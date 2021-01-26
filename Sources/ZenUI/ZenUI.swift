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
    @State private var show: Bool = true
    @State private var index: Int = 0

    @LibraryContentBuilder public func modifiers(base: Text) -> [LibraryItem] {
        
        LibraryItem(base.modifier(NavigationToolbarModifier(title: "", mode: .large)), title: "Navigation Toolbar", category: .control)
        
        LibraryItem(base.modifier(CubeRotationModifier(pct: 0, translation: .exit, rotation: .next) { print("completed") }), title: "Cube Rotation", category: .effect)
        
        LibraryItem(base.transition(.cubeRotationLeft), title: "Cube Rotation Left", category: .effect)
        
        LibraryItem(base.transition(.cubeRotationRight), title: "Cube Rotation Right", category: .effect)
    }

    public var views: [LibraryItem] {
        
        LibraryItem(
            ZenNavigationView(transitionType: .default) {
                // Main content here
            },
            visible: true,
            title: "Navigation Stack",
            category: .control,
            matchingSignature: "znv"
        )

        LibraryItem(
            ZenSidebarView(width: 300, show: $show) {
                // Sidebar content here
            } content: {
                // Main content here
            },
            visible: true,
            title: "Sidebar View",
            category: .control,
            matchingSignature: "zsv"
        )

        LibraryItem(
            ZenScrollView(offset: $offset) {
                // Main content here
            },
            visible: true,
            title: "Scroll View",
            category: .control,
            matchingSignature: "zsw"
        )

        LibraryItem(
            ZenRefreshView(scrollOffset: $offset, isRefreshing: $isRefreshing, onRefreshing: { }) {
                // Main content here
            },
            visible: true,
            title: "Refresh View",
            category: .control,
            matchingSignature: "zrw"
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
