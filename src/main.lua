love = {
    -- user callbacks
    load = function() end,
    update = function(dt) end,
    draw = function() end,
    resize = function(w, h) end,
    keypressed = function (key, scancode, isrepeat) end,
    keyreleased = function (key, scancode) end,
    -- engine API
    graphics = {},
    keyboard = {},
    timer={}
}

local engine = {
    width=1280,
    height=720,
    keys={},
    milis=0
}

local conversor_frame = {
    [0] = 'line',
    [1] = 'frame'
}

--! @defgroup love_graphics love.graphics
--! @{

function love.graphics.print(text, x, y)
    return native_text_print(x, y, text)
end

function love.graphics.rectangle(mode, x, y, w, h)
    return native_draw_rect(conversor_frame[mode], x, y, w, h)
end

function love.graphics.setColor(r, g, b, a)
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

--! @}
--! @defgroup love_keyboard love.keyboard
--! @{

function love.keyboard.isDown(key)
    return engine.keys[key] == true
end

--! @}
--! @defgroup love_timer love.timer
--! @{

function love.timer.getTime()
    return engine.milis
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
    native_draw_clear(0x000000FF, 0, 0, engine.width, engine.height)
    native_draw_color(0xFFFFFFFF)
    native_text_font_size(12)
    local ok, app = pcall(loadstring, game_lua)
    if not ok then
        ok, app = pcall(load, game_lua)
    end
    app()
    love.load()
end

local P = {
    meta={
        title='love-engine',
        author='RodrigoDornelles',
        description='reimplementation of the love2d framework to make homebrew games to gba, nds, wii, ps2 and many other platforms!',
        version='0.0.16'
    }
}

return P
