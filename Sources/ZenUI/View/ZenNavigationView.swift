//
//  ZenNavigationView.swift
//  
//
//  Created by Gerardo Grisolini on 24/01/21.
//

import SwiftUI

public struct ZenNavigationView<Content: View>: View {
    
    let router: Router
    let transitionType: NavigationTransition
    let content: Content
    
    public init(router: Router = Router(), transitionType: NavigationTransition = .default, @ViewBuilder content: () -> Content) {
        self.router = router
        self.transitionType = transitionType
        self.content = content()
    }
    
    public var body: some View {
        NavigationStackView(transitionType: transitionType, navigationStack: router.navStack) {
            self.content
        }
        .environment(\.router, router)
    }
}

#if DEBUG
struct ZenNavigationView_Previews: PreviewProvider {
    @State static var show = true

    static let router = Router()
    
    static var previews: some View {
        ZenSidebarView(width: UIScreen.main.bounds.width / 1.5, show: $show) {
            List {
                Button(action: { show.toggle(); show.toggle() }, label: {
                    Image(systemName: "line.horizontal.3")
                })
                Divider()
                Button("Home") {
                    router.popToRoot()
                    router.push(content: HomePage(show: $show))
                    show.toggle()
                }
                Button("Settings") {
                    router.popToRoot()
                    router.push(content: Text("Settings").navigationToolbar(title: "Settings", trailingButtons: nil))
                    show.toggle()
                }
                Button("Account") {
                    router.popToRoot()
                    router.push(content: Text("Account").navigationToolbar(title: "Account", trailingButtons: nil))
                    show.toggle()
                }
            }
            .listStyle(SidebarListStyle())
            .zIndex(1.0)
        } content: {
            ZenNavigationView(router: router, transitionType: .default) {
                HomePage(show: $show)
            }
        }
    }
}

struct HomePage: View {
    @Binding var show: Bool
    @State private var showAlert = false

    var body: some View {
        let leftButton = Button(action: { show.toggle() }, label: {
            Image(systemName: "line.horizontal.3")
        })
        let rightButton = Button(action: { showAlert.toggle() }, label: {
            Image(systemName: "info")
        })

        VStack(spacing: 50) {
            PushView(destination: DetailPage(), destinationId: "detail") {
                Text("DetailPage")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Important message"), message: Text("NavigationView"), dismissButton: .default(Text("Got it!")))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationToolbar(title: "Home", leadingButtons: AnyView(leftButton), trailingButtons: AnyView(rightButton))
    }
}

struct DetailPage: View {
    @Environment(\.router) var router

    var body: some View {
        VStack(spacing: 50) {
            Button("InfoPage") {
                router.setCheckpoint(withId: "detail")
                router.push(content: InfoPage())
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationToolbar(title: "Detail", trailingButtons: nil)
    }
}

struct InfoPage: View {
    @Environment(\.router) var router

    var body: some View {
        VStack(spacing: 50) {
            PushView(destination: ScrollScreen()) {
                Text("ScrollScreen")
            }
            Button("Checkpoint") {
                router.popToCheckpoint()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .navigationToolbar(title: "Info")
    }
}

struct ScrollScreen: View {
    @Environment(\.router) var router

    @State private var index: Int = 0
    @State private var scrollOffset: CGFloat = 0
    @State private var isRefreshing: Bool = false
    @State private var data: [Int] = []

    var body: some View {
        ZenScrollView(offset: $scrollOffset) {
            ZenRefreshView(scrollOffset: $scrollOffset, isRefreshing: $isRefreshing, onRefreshing: refresh, refreshOffset: 200) {
        
                LazyVStack(alignment: .leading, spacing: 1) {
                    ForEach(data, id: \.self) { value in
                        Text(value.description)
                            .frame(maxWidth: .infinity)
                            .font(.title3)
                            .padding()
                    }
                }
            }
        }
        .navigationToolbar(title: "Scroll \(Int(scrollOffset))", offset: scrollOffset)
        .onAppear {
            refresh()
        }
    }
    
    private func refresh() {
        isRefreshing = true
        data.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            data.append(contentsOf: 0...30)
            isRefreshing = false
        }
    }
}
#endif
