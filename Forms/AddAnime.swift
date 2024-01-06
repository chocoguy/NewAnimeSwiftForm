//
//  AddAnime.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/17/23.
//

import SwiftUI
import AlertToast

struct AddAnime: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var _title: String = ""
    @State var _episodes: Int = 0
    @State var _season: String = "winter"
    @State var _year: Int = 0
    @State var _derivedSource: String = "manga"
    @State var _mediaType: String = "tv"
    
    @State private var showSavedToast = false
    
    

    
    var body: some View {
        Form{
            VStack{
                HStack{
                    Spacer()
                    TextField(text: $_title, prompt: Text("required")){
                        Text("Title")
                    }.padding(.horizontal, 50).autocorrectionDisabled(true)
                    Spacer()
                    Stepper(value: $_episodes, step: 1){
                        TextField(value: $_episodes, format: .number){
                            Text("Episodes")
                        }
                    }.padding(.horizontal, 50)
                    Spacer()
                }
                HStack{
                    Spacer()
                    Picker("Season", selection: $_season){
                        Text("Winter").tag("winter")
                        Text("Spring").tag("spring")
                        Text("Summer").tag("summer")
                        Text("Fall").tag("fall")
                    }.padding(.horizontal, 50)
                    Spacer()
                    TextField( value: $_year, formatter: NumberFormatter()){
                            Text("Year")
                        }.padding(.horizontal, 50)
                    Spacer()
                }.padding(.top, 10)
                HStack{
                    Spacer()
                    Picker("Source", selection: $_derivedSource){
                        Text("Manga").tag("manga")
                        Text("Other").tag("other")
                        Text("Original").tag("original")
                        Text("Web Manga").tag("web_manga")
                        Text("Game").tag("game")
                        Text("Light Novel").tag("light_novel")
                        Text("Visual Novel").tag("visual_novel")
                    }.padding(.horizontal, 50)
                    Spacer()
                    Picker("Media Type", selection: $_mediaType){
                        Text("TV").tag("tv")
                        Text("Unknown").tag("unknown")
                        Text("Movie").tag("movie")
                        Text("OVA").tag("ova")
                        Text("ONA").tag("ona")
                        Text("Special").tag("special")
                        Text("Music").tag("music")
                    }.padding(.horizontal, 50)
                    Spacer()
                }.padding(.top, 10)
                Spacer()
                HStack(spacing: 2.0){
                    Spacer()
                    Button(action: SaveAnime){
                        Text("Save")
                    }.padding(.bottom, 10)
                        .padding(.trailing, 15)
                    
                }
            }
            .padding(.top, 50)
            
        }.navigationTitle("Add Anime - Manual")
            .toast(isPresenting: $showSavedToast){
                AlertToast(displayMode: .hud, type: .complete(.green), title: "Anime Added!")
            }
    }
    
    func SaveAnime(){
        var newAnime = Anime(context: viewContext)
        
        newAnime.id = UUID()
        newAnime.mediaType = _mediaType
        newAnime.title = _title
        newAnime.year = Int16(_year)
        newAnime.season = _season
        newAnime.episodes = Int16(_episodes)
        newAnime.derivedSource = _derivedSource

        do {
            try viewContext.save()
            print("Saved")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved in AddAnime.swift \(nsError). \(nsError.userInfo)" )
        }
        
        for i in 1...newAnime.episodes{
            let newEpisode = Episode(context: viewContext)
            newEpisode.id = UUID();
            newEpisode.animeId = newAnime.id;
            newEpisode.number = Int16(i);
            newEpisode.watchStatus = 0;
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved in AddAnime.swift \(nsError), \(nsError.userInfo)")
            }
        }
        print("Episodes saved")
        
        showSavedToast.toggle()
        
        
        
    }
}

#Preview {
    AddAnime()
}
