-- Do not include

---@meta

---@class flat
---@field math flat.math
---@field console flat.console
---@field error flat.error
---@field explorer flat.explorer
---@field storage flat.storage
---@field script flat.script
---@field date flat.date
---@field stopwatch flat.stopwatch
---@field timer flat.timer
---@field label flat.label
---@field sound flat.sound
---@field image flat.image
---@field tile flat.tile
---@field dispatcher flat.dispatcher
---@field network flat.network
---@field eula flat.eula
---@field dialog flat.dialog
---@field scene flat.scene
---@field input flat.input
---@field vector flat.vector
---@field shape flat.shape
flat = {}

---@class flat.math
---@field epsilon number
---@field max number
---@field min number
---@field infinity number
---@field nan number
---@field pi number
---@field rad2deg number
---@field deg2rad number
flat.math = {}

---@param value number
---@return number
function flat.math.absolute(value) end

---@param value number
---@return number
function flat.math.square_root(value) end

---@param a number
---@param b number
---@return number
function flat.math.average(a, b) end

---@param value number
---@param min number
---@param max number
---@return number
function flat.math.clamp(value, min, max) end

---@param a number
---@param b number
---@return number
function flat.math.maximum(a, b) end

---@param a number
---@param b number
---@return number
function flat.math.minimum(a, b) end

---@param value number
---@param limit number
---@return number
function flat.math.normalize(value, limit) end

---@param value number
---@return integer
function flat.math.floor(value) end

---@param value number
---@return integer
function flat.math.ceil(value) end

---@param value number
---@return integer
function flat.math.round(value) end

---@param min number
---@param max number
---@return number
function flat.math.random(min, max) end

---@param x number
---@param y number
---@return number
function flat.math.length(x, y) end

---@param x number
---@param y number
---@return number
function flat.math.angle(x, y) end

---@param value number
---@return number
function flat.math.sine(value) end

---@param value number
---@return number
function flat.math.cosine(value) end

---@param a number
---@param b number
---@param delta_time number
---@return number
function flat.math.interpolate(a, b, delta_time) end

---@param value number
---@return number
function flat.math.sign(value) end

---@class flat.console
flat.console = {}

function flat.console.show() end

function flat.console.hide() end

function flat.console.clear() end

---@class flat.error
---@field silent boolean
flat.error = {}

---@class flat.explorer
---@field location string
flat.explorer = {}

---@param filter string
---@return string
function flat.explorer.select(filter) end

---@param folder string
---@return string[]
function flat.explorer.list(folder) end

---@class flat.storage
flat.storage = {}

---@return string
function flat.storage.load() end

---@param content string
function flat.storage.save(content) end

---@class flat.script
flat.script = {}

---@param script string
---@param name string
---@return any
function flat.script.execute(script, name) end

---@class flat.date
---@field year integer
---@field month integer
---@field day integer
---@field hour integer
---@field minute integer
---@field second integer
---@field total integer
---@field now flat.date
flat.date = {}

---@return string
function flat.date:__tostring() end

---@class flat.stopwatch
---@field elapsed number
flat.stopwatch = {}

---@return flat.stopwatch
function flat.stopwatch() end

function flat.stopwatch:reset() end

---@class flat.timer
---@field remaining number
---@field delay number
flat.timer = {}

---@param delay number
---@return flat.timer
function flat.timer(delay) end

function flat.timer:reset() end

---@class flat.label
---@field shape flat.shape
---@field layer integer
---@field text string
---@field color integer
flat.label = {}

---@param shape flat.shape
---@param layer integer
---@param text string
---@param color integer
---@return flat.label
function flat.label(shape, layer, text, color) end

---@return string
function flat.label:__tostring() end

---@class flat.sound
---@field playing boolean
flat.sound = {}

---@param path string
---@return flat.sound
function flat.sound.load(path) end

function flat.sound:play() end

function flat.sound:mute() end

---@return string
function flat.sound:__tostring() end

---@class flat.image
---@field width integer
---@field height integer
---@field diagonal number
flat.image = {}

---@param path string
---@return flat.image
function flat.image.load(path) end

---@return string
function flat.image:__tostring() end

---@class flat.tile
---@field shape flat.shape
---@field layer integer
---@field image flat.image
---@field flipped boolean
---@field dynamic boolean
---@field tangible boolean
---@field bounciness number
---@field friction number
---@field velocity flat.vector
---@field torque number
---@field mass number
flat.tile = {}

