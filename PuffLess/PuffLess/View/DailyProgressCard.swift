//
//  DailyProgressCard.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 24.09.2024.
//

import SwiftUI

struct DailyProgressCard: View {
    
    let data: DailyProgressData
    @Binding var amount: Int
    
    var displayValue: String {
        switch data.type {
        case .cigarettes:
            return "\(amount) cigarettes"
        case .time:
            return TimeFormatter.formatMinutesToTimeString(minutes: amount)
        case .goal:
            return amount < 0 ? "Reached" : "\(amount) remaining"
        }
    }
    
    var body: some View {
        VStack {
            data.image
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(data.color)
                .frame(width: 24, height: 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.init(top: 8, leading: 8, bottom: 0, trailing: 0))
            
            VStack(spacing: 0) {
                Text(data.title)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                Text(displayValue)
                    .font(.caption)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.init(top: 0, leading: 8, bottom: 8, trailing: 0))
        }
    }
}

#Preview {
    DailyProgressCard(data: DailyProgressData(title: "asd", image: Image(systemName: "asd"), amount: nil, color: .pink, type: .cigarettes), amount: .constant(3))
        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        .background(.secondary)
        .cornerRadius(12)
}
