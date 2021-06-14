//
//  ContentView.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/9/21.
//

import SwiftUI

struct ContentView: View {
    
    private var initialEndpoint = EndpointBuilder()
        .withApiKey("6ffeaceffa7949b68bf9d68b9f06fd33")
        .withType(.topHeadlines)
    
    @ObservedObject var newsInterface: NewsInterface
    
    private var dateToday:String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    @AppStorage("key.topic") private var topic = Topic.general
    
    init() {
        
        newsInterface = NewsInterface(initialEndpoint)
        newsInterface.reload(initialEndpoint.withTopic(topic))
    }

    
    var body: some View {
        VStack {
            HStack {
                Text(dateToday)
                    .bold()
                    .font(.system(size: 18))
                    .foregroundColor(Color(.systemGray))
                Spacer()
            }.padding(.horizontal, 20)
            
            TopicChooser(chosenTopic: $topic, onChosen: { _ in
                newsInterface.reload(initialEndpoint.withTopic(topic))
            })
            .padding(.horizontal, 10)
            
            ScrollView {
                if newsInterface.articles.isEmpty {
                    
                    if newsInterface.loading {
                        
                        loadingScreen
                    }
                    else {
                        
                        VStack {
                            Text("Sorry")
                                .font(.system(size: 32))
                                .bold()
                                .padding(.bottom, 10)
                            Text("Unable to find any articles!")
                                .font(.system(size: 18))
                        }.padding(.top, 100)
                    }
                }
                else {
                    LazyVStack(alignment: .leading) {
                        ForEach(newsInterface.articles, id: \.self, content: { article in
                            NavigationLink(
                                destination: ArticleViewer(article: article, topic: topic),
                                label: {
                                    Text(article.title)
                                        .bold()
                                        .padding(.vertical, 20)
                                        .onAppear(perform: {
                                            if article == newsInterface.articles.last {
                                                newsInterface.loadMore()
                                            }
                                        })
                                })
                        })
                    }
                    .padding(.all, 5)
                }
            }
        }
        .overlay(VStack {
            if newsInterface.loading && !newsInterface.articles.isEmpty {
                Spacer()
                LoadingIcon()
            }
        })
        .navigationTitle("Top Headlines")
        .modal($newsInterface.lastErrorStatus, view: { status in
            ErrorModal(title: "Sorry...", message: status.message, onDismiss: {
                newsInterface.dismissError()
            })
        })
    }
    
    var roundedLoader: some View {
        RoundedRectangle(cornerRadius: 20)
            .shimmer()
    }
}

extension ContentView {
    
    var loadingScreen: some View {
        VStack(spacing: 20) {
            roundedLoader
                .frame(height: 150)
            roundedLoader
                .frame(height: 30)
            
            HStack(alignment: .top, spacing: 10, content: {
                Circle()
                    .shimmer()
                    .frame(width: 100, height: 100, alignment: .center)
                Spacer()
                VStack {
                    roundedLoader
                        .frame(height: 30)
                    roundedLoader
                        .frame(height: 30)
                        .padding(.leading, -10)
                    roundedLoader
                        .frame(height: 30)
                        .padding(.leading, 70)
                }
            }).padding(.vertical, 50)
            
            HStack(alignment: .top, spacing: 10, content: {
                VStack(spacing: 20) {
                    roundedLoader
                        .frame(height: 100)
                    roundedLoader
                        .frame(height: 170)
                    roundedLoader
                        .frame(height: 190)
                }
                
                VStack(spacing: 20) {
                    roundedLoader
                        .frame(height: 180)
                    roundedLoader
                        .frame(height: 130)
                    roundedLoader
                        .frame(height: 170)
                    
                }
            })
            
        }.padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
