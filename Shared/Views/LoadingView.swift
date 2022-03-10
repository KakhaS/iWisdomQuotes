//
//  LoadingView.swift
//  iWisdom
//
//  Created by Kakha Sepashvili on 1/22/22.
//


import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            LottieView(animationName: "lottie-loading", loopMode: .loop, contentMode: .center)
            
                .frame(width: 330, height: 300, alignment: .center)
        }
       
    }
}
