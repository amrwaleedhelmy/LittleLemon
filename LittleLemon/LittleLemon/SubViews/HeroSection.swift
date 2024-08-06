//
//  HeroSection.swift
//  LittleLemon
//
//  Created by Amr Waleed Helmy on 8/6/24.
//

import SwiftUI

struct HeroSection: View {
    
    let AppDescription = "We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist."

    @Binding var textEntry: String
    
    var body: some View {
        VStack (alignment: .leading) {
            VStack (alignment: .leading) {
                Text("Little Lemon").foregroundColor(Color("Primary2"))
                    .font(.largeTitle)
                    .font(.custom("Avenir Book", size: 22))
                    .bold()
                    .padding([.leading])
                Text("Chicago")
                    .foregroundColor(Color.white)
                    .font(.title)
                    .padding([.leading])
            }
            
            HStack{
                Text(AppDescription)
                    .foregroundColor(Color.white)
                    .font(.title3)
                    .padding([.leading])
                Image("Hero Image")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding([.bottom, .trailing])
            }
            // Search Bar
            TextField("🔍 Search menu", text: $textEntry)
                .padding(5)
                .foregroundColor(.black)
                .overlay { RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.yellow)}
                .background(Color.white)
                .padding()
        }
        .background(Color("Primary1"))
        .ignoresSafeArea()
    }
}

struct HeroSection_Previews: PreviewProvider {
    static var previews: some View {
        HeroSection(textEntry: .constant("Entered Text"))
            .previewLayout(.sizeThatFits)
    }
}
