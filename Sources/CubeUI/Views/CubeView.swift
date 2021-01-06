//
//  CubeView.swift
//  CubeUI
//
//  Created by Gerardo Grisolini on 06/01/21.
//

import SwiftUI

public struct CubeView<Content: View>: View {
      
    public enum CubeMode {
        case swipe
        case drag
    }

    private enum SlideDirection {
        case enter
        case exit
    }

    private enum DragDirection {
        case next
        case prev
    }
    
    @State private var direction: DragDirection = .next
    @State private var isReady: Bool = true
    @State private var pct: Double = 0
    @State private var diff: Double = 0
    @State private var indexView: Int = 0
    @Binding private var index: Int

    private let mode: CubeMode
    private var views: [AnyView] = []

    public var animatableData: Double {
        get { pct }
        set { pct = newValue }
    }
    
    private var next: Int {
        let i = indexView + 1
        return i == views.count ? 0 : i
    }

    private var prev: Int {
        let i = indexView - 1
        return i < 0 ? views.count - 1 : i
    }

    private var primaryView: AnyView {
        views[direction == .next ? indexView : prev]
    }

    private var secondaryView: AnyView {
        views[direction == .next ? next : indexView]
    }

    public init(index: Binding<Int>, mode: CubeMode, @ViewBuilder content: () -> Content) {
        self.mode = mode
        _index = index
        
        let m = Mirror(reflecting: content())
        if let value = m.descendant("value") {
            let tupleMirror = Mirror(reflecting: value)
            let tupleElements = tupleMirror.children.map({ AnyView(_fromValue: $0.value)! })
            views.append(contentsOf: tupleElements)
        }
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                primaryView
                    .frame(width: geo.size.width, height: geo.size.height)
                    .rotation3DEffect(
                        Angle(degrees: calcRotation(direction: .exit)),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .trailing,
                        anchorZ: 0,
                        perspective: 0.5
                    )
                    .transformEffect(.init(translationX: calcTranslation(geo: geo, direction: .exit), y: 0))
                    .scaleEffect(calcScale())
                secondaryView
                    .frame(width: geo.size.width, height: geo.size.height)
                    .rotation3DEffect(
                        Angle(degrees: calcRotation(direction: .enter)),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .leading,
                        anchorZ: 0,
                        perspective: 0.5
                    )
                    .transformEffect(.init(translationX: calcTranslation(geo: geo, direction: .enter), y: 0))
                    .scaleEffect(calcScale())
            }
            .onReceive([self.index].publisher.first()) { value in
                guard pct == 0 || pct == 1 else { return }
                
                if value == 0 && indexView == views.count - 1 {
                    rotate(direction: .next, count: 1)
                    return
                }
                if indexView == 0 && value == views.count - 1 {
                    rotate(direction: .prev, count: 1)
                    return
                }
                if value > indexView {
                    rotate(direction: .next, count: value - indexView)
                }
                if value < indexView {
                    rotate(direction: .prev, count: indexView - value)
                }
            }
            .gesture(DragGesture().onChanged(dragChange).onEnded(dragEnded))
        }

//        Slider(
//            value:
//                Binding<Double>(
//                    get: { self.$pct.wrappedValue },
//                    set: { self.sliderChanged(toValue: $0) }
//                ),
//            in: -1...1
//        )
//        .padding(.horizontal, 10)
    }
    
    private func rotate(direction: DragDirection, count: Int) {
        guard count > 0 else { return }
        
        DispatchQueue.global(qos: .background).async {
            for _ in 1...count {
                for i in 1...10000 {
                    let value = direction == .next
                        ? Double(i) / 10000
                        : (Double(i) / 10000) * -1
                    calcChanged(toValue: value)
                }
                usleep(100)
            }
        }
    }
    
    private func dragEnded(gesture: DragGesture.Value) {
        if mode == .swipe {
            let xDist = abs(gesture.location.x - gesture.startLocation.x)
            let yDist = abs(gesture.location.y - gesture.startLocation.y)
            if gesture.startLocation.x > gesture.location.x && yDist < xDist {
                // Left
                index = indexView == views.count - 1 ? 1 : indexView + 1
            }
            else if gesture.startLocation.x < gesture.location.x && yDist < xDist {
                // Right
                index = indexView > 0 ? indexView - 1 : 0
            }
        } else if mode == .drag {
            // save difference in case of unfinished rotation
            diff = pct
            isReady = true
        }
    }
    
    private func dragChange(gesture: DragGesture.Value) {
        if mode == .drag {
            var newValue = (Double(gesture.translation.width) / 250) * -1

            /// limit in rewind after unfinished rotation
            if diff > 0 && newValue < 0 {
                if diff + newValue < 0 {
                    pct = 0
                    return
                }
            }
            if diff < 0 && newValue > 0 {
                if newValue + diff > 0 {
                    pct = 0
                    return
                }
            }

            /// highest difference of unfinished rotation
            newValue += diff

            /// limit to one page in rotation
            if newValue > 1 {
                newValue = 1
            }
            if newValue < -1 {
                newValue = -1
            }
            
            calcChanged(toValue: newValue)
        }
    }
    
    private func calcChanged(toValue value: Double) {
        guard isReady else { return }
        
        switch value {
        case 0.01...1:
            direction = .next
            if value == 1 {
                if pct > 0.9 {
                    pct = 0
                    indexView = next
                    index = Int(indexView)
                    isReady = false
                }
            } else {
                pct = value
            }
        case -1...(-0.01):
            direction = .prev
            if value == -1 {
                if pct < -0.9 {
                    pct = 0
                    indexView = prev
                    index = Int(indexView)
                    isReady = false
                }
            } else {
                pct = value
            }
        default:
            break
        }
    }

    private func calcTranslation(geo: GeometryProxy, direction: SlideDirection) -> CGFloat {
        let degree = self.direction == .next ? pct : pct + 1
        if direction == .enter {
            return geo.size.width - (CGFloat(degree) * geo.size.width)
        } else {
            return -1 * (CGFloat(degree) * geo.size.width)
        }
    }
    
    private func calcRotation(direction: SlideDirection) -> Double {
        let degree = self.direction == .next ? pct : pct + 1
        if direction == .enter {
            return 90 - (degree * 90)
        } else {
            return -1 * (degree * 90)
        }
    }
    
    private func calcScale() -> CGFloat {
        var degree = Double(direction == .next ? pct : pct * -1)
        if degree < 0.5 {
            degree = 1 - degree
        }
        if degree < 0.95 {
            return 0.95
        }

        return CGFloat(degree)
    }
}


struct CubeView_Previews: PreviewProvider {
    static var previews: some View {
        CubeView(index: .constant(0), mode: .swipe) {
            Rectangle().fill(Color.green)
            Rectangle().fill(Color.orange)
            Rectangle().fill(Color.blue)
            Rectangle().fill(Color.yellow)
        }
        .ignoresSafeArea(.all)
    }
}


