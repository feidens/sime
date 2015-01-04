Accounts.onCreateUser (options, user) ->
  Houses.insert
    name: "defaultHouse"
    userId: user._id
    createdAt: new Date()
  user
