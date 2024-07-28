//
//  ComplicationController.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/2/21.
//

import ClockKit
import SwiftUI
import BoroKit
import BoroKitUI

class ComplicationController: NSObject, CLKComplicationDataSource, CLKComplicationWidgetMigrator {
    
    var widgetMigrator: CLKComplicationWidgetMigrator {
        self
    }
    
    static var textProvider:(Boro) -> CLKSimpleTextProvider = { boro in
        return CLKSimpleTextProvider(text: boro.rawValue, shortText: boro.shortText())
    }
    
    let appText = CLKTextProvider(format: "Boro")
    
    // MARK: - Complication Configuration
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(identifier: "complication", displayName: "Boro", supportedFamilies: [
                CLKComplicationFamily.utilitarianSmall,
                CLKComplicationFamily.extraLarge,
                CLKComplicationFamily.graphicCorner,
                CLKComplicationFamily.graphicCircular,
                CLKComplicationFamily.circularSmall,
                CLKComplicationFamily.modularSmall,
                CLKComplicationFamily.modularLarge
            ])
            // Multiple complication support can be added here with more descriptors
        ]
        
        // Call the handler with the currently supported complication descriptors
        handler(descriptors)
    }
    
    func getWidgetConfiguration(from complicationDescriptor: CLKComplicationDescriptor, completionHandler: @escaping (CLKComplicationWidgetMigrationConfiguration?) -> Void) {
        var configuration: CLKComplicationWidgetMigrationConfiguration? = nil
        configuration = CLKComplicationStaticWidgetMigrationConfiguration(kind: "Boro", extensionBundleIdentifier: "co.jossy.Boro.watchkitapp.widget-extension")
        completionHandler(configuration)
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
        
        //Get the cached location from the manager static property
        let current = BoroManager.cached
        
        
        let text = Self.textProvider(current)
        
        var complicationForCurrentTime: CLKComplicationTimelineEntry? = nil
        
        let now = Date()
        
        switch complication.family {
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: text)
            complicationForCurrentTime = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .graphicCorner:
            let color = BoroColorScheme(boro: current).backgroundColor
            let gauge = CLKSimpleGaugeProvider(style: .fill, gaugeColor: UIColor(color) , fillFraction: current.float)
            let template = CLKComplicationTemplateGraphicCornerGaugeText(gaugeProvider: gauge, outerTextProvider: text)
            complicationForCurrentTime = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeSimpleText(textProvider: text)
            complicationForCurrentTime = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularView(BoroIcon(boro: current))
            complicationForCurrentTime = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleText(textProvider: text)
            complicationForCurrentTime = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: appText, body1TextProvider: text)
            complicationForCurrentTime = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallRingText(textProvider: text, fillFraction: current.float, ringStyle: CLKComplicationRingStyle.open)
            complicationForCurrentTime = CLKComplicationTimelineEntry(date: now, complicationTemplate: template)
        default:
            break
        }
        
        handler(complicationForCurrentTime)
        
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after the given date
        handler(nil)
    }
    
    // MARK: - Sample Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        var template: CLKComplicationTemplate? = nil
        
        let emptyTextProvider = CLKTextProvider(format: "")
        
        switch (complication.family) {
        case .graphicCorner:
            template = CLKComplicationTemplateGraphicCornerStackText(innerTextProvider: emptyTextProvider, outerTextProvider: appText)
        case .extraLarge:
            template = CLKComplicationTemplateExtraLargeSimpleText(textProvider: appText)
        case .utilitarianSmall:
            template = CLKComplicationTemplateUtilitarianSmallFlat(textProvider: appText)
        case .graphicCircular:
            template = CLKComplicationTemplateGraphicCircularView<BoroIcon>(BoroIcon(boro: .template))
        case .modularSmall:
            template = CLKComplicationTemplateModularSmallSimpleText(textProvider: appText)
        case .modularLarge:
            template = CLKComplicationTemplateModularLargeStandardBody(headerTextProvider: appText, body1TextProvider: emptyTextProvider)
        case .circularSmall:
            template = CLKComplicationTemplateCircularSmallRingText(textProvider: appText, fillFraction: 1.0, ringStyle: CLKComplicationRingStyle.open)
        default:
            break
        }
        handler(template)
    }
}


