-- Copy table values individually instead of copying a reference to a table
function table.new(orig)
    local orig_type = type(orig)

    local copy

    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.new(orig_key)] = table.new(orig_value)
        end
    else
        copy = orig
    end
    return copy
end
