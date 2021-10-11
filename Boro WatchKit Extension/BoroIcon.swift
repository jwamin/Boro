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
  
  var foregroundColor: Color{
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
  
  @ScaledMetric(relativeTo: .largeTitle) var scaledSize: CGFloat = 100
  @ScaledMetric(relativeTo: .largeTitle) var scaledPadding: CGFloat = 10
  
    var body: some View {
          Circle()
          .fill(bgColor)
          .overlay(
          Text(boro.shortText())
            .font(Font.custom("Helvetica", size: scaledSize))
            .fontWeight(.bold)
            .foregroundColor(foregroundColor)
            .lineLimit(1)
            .allowsTightening(true)
            .minimumScaleFactor(0.01)
            .truncationMode(.tail)
            .padding([.leading,.trailing], scaledPadding)
          )
        .aspectRatio(1.0, contentMode: .fit)
        .edgesIgnoringSafeArea(.all)
    }
}

struct BoroIcon_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        ForEach(Boro.allCases) { boro in
          BoroIcon(boro: boro)
        }
        //BoroIcon(boro: .template).previewLayout(.fixed(width: 1024, height: 1024))
      }
    }
}
