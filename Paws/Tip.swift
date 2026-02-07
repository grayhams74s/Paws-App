//
//  Tip.swift
//  Paws
//
//  Created by felix angcot jr on 1/24/26.
//

import Foundation
import TipKit

struct ButtonTip: Tip {
    var title: Text = Text("My Pets")
    var message: Text? = Text("Add some of pets")
    var image: Image? = Image(systemName: "info.circle")
}
