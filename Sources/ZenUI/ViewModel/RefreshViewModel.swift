//
//  RefreshViewModel.swift
//  
//
//  Created by Gerardo Grisolini on 16/01/21.
//

import SwiftUI
import Combine

class RefreshViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    var navBarHeight: CGFloat = 0

    @Published var offset: CGFloat = 0
    @Published var isRefresh: Bool = false
    
    deinit {
        print("deinit")
    }
    
    init() {
        $offset
            .sink { value in
                if !self.isRefresh && value > 100 {
                    self.isRefresh = true
                }
            }
            .store(in: &cancellables)
    }
}
