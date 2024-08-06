//
//  Home.swift
//  LittleLemon
//
//  Created by Amr Waleed Helmy on 8/6/24.
//

import SwiftUI

struct Home: View {
    
    @State private var tabSelection = 1
    let persistence = PersistenceController.shared
    
    var body: some View {
        // Default TabView Template for now
        TabView(selection: $tabSelection) {
            Menu()
                .tabItem { Label("Menu", systemImage: "list.dash") }
                .tag(1)
                .environment(\.managedObjectContext, persistence.container.viewContext)
            UserProfile()
                .tabItem { Label("Profile", systemImage: "square.and.pencil") }
                .tag(2)
        }
        .accentColor(Color("Primary2"))
        .navigationBarBackButtonHidden(true) // hide back button on home screen
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
