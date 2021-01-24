//
//  ZenUI.swift
//  
//
//  Created by Gerardo Grisolini on 23/01/21.
//

import SwiftUI

struct ZenUI_LibraryContent: LibraryContentProvider {

    @State private var offset: CGFloat = 0
    @State private var isRefreshing: Bool = true
    @State private var index: Int = 0

    @LibraryContentBuilder public func modifiers(base: Text) -> [LibraryItem] {
        
        LibraryItem(base.modifier(CubeRotationModifier(pct: 0, translation: .exit, rotation: .next) { print("completed") }), title: "Cube Rotation", category: .effect)
        
        LibraryItem(base.transition(.cubeRotationLeft), title: "Cube Rotation Left", category: .effect)
        
        LibraryItem(base.transition(.cubeRotationRight), title: "Cube Rotation Right", category: .effect)
    }

    public var views: [LibraryItem] {
        
        LibraryItem(
            ZenScrollView(offset: $offset) {
                Text("Content")
            },
            visible: true,
            title: "Scroll View",
            category: .control,
            matchingSignature: "sow"
        )

        LibraryItem(
            ZenRefreshView(scrollOffset: $offset, isRefreshing: $isRefreshing, onRefreshing: { print("onRefreshing") }) {
                Text("Content")
            },
            visible: true,
            title: "Refresh View",
            category: .control,
            matchingSignature: "rw"
        )
        
        LibraryItem(
            ZenCubeView(index: $index, mode: .swipe) {
                Text("1")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.green)
                Text("2")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.blue)
                Text("3")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.orange)
                Text("4")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.yellow)
            },
            visible: true,
            title: "Cube View",
            category: .control,
            matchingSignature: "cw"
        )
    }
}
