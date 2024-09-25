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
    @State var showAddLogView: Bool = false
    @State private var addLogQuantity: Int?
    @State private var errorOccured: Bool = false
    
    private var dailyProgressData: [DailyProgressData] {
        [
            DailyProgressData(title: "Today", image: Image("cigarette"), amount: $cigaretteConsumedToday, color: .pink, type: .cigarettes),
            DailyProgressData(title: "Last time", image: Image(systemName: "clock"), amount: $lastTime, color: .pink, type: .time),
            DailyProgressData(title: "Daily goal", image: Image(systemName: "target"), amount: $dailyGoal, color: .pink, type: .goal)
        ]
    }
    
    var body: some View {
        ZStack {
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
                            DailyProgressCard(data: data, amount: data.amount ?? .constant(0))
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
                        .padding(.bottom, 56)
                        .onChange(of: selectedDate) { newValue in
                            print(viewModel.getHistoryForDate(date: newValue))
                        }
                    
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showAddLogView.toggle()
                        }
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(Color.pink)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                }
            }
            
            if showAddLogView {
                LinearGradient(gradient: Gradient(colors: [Color(.systemBackground.withAlphaComponent(0.9))]),
                                                           startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            showAddLogView = false
                        }
                    }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showAddLogView = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                        }
                        .padding(.trailing, 16)
                        .padding(.top, 16)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 0) {
                        TextField("Cigarette amount", value: $addLogQuantity, format: .number)
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 8)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 32)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 32)
                    }
                    .padding(.bottom, 30)

                    Button(action: {
                        addLog()
                        withAnimation {
                            showAddLogView = false
                        }
                    }) {
                        Text("Done")
                            .font(.headline)
                            .frame(width: 200, height: 50)
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                }
                .padding()
                .padding(.bottom, 32)
            }
            
        }
        .alert(isPresented: $errorOccured) {
                   Alert(
                    title: Text("Error"),
                    message: Text("Please enter a valid number"),
                    dismissButton: Alert.Button.default(Text("OK"))
                   )
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
        guard let addLogQuantity = addLogQuantity else {
            errorOccured = true
            return
        }
        viewModel.addLog(quantity: Int16(addLogQuantity))
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
