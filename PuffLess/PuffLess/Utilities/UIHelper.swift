//
//  UIHelper.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 25.09.2024.
//

import Foundation

enum TimeFormatter {
    static func formatMinutesToTimeString(minutes: Int) -> String {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        let days = hours / 24
        
        if days > 0 {
            return "\(days)d \(hours)h"
        }
        if hours > 0 {
            return "\(hours)h \(remainingMinutes)m"
        } else {
            return "\(remainingMinutes)m"
        }
    }
}
