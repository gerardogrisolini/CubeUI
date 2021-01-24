//
//  NavigationToolbarModifier.swift
//
//
//  Created by Gerardo Grisolini on 24/01/21.
//

import SwiftUI

public struct NavigationToolbarModifier: AnimatableModifier {
    @Environment(\.router) var router
    
    private let title: String
    private let mode: NavigationBarItem.TitleDisplayMode
    private let backButton: Bool
    private let closeButton: Bool
    private var offset: CGFloat = 0

    public var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    public init(
        title: String,
        mode: NavigationBarItem.TitleDisplayMode,
        backButton: Bool,
        closeButton: Bool,
        offset: CGFloat = 0) {
        
        self.title = title
        self.mode = mode
        self.backButton = backButton
        self.closeButton = closeButton
        self.offset = offset
    }
    
    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if backButton {
                        Button(action: router.popToPrevious) {
                            Image(systemName: "arrow.left")
                        }
                    }
                    
                    Text(title)
                        .scaleEffect(mode == .inline || mode == .automatic && offset < 0 ? 1.0 : 0.0)
                        .frame(maxWidth: .infinity)

                    if closeButton {
                        Button(action: router.popToCheckpoint) {
                            Image(systemName: "xmark")
                        }
                    }
                }
                .padding(EdgeInsets(top: 56, leading: 20, bottom: 16, trailing: 20))
                .frame(height: offset > -500 ? 90 : 0)
                .offset(y: offset > -500 ? 0.0 : -90.0)

                Text(title)
                    .font(.title)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .scaleEffect(mode == .large || mode == .automatic && offset >= 0 ? 1.0 : 0.0)
                    .frame(height: mode == .inline || mode == .automatic && offset < 0 ? 0 : 50)
            
                Divider()
            }
            .background(LinearGradient(gradient: Gradient(colors: [.gray, .white]), startPoint: .top, endPoint: .bottom))
            .foregroundColor(.primary)
            //.shadow(radius: 3, x: 0, y: 3)

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .animation(NavigationStack.defaultEasing)
        .edgesIgnoringSafeArea(.top)
    }
}

extension View {
    public func navigationToolbar(title: String = "", mode: NavigationBarItem.TitleDisplayMode = .automatic, backButton: Bool = true, closeButton: Bool = true, offset: CGFloat = 0) -> some View {

        return self
            .modifier(NavigationToolbarModifier(title: title, mode: mode, backButton: backButton, closeButton: closeButton, offset: offset))
    }
}
