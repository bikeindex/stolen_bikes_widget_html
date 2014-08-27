# Recent stolen bikes & search widget

Alert people to recent thefts! Give people a convenient way to search for stolen bikes right on your page!

<!-- ![Example widget display](https://github.com/bikeindex/stolen_bikes_widget_html/blob/master/example.png?raw=true) -->
![Example widget display](example.png)

All you need to do is include this HTML snippet where you would like the widget to appear:

```html
<div id="binx_stolen_widget"></div>
```

And add this to the header of your page:

```html
<script src="http://widget.bikeindex.org/include.js"></script>
```

#### View an example of it on [VeloHut.com](http://www.velohut.com#binx_stolen_widget)!

===

### Extra options

A few options for customization and configuration:

| property | what it does | blank/default |
| -------- | ------------ | ------------- |
| `data-location` | Find stolen bikes near this location first (address, city, state, lat/long) | Shows bikes near where we guess they are |
| `data-height` | max-height for the widget in pixels | max-height of 500px |
| `data-norecent` | Boolean - whether or not it should fetch recent stolen bikes | Default to false |
| `data-nocache` | Don't store recent stolen bikes in localstorage | For development purposes |

Set the options by adding the attributes and value to the `div` you add to your page. For example:

```html
<div id="binx_stolen_widget" data-location="Portland, OR" data-height="1000"></div>
```

(This sets the initial search to Portland, OR and makes the widget a max of 1000px high.)



### Under the hood

- Saves the response from the Bike Index API in localStorage for 3 hours

- This widget requires jQuery. Sorry.

- You can use it however you want (MIT license for those who care)

- Locally we use [rerun](https://github.com/alexch/rerun) to restart the app on changes. Launch the app in development mode with `rerun 'rackup'`.

- If you run it locally, the index page doesn't cache and references the separate js files to make development easier.

===

Made with all the :doughnut:s. [Bike Index](https://bikeindex.org)