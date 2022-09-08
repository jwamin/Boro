//
//  ContentView.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/2/21.
//

import SwiftUI
import BoroKit

struct BoroView: View {
  
  var current: Boro
  
    @ScaledMetric(relativeTo: .largeTitle) var scaledSize: CGFloat = 100
    @ScaledMetric(relativeTo: .largeTitle) var scaledPadding: CGFloat = 10
    
    
    var body: some View {
      Circle().stroke(
        style: StrokeStyle(lineWidth: 2, lineCap: CGLineCap.round, lineJoin: CGLineJoin.round, miterLimit: 2, dash: [1], dashPhase: 1)
      ).overlay(content: {
          Text(current.shortText())
            .font(Font.custom("Helvetica", size: scaledSize))
            .fontWeight(.bold)
            //.foregroundColor(foregroundColor)
            .lineLimit(1)
            .allowsTightening(true)
            .minimumScaleFactor(0.01)
            .truncationMode(.tail)
            
            .padding([.leading,.trailing], scaledPadding)
          
      }).foregroundColor(Color.red)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      Group{
        BoroView(current: .manhattan)
        BoroView(current: .bronx)
        BoroView(current: .queens)
        BoroView(current: .brooklyn)
        BoroView(current: .statenIsland)
        BoroView(current: .out)
      }
    }
}
