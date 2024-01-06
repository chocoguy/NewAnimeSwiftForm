//
//  Navbar.swift
//  NewAnimeSwiftForm
//
//  Created by Edgar Zarco on 12/16/23.
//

import SwiftUI

struct Navbar: View {
        var body: some View {
            VStack(alignment: .leading){
                NavigationLink(destination: {
                    Home()
                }, label: {
                    HStack{
                        Image(systemName: "face.smiling").foregroundStyle(.blue)
                        Text("Home").foregroundStyle(.blue)
                    }.frame(width: 120)
                })
                NavigationLink(destination: {
                    Text("Schedule Screen")
                }, label: {
                    HStack{
                        Image(systemName: "list.bullet").foregroundStyle(.blue)
                        Text("Schedule").foregroundStyle(.blue)
                    }.frame(width: 120)
                })
                NavigationLink(destination: {
                    Text("MAL Digest Screen")
                }, label: {
                    HStack{
                        Image(systemName: "globe").foregroundStyle(.blue)
                        Text("MAL Digest").foregroundStyle(.blue)
                    }.frame(width: 120)
                })
                NavigationLink(destination: {
                    Text("Settings or about screen")
                }, label: {
                    HStack{
                        Image(systemName: "gearshape").foregroundStyle(.blue)
                        Text("About").foregroundStyle(.blue)
                    }.frame(width: 120)
                })
                
                Spacer()
                //            Button("Add status", action: addStatusItem)
            }
        }
}

