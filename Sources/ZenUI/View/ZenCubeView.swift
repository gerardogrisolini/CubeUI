//
//  ZenCubeView.swift
//  ZenUI
//
//  Created by Gerardo Grisolini on 06/01/21.
//

import SwiftUI

public struct ZenCubeView<Content: View>: View {
    @StateObject private var viewModel = CubeViewModel()
    @Binding var index: Int
    
    let mode: CubeMode
    let views: [AnyView]

    var next: Int {
        let i = viewModel.currentIndex + 1
        return i == views.count ? 0 : i
    }

    var prev: Int {
        let i = viewModel.currentIndex - 1
        return i < 0 ? views.count - 1 : i
    }

    var primaryView: AnyView {
        views[viewModel.direction == .next ? viewModel.currentIndex : prev]
    }

    var secondaryView: AnyView {
        views[viewModel.direction == .next ? next : viewModel.currentIndex]
    }
    
    public init(index: Binding<Int>, mode: CubeMode, @ViewBuilder content: () -> Content) {
        _index = index
        self.mode = mode
        
        let m = Mirror(reflecting: content())
        if let value = m.descendant("value") {
            let tupleMirror = Mirror(reflecting: value)
            views = tupleMirror.children.map({ AnyView(_fromValue: $0.value)! })
        } else {
            views = []
        }
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                primaryView
                    .frame(width: geo.size.width, height: geo.size.height)
                    .modifier(CubeRotationModifier(pct: viewModel.pct, translation: .exit, rotation: viewModel.direction) {
                        viewModel.pct = 0
                    })
                secondaryView
                    .frame(width: geo.size.width, height: geo.size.height)
                    .modifier(CubeRotationModifier(pct: viewModel.pct, translation: .enter, rotation: viewModel.direction) {
                        viewModel.pct = 0
                    })
            }
            .onChange(of: index, perform: { value in
                externalChange(index: value)
            })
            .onChange(of: viewModel.index, perform: { value in
                internalChange(index: value)
            })
            .gesture(DragGesture().onChanged(dragChange).onEnded(dragEnded))
            .onAppear {
                viewModel.subscribe(mode: mode)
            }
        }
    }
    
    private func externalChange(index value: Int) {
        guard value != viewModel.index else { return }
        
        viewModel.isReady = false
        if value > viewModel.index {
            viewModel.direction = .next
            let a = value - viewModel.index
            let b = views.count - (viewModel.index == 0 ? value : viewModel.index + value)
            if b < a {
                viewModel.direction = .prev
                rotate(count: b, incrementBy: -1)
            } else {
                rotate(count: a, incrementBy: 1)
            }
        }
        else if value < viewModel.index {
            viewModel.direction = .prev
            let a = viewModel.index - value
            let b = views.count - viewModel.index + value
            if b < a {
                viewModel.direction = .next
                rotate(count: b, incrementBy: 1)
            } else {
                rotate(count: a, incrementBy: -1)
            }
        }
    }

    private func internalChange(index value: Int) {
        index = value
        viewModel.pct = 0
        
        guard (mode == .swipe) else { return }

        if viewModel.index == 0 && viewModel.currentIndex == views.count - 1 {
            viewModel.direction = .next
            rotate()
        }
        else if viewModel.currentIndex == 0 && viewModel.index == views.count - 1 {
            viewModel.direction = .prev
            rotate()
        }
        else if viewModel.index > viewModel.currentIndex {
            viewModel.direction = .next
            rotate()
        }
        else if viewModel.index < viewModel.currentIndex {
            viewModel.direction = .prev
            rotate()
        }
    }
    
    private func rotate(count: Int = 1, incrementBy: Int = 0) {
        guard count > 0 else { return }
        
        viewModel.pct = 0
        let pct = viewModel.direction == .next ? 1.0 : -1.0
        for val in 0..<count {
            let delay = TimeInterval(Double(val)/2.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if viewModel.index + incrementBy == -1 {
                    viewModel.index = views.count - 1
                }
                else if viewModel.index + incrementBy == views.count {
                    viewModel.index = 0
                }
                else {
                    viewModel.index += incrementBy
                }
                withAnimation(.linear(duration: TimeInterval(0.5))) {
                    viewModel.pct = pct
                }
            }
        }
    }
    
    private func dragEnded(gesture: DragGesture.Value) {
        if mode == .swipe {
            let xDist = abs(gesture.location.x - gesture.startLocation.x)
            let yDist = abs(gesture.location.y - gesture.startLocation.y)
            if gesture.startLocation.x > gesture.location.x && yDist < xDist {
                // Left
                viewModel.index = next
            }
            else if gesture.startLocation.x < gesture.location.x && yDist < xDist {
                // Right
                viewModel.index = prev
            }
        }
        else if mode == .drag {
            // save difference in case of unfinished rotation
            viewModel.diff = viewModel.pct
            viewModel.isReady = true
        }
    }
    
    private func dragChange(gesture: DragGesture.Value) {
        guard mode == .drag else { return }

        var newValue = (Double(gesture.translation.width) / 250) * -1

        /// limit in rewind after unfinished rotation
        if viewModel.diff > 0 && newValue < 0 {
            if viewModel.diff + newValue < 0 {
                viewModel.pct = 0
                return
            }
        }
        if viewModel.diff < 0 && newValue > 0 {
            if newValue + viewModel.diff > 0 {
                viewModel.pct = 0
                return
            }
        }

        /// highest difference of unfinished rotation
        newValue += viewModel.diff

        /// limit to one page in rotation
        if newValue > 1 {
            newValue = 1
        }
        if newValue < -1 {
            newValue = -1
        }
        
        calcChanged(toValue: newValue)
    }
    
    private func calcChanged(toValue value: Double) {
        switch value {
        case 0.01...1:
            viewModel.direction = .next
            if value == 1 {
                if viewModel.isReady {
                    viewModel.isReady = false
                    viewModel.index = next
                    viewModel.pct = value
                }
            } else {
                viewModel.pct = value
            }
        case -1...(-0.01):
            viewModel.direction = .prev
            if value == -1 {
               if viewModel.isReady {
                    viewModel.isReady = false
                    viewModel.index = prev
                    viewModel.pct = value
                }
            } else {
                viewModel.pct = value
            }
        default:
            break
        }
    }
}

#if DEBUG
struct CubeView_Previews: PreviewProvider {

    private struct SideView: View {
        var number: Int
        var color: Color
        
        var body: some View {
            Text("Content \(number)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .foregroundColor(.white)
                .background(color)
        }
    }
    
    static var previews: some View {
        ZenCubeView(index: .constant(0), mode: .swipe) {
            SideView(number: 1, color: .blue)
            SideView(number: 2, color: .orange)
            SideView(number: 3, color: .green)
            SideView(number: 4, color: .yellow)
        }
        .ignoresSafeArea(.all)
    }
}
#endif
