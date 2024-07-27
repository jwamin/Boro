//
//  BoroIcon.swift
//  Boro WatchKit Extension
//
//  Created by Joss Manger on 10/8/21.
//

import SwiftUI
import BoroKit
import BoroKitUI



struct BoroIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(Boro.allCases) { boro in
                BoroIcon(boro: boro)
            }
        }
    }
}
