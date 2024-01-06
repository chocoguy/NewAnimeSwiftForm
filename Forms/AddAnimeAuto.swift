//
//  AddAnimeAuto.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 1/1/24.
//

import SwiftUI
import AlertToast

struct AddAnimeAuto: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var _searchQuery: String = ""
    @State private var _queryResults: [QueryResult] = []
    @State var _showResults = false
    @State private var showSavedToast = false
    
    
    private var sampleAnimeText = """
        {
          "id_MAL": 9756,
          "title": "Mahou Shoujo Madoka★Magica",
          "episodes": 12,
          "derivedSource": "original",
          "mediaType": "tv",
          "year": 2011,
          "season": "Winter",
          "broadcastDay": "Friday",
          "poster_MAL": "https://cdn.myanimelist.net/images/anime/11/55225.jpg",
          "started_MAL": "2011-01-07",
          "ended_MAL": "2011-04-22",
          "description_MAL": "Description",
          "rank_MAL": 199,
          "airingStatus_MAL": "finished_airing",
          "studios_MAL": "Shaft",
          "score_MAL": 8.36,
          "usersWhoDropped_MAL": 27333
        }
    """
    
    var body: some View {
        VStack{
            HStack{
                Text("Search for an Anime")
                    .padding(.top, 5)
                    .padding(.leading, 10)
                TextField(text: $_searchQuery){
                    Text("Title")
                }.padding(.horizontal, 50)
                    .padding(.top, 5)
                    .autocorrectionDisabled(true)
                Button(action: {
                    Task{
                        await SearchAnime()
                    }
                }){
                    Text("Search")
                }.padding(.top, 5)
                .padding(.trailing, 15)
            }
            
            ScrollView{
                    ForEach(_queryResults, id: \.self.id) { result in
                        HStack{
                            VStack{
                                HStack{
                                    VStack{
                                        
                                        if(result.image == "Unknown"){
                                            Image("placeholder")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 150)
                                                .shadow(color: .black, radius: 6)
                                        }else{
                                            AsyncImage(url: URL(string: result.image)) { image in
                                                image.resizable()
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 100, height: 150)
                                                    .shadow(color: .black, radius: 6)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    }.padding(.leading, 10)
                                    VStack{
                                        Text(result.title)
                                            .foregroundColor(Color.white)
                                    }
                                    Spacer()
                                }
                                Button(action: {
                                    Task{
                                        await AddAnime(malKey: result.id)
                                    }
                                }){
                                    Text("Add")
                                }.padding(.bottom, 10)
                                    .padding(.trailing, 10)
                            }.background(Color.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
            }
        }.onAppear{

        }
        .navigationTitle("Add Anime Auto")
        .toast(isPresenting: $showSavedToast){
            AlertToast(displayMode: .hud, type: .complete(.green), title: "Anime Added!")
        }
    }
    
    
    func SearchAnime() async {
        do{
            var aniQuery = try await AnimeController().searchAnime(query: _searchQuery)
            _queryResults.removeAll()
            
            for item in aniQuery.data! {
                _queryResults.append(QueryResult(id: item.node?.id ?? 1, title: item.node?.title ?? "Unknown", image: item.node?.main_picture?.medium ?? "Unknown"))
                
                print(item.node?.title)
                print(item.node?.main_picture?.medium)
            }
            
        } catch{
            print("Error searching anime \(error.localizedDescription)")
        }
    }
    
    func MalTest() async{
//        let animeData = Data(sampleAnimeText.utf8)
//        let jsonDecode = JSONDecoder()
//        //jsonDecode.keyDecodingStrategy = .convertFromSnakeCase
//        
//        do{
//            let decodedAnime = try jsonDecode.decode(MALAnime.self, from: animeData)
//            print(decodedAnime.title)
//            print(decodedAnime.startedMAL)
//            print(decodedAnime.airingStatusMAL)
//        } catch {
//            print("error decoding \(error.localizedDescription)")
//        }
        
        do{
            var ani = try await AnimeController().getAnimeById(MalId: 38256)
            print(ani.title)
        } catch{
            print("Error getting anime \(error.localizedDescription)")
        }
        
        
    }
    
    
    func MalSearchTest() async {
        do{
            var aniQuery = try await AnimeController().searchAnime(query: "Demon Slayer")
            
            for item in aniQuery.data! {
                print(item.node?.title)
                print(item.node?.main_picture?.medium)
            }
            
        } catch{
            print("Error searching anime \(error.localizedDescription)")
        }
    }
    
    func AddAnime(malKey: Int) async {
        do{
            var ani = try await AnimeController().getAnimeById(MalId: malKey)
            var newAnime = Anime(context: viewContext)
            
            newAnime.id = UUID()
            newAnime.mediaType = ani.mediaType
            newAnime.title = ani.title
            newAnime.year = Int16(ani.year)
            newAnime.season = ani.season.lowercased()
            newAnime.episodes = Int16(ani.episodes)
            newAnime.derivedSource = ani.derivedSource
            
            newAnime.id_MAL = Int32(ani.idMAL)
            newAnime.broadcastDay = ani.broadcastDay
            newAnime.poster_MAL = URL(string: ani.posterMAL)
            newAnime.started_MAL = DateFromString(dateString: ani.startedMAL)
            newAnime.ended_MAL = DateFromString(dateString: ani.endedMAL)
            newAnime.description_MAL = ani.descriptionMAL
            newAnime.rank_MAL = Int32(ani.rankMAL)
            newAnime.airingStatus_MAL = ani.airingStatusMAL
            newAnime.studios_MAL = ani.studiosMAL
            newAnime.score_MAL = ani.scoreMAL
            newAnime.usersWhoDropped_MAL = Int32(ani.usersWhoDroppedMAL)
            
            
            try viewContext.save()
            
            for i in 1...newAnime.episodes{
                let newEp = Episode(context: viewContext)
                newEp.id = UUID()
                newEp.animeId = newAnime.id
                newEp.number = Int16(i)
                newEp.watchStatus = 0
                
                try viewContext.save()
            }
            
            
            print(ani.title)
            showSavedToast.toggle()
        } catch{
            print("Error getting anime on AddAnimeAuto.swift \(error.localizedDescription)")
        }
    }
    
    
//    Button(action: {
//        Task{
//            await MalTest()
//        }
//    }) {
//        Text("Test")
//    }
//    Button(action: {
//        Task{
//            await MalSearchTest()
//        }
//    }) {
//        Text("Test2")
//    }
    
}

#Preview {
    AddAnimeAuto().environment(\.managedObjectContext, PersistenceController.preview.persistentContainer.viewContext).frame(width: 707.0, height: 407.0)
}





