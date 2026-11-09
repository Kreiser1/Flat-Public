local assets = {}

local folder = 'Assets'

local loaders = {
	wav  = flat.sound.load,
	png  = flat.image.load,
	jpg  = flat.image.load,
	jpeg = flat.image.load,
	bmp  = flat.image.load,
}

local function key_of(file)
	local name = string.match(file, '([^/\\]+)$') or file
	name = string.match(name, '^(.+)%..+$') or name
	return string.lower(name)
end

local function extension_of(file)
	return string.lower(string.match(file, '%.([^.]+)$') or '')
end

print '[Flat.Assets] loading assets...'

local list = flat.explorer.list(folder .. '/*.*')
table.sort(list)

local loaded, skipped, collisions = 0, 0, 0

for _, file in ipairs(list) do
	local key = key_of(file)
	local extension = extension_of(file)
	local file_path = folder .. '/' .. file

	local loader = loaders[extension]

	if not loader then
		print('[Flat.Assets] skipped (unknown extension): ' .. string.format('%q', file_path))
		skipped = skipped + 1
	else
		print('[Flat.Assets] ' .. string.format('%q', key) .. ': ' .. string.format('%q', file_path))

		if assets[key] ~= nil then
			print('[Flat.Assets] warning: duplicate key ' .. string.format('%q', key) ..
				' (' .. string.format('%q', file_path) .. ' overwrites previous)')
			collisions = collisions + 1
		end

		local asset = loader(file_path)

		if asset == nil then
			error('[Flat.Assets] failed to load ' .. string.format('%q', file_path) .. ': ' .. tostring(asset))
		end

		assets[key] = asset
		loaded = loaded + 1
	end
end

print(string.format(
	'[Flat.Assets] finished loading assets: %d loaded, %d skipped, %d collision(s).',
	loaded, skipped, collisions
))

return assets
