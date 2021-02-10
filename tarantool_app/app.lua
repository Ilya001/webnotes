box.cfg{
    listen = 3312; 
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

function create_user(username, password)
    return user:create_user('username', 'password')
end

function login(username, password)
    local status, key = user:login(username, password)
    if status ~= nil and key ~= nil then
        return status, key
    else
        return 'Логин или пароль введен не верно'
    end
end

function logout(token)
    return user:logout(token)
end

function get_notes(token, key)
    local note_id = session:check_user(token, key)
    if note_id ~= nil then 
        return notes:get_notes(note_id)
    else
        return "Bad data"
    end
end

function add_note(token, key)
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
