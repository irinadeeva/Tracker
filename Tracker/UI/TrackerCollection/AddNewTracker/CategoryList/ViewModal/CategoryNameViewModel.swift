//
//  CategoryNameViewModel.swift
//  Tracker
//
//  Created by Irina Deeva on 15/04/24.
//

import UIKit

final class CategoryNameViewModel: Identifiable {
    private let name: String
    
    var nameBinding: Binding<String>? {
        didSet {
            nameBinding?(name)
        }
    }
    
    init(name: String) {
        self.name = name
    }
    
    func getName() -> String{
        return name
    }
}
