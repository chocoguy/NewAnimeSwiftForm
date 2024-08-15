//
//  ScheduleDetails.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 3/11/24.
//

import SwiftUI
import AlertToast

struct ScheduleDetails: View {
    //@FetchRequest, get data before state and UI is loaded, store that data in the currentScheduleFilter var
    @FetchRequest(sortDescriptors: []) var currentScheduleFilter: FetchedResults<Schedule>
    @FetchRequest(sortDescriptors: []) var allSchedules: FetchedResults<Schedule>
    //FetchRequest for the anime and sort
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Anime.title, ascending: true)], animation: .default) private var allAnime: FetchedResults<Anime>
    //Store those results here for anime
    //This will always be empty as there is no preceding @FetchRequest
    //private var allSchedules: FetchedResults<Schedule>
    @Environment(\.managedObjectContext) private var viewContext
    @State private var currentSchedule : Schedule?
    @State private var currentScheduleId: UUID?
    @State private var showNewScheduleView: Bool = false;
    
    
    @State private var _formTitle: String = ""
    
    //Form Values
    @State private var _mon: UUID?
    @State private var _tue: UUID?
    @State private var _wed: UUID?
    @State private var _thu: UUID?
    @State private var _fri: UUID?
    @State private var _sat: UUID?
    @State private var _sun: UUID?
    @State private var _scheduleTitle: String = ""
    @State private var _isCurrent: Bool = false
    
    //Schedule Anime
    @State private var monScheduled: ScheduledAnime?
    @State private var tueScheduled: ScheduledAnime?
    @State private var wedScheduled: ScheduledAnime?
    @State private var thuScheduled: ScheduledAnime?
    @State private var friScheduled: ScheduledAnime?
    @State private var satScheduled: ScheduledAnime?
    @State private var sunScheduled: ScheduledAnime?
    
    
    
    
    
    //Toasts
    @State private var showSavedToast: Bool = false
    @State private var showErrorToast: Bool = false
    @State private var errorToastMessage: String = "Error"
    
    var body: some View {
        HStack{
            if(showNewScheduleView){
                Form{
                    Text("Adding new schedule")
                    HStack{
                        Picker("Monday", selection: $_mon){
                            ForEach(allAnime, id: \.self.id) { ani in
                                Text("\(ani.title!)").tag("\(ani.id!)")
                            }
                        }
                        Picker("Tuesday", selection: $_tue){
                            ForEach(allAnime, id: \.self.id) { ani in
                                Text("\(ani.title!)").tag("\(ani.id!)")
                            }
                        }
                    }
                    HStack{
                        Picker("Wedensday", selection: $_wed){
                            ForEach(allAnime, id: \.self.id) { ani in
                                Text("\(ani.title!)").tag("\(ani.id!)")
                            }
                        }
                        Picker("Thursday", selection: $_thu){
                            ForEach(allAnime, id: \.self.id) { ani in
                                Text("\(ani.title!)").tag("\(ani.id!)")
                            }
                        }
                    }
                    HStack{
                        Picker("Friday", selection: $_fri){
                            ForEach(allAnime, id: \.self.id) { ani in
                                Text("\(ani.title!)").tag("\(ani.id!)")
                            }
                        }
                        Picker("Saturday", selection: $_sat){
                            ForEach(allAnime, id: \.self.id) { ani in
                                Text("\(ani.title!)").tag("\(ani.id!)")
                            }
                        }
                    }
                    HStack{
                        Picker("Sunday", selection: $_sun){
                            ForEach(allAnime, id: \.self.id) { ani in
                                Text("\(ani.title!)").tag("\(ani.id!)")
                            }
                        }
                        TextField(text: $_scheduleTitle){
                            Text("Title")
                        }
                    }
                    HStack{
                        Toggle(isOn: $_isCurrent){
                            Text("Make current")
                        }
                    }
                    
                    
                    
                    
                    Button(action: {
                        AddSchedule()
                    }){
                        Text("Add")
                            .padding(.bottom, 20)
                            .padding(.trailing, 10)
                    }
                }
            }else{
                VStack{
                    
                    Picker("Select Schedule", selection: $currentScheduleId) {
                        ForEach(allSchedules, id: \.self.id) { schedule in
                            Text(schedule.title ?? "no title").tag("\(schedule.id!)")
                        }
                    }.onChange(of: currentScheduleId){ newVal in
                        print("change")
                    }
                    //curr schedule grid
                    
                    if(currentSchedule != nil){
                        HStack{
                            VStack{
                                Text("Monday")
                            }
                            VStack{
                                if(monScheduled == nil){
                                    Text("No Anime Scheduled")
                                }else{
                                    Text(monScheduled!.title)
                                }
                            }
                        }
                        
                        HStack{
                            VStack{
                                Text("Tuesday")
                            }
                            VStack{
                                if(tueScheduled == nil){
                                    Text("No Anime Scheduled")
                                }else{
                                    Text(tueScheduled!.title)
                                }
                            }
                        }
                        
                        HStack{
                            VStack{
                                Text("Wedensday")
                            }
                            VStack{
                                if(wedScheduled == nil){
                                    Text("No Anime Scheduled")
                                }else{
                                    Text(wedScheduled!.title)
                                }
                            }
                        }
                        
                        HStack{
                            VStack{
                                Text("Thursday")
                            }
                            VStack{
                                if(thuScheduled == nil){
                                    Text("No Anime Scheduled")
                                }else{
                                    Text(thuScheduled!.title)
                                }
                            }
                        }
                        
                        HStack{
                            VStack{
                                Text("Friday")
                            }
                            VStack{
                                if(friScheduled == nil){
                                    Text("No Anime Scheduled")
                                }else{
                                    Text(friScheduled!.title)
                                }
                            }
                        }
                        
                        HStack{
                            VStack{
                                Text("Saturday")
                            }
                            VStack{
                                if(satScheduled == nil){
                                    Text("No Anime Scheduled")
                                }else{
                                    Text(satScheduled!.title)
                                }
                            }
                        }
                        
                        HStack{
                            VStack{
                                Text("Sunday")
                            }
                            VStack{
                                if(sunScheduled == nil){
                                    Text("No Anime Scheduled")
                                }else{
                                    Text(sunScheduled!.title)
                                }
                            }
                        }
                    }
                    
                    Button(action: {
                        showNewScheduleView = true
                        currentSchedule = Schedule(context: viewContext)
                    }){
                        Text("Add new schedule").padding(.bottom, 20).padding(.trailing, 20)
                    }
                    
                }
            }
        }.onAppear {
            print("Appear now")
            //currentSchedule = Schedule(context: viewContext)
            
            
            //currentScheduleFilter.nsPredicate = NSPredicate(format: "isCurrent = true")
            for currSchedule in allSchedules {
                if(currSchedule.isCurrent){
                    currentSchedule = currSchedule
                    currentScheduleId = currSchedule.id
                    PopulateScheduledAnime()
                    
                }
            }

        }
        .navigationTitle($_formTitle)
        .toast(isPresenting: $showSavedToast){
            AlertToast(displayMode: .hud, type: .complete(.green), title: "Schedule Saved!")
        }
        
        //attributes
        //count, int 16
        //isCurrent, boolean
        //id UUID
        //title, string
    }
    
    //01
    func AddSchedule(){
        currentSchedule!.id = UUID();
        currentSchedule!.title = _scheduleTitle
        currentSchedule!.isCurrent = _isCurrent
        currentSchedule!.mon = _mon
        currentSchedule!.tue = _tue
        currentSchedule!.wed = _wed
        currentSchedule!.thu = _thu
        currentSchedule!.fri = _fri
        currentSchedule!.sat = _sat
        currentSchedule!.sun = _sun
        
        if(_isCurrent){
            for currSchedule in allSchedules{
                currSchedule.isCurrent = false
            }
        }
        
        do {
            try viewContext.save()
            print("Scheduled saved")
            showNewScheduleView = false
        } catch {
            let nsError = error as NSError
            fatalError("Error on ScheduleDetails.swift AddSchedule() 2 \(nsError), \(nsError.userInfo)")
        }
        
    }
    
    
    //02
    func PopulateScheduledAnime(){
        for currAnime in allAnime {
            if(currentSchedule?.mon == currAnime.id){
                monScheduled = ScheduledAnime(id: currAnime.id!, title: currAnime.title!, episodeString: "\(currAnime.lastEpisodeWatched)/\(currAnime.episodes)", poster: currAnime.poster_MAL, seasonString: "\(currAnime.season!) - \(currAnime.year)")
            }
            
            if(currentSchedule?.tue == currAnime.id){
                tueScheduled = ScheduledAnime(id: currAnime.id!, title: currAnime.title!, episodeString: "\(currAnime.lastEpisodeWatched)/\(currAnime.episodes)", poster: currAnime.poster_MAL, seasonString: "\(currAnime.season!) - \(currAnime.year)")
            }
            
            if(currentSchedule?.wed == currAnime.id){
                wedScheduled = ScheduledAnime(id: currAnime.id!, title: currAnime.title!, episodeString: "\(currAnime.lastEpisodeWatched)/\(currAnime.episodes)", poster: currAnime.poster_MAL, seasonString: "\(currAnime.season!) - \(currAnime.year)")
            }
            
            if(currentSchedule?.thu == currAnime.id){
                thuScheduled = ScheduledAnime(id: currAnime.id!, title: currAnime.title!, episodeString: "\(currAnime.lastEpisodeWatched)/\(currAnime.episodes)", poster: currAnime.poster_MAL, seasonString: "\(currAnime.season!) - \(currAnime.year)")
            }
            
            if(currentSchedule?.fri == currAnime.id){
                friScheduled = ScheduledAnime(id: currAnime.id!, title: currAnime.title!, episodeString: "\(currAnime.lastEpisodeWatched)/\(currAnime.episodes)", poster: currAnime.poster_MAL, seasonString: "\(currAnime.season!) - \(currAnime.year)")
            }
            
            if(currentSchedule?.sat == currAnime.id){
                satScheduled = ScheduledAnime(id: currAnime.id!, title: currAnime.title!, episodeString: "\(currAnime.lastEpisodeWatched)/\(currAnime.episodes)", poster: currAnime.poster_MAL, seasonString: "\(currAnime.season!) - \(currAnime.year)")
            }
            
            if(currentSchedule?.sun == currAnime.id){
                sunScheduled = ScheduledAnime(id: currAnime.id!, title: currAnime.title!, episodeString: "\(currAnime.lastEpisodeWatched)/\(currAnime.episodes)", poster: currAnime.poster_MAL, seasonString: "\(currAnime.season!) - \(currAnime.year)")
            }
            
            
        }
    }
    
    
}
