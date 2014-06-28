# Recent stolen bikes widget

_A small, lightweight widget to put on your web-blog or tumblr or the geocities or whatever_

![Stolen Bike Widget](https://github.com/sethherr/stolen_bikes_widget_html/blob/master/screenshot.png)

### Alert people who visit your site to recent bike thefts!

[View a live example!](http://sethherr.github.io/stolen_bikes_widget_html/example)

The easiest way to use this is to add an iFrame of this github page to your interweb page:

    <iframe src="http://sethherr.github.io/stolen_bikes_widget_html" style="width: 500px; border: none;"></iframe>

It's set up for Chicago (because the Windy City is delightful), but that's easily changed -

Fork the repository and update the `data-location` property of the only element in [index.html](https://github.com/sethherr/stolen_bikes_widget_html/blob/master/index.html#L7).
    
    <div id="bi-stolen-widget" data-location="Chicago"></div>

... and then change the location of the iFrame to be your username and repository on GitHub

You can also just add the code from [index.html](https://github.com/sethherr/stolen_bikes_widget_html/blob/master/index.html) to your page if you'd prefer.


### Tech stuff

I don't know if people actually want this, but since the Bike Index has a [WordPress plugin](https://github.com/purcebr/bike-index-listings) it seemed neglectful to not offer one for people who aren't on WP.

This: 

- Saves the response from the Bike Index API in localStorage for 6 hours

- It doesn't have any dependencies (i.e. doesn't require jQuery)

- You can use it however you want (MIT license for those who care)

- I haven't made a build process because I don't know if anyone cares. Tell me if you do.