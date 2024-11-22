//
//  Tab.swift
//  pantrix
//
//  Created by student on 22/11/24.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case recipes = "Recipes"
    case mealplan = "Meal Plan"
    case pantry = "Pantry"
    case shoppinglist = "Shopee List"
    case profile = "Profile"
    
    var systemImage: String {
        switch self {
        case .recipes:
            return "book.fill"
        case .mealplan:
            return "calendar.circle.fill"
        case .pantry:
            return "refrigerator.fill"
        case .shoppinglist:
            return "cart.badge.plus"
        case .profile:
            return "person.circle.fill"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}
