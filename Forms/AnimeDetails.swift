//
//  AnimeDetails.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/20/23.
//

import SwiftUI
import CoreData
import AlertToast

struct AnimeDetails: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    //preview
//    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Anime.title, ascending: true)],
//                  animation: .default)
//    private var animeList: FetchedResults<Anime>
    @EnvironmentObject var anime: Anime
    //@State var testTitle = ""
    //end preview
    
    @FetchRequest(sortDescriptors: []) var allEpisodesFromSelection: FetchedResults<Episode>
    
    @State private var showDeleteAlert = false
    @State private var showDropAlert = false
    @State private var showStallAlert = false
    
    @State private var showDeletedToast = false
    @State private var showMarkedToast = false
    
    init(){
        
        //testTitle = anime.title!
        
    }
    
    var body: some View {
        HStack{
            VStack{
                HStack{
                    Text("Episode: \(anime.lastEpisodeWatched)/\(anime.episodes) | Last Watched: \(FormatDate(date: anime.lastWatched, notParsedString: "Unknown")) | Currently: \(anime.watchStatus ?? "Unknown")")
                        .padding([.top, .leading])
                    Spacer()
                }
                HStack{
                    Text("Started: \(FormatDate(date: anime.started, notParsedString: "Not Started")) | Ended: \(FormatDate(date: anime.ended, notParsedString: "Not Ended"))")
                        .padding(.leading)
                    Spacer()
                }
                Divider()
                
                Group{
                    HStack{
                        Text("Derived Source:")
                            .padding(.leading)
                        Text(anime.derivedSource ?? "Unknown")
                            .padding(.leading, 8.0)
                        Spacer()
                    }
                    HStack{
                        Text("Media Type:")
                            .padding(.leading)
                        
                        Text(anime.mediaType ?? "Unknown")
                            .padding(.leading, 31.0)
                        
                        Spacer()
                    }
                    HStack{
                        Text("Personal Rating:")
                            .padding(.leading)
                        Text(anime.personalRatingString)
                            .padding(.leading, 2.0)
                        Spacer()
                    }
                }
                if(anime.id_MAL != 0){
                    Group{
                        HStack{
                            Text("Airing Status:")
                                .padding(.leading)
                            Text(anime.airingStatus_MAL ?? "Unknown")
                                .padding(.leading, 24.0)
                            Spacer()
                        }
                        HStack{
                            Text("Started:")
                                .padding(.leading)
                            Text(FormatDate(date: anime.started_MAL, notParsedString: "Unknown"))
                                .padding(.leading, 55.0)
                            Spacer()
                        }
                        HStack{
                            Text("Ended:")
                                .padding(.leading)
                            Text(FormatDate(date: anime.ended_MAL, notParsedString: "Unknown"))
                                .padding(.leading, 61.0)
                            Spacer()
                        }
                        HStack{
                            Text("New Episode:")
                                .padding(.leading)
                            Text(anime.broadcastDay ?? "Unknown")
                                .padding(.leading, 22.0)
                            Spacer()
                        }
                        HStack{
                            Text("MAL Rank:")
                                .padding(.leading)
                            Text("\(anime.rank_MAL)")
                                .padding(.leading, 40.0)
                            Spacer()
                        }
                        HStack{
                            Text("MAL Score:")
                                .padding(.leading)
                            Text("\(anime.score_MAL.formatted())")
                                .padding(.leading, 35.0)
                            Spacer()
                        }
                        HStack{
                            Text("Studios:")
                                .padding(.leading)
                            Text(anime.studios_MAL ?? "Unknown")
                                .padding(.leading, 55.0)
                            Spacer()
                        }
                        HStack{
                            Text("People Filtered:")
                                .padding(.leading)
                            Text("\(anime.usersWhoDropped_MAL)")
                                .padding(.leading, 10.0)
                            Spacer()
                        }
                    }
                }
                Spacer()
            }
            
            VStack{
                if(anime.poster_MAL == nil){
                    Image("placeholder")
                }else{
                    AsyncImage(url: anime.poster_MAL) { image in
                        image.resizable()
                            .scaledToFit()
                            .padding(.top, 50)
                            .shadow(color: .black, radius: 6)
                    } placeholder: {
                        ProgressView()
                    }
                    Button(action: {
                        SyncWithMal()
                    }) {
                        Text("Sync with MAL")
                    }
                }
                HStack{
                    NavigationLink{
                        EditAnime()
                            .environmentObject(anime)
                    } label: {
                        Text("Edit")
                    }
                    Button(action: {
                        IncrementEpisode()
                    }) {
                        Text("Watch")
                    }
                    Button(action: {
                        showStallAlert = true
                    }) {
                        Text("Stall")
                    }.alert("Mark Anime", isPresented: $showStallAlert){
                        Button("Yes"){ MarkAnime(IsStalled: true) }
                        Button("No"){ }
                    } message: {
                        Text("Mark as Stalled?")
                    }
                    Button(action: {
                        showDropAlert = true
                    }) {
                        Text("Drop")
                    }.alert("Mark Anime", isPresented: $showDropAlert){
                        Button("Yes"){ MarkAnime(IsStalled: false) }
                        Button("No"){ }
                    } message: {
                        Text("Mark as Dropped?")
                    }
                    Button(action: {
                        showDeleteAlert = true
                    }) {
                        Text("Delete")
                    }.alert("Delete Anime", isPresented: $showDeleteAlert){
                        Button("Yes"){ DeleteAnime() }
                        Button("No"){ }
                    } message: {
                        Text("Are you sure?")
                    }
                }
            }
        }.navigationTitle(anime.title!)
            .toast(isPresenting: $showDeletedToast){
                AlertToast(displayMode: .hud, type: .complete(.green), title: "Anime Deleted!")
            }
            .onDisappear(){
                do{
                    try viewContext.save();
                } catch {
                    let nsError = error as NSError
                    fatalError("Error on AnimeDetails.swift onDisappear() \(nsError), \(nsError.userInfo)")
                }
            }
    }
    
    func SyncWithMal(){
        
    }
    
    func IncrementEpisode(){
        allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [anime.id])
        print("all ep count \(allEpisodesFromSelection.count)")
        if(allEpisodesFromSelection.count == 0){
            
        }else{
            for episode in allEpisodesFromSelection  {
                if(episode.watchStatus == 0){
                    
                    if(episode.number == 1){
                        anime.started = Date()
                    }
                    
                    if(episode.number == anime.episodes){
                        anime.watchStatus = "Finished"
                        anime.ended = Date()
                    }
                    
                    episode.watchStatus = 1
                    anime.watchStatus = "Watching"
                    anime.lastWatched = Date()
                    anime.lastEpisodeWatched = episode.number
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
    
    func MarkAnime(IsStalled: Bool){
        
        if(IsStalled){
            anime.watchStatus = "Stalled"
        }else{
            anime.watchStatus = "Dropped"
        }
        do{
            try viewContext.save();
            showMarkedToast.toggle()
        } catch {
            let nsError = error as NSError
            fatalError("Error on EditAnime.swift SaveAnime() \(nsError), \(nsError.userInfo)")
        }
    }
    
    
    func DeleteAnime(){
        showDeletedToast.toggle()
        allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [anime.id])
        for episode in allEpisodesFromSelection {
            do{
                try viewContext.delete(episode)
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error in EditAnime \(nsError), \(nsError.userInfo)")
            }
        }
        
        do{
            try viewContext.delete(anime)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error in EditAnime \(nsError), \(nsError.userInfo)")
        }
    }
    
}

#Preview {
    AnimeDetails().environment(\.managedObjectContext, PersistenceController.preview.persistentContainer.viewContext)
        .frame(width: 707.0, height: 407.0)
}
