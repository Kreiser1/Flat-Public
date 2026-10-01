local scenes = {
	_vault = {},
	current = {}
}

local path = 'Scenes'

print '[Flat.Scenes] loading scenes...'

for _, file in pairs(flat.explorer.list(path .. '/*.lua')) do
	local key = string.lower(string.gsub(string.match(file, "^(.+)%..+$") or file, "%.", "_"))
	local extension = string.lower(string.match(file, "%.([^.]+)$"))
	local path = path .. '/' .. file
	local module_path = string.gsub(string.gsub(path, "%.lua$", ""), "[/\\]", ".")

	if extension == 'lua' then
		print('[Flat.Scenes] ' .. string.format('%q', key) .. ': ' .. string.format('%q', path))

		local scene = require(module_path)

		if not type(scene) == 'function' then
			error('[Flat.Scenes] scene ' .. string.format('%q', key) .. ' is not a factory.')
		end

		scenes._vault[key] = scene
	end
end

print '[Flat.Scenes] finished loading scenes.'

local function install_hook(event_name)
	flat.dispatcher.hook(flat.dispatcher[event_name], function(...)
		for _, entity in ipairs(scenes.current) do
			local hook = entity[event_name]

			if hook then
				hook(entity, ...)
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

function scenes.load(entity)
	for _, entity2 in ipairs(scenes.current) do
		if entity == entity2 then
			error '[Flat.Scenes] object re-loading.'
		end
	end

	table.insert(scenes.current, entity)

	local load = entity.load

	if load then
		load(entity)
	end
end

function scenes.unload(entity)
	local unload = entity.unload

	for i = #scenes.current, 1, -1 do
		if scenes.current[i] == entity then
			if unload then
				unload(entity)
			end

			table.remove(scenes.current, i)

			break
		end
	end
end

function scenes.set(scene_name)
	local scene = scenes._vault[scene_name]

	if not scene then
		error('[Flat.Scenes] scene ' .. string.format('%q', scene_name) .. ' not found.')
	end

	if not type(scene) == 'function' then
		error('[Flat.Scenes] scene ' .. string.format('%q', scene_name) .. ' is not a factory.')
	end

	while #scenes.current > 0 do
		scenes.unload(scenes.current[#scenes.current])
	end

	scenes.current = {}

	local entities = scene(scenes)

	for i = 1, #entities do
		local object = entities[i]

		if object then
			scenes.load(object)
		end
	end
end

return scenes
