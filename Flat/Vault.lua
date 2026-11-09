local vault = {}

function vault.serialize_table(t)
    if type(t) ~= 'table' then
        error '[Flat.Vault] value to serialize is not a table.'
    end

    local seen = {}

    local function serialize_value(value)
        local value_type = type(value)

        if value_type == 'number' or value_type == 'boolean' then
            return tostring(value)
        elseif value_type == 'string' then
            return string.format('%q', value)
        elseif value_type == 'table' then
            if seen[value] then
                error '[Flat.Vault] self-reference detected in table being serialized.'
            end

            seen[value] = true

            local is_list = true
            local length = 0

            for key in pairs(value) do
                if type(key) ~= 'number' or key ~= math.floor(key) or key < 1 then
                    is_list = false
                    break
                end

                if key > length then
                    length = key
                end
            end

            if is_list then
                for i = 1, length do
                    if value[i] == nil then
                        is_list = false
                        break
                    end
                end
            end

            local tmp = {}

            if is_list then
                for i = 1, length do
                    tmp[#tmp + 1] = serialize_value(value[i])
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

                    tmp[#tmp + 1] = serialization_key .. '=' .. serialize_value(value_value)

                    ::continue::
                end
            end

            seen[value] = nil

            return '{' .. table.concat(tmp, ',') .. '}'
        else
            return 'nil'
        end
    end

    return serialize_value(t)
end

function vault.deserialize_table(text)
    if type(text) ~= 'string' or not string.match(text, '^%{.*%}$') then
        error '[Flat.Vault] invalid table being deserialized.'
    end

    local ok, result = pcall(function()
        return load('return ' .. text, '[Flat.Vault] Deserialization')
    end)

    if not ok then
        error '[Flat.Vault] Failed to deserialize table.'
    end

    if type(result) ~= 'table' then
        error '[Flat.Vault] deserialized value is not a table.'
    end

    return result
end

local _cache

do
    local text = flat.storage.load()

    if type(text) ~= 'string' or not string.match(text, '^%{.*%}$') then
        text = '{}'
    end

    _cache = vault.deserialize_table(text)
end

function vault.load(key)
    return _cache[key]
end

function vault.has(key)
    return _cache[key] ~= nil
end

function vault.save(key, value)
    if value == nil then
        error('[Flat.Vault] cannot save nil value for key ' .. string.format('%q', tostring(key)))
    end

    if _cache[key] ~= value then
        _cache[key] = value
        flat.storage.save(vault.serialize_table(_cache))
    end
end

function vault.load_or(key, value)
    local loaded = _cache[key]

    if loaded ~= nil then
        return loaded
    end

    if value == nil then
        error('[Flat.Vault] cannot use nil as default for key ' .. string.format('%q', tostring(key)))
    end

    _cache[key] = value

    return value
end

function vault.remove(key)
    if _cache[key] ~= nil then
        _cache[key] = nil
        flat.storage.save(vault.serialize_table(_cache))
    end
end

function vault.drop()
    _cache = {}
    flat.storage.save(vault.serialize_table(_cache))
end

return vault
