local session = {}
local sha256 = require('tarantool_app.src.sha256')

function session:start()
    box.once('init_session', function()
        box.schema.space.create('session', {if_not_exists=true})
        box.space.session:format({
            {name = 'id', type = 'number'},
            {name = 'token', type = 'string'},
            {name = 'key', type = 'uuid'}
        })
        box.space.session:create_index('primary', {
            type='TREE',
            unique=true,
            parts={'id'},
            if_not_exists=true
        })
        box.space.session:create_index('token', {
            type='TREE',
            unique=true,
            parts={'token'},
            if_not_exists=true
        })
    end)
end

function session:create(uuid, username)
    local token = sha256:hexFromBin(username..os.time())
    box.space.session:auto_increment{token, uuid}
    return token
end

function session:delete(token)
    local status = box.space.session.index.token:delete(token)
    if status == nil then
        return false
    else
        return status
    end
end

function session:check_token(token)
    local status = box.space.session.index.token:select{token}
    if status == nil then
        return false
    else
        return true
    end
end

function session:check_user(token, key)
    local session = box.space.session.index.token:select{token}
    if session ~= nil then
        if session[1][3] == key then
            local user = box.space.user.index.key:select{key}
            if user ~= nil then
                return user[1][5]
            else
                return nil
            end
        else
            return nil
        end
    else
        return nil
    end
end

return session