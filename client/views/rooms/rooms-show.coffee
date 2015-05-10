Template["roomGridItem"].rendered = ->
  fview = FView.from(this)
  target = fview.surface or fview.view
  roomId = @data._id
  target.on "click", ->
    Router.go 'roomItem',
      _id: roomId
    return
  return


# Set FView logging at its bare minimum
Logger.setLevel 'famous-views', 'info'

# Polyfills are necessary if you are using raix:famono
# famous.polyfills
# If you are using pierreeric:cssc-famous, you don't need this line
# as it imports the required CSS files for Famo.us in CS (therefore no
# CSS file is required which speeds up your apps and avoid tempering
# with the JS engine).
#famous.core.famous

Engine = famous.core.Engine
Timer = famous.utilities.Timer



Template["logoutButton"].rendered = ->
  button = (FView.byId 'switchRoute').surface
  button.on 'click', ->
    Meteor.logout (err) ->
      # callback
      Router.go('/sign-in')
      return



Router.route '/second'
