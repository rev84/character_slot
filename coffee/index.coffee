window.reels =
  who:[]
  clothes:[]
  serif:[]
window.speed = 
  who:false
  clothes:false
  serif:false
window.interval = 50
window.startSpeed = 30
window.minSpeed = 5
window.decreaseSpeed = 1
window.stopTimer = false

$().ready ->
  window.reels.who.push new Koma('who', '？？？', 0)
  window.reels.clothes.push new Koma('clothes', '？？？', 0)
  window.reels.serif.push new Koma('serif', '？？？', 0)
  move true
  setInterval move, window.interval
  $('#start').on 'click', buttonClick

buttonClick = ->
  if $(@).html() is 'スタート'
    return if window.stopTimer isnt false
    $(@).html('ストップ')
    start()
  else
    $(@).html('スタート')
    window.stopTimer = setInterval stop, window.interval

start = ->
  window.speed.who = window.startSpeed
  window.speed.clothes = window.startSpeed
  window.speed.serif = window.startSpeed

stop = ->
  if window.speed.who isnt false
    window.speed.who -= window.decreaseSpeed
    window.speed.who = window.minSpeed if window.speed.who <= window.minSpeed
  else if window.speed.clothes isnt false
    window.speed.clothes -= window.decreaseSpeed
    window.speed.clothes = window.minSpeed if window.speed.clothes <= window.minSpeed
  else if window.speed.serif isnt false
    window.speed.serif -= window.decreaseSpeed
    window.speed.serif = window.minSpeed if window.speed.serif <= window.minSpeed
  else
    clearInterval window.stopTimer
    window.stopTimer = false

move = (isForce = false)->
  return false if window.speed.who is false and window.speed.clothes is false and window.speed.serif is false and isForce isnt true
  for id, objs of window.reels
    newObjs = []
    minY = null
    for obj in objs
      # 止まる
      if window.speed[id] is window.minSpeed and -window.minSpeed <= obj.getY() <= window.minSpeed
        obj.move -obj.getY(), window.interval
        window.speed[id] = false
        newObjs.push obj
      else
        obj.move window.speed[id], window.interval
        newObjs.push obj if obj.deleteElementByPosition()
        minY = obj.getY() if minY is null or minY > obj.getY()
    if minY > -10 and window.speed[id] isnt false
      idol = pickIdol()
      newObjs.push(new Koma(id, idol.name, minY - 75, idol.icon))
    window.reels[id] = newObjs

pickIdol = ->
  window.idols[Utl.rand(0, window.idols.length-1)]

class Koma
  isAlive: true
  element: null

  constructor:(@id, @name, @top = -75, @img = './img/default.png')->
    @generateElement()

  generateElement:()->
    @element = $('<div>').addClass('koma').css('top', @top)
    @element.append(
      $('<img>').attr('src', @img)
    ).append(
      $('<span>').html(@name)
    )
    $('#'+@id).append @element
    @element

  setY:(y, msec = 0)->
    @top = y if y isnt false
    if msec <= 0
      @element.css('top', @top)
    else
      @element.animate({
        top: @top
      }, msec)
  move:(y, msec = 0)->
    @top += y if y isnt false
    if msec <= 0
      @element.css('top', @top)
    else
      @element.animate({
        top: @top
      }, msec)

  getY:->
    @top

  deleteElementByPosition:->
    if @top > 85
      @element.remove() 
      @isAlive = false
    @isAlive
