--require('ide-debug')
local http_server_lib = require('http.server')
local net_box = require('net.box')
local z = require('zlib')

local storage = net_box.connect('localhost:3301')
storage:wait_connected(3)
if not storage:is_connected() then
    error('Нет соединения со стораджем')
end

local function unzip(value)
    return z.inflate()(value, 'finish')
end

local function doc_post(uid, body)
    storage:call('doc_post', {uid, body, false})
    return 'ok'
end

local function doc_get(uid)
    local body, zipped_flag = storage:call('doc_get', {uid})
    return zipped_flag and unzip(body) or body
end

local function stat()
    return storage:call('stat')
end

local function no_cache(response)
    response.headers['Cache-Control'] = 'no-cache, must-revalidate';
    response.headers['Pragma'] = 'no-cache';
    return response
end

local function api_call(request, call_func)
    local uid = request:query_param('uid')
    local response = {}
    local ok, result = pcall(call_func, uid, request:read())
    if ok then
        if result == nil then
            response = request:render{ text = '' }
            response.status = 404
        else
            local opt = type(result) == 'string' and { text = result } or { json = result }
            response = request:render(opt)
            response.status = 200
        end
    else
        local errcode = '?'
        if type(result) == 'table' and result.code ~= nil then
            errcode = result.code
        end
        local errJson = {
            code = 'app-'..errcode,
            text = ''..result
        }

        response = request:render{ json = errJson }
        response.status = 500
        print(errJson.text)
    end
    return no_cache(response)
end

local function api_post(request)
    return api_call(request, doc_post)
end

local function api_get(request)
    return api_call(request, doc_get)
end

local function api_stat(request)
    return api_call(request, stat)
end

local server = http_server_lib.new(nil, 8888)
server:route({ path = '/api/doc_post', method = 'POST' }, api_post)
server:route({ path = '/api/doc_get' }, api_get)
server:route({ path = '/api/stat' }, api_stat)
server:start()
