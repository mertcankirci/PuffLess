//
//  PersistanceViewModel.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 23.09.2024.
//

import WidgetKit
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
    
    func getMonthlyCigaretteConsumedByWeek() -> [(String, Int)] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)),
              let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth),
              let numberOfWeeks = calendar.range(of: .weekOfMonth, in: .month, for: startOfMonth)?.count else {
            return []
        }

        var weeklyConsumption = Array(repeating: 0, count: numberOfWeeks)

        let monthlyLogs = logs.filter { log in
            if let logDate = log.date {
                return logDate >= startOfMonth && logDate < endOfMonth
            }
            return false
        }

        for log in monthlyLogs {
            if let logDate = log.date {
                let weekOfMonth = calendar.component(.weekOfMonth, from: logDate) - 1
                if weekOfMonth >= 0 && weekOfMonth < numberOfWeeks {
                    weeklyConsumption[weekOfMonth] += Int(log.quantitiy)
                }
            }
        }

        var orderedResults: [(String, Int)] = []
        for week in 1...numberOfWeeks {
            let weekStartDate = calendar.date(byAdding: .weekOfMonth, value: week - 1, to: startOfMonth)!
            let weekEndDate = calendar.date(byAdding: .day, value: 6, to: weekStartDate)!

            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "d" 

            let weekRangeString = "\(dayFormatter.string(from: weekStartDate))-\(dayFormatter.string(from: weekEndDate))"
            
            orderedResults.append((weekRangeString, weeklyConsumption[week - 1]))
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
        guard let defaults = UserDefaults(suiteName: "group.com.mertcankirci.PuffLess") else {return 0}
        let goal = defaults.integer(forKey: "dailyGoal")
        let dailyConsumed = getDailyCigaretteConsumed()
        
        let remaining = goal - dailyConsumed
        return remaining
    }
    
    func saveDailyGoals(dailyGoal: Int) {
        guard let defaults = UserDefaults(suiteName: "group.com.mertcankirci.PuffLess") else { return }
        defaults.set(dailyGoal, forKey: "dailyGoal")
        WidgetCenter.shared.reloadAllTimelines()
    }
}
