//
//  ToggleView.swift
//  iWisdom
//
//  Created by Kakha Sepashvili on 1/22/22.
//

import SwiftUI

struct ToggleView: View {
    @Binding var userEnabledDarkMode: Bool
    @Binding var refreshedView: Bool
    let lightImage: String
    let darkImage: String
    let lightColor: Color
    let darkColor: Color
    var action: State<Bool>
    
    var body: some View {
        Image(systemName: userEnabledDarkMode ? lightImage : darkImage)
            .resizable()
            .foregroundColor(userEnabledDarkMode  ? lightColor : darkColor)
            .preferredColorScheme(userEnabledDarkMode ? .dark : .light)
                            .frame(width: 50, height: 50)
                            .onTapGesture {action.wrappedValue.toggle()  }
                         
                           
    }

}
