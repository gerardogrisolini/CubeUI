//
//  ZenScrollView.swift
//  
//
//  Created by Gerardo Grisolini on 24/01/21.
//

import SwiftUI

public struct ZenScrollView<Content: View>: View {
    
    @State private var navBarHeight: CGFloat = 0
    @Binding var offset: CGFloat
    
    let content: Content

    public init(offset: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        _offset = offset
        self.content = content()
    }
    
    public var body: some View {
        let view = ScrollView(showsIndicators: false) {
            ZStack {
                GeometryReader { inReader in
                    Color.clear
                        .preference(key: ViewHeightKey.self, value: inReader.frame(in: .global).minY - navBarHeight - 47)
                }
                self.content
            }
            .onPreferenceChange(ViewHeightKey.self) {
                offset = $0
            }
        }
        
        #if os(macOS)
        return view
        #else
        return view
            .background(NavBarAccessor { navBar in
                navBarHeight = navBar.bounds.height
            })
        #endif
    }
}

#if DEBUG
struct ZenScrollView_Previews: PreviewProvider {
    @State static var offset: CGFloat = 0
    @State static var isRefreshing: Bool = false

    static var previews: some View {
        ZenScrollView(offset: $offset) {
            ZenRefreshView(scrollOffset: $offset, isRefreshing: $isRefreshing, onRefreshing: { print("onRefreshing") }) {

                Text("ScrollObservedView")
            }
        }
    }
}
#endif
