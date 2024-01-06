//
//  FormContent.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/28/23.
//

import SwiftUI

struct FormContent: View {
    
    var screen: AppForm?
    
    var body: some View {
        Group{
            if let screen {
                screen.destination
            } else {
                Text("Select an item from list")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background()
    }
}

#Preview {
    FormContent()
}


//#if os(macOS)
//#endif
