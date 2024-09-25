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
    
    var body: some View {
         TabView {
             HomeView()
                 .environmentObject(viewModel)
                 .tabItem {
                     Label("Home", systemImage: "house")
                 }
                 .tag(0)
             
             StatsView()
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
}
