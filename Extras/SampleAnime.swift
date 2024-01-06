//
//  SampleAnime.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/17/23.
//

import Foundation
import CoreData

struct SampleAnime {
    static let sampleAnime = {
        let context = PersistenceController.preview.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Anime> = Anime.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        let results = try! context.fetch(fetchRequest)
        
        return results.first!
        
    }()
}
