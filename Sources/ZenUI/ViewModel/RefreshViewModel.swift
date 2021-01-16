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
    var isHidden: Bool = false
    
    @Published var offset: CGFloat = 0
    @Published var isRefresh: Bool = false
    
    init() {
        $offset
            .sink { value in
                if !self.isRefresh && value > 100 {
                    self.isRefresh = true
                }
                
                if value > -250 && self.isHidden {
                    self.isHidden = false
                }
                if value < -250 && !self.isHidden {
                    self.isHidden = true
                }
            }
            .store(in: &cancellables)
    }
}
