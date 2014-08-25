# Recent stolen bikes widget

For the widget, all you need to do is include this HTML where you would like the widget to appear:

```
<div id="binx_stolen_widget" data-location=""></div>
```

And add this script tag to the bottom of your page:

```
<script src="http://widget.bikeindex.org/include.js"></script>
```

You can view an example of it on [VeloHut.com](http://www.velohut.com/)

===

**More documentation will be added soon!**

===


#### Running it

Locally we use [rerun](https://github.com/alexch/rerun) to restart the app on changes. Launch the app in development mode with `rerun 'rackup'`. You can run the tests with `rerun 'rake spec'` (sometimes this breaks and infinitely reloops. Srys.)

This: 

- Saves the response from the Bike Index API in localStorage for 6 hours

- It doesn't have any dependencies (i.e. doesn't require jQuery)

- You can use it however you want (MIT license for those who care)

- I haven't made a build process because I don't know if anyone cares. Tell me if you do.