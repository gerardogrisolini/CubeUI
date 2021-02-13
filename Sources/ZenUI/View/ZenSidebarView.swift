//
//  ZenSidebarView.swift
//  ZenUI
//
//  Created by Gerardo Grisolini on 29/12/20.
//

import SwiftUI

public struct ZenSidebarView<SidebarContent: View, Content: View>: View {
    
    let sidebarContent: SidebarContent
    let mainContent: Content
    let width: CGFloat
    
    @Binding var show: Bool
    
    public init(width: CGFloat, show: Binding<Bool>, @ViewBuilder sidebar: () -> SidebarContent, @ViewBuilder content: () -> Content) {
        self.width = width
        self._show = show
        sidebarContent = sidebar()
        mainContent = content()
    }
    
    public var body: some View {
        ZStack(alignment: .leading) {
            sidebarContent
                .frame(width: width, alignment: .center)
                .offset(x: show ? 0 : -1 * width, y: 0)
                .gesture(DragGesture().onEnded { value in
                    if value.translation.width < -50 {
                        show = false
                    }
                    if value.translation.width > 50 {
                        show = true
                    }
                })
                .animation(Animation.easeInOut.speed(2))
            mainContent
                .overlay(
                    Color.black
                        .opacity(show ? 0.25 : 0)
                        .onTapGesture {
                            show = false
                        }
                        .edgesIgnoringSafeArea(.all)
                )
                .animation(Animation.easeInOut.speed(2))
        }
    }
}

#if DEBUG
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
#endif

struct ZenSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
