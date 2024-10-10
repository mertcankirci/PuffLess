//
//  MainView.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 10.10.2024.
//

import SwiftUI
import WidgetKit

struct PuffLessWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Cigarettes Today")
                .font(.headline)
                .padding(.bottom, 8)
            
            Text("\(entry.quantity)")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(entry.quantity > 0 ? .red : .green)
                .padding(.top, 8)
        }
        .padding()
        .background(Color(.systemBackground))
        .widgetURL(URL(string: "puffless://details"))
    }
}

