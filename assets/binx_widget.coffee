root_url = "http://binx-widget.herokuapp.com/"

Array::uniq = ->
  output = {}
  output[@[key]] = @[key] for key in [0...@length]
  value for key, value of output

trim = (str) ->
  str.replace(/^\s\s*/, "").replace /\s\s*$/, ""

getSerialResponse = (serial) ->
  base_url = $('#search_serials').attr('data-target')
  that = this
  $.ajax
    type: "GET"
    url: "https://bikeindex.org/api/v1/bikes?serial=#{serial}"
    success: (data, textStatus, jqXHR) ->
      data.serial_searched = serial
      that.appendBikes(data)

appendBikes = (data, setTime=null) ->
  if setTime?
    cache = 
      data: data
      time: setTime
    localStorage.setItem('binx_rstolen', JSON.stringify(cache))
  $("#binx_list_container").html(Mustache.render(binx_list_item, data))
  for ds in $("#binx_list_container .date-stolen")
    ds = $(ds)
    sdate = new Date(Date.parse(ds.text().trim()))
    ds.text(sdate.toString().split(/\d{2}:/)[0])
  unless data.recent_results?
    # Show the number of results unless it's recent thefts or there are no results
    if data.bikes.length > 0
      if data.bikes.length > 19
        i = " <span>(many found, showing first 20)</span>"
      else
        i = " <span>(#{data.bikes.length} found)</span>"
        
      $('#binx_list_container .search-response-info').append(i)

# getFuzzySerialResponse = (serial) ->
#   base_url = $('#multiserial_fuzzy').attr('data-target')
#   that = this
#   $.ajax
#     type: "GET"
#     url: "#{base_url}?serial=#{serial}"
#     success: (data, textStatus, jqXHR) ->
#       that.appendBikes(data.bikes, serial, true)

getNearbyStolen = (location) ->
  url = "https://bikeindex.org/api/v1/bikes?stolen=true&proximity=#{location}&proximity_radius=100"
  base_url = $('#search_serials').attr('data-target')
  that = this
  $.ajax
    type: "GET"
    url: url
    success: (data, textStatus, jqXHR) ->
      time = new Date().getTime() 
      data.recent_results = true
      appendBikes(data, time)


$(document).ready ->
  Mustache.parse binx_list_item
  $('#binx_stolen_widget').html(Mustache.render(binx_widget_template))

  is_cached = false
  # Check if recent stolen bikes are cached in local storage
  # Don't call the Index if they are and are less than 6 hours old
  cache = localStorage.getItem('binx_rstolen')
  time = new Date().getTime() 
  if cache? and cache.length > 0
    cache = JSON.parse(cache)
    if cache.time? and time - cache.time < 21600000
      is_cached = true
      appendBikes(cache.data)

  unless is_cached
    getNearbyStolen($('#binx_stolen_widget').attr('data-location'))
  
  $('#binx_subm').click (event) ->
    getSerialResponse($('#binx_search').val())


binx_widget_template = """
  <link href="#{root_url}styles.css" rel="stylesheet" type="text/css">
  <div class="topsearcher">
    <span class="spacing-span"></span>
    <span class="top-stripe skinny-stripe"></span>
    <span class="spacing-span"></span>
    <span class="top-stripe fat-stripe"></span>
    <span class="spacing-span"></span>
    <span class="bottom-stripe fat-stripe"></span>
    <span class="spacing-span"></span>
    <span class="bottom-stripe skinny-stripe"></span>
    <input id="binx_search" type="text" placeholder="Search for a serial number">
    <a href="#" class="subm" id="binx_subm"><img src="#{root_url}search.svg"></a>
  </div>
  <div class='binxcontainer' id='binx_list_container'></div>
"""
binx_list_item = """
  {{#serial_searched}}
    <h2 class="search-response-info">Bikes with serial numbers matching <em>{{serial_searched}}</em></h2>
  {{/serial_searched}}
  <ul>
    {{#bikes}}
      <li class='{{#stolen}}stolen{{/stolen}}'>
        {{#thumb}}
           <a class='stolen-thumb' href='{{url}}' target="_blank">
            <img src='{{thumb}}'>
          </a>
        {{/thumb}}
        <h4>
          <a href='{{url}}' target="_blank">{{title}}</a>
        </h4>
        {{#stolen}}
          <p>
            <span class='stolen-color'>Stolen</span> {{#stolen_record.location}}from {{stolen_record.location}} &mdash; {{/stolen_record.location}} on <span class='date-stolen'>{{stolen_record.date_stolen}}
          </p>
        {{/stolen}}
        <p>
          Serial: <span class='serial-text'>{{serial}}</span>
        </p>
        {{^stolen}}
          <p class="not-stolen">Bike is not marked stolen</p>
        {{/stolen}}
      </li>
    {{/bikes}}
    {{^bikes}}
      {{#recent_results}}
        <h2 class='search-fail'>
          We're sorry! Something went wrong and we couldn't retrieve recent results!
          <span>We're probably working on fixing this right now, send us an email at <a href="mailto:contact@bikeindex.org">contact@bikeindex.org</a> if the problem persists</span>
        </h2>
      {{/recent_results}}
      {{#serial_searched}}
        <h2 class='search-fail'>
          No bikes found on the Bike Index with a serial of <span class="search-query">{{serial_searched}}</span>
        </h2>
      {{/serial_searched}}
    {{/bikes}}
  </ul>
  {{#recent_results}}
    <div class="widget-info">
      Recent reported stolen bikes
    </div>
  {{/recent_results}}
"""
