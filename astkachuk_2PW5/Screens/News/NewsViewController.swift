//
//  NewsViewController.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 22.12.2024.
//

import UIKit

protocol NewsDisplayLogic: AnyObject {
    func displayNews(viewModel: News.FetchNews.ViewModel)
}

final class NewsViewController: UIViewController {
    var interactor: (NewsBusinessLogic & NewsDataStore)?
    
    // MARK: - Constants
    private enum Constants {
        static let tableBackgroundColor: UIColor = .white
        static let tableEstimatedHeight: Double = 130
        static let tableSeparator: UIEdgeInsets = UIEdgeInsets(top: 2, left: 16, bottom: 2, right: 16)
        
        static let title: String = "НОВОСТИ"
        
        static let backgroundColor: UIColor = .white
    }
    
    // MARK: - UI Components
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseId)
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = Constants.tableEstimatedHeight
        table.separatorInset = Constants.tableSeparator
        table.backgroundColor = Constants.tableBackgroundColor
        return table
    }()
    
    // MARK: - Properties
    private var displayedNews: [News.NewsDisplayModel] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureComponents()
        configureUI()
        title = Constants.title
        interactor?.loadFreshNews()
    }
    
    // MARK: - Configuration
    private func configureComponents() {
        let viewController = self
        let interactor = NewsInteractor()
        let presenter = NewsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    private func configureUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.pin(to: view)
    }
}

// MARK: - NewsDisplayLogic
extension NewsViewController: NewsDisplayLogic {
    func displayNews(viewModel: News.FetchNews.ViewModel) {
        print("Количество новостей: \(viewModel.displayedNews.count)")
        displayedNews = viewModel.displayedNews
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Количество строк: \(displayedNews.count)")
        return displayedNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Обработка ячейки: \(indexPath.row)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        let news = displayedNews[indexPath.row]
        cell.configure(with: news)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Индекс нажатой ячейки: \(indexPath.row)")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let news = displayedNews[indexPath.row]
        print("Article URL: \(String(describing: news.articleUrl))")
        
        guard let articleUrl = news.articleUrl else {
            print("No article URL available")
            return
        }
        
        let webViewController = WebViewController()
        webViewController.url = articleUrl
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let news = displayedNews[indexPath.row]
        
        let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] (action, view, completion) in
            guard let articleUrl = news.articleUrl else {
                completion(false)
                return
            }
            let items: [Any] = [articleUrl]
            let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
            self?.present(activityViewController, animated: true, completion: nil)
            completion(true)
        }
        
        shareAction.backgroundColor = .systemBlue
        let configuration = UISwipeActionsConfiguration(actions: [shareAction])
        return configuration
    }
}
