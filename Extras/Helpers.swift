//
//  Helpers.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/17/23.
//

import Foundation


func FormatYear(year: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0

    return formatter.string(from: NSNumber(value: year)) ?? ""
}

func FormatDate(date: Date?, notParsedString: String) -> String {
    if date == nil{
        return notParsedString
    }else{
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date!)
    }
}

func DateFromString(dateString: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    if let date = dateFormatter.date(from: dateString) {
        return date
    } else {
        print("Error: Unable to convert string to date.")
        return nil
    }
}


extension Anime {
    //0 = ❔ 0=🙂 1=😐 2=🙁 3=😩 4=😳
    var personalRatingString: String {
        switch(self.personalRating){
        case 0:
            return "❓"
        case 1:
            return "🙂"
        case 2:
            return "😐"
        case 3:
            return "🙁"
        case 4:
            return "😩"
        case 5:
            return "😳"
        default:
            return "❓"
        }
    }
}



