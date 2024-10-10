//
//  HomeView.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 24.09.2024.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: PersistanceViewModel
    @EnvironmentObject var router: Router
    
    @State var cigaretteConsumedToday: Int = 0
    @State var lastTime: Int = 0
    @State var dailyGoal: Int = 0
    
    @State var weeklyProgress: [(String, Int)] = []
    @State var selectedDate: Date = Date()
    
    @State private var timer: Timer?
    @State var showAddLogView: Bool = false
    @State private var addLogQuantity: Int?
    @State private var errorOccured: Bool = false
    
    @State private var blurOfMainView: Double = 0.0
    
    @FocusState private var isInputFocused: Bool
    
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    
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
                            .background(.regularMaterial)
                            .cornerRadius(12)
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
                        .background(.regularMaterial)
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
                        .onChange(of: selectedDate) { newDate in
                            let logs = viewModel.getHistoryForDate(date: newDate)
                            router.navigate(to: .historyDetail(logs: logs, date: newDate))
                        }
                    
                }
            }
            .blur(radius: blurOfMainView)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showAddLogView.toggle()
                            blurOfMainView = 20
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
            .blur(radius: blurOfMainView)
            
            if showAddLogView {
                ZStack {
                    Color(.systemBackground.withAlphaComponent(0.3))
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            if isInputFocused {
                                 UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                             } else {
                                 withAnimation {
                                     blurOfMainView = 0
                                     showAddLogView = false
                                 }
                             }
                        }
                        
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    blurOfMainView = 0
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
                                .focused($isInputFocused)
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
                                blurOfMainView = 0
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
            
            if !isOnboardingCompleted {
                Color.white
                    .edgesIgnoringSafeArea(.all)
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                    .environmentObject(viewModel)
                    .transition(.opacity)
            }
            
        }
        .alert(isPresented: $errorOccured) {
                   Alert(
                    title: Text("Error"),
                    message: Text("Please enter a valid number"),
                    dismissButton: Alert.Button.default(Text("OK"))
                   )
               }
        .background(Color(UIColor.tertiarySystemFill))
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
        guard let addLogQuantity = addLogQuantity, addLogQuantity > 0 else {
            errorOccured = true
            return
        }
        viewModel.addLog(quantity: Int16(addLogQuantity))
        fetchDailyConsumed()
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
        .environmentObject(Router())
}
