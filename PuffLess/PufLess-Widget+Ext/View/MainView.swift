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
        smallView
    }
    
    @ViewBuilder
    var smallView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(calculateWeekdayName(entry.date).uppercased())
                .font(.system(size: 22, weight: .black))
                .foregroundStyle(.pink)
            
                Text("\(entry.quantity)")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
            
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.mint)
                    .frame(width: 10)
                
                VStack(alignment: .leading) {
                    Text("DAILY GOAL")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.mint)
                    
                    Text("\(entry.dailyGoalRemaining) remaining")
                        .font(.caption)
                        .foregroundStyle(.mint)
                }
                .padding(.vertical)
                .padding(.horizontal, 8)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.mint.opacity(0.2))
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func calculateWeekdayName(_ date: Date) -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        
        return dayInWeek
    }
}
