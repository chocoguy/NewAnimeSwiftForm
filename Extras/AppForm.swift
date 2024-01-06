//
//  AppForm.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/27/23.
//

import Foundation
import SwiftUI

enum AppForm: Codable, Hashable, Identifiable, CaseIterable {
    case anime
    case schedule
    case settings
    
    var id: AppForm {self}
}

extension AppForm {
    @ViewBuilder
    var label: some View {
        switch self {
        case .anime:
            Label("Anime", systemImage: "tv")
        case .schedule:
            Label("Schedule", systemImage: "calendar")
        case .settings:
            Label("Settings", systemImage: "gearshape")
        }
    }
    
    @ViewBuilder
    var destination: some View {
        switch self {
        case .anime:
            AnimeNavigationStack()
        case .schedule:
            ScheduleNavigationStack()
        case .settings:
            SettingsNavigationStack()
        }
    }
}
