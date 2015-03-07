canvas = document.getElementById 'main-canvas'

DIRECTION = {
  DOWN:  [0, 1]
  RIGHT: [1, 0]
  LEFT:  [-1, 0]
  UP:    [0, -1]
}

add = (coordA, coordB) ->
  [a1, a2] = coordA; [b1, b2] = coordB
  result = [a1 + b1, a2 + b2]
  return result

class GameState
  constructor: ->
    @counter  = 0    # logical clock. integer. increaments by 1.
    @counterTime = 0  # real clock when the counter was incremented.
    @currentDelta = 0 # current clock.
    @clock = -> new Date() - 0

  updateCounter: ->
    @counter++
    @realTime = @clock()
    @timeDelta = 0

  updateRealtime: ->
    @timeDelta = @clock() - @realTime

draw = (ps) ->
  fps = 10
  SPEED  = 1
  sleepMs = 1000 / fps
  x = (v) -> v * 50
  y = (v) -> v * 50
  ps.setup canvas

  globalState = new GameState()

  class GameObject
    constructor: ->
    onLogicTick: (counter) ->

  class SceneObject
    onFrameTick: (counter) ->

  class Robot extends GameObject
    # robot can be in 2 state.
    # moving (towards x)
    # stationary
    constructor: ->
      @coord =        [1, 1] # update this later.
      @state =        "STATIONARY"
      @moveCoord =    null
      @startCounter = null

    move: (counter, direction) ->
      if @state is "STATIONARY"
        @state =        "MOVING"
        @nextCoord =    add(@coord, direction)
        @startCounter = counter
      else
        @state =        "MOVING"
        @coord =        @nextCoord
        @nextCoord =    add(@coord, direction)
        @startCounter = counter

    onLogicTick: (counter) ->
      if @state is "STATIONARY" then return
      if @state is "MOVING"
        if counter - @startCounter is SPEED
          @state = "STATIONARY"
          @coord = @nextCoord
          @nextCoord = null

  class RobotScene
    constructor: (robot) ->
      @robot = robot
      @view  = new ps.Path.Circle(new ps.Point(x(@robot.coord[0]), y(@robot.coord[1])), 25)
      @view.fillColor = 'black'

    onFrameTick: (timeState) ->
      {counter} = timeState
      if @robot.state is "MOVING"
        x_initial = @robot.coord[0]
        y_initial = @robot.coord[1]
        x_next = @robot.nextCoord[0]
        y_next = @robot.nextCoord[1]
        counterDelta = counter - @robot.startCounter
        {timeDelta} = timeState
        realCounterDelta = (counterDelta) + timeDelta / sleepMs
        @view.position.x = x(x_initial + (x_next - x_initial) / SPEED * realCounterDelta)
        @view.position.y = y(y_initial + (y_next - y_initial) / SPEED * realCounterDelta)
      else
        @view.position.x = x(@robot.coord[0])
        @view.position.y = y(@robot.coord[1])

  robot = new Robot()
  rScene = new RobotScene(robot)
  queue =  []

  ps.view.onFrame = (event) ->
    globalState.updateRealtime()
    rScene.onFrameTick(globalState)

  tool = new ps.Tool()
  tool.onKeyDown = (event) ->
    queue.push event

  logic = ->
    # main game loop
    globalState.updateCounter()
    robot.onLogicTick(globalState.counter)
    moved = false
    for item in queue
      # only move once per game.
      if moved then continue
      if item.type is 'keydown'
        if item.key is 'up'
          robot.move(globalState.counter, DIRECTION.UP)
          moved = true
        if item.key is 'down'
          robot.move(globalState.counter, DIRECTION.DOWN)
          moved = true
        if item.key is 'left'
          robot.move(globalState.counter, DIRECTION.LEFT)
          moved = true
        if item.key is 'right'
          robot.move(globalState.counter, DIRECTION.RIGHT)
          moved = true
    queue = []
    
  setInterval(logic, sleepMs)
  ps.view.draw()

ps = new paper.PaperScope()
draw ps
