local vault = {
    _vault = nil
}

function vault.serialize(value)
    local seen = {}

    local function _serialize(value)
        local value_type = type(value)

        if value_type == 'number' or value_type == 'boolean' then
            return tostring(value)
        elseif value_type == 'string' then
            return string.format('%q', value)
        elseif value_type == 'table' then
            if seen[value] then
                error '[Flat.State] self-reference detected in object being serialized.'
            end

            seen[value] = true

            local tmp = {}

            local is_list = true
            local length = 0

            for _ in pairs(value) do length = length + 1 end

            for i = 1, length do
                if value[i] == nil then
                    is_list = false
                    break
                end
            end

            if is_list then
                for i = 1, length do
                    table.insert(tmp, _serialize(value[i]))
                end
            else
                for key, value_value in pairs(value) do
                    local serialization_key

                    if type(key) == 'string' then
                        serialization_key = string.format('[%q]', key)
                    elseif type(key) == 'number' or type(key) == 'boolean' then
                        serialization_key = string.format('[%s]', tostring(key))
                    else
                        goto continue
                    end

                    table.insert(tmp, serialization_key .. '=' .. _serialize(value_value))

                    ::continue::
                end
            end

            seen[value] = nil

            return '{' .. table.concat(tmp, ',') .. '}'
        else
            return 'nil'
        end
    end

    return _serialize(value)
end

function vault.deserialize(text)
    if type(text) ~= 'string' or not string.match(text, '^%{.*%}$') then
        error '[Flat.State] invalid object being deserialized.'
    end

    return load('return ' .. text, '[Deserialization]')
end

function vault.load(key)
    return vault._vault[key]
end

function vault.save(key, value)
    if vault._vault[key] ~= value then
        vault._vault[key] = value
        flat.storage.save(vault.serialize(vault._vault))
    end
end

function vault.load_or(key, value)
    local loaded = vault._vault[key]

    if loaded ~= nil then
        return loaded
    end

    vault._vault[key] = value
    flat.storage.save(vault.serialize(vault._vault))

    return value
end

function vault.drop()
    vault._vault = {}
    flat.storage.save(vault.serialize(vault._vault))
end

local text = flat.storage.load()

if not string.match(text, '^%{.*%}$') then
    text = '{}'
end

vault._vault = vault.deserialize(text)

return vault
