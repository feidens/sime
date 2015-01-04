@Houses = new Meteor.Collection("houses",
  schema:
    name:
      type: String
      label: "House name"
      optional: false

    userId:
      type: String
      label: "user id"
      optional: false

    createdAt:
      type: Date
      optional: false
)

# Collection2 already does schema checking"
# Add custom permission rules if needed"
Houses.allow
  insert: ->
    false

  update: ->
    false

  remove: ->
    false
