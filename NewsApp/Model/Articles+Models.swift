//
//  News.swift
//  NewsApp
//
//  Created by Ronan Kelly on 6/9/21.
//

import Foundation

enum NewsType: String {
    
    typealias RawValue = String
    
    case everything = "everything"
    case topHeadlines = "top-headlines"
}

enum Topic: String, CaseIterable {
    
    typealias RawValue = String
    
    case business = "business"
    case entertainment = "entertainment"
    case general = "general"
    case health = "health"
    case science = "science"
    case sports = "sports"
    case technology = "technology"
}

class EndpointBuilder {
    
    private let baseurl = URL(string: "https://newsapi.org/v2/")!
    
    private var apiKey:String? = nil
    private var topic:Topic? = nil
    private var type:NewsType = .everything
    private var language = "en"
    private var country = "us"
    private var search:String? = nil
    private var pageSize:Int = 100
    
    func withApiKey(_ key: String) -> EndpointBuilder {
        
        self.apiKey = key
        return self
    }
    
    func withTopic(_ topic: Topic? = .none) -> EndpointBuilder {
        
        self.topic = topic
        return self
    }
    
    func withType(_ type: NewsType = .everything) -> EndpointBuilder {
        
        self.type = type
        return self
    }
    
    func withLanguage(_ language:String = "en") -> EndpointBuilder {
        
        self.language = language
        return self
    }
    
    func withCountry(_ country:String = "us") -> EndpointBuilder {
        
        self.country = country
        return self
    }
    
    func withSearchQuery(_ search:String? = nil) -> EndpointBuilder {
        
        self.search = search
        return self
    }
    
    func withPageSize(_ size:Int = 100) -> EndpointBuilder {
        
        self.pageSize = size
        return self
    }
    
    func request() -> URL {
        
        var built = baseurl
        
        built.appendPathComponent(type.rawValue)
        
        guard var components = URLComponents(url: built, resolvingAgainstBaseURL: true) else {
            
            fatalError("Unable to build URL")
        }
        
        var queries = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "language", value: language),
            URLQueryItem(name: "q", value: search),
            URLQueryItem(name: "pageSize", value: "\(pageSize)"),
        ]
        
        if type == .topHeadlines {
            
            queries.append(URLQueryItem(name: "country", value: country))
            queries.append(URLQueryItem(name: "category", value: topic?.rawValue))
        }
        
        components.queryItems = queries
        
        print(components.url!)
        
        return components.url!
    }
}

struct ArticleSource: Codable, Identifiable, Hashable {
    
    var id: String?
    
    var name: String
}

struct Article: Codable, Hashable {
    
    var source: ArticleSource
    
    var author: String?
    
    var title: String
    
    var description: String
    
    var url:URL
    
    var urlToImage: URL?
    
    var publishedAt: Date
    
    var content: String?
    
    static func == (lhs: Article, rhs: Article) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

protocol Status {
    
    var status: String { get }
}

struct ErrorStatus: Status, Codable {
    
    var status: String
    
    var code: String
    
    var message: String
}

struct SuccessStatus: Status, Codable {
    
    var status: String
    
    var totalResults: Int
    
    var articles: [Article]
}
