@Rooms = new Meteor.Collection("rooms",
  schema:
    name:
      type: String
      label: "Room name"
      optional: false

    houseId:
      type: String
      label: "House id"
      optional: false

    createdAt:
      type: Date
      optional: false
)

# Collection2 already does schema checking"
# Add custom permission rules if needed"
Rooms.allow
  insert: ->
    true

  update: ->
    false

  remove: ->
    false
