//
//  DetailHistoryView.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 25.09.2024.
//

import SwiftUI

struct DetailHistoryView: View {
    @State var logs: [CigaretteLog]
    @State var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            if logs.isEmpty {
                emptyStateView
            } else {
                logListView
            }
        }
        .navigationTitle("\(formattedDate(date))")
        .padding()
    }
    
    private var logListView: some View {
        ScrollView {
            ForEach(logs, id: \.self) { log in
                HStack {
                    VStack(alignment: .leading) {
                        Text(logTime(log))
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("Cigarettes: \(log.quantitiy)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color(UIColor.secondarySystemBackground)))
                .padding(.bottom, 8)
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "tray")
                .font(.system(size: 64))
                .foregroundColor(.gray)
            Text("Sorry, no logs for this day.")
                .font(.title2)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    private func logTime(_ log: CigaretteLog) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: log.date ?? Date())
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

#Preview {
    DetailHistoryView(logs: [], date: Date())
}

