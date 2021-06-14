//
//  Articles+Controller.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/9/21.
//

import Foundation
import UIKit

class NewsInterface: ObservableObject {
    
    //  A list of all loaded articles
    @Published var articles = [Article]()
    
    //  Set to true when the network request is in progress
    @Published var loading = false
    
    //  Is set when an error occurs
    @Published var lastErrorStatus:ErrorStatus? = nil
    
    private var page = 1
    
    private var decoder:JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    private var url:URL
    
    init(_ endpoint: EndpointBuilder) {
        
        self.url = endpoint.request()
    }
    
}

extension NewsInterface {
    
    func reload(_ endpoint: EndpointBuilder) {
        
        url = endpoint.request()
        articles = []
        page = 1
        
        loadMore()
    }
    
    func dismissError() {
        
        lastErrorStatus = nil
    }
    
    //  Attempts to load another page of articles with the current request info
    func loadMore() {
        
        loading = true
        
        URLSession.shared.dataTask(with: url, completionHandler: { [self] data, res, err in
            
            if let data = data, err == nil {
             
                DispatchQueue.main.async {
                    
                    //  If the status is an OK, append the articles
                    if let validResponse = try? decoder.decode(SuccessStatus.self, from: data) {
                        
                        articles += validResponse.articles

                        page += 1
                    }
                    else {
                        
                        if let errorStatus = try? decoder.decode(ErrorStatus.self, from: data) {
                            
                            lastErrorStatus = errorStatus
                            print(errorStatus)
                        }
                    }
                    
                    loading = false
                }
                
            }
            
        }).resume()
    }
}

class SourceIcon: ObservableObject {
    
    @Published var icon:UIImage? = nil
    
    func loadFrom(_ article:Article) {
        if let host = article.url.host, let scheme = article.url.scheme, let url = URL(string: "\(scheme)://\(host)/favicon.ico") {
            URLSession.shared.dataTask(with: url, completionHandler: { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        self.icon = UIImage(data: data)
                    }
                }
            }).resume()
        }
    }
    
}
