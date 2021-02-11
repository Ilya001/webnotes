local notes = {}

function notes:start()
    box.once('init_note', function()
        box.schema.space.create('notes', {if_not_exists=true})
        box.space.notes:format({
            {name = 'id', type = 'number'},
            {name = 'notes', type='array'}
        })
        box.space.notes:create_index('primary', {
            type='TREE',
            unique=true,
            parts={'id'},
            if_not_exists=true
        })
    end)
end

function notes:get_notes(notes_id, this_note_id)
    local note = box.space.notes:select{notes_id}
    if note ~= nil then
        if this_note_id ~= nil then
            for key, _ in pairs(note[1][2]) do
                if this_note_id == note[1][2][key]['id'] then
                    return note[1][2][key]    
                end
            end
        else
            return note
        end
    else
        return nil
    end
end

function notes:create_note_obj()
    local this_note = box.space.notes:auto_increment{{{id = 1, name = 'Новая заметка', html = '<div>Новая заметка</div>'}}}
    return this_note[1]
end

function notes:create_note(notes_id)
    local note = box.space.notes:select{notes_id}
    if note ~= nil then
        local this_note_list = note[1][2]
        local lastkey = 0
        for key, _ in pairs(this_note_list) do
            lastkey = key
        end
        table.insert(this_note_list, {id = lastkey+1, name="Новая заметка", html="<p>Новая заметка</p>"})
        return box.space.notes:update({notes_id}, {{'=', 'notes', this_note_list}}) 
    else 
        return nil
    end
end

function notes:delete_note(notes_id, delete_note_id)
    local note = box.space.notes:select{notes_id}
    if note ~= nil then
        local this_note_list = note[1][2]
        for key, _ in pairs(this_note_list) do
            if delete_note_id == key then
                table.remove(this_note_list, delete_note_id)
            end
        end
        for key, _ in pairs(this_note_list) do
            this_note_list[key]['id'] = key
        end
        box.space.notes:update({notes_id}, {{'=', 'notes', this_note_list}}) 
        return true
    else
        return nil
    end
end

function notes:update_note(notes_id, update_note_id, name, html)
    local note = box.space.notes:select{notes_id}
    if note ~= nil then
        local this_note_list = note[1][2]
        for key, _ in pairs(this_note_list) do
            if update_note_id == key then
                this_note_list[key]['name'] = name
                this_note_list[key]['html'] = html
            end
        end
        box.space.notes:update({notes_id}, {{'=', 'notes', this_note_list}})
        return true
    else
        return nil
    end
end

return notes
