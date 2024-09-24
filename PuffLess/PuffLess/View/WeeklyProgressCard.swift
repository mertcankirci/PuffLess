//
//  WeeklyProgressCard.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 24.09.2024.
//

import SwiftUI

struct WeeklyProgressCard: View {
    
    let weeklyProgress: [(String, Int)]

    private func colorForAmount(_ amount: Int) -> Color {
        switch amount {
        case 0...5:
            return .green
        case 5...10:
            return .mint
        case 10...15:
            return .yellow
        default:
            return .pink
        }
    }

    var body: some View {

        HStack {
            ForEach(weeklyProgress, id: \.0) { (day, amount) in
                VStack {
                    Text("\(amount)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(colorForAmount(amount))
                    Text(day)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding()
    }
}

#Preview {
    WeeklyProgressCard(weeklyProgress: [("Wed", 2), ("Thu", 8), ("Fri", 13), ("Sat", 20), ("Sun", 0), ("Mon", 0), ("Tue", 35)])
}

