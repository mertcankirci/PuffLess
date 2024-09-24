//
//  PuffLessApp.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 23.09.2024.
//

import SwiftUI

@main
struct PuffLessApp: App {
    @StateObject private var viewModel = PersistanceViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
