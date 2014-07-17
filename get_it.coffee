stolenBinxList = (bikes, setTime=null) ->
  # If called with setTime it means we need to store bikes in localstorage
  widget = document.getElementById('bi-stolen-widget')
  list = document.createElement('ul')
  list.setAttribute('id', 'bistole-list')
  list.innerHTML = ''
  for bike, i in bikes
    break if i > 6
    s_on = new Date(Date.parse(bike.stolen_record.date_stolen))
    s_on = s_on.toString().split(/\d{2}:/)[0]
    list_item = "<li>" 
    if bike.thumb?
      list_item +=  "<a href='#{bike.url}' class='stolen-thumb'><img src='#{bike.thumb}'></a>"

    list_item += """
      <h4>
        <a href='#{bike.url}'>#{bike.title}</a>
      </h4>
      <p>
        Stolen from #{bike.stolen_record.location}
        &mdash; on #{s_on}
      </p>
    </li>
    """
    list.innerHTML += list_item

  widget.appendChild(list)
  widget_info = document.createElement('div')
  widget_info.setAttribute('class', 'widget-info')
  widget_info.innerHTML = """
    Recent thefts near you
  """
  widget.appendChild(widget_info)
  height = getComputedStyle(document.getElementById('bistole-body')).height
  document.getElementById('bistole-list').style.height = height
  
  if setTime?
    cache = 
      bikes: bikes 
      time: setTime
    localStorage.setItem('binx_rstolen', JSON.stringify(cache))

loadBikes = (location, bikes=[]) ->
  console.log(bikes)
  req = new XMLHttpRequest()
  url = "https://bikeindex.org/api/v1/bikes?stolen=true&proximity=#{location}&proximity_radius=100"
  req.addEventListener 'readystatechange', ->
    if req.readyState is 4
      successResultCodes = [200]
      if req.status in successResultCodes
        data = eval '(' + req.responseText + ')'
        if data.bikes.length > 5
          # concat existing bikes
          bikes = bikes.concat(data.bikes)
          time = new Date().getTime() 
          stolenBinxList(bikes, time)
        else 
          console.log('we run again')
          # load any stolen bikes if there aren't 5 of them from this location,
          # or if we failed to get some back
          loadBikes('', data.bikes)
      else
        return []
        
  req.open 'GET', url, false
  req.send()

unableToBinxList = ->
  widget = document.getElementById('bi-stolen-widget')
  binx_error = document.createElement('div')
  binx_error.innerHTML = """
    <div class='binxerror'>
    <h4>Something went wrong. We couldn't get any recent stolen bikes. Check the <a href='https://bikeindex.org'>Bike Index</a> for an updated list.</h4>
    <pre>
              ~~O     
            -  /\,    
           -  -|~(*)  
          -  (*)      

         ---^------   
    </pre><p>... or maybe you should just go ride your bike</p></div>
  """
  widget.appendChild(binx_error)

do ->
  location = document.getElementById('bi-stolen-widget').getAttribute('data-location')
  is_cached = false
  # Check if recent stolen bikes are cached in local storage
  # Don't call the Index if they are and are less than 6 hours old
  cache = localStorage.getItem('binx_rstolen')
  time = new Date().getTime() 
  # if cache? and cache.length > 0
  #   cache = JSON.parse(cache)
  #   if cache.time? and time - cache.time < 21600000
  #     is_cached = true
  #     stolenBinxList(cache.bikes)
      
  # unless is_cached
  loadBikes(location)
  
  