//
//  EditAnime.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/22/23.
//

import SwiftUI
import CoreData
import AlertToast

struct EditAnime: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    //preview
    
    //@FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Anime.title, ascending: true)]) var animeList: FetchedResults<Anime>
    
    @EnvironmentObject var anime: Anime
    @FetchRequest(sortDescriptors: []) var allEpisodesFromSelection: FetchedResults<Episode>
    //end preview
    
    @State private var episodesFromSelectionTwo: [Episode] = []
    
    //@State private var predicate: NSPredicate?
    
    @State var _id: UUID = UUID()
    @State var _title: String = "Johnsumisu"
    @State var _season: String = "spring"
    @State var _source: String = "manga"
    @State var _mediaType: String = "tv"
    @State var _rating: String = "0"
    @State var _episodeCount: Int = 0
    @State var _year: Int = 0
    
    @State private var showSavedToast: Bool = false
    @State private var showErrorToast: Bool = false
    @State private var errorToastMessage: String = "Error"
    
//    @State var _episodes: Int = 12
//    @State var _season: String = "spring"
//    @State var _year: Int = 2022
//    @State var _derivedSource: String = "manga"
//    @State var _mediaType: String = "tv"
//    @State var _personalRating: Int = 0
//    @State var _watchStatus = "Watching"
    
    //init(){
        
        //_predicate = State(initialValue: NSPredicate(format: "animeId = %@", argumentArray: [UUID()]))
        
//        if let lastAnime = animeList.last {
//            if let animeId = lastAnime.id {
//                allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [animeId])
//                print("all ep count \(allEpisodesFromSelection.count)")
//            } else {
//                print("Anime's id is nil")
//            }
//        } else {
//            print("Anime list is empty")
//        }
        
        //allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [anime.id])
        //_title = anime.title!
        
    //}
    
    
    var body: some View {

        HStack{
            VStack{
                HStack{
                    Text("Title")
                    TextField(text: $_title){
                    }
                }
                HStack{
                    Text("Episodes")
                    Stepper(value: $_episodeCount, step: 1){
                        TextField(value: $_episodeCount, format: .number){
                        }
                    }
                }
                Picker("Season", selection: $_season){
                        Text("Winter").tag("winter")
                        Text("Spring").tag("spring")
                        Text("Summer").tag("summer")
                        Text("Fall").tag("fall")
                    }
                HStack{
                    Text("Year")
                    TextField( value: $_year, formatter: NumberFormatter()){
                        }
                }
                Picker("Source", selection: $_source){
                    Text("Manga").tag("manga")
                    Text("Other").tag("other")
                    Text("Original").tag("original")
                    Text("Web Manga").tag("web_manga")
                    Text("Game").tag("game")
                    Text("Light Novel").tag("light_novel")
                    Text("Visual Novel").tag("visual_novel")
                }
                Picker("Media Type", selection: $_mediaType){
                    Text("TV").tag("tv")
                    Text("Unknown").tag("unknown")
                    Text("Movie").tag("movie")
                    Text("OVA").tag("ova")
                    Text("ONA").tag("ona")
                    Text("Special").tag("special")
                    Text("Music").tag("music")
                }
                Picker("Rating", selection: $_rating){
                    Text("❓").tag("0")
                    Text("🙂").tag("1")
                    Text("😐").tag("2")
                    Text("🙁").tag("3")
                    Text("😩").tag("4")
                    Text("😳").tag("5")
                }
            }
            
            VStack{
                    List(episodesFromSelectionTwo){ ep in
                        Text("\(ep.number)")
                        Button(){
                            print("\(ep.id)")
                        }label: {
                            Text("joe").foregroundStyle(.green)
                        }
                            .swipeActions(edge: .trailing) {
                                Button("Hamster"){
                                    print("Small and Soft")
                                }
                                .tint(.blue)
                            }
                            .selectionDisabled()
                    }
//                    Table(allEpisodesFromSelection) {
//                        TableColumn("Episode Num"){ episode in
//                            Text("\(episode.number)")
//                        }
//                        TableColumn(""){ episode in
//                            
//                            if(episode.watchStatus == 1){
//                                Text("Watched")
//                            }else{
//                                Text("Not Watched")
//                            }
//                        }
//                    }
                HStack(spacing: 2.0){
                    Spacer()
                    Button(action: SaveAnime){
                        Text("Save")
                    }.padding(.bottom, 10)
                        .padding(.trailing, 10)
                    Button(action: doStuff){
                        Text("Stuff")
                    }.padding(.bottom, 10)
                        .padding(.trailing, 10)
                    
                }
            }
            List {
                Text("Pepperoni pizza")
                    .swipeActions {
                        Button("Order") {
                            print("Awesome!")
                        }
                        .tint(.green)
                    }

                Text("Pepperoni with pineapple")
                    .swipeActions {
                        Button("Burn") {
                            print("Right on!")
                        }
                        .tint(.red)
                    }
            }
        }.onAppear {
            _title = anime.title!
            _season = anime.season!
            _source = anime.derivedSource!
            _mediaType = anime.mediaType!
            _rating = String(anime.personalRating)
            _year = Int(anime.year)
            _episodeCount = Int(anime.episodes)
            _id = anime.id!
            allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [anime.id])
            for currEp in allEpisodesFromSelection{
                episodesFromSelectionTwo.append(currEp)
            }
            
            
        }
        .navigationTitle("Edit - \(anime.title!)")
        .toast(isPresenting: $showSavedToast){
            AlertToast(displayMode: .hud, type: .complete(.green), title: "Anime Saved!")
        }
        .toast(isPresenting: $showErrorToast){
            AlertToast(displayMode: .hud, type: .error(.red), title: errorToastMessage)
        }
    }
    
    func doStuff(){
        
    }
    
    //01
    func SaveAnime(){

        print(anime.episodes)
        print(_episodeCount)
        if(anime.episodes > Int16(_episodeCount)){
            errorToastMessage = "May not decrement episodes. Only Increment"
            showErrorToast.toggle()
            return
        }
        
        if(Int16(_episodeCount) > anime.episodes){
            IncrementAnimeEpisodeCount()
            anime.watchStatus = "Watching"
        }
        anime.title = _title;
        anime.season = _season;
        anime.derivedSource = _source
        anime.mediaType = _mediaType
        anime.personalRating = Int16(_rating)!
        anime.year = Int16(_year)
        anime.episodes = Int16(_episodeCount)
        do{
            try viewContext.save();
            showSavedToast.toggle()
            allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [anime.id])
            episodesFromSelectionTwo.removeAll()
            for currEp in allEpisodesFromSelection{
                episodesFromSelectionTwo.append(currEp)
            }
            episodesFromSelectionTwo.sort{ $0.number < $1.number }
        } catch {
            errorToastMessage = "Runtime Error - 0501"
            showErrorToast.toggle()
            let nsError = error as NSError
            fatalError("Error on EditAnime.swift SaveAnime() \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    //02
    func IncrementEpisode(){
        //allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [anime.id])
        print("all ep count \(allEpisodesFromSelection.count)")
        if(allEpisodesFromSelection.count == 0){
            
        }else{
            for episode in allEpisodesFromSelection  {
                if(episode.watchStatus == 0){
                    episode.watchStatus = 1
                    anime.lastEpisodeWatched = episode.number
                    print("watch episode: \(episode.number)")
                    do {
                        try viewContext.save()
                    } catch {
                        errorToastMessage = "Runtime Error - 0502"
                        showErrorToast.toggle()
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
    
    //03
    func IncrementAnimeEpisodeCount(){
        for i in Int(anime.episodes)..._episodeCount - 1{
            let ammendedEpisode = Episode(context: viewContext)
            ammendedEpisode.id = UUID();
            ammendedEpisode.animeId = anime.id;
            ammendedEpisode.number = Int16(i + 1);
            ammendedEpisode.watchStatus = 0;
            do{
                try viewContext.save()
            } catch {
                errorToastMessage = "Runtime Error - 0503"
                showErrorToast.toggle()
                let nsError = error as NSError
                fatalError("Unresolved in EditAnime.swift \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    //04
    func DecrementEpisode(){
//        allEpisodesFromSelection.nsPredicate = NSPredicate(format: "animeId = %@", argumentArray: [anime.id])
//        print("all ep count \(allEpisodesFromSelection.count)")
//        if(allEpisodesFromSelection.count == 0){
//            
//        }else{
//            for episode in allEpisodesFromSelection  {
//                if(episode.watchStatus == 0){
//                    
//                    if(allEpisodesFromSelection[episode. - 1].watchStatus == 1){
//                        
//                    }
//                    
//                    
//                    episode.watchStatus = 1
//                    anime.lastEpisodeWatched = episode.number
//                    print("watch episode: \(episode.number)")
//                    do {
//                        try viewContext.save()
//                    } catch {
//                        let nsError = error as NSError
//                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                    }
//                    return
//                }else{
//                    print("already watched episode: \(episode.number)")
//                }
//            }
//        }
    }
    
}

#Preview {
    EditAnime().environment(\.managedObjectContext, PersistenceController.preview.persistentContainer.viewContext)
        .frame(width: 707.0, height: 407.0)
}
