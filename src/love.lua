local math = require('math')

if not arg then
    arg = {}
end

if not unpack then
    unpack = function(t) return t and table.unpack(t) end
end

love = {
    -- internal values
    color_r = 1,
    color_g = 1,
    color_b = 1,
    color_a = 1,
    -- user callbacks
    load = function() end,
    update = function(dt) end,
    draw = function() end,
    resize = function(w, h) end,
    keypressed = function (key, scancode, isrepeat) end,
    keyreleased = function (key, scancode) end,
    -- engine API
    physics = {},
    filesystem = {},
    graphics = {},
    joystick = {},
    keyboard = {},
    image = {},
    timer = {},
    system = {},
    mouse = {},
    math = {},
    audio = {},
    sound = {},
    window = {},
    event = {}
}

require('src/audio')
require('src/event')
require('src/filesystem')
require('src/graphics')
require('src/image')
require('src/joystick')
require('src/keyboard')
require('src/lovemath')
require('src/mouse')
require('src/sound')
require('src/system')
require('src/timer')
require('src/window')

engine = {
    width=1280,
    height=720,
    keys={},
    milis=0
}

keybindings = {
}

--! @defgroup love love
--! @{

function love.getVersion()
    return 11, 0, 0
end

--! @}

function native_callback_loop(dt)
    engine.milis = engine.milis + dt
    love.update(dt/1000)
end

function native_callback_draw()
    native_draw_start()
    love.draw()
    native_draw_flush()
end

function native_callback_resize(width, height)
    engine.width = width
    engine.height = height
    love.resize(w, h)
end

function native_callback_keyboard(vkey, value)
    local key = keybindings[vkey] or vkey
    if value == true or value == 1 then
        engine.keys[key] = true
        love.keypressed(key, key, false)
    else
        engine.keys[key] = false
        love.keyreleased(key, key)
    end
end

function native_callback_init(width, height, game_lua)
    engine.width = width
    engine.height = height
    native_draw_clear(0x000000FF, 0, 0, engine.width, engine.height)
    native_draw_color(0xFFFFFFFF)
    native_text_font_size(12)
    local ok, app = pcall(loadstring, game_lua)
    if not ok then
        ok, app = pcall(load, game_lua)
    end
    while type(app) == 'function' do
        app = app()
    end
    love.load(arg)
end

local function main()
    local config_file = io and io.open and io.open('love.json')

    if config_file then
        local index = 1
        local config_content = config_file:read('*a')
        local config_table = native_json_decode(config_content) or {}
        local key_list = {'a', 'b', 'c', 'd', 'menu', 'up', 'left', 'down', 'right'}
        while index <= #key_list do
            keybindings[key_list[index]] = config_table['key_'..key_list[index]]
            index = index + 1
        end
    end

    pcall(require, 'conf')
end

main()

local P = {
    meta={
        title='love-engine',
        author='RodrigoDornelles',
        description='reimplementation of the love2d framework to make homebrew games to gba, nds, wii, ps2 and many other platforms!',
        version='0.0.19'
    }
}

return P
