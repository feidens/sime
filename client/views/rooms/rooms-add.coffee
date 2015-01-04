Template["addRoom"].rendered = ->
  fview = FView.from(this)

  target = fview.surface or fview.view

  target.on "click", ->
    index = Rooms.find().count()
    index += 1
    Rooms.insert
      name: "Room " + "#{index}"
      houseId: Router.current().params._id
      createdAt: new Date()



  return
