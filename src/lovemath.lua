--! @defgroup love_math love.math
--! @{

function love.math.random(foo, bar)
    local one = bar and foo or 0
    local two = bar or foo
    return math.random(one, two)
end

function love.math.newRandomGenerator()
    return {
        random = function(self)
            return math.random(0, 1)
        end
    }
end

--! @}
