//
//  ArticleViewer.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/13/21.
//

import SwiftUI
import Combine

struct ArticleViewer: View {
    
    let article:Article
    let topic:Topic
    
    @ObservedObject var sourceIcon = SourceIcon()
    
    @State private var image:UIImage? = nil
    
    @Environment(\.presentationMode) var presentationMode
    
    private var dateFormatter:DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ScrollView {
            GeometryReader { proxy in
                VStack {
                    if let image = image {
                        
                        let y = proxy.frame(in: .global).origin.y
                        
                        ZStack(alignment: .center, content: {
                            Group {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(height: 300)
                                    .clipped()
                                    .blur(radius: max(y / 50, 0))
                                LinearGradient(gradient: Gradient(colors: [.black.opacity(0.5), .clear]), startPoint: .top, endPoint: .bottom)
                            }
                            .scaleEffect(max(y / 500 + 1, 1))
                        })
                        .offset(y: min(-y, 0))
                    }
                    
                    VStack {
                        
                        HStack {
                            if let image = sourceIcon.icon {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 15, height: 15, alignment: .center)
                            }
                            Text(article.source.name)
                                .bold()
                                .font(.system(size: 12))
                            Spacer()
                        }
                        
                        HStack {
                            Text(article.title)
                                .bold()
                                .lineLimit(nil)
                                .font(.system(size: 22))
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        .padding(.top, 10)
                        
                        HStack {
                            if let author = article.author {
                                Text("By \(author)")
                                    .foregroundColor(Color(.systemGray))
                                Spacer()
                            }
                            
                            Text(article.publishedAt, formatter: dateFormatter)
                                .foregroundColor(Color(.systemGray))
                            
                            if article.author == nil {
                                Spacer()
                            }
                        }
                        .padding(.top, 5)
                        
                        if let content = article.content {
                            Text(content)
                                .lineLimit(nil)
                                .lineSpacing(10)
                                .font(.system(size: 18))
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.top, 20)
                        }
                        
                        Capsule()
                            .fill(Color(.label))
                            .frame(width: 180, height: 40, alignment: .center)
                            .overlay(Button("Continue Reading", action: {
                                UIApplication.shared.open(article.url, options: [:], completionHandler: nil)
                            }).foregroundColor(Color(.systemBackground)))
                            .padding(.top, 20)
                        
                        
                    }
                    .padding(.horizontal, 10)
    
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
        .onAppear(perform: {
            
            //  Try to load the icon of the source
            sourceIcon.loadFrom(article)
            
            //  If an image media exists, download it
            if let url = article.urlToImage {
                URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                    if let data = data, let image = UIImage(data: data) {
                        self.image = image
                    }
                }).resume()
            }
        })
    }
}

struct ArticleViewer_Previews: PreviewProvider {
    static var previews: some View {
        ArticleViewer(article: Article(source: ArticleSource(id: "test", name: "CNN"), author: "Test Author", title: "Test Title", description: "A very long descripton about soemthing", url: URL(string: "https://www.example.com/")!, urlToImage: nil, publishedAt: Date(), content: ""), topic: .entertainment)
    }
}
