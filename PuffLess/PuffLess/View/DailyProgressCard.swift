//
//  DailyProgressCard.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 24.09.2024.
//

import SwiftUI

struct DailyProgressCard: View {
    
    @State var title: String
    @State var description: String
    @State var image: Image
    @State var imageColor: Color
    @Binding var amount: Int
    
    var body: some View {
        VStack {
            image
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(imageColor)
                .frame(width: 24, height: 24)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.init(top: 8, leading: 8, bottom: 0, trailing: 0))
            
            VStack(spacing: 0) {
                Text(title)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                Text(amount < 0 ? "Reached" : "\(amount) \(description)")
                    .font(.caption)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.init(top: 0, leading: 8, bottom: 8, trailing: 0))
        }
    }
}

#Preview {
    DailyProgressCard(title: "Today", description: "cigarettes", image: Image(systemName: "person.fill"), imageColor: .pink, amount: .constant(3))
        .frame(width: UIScreen.main.bounds.width / 4, height: UIScreen.main.bounds.width / 4)
        .background(.secondary)
        .cornerRadius(12)
}
