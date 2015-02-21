canvas = document.getElementById 'main-canvas'

draw = (ps) ->
  ps.setup canvas
  path = new ps.Path()
  path.strokeColor = 'black'
  start = new ps.Point 100, 100
  path.moveTo start
  path.lineTo start.add [200, -50]
  path.lineTo start.add [200, -40]
  path.selected = true
  ps.view.draw()

ps = new paper.PaperScope()
draw ps
