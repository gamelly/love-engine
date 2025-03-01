--! @defgroup love_audio love.audio
--! @{

function love.audio.play()
end

function love.audio.stop()
end

function love.audio.setPosition()
end

function love.audio.newSource()
    return {
        play = function() end,
        stop = function() end,
        setLooping = function() end,
        setVolume = function() end,
        setPosition = function() end,
        setAttenuationDistances=function() end,
    }
end

--! @}
