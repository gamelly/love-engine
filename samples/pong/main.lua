local game = {
    highscore = 0,
    player_pos = 0,
    ball_pos_x = 0,
    ball_pos_y = 0,
    ball_spd_x = 500,
    ball_spd_y = 300,
    score = 0,
    player_size = 0,
    ball_size = 0
}

function love.load()
    game.highscore = math.max(game.highscore, game.score)
    game.player_pos = love.graphics.getHeight() / 2
    game.ball_pos_x = love.graphics.getWidth() / 2
    game.ball_pos_y = love.graphics.getHeight() / 2
    game.player_size = math.min(love.graphics.getWidth(), love.graphics.getHeight()) / 8
    game.ball_size = math.max(love.graphics.getWidth(), love.graphics.getHeight()) / 160
end

function love.update(dt)
    game.ball_pos_x = game.ball_pos_x + (game.ball_spd_x * dt)
    game.ball_pos_y = game.ball_pos_y + (game.ball_spd_y * dt)
    
    if love.keyboard.isDown("up") then
        game.player_pos = math.max(0, game.player_pos - 300 * dt)
    elseif love.keyboard.isDown("down") then
        game.player_pos = math.min(love.graphics.getHeight() - game.player_size, game.player_pos + 300 * dt)
    end

    if game.ball_pos_x >= love.graphics.getWidth() - game.ball_size then
        game.ball_spd_x = -math.abs(game.ball_spd_x)
    end
    if game.ball_pos_y >= love.graphics.getHeight() - game.ball_size then
        game.ball_spd_y = -math.abs(game.ball_spd_y)
    end
    if game.ball_pos_y <= 0 then
        game.ball_spd_y = math.abs(game.ball_spd_y)
    end
    if game.ball_pos_x <= 0 then
        if game.ball_pos_y >= game.player_pos and game.ball_pos_y <= game.player_pos + game.player_size then
            game.ball_spd_y = game.ball_spd_y + 500 - (math.floor(love.timer.getTime()) % 1000)
            game.ball_spd_x = math.abs(game.ball_spd_x) * 1.1
            game.score = game.score + 1
        else
            love.load()
        end
    end
end

function love.draw()
    local w = love.graphics.getWidth()/4
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", 0, game.player_pos, game.ball_size, game.player_size)
    love.graphics.rectangle("fill", game.ball_pos_x, game.ball_pos_y, game.ball_size, game.ball_size)
    love.graphics.print(game.score, w, 1)
    love.graphics.print(game.highscore, w*3, 1)
end
