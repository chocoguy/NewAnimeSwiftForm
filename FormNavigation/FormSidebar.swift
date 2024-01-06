//
//  FormSidebar.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/28/23.
//

import SwiftUI

struct FormSidebar: View {
    
    @Binding var selection: AppForm?
    
    var body: some View {
        List(AppForm.allCases, selection: $selection) { screen in
            NavigationLink(value: screen) {
                screen.label
            }
        }
        .navigationTitle("New AnimeSwiftForm")
    }
}


