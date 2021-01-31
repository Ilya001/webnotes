local notes ={}

function notes:get_notes(token)
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        return box.space.user.index.token:select{token}[1][4]
    else
        return false
    end
end

function notes:create_note(token)
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        local this_notes = box.space.user.index.token:select{token}[1][4]
        table.insert(this_notes, "<div>Новая заметка</div>")
        box.space.user.index.token:update({token}, {{'=', 'notes', this_notes}})
        return true
    else 
        return false
    end
end

function notes:delete_note(token, note_id)
    note_id = note_id + 1
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        local this_notes = box.space.user.index.token:select{token}[1][4]
        for key, _ in pairs(this_notes) do
            if note_id == key then
                table.remove(this_notes, note_id)
            end
        end
        box.space.user.index.token:update({token}, {{'=', 'notes', this_notes}})
        return true
    else
        return false
    end
end

function notes:update_note(token, note_id, text)
    note_id = note_id + 1
    if (box.space.user.index.token:select{token}[1] ~= nil) and (box.space.user.index.token:select{token}[1][5] == token) then
        local this_notes = box.space.user.index.token:select{token}[1][4]
        for key, _ in pairs(this_notes) do
            if note_id == key then
                this_notes[key] = text
            end
        end
        box.space.user.index.token:update({token}, {{'=', 'notes', this_notes}})
        return true
    else
        return false
    end
end


return notes