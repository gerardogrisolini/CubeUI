//
//  CubeViewModel.swift
//  
//
//  Created by Gerardo Grisolini on 09/01/21.
//

import SwiftUI
import Combine

final class CubeViewModel: ObservableObject {
    @Published var pct: Double = 0
    @Published var index: Int = 0
    @Published var currentIndex: Int = 0
    
    var direction: RotationDirection = .prev
    var diff: Double = 0
    var isReady = false
    private var cancellables = Set<AnyCancellable>()
    
    func subscribe(mode: CubeMode) {
        $pct
            .receive(on: RunLoop.main)
            .filter { [1,0,-1].contains($0) }
            .removeDuplicates()
            .sink { [unowned self] value in
                if value == 0 {
                    currentIndex = index
                } else if mode == .drag {
                    pct = 0
                }
            }
            .store(in: &cancellables)
    }
}
