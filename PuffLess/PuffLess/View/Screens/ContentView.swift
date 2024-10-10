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
             HomeView()
                 .environmentObject(viewModel)
                 .environmentObject(router)
                 .accentColor(.pink)
     }
}


#Preview {
    ContentView()
        .environmentObject(PersistanceViewModel())
        .environmentObject(Router())
}
