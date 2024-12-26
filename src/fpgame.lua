local game = {
    score = 0,
    highscore = 0,
    bird_y = 0,
    bird_velocity = 0,
    bird_size = 20,
    gravity = 500,
    jump_strength = -300,
    pipes = {},
    pipe_width = 50,
    pipe_gap = 150,
    pipe_spawn_timer = 0,
    pipe_spawn_interval = 2, -- segundos
    is_game_over = false
}

function love.load()
    game.score = 0
    game.highscore = math.max(game.highscore, game.score)
    game.bird_y = love.graphics.getHeight() / 2
    game.bird_velocity = 0
    game.pipes = {}
    game.pipe_spawn_timer = 0
    game.is_game_over = false
end

function spawn_pipe()
    local screen_height = love.graphics.getHeight()
    local gap_start = math.random(100, screen_height - 100 - game.pipe_gap)
    table.insert(game.pipes, {
        x = love.graphics.getWidth(),
        gap_start = gap_start
    })
end

function love.update(dt)
    if game.is_game_over then
        if love.keyboard.isDown("space") then
            love.load() -- Reinicia o jogo
        end
        return
    end

    -- Atualiza a física do pássaro
    game.bird_velocity = game.bird_velocity + game.gravity * dt
    game.bird_y = game.bird_y + game.bird_velocity * dt

    -- Verifica pulo
    if love.keyboard.isDown("space") then
        game.bird_velocity = game.jump_strength
    end

    -- Gerenciamento de canos
    game.pipe_spawn_timer = game.pipe_spawn_timer + dt
    if game.pipe_spawn_timer >= game.pipe_spawn_interval then
        spawn_pipe()
        game.pipe_spawn_timer = 0
    end

    for i = #game.pipes, 1, -1 do
        local pipe = game.pipes[i]
        pipe.x = pipe.x - 200 * dt -- Move o cano para a esquerda

        -- Remove canos que saíram da tela
        if pipe.x + game.pipe_width < 0 then
            table.remove(game.pipes, i)
        end

        -- Verifica colisão
        if pipe.x < love.graphics.getWidth() / 4 + game.bird_size and pipe.x + game.pipe_width > love.graphics.getWidth() / 4 then
            if game.bird_y < pipe.gap_start or game.bird_y + game.bird_size > pipe.gap_start + game.pipe_gap then
                game.is_game_over = true
            end
        end

        -- Pontuação
        if not pipe.scored and pipe.x + game.pipe_width < love.graphics.getWidth() / 4 then
            game.score = game.score + 1
            pipe.scored = true
        end
    end

    -- Verifica colisão com as bordas da tela
    if game.bird_y < 0 or game.bird_y + game.bird_size > love.graphics.getHeight() then
        game.is_game_over = true
    end
end

function love.draw()
    love.graphics.clear(0.5, 0.8, 1) -- Fundo azul claro

    -- Desenha o pássaro
    love.graphics.setColor(1, 1, 0) -- Amarelo
    love.graphics.rectangle("fill", love.graphics.getWidth() / 4, game.bird_y, game.bird_size, game.bird_size)

    -- Desenha os canos
    love.graphics.setColor(0, 1, 0) -- Verde
    for _, pipe in ipairs(game.pipes) do
        -- Cano superior
        love.graphics.rectangle("fill", pipe.x, 0, game.pipe_width, pipe.gap_start)
        -- Cano inferior
        love.graphics.rectangle("fill", pipe.x, pipe.gap_start + game.pipe_gap, game.pipe_width, love.graphics.getHeight() - pipe.gap_start - game.pipe_gap)
    end

    -- Desenha o placar
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. game.score, 10, 10)
    love.graphics.print("Highscore: " .. game.highscore, 10, 30)

    -- Tela de Game Over
    if game.is_game_over then
        love.graphics.setColor(1, 0, 0)
        love.graphics.printf("Game Over! Press SPACE to restart.", 0, love.graphics.getHeight() / 2, love.graphics.getWidth(), "center")
    end
end
