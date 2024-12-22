local math = require('math')

if not unpack then
    unpack = function() end
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

local engine = {
    width=1280,
    height=720,
    keys={},
    milis=0
}

local conversor_frame = {
    fill = 0,
    line = 1,
    frame = 1
}

--! @defgroup love_graphics love.graphics
--! @{

function love.graphics.print(text, x, y)
    return native_text_print(x, y, text)
end

function love.graphics.rectangle(mode, x, y, w, h)
    return native_draw_rect(conversor_frame[mode], x, y, w, h)
end

function love.graphics.getColor()
    return love.color_r, love.color_g, love.color_b, love.color_a
end

function love.graphics.setColor(r, g, b, a)
    love.color_r, love.color_g, love.color_b, love.color_a = r, g, b, a
    local color = (r * 0xFF000000) + (g * 0xFF0000) + (b * 0xFF00) + ((a or 1) * 0xFF)
    return native_draw_color(color)
end

function love.graphics.clear(r, g, b, a)
    local color = (r * 0xFF000000) + (g * 0xFF0000) + (b * 0xFF00) + ((a or 1) * 0xFF)
    native_draw_clear(0x000000FF, 0, 0, engine.width, engine.height)
end

function love.graphics.getHeight()
    return engine.height
end

function love.graphics.getWidth()
    return engine.width
end

function love.graphics.setDefaultFilter()
end

function love.graphics.setBackgroundColor()
end

function love.graphics.setBlendMode()
end

function love.graphics.newShader()
    return {}
end

function love.graphics.newCanvas()
    return {
        renderTo=function() end
    }
end

function love.graphics.newFont()
    return {}
end

function love.graphics.newImageFont()
    return {}
end

function love.graphics.present()
end

function love.graphics.draw(src, x, y)
    if src.src and src.t == 'img' then
        return native_draw_image(src.src, x, y)
    end
end

function love.graphics.newImage(src)
    return {
        t='img',
        src=src,
        release = function() end,
        getWidth = function() return 100 end,
        getHeight = function() return 100 end,
        setWrap = function() end,
        setFilter = function() end,
    }
end

function love.graphics.newQuad(x, y, width, height, sw,sh)
    return {
        t='quad',
        x=x,
        y=y,
        width=width,
        height=height
    }
end

function love.graphics.newSpriteBatch()
    return {
        setColor=function() end,
        clear=function() end,
        add=function() end
    }
end

function love.graphics.scale()
end

function love.graphics.translate()
end

function love.graphics.origin()
end

--! @}
--! @defgroup love_keyboard love.keyboard
--! @{

function love.keyboard.isDown(key)
    return engine.keys[key] == true
end

function love.keyboard.setKeyRepeat()
end

--! @}
--! @defgroup love_timer love.timer
--! @{

function love.timer.getTime()
    return engine.milis
end

--! @}
--! @defgroup love love
--! @{

function love.getVersion()
    return 11, 0, 0
end


--! @}
--! @defgroup love_system love.system
--! @{

function love.system.getOS()
    return 'Web'
end

--! @}
--! @defgroup love_mouse love.mouse
--! @{

function love.mouse.setVisible()
end

function love.mouse.getPosition()
    return 0, 0
end

--! @}
--! @defgroup love_image love.image
--! @{

function love.image.newImageData(width, height)
    return {
        paste = function() end,
        setPixel = function() end,
        getWidth = function() return 100 end,
        getHeight = function() return 100 end
    }
end

--! @}
--! @defgroup love_math love.math
--! @{

function love.math.newRandomGenerator()
    return {
        random = function(self)
            return math.random(0, 1)
        end
    }
end

--! @}
--! @defgroup love_audio love.audio
--! @{

function love.audio.setPosition()
end

function love.audio.newSource()
    return {
        setLooping = function() end,
        setVolume = function() end,
        setAttenuationDistances=function() end,
    }
end

--! @}
--! @defgroup love_sound love.sound
--! @{

function love.sound.newSoundData()
    return {}
end

--! @}
--! @defgroup love_filesystem love.filesystem
--! @{

function love.filesystem.getInfo()
end

function love.filesystem.read()
end

--! @}
--! @defgroup love_window love.window
--! @{

function love.window.setMode()
end

function love.window.toPixels(w)
    return w
end

function love.window.setTitle()
end

function love.window.setIcon()
end

function love.window.getDesktopDimensions()
    return engine.width, engine.height
end

--! @}

function native_callback_loop(dt)
    engine.milis = engine.milis + dt
    love.update(dt/1000)
end

function native_callback_draw()
    native_draw_start()
    native_draw_clear(0x000000FF, 0, 0, engine.width, engine.height)
    native_draw_color(0xFFFFFFFF)
    love.draw()
    native_draw_flush()
end

function native_callback_resize(width, height)
    engine.width = width
    engine.height = height
    love.resize(w, h)
end

function native_callback_keyboard(key, value)
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
    native_text_font_size(12)
    local ok, app = pcall(loadstring, game_lua)
    if not ok then
        ok, app = pcall(load, game_lua)
    end
    while type(app) == 'function' do
        app = app()
    end
    love.load()
end

pcall(function() 
    require('conf')
end)

local P = {
    meta={
        title='love-engine',
        author='RodrigoDornelles',
        description='reimplementation of the love2d framework to make homebrew games to gba, nds, wii, ps2 and many other platforms!',
        version='0.0.16'
    }
}

return P
