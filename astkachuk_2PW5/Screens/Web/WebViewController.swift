//
//  WebViewController.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 24.12.2024.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: - Properties
    var url: URL?
    
    // MARK: - Constants
    private enum Constants {
        static let backgroundColor: UIColor = .white
    }
    
    // MARK: - UI Components
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        setupUI()
        loadContent()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        view.addSubview(webView)
        webView.pinHorizontal(to: view)
        webView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        webView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    private func loadContent() {
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
}
