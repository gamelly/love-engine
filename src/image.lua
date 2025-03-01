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
