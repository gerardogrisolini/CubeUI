//
//  CubeView.swift
//  CubeUI
//
//  Created by Gerardo Grisolini on 01/01/21.
//

import SwiftUI

public struct CubeView<Content: View>: View {
      
    enum SlideDirection {
        case enter
        case exit
    }

    enum DragDirection {
        case next
        case prev
    }
    
    @State var direction: DragDirection = .next
    @State var pct: Double = 0
    @State var diff: Double = 0
    @State var index: Int = 0
    
    var views: [AnyView] = []

    public init(@ViewBuilder content: () -> Content) {
        let m = Mirror(reflecting: content())
        if let value = m.descendant("value") {
            let tupleMirror = Mirror(reflecting: value)
            let tupleElements = tupleMirror.children.map({ AnyView(_fromValue: $0.value)! })
            views.append(contentsOf: tupleElements)
        }
    }
    
    var next: Int {
        let i = index + 1
        return i == views.count ? 0 : i
    }

    var prev: Int {
        let i = index - 1
        return i < 0 ? views.count - 1 : i
    }

    var primaryView: AnyView {
        views[direction == .next ? index : prev]
    }

    var secondaryView: AnyView {
        views[direction == .next ? next : index]
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

    private func dragEnded(value: DragGesture.Value) {
        /// save difference in case of unfinished rotation
        diff = pct
    }
    
    private func dragChange(value: DragGesture.Value) {
        var newValue = (Double(value.translation.width) / 200) * -1
        //debugPrint("value: \(newValue)\tdiff: \(diff)\tpct: \(pct)")

        /// limitation in rewind after unfinished rotation
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

        /// limitation to one page in rotation
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
            direction = .next
            if value == 1 {
                if pct > 0.9 {
                    index = next
                    pct = 0
                }
            } else {
                pct = value
            }
        case -1...(-0.01):
            direction = .prev
            if value == -1 {
                if pct < -0.9 {
                    index = prev
                    pct = 0
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
}


struct CubeView_Previews: PreviewProvider {

    static var previews: some View {
        CubeView {
            Rectangle().fill(Color.green)
            Rectangle().fill(Color.orange)
            Rectangle().fill(Color.blue)
            Rectangle().fill(Color.yellow)
        }
        .ignoresSafeArea(.all)
    }
}

