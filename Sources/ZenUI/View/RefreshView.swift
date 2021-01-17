//
//  RefreshView.swift
//  ZenUI
//
//  Created by Gerardo Grisolini on 14/01/21.
//

import SwiftUI


public struct RefreshView<Content: View>: View {
        
    @StateObject private var viewModel = RefreshViewModel()
    @Binding var offset: CGFloat
    @Binding var isRefresh: Bool
    
    private let onRefresh: () -> ()
    private let content: Content

    public init(
        offset: Binding<CGFloat>,
        isRefresh: Binding<Bool>,
        onRefresh: @escaping () -> (),
        @ViewBuilder content: () -> Content
    ) {
        _offset = offset
        _isRefresh = isRefresh
        self.onRefresh = onRefresh
        self.content = content()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            if isRefresh {
                ProgressView()
                    .padding()
                    .background(Color.white.opacity(0.75).clipShape(Circle()))
                    .padding()
                    .zIndex(1.0)
            }
            ScrollView {
                ZStack {
                    GeometryReader { inReader in
                        Color.clear
                            .preference(key: ViewHeightKey.self, value: inReader.frame(in: .global).minY - viewModel.navBarHeight - 47)
                    }
                    self.content
                }
                .onChange(of: isRefresh) { value in
                    viewModel.isRefresh = value
                }
                .onReceive(viewModel.$isRefresh, perform: { value in
                    if !isRefresh && value == true {
                        onRefresh()
                    }
                    isRefresh = value
                })
                .onPreferenceChange(ViewHeightKey.self) {
                    viewModel.offset = $0
                    offset = $0
                }
                .background(NavBarAccessor { navBar in
                    viewModel.navBarHeight = navBar.bounds.height
                })
            } 
        }
    }
}


struct RefreshView_Previews: PreviewProvider {
    @State static var offset: CGFloat = 0
    @State static var isRefresh: Bool = true
    
    static var previews: some View {
        
        RefreshView(offset: $offset, isRefresh: $isRefresh, onRefresh: { print("onRefresh") }) {
            
            Text("\(offset) - \(isRefresh.description)")
                .font(.title)
                .frame(maxWidth: .infinity)
        }
    }
}
