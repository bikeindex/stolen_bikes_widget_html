# Recent stolen bikes & search widget

Alert people to recent thefts! Add a convenient way to search for stolen bikes right on your page.

![Example widget display](readme_example.png)

All you need to do is include this HTML snippet where you would like the widget to appear:

```html
<div id="binx_stolen_widget"></div>
```

And add this to the header of your page:

```html
<script src="http://widget.bikeindex.org/include.js"></script>
```

#### View an example of it on [IndyCog](http://indycog.org/stolenbikes)!

===

### Extra options

A few options for customization and configuration:

| property | what it does | default |
| -------- | ------------ | ------------- |
| `data-location` | Find stolen bikes near this location first (address, city, state or lat/long) | Shows recent stolen near ip geolocation |
| `data-height` | max-height for the widget in pixels | 400px |
| `data-norecent` | Boolean - whether or not it should fetch recent stolen bikes (it starts just as a search widget) | false |
| `data-nocache` | Don't store recent results in localstorage. For development purposes | false |

Set the options by adding the attributes and value to the `div` you add to your page. For example:

```html
<div id="binx_stolen_widget" data-location="Portland, OR" data-height="1000"></div>
```

(This sets the initial search to Portland, OR and makes the widget a max of 1000px high.)



### Under the hood

- Saves the response from the Bike Index API in localStorage for 3 hours.

- Requires jQuery. Sorry.

- You can use it however you want (MIT license for those who care)

- To run it locally `bundle install` and run `jekyll serve`. Open the url that is printed out on your console.

- This site was built with [jekyll](http://jekyllrb.com) and [jekyll-asset-pipeline](https://github.com/matthodan/jekyll-asset-pipeline) (from the compile folder). Then Jekyll was removed. Let's just say it's in transition right now ;)

- This site is deployed using github pages and cloudflare universal ssl. You can access it at https://widget.bikeindex.org


===

Made with all the :doughnut:s. [Bike Index](https://bikeindex.org)