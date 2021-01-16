//
//  ViewHeightKey.swift
//  
//
//  Created by Gerardo Grisolini on 16/01/21.
//

import SwiftUI

struct ViewHeightKey: PreferenceKey {
    static var defaultValue = CGFloat.zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}
