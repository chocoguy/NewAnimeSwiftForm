//
//  NewAnimeSwiftFormApp.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/16/23.
//

import SwiftUI

@main
struct NewAnimeSwiftFormApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let viewContext = PersistenceController.shared.persistentContainer.viewContext
            Home()
            .frame(width: 808, height: 407).frame(minWidth: 808, idealWidth: 808, maxWidth: 808, minHeight: 407, idealHeight: 407, maxHeight: 407)
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environment(\.managedObjectContext, viewContext)
        }.windowResizability(WindowResizability.contentSize)
    }
}
