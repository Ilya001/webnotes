box.cfg{
    listen = 3312;
}
box.once('grant', function()
    box.schema.user.grant('guest', 'read,write,execute', 'universe')
end)

local user = require('tarantool_app.src.user')
local notes = require('tarantool_app.src.notes')

user:start()

-- Create user /api/auth/registration
function create_user(username, password)
    local status, data = user:create_user(username, password)
    return status, data
end

-- Login /api/auth/login
function login(username, password)
    return user:login(username, password)
end

-- Logout /api/auth/logout
function logout(token)
    return user:logout(token)
end

-- Get all notes /api/notes/get_notes
function get_notes(token)
    return notes:get_notes(token)
end

-- Create new note /api/notes/create_note
function create_note(token)
    return notes:create_note(token)
end

-- Delete note /api/notes/delete_note
function delete_note(token, note_id)
    return notes:delete_note(token, note_id)
end

-- Update note /api/notes/update_note
function update_note(token, note_id, text)
    return notes:update_note(token, note_id, text)
end
