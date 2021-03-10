box.cfg{
    listen = "127.0.0.1:3312"
    background = true,
    log = '1.log',
    pid_file = '1.pid'
}

box.once('grant', function()
    box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

local session = require('tarantool_app.src.session')
local notes = require('tarantool_app.src.notes')
local user = require('tarantool_app.src.user')

session:start()
notes:start()
user:start()

function check_username(username)
    return user:check_username(username)
end

function check_session(token)
    return session:check_token(token)
end

function create_user(username, password)
    local user = user:create_user(username, password) 
    if user ~= nil then
        return true
    else
        return false
    end
end

function login(username, password)
    local status, key = user:login(username, password)
    if status ~= nil and key ~= nil then
        return status, key
    else
        return false
    end
end

function logout(token)
    return user:logout(token)
end

function get_notes(token, key, this_note_id)
    local note_id = session:check_user(token, key)
    if note_id ~= nil then 
        return notes:get_notes(note_id, this_note_id)
    else
        return "Bad data"
    end
end

function create_note(token, key)
    local note_id = session:check_user(token, key)
    if note_id ~= nil then 
        return notes:create_note(note_id)
    else
        return "Bad data"
    end
end

function delete_note(token, key, delete_note_id)
    local note_id = session:check_user(token, key)
    if note_id ~= nil then 
        return notes:delete_note(note_id, delete_note_id)
    else
        return "Bad data"
    end
end

function update_note(token, key, update_note_id, name, html)
    local note_id = session:check_user(token, key)
    if note_id ~= nil then 
        return notes:update_note(note_id, update_note_id, name, html)
    else
        return "Bad data"
    end
end
