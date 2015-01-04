templateDep = new Deps.Dependency()

#
# * Function to draw the line
#
builtLineChatReactive = () ->
  templateDep.depend()
  data = new Array()
  #data[0] = Session.get("reactive")  if Session.get("reactive") isnt `undefined`

  value = @Blaze.getData().sensorData
  items = value.fetch()
  categories = _.pluck(items, "createdAt")
  values = _.pluck(items, "value")
  for value in values
    data.unshift Number value
  $("#container-line-reactive").highcharts
    chart:
      type: "line"
      backgroundColor: "#fafafa"

    title:
      text: "Humidity overview"

    subtitle:
      text: "Rasperri Pi"


    yAxis:
      title:
        text: "Humidity (rH)"

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
builtGaugeReactive = () ->
  templateDep.depend()
  data = new Array()
  data[0] = 0
  #data[0] = Session.get("reactive")  if Session.get("reactive") isnt `undefined`

  value = Number @Blaze.getData().lastSensorData
  data[0] = value

  $("#container-gauge-reactive").highcharts
    chart:
      type: "gauge"
      plotBackgroundColor: null
      plotBackgroundImage: null
      plotBorderWidth: 0
      plotShadow: false
      backgroundColor: "#fafafa"


    title:
      text: "Hygrometer"

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
        text: "rH"

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


Template["gauge"].helpers
  debug: ->
    console.log "DEBUG!!!!!!!!!"
    console.log @
  topGenresChart = ->
    chart:
      plotBackgroundColor: null
      plotBorderWidth: null
      plotShadow: false

    title:
      text: @username + "'s top genres"

    tooltip:
      pointFormat: "<b>{point.percentage:.1f}%</b>"

    plotOptions:
      pie:
        allowPointSelect: true
        cursor: "pointer"
        dataLabels:
          enabled: true
          format: "<b>{point.name}</b>: {point.percentage:.1f} %"
          style:
            color: (Highcharts.theme and Highcharts.theme.contrastTextColor) or "black"

          connectorColor: "silver"

    series: [
      type: "pie"
      name: "genre"
      data: [ [ "Adventure", 45.0 ], [ "Action", 26.8 ], [ "Ecchi", 12.8 ], [ "Comedy", 8.5 ], [ "Yuri", 6.2 ] ]
     ]


#
# * Call the function to built the chart when the template is rendered
#
Template["gauge"].rendered = ->
  @autorun (c) ->
    builtGaugeReactive()
    return

  return

Template["lineChart"].rendered = ->
  @autorun (c) ->
    builtLineChatReactive()
    return

  return

#
# * Template events
#
Template.gauge.events = "change #reactive": (event, template) ->
  newValue = $(event.target).val()

  SensorData.insert
    type: 'humidity'
    houseId: 'YG3xwfqrhsx669TZe'
    value: newValue
    roomId: Router.current().params._id
    createdAt: new Date()
  templateDep.changed()

  return
