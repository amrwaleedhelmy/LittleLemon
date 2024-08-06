//
//  Menu.swift
//  LittleLemon
//
//  Created by Amr Waleed Helmy on 8/6/24.
//

import SwiftUI

struct Menu: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText = ""
    @State private var predicateSelection = PredicateSelection.None
    @State private var previousPredicate = PredicateSelection.None
    
    enum PredicateSelection {
        case None
        case Starters
        case Mains
        case Desserts
    }
    
    var body: some View {
        NavigationView {
            VStack{
                NavigationBar()
                HeroSection(textEntry: $searchText)
                VStack {
                    HStack {
                        Text("OUT FOR DELIVERY")
                            .bold()
                            .font(.caption)
                        Image("Delivery Van")
                            .resizable()
                            .frame(width: 50, height: 25)
                    }
                    
                    HStack(spacing: 20) {
                        Button("Starters"){
                            handlePredicate(currentPredicate: .Starters)
                        }
                        .foregroundColor(.black)
                        .buttonStyle(.bordered)
                        .background(predicateSelection == .Starters ? Color("Secondary1") : Color.white)
                        .cornerRadius(10)
                        
                        Button("Mains"){
                            handlePredicate(currentPredicate: .Mains)
                        }
                        .foregroundColor(.black)
                        .buttonStyle(.bordered)
                        .background(predicateSelection == .Mains ? Color("Secondary1") : Color.white)
                        .cornerRadius(10)
                        
                        .cornerRadius(10)
                        Button("Desserts") {
                            handlePredicate(currentPredicate: .Desserts)
                        } .foregroundColor(.black)
                            .buttonStyle(.bordered)
                            .background(predicateSelection == .Desserts ? Color("Secondary1") : Color.white)
                            .cornerRadius(10)
                    }
                    
                    FetchedObjects(predicate: buildPredicate()
                                   ,sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                        List {
                            ForEach(dishes, id: \.self) { dish in
                                
                                NavigationLink {
                                    MenuItemDetails(dishEntity: dish)
                                } label: {
                                    SingleMenuItem(dishEntity: dish)
                                }
                            }
                        }
                    } // end FetchedObjects
                } // end VStack (Bottom Half of Menu)
            } // end VStack (entire Menu)
            .onAppear {
                getMenuData()
            }
        }.accentColor(Color.white) // Navigation Back button
    }
    
    func getMenuData() {
        
        // clear database (per Coursera course instruction)
        PersistenceController.shared.clear()
        
        // get URL
        let url = URL(string: "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json")!
        
        // create URL request
        let urlRequest = URLRequest(url: url)
        
        // create URL Session task
        let task = URLSession.shared.dataTask(with: urlRequest) { data, reponse, error in
            
            if let data = data, let string = String(data: data, encoding: .utf8) {
                
                // convert string to Data format
                let menuListData = Data(string.utf8)
                
                // create decoder and use it to decode based off of MenuList created earlier
                let decoder = JSONDecoder()
                let menuList = try! decoder.decode(MenuList.self, from: menuListData)
                
                // convert decoded data to CoreData entities
                for foodItem in menuList.menu {
                    let newDish = Dish(context: viewContext) // Note - initially had an error saying "Dish could not be found" - quitting and restarting Xcode seemed to solve this as this class is created dynamically
                    
                    newDish.title = foodItem.title
                    newDish.price = foodItem.price
                    newDish.image = foodItem.image
                    newDish.category = foodItem.category
                    newDish.foodDescription = foodItem.description
                }
                
                try? viewContext.save() // save to CoreData
                
            } else {
                print("unsuccessful decoding - data not valid")
            }
        }
        task.resume()
    }
    
    func handlePredicate(currentPredicate: PredicateSelection) {
        // save off previous predicate selection
        previousPredicate = predicateSelection
        
        // assign current predicate selection
        predicateSelection = currentPredicate
        
        // Button has been pressed twice, reset
        if previousPredicate == predicateSelection {
            predicateSelection = .None
        }
    }
    
    
    func buildSortDescriptors() -> [NSSortDescriptor] {
        
        // alphabetical sort descriptor
        return [
            NSSortDescriptor(key: "title",
                             ascending: true,
                             selector: #selector(NSString.localizedCaseInsensitiveCompare))
        ]
    }
    
    func buildPredicate() -> NSPredicate {
        
        // have predicates default to no filtering
        var searchPredicate = NSPredicate(value: true)
        var buttonPredicate = NSPredicate(value: true)
        
        if searchText.isEmpty {
            // do nothing
        } else {
            // filter on TextField entry
            searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@",  "\(searchText)")
        }
        
        // additional category predicate
        let starters = NSPredicate(format: "category MATCHES[cd] %@", "starters")
        let mains = NSPredicate(format: "category MATCHES[cd] %@", "mains")
        let desserts = NSPredicate(format: "category MATCHES[cd] %@", "desserts")
        
        switch predicateSelection {
        case .None:
            buttonPredicate = NSPredicate(value: true)
        case .Starters:
            buttonPredicate = starters
        case .Mains:
            buttonPredicate = mains
        case .Desserts:
            buttonPredicate = desserts
        }
        
        
        let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [searchPredicate, buttonPredicate])
        
        return compoundPredicate
    }
    
    
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
