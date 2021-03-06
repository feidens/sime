Meteor.publish 'houses', ->
  if @userId
    Houses.find
      userId: @userId
  else
    @ready()


Meteor.publish "rooms", (houseId) ->
  check houseId, String
  Rooms.find
    houseId: houseId
  ,
    sort:
      createdAt: 1
      _id: 1

Meteor.publish "roomName", (roomId) ->
  check roomId, String
  Rooms.find
    _id: roomId
  ,
    sort:
      createdAt: 1
      _id: 1


Meteor.publish "sensorData", (roomId) ->
  check roomId, String
  SensorData.find
    roomId: roomId
  ,
    limit: 50
    sort:
      createdAt: -1
