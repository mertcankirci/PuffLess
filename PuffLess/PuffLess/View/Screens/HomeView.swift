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
    @State var lastTime: Int = 0
    @State var dailyGoal: Int = 0
    
    @State var weeklyProgress: [(String, Int)] = []
    @State var selectedDate: Date = Date()
    
    @State private var timer: Timer?
    
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
                    .bold()
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
                            addLog()
                        }
                    }
                }
                .frame(height: 100)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal)
                
                Text("Weekly Progress")
                    .font(.title)
                    .bold()
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
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(.horizontal)
                    .padding(.top)
                
                DatePicker("", selection: $selectedDate)
                    .datePickerStyle(.graphical)
                    .labelsHidden()
                    .tint(.pink)
                    .padding(.horizontal)

            }
        }
        .background(.regularMaterial)
        .onAppear {
            fetchDailyConsumed()
            fetchWeeklyProgress()
            fetchDailyGoal()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private func addLog() {
        viewModel.addLog(quantity: 8)
        fetchDailyConsumed()
        fetchLastTime()
        fetchDailyGoal()
        fetchLastTime()
    }
    
    private func fetchDailyConsumed() {
        cigaretteConsumedToday = viewModel.getDailyCigaretteConsumed()
    }
    
    private func fetchWeeklyProgress() {
        weeklyProgress = viewModel.getWeeklyCigaretteConsumed()
    }
    
    private func fetchLastTime() {
        lastTime = viewModel.getLastCigaretteLogTime() ?? 0
    }
    
    private func fetchDailyGoal() {
        dailyGoal = viewModel.getDailyGoalRemaining()
    }
    
    private func startTimer() {
        fetchLastTime()
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            fetchLastTime()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    HomeView()
        .environmentObject(PersistanceViewModel())
}
