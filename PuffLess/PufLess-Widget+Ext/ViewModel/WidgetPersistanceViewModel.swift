//
//  WidgetPersistanceViewModel.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 9.10.2024.
//

import WidgetKit
import CoreData

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> CigaretteEntry {
        return CigaretteEntry(date: Date(), quantity: 0, widgetFamily: context.family, dailyGoalRemaining: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CigaretteEntry) -> Void) {
        let entry = CigaretteEntry(date: Date(), quantity: fetchCigaretteConsumedToday(), widgetFamily: context.family, dailyGoalRemaining: getDailyGoalRemaining())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CigaretteEntry>) -> Void) {
        let consumedCigarettes = fetchCigaretteConsumedToday()
        let entry = CigaretteEntry(date: Date(), quantity: consumedCigarettes, widgetFamily: context.family, dailyGoalRemaining: getDailyGoalRemaining())
        
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }

    private func fetchCigaretteConsumedToday() -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let logs = CoreDataManager.shared.fetchCigaretteLogs()
        
        let todayLogs = logs.filter { log in
            if let logDate = log.date {
                return calendar.isDate(logDate, inSameDayAs: today)
            }
            return false
        }
        
        return Int(todayLogs.reduce(0) { $0 + $1.quantitiy})
    }
    
    private func getDailyGoalRemaining() -> Int {
        let goal = CoreDataManager.shared.returnDailyGoal()
        let dailyConsumed = fetchCigaretteConsumedToday()
        
        let remaining = goal - dailyConsumed
        return remaining
    }
}




