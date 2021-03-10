local session = {}
local sha256 = require('tarantool_app.src.sha256')

function session:start()
    box.once('init_session', function()
        box.schema.space.create('session', {if_not_exists=true})
        box.space.session:format({
            {name = 'id', type = 'number'},
            {name = 'token', type = 'string'},
            {name = 'key', type = 'string'}
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

function session:create(uuid)
    local token = sha256:hexFromBin(uuid..os.time())
    box.space.session:auto_increment{token, uuid}
    return token
end

function session:delete(token)
    if token ~= nil then
        local status = box.space.session.index.token:delete(token)
        if status == nil then
            return false
        else
            return true
        end
    else 
        return false
    end
end

function session:check_token(token)
    if token ~= nil then
        local status = box.space.session.index.token:select{token}
        if status[1] == nil then
            return false
        else
            return true
        end
    else 
        return false
    end
end

function session:check_user(token, key)
    if token ~= nil then
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
    else
        return nil
    end
end

return session