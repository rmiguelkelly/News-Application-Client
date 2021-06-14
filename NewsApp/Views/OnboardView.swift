//
//  OnboardView.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/14/21.
//

import SwiftUI

struct OnboardView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Welcome")
                    .bold()
                    .font(.system(size: 24))
                    .foregroundColor(Color(.label))
                Text("Your News App")
                    .font(.system(size: 18))
                    .foregroundColor(Color(.systemGray))
                
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 1, height: 50, alignment: .center)
                    .padding(.vertical, 10)
                
                Capsule()
                    .fill(Color.blue)
                    .frame(width: 150, height: 40, alignment: .center)
                    .overlay(Button("Setup API Key", action: {
                        
                    }).foregroundColor(.white))
            }
            
            
        }
    }
}

struct OnboardView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardView()
    }
}
