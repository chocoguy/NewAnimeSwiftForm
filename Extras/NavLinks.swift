//
//  NavLinks.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/17/23.
//

import Foundation

enum NavLinks: String, Codable{
    case home, schedule, settings
    
    var title: String {
        rawValue.capitalized
    }
}
