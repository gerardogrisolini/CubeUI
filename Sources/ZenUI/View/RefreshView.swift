//
//  RefreshView.swift
//  ZenUI
//
//  Created by Gerardo Grisolini on 14/01/21.
//

import SwiftUI

public struct RefreshView<Content: View>: View {
        
    @Binding var scrollOffset: CGFloat
    @Binding var isRefreshing: Bool
    @State private var navBarHeight: CGFloat = 0
    
    let refreshOffset: CGFloat
    private let onRefreshing: () -> ()
    private let content: Content
    private var icon: AnyView?
    
    public init(
        scrollOffset: Binding<CGFloat>,
        refreshOffset: CGFloat = 100,
        isRefreshing: Binding<Bool>,
        onRefreshing: @escaping () -> (),
        icon: AnyView? = nil,
        @ViewBuilder content: () -> Content
    ) {
        _scrollOffset = scrollOffset
        _isRefreshing = isRefreshing
        self.refreshOffset = refreshOffset
        self.onRefreshing = onRefreshing
        self.content = content()
        self.icon = icon
    }
    
    public var body: some View {
        ZStack(alignment: .top) {

            if isRefreshing {
                if let icon = icon {
                    icon
                } else {
                    ProgressView()
                        .padding()
                        .background(Color.white.opacity(0.85).clipShape(Circle()))
                        .padding()
                        .zIndex(1.0)
                }
            }
            ScrollView {
                ZStack {
                    GeometryReader { inReader in
                        Color.clear
                            .preference(key: ViewHeightKey.self, value: inReader.frame(in: .global).minY - navBarHeight - 47)
                    }
                    self.content
                }
                .onPreferenceChange(ViewHeightKey.self) {
                    scrollOffset = $0
                    if !isRefreshing && scrollOffset > refreshOffset {
                        isRefreshing = true
                        onRefreshing()
                    }
                }
                .background(NavBarAccessor { navBar in
                    navBarHeight = navBar.bounds.height
                })
            }
        }
    }
}


#if DEBUG
struct RefreshView_Previews: PreviewProvider {
    @State static var scrollOffset: CGFloat = 0
    @State static var isRefreshing: Bool = true
    
    static var previews: some View {
        
        RefreshView(
            scrollOffset: $scrollOffset,
            isRefreshing: $isRefreshing,
            onRefreshing: { print("onRefreshing") },
            icon: AnyView(Image(systemName: "message"))
        ) {
            Text("\(scrollOffset) - \(isRefreshing.description)")
                .font(.title)
                .frame(maxWidth: .infinity)
        }
    }
}
#endif
