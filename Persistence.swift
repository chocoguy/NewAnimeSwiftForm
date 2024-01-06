//
//  Persistence.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/16/23.
//

import CoreData

struct PersistenceController {
    let persistentContainer: NSPersistentContainer
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.persistentContainer.viewContext
        let viewContextTwo = result.persistentContainer.viewContext
        
        let sampleAnimeUUID = UUID()
        let sampleAnimeMALUUID = UUID()
        
        let sampleAnime = Anime(context: viewContext)
        let sampleAnimeMAL = Anime(context: viewContext)
        
        let dateFormatThing = DateFormatter()
        dateFormatThing.dateFormat = "'yyyy'-'MM'-'dd'"
        
        
        sampleAnime.id = sampleAnimeUUID;
        sampleAnime.airingStatus_MAL = nil;
        sampleAnime.broadcastDay = nil;
        sampleAnime.derivedSource = "Original"
        sampleAnime.description_MAL = nil;
        sampleAnime.ended = nil;
        sampleAnime.ended_MAL = nil;
        sampleAnime.episodes = 12;
        sampleAnime.id_MAL = 0;
        sampleAnime.lastEpisodeWatched = 0;
        sampleAnime.lastWatched = nil;
        sampleAnime.mediaType = "TV";
        sampleAnime.personalRating = 0;
        sampleAnime.poster_MAL = nil;
        sampleAnime.rank_MAL = 0;
        sampleAnime.score_MAL = 0;
        sampleAnime.season = "Winter";
        sampleAnime.started = nil;
        sampleAnime.started_MAL = nil;
        sampleAnime.studios_MAL = nil;
        sampleAnime.title = "Madoka Magica";
        sampleAnime.usersWhoDropped_MAL = 0;
        sampleAnime.watchStatus = "Watching"
        sampleAnime.year = 2011
        
        
        
        sampleAnimeMAL.id = sampleAnimeMALUUID;
        sampleAnimeMAL.airingStatus_MAL = "finished_airing";
        sampleAnimeMAL.broadcastDay = "Saturday";
        sampleAnimeMAL.derivedSource = "manga"
        sampleAnimeMAL.description_MAL = "Very long desc";
        sampleAnimeMAL.ended = nil;
        sampleAnimeMAL.ended_MAL = DateFromString(dateString: "2022-06-25")
        sampleAnimeMAL.episodes = 12;
        sampleAnimeMAL.id_MAL = 50265;
        sampleAnimeMAL.lastEpisodeWatched = 0;
        sampleAnimeMAL.lastWatched = nil;
        sampleAnimeMAL.mediaType = "tv";
        sampleAnimeMAL.personalRating = 0;
        sampleAnimeMAL.poster_MAL = URL(string: "https://cdn.myanimelist.net/images/anime/1441/122795.jpg");
        sampleAnimeMAL.rank_MAL = 98;
        sampleAnimeMAL.score_MAL = 8.57;
        sampleAnimeMAL.season = "Spring";
        sampleAnimeMAL.started = nil;
        sampleAnimeMAL.started_MAL =  DateFromString(dateString: "2022-04-12")
        sampleAnimeMAL.studios_MAL = "Wit Studio, CloverWorks";
        sampleAnimeMAL.title = "Spy x Family";
        sampleAnimeMAL.usersWhoDropped_MAL = 19354;
        sampleAnimeMAL.watchStatus = "Watching"
        sampleAnimeMAL.year = 2022
        
        
        
                
        //sample schedule
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        //12 episodes for each
        
//        for i in 1...12{
//            let newEpisode = Episode(context: viewContextTwo)
//            newEpisode.id = UUID();
//            newEpisode.animeId = sampleAnimeUUID;
//            newEpisode.number = Int16(i);
//            newEpisode.watchStatus = 0;
//            do {
//                try viewContextTwo.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
        
        for i in 1...12{
            let newEpisodeMAL = Episode(context: viewContextTwo)
            newEpisodeMAL.id = UUID();
            newEpisodeMAL.animeId = sampleAnimeMALUUID;
            newEpisodeMAL.number = Int16(i);
            newEpisodeMAL.watchStatus = 0;
            do {
                try viewContextTwo.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        
        return result
    }()
    
    
    //let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "NewAnimeSwiftForm")
        print(persistentContainer.persistentStoreDescriptions.first?.url ?? "I do not know the location!")
        
        if inMemory {
            persistentContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        //container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    
}
