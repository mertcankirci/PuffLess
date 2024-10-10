//
//  WidgetPersistanceViewModel.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 9.10.2024.
//

import Foundation
import WidgetKit

struct Provider: TimelineProvider {
    
    let viewModel = PersistanceViewModel()
    
    func placeholder(in context: Context) -> CigaretteEntry {
        return CigaretteEntry(date: Date(), quantity: 0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CigaretteEntry) -> Void) {
        let entry = CigaretteEntry(date: Date(), quantity: getData())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CigaretteEntry>) -> Void) {
        var entries: [CigaretteEntry] = []
        
        let quantity = getData()
        
        let currentEntry = CigaretteEntry(date: Date(), quantity: quantity)
        entries.append(currentEntry)
        
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        let timeline = Timeline(entries: entries, policy: .after(nextUpdateDate))
        completion(timeline)
    }
    
    func getData() -> Int {
        return viewModel.getDailyCigaretteConsumed()
    }
}



