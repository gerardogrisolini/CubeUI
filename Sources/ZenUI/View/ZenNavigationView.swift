//
//  ZenNavigationView.swift
//  
//
//  Created by Gerardo Grisolini on 24/01/21.
//

import SwiftUI

struct ZenNavigationView<Content: View>: View {
    
    let router = Router()
    let transitionType: NavigationTransition
    let content: Content
    
    init(transitionType: NavigationTransition = .default, @ViewBuilder content: () -> Content) {
        self.transitionType = transitionType
        self.content = content()
    }
    
    var body: some View {
        NavigationStackView(transitionType: transitionType, navigationStack: router.navStack) {
            self.content
        }
        .environment(\.router, router)
    }
}

struct ZenNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        ZenNavigationView {
            Text("Hello ZenUI!")
        }
    }
}
