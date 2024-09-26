//
//  Router.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 25.09.2024.
//

import SwiftUI

final class Router: ObservableObject {
    
    public enum Destination: Hashable {
        case historyDetail(logs: [CigaretteLog], date: Date)
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
