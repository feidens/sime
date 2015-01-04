Router.configure

  # we use the  appBody template to define the layout for the entire app
  layoutTemplate: "appBody"

  # # the appNotFound template is used for unknown routes and missing lists
  # notFoundTemplate: "appNotFound"
  #
  # # show the appLoading template whilst the subscriptions below load their data
  # loadingTemplate: "appLoading"

  # wait on the following subscriptions before rendering the page to ensure
  # the data it's expecting is present
  waitOn: ->
    [ Meteor.subscribe("houses") ]



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
  # Router.onBeforeAction "loading",
  #   except: [ "join", "signin" ]
  #
  # Router.onBeforeAction "dataNotFound",
  #   except: [ "join", "signin" ]


RoomController = RouteController.extend
    template: 'roomItem'
    waitOn: ->
      Meteor.subscribe 'sensorData', @params._id
    getSensorData: ->
      SensorData.find {}, {sort: {createdAt: -1}}
    getLastSensorData: ->
      data = @getSensorData().fetch()[0]
      value = data.value if data
      value
    data: ->
      sensorData: @getSensorData()
      lastSensorData: @getLastSensorData()


Engine = famous.core.Engine
Timer = famous.utilities.Timer

Router.map ->
  @route "join"
  @route "signin"
  @route "roomsShow",
    path: "/rooms/:_id"

    # subscribe to todos before the page is rendered but don't wait on the
    # subscription, we'll just render the items as they arrive
    # onBeforeAction: ->
    #   @todosHandle = Meteor.subscribe("todos", @params._id)
    #
    #   # Handle for launch screen defined in app-body.js
    #   dataReadyHold.release()  if @ready()
    #   this.next()
    waitOn: ->
      Meteor.subscribe 'rooms', @params._id
    data: ->
      data = Rooms.find()
      rooms: data.fetch()
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

# if Meteor.isClient
  # Router.onBeforeAction "loading",
  #   except: [ "join", "signin" ]
  #
  # Router.onBeforeAction "dataNotFound",
  #   except: [ "join", "signin" ]
