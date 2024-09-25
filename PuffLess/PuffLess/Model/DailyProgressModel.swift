//
//  DailyProgressModel.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 24.09.2024.
//

import SwiftUI

struct DailyProgressData {
    let title: String
    let image: Image
    let amount: Binding<Int>?
    let color: Color
    let type: ProgressType
    
    enum ProgressType {
        case cigarettes
        case time
        case goal
    }
}
