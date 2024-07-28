//
//  BoroKitViews.swift
//  BoroKitUI
//
//  Created by Joss Manger on 7/27/24.
//

import BoroKit
import SwiftUI

public protocol BoroKitViewProtocol: View {
    init(boro: Boro)
}


public struct BoroIconRound: BoroKitViewProtocol, View {
    
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
            .transition(.scale)
    }
}

public struct BoroIconRect: BoroKitViewProtocol, View {
    
    let boro: Boro
    let darkMode = false
    
    public init(boro: Boro) {
        self.boro = boro
    }
    
    var scheme: InitializesWithBoro & ForegroundAndBackgroundColorProviding {
        BoroColorScheme(boro: boro)
    }
    
    public var body: some View {
        Rectangle()
            .fill(scheme.backgroundColor)
            .addCircleText(boro: boro, scheme: scheme)
            .transition(.scale)
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
            ZStack(alignment: .center){
                Text(boro.shortText())
                    .font(Font.custom("Helvetica", size: scaledSize))
                    .fontWeight(.bold)
                    .foregroundColor(scheme.foregroundColor)
                    .lineLimit(1)
                    .allowsTightening(true)
                    .minimumScaleFactor(0.01)
                    .truncationMode(.tail)
                    .padding([.leading,.trailing], scaledPadding)
                if boro == .system {
                    LoadingView(scheme: scheme, dimension: scaledSize)
                }
            }
        ).aspectRatio(1.0, contentMode: .fit)
        
    }

}


struct LoadingView: View {
    
    let repeatingAnimation: Animation = {
            Animation
                .linear(duration: 5) //.easeIn, .easyOut, .linear, etc...
                .repeatForever(autoreverses: false)
        }()
    
    let scheme: ForegroundAndBackgroundColorProviding
    @State var rotation: Angle = .zero
    var dimension: CGFloat
    
    var body: some View {
        Image(systemName: "arrow.triangle.2.circlepath")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: dimension,height: dimension)
            .foregroundColor(scheme.foregroundColor)
            .rotationEffect(rotation)
            .onAppear(perform: {
                withAnimation(repeatingAnimation,{
                    rotation = .degrees(360.0)
                })
            })
    }
}


struct BoroIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(Boro.allCases) { boro in
                BoroIconRound(boro: boro)
            }
            ForEach(Boro.allCases) { boro in
                BoroIconRect(boro: boro)
            }
        }
    }
}
