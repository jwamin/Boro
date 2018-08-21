#  Boro

## Prototype of a `CoreLocation` based `ClockKit` Complication for New York City Boroughs.

Reports what NYC borough you are currently in based on Swift `enum`:

```
enum Borough {
    case manhattan
    case brooklyn
    case queens
    case bronx
    case statenIsland
    case outOfNYC
}

```

Automatically updates and schedules future updates 5 min from now.

Supports the `Utilitarian` (Small, Large) and `CircularSmall` CLKComplication templates.

Simple `WKInterfaceController` Interface. 

### Notes

* Will only update when `watchOS` grants a `WKApplicationRefreshBackgroundTask`. 

* More reliable when on a Wi-Fi network.

* `CLKComplicationTemplateCircularSmallSimpleText` is a good complication to use to prototype as all it takes is one small text provider.

### DONE

* `CLLocationManager`, `CLLocationMangerDelegate`.
* `Borough` enum structure.
* `enum` state-based logic with Swift property observers.
* `CLKComplicationTemplateCircularSmallSimpleText` complication for `Explorer` and `Color` clock faces.
* Runs natively on `watchOS` and `iOS` without the need for `WatchConnectivity`

### TODO

* TIghten up refresh and timeline logic.

* Frameworkize Locator Class using Cross Platform `.framework` using [framework hack](https://theswiftdev.com/2017/10/23/how-to-make-a-swift-framework/)
  
#### Frameworks Used

`WatchKit`
`ClockKit`
`CoreLocation`
`UIKit`
