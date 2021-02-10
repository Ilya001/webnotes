local user = {}

local sha256 = require('tarantool_app.src.sha256')
local uuid = require('uuid')
local notes = require('tarantool_app.src.notes')
local session = require('tarantool_app.src.session')

function user:check_username(username)
    local uniq = box.space.user.index.username:select{username} 
    if uniq[1] == nil then
        return true
    else 
        return false
    end
end

function user:start()
    box.once('init_user', function()
        box.schema.space.create('user', {if_not_exists=true})
        box.space.user:format({
            {name = 'id', type = 'number'},
            {name = 'username', type = 'string'},
            {name = 'password', type = 'string'},
            {name = 'key', type = 'uuid'},
            {name = 'notesId', type = 'number'}
        })
        box.space.user:create_index('primary', {
            type='TREE',
            unique=true,
            parts={'id'},
            if_not_exists=true
        })
        box.space.user:create_index('username', {
            type='hash',
            parts={'username'},
            if_not_exists=true
        })
        box.space.user:create_index('key', {
            type='hash', 
            parts={'key'},
            if_not_exists=true
        })
    end)
end

function user:create_user(username, password)
    local uniq_user = self:check_username(username)   
    if uniq_user then
        local notesId = notes:create_note_obj()
        local password = sha256:hexFromBin(password) 
        return box.space.user:auto_increment{username, password, uuid.new(), notesId}
    else
        return nil
    end
end

function user:login(username, password)
    local this_user = box.space.user.index.username:select{username}
    if this_user ~= nil then
        if this_user[1][3] == sha256:hexFromBin(password) then
            return session:create(this_user[1][4], username), this_user[1][4]
        else 
            return nil, nil
        end
    else
        return nil, nil
    end
end

function user:logout(token)
    return session:delete(token)
end

return user