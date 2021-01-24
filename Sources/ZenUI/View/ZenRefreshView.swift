//
//  ZenRefreshView.swift
//  ZenUI
//
//  Created by Gerardo Grisolini on 14/01/21.
//

import SwiftUI

public struct ZenRefreshView<Content: View>: View {
        
    @Binding var scrollOffset: CGFloat
    @Binding var isRefreshing: Bool
    @State private var navBarHeight: CGFloat = 0
    
    private let refreshOffset: CGFloat
    private let onRefreshing: () -> ()
    private let content: Content
    private var icon: AnyView?
    
    public init(
        scrollOffset: Binding<CGFloat>,
        isRefreshing: Binding<Bool>,
        onRefreshing: @escaping () -> (),
        refreshOffset: CGFloat = 100,
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
            
            self.content
        }
        .onChange(of: scrollOffset) { value in
            if !isRefreshing && scrollOffset > refreshOffset {
                isRefreshing = true
                onRefreshing()
            }
        }
    }
}


#if DEBUG
struct ZenRefreshView_Previews: PreviewProvider {
    @State static var scrollOffset: CGFloat = 0
    @State static var isRefreshing: Bool = true
    
    static var previews: some View {
        
        ZenRefreshView(
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
