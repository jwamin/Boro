#  Boro

## CoreLocation based WatchKit Complication for New York Boroughs.

### Notes

* `CLKComplicationTemplateCircularSmallSimpleText` is a good complication to use to prototype as all it takes is one small text provider.

### DONE

* `CLLocationManager`, `CLLocationMangerDelegate`
* `Borough` enum structure.
* `CLKComplicationTemplateCircularSmallSimpleText` complication for `Explorer` and `Color` clock faces.

### TODO

1. Implement `WKBackgroundRefreshTask` logic:

  * State for CLGeocoder info .current .changed

  * Schedule update in 8 mins

  * Check Reverse CL Geocoder, set state.

  * Update complication ONLY when .changed

  * If not updated DO NOT invalidate and reload complication

  * Schedule for another 8 mins

2. Frameworkize Locator Class using Cross Platform `.framework`:

  * using [framework hack](https://theswiftdev.com/2017/10/23/how-to-make-a-swift-framework/)
