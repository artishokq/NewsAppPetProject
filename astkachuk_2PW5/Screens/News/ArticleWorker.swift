//
//  ArticleWorker.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 23.12.2024.
//

import UIKit

final class ArticleWorker {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return decoder
    }()
    
    private func getURL(_ rubric: Int, _ pageIndex: Int) -> URL? {
        URL(string: "https://news.myseldon.com/api/Section?rubricId=\(rubric)&pageSize=25&pageIndex=\(pageIndex)")
    }
    
    func fetchNews(completion: @escaping ([ArticleModel]?) -> Void) {
        guard let url = getURL(4, 1) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let data = data {
                do {
                    let newsPage = try self?.decoder.decode(NewsPage.self, from: data)
                    if var news = newsPage?.news {
                        for i in 0..<news.count {
                            news[i].requestId = newsPage?.requestId
                        }
                        print("Новости декодированы. Количество: \(news.count)")
                        completion(news)
                    } else {
                        completion(nil)
                    }
                } catch {
                    print("Ошибка декодирования: \(error)")
                    completion(nil)
                }
            } else {
                print("Нет данных")
                completion(nil)
            }
        }.resume()
    }
}
