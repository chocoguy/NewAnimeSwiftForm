//
//  AnimeNavigationStack.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/28/23.
//

import SwiftUI

struct AnimeNavigationStack: View {
    var body: some View {
        NavigationStack{
            AllAnime()
        }.navigationTitle("Anime")
    }
}

#Preview {
    AnimeNavigationStack()
}
