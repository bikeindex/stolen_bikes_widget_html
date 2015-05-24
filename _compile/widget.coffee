root_url = window.binxw_root_url || "https://widget.bikeindex.org/"

binx_api = "https://bikeindex.org/api/v2/bikes_search/stolen?per_page=10&widget_from=#{document.domain}&"

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
    url: "#{binx_api}serial=#{serial}"
    success: (data, textStatus, jqXHR) ->
      data.serial_searched = serial
      window.appendBikes(data)

window.appendBikes = (data, setTime=null) ->
  if setTime?
    cache = 
      data: data
      time: setTime
    localStorage.setItem('binx_rstolen', JSON.stringify(cache))
  $("#binx_list_container").html(Mustache.render(binx_list_item, data))
  $('#binx_stolen_widget ul').css('max-height', $('#binx_stolen_widget').attr('data-height'))
  formatDates()
  unless data.recent_results?
    # Show the number of results unless it's recent thefts or there are no results
    if data.bikes.length > 0
      if data.bikes.length > 19
        i = " <span>(many found, showing first 20)</span>"
      else
        i = " <span>(#{data.bikes.length} found)</span>"
      $('#binx_list_container .search-response-info').append(i)

formatDates = ->
  # Make dates human readable (and shorter)
  today = new Date()
  yesterday = new Date()
  yesterday.setDate(today.getDate() - 1)
  yesterday = yesterday.toString().split(/\d{2}:/)[0]
  today = today.toString().split(/\d{2}:/)[0]
  for ds in $("#binx_list_container .date-stolen")
    sdate = new Date(parseInt($(ds).text(), 10) * 1000)
    date = sdate.toString().split(/\d{2}:/)[0]
    date = 'Today' if date == today
    date = 'Yesterday' if date == yesterday
    $(ds).text(date)

getNearbyStolen = (location, existing_bikes=[]) ->
  url = "#{binx_api}proximity=#{location}&proximity_radius=100"
  that = this
  $.ajax
    type: "GET"
    url: url
    success: (data, textStatus, jqXHR) ->
      time = new Date().getTime()
      data.recent_results = true
      # concat existing bikes, in case this is a second call
      data.bikes = existing_bikes.concat(data.bikes)
      # Disabling location display for now, till API returns location info for IP queries
      # data.location = location if location.length > 0
      # Call it again with no location if we don't have enough bikes
      # Don't call if location absent so we don't infinite loop
      if data.bikes.length < 6 && location.length > 0
        getNearbyStolen('', data.bikes)
      else
        window.appendBikes(data, time)

initializeBinxWidget = (options) ->
  Mustache.parse binx_list_item
  $('#binx_stolen_widget').html(Mustache.render(binx_widget_template, options.height))

  $('#binx_search_form').submit (event) ->
    getSerialResponse($('#binx_search').val())
    false

  $('#binxformsubm_a').click (event) ->
    getSerialResponse($('#binx_search').val())

  return true if options.norecent

  is_cached = false
  unless options.nocache
    # Check if recent stolen bikes are cached in local storage
    # Don't call the Index if they are and are less than 3 hours old
    cache = localStorage.getItem('binx_rstolen')
    time = new Date().getTime() 
    if cache? and cache.length > 0
      cache = JSON.parse(cache)
      if cache.time? and time - cache.time < 10800000
        is_cached = true
        window.appendBikes(cache.data)
  unless is_cached
    getNearbyStolen(options.location)

  
$(document).ready ->
  container = $('#binx_stolen_widget')
  options = 
    location: container.attr('data-location') ? 'ip'
    nocache: container.attr('data-nocache') ? false
    norecent: container.attr('data-norecent') ? false
  
  height = container.attr('data-height') ? 400
  height = parseInt(height, 10) - 41 # Header height
  container.attr('data-height', "#{height}px")
  initializeBinxWidget(options)
  

binx_widget_template = """
  <link href="#{root_url}assets/styles.css" rel="stylesheet" type="text/css">
  <form class="topsearcher" id="binx_search_form">
    <span class="spacing-span"></span>
    <span class="top-stripe skinny-stripe"></span>
    <span class="spacing-span"></span>
    <span class="top-stripe fat-stripe"></span>
    <span class="spacing-span"></span>
    <span class="bottom-stripe fat-stripe"></span>
    <span class="spacing-span"></span>
    <span class="bottom-stripe skinny-stripe"></span>
    <input id="binx_search" type="text" placeholder="Search for a serial number">
    <input type="submit" id="binxformsubm">
    <a href="#" class="subm" id="binxformsubm_a"><img src="#{root_url}assets/search.svg"></a>
  </form>
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
           <a class='stolen-thumb' href='https://bikeindex.org/bikes/{{id}}' target="_blank">
            <img src='{{thumb}}'>
          </a>
        {{/thumb}}
        <h4>
          <a href='https://bikeindex.org/bikes/{{id}}' target="_blank">{{title}}</a>
        </h4>
        {{#stolen}}
          <p>
            <span class='stolen-color'>Stolen</span> {{#stolen_location}}from {{stolen_location}} &mdash; {{/stolen_location}} <span class='date-stolen'>{{date_stolen}}
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
  </ul>
  {{^bikes}}
    <div class="binx-stolen-widget-list">
      {{#recent_results}}
        <h2 class='search-fail'>
          We're sorry! Something went wrong and we couldn't retrieve recent results!
          <span>We're probably working on fixing this right now, send us an email at <a href="mailto:contact@bikeindex.org">contact@bikeindex.org</a> if the problem persists</span>
        </h2>
      {{/recent_results}}
      {{#serial_searched}}
        <h2 class='search-fail'>
          No stolen bikes on the Bike Index with a serial of <span class="search-query">{{serial_searched}}</span>
        </h2>
      {{/serial_searched}}
    </div>
  {{/bikes}}
  {{#recent_results}}
    <div class="widget-info">
      Recent reported stolen bikes 
      {{#location}}
        near <em>{{location}}</em>
      {{/location}}
    </div>
  {{/recent_results}}
"""
