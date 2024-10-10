//
//  PuffLessWidget.swift
//  PuffLess
//
//  Created by Mertcan Kırcı on 10.10.2024.
//

import WidgetKit
import SwiftUI

@main
struct PuffLessWidget: Widget {
    let kind: String = "PuffLessWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PuffLessWidgetView(entry: entry)
        }
        .configurationDisplayName("PuffLess Tracker")
        .description("Track your daily cigarette consumption directly from your home screen.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

