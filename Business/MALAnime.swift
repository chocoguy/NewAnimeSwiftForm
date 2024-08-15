//
//  MALAnime.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 1/1/24.
//

import Foundation


struct MALAnime: Codable {
    var idMAL: Int
    var title: String
    var episodes: Int
    var derivedSource: String
    var mediaType: String
    var year: Int
    var season: String
    var broadcastDay: String
    var posterMAL: String
    var startedMAL: String
    var endedMAL: String?
    var descriptionMAL: String
    var rankMAL: Int
    var airingStatusMAL: String
    var studiosMAL: String
    var scoreMAL: Float
    var usersWhoDroppedMAL: Int
    
    enum CodingKeys: String, CodingKey {
        case idMAL = "id_MAL"
        case title, episodes, derivedSource, mediaType, year, season, broadcastDay
        case posterMAL = "poster_MAL"
        case startedMAL = "started_MAL"
        case endedMAL = "ended_MAL"
        case descriptionMAL = "description_MAL"
        case rankMAL = "rank_MAL"
        case airingStatusMAL = "airingStatus_MAL"
        case studiosMAL = "studios_MAL"
        case scoreMAL = "score_MAL"
        case usersWhoDroppedMAL = "usersWhoDropped_MAL"
    }
    
}
