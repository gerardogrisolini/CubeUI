//
//  NavigationToolbarModifier.swift
//
//
//  Created by Gerardo Grisolini on 24/01/21.
//

import SwiftUI
import NavigationStack

public struct NavigationToolbarModifier: AnimatableModifier {
    @Environment(\.router) var router
    
    private let title: String
    private let mode: TitleDisplayMode
    private let leadingButtons: AnyView?
    private let trailingButtons: AnyView?
    private var offset: CGFloat = 0

    public var animatableData: CGFloat {
        get { offset }
        set { offset = newValue }
    }

    public init(
        title: String,
        mode: TitleDisplayMode,
        leadingButtons: AnyView? = nil,
        trailingButtons: AnyView? = nil,
        offset: CGFloat = 0) {
        
        self.title = title
        self.mode = mode
        self.leadingButtons = leadingButtons
        self.trailingButtons = trailingButtons
        self.offset = offset
    }
    
    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    if let leadingButtons = leadingButtons {
                        leadingButtons
                    }
                    
                    Text(title)
                        .scaleEffect(mode == .inline || mode == .automatic && offset < 0 ? 1.0 : 0.0)
                        .frame(maxWidth: .infinity)

                    if let trailingButtons = trailingButtons {
                        trailingButtons
                    }
                }
                .padding(EdgeInsets(top: 56, leading: 20, bottom: 16, trailing: 20))
                .frame(height: offset > -500 ? 88 : 0)
                .offset(y: offset > -500 ? 0.0 : -90.0)

                Text(title)
                    .font(.title)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .scaleEffect(mode == .large || mode == .automatic && offset >= 0 ? 1.0 : 0.0)
                    .frame(height: mode == .inline || mode == .automatic && offset < 0 ? 0 : 60)
            
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
    public func navigationToolbar(
        title: String = "",
        mode: TitleDisplayMode = .automatic,
        leadingButtons: AnyView? = AnyView(BackButton()),
        trailingButtons: AnyView? = AnyView(CloseButton()),
        offset: CGFloat = 0) -> some View {

        return self
            .modifier(
                NavigationToolbarModifier(
                    title: title,
                    mode: mode,
                    leadingButtons: leadingButtons,
                    trailingButtons: trailingButtons,
                    offset: offset
                )
            )
    }
}

public enum TitleDisplayMode {
    case automatic
    case inline
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case large
}

public struct BackButton: View {
    @Environment(\.router) var router
    
    public init() { }
    
    public var body: some View {
        Button(action: router.popToPrevious) { Image(systemName: "arrow.left") }
    }
}

public struct CloseButton: View {
    @Environment(\.router) var router

    public init() { }

    public var body: some View {
        Button(action: router.popToCheckpoint) { Image(systemName: "xmark") }
    }
}
