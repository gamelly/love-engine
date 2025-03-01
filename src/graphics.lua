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

function love.graphics.setShader()
end

function love.graphics.newShader()
    return {
        send = function() end
    }
end

function love.graphics.newCanvas()
    return {
        renderTo = function() end
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
        if type(x) == 'table' then
            y, x = x.y, x.x
        end
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