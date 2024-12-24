//
//  NewsPresenter.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 23.12.2024.
//

import UIKit

protocol NewsPresentationLogic {
    func presentNews(response: News.FetchNews.Response)
}

final class NewsPresenter: NewsPresentationLogic {
    weak var viewController: NewsDisplayLogic?
    
    func presentNews(response: News.FetchNews.Response) {
        let displayedNews = response.articles.map { article in
            print("Article ID: \(article.newsId ?? 0)")
            return News.NewsDisplayModel(
                title: article.title ?? "No title",
                description: article.announce ?? "No description",
                imageUrl: article.img?.url,
                articleUrl: article.articleUrl
            )
        }
        let viewModel = News.FetchNews.ViewModel(displayedNews: displayedNews)
        viewController?.displayNews(viewModel: viewModel)
    }
}
