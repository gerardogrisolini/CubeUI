//
//  CubeMenuView.swift
//  CubeUI
//
//  Created by Gerardo Grisolini on 30/12/20.
//

import SwiftUI

public struct CubeMenuView<Menu: View, Content: View> : View {

    @State private var animation : AnyTransition = .cubeRotationLeft
    @State private var startPos : CGPoint = .zero
    @State private var isSwipping = true
    @State private var indexView = 0

    @Binding var index: Int
    private let views: [AnyView]
    
    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> Content) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content())
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1)
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2)
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2),
            AnyView(content().value.3)
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2),
            AnyView(content().value.3),
            AnyView(content().value.4)
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content, Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2),
            AnyView(content().value.3),
            AnyView(content().value.4),
            AnyView(content().value.5)
        ]
    }
    
    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content, Content, Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2),
            AnyView(content().value.3),
            AnyView(content().value.4),
            AnyView(content().value.5),
            AnyView(content().value.6)
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content, Content, Content, Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2),
            AnyView(content().value.3),
            AnyView(content().value.4),
            AnyView(content().value.5),
            AnyView(content().value.6),
            AnyView(content().value.7)
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content, Content, Content, Content, Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2),
            AnyView(content().value.3),
            AnyView(content().value.4),
            AnyView(content().value.5),
            AnyView(content().value.6),
            AnyView(content().value.7),
            AnyView(content().value.8)
        ]
    }

    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content, Content, Content, Content, Content, Content, Content, Content, Content)> ) {
        _index = index
        views = [
            AnyView(menu()),
            AnyView(content().value.0),
            AnyView(content().value.1),
            AnyView(content().value.2),
            AnyView(content().value.3),
            AnyView(content().value.4),
            AnyView(content().value.5),
            AnyView(content().value.6),
            AnyView(content().value.7),
            AnyView(content().value.8),
            AnyView(content().value.9)
        ]
    }
    
    public var body: some View {
        ZStack {
            ForEach(views.indices) { idx in
                if indexView == idx {
                    views[idx]
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(animation)
                }
            }
        }
        .onReceive([self.index].publisher.first()) { (value) in
            if value > indexView {
                animation = .cubeRotationLeft
                withAnimation(.easeIn(duration: 0.5)) {
                    indexView = value
                }
            }
            if value < indexView {
                animation = .cubeRotationRight
                withAnimation(.easeInOut(duration: 0.5)) {
                    indexView = value
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if self.isSwipping {
                        self.startPos = gesture.location
                        self.isSwipping.toggle()
                    }
                }
                .onEnded { gesture in
                    let xDist = abs(gesture.location.x - self.startPos.x)
                    let yDist = abs(gesture.location.y - self.startPos.y)
                    if self.startPos.x > gesture.location.x && yDist < xDist {
                        // Left
                        index = indexView == views.count - 1 ? 1 : indexView + 1
                    }
                    else if self.startPos.x < gesture.location.x && yDist < xDist {
                        // Right
                        index = indexView > 0 ? indexView - 1 : 0
                    }
                    self.isSwipping.toggle()
                }
        )
        .ignoresSafeArea(.all)
    }
}

struct CubeModifierView_Previews: PreviewProvider {
    @State static var index = 1

    static var previews: some View {
        CubeMenuView(index: $index) {

            VStack(alignment: .center, spacing: 50) {
                Text("Menu").font(.title)
                Button(action: { index = 1 }, label: {
                    Text("Content 1")
                })
                Button(action: { index = 2 }, label: {
                    Text("Content 2")
                })
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.orange]), startPoint: .bottomLeading, endPoint: .topTrailing))
            .ignoresSafeArea(.all)

        } content: {
            
            VStack(alignment: .center, spacing: 50) {
                Button(action: { index = 0 }) {
                    Image(systemName: "line.horizontal.3")
                }
                Text("Content 1").font(.title)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.orange]), startPoint: .bottomTrailing, endPoint: .topLeading))
            .ignoresSafeArea(.all)
            
            VStack(alignment: .center, spacing: 50) {
                Button(action: { index = 0 }) {
                    Image(systemName: "line.horizontal.3")
                }
                Text("Content 2").font(.title)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.green, Color.orange]), startPoint: .bottomTrailing, endPoint: .topLeading))
            .ignoresSafeArea(.all)
        }
    }
}
