//
//  CubeRotationModifier.swift
//  CubeUI
//
//  Created by Gerardo Grisolini on 29/12/20.
//

import SwiftUI

public struct CubeRotationModifier: AnimatableModifier {
    var pct: Double
    var translation: TranslationDirection
    var rotation: RotationDirection
    private var completion: () -> Void

    public var animatableData: Double {
        get { pct }
        set {
            pct = newValue
            if (pct == 1 || pct == -1) {
                completion()
            }
        }
    }
    
    init(pct: Double, translation: TranslationDirection, rotation: RotationDirection, completion: @escaping () -> Void) {
        self.pct = pct
        self.translation = translation
        self.rotation = rotation
        self.completion = completion
    }
    
    public func body(content: Content) -> some View {
        GeometryReader { geo in
            content
                .rotation3DEffect(
                    Angle(degrees: calcRotation()),
                    axis: (x: 0.0, y: 1.0, z: 0.0),
                    anchor: translation == .enter ? .leading : .trailing,
                    anchorZ: 0,
                    perspective: 0.3
                )
                .transformEffect(.init(translationX: calcTranslation(geo: geo), y: 0))
                .scaleEffect(calcScale())
        }
    }

    private func calcTranslation(geo: GeometryProxy) -> CGFloat {
        let degree = rotation == .next ? pct : pct + 1
        if translation == .enter {
            return geo.size.width - (CGFloat(degree) * geo.size.width)
        } else {
            return -1 * (CGFloat(degree) * geo.size.width)
        }
    }
    
    private func calcRotation() -> Double {
        let degree = rotation == .next ? pct : pct + 1
        if translation == .enter {
            return 90 - (degree * 90)
        } else {
            return -1 * (degree * 90)
        }
    }
    
    private func calcScale() -> CGFloat {
        var degree = Double(rotation == .next ? pct : pct * -1)
        if degree < 0.5 {
            degree = 1 - degree
        }
        if degree < 0.9 {
            return 0.9
        }

        return CGFloat(degree)
    }
}

extension AnyTransition {
    static var cubeRotationRight: AnyTransition {
       .asymmetric(
            insertion:
                AnyTransition.modifier(
                    active: CubeRotationModifier(pct: 1, translation: .exit, rotation: .prev) { },
                    identity: CubeRotationModifier(pct: 0, translation: .exit, rotation: .prev) { }
                ),
            removal:
                AnyTransition.modifier(
                    active: CubeRotationModifier(pct: 0, translation: .enter, rotation: .prev) { },
                    identity: CubeRotationModifier(pct: 1, translation: .enter, rotation: .prev) { }
                )
        )
    }
    static var cubeRotationLeft: AnyTransition {
       .asymmetric(
            insertion:
                AnyTransition.modifier(
                    active: CubeRotationModifier(pct: 0, translation: .enter, rotation: .next) { },
                    identity: CubeRotationModifier(pct: 1, translation: .enter, rotation: .next) { }
                ),
            removal:
                AnyTransition.modifier(
                    active: CubeRotationModifier(pct: 1, translation: .exit, rotation: .next) { },
                    identity: CubeRotationModifier(pct: 0, translation: .exit, rotation: .next) { }
                )
        )
    }
}
