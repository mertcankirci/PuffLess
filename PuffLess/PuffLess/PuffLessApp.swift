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
    @ObservedObject var router = Router()
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingCompleted {
                NavigationStack(path: $router.navPath) {
                    ContentView()
                        .navigationDestination(for: Router.Destination.self, destination: { destination in
                            switch destination {
                            case .historyDetail(let logs, let date):
                                DetailHistoryView(logs: logs, date: date)
                            }
                        })
                        .environmentObject(viewModel)
                        .environmentObject(router)
                }
                .tint(.pink)
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                    .environmentObject(viewModel)
            }
        }
    }
}