---@param shape flat.shape
---@param layer integer
---@param image flat.image
---@param flipped boolean
---@param dynamic boolean
---@param tangible boolean
---@param bounciness number
---@param friction number
---@return flat.tile
function flat.tile(shape, layer, image, flipped, dynamic, tangible, bounciness, friction) end

---@return string
function flat.tile:__tostring() end

---@class flat.dispatcher
---@field update integer
---@field render integer
---@field phase integer
---@field collision integer
---@field keyboard integer
---@field mouse integer
flat.dispatcher = {}

---@param eventType integer
---@param handler function
function flat.dispatcher.hook(eventType, handler) end

---@param eventType integer
---@param handler function
function flat.dispatcher.unhook(eventType, handler) end

---@class flat.network
---@field online boolean
flat.network = {}

---@param port integer
---@param reciever function
---@return integer
function flat.network.deploy(port, reciever) end

---@param host string
---@param path string
---@param request string
---@return string
function flat.network.request(host, path, request) end

---@param host string
---@param port integer
---@param request string
---@return string
function flat.network.send(host, port, request) end

function flat.network.shutdown() end

---@class flat.eula
---@field text string
flat.eula = {}

---@class flat.dialog
flat.dialog = {}

---@param text string
function flat.dialog.message(text) end

---@param text string
function flat.dialog.error(text) end

---@param text string
---@return boolean
function flat.dialog.question(text) end

---@param text string
---@return boolean
function flat.dialog.warning(text) end

---@class flat.scene
---@field time number
---@field fps integer
---@field gravity flat.vector
---@field filter integer
---@field background integer
---@field frames integer
---@field camera flat.shape
---@field title string
---@field ratio flat.vector
---@field fullscreen boolean
---@field icon flat.image
---@field tiles flat.scene.tiles
---@field labels flat.scene.labels
---@field cursor flat.scene.cursor
flat.scene = {}

function flat.scene.stop() end

---@class flat.scene.tiles
flat.scene.tiles = {}

---@param tile flat.tile
function flat.scene.tiles.add(tile) end

---@param tile flat.tile
function flat.scene.tiles.remove(tile) end

function flat.scene.tiles.reset() end

---@class flat.scene.labels
flat.scene.labels = {}

---@param label flat.label
function flat.scene.labels.add(label) end

---@param label flat.label
function flat.scene.labels.remove(label) end

function flat.scene.labels.reset() end

---@class flat.scene.cursor
---@field position flat.vector
flat.scene.cursor = {}

function flat.scene.cursor.show() end

function flat.scene.cursor.hide() end

---@class flat.input
---@field press integer
---@field release integer
---@field repeat_ integer
---@field keys flat.input.keys
---@field buttons flat.input.buttons
flat.input = {}

---@param key integer
---@return boolean
function flat.input.key(key) end

---@param button integer
---@return boolean
function flat.input.button(button) end

