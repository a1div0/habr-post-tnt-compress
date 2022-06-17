--require('ide-debug')
local fio = require('fio')

local function dbInit()
    --box.schema.user.create('admin', {password = '123'})
    box.schema.user.grant('guest', 'read,write,execute,create,alter,drop', 'universe', nil, {if_not_exists=true})

    local space = box.schema.space.create('DOCS', { if_not_exists = true })
    space:format{
        {name = 'uid', type = 'string', isKey = 1},
        {name = 'zipped_body', type = 'string', is_nullable = true },
        {name = 'zipped', type = 'boolean' },
    }
    space:create_index('primary', {
        parts = {'uid'},
        type = 'tree',
        unique = true,
        if_not_exists = true,
    })

    space:create_index('zipped_idx', {
        parts = {'zipped'},
        type = 'tree',
        unique = false,
        if_not_exists = true,
    })
end

function doc_post(uid, body, zipped)
    local update_data = {
        {'=', 2, body},
        {'=', 3, zipped},
    }
    box.space.DOCS:upsert({uid, body, zipped}, update_data)
end

function doc_get(uid)
    local tuple = box.space.DOCS:get{uid}
    if tuple ~= nil then
        return tuple.zipped_body, tuple.zipped
    end
end

function doc_get_unzipped()
    local list = box.space.DOCS.index.zipped_idx:select(false, { limit = 1 })
    if #list > 0 then
        return list[1]:tomap{names_only = true}
    end
end

function stat()
    return {
        table_size = tonumber(box.space.DOCS:bsize()),
        count = box.space.DOCS:count(),
    }
end

local MByte = 1024 * 1024
local data_dir = 'tmp'

fio.rmtree(data_dir)
fio.mktree(data_dir)

box.cfg{
    memtx_memory = 2048 * MByte,
    wal_dir = data_dir,
    memtx_dir = data_dir,
    listen = 3301,
    memtx_max_tuple_size = 200 * MByte,
    readahead = 400 * MByte,
}

box.once("init_v1", dbInit)