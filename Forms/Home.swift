//
//  Home.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/16/23.
//

import SwiftUI
import CoreData

struct Home: View {
    
    @State private var selection: AppForm? = .anime
    
    var body: some View {

        NavigationSplitView{
            FormSidebar(selection: $selection)
        } detail: {
            FormContent(screen: selection)
        }
    }
}
#Preview {
    Home().environment(\.managedObjectContext, PersistenceController.preview.persistentContainer.viewContext).frame(width: 707.0, height: 407.0)
}
