templateTempDep = new Deps.Dependency()
Highcharts.theme = {
   title: {
      style: {
         color: 'black',
         fill: 'black';
         fontSize: '16px',
         fontWeight: 'bold'
      }
   },
   subtitle: {
      style: {
         color: 'black'
      }
   }
};


Highcharts.setOptions(Highcharts.theme);
#
# * Function to draw the line
#
builtTempLineChatReactive = () ->
  templateTempDep.depend()
  data = new Array()
  catData = new Array()
  #data[0] = Session.get("reactive")  if Session.get("reactive") isnt `undefined`

  value = @Blaze.getData().tempSensorData
  items = value.fetch()
  categories = _.pluck(items, "createdAt")
  values = _.pluck(items, "value")
  for value in values
    data.unshift Number value
  for value in categories
    catData.unshift moment(value).format("HH:mm")
  $("#container-temp-line-reactive").highcharts
    chart:
      type: "line"
      backgroundColor: "rgba(251, 237, 228, 0.0)"

    title:
      style:
        color: '#fff'
        fontSize: '16px'
      text: "Temperature overview"

    subtitle:
      text: "Rasperri Pi"

    xAxis:
      categories: catData

    yAxis:
      title:
        text: "Temp (°C)"

    plotOptions:
      line:
        dataLabels:
          enabled: true

        enableMouseTracking: false

    series: [
      name: "Room Name"
      data: data
     ]



#
# * Function to draw the gauge
#
builtTempGaugeReactive = () ->
  templateTempDep.depend()
  data = new Array()
  data[0] = 0
  #data[0] = Session.get("reactive")  if Session.get("reactive") isnt `undefined`

  value = Number @Blaze.getData().lastTempSensorData
  data[0] = value

  $("#container-temp-gauge-reactive").highcharts
    chart:
      type: "gauge"
      plotBackgroundColor: null
      plotBackgroundImage: null
      plotBorderWidth: 0
      plotShadow: false
      backgroundColor: "rgba(251, 237, 228, 0.0)"


    title:
      text: "Thermometer"

    pane:
      startAngle: -140
      endAngle: 140
      background: [
        backgroundColor:
          linearGradient:
            x1: 0
            y1: 0
            x2: 0
            y2: 1

          stops: [ [ 0, "#FFF" ], [ 1, "#333" ] ]

        borderWidth: 0
        outerRadius: "109%"
      ,
        backgroundColor:
          linearGradient:
            x1: 0
            y1: 0
            x2: 0
            y2: 1

          stops: [ [ 0, "#333" ], [ 1, "#FFF" ] ]

        borderWidth: 1
        outerRadius: "107%"
      , {},

        # default background
        backgroundColor: "#DDD"
        borderWidth: 0
        outerRadius: "105%"
        innerRadius: "103%"
       ]


    # the value axis
    yAxis:
      min: 0
      max: 100
      minorTickInterval: "auto"
      minorTickWidth: 1
      minorTickLength: 10
      minorTickPosition: "inside"
      minorTickColor: "#666"
      tickPixelInterval: 30
      tickWidth: 2
      tickPosition: "inside"
      tickLength: 10
      tickColor: "#666"
      labels:
        step: 2
        rotation: "auto"

      title:
        text: "°C"

      plotBands: [
        from: 30
        to: 60
        color: "#55BF3B" # green
      ,
        from: 0
        to: 30
        color: "#DDDF0D" # yellow
      ,
        from: 60
        to: 100
        color: "#DF5353" # red
       ]

    # series: [
    #   name: "Speed"
    #   data: [ 80 ]
    #   tooltip:
    #     valueSuffix: "rH"
    #  ]




    series: [
      name: "Luftfeuchtigkeit"
      data: data
      dataLabels:
        format: "<div style=\"text-align:center\"><span style=\"font-size:18px;color:#7e7e7e\">{y}</span><br/>" + "<span style=\"font-size:12px;color:silver\">%</span></div>"

      tooltip:
        valueSuffix: ""
    ]

  return



Template["roomName"].helpers
  debug: ->
    console.log "DEBUG!!!!!!!!!"
    console.log @

#
# * Call the function to built the chart when the template is rendered
#
Template["tempGauge"].rendered = ->
  @autorun (c) ->
    builtTempGaugeReactive()
    return

  return

Template["tempLineChart"].rendered = ->
  @autorun (c) ->
    builtTempLineChatReactive()
    return



  return


Template["roomName"].events
  'change ': (e, a) ->

    selector = @room.name
    newValue = $("input[name=name]").val()
    set= {}
    set['name'] = newValue
    console.log "change"
    console.log @room._id
    console.log set
    b = Rooms.update @room._id,
      $set: set


    console.log b

#
# * Template events
#
Template.tempGauge.events = "change #reactive": (event, template) ->
  newValue = $(event.target).val()

  SensorData.insert
    type: 'temp'
    houseId: 'YG3xwfqrhsx669TZe'
    value: newValue
    roomId: Router.current().params._id
    createdAt: new Date()
  templateTempDep.changed()

  return
