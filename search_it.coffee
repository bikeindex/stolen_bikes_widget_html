Array::uniq = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

trim = (str) ->
  str.replace(/^\s\s*/, "").replace /\s\s*$/, ""

unlockSearch = ->
  $('#multiserial_fuzzy, #search_serials').addClass('ms_unlocked')

getSerialResponse = (serial) ->
  base_url = $('#search_serials').attr('data-target')
  that = this
  $.ajax
    type: "GET"
    url: "https://bikeindex.org/api/v1/bikes?serial=#{serial}"
    success: (data, textStatus, jqXHR) ->
      that.appendBikes(data.bikes)

bikeList = (bikes) ->
  list = ''
  for bike, i in bikes
    break if i > 8
    list += '<li>'
    if bike.thumb?
      list +=  "<a href='#{bike.url}' class='stolen-thumb'><img src='#{bike.thumb}'></a>"
    list += "<h4><a href='#{bike.url}'>#{bike.title}</a></h4>"
    if bike.stolen
      s_on = new Date(Date.parse(bike.stolen_record.date_stolen))
      s_on = s_on.toString().split(/\d{2}:/)[0]
      list += "<p>Stolen from #{bike.stolen_record.location} &mdash; on #{s_on}</p>"
    list += "<p>Serial: <span class='serial-text'>#{bike.serial}</span></p>"
  list

appendBikes = (bikes, fuzzy=false) ->
  html = ""
  $("#bi-stolen-widget ul").html(bikeList(bikes))

searchSerialsFuzzy = (event) ->
  event.preventDefault()
  return true unless $('#multiserial_fuzzy').hasClass('ms_unlocked')
  $('#multiserial_fuzzy').removeClass('ms_unlocked')
  for li in $('#serials_submitted li')
    serial = $(li).attr('name')
    @getFuzzySerialResponse(serial)
  

getFuzzySerialResponse = (serial) ->
  base_url = $('#multiserial_fuzzy').attr('data-target')
  that = this
  $.ajax
    type: "GET"
    url: "#{base_url}?serial=#{serial}"
    success: (data, textStatus, jqXHR) ->
      if data.bikes.length > 1
        that.appendBikes(data.bikes, serial, true)

getNearbyStolen = (location) ->
  url = "https://bikeindex.org/api/v1/bikes?stolen=true&proximity=#{location}&proximity_radius=100"
  base_url = $('#search_serials').attr('data-target')
  that = this
  $.ajax
    type: "GET"
    url: url
    success: (data, textStatus, jqXHR) ->
      that.appendBikes(data.bikes)


$(document).ready ->
  getNearbyStolen($('#bi-stolen-widget').attr('data-location'))
  # $('#multi_serial_search').change (event) ->
  #   unlockSearch()
  $('#bi_submit').click (event) ->
    getSerialResponse($('#bi_search').val())