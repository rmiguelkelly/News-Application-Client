//
//  Extensions.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/12/21.
//

import SwiftUI

struct Shimmer: View {
    
    @State var gradientOffset:CGFloat = 0.0
    
    private var gradient:Gradient {
        Gradient(colors: [
            Color(.systemGray),
            Color(.systemGray2),
            Color(.systemGray3),
            Color(.systemGray4)
        ])
    }
    
    var body: some View {
        LinearGradient(gradient: gradient, startPoint: UnitPoint(x: 0, y:  gradientOffset - 0.6), endPoint: UnitPoint(x: 1, y: 0.3))
            .onAppear(perform: {
                withAnimation(Animation.easeIn(duration: 1.3).repeatForever(autoreverses: true), {
                    gradientOffset = 0.0
                })
            })
    }
}

//  Add view modifier to shape for a shimmering loading effect
extension Shape {
    
    ///  Adds a shimmering effect to a shape
    func shimmer() -> some View {
        Shimmer()
            .clipShape(self)
    }
}

extension UIColor {
    
    static func fromHex(_ hex:UInt32) -> UIColor {
        
        let r = (hex & 0xFF0000) >> 0x10
        let g = (hex & 0x00FF00) >> 0x8
        let b = (hex & 0x0000FF)
        
        return UIColor(red: CGFloat(r) / 0xFF, green: CGFloat(g) / 0xFF, blue: CGFloat(b) / 0xFF, alpha: 1)
    }
}


extension View {
    
    func modal<T, V: View>(_ model:Binding<T?>, view: @escaping (T) -> V) -> some View {
        
        if let model = model.wrappedValue {
            return AnyView(self.overlay(view(model)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                                            .background(Color.black.opacity(0.3)).ignoresSafeArea().zIndex(0).transition(.move(edge: .top))))
        }
        else {
            return AnyView(self)
        }
    }
}
