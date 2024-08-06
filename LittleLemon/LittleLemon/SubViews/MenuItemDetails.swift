//
//  MenuItemDetails.swift
//  LittleLemon
//
//  Created by Amr Waleed Helmy on 8/6/24.
//

import SwiftUI

struct MenuItemDetails: View {
    let dishEntity: Dish
    
    var body: some View {
        
        ZStack {
            Color("Primary1")
                .ignoresSafeArea()
            VStack {
                HStack{
                    Spacer()
                    Text("\(dishEntity.title ?? "Unknown title")")
                        .font(.system(size: 60))
                        .bold()
                        .foregroundColor(Color.white)
                    Spacer()
                }
                // using Apple example of error handling for AsyncImage
                AsyncImage(url: URL(string: dishEntity.image ?? "no image")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(5)
                            .padding()
                        
                    } else if phase.error != nil {
                        Label("Could not load image", systemImage: "photo")
                            .foregroundColor(Color("Secondary1"))
                    } else {
                        ProgressView("Loading...")
                            .foregroundColor(Color.white)
                            .tint(Color.white)
                            
                    }
                } // end AsyncImage
                
                VStack (alignment: .leading){
                    Text("$\(dishEntity.price ?? "Unknown price")")
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color("Secondary1"))
                        .padding()
                    Text("\(dishEntity.foodDescription ?? "Description not provided")")
                        .font(.title3)
                        .italic()
                        .foregroundColor(Color.white)
                        .padding()
                }
            } // end VStack
        }
        
       
    }
}

//struct MenuItemDetails_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuItemDetails()
//    }
//}
