local game = {
    highscore = 0,
    player_pos = 0,
    ball_pos_x = 0,
    ball_pos_y = 0,
    ball_spd_x = 0,
    ball_spd_y = 0,
    score = 0,
    player_size = 0,
    ball_size = 0,
    player_speed = 0,
    aux_ball_speed = 0,
    max_speed = 0,
    acceleration = 0,
    deceleration = 0,
    player_color = {1, 1, 1}
}

function love.load()
    game.score = 0
    game.highscore = math.max(game.highscore, game.score)
    game.player_pos = love.graphics.getHeight() / 2
    game.ball_pos_x = love.graphics.getWidth() / 1.5
    game.ball_pos_y = love.graphics.getHeight() / 1.5
    game.player_size = math.min(love.graphics.getWidth(), love.graphics.getHeight()) / 4
    game.ball_size = math.max(love.graphics.getWidth(), love.graphics.getHeight()) / 160
    game.ball_spd_x = (game.ball_size * 50)*-1
    game.ball_spd_y = (game.ball_size * 50)*-1
    game.player_speed = 0
    game.aux_ball_speed = 1
    game.max_speed = 400 
    game.acceleration = 1000 
    game.deceleration = 1000
    game.is_paused = false
    game.player_color = {1, 1, 1}

    if love.graphics.getWidth() < 600 then
        game.ball_spd_x = (game.ball_size * 30)*-1
        game.ball_spd_y = (game.ball_size * 30)*-1
        game.max_speed = 200
        game.acceleration = 200
        game.deceleration = 500
        game.player_size = math.min(love.graphics.getWidth(), love.graphics.getHeight()) / 2
    end
end

function love.update(dt)
    if love.keyboard.isDown("right") then  
        game.is_paused = not game.is_paused
    end

    if game.is_paused then
        return
    end

    screen_change_color()
    update_ball_position(dt)
    input_player(dt)

    game.player_pos = math.min(love.graphics.getHeight() - game.player_size, math.max(0, game.player_pos + game.player_speed * dt))

    ease_ball_speed(dt)

    if game.ball_pos_x >= love.graphics.getWidth() - game.ball_size then
        game.ball_spd_x = -math.abs(game.ball_spd_x)
    end
    if game.ball_pos_y >= love.graphics.getHeight() - game.ball_size then
        game.ball_spd_y = -math.abs(game.ball_spd_y)
    end
    if game.ball_pos_y <= 0 then
        game.ball_spd_y = game.ball_spd_y * -1
    end

    if game.ball_pos_x <= 0 then -- collison with player
        if game.ball_pos_y >= game.player_pos and game.ball_pos_y <= game.player_pos + game.player_size then
            game.ball_spd_y = game.ball_spd_y + 900 - (math.floor(love.timer.getTime()) % 1000)
            game.ball_spd_x = math.abs(game.ball_spd_x) * 1.1
            game.aux_ball_speed = 1.25
            game.score = game.score + 1
            game.speed_timer = 0
            game.player_size = game.player_size * 0.98
            increase_player_aceleration()
        else
            love.load()
        end
    end
end

function increase_player_aceleration()
    game.acceleration = game.acceleration * 1.05
    game.deceleration = game.deceleration * 1.05
    game.max_speed = game.max_speed * 1.05
end

function player_move(direction)
    if direction == "up" then
         game.player_speed = math.max(-game.max_speed, game.player_speed - game.acceleration)
    elseif direction == "down" then
       game.player_speed = math.min(game.max_speed, game.player_speed + game.acceleration)
    end
end

function player_stop_movement(dt)
    if game.player_speed > 0 then
            game.player_speed = math.max(0, game.player_speed - game.deceleration * dt)
        elseif game.player_speed < 0 then
            game.player_speed = math.min(0, game.player_speed + game.deceleration * dt)
        end
end

function update_ball_position(dt)
    game.ball_pos_x = game.ball_pos_x + (game.ball_spd_x * dt) 
    game.ball_pos_y = (game.ball_pos_y + (game.ball_spd_y * dt)/(love.graphics.getHeight()/100)) * 0.99
end

function screen_change_color()
        if game.aux_ball_speed > 1.1 then
        game.player_color = {1, math.min(0,game.aux_ball_speed-1),math.min(0,game.aux_ball_speed-1)}
       
    elseif game.aux_ball_speed < 1.1 then
        game.player_color = {1, 1, 1}
    end
end

function ease_ball_speed(dt)
     if game.aux_ball_speed > 1.001 then
        game.speed_timer = game.speed_timer + dt
        if game.speed_timer >= 0.05 then -- wait 50ms
            game.speed_timer = game.speed_timer - 0.05 -- reset timer
            
            local delta = game.aux_ball_speed - 1
            game.aux_ball_speed = game.aux_ball_speed - delta * 0.1 -- Reduz proporcionalmente
            
            if game.aux_ball_speed < 1 then
                game.aux_ball_speed = 1 -- Garante que não seja menor que 1
            end
        end
    end
end

function input_player(dt)
    if love.keyboard.isDown("up") then
        player_move("up")
    elseif love.keyboard.isDown("down") then
        player_move("down")
    else
        player_stop_movement(dt)
    end
end


function love.draw()
    local w = love.graphics.getWidth()/4
    love.graphics.clear(0, 0, 0)
    love.graphics.setColor(game.player_color[1],game.player_color[2],game.player_color[2])
    love.graphics.rectangle("fill", 0, game.player_pos, game.ball_size, game.player_size)
    love.graphics.rectangle("fill", game.ball_pos_x, game.ball_pos_y, game.ball_size, game.ball_size)
    love.graphics.print(game.score, w, 1)
    love.graphics.print(game.highscore, w*3, 1)
    love.graphics.print(game.ball_spd_x, w*2, 1)
    love.graphics.print(love.graphics.getWidth(), w*2, 20)
end