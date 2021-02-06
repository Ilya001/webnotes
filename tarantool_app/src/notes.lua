local notes ={}

function notes:get_notes(token, id)
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        if id ~= nil then
            return box.space.user.index.token:select{token}[1][4][id]
        else
            return box.space.user.index.token:select{token}[1][4]
        end
    else
        return false
    end
end

function notes:create_note(token)
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        local this_notes = box.space.user.index.token:select{token}[1][4]
        local lastkey = 0
        for key, _ in pairs(this_notes) do
            lastkey = key
        end
        table.insert(this_notes, {id = lastkey+1, name="Новая заметка", text="<h1>Новая заметка</h1>"})
        box.space.user.index.token:update({token}, {{'=', 'notes', this_notes}})
        return true
    else 
        return false
    end
end

function notes:delete_note(token, note_id)
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        local this_notes = box.space.user.index.token:select{token}[1][4]
        for key, _ in pairs(this_notes) do
            if note_id == key then
                table.remove(this_notes, note_id)
            end
        end
        for key, value in pairs(this_notes) do
            this_notes[key]['id'] = key
        end
        box.space.user.index.token:update({token}, {{'=', 'notes', this_notes}})
        return true
    else
        return false
    end
end

function notes:update_note(token, note_id, name, text)
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        local this_notes = box.space.user.index.token:select{token}[1][4]
        for key, _ in pairs(this_notes) do
            if note_id == key then
                this_notes[key]['name'] = name
                this_notes[key]['text'] = text
            end
        end
        box.space.user.index.token:update({token}, {{'=', 'notes', this_notes}})
        return true
    else
        return false
    end
end


return notes