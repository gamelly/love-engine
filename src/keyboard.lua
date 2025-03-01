--! @defgroup love_keyboard love.keyboard
--! @{

function love.keyboard.isDown(key)
    return engine.keys[key] == true
end

function love.keyboard.setKeyRepeat()
end

--! @}
