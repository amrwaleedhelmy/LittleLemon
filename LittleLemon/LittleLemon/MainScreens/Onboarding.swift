//
//  Onboarding.swift
//  LittleLemon
//
//  Created by Amr Waleed Helmy on 8/6/24.
//

import SwiftUI

// User Default keys - global variables
let firstNameKey = "First_Name_Key"
let lastNameKey = "Last_Name_Key"
let emailKey = "Email_Key"
let loggedInKey = "Logged_In_Key"

// Custom modifier for onboarding TextFields
struct OnboardingTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("Primary2"))
            .padding()
            .overlay { RoundedRectangle(cornerRadius: 5)
                    .stroke(.yellow, lineWidth: 1)
            }
            .padding(.horizontal)
    }
}


struct Onboarding: View {
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var isLoggedIn = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("Primary1")
                    .ignoresSafeArea()
                VStack{
                    Text("Welcome to the Little Lemon App! ")
                        .foregroundColor(.yellow)
                        .font(.title)
                        .padding([.top, .horizontal])
                        .bold()
                    
                    Text("Create an account to continue")
                        .bold()
                        .foregroundColor(Color("Primary2"))
                        .padding()
                    
                    // Note - assignment requests iOS15 style coding, latest OS is iOS17
                    NavigationLink(destination: Home(),
                                   isActive: $isLoggedIn) {
                        EmptyView()
                    }
                    
                    TextField("",
                              text: $firstName,
                              prompt: Text("First Name")
                        .foregroundColor(.gray)
                    )
                    .modifier(OnboardingTextField())
                    
                    
                    TextField("",
                              text: $lastName,
                              prompt: Text("Last Name")
                        .foregroundColor(.gray)
                    )
                    .modifier(OnboardingTextField())
                    
                    TextField("",
                              text: $email,
                              prompt: Text("Email").foregroundColor(.gray)
                    )
                    .modifier(OnboardingTextField())
                    
                    Button {
                        if ( !firstName.isEmpty &&
                             !lastName.isEmpty &&
                             !email.isEmpty) {
                            UserDefaults.standard.set(firstName, forKey: firstNameKey)
                            UserDefaults.standard.set(lastName, forKey: lastNameKey)
                            // TODO: add email validation
                            UserDefaults.standard.set(email, forKey: emailKey)
                            UserDefaults.standard.set(true, forKey: loggedInKey)
                            
                            isLoggedIn = true
                            
                            // clear entry fields for logout
                            firstName = ""
                            lastName = ""
                            email = ""
                            
                        } else {
                            // TODO: add alert to signify fields not completed
                        }
                        
                    } label: {
                        Text("Register")
                            .frame(maxWidth: 150)
                    }
                    .buttonStyle(.bordered)
                    .background(Color("Primary2"))
                    .foregroundColor(Color.black)
                    .cornerRadius(5)
                    .padding(.vertical)
                    
                } // end VStack
                .onAppear {
                    if ( UserDefaults.standard.bool(forKey: loggedInKey) ) {
                        isLoggedIn = true
                    }
                }
            }
        } // end Navigation View
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
