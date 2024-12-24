//
//  NewsInteractor.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 23.12.2024.
//

import UIKit

protocol NewsBusinessLogic {
    func loadFreshNews()
    func loadMoreNews()
}

protocol NewsDataStore {
    var articles: [ArticleModel] { get set }
}

final class NewsInteractor: NewsBusinessLogic, NewsDataStore {
    var presenter: NewsPresentationLogic?
    var worker: ArticleWorker = ArticleWorker()
    
    var articles: [ArticleModel] = [] {
        didSet {
            let response = News.FetchNews.Response(articles: articles)
            presenter?.presentNews(response: response)
        }
    }
    
    func loadFreshNews() {
        worker.fetchNews { [weak self] newArticles in
            if let newArticles = newArticles {
                DispatchQueue.main.async {
                    self?.articles = newArticles
                }
            }
        }
    }
    
    func loadMoreNews() {
        worker.fetchNews { [weak self] newArticles in
            if let newArticles = newArticles {
                DispatchQueue.main.async {
                    self?.articles.append(contentsOf: newArticles)
                }
            }
        }
    }
}
