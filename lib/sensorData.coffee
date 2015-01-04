@SensorData = new Meteor.Collection("sensorData",
  schema:
    type:
      type: String
      label: "Type of sensor"
      optional: false

    houseId:
      type: String
      label: "House id"
      optional: false

    roomId:
      type: String
      label: "Room id"
      optional: false

    value:
      type: String
      label: "Sensor Value"
      optional: false

    createdAt:
      type: Date
      optional: false
)

# Collection2 already does schema checking"
# Add custom permission rules if needed"
SensorData.allow
  insert: ->
    true

  update: ->
    false

  remove: ->
    false
