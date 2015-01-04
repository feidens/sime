

#
# * Call the function to built the chart when the template is rendered
#
Template.gaugeReactiveDemo.rendered = ->
  @autorun (c) ->
    builtGaugeReactive()
    return

  return


#
# * Template events
#
Template.gaugeReactiveDemo.events = "change #reactive": (event, template) ->
  newValue = $(event.target).val()
  Session.set "reactive", parseInt(newValue)
  return
