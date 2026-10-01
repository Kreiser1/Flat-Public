local assets = {}

local path = 'Assets'

local loaders = {
	wav = flat.sound.load,
	png = flat.image.load,
	jpg = flat.image.load,
	jpeg = flat.image.load,
	bmp = flat.image.load
}

print '[Flat.Assets] loading assets...'

for _, file in pairs(flat.explorer.list(path .. '/*.*')) do
	local key = string.lower(string.match(file, "^(.+)%..+$") or file)
	local extension = string.lower(string.match(file, "%.([^.]+)$"))
	local path = path .. '/' .. file

	local loader = loaders[extension]

	if loader then
		print('[Flat.Assets] ' .. string.format('%q', key) .. ': ' .. string.format('%q', path))
		assets[key] = loaders[extension](path)
	end
end

print '[Flat.Assets] finished loading assets.'

return assets
