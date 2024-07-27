//
//  BoroKitViews.swift
//  BoroKitUI
//
//  Created by Joss Manger on 7/27/24.
//

import BoroKit
import SwiftUI

public struct BoroIcon: View {
    
    let boro: Boro
    let darkMode = false
    
    public init(boro: Boro) {
        self.boro = boro
    }
    
    var scheme: InitializesWithBoro & ForegroundAndBackgroundColorProviding {
        BoroColorScheme(boro: boro)
    }
    
    public var body: some View {
        Circle()
            .fill(scheme.backgroundColor)
            .addCircleText(boro: boro, scheme: scheme)
    }
}

extension View {
    func addCircleText(boro: Boro, scheme: InitializesWithBoro & ForegroundAndBackgroundColorProviding) -> some View {
        modifier(AddCircleText(boro: boro, scheme: scheme))
    }
}

struct AddCircleText: ViewModifier {
    
    @ScaledMetric(relativeTo: .largeTitle) var scaledSize: CGFloat = 100
    @ScaledMetric(relativeTo: .largeTitle) var scaledPadding: CGFloat = 10
    
    let boro: Boro
    
    let scheme: InitializesWithBoro & ForegroundAndBackgroundColorProviding
    
    func body(content: Content) -> some View {
        content.overlay(
            Text(boro.shortText())
                .font(Font.custom("Helvetica", size: scaledSize))
                .fontWeight(.bold)
                .foregroundColor(scheme.foregroundColor)
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.01)
                .truncationMode(.tail)
                .padding([.leading,.trailing], scaledPadding)
        )
        .aspectRatio(1.0, contentMode: .fit)
    }
    

   
    
}
