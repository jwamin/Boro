//
//  BoroIcon.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/8/21.
//

import SwiftUI
import BoroKit

struct BoroRootView: View {
    
    @ObservedObject var manager: BoroManager
    
    var body: some View {
        BoroIcon(boro: manager.current)
    }
}


struct BoroIcon: View {
    
    var boro: Boro
    
    //@Environment(\.colorScheme) var colorScheme: ColorScheme
    var colorScheme: ColorScheme = .light
    
    var foregroundColor: Color{
        
        if colorScheme == .dark {
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
        if colorScheme == .dark {
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
    
    private let scaleMultiplier = 0.45
    
    func body(content: Content) -> some View {
        
        content.overlay(
            GeometryReader{ proxy in
                VStack(alignment: .center,spacing: 0){
                    Text(boro.shortText())
                        .font(Font.custom("Helvetica",size: proxy.size.height * scaleMultiplier))
                    
                        .fontWeight(.bold)
                        .foregroundColor(fgcolor)
                        .lineLimit(1)
                        .allowsTightening(true)
                    
                }.frame(width: proxy.size.width,height: proxy.size.height,alignment: .center)
            }
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
