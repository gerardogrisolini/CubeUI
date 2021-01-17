//
//  RefreshView.swift
//  ZenUI
//
//  Created by Gerardo Grisolini on 14/01/21.
//

import SwiftUI

public struct RefreshView<Content: View>: View {
        
    @Binding var offset: CGFloat
    @Binding var isRefresh: Bool
    @State private var navBarHeight: CGFloat = 0
    
    private let onRefresh: () -> ()
    private let content: Content
    private var icon: AnyView?
    
    public init(
        offset: Binding<CGFloat>,
        isRefresh: Binding<Bool>,
        onRefresh: @escaping () -> (),
        icon: AnyView? = nil,
        @ViewBuilder content: () -> Content
    ) {
        _offset = offset
        _isRefresh = isRefresh
        self.onRefresh = onRefresh
        self.content = content()
        self.icon = icon
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            if isRefresh {
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
                    offset = $0
                    if !isRefresh && offset > 100 {
                        isRefresh = true
                        onRefresh()
                    }
                }
                .background(NavBarAccessor { navBar in
                    navBarHeight = navBar.bounds.height
                })
            }
        }
    }
}


struct RefreshView_Previews: PreviewProvider {
    @State static var offset: CGFloat = 0
    @State static var isRefresh: Bool = true
    
    static var previews: some View {
        
        RefreshView(
            offset: $offset,
            isRefresh: $isRefresh,
            onRefresh: { print("onRefresh") },
            icon: AnyView(Image(systemName: "message"))
        ) {
            
            Text("\(offset) - \(isRefresh.description)")
                .font(.title)
                .frame(maxWidth: .infinity)
        }
    }
}
