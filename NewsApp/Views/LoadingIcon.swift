//
//  LoadingIcon.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/9/21.
//

import SwiftUI

struct LoadingIcon: View {
    
    @State var scale1:CGFloat = 1
    @State var scale2:CGFloat = 1
    @State var scale3:CGFloat = 1
    
    var body: some View {
        
        HStack {
            Spacer()
            
            circle(.blue)
                .scaleEffect(scale1)
            circle(.blue.opacity(0.8))
                .scaleEffect(scale2)
            circle(.blue.opacity(0.6))
                .scaleEffect(scale3)
            
            Spacer()
        }
        .onAppear(perform: {
            withAnimation(.easeIn.delay(0.0).repeatForever(autoreverses: true), {
                scale1 = 1.3
            })
            withAnimation(.easeIn.delay(0.1).repeatForever(autoreverses: true), {
                scale2 = 1.3
            })
            withAnimation(.easeIn.delay(0.2).repeatForever(autoreverses: true), {
                scale3 = 1.3
            })
        })
    }
    
    func circle(_ color:Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 20, height: 20, alignment: .center)
    }
    
}
