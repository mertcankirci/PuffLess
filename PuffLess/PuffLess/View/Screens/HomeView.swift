//
//  HomeView.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 24.09.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: PersistanceViewModel
    
    @State var cigaretteConsumedToday: Int = 0
    @State var lastTime: Int = 1
    @State var dailyGoal: Int = 8
    
    @State var weeklyProgress: [(String, Int)] = []
    
    private var dailyProgressData: [DailyProgressData] {
        [
            DailyProgressData(title: "Today", description: "cigarettes", image: Image("cigarette"), amount: $cigaretteConsumedToday, color: .pink),
            DailyProgressData(title: "Last time", description: "m ago", image: Image(systemName: "clock"), amount: $lastTime, color: .primary),
            DailyProgressData(title: "Daily goal", description: "remaining", image: Image(systemName: "target"), amount: $dailyGoal, color: .mint)
        ]
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Daily Progress")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding()
                    .padding(.top)
                
                HStack {
                    ForEach(dailyProgressData, id: \.title) { data in
                        DailyProgressCard(title: data.title,
                                          description: data.description,
                                          image: data.image,
                                          imageColor: data.color,
                                          amount: data.amount)
                        .background(.background)
                        .cornerRadius(12)
                        .onTapGesture {
                            viewModel.addLog(quantity: 8)
                            fetchDailyConsumed()
                        }
                    }
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                
                Text("Weekly Progress")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding()
                    .padding(.top)
                
                WeeklyProgressCard(weeklyProgress: weeklyProgress)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(.background)
                    .cornerRadius(12)
                    .padding(.horizontal)
                
                Text("History")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding()
                    .padding(.top)
                
                Rectangle()
                    .fill(.background)
                    .frame(height: 300)
                    .padding(.horizontal)
            }
        }
        .background(.regularMaterial)
        .onAppear {
            fetchDailyConsumed()
            fetchWeeklyProgress()
        }
    }
    
    private func fetchDailyConsumed() {
        cigaretteConsumedToday = viewModel.getDailyCigaretteConsumed()
    }
    
    private func fetchWeeklyProgress() {
        weeklyProgress = viewModel.getWeeklyCigaretteConsumed()
    }
}

#Preview {
    HomeView()
        .environmentObject(PersistanceViewModel())
}
