//
//  ContentView.swift
//  Shared
//
//  Created by Kakha Sepashvili on 1/15/22.
//

import SwiftUI





struct ContentView: View {
    
    @Environment(\.colorScheme) var currentMode
    @StateObject var viewModel = ViewModel()
    @StateObject var networkManager = NetworkManager()
    @State private var userEnabledDark: Bool = false
    @State private var refreshedView: Bool = false
    
    
   
    
    
    var body: some View {
        ZStack {
            
            Color( userEnabledDark == false ? .white : .black)
               
            VStack {
                if networkManager.isConnected != true {
                    Text("for Updates connect to the Internet")
                        .foregroundColor(userEnabledDark == false ? .black : .white)
                        .fontWeight(.light)
                        .frame(width: 300, height: 130, alignment: .center)
                }
                Text(viewModel.quoteText)
                    .foregroundColor(userEnabledDark == false ? .black : .white)
                    .fontWeight(.light)
                    .frame(width: 300, height: 130, alignment: .center)
                Text(viewModel.quoteAuthor)
                    .fontWeight(.semibold)
                    .foregroundColor(userEnabledDark == false ? .black : .white)
                    .multilineTextAlignment(.center)
                    .frame(width: 300, height: 80, alignment: .center)
                HStack {
                    ToggleView(userEnabledDarkMode: $userEnabledDark, refreshedView: .constant(refreshedView), lightImage: "sun.min.fill", darkImage: "moon.circle", lightColor: .white, darkColor: .black, action: _userEnabledDark)
                        .padding()
                    ToggleView(userEnabledDarkMode: .constant(userEnabledDark), refreshedView: $refreshedView, lightImage: "repeat.circle", darkImage: "repeat.circle", lightColor: .white, darkColor: .black, action: _refreshedView)
                        .padding()
                        .onChange(of: refreshedView) { _ in
                                viewModel.fetchQuotes()    
                        }
                }
          
            }
            .onAppear(perform: {if currentMode == .light {
                userEnabledDark = false
            } else {
                userEnabledDark = true
            }})
            if viewModel.isLoading {
                 LoadingView()
             }
                
        }

        .ignoresSafeArea()
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
