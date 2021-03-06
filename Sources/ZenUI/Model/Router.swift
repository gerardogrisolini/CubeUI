//
//  Router.swift
//  
//
//  Created by Gerardo Grisolini on 24/01/21.
//

import SwiftUI

public struct RouterKey: EnvironmentKey {
    public static let defaultValue: Router = Router()
}

extension EnvironmentValues {
    public var router: Router {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}

public class Router {
    
    let navStack = NavigationStack(easing: Animation.easeOut(duration: 0.2))
    private(set) public var checkpoint: String? = nil

    public init() { }
    
    public func setCheckpoint(withId: String) {
        checkpoint = withId
    }

    public func removeCheckpoint() {
        checkpoint = nil
    }

    public func popToRoot() {
        navStack.pop(to: .root)
    }

    public func popToCheckpoint() {
        if let cp = checkpoint {
            navStack.pop(to: .view(withId: cp))
            checkpoint = nil
        } else {
            popToRoot()
        }
    }

    public func popToPrevious() {
        navStack.pop(to: .previous)
    }
    
    public func pop(withId: String) {
        navStack.pop(to: .view(withId: withId))
    }

    public func push<T>(content: T, withId: String? = nil) where T : View {
        if let withId = withId {
            navStack.push(content, withId: withId)
        } else {
            navStack.push(content)
        }
    }
}
