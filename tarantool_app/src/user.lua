local user = {}
local sha256 = require('tarantool_app.src.sha256')

function user:start()
    box.once('init', function()
        box.schema.space.create('user', {if_not_exists=true})
        box.space.user:format({
            {name='id', type='number'},
            {name='username', type='string'},
            {name='password', type='string'},
            {name='notes', type='array'},
            {name='token', type='string'}
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
        box.space.user:create_index('token', {
            type='hash',
            parts={'token'},
            if_not_exists=true
        })
    end)
end

function user:check_username(username)
    local uniq = box.space.user.index.username:select{username}
    
    if uniq[1] == nil then
        return true
    else 
        return false
    end
end

function user:create_user(username, password)
    local uniq = self:check_username(username)

    if uniq == true then
        box.space.user:auto_increment({username, password, {{id = 1, name='New Note', text = '<div>Новая заметка</div>'}}, sha256:hexFromBin(username..os.time())})
        return 200, "User registered "
    else 
        return 400, "User is already registered"
    end
end

function user:login(username, password)
    if self:check_username(username) == false then
        local this_user = box.space.user.index.username:select{username}
        if this_user[1][3] == password then
            local token = sha256:hexFromBin(username..os.time())
            box.space.user.index.username:update({username}, {{'=', 'token', token}})
            return token
        end
        return false
    else
        return false
    end
end

function user:logout(token)
    if box.space.user.index.token:select{token}[1] ~= nil then
        box.space.user.index.token:update({token}, {{'=', 'token', sha256:hexFromBin(token..os.time())}})
        return true
    else
        return false
    end
end


return user