cachedSubs = new SubsManager(
  cacheLimit: 20
  expireIn: 9999
)


Router.configure

  # we use the  appBody template to define the layout for the entire app
  layoutTemplate: "appBody"


  waitOn: ->
    [ cachedSubs.subscribe("houses") ]



requireLogin = (pause) ->
  unless Meteor.userId()
    Router.go 'atSignIn'
  else
    @next()
  return



Router.onBeforeAction requireLogin,
  except: [ "atSignIn", "atSignUp" ]

dataReadyHold = null
if Meteor.isClient

  # Keep showing the launch screen on mobile devices until we have loaded
  # the app's data
  dataReadyHold = LaunchScreen.hold()

  # Show the loading screen on desktop
  Router.onBeforeAction "loading",
    except: [ "atSignUp", "atSignIn" ]
  #
  # Router.onBeforeAction "dataNotFound",
  #   except: [ "atSignUp", "atSignIn" ]


RoomController = RouteController.extend
    template: 'roomItem'
    waitOn: ->
      cachedSubs.subscribe 'sensorData', @params._id if @params._id
      cachedSubs.subscribe 'roomName', @params._id
    getHumSensorData: ->
      SensorData.find {'type': 'hum'}, {sort: {createdAt: -1}}
    lastHumSensorData: ->
      data = @getHumSensorData().fetch()[0]
      value = data.value if data
      value
    getTempSensorData: ->
      SensorData.find {'type': 'temp'}, {sort: {createdAt: -1}}
    lastTempSensorData: ->
      data = @getTempSensorData().fetch()[0]
      value = data.value if data
      value
    getRoom: ->
      Rooms.findOne()
    data: ->
      room: @getRoom()
      humSensorData: @getHumSensorData()
      lastHumSensorData: @lastHumSensorData()
      tempSensorData: @getTempSensorData()
      lastTempSensorData: @lastTempSensorData()


Engine = famous.core.Engine
Timer = famous.utilities.Timer

Router.map ->
  @route "join"
  @route "signin"
  @route "roomsShow",
    path: "/rooms/:_id"


    waitOn: ->
      cachedSubs.subscribe 'rooms', @params._id
    data: ->
      data = Rooms.find()
      rooms: data
    onAfterAction: ->
      Timer.setTimeout ->
        fscrollview = FView.byId 'scrollview'
        Engine.pipe fscrollview.view if fscrollview
      , 100

  @route "home",
    path: "/"
    action: ->
      house = Houses.findOne()
      Router.go "roomsShow", house

  @route "roomItem",
    path: "/room/:_id"
    controller: RoomController


setOverlayOpacity = ->
  overlay = FView.byId 'overlay'
  return false if overlay is undefined
  currentOpacity = overlay.modifier.getOpacity()
  nextOpacity = if currentOpacity > .5 then 0 else 1
  overlay.modifier.setOpacity nextOpacity, duration: 300