---@class flat.input.keys
---@field space integer
---@field apostrophe integer
---@field comma integer
---@field minus integer
---@field period integer
---@field slash integer
---@field digit0 integer
---@field digit1 integer
---@field digit2 integer
---@field digit3 integer
---@field digit4 integer
---@field digit5 integer
---@field digit6 integer
---@field digit7 integer
---@field digit8 integer
---@field digit9 integer
---@field semicolon integer
---@field equal integer
---@field a integer
---@field b integer
---@field c integer
---@field d integer
---@field e integer
---@field f integer
---@field g integer
---@field h integer
---@field i integer
---@field j integer
---@field k integer
---@field l integer
---@field m integer
---@field n integer
---@field o integer
---@field p integer
---@field q integer
---@field r integer
---@field s integer
---@field t integer
---@field u integer
---@field v integer
---@field w integer
---@field x integer
---@field y integer
---@field z integer
---@field left_bracket integer
---@field back_slash integer
---@field right_bracket integer
---@field grave_accent integer
---@field world1 integer
---@field world2 integer
---@field escape integer
---@field tab integer
---@field backspace integer
---@field insert integer
---@field arrow_right integer
---@field arrow_left integer
---@field arrow_down integer
---@field arrow_up integer
---@field page_up integer
---@field page_down integer
---@field home integer
---@field end integer
---@field caps_lock integer
---@field scroll_lock integer
---@field num_lock integer
---@field print_screen integer
---@field pause integer
---@field f1 integer
---@field f2 integer
---@field f3 integer
---@field f4 integer
---@field f5 integer
---@field f6 integer
---@field f7 integer
---@field f8 integer
---@field f9 integer
---@field f10 integer
---@field f11 integer
---@field f12 integer
---@field f13 integer
---@field f14 integer
---@field f15 integer
---@field f16 integer
---@field f17 integer
---@field f18 integer
---@field f19 integer
---@field f20 integer
---@field f21 integer
---@field f22 integer
---@field f23 integer
---@field f24 integer
---@field f25 integer
---@field keypad0 integer
---@field keypad1 integer
---@field keypad2 integer
---@field keypad3 integer
---@field keypad4 integer
---@field keypad5 integer
---@field keypad6 integer
---@field keypad7 integer
---@field keypad8 integer
---@field keypad9 integer
---@field keypad_decimal integer
---@field keypad_divide integer
---@field keypad_multiply integer
---@field keypad_substract integer
---@field keypad_add integer
---@field keypad_enter integer
---@field keypad_equal integer
---@field left_shift integer
---@field left_control integer
---@field left_alt integer
---@field left_super integer
---@field right_shift integer
---@field right_control integer
---@field right_alt integer
---@field right_super integer
---@field menu integer
flat.input.keys = {}

---@class flat.input.buttons
---@field left integer
---@field right integer
---@field middle integer
---@field x1 integer
---@field x2 integer
---@field x3 integer
---@field x4 integer
---@field x5 integer
---@field hover integer
---@field scroll integer
flat.input.buttons = {}

---@class flat.vector
---@field x number
---@field y number
---@field length number
---@field angle number
---@field perpendicular flat.vector
---@field unit flat.vector
flat.vector = {}

---@param x number
---@param y number
---@return flat.vector
function flat.vector(x, y) end

---@param other flat.vector
---@return number
function flat.vector:dot(other) end

---@param other flat.vector
---@return number
function flat.vector:cross(other) end

---@param angle number
---@return flat.vector
function flat.vector:cross_angle(angle) end

---@param angle number
function flat.vector:rotate(angle) end

---@param length number
function flat.vector:resize(length) end

---@param other flat.vector
---@param time number
function flat.vector:interpolate(other, time) end

---@param min flat.vector
---@param max flat.vector
function flat.vector:clamp(min, max) end

---@param limits flat.vector
function flat.vector:normalize(limits) end

---@param a flat.vector
---@param b flat.vector
---@return flat.vector
function flat.vector.average(a, b) end

---@param other flat.vector
---@return boolean
function flat.vector:__eq(other) end

---@return flat.vector
function flat.vector:__unm() end

---@param other flat.vector
---@return flat.vector
function flat.vector:__add(other) end

---@param other flat.vector
---@return flat.vector
function flat.vector:__sub(other) end

---@param other flat.vector
---@return flat.vector
function flat.vector:__mul(other) end

---@param scalar number
---@return flat.vector
function flat.vector:scale(scalar) end

---@return string
function flat.vector:__tostring() end

---@class flat.shape
---@field position flat.vector
---@field size flat.vector
---@field rotation number
---@field diagonal number
---@field center flat.vector
---@field vertices flat.vector[]
flat.shape = {}

---@param x number
---@param y number
---@param width number
---@param height number
---@param rotation number
---@return flat.shape
function flat.shape(x, y, width, height, rotation) end

---@param other flat.shape
---@return number
function flat.shape:distance(other) end

---@param other flat.shape
---@return number
function flat.shape:angle(other) end

---@param diagonal number
function flat.shape:resize(diagonal) end

---@param other flat.shape
---@param time number
function flat.shape:interpolate(other, time) end

---@param min flat.vector
---@param max flat.vector
function flat.shape:clamp(min, max) end

---@param other flat.shape
---@return boolean
function flat.shape:intersect(other) end

---@param other flat.shape
function flat.shape:unstuck(other) end

---@param point flat.vector
---@return boolean
function flat.shape:contains(point) end

---@param other flat.shape
---@return boolean
function flat.shape:__eq(other) end

---@return string
function flat.shape:__tostring() end
