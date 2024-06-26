//
//  BoroIcon.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/8/21.
//

import SwiftUI
import BoroKit

struct BoroIcon: View {
    
    let boro: Boro
    let darkMode = false
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var foregroundColor: Color{
        
        if colorScheme == .dark && darkMode {
            return .white
        }
        
        switch(boro){
        case .brooklyn:
            return .black
        default:
            return .white
        }
    }
    
    var bgColor: Color {
        switch(boro){
        case .template:
            return .orange
        case .manhattan:
            return .red
        case .brooklyn:
            return .yellow
        case .bronx:
            return .green
        case .queens:
            return .purple
        case .statenIsland:
            return .indigo
        case .six:
            return .blue
        default:
            return .gray
        }
    }
    

    
    var body: some View {
        if colorScheme == .dark && darkMode {
            Circle().stroke(bgColor).addCircleText(boro: boro, fgColor: foregroundColor, bgcolor: bgColor)
        } else {
            Circle().fill(bgColor).addCircleText(boro: boro, fgColor: foregroundColor, bgcolor: bgColor)
        }
            
    }
}

extension View {
    func addCircleText(boro: Boro, fgColor: Color, bgcolor: Color) -> some View {
        modifier(AddCircleText(boro: boro, fgcolor: fgColor, bgcolor: bgcolor))
    }
}

struct AddCircleText: ViewModifier {
    
    @ScaledMetric(relativeTo: .largeTitle) var scaledSize: CGFloat = 100
    @ScaledMetric(relativeTo: .largeTitle) var scaledPadding: CGFloat = 10
    
    func body(content: Content) -> some View {
        content.overlay(
            Text(boro.shortText())
                .font(Font.custom("Helvetica", size: scaledSize))
                .fontWeight(.bold)
                .foregroundColor(fgcolor)
                .lineLimit(1)
                .allowsTightening(true)
                .minimumScaleFactor(0.01)
                .truncationMode(.tail)
                .padding([.leading,.trailing], scaledPadding)
        )
        .aspectRatio(1.0, contentMode: .fit)
    }
    
    let boro: Boro
    
    let fgcolor: Color
    let bgcolor: Color
   
    
}

struct BoroIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(Boro.allCases) { boro in
                BoroIcon(boro: boro)
            }

        }
    }
}
