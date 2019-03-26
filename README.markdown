# Recent stolen bikes & search widget

Alert people to recent thefts! Add a convenient way to search for stolen bikes right on your page.

![Example widget display](screenshot.jpg)

All you need to do is include this HTML snippet where you would like the widget to appear:

```html
<div id="binx-stolen-widget"></div>
```

And add this to the header of your page:

```html
<script src="http://widget.bikeindex.org/stolen-widget.js"></script>
```

### Extra options

A few options for customization and configuration:

| property | what it does | default |
| -------- | ------------ | ------------- |
| `location` | Find stolen bikes near this location first (address, city, state or lat/long) | Shows recent for  |
| `height` | max-height for the widget in pixels | 400px |
| `recentResults` | Boolean - whether or not it should fetch recent stolen bikes (it starts just as a search widget) | true |
| `cacheResults` | Store recent results for three hours in localstorage | true |
| `elementId` | the id of the div element for the widget | binx-stolen-widget |


### Examples

Set the options when configuring the widget within the script tag:

```html
<!-- Override default options -->

<script>
  BikeIndex.init({
    height: 400,
    cacheResults: true,
    recentResults: true,
    location: 'Portland, OR',
    elementId: 'some-other-id',
  });
</script>
```

```html
<!-- No options -->

<script>
  BikeIndex.init();
</script>
```


## Running locally

1.  Install dependencies

```
yarn
```

2. Start webpack server in development mode

```
yarn start
```
  * This should open the widget in your browser [here](http://localhost:8080/)

## Testing

1. Run the script to lint and run the jest specs:

```
yarn test

// OR

yarn watch
```



Made with all the :doughnut:s. [Bike Index](https://bikeindex.org)