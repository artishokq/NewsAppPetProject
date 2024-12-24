//
//  NewsModels.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 23.12.2024.
//

import Foundation

enum News {
    enum FetchNews {
        struct Request {
            
        }
        
        struct Response {
            var articles: [ArticleModel]
        }
        
        struct ViewModel {
            var displayedNews: [NewsDisplayModel]
        }
    }
    
    struct NewsDisplayModel {
        let title: String
        let description: String
        let imageUrl: URL?
        let articleUrl: URL?
    }
}
