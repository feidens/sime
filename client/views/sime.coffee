# if Meteor.isClient
#
#   # counter starts at 0
#   Session.setDefault "counter", 0
#   Template.hello.helpers counter: ->
#     Session.get "counter"
#
#   Template.hello.events "click button": ->
#
#     # increment the counter when button is clicked
#     Session.set "counter", Session.get("counter") + 1

if Meteor.isServer
  Meteor.startup ->


# code to run on server at startup


# Set FView logging at its bare minimum
#Logger.setLevel('famous-views', 'info');

# Polyfills are necessary if you are using raix:famono
# famous.polyfills

# If you are using pierreeric:cssc-famous, you don't need this line
# as it imports the required CSS files for Famo.us in CS (therefore no
# CSS file is required which speeds up your apps and avoid tempering
# with the JS engine).

#famous.core.famous


Transform = null
FView.ready ->

  Transform = famous.core.Transform
  FView.registerView "GridLayout", famous.views.GridLayout
  console.info "%c\nfamous-views started\n", "font-weight: 300; color: #ec5f3e; font-size: x-large; " + "font-family: 'Lato', 'Helvetica Neue', Helvetica, Arial, sans-serif; " + "-webkit-font-smoothing: antialiased;"


Template.header.rendered = ->
  fview = FView.from(this)
  target = fview.surface or fview.view
  target.on "click", ->
    Router.go 'home'
    return
  return
