local registry = {}

local _levels = {}
local _entities = {}

local folder = 'Levels'

print '[Flat.Registry] loading scenes...'

local list = flat.explorer.list(folder .. '/*.lua')
table.sort(list)

for _, file in ipairs(list) do
    local name = string.match(file, '([^/\\]+)$') or file
    local key = string.lower(string.gsub(name, '%.lua$', ''))
    local file_path = folder .. '/' .. file
    local module_path = string.gsub(string.gsub(file_path, '%.lua$', ''), '[/\\]', '.')

    print('[Flat.Registry] ' .. string.format('%q', key) .. ': ' .. string.format('%q', file_path))

    local ok, factory = pcall(require, module_path)

    if not ok then
        error('[Flat.Registry] failed to load scene ' .. string.format('%q', key) .. ': ' .. tostring(factory))
    end

    if type(factory) ~= 'function' then
        error('[Flat.Registry] scene ' .. string.format('%q', key) .. ' is not a factory.')
    end

    _levels[key] = factory
end

print '[Flat.Registry] finished loading scenes.'

local function shallow_copy(t)
    local out = {}

    for i = 1, #t do
        out[i] = t[i]
    end

    return out
end

local function index_of(entity)
    for i = 1, #_entities do
        if _entities[i] == entity then
            return i
        end
    end

    return nil
end

local function remove_at(index)
    local entity = _entities[index]

    if entity.unload then
        local ok, err = pcall(entity.unload, entity)
        if not ok then
            print('[Flat.Registry] unload error: ' .. tostring(err))
        end
    end

    table.remove(_entities, index)
end

function registry.current()
    return shallow_copy(_entities)
end

function registry.count()
    return #_entities
end

function registry.has_entity(entity)
    return index_of(entity) ~= nil
end

function registry.has_scene(name)
    return _levels[name] ~= nil
end

function registry.load(entity)
    if entity == nil then
        error '[Flat.Registry] cannot load nil entity.'
    end

    if type(entity) ~= 'table' then
        error '[Flat.Registry] cannot load non-table entity.'
    end

    if index_of(entity) ~= nil then
        error '[Flat.Registry] entity re-loading.'
    end

    _entities[#_entities + 1] = entity

    if entity.load then
        local ok, error = pcall(entity.load, entity)

        if not ok then
            table.remove(_entities)
            error('[Flat.Registry] entity loading failed: ' .. tostring(error))
        end
    end
end

function registry.unload(entity)
    if entity == nil then
        return
    end

    local index = index_of(entity)

    if index ~= nil then
        remove_at(index)
    end
end

function registry.unload_if(predicate)
    local snapshot = shallow_copy(_entities)

    for i = 1, #snapshot do
        local entity = snapshot[i]

        if predicate(entity) then
            local index = index_of(entity)

            if index ~= nil then
                remove_at(index)
            end
        end
    end
end

function registry.for_each(fn)
    local snapshot = shallow_copy(_entities)

    for i = 1, #snapshot do
        fn(snapshot[i])
    end
end

function registry.find(predicate)
    local snapshot = shallow_copy(_entities)

    for i = 1, #snapshot do
        local entity = snapshot[i]

        if predicate(entity) then
            return entity
        end
    end

    return nil
end

function registry.find_all(predicate)
    local snapshot = shallow_copy(_entities)
    local out = {}

    for i = 1, #snapshot do
        local entity = snapshot[i]

        if predicate(entity) then
            out[#out + 1] = entity
        end
    end

    return out
end

function registry.load_level(name, ...)
    local factory = _levels[name]

    if type(factory) ~= 'function' then
        error('[Flat.Registry] scene ' .. string.format('%q', tostring(name)) .. ' not found.')
    end

    while #_entities > 0 do
        remove_at(#_entities)
    end

    local ok, result = pcall(factory, registry, ...)

    if not ok then
        error('[Flat.Registry] scene ' .. string.format('%q', tostring(name)) .. ' failed: ' .. tostring(result))
    end

    if type(result) ~= 'table' then
        error('[Flat.Registry] scene ' .. string.format('%q', tostring(name)) .. ' did not return a table.')
    end

    local loaded = {}

    for i = 1, #result do
        local entity = result[i]

        if entity ~= nil then
            if type(entity) ~= 'table' then
                for j = #loaded, 1, -1 do
                    local e = loaded[j]
                    if e.unload then
                        pcall(e.unload, e)
                    end
                end

                error('[Flat.Registry] entity #' ..
                    i .. ' in scene ' .. string.format('%q', tostring(name)) .. ' is not a table.')
            end

            _entities[#_entities + 1] = entity

            if entity.load then
                local loading_ok, err = pcall(entity.load, entity)

                if not loading_ok then
                    for j = #loaded, 1, -1 do
                        local e = loaded[j]

                        if e.unload then
                            pcall(e.unload, e)
                        end

                        table.remove(_entities)
                    end

                    error('[Flat.Registry] entity #' .. i .. ' loading failed: ' .. tostring(err))
                end
            end

            loaded[#loaded + 1] = entity
        end
    end
end

local function install_hook(event_name)
    flat.dispatcher.hook(flat.dispatcher[event_name], function(...)
        local snapshot = shallow_copy(_entities)

        for i = 1, #snapshot do
            local entity = snapshot[i]

            if index_of(entity) ~= nil then
                local hook = entity[event_name]

                if hook then
                    local ok, error = pcall(hook, entity, ...)

                    if not ok then
                        print('[Flat.Registry] ' .. event_name .. ' event error: ' .. tostring(error))
                    end
                end
            end
        end
    end)
end

install_hook 'update'
install_hook 'render'
install_hook 'keyboard'
install_hook 'mouse'
install_hook 'phase'
install_hook 'collision'
install_hook 'network'

return registry
