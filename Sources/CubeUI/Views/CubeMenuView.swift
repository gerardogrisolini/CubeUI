//
//  CubeMenuView.swift
//  iSwiftUI
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

    var views: [AnyView] = []
    
    public init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> Content) {
        _index = index
        
        views.append(AnyView(menu()))

        let m = Mirror(reflecting: content())
        if let value = m.descendant("value") {
            let tupleMirror = Mirror(reflecting: value)
            let tupleElements = tupleMirror.children.map({ AnyView(_fromValue: $0.value)! })
            views.append(contentsOf: tupleElements)
        }

        precondition(views.count > 1, "Content is mandatory")
    }

//    init(index: Binding<Int>, @ViewBuilder menu: () -> Menu, @ViewBuilder content: () -> TupleView<(Content, Content)> ) {
//        _index = index
//
//        views.append(AnyView(menu()))
//        views.append(AnyView(content().value.0))
//        views.append(AnyView(content().value.1))
//    }
    
    public var body: some View {
        ZStack {
            ForEach(views.indices) { idx in
                if indexView == idx {
                    NavigationView {
                        views[idx]
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
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
    @State static var index = 0
    static var previews: some View {
        CubeMenuView(index: $index) {

            ZStack(alignment: .center) {
                VStack(spacing: 50) {
                    Button(action: { index = 1 }, label: {
                        Text("Content 1")
                    })

                    Button(action: { index = 2 }, label: {
                        Text("Content 2")
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .bottomLeading, endPoint: .topTrailing))
            .navigationTitle(Text("Menu"))
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: { index = 2 }) {
                        Image(systemName: "rotate.right.fill")
                    }
                }

                ToolbarItem(placement: .automatic) {
                    Button(action: { index = 1 }) {
                        Image(systemName: "rotate.left.fill")
                    }
                }
            }
            .ignoresSafeArea(.all)

        } content: {
            
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .bottomTrailing, endPoint: .topLeading))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Content 1"))
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: { index = 0 }) {
                            Image(systemName: "rotate.right.fill")
                        }
                    }
                }
                .ignoresSafeArea(.all)
            
            Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.orange]), startPoint: .bottomTrailing, endPoint: .topLeading))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationTitle(Text("Content 2"))
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: { index = 1 }) {
                            Image(systemName: "rotate.right.fill")
                        }
                    }
                }
                .ignoresSafeArea(.all)
        }
    }
}
