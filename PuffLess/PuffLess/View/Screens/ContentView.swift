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
        }
    }
}


#Preview {
    ContentView()
}
