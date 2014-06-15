# Definitely don't need jQuery, but including it for simplicities sake.
$(document).ready ->
  $.ajax
    type: "GET"
    url: "https://bikeindex.org/api/v1/bikes?stolen=true"
    success: (data, textStatus, jqXHR) ->
      list = ''
      for bike in data.bikes
        list_item = "<li>" 
        if bike.thumb?
          list_item +=  "<a href='#{bike.url}' class='stolen-thumb'><img src='#{bike.thumb}'></a>"

        list_item += """
          <h4>
            <a href='#{bike.url}'>#{bike.title}</a>
          </h4>
          <p>Stolen from
          #{bike.stolen_record.location}
          </p>
        </li>
        """
        list += list_item

      $('#bi-stolen-widget ul').append(list)