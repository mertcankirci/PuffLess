//
//  ContentView.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 23.09.2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject var viewModel: PersistanceViewModel
    @EnvironmentObject var router: Router
    
    var body: some View {
         TabView {
             HomeView()
                 .environmentObject(viewModel)
                 .environmentObject(router)
                 .tabItem {
                     Label("Home", systemImage: "house")
                 }
                 .tag(0)
             
             StatsView()
                 .environmentObject(viewModel)
                 .tabItem {
                     Label("Stats", systemImage: "chart.bar")
                 }
                 .tag(1)
         }
         .accentColor(.pink)
     }
}


#Preview {
    ContentView()
        .environmentObject(PersistanceViewModel())
        .environmentObject(Router())
}
