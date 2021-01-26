//
//  ZenSidebarView.swift
//  ZenUI
//
//  Created by Gerardo Grisolini on 29/12/20.
//

import SwiftUI

struct ZenSidebarView<SidebarContent: View, Content: View>: View {
    
    let sidebarContent: SidebarContent
    let mainContent: Content
    let width: CGFloat
    
    @Binding var show: Bool
    
    init(width: CGFloat, show: Binding<Bool>, @ViewBuilder sidebar: () -> SidebarContent, @ViewBuilder content: () -> Content) {
        self.width = width
        self._show = show
        sidebarContent = sidebar()
        mainContent = content()
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            sidebarContent
                .frame(width: width, alignment: .center)
                .offset(x: show ? 0 : -1 * width, y: 0)
                .animation(Animation.easeInOut.speed(2))
            mainContent
                .overlay(
                    Group {
                        if show {
                            Color.white
                                .opacity(show ? 0.01 : 0)
                                .onTapGesture {
                                    self.show = false
                                }
                        } else {
                            Color.clear
                            .opacity(show ? 0 : 0)
                            .onTapGesture {
                                self.show = false
                            }
                        }
                    }
                )
//                .offset(x: showSidebar ? sidebarWidth : 0, y: 0)
                .animation(Animation.easeInOut.speed(2))
        }
    }
}

struct SideBarStack_Previews: PreviewProvider {
    @State static var show = false
    
    static var previews: some View {
        ZenSidebarView(width: 200, show: $show) {
            // Sidebar content here
        } content: {
            // Main content here
        }
        .edgesIgnoringSafeArea(.all)

    }
}
