//
//  ComplicationController.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/2/21.
//

import ClockKit
import CoreLocation
import BoroKit


class ComplicationController: NSObject, CLKComplicationDataSource {
  
  // MARK: - Complication Configuration
  
  private let coder = CLGeocoder()
  private let location = CLLocationManager()
  private let queue = DispatchQueue(label: "com.jossy.clockkit.background", attributes: .concurrent)
  private let dispatchGroup = DispatchGroup()
  
  
  override init() {
    super.init()
    location.delegate = self
    location.requestWhenInUseAuthorization()
  }
  
  func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
    let descriptors = [
      CLKComplicationDescriptor(identifier: "complication", displayName: "Boro", supportedFamilies: [CLKComplicationFamily.graphicCorner])
      // Multiple complication support can be added here with more descriptors
    ]
    
    // Call the handler with the currently supported complication descriptors
    handler(descriptors)
  }
  
  func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
    // Do any necessary work to support these newly shared complication descriptors
  }
  
  // MARK: - Timeline Configuration
  
  func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
    // Call the handler with the last entry date you can currently provide or nil if you can't support future timelines
    handler(nil)
  }
  
  func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
    // Call the handler with your desired behavior when the device is locked
    handler(.showOnLockScreen)
  }
  
  // MARK: - Timeline Population
  
  func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
    // Call the handler with the current timeline entry
 
  
    
    queue.async { [weak self] in
      self?.location.requestLocation()
    }
 
    
    dispatchGroup.enter()
    dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
      
      if let location = self?.location.location {
       
        self?.coder.reverseGeocodeLocation(location) { placemarks, error in
          
          if error != nil {
            handler(nil)
          }
          
          if let current = Boro(placemark: placemarks!.first!) {
            let text = CLKTextProvider(format: current.rawValue)
            let template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: text, outerTextProvider: text)
            let complicationTimelineEntry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(complicationTimelineEntry)
            return
          }
          
        }
        
      } else {
        handler(nil)
      }
    }
    
    dispatchGroup.wait()
    
    }
  
  func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
    // Call the handler with the timeline entries after the given date
    handler(nil)
  }
  
  // MARK: - Sample Templates
  
  func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
    // This method will be called once per supported complication, and the results will be cached
    var template: CLKComplicationTemplate? = nil
    
    let textProvider = CLKTextProvider(format: "Boro")
    
    switch (complication.family) {
    case .graphicCorner:
      template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: textProvider, outerTextProvider: textProvider)
    default:
      break
    }
    handler(template)
  }
}


extension ComplicationController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    DispatchQueue.main.async { [weak self] in
      self?.dispatchGroup.leave()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    DispatchQueue.main.async { [weak self] in
      self?.dispatchGroup.leave()
    }
  }
  
}
