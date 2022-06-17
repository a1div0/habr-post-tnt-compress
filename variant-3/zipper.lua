require('ide-debug')
local net_box = require('net.box')
local fiber = require('fiber')
local z = require('zlib')

local sleep_in_second = 15


local function zip(value)
    return z.deflate()(value, 'finish')
end

local storage = net_box.connect('localhost:3301')
storage:wait_connected(3)
if not storage:is_connected() then
    error('Нет соединения со стораджем')
end

print('Zipper started...')

while true do
    local record = storage:call('doc_get_unzipped', {})
    if record == nil then
        fiber.sleep(sleep_in_second)
    else
        local zipped_body = zip(record.zipped_body)
        storage:call('doc_post', {record.uid, zipped_body, true})
        print(record.uid..' - packed')
    end
end