//
//  Modal.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/13/21.
//

import SwiftUI

struct ErrorModal: View {
    
    @State private var offset:CGFloat = -20
    
    let title:String
    let message:String
    
    let onDismiss:(() -> Void)
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .bold()
                    .font(.system(size: 24))
                    .foregroundColor(Color(Theme.error))
                Spacer()
            }
            .padding(.bottom, 10)
            Text(message)
            
            Capsule()
                .fill(Color(Theme.error))
                .frame(width: 200, height: 40, alignment: .center)
                .overlay(Button("Okay", action: onDismiss).foregroundColor(.white))
                .padding(.top, 10)
        }
        .padding()
        .frame(width: 250)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .offset(y: offset)
        .onAppear(perform: {
            withAnimation {
                offset = 0
            }
        })
        .onDisappear(perform: {
            withAnimation {
                offset = -20
            }
        })
    }
}

struct Modal_Previews: PreviewProvider {
    static var previews: some View {
        ErrorModal(title: "", message: "", onDismiss: { })
    }
}
