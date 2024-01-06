//
//  AllAnime.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/17/23.
//

import SwiftUI

struct AllAnime: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Anime.title, ascending: true)],
                  animation: .default)
    private var animeList: FetchedResults<Anime>
    
    @FetchRequest(sortDescriptors: []) var allEpisodesFromSelection: FetchedResults<Episode>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        Table(animeList) {
            TableColumn("Title", value: \.title!)
            TableColumn("Episode"){
                Text("\($0.lastEpisodeWatched)/\($0.episodes)")
            }
            TableColumn("Season"){ anime in
                Text(verbatim: "\(anime.season!) - \(anime.year)")
            }
            TableColumn("Status"){ anime in
                anime.watchStatus == nil ? Text("Unknown") :  Text(anime.watchStatus!)
            }
            TableColumn("Watch"){ anime in
                Button(action: {
                    IncrementEpisode(selectedAnime: anime)
                }) {
                    Text("Watch")
                }
            }
            TableColumn("Details") { ani in
                NavigationLink{
                    AnimeDetails().environmentObject(ani)
                } label: {
                    Text("View")
                }
            }
        }
        
        NavigationLink{
            AddAnime()
            
        } label: {
            Text("Add Manual")
        }
        NavigationLink{
            AddAnimeAuto()
            
        } label: {
            Text("Add Auto")
        }
    }
    
    func IncrementEpisode(selectedAnime: Anime){
        allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [selectedAnime.id])
        print("all ep count \(allEpisodesFromSelection.count)")
        if(allEpisodesFromSelection.count == 0){
            
        }else{
            for episode in allEpisodesFromSelection  {
                if(episode.watchStatus == 0){
                    
                    if(episode.number == 1){
                        selectedAnime.started = Date()
                    }
                    
                    if(episode.number == selectedAnime.episodes){
                        selectedAnime.watchStatus = "Finished"
                        selectedAnime.ended = Date()
                    }
                    
                    episode.watchStatus = 1
                    selectedAnime.watchStatus = "Watching"
                    selectedAnime.lastEpisodeWatched = episode.number
                    selectedAnime.lastWatched = Date()
                    print("watch episode: \(episode.number)")
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    return
                }else{
                    print("already watched episode: \(episode.number)")
                }
            }
        }
    }
    
    func ViewAnimeAction(){
        
    }
    
    
}

//Bloat?
//TableColumn("Last Watched"){ anime in
//    anime.lastWatched == nil ? Text("Unknown") : Text(FormatDate(date: anime.lastWatched!))
//}

#Preview {
    AllAnime().environment(\.managedObjectContext, PersistenceController.preview.persistentContainer.viewContext)
}
