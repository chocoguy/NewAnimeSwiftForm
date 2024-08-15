//
//  ScheduleNavigationStack.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/28/23.
//

import SwiftUI

struct ScheduleNavigationStack: View {
    var body: some View {
        NavigationStack{
            ScheduleDetails()
        }.navigationTitle("Schedule")
    }
}

#Preview {
    ScheduleNavigationStack()
}
