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
      GeometryReader { reader in
        ZStack {
          Circle()
            .fill(bgColor)
            .frame(width: reader.size.width, height: reader.size.height, alignment: .center)
          Text(boro.shortText())
            .foregroundColor(foregroundColor)
            .font(Font.custom("Helvetica", size: reader.size.height > reader.size.width ? reader.size.width * 0.6: reader.size.height * 0.6))
        }.aspectRatio(1.0, contentMode: .fit)
      }
    }
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
