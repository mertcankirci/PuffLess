//
//  PersistanceViewModel.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 23.09.2024.
//

import Foundation
import CoreData

class PersistanceViewModel: ObservableObject {
    @Published var logs: [CigaretteLog] = []
    
    init() {
        fetchLogs()
    }
    
    func fetchLogs() {
        logs = CoreDataManager.shared.fetchCigaretteLogs()
    }
    
    func addLog(quantity: Int16, date: Date = Date()) {
        CoreDataManager.shared.addCigaretteLog(quantity: quantity, date: date)
        fetchLogs()
    }
    
    func deleteLog(log: CigaretteLog) {
        CoreDataManager.shared.deleteCigaretteLog(log)
        fetchLogs()
    }
    
    func getDailyCigaretteConsumed() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let todayLogs = logs.filter { log in
            if let logDate = log.date {
                return calendar.isDate(logDate, inSameDayAs: today)
            }
            return false
        }
        
        return Int(todayLogs.reduce(0) { $0 + $1.quantitiy})
    }
    
    func getWeeklyCigaretteConsumed() -> [(String, Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let weekStartDate = calendar.date(byAdding: .day, value: -7, to: today)!
        
        var dailyConsumption = Array(repeating: 0, count: 7)
        
        let weekLogs = logs.filter { log in
            if let logDate = log.date {
                return logDate >= weekStartDate && logDate < today
            }
            return false
        }
        
        for log in weekLogs {
            if let logDate = log.date {
                let dayDifference = calendar.dateComponents([.day], from: weekStartDate, to: logDate).day ?? 0
                if dayDifference >= 0 && dayDifference < 7 {
                    dailyConsumption[dayDifference] += Int(log.quantitiy)
                }
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        var orderedResults: [(String, Int)] = []
        for i in 0..<dailyConsumption.count {
            if let date = calendar.date(byAdding: .day, value: i, to: weekStartDate) {
                let dayName = dateFormatter.string(from: date)
                orderedResults.append((dayName, dailyConsumption[i]))
            }
        }
        
        return orderedResults
    }
    
    func getHistoryForDate(date: Date) -> [CigaretteLog] {
        let calendar = Calendar.current
        
        return logs.filter { log in
            if let logDate = log.date {
                return calendar.isDate(logDate, inSameDayAs: date)
            } else {
                return false
            }
        }
    }
    
    func getLastCigaretteLogTime() -> Int? {
        if let lastLogDate = logs.first?.date {
            let now = Date()
            let diffComponents = Calendar.current.dateComponents([.minute], from: lastLogDate, to: now)
            return diffComponents.minute
        } else {
            return nil
        }
    }
    
    func getDailyGoalRemaining() -> Int {
        let goal = UserDefaults.standard.integer(forKey: "dailyGoal")
        let dailyConsumed = getDailyCigaretteConsumed()
        
        let remaining = goal - dailyConsumed
        return remaining
    }
    
    func saveDailyGoals(dailyGoal: Int) {
        UserDefaults.standard.set(dailyGoal, forKey: "dailyGoal")
    }
}
