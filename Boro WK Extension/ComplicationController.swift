//
//  ComplicationController.swift
//  Boro WK Extension
//
//  Created by Joss Manger on 8/10/18.
//  Copyright © 2018 Joss Manger. All rights reserved.
//

import WatchKit
import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward,.backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        // Call the handler with the current timeline entry
        print("getting current timeline entry")
        guard let locale = (WKExtension.shared().delegate as! ExtensionDelegate).locator.borough else {
            handler(nil)
            print("no locale")
            return
        }
        
        let date = Date()
        switch complication.family {
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            let literal = #imageLiteral(resourceName: "Template/Staten")
            let imageProvider = CLKImageProvider(onePieceImage:literal)
            template.imageProvider = imageProvider
            let timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
            handler(timelineEntry)
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleText()
            let textProvider = CLKSimpleTextProvider(text: locale.getAbbrString())
            template.textProvider = textProvider
            //template.tintColor = UIColor.red
            let timelineEntry = CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
            handler(timelineEntry)
        default:
            handler(nil)
        }
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        
//        let delegate = WKExtension.shared().delegate as! ExtensionDelegate
//        let data = delegate.myComplicationData
        print("querying for template")
        
        
        
        switch complication.family {
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallSquare()
            let literal = #imageLiteral(resourceName: "Template/Utilitarian")
            let imageProvider = CLKImageProvider(onePieceImage:literal)
           template.imageProvider = imageProvider
            handler(template)
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleText()
            let textProvider = CLKSimpleTextProvider(text: "NYC")
            template.textProvider = textProvider
            template.tintColor = UIColor.red
            handler(template)
        default:
            handler(nil)
        }
        
        
        
    }
    
}
