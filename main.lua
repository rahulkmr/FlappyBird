
function love.load()
    arenaWidth = love.graphics.getWidth()
    arenaHeight = love.graphics.getHeight()

    birdX = 62
    birdWidth = 30
    birdHeight = 25

    pipeSpaceHeight = 100
    pipeWidth = 54

    reset()
end

function reset()
    score = 0
    upcomingPipe =1

    birdY = 200
    birdYSpeed = 0

    pipe1X = arenaWidth
    pipe1SpaceY = newPipeSpaceY()
    pipe2X = arenaWidth + ((arenaWidth + pipeWidth) / 2)
    pipe2SpaceY = newPipeSpaceY()
end


function newPipeSpaceY()
    local pipeSpaceYMin = 54
    return love.math.random(pipeSpaceYMin, arenaHeight - pipeSpaceHeight - pipeSpaceYMin)
end


function isBirdCollidingWithPipe(dt, pipeX, pipeSpaceY)
    if birdX < (pipeX + pipeWidth) and
        (birdX + birdWidth) > pipeX and 
        (birdY < pipeSpaceY or (birdY + birdHeight) > (pipeSpaceY + pipeSpaceHeight)) then
            return true
    end
end


function love.update(dt)
    birdYSpeed = birdYSpeed + (516 * dt)
    birdY = birdY + (birdYSpeed * dt)

    local function movePipe(pipeX, pipeSpaceY)
        pipeX = pipeX - (120 * dt)
        if (pipeX + pipeWidth) < 0 then
            pipeX = arenaWidth
            pipeSpaceY = newPipeSpaceY()
        end
        return pipeX, pipeSpaceY
    end

    pipe1X, pipe1SpaceY = movePipe(pipe1X, pipe1SpaceY)
    pipe2X, pipe2SpaceY = movePipe(pipe2X, pipe2SpaceY)

    if isBirdCollidingWithPipe(dt, pipe1X, pipe1SpaceY) or
        isBirdCollidingWithPipe(dt, pipe2X, pipe2SpaceY) or
        birdY > arenaHeight then
            reset()
    end
    
    local function updateScoreAndClosestPipe(thisPipe, pipeX, otherPipe)
        if upcomingPipe == thisPipe and
        (birdX > (pipeX + pipeWidth)) then
            score = score + 1
            upcomingPipe = otherPipe
        end
    end

    updateScoreAndClosestPipe(1, pipe1X, 2)
    updateScoreAndClosestPipe(2, pipe2X, 1)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.push('quit')
    elseif key == 'space' and birdY > 0 then
        birdYSpeed = -165
    elseif key == 'r' then
        love.load()
    end
end

function love.draw()
    love.graphics.setColor(.14, .36, .46)
    love.graphics.rectangle('fill', 0, 0, arenaWidth, arenaHeight)

    love.graphics.setColor(.87, .84, .27)
    love.graphics.rectangle('fill', birdX, birdY, birdWidth, 25)

    local function drawPipe(pipeX, pipeSpaceY)
        love.graphics.setColor(.37, .82, .28)
        love.graphics.rectangle('fill', pipeX, 0, pipeWidth, pipeSpaceY)
        love.graphics.rectangle('fill', pipeX, 
            pipeSpaceY + pipeSpaceHeight, pipeWidth, 
            arenaHeight - pipeSpaceY - pipeSpaceHeight)
    end
    drawPipe(pipe1X, pipe1SpaceY)
    drawPipe(pipe2X, pipe2SpaceY)

    love.graphics.setColor(1, 1, 1)
    love.graphics.print(score, 15, 15)
end