# Recent stolen bikes widget

<script src="include.js" type="text/javascript"></script>

#### Running it

Locally we use [rerun](https://github.com/alexch/rerun) to restart the app on changes. Launch the app in development mode with `rerun 'rackup'`. You can run the tests with `rerun 'rake spec'` (sometimes this breaks and infinitely reloops. Srys.)

This: 

- Saves the response from the Bike Index API in localStorage for 6 hours

- It doesn't have any dependencies (i.e. doesn't require jQuery)

- You can use it however you want (MIT license for those who care)

- I haven't made a build process because I don't know if anyone cares. Tell me if you do.