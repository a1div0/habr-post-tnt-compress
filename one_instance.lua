local fio = require('fio')
local json = require('json')
local clock = require('clock')
local doc_helper = require('test.doc_helper') -- модуль для доступа к данным, чтобы попробовать, надо подсунуть свой
local z = require('zlib') -- внешняя библиотека, её надо отдельно установить
--require('ide-debug') -- это можно взять тут: https://github.com/a1div0/ide-debug

local docs_qty = 100000
local docs_list = {}
local MByte = 1024 * 1024


local function zip(value)
    return z.deflate()(value, 'finish')
end

local function unzip(value)
    return z.inflate()(value, 'finish')
end

local function dummy(value)
    return value;
end

local function create_table(method_name, format)
    local space = box.schema.space.create(method_name, { if_not_exists = true })
    space:format(format)
    space:create_index('primary', {
        parts = {'uid'},
        type = 'tree',
        unique = true,
        if_not_exists = true,
    })
end

local function dbInit()
    create_table('ZLIB', {
        {name = 'uid', type = 'string', isKey = 1},
        {name = 'zipped_body', type = 'string', is_nullable = true},
    })

    create_table('TNT_ZSTD', {
        {name = 'uid', type = 'string', isKey = 1},
        {name = 'zipped_body', type = 'string', is_nullable = true, compression = 'zstd'},
    })

    create_table('TNT_LZ4', {
        {name = 'uid', type = 'string', isKey = 1},
        {name = 'zipped_body', type = 'string', is_nullable = true, compression = 'lz4'},
    })
end

local function perfomance_method(method_name, unzip_size, pack, unpack)
    local table_name = method_name
    local space = box.space[table_name]
    local start = clock.monotonic()

    for uid, doc in pairs(docs_list) do
        space:insert{uid, pack(doc)}
    end

    local duration_zip_write = clock.monotonic() - start

    start = clock.monotonic()

    for uid, doc in pairs(docs_list) do
        local tuple = space:get{uid}
        local res = unpack(tuple.zipped_body)
        local res_size = #res
        local doc_size = #doc
        if (doc_size ~= res_size) then
            error('Несовпадение размера!')
        end
    end

    local duration_read_unzip = clock.monotonic() - start
    local template = [[

Method = %s
Duration pack and write = %.3f sec
Duration read and unpack = %.3f sec
Unpack data size = %.3f MBytes
Space size with packed data = %.3f MBytes
Compression ratio = %.3f (%.2f %%)

]]
    local table_size = tonumber(space:bsize()) -- uint64_t
    print(template:format(
            method_name,
            duration_zip_write,
            duration_read_unzip,
            unzip_size / MByte,
            table_size / MByte,
            unzip_size / table_size,
            100 - (100 * table_size / unzip_size)
    ))
end


print('Box cfg...')
local root = fio.dirname(fio.abspath(package.search('ufm.init')))
local data_dir = fio.pathjoin(root, 'tmp', 'db_test')

fio.rmtree(data_dir)
fio.mktree(data_dir)

box.cfg{
    memtx_memory = 2048 * MByte,
    wal_dir = data_dir,
    memtx_dir = data_dir,
    listen = 9998,
    memtx_max_tuple_size = 200 * MByte,
}

box.once("init_v1", dbInit)

print('Generate docs list...')

local unzip_size = 0
for doc_num = 1, docs_qty do
    local uid = ('doc_%08x'):format(doc_num)
    local doc = doc_helper.get_doc(uid)
    local data = json.encode(doc)
    docs_list[uid] = data
    unzip_size = unzip_size + #data
end

print('Start competition')

perfomance_method('ZLIB', unzip_size, zip, unzip)
perfomance_method('TNT_ZSTD', unzip_size, dummy, dummy)
perfomance_method('TNT_LZ4', unzip_size, dummy, dummy)

os.exit()