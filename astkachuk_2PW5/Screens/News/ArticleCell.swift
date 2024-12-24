//
//  ArticleCell.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 23.12.2024.
//

import UIKit

final class ArticleCell: UITableViewCell {
    static let reuseId = "ArticleCell"
    
    // MARK: - Constants
    private enum Constants {
        static let imageViewbackgroundColor: UIColor = .systemGray6
        
        static let titleLabelFont: UIFont = .systemFont(ofSize: 16, weight: .bold)
        static let titleLabelNumberOfLines: Int = 2
        
        static let descriptionLabelFont: UIFont = .systemFont(ofSize: 14)
        static let descriptionLabelTextColor: UIColor = .gray
        static let descriptionLabelNumberOfLines: Int = 6
        
        static let contentViewFrame: UIEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        
        static let containerViewTopPadding: Double = 8
        static let containerViewBottomPadding: Double = 8
        static let containerViewLeftPadding: Double = 16
        static let containerViewRightPadding: Double = 16
        
        static let articleImageViewHeight: Double = 100
        static let articleImageViewWidth: Double = 100
        
        static let titleLabelLeftPadding: Double = 12
        
        static let descriptionLabelTopPadding: Double = 8
        static let descriptionLabelLeftPadding: Double = 12
        static let descriptionLabelBottomPadding: Double = 0
    }
    
    // MARK: - UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = Constants.imageViewbackgroundColor
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.titleLabelFont
        label.numberOfLines = Constants.titleLabelNumberOfLines
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.descriptionLabelFont
        label.textColor = Constants.descriptionLabelTextColor
        label.numberOfLines = Constants.descriptionLabelNumberOfLines
        return label
    }()
    
    // MARK: - Properties
    private var imageURL: URL?
    private var imageLoadTask: DispatchWorkItem?
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel()
        imageLoadTask = nil
        articleImageView.image = nil
        imageURL = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: Constants.contentViewFrame)
    }
    
    // MARK: - UI Configuration
    private func configureUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(articleImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        containerView.pinTop(to: contentView, Constants.containerViewTopPadding)
        containerView.pinLeft(to: contentView, Constants.containerViewLeftPadding)
        containerView.pinRight(to: contentView, Constants.containerViewRightPadding)
        containerView.pinBottom(to: contentView, Constants.containerViewBottomPadding)

        articleImageView.pinTop(to: containerView)
        articleImageView.pinLeft(to: containerView)
        articleImageView.setWidth(Constants.articleImageViewWidth)
        articleImageView.setHeight(Constants.articleImageViewHeight)

        titleLabel.pinTop(to: containerView)
        titleLabel.pinLeft(to: articleImageView.trailingAnchor, Constants.titleLabelLeftPadding)
        titleLabel.pinRight(to: containerView)

        descriptionLabel.pinTop(to: titleLabel.bottomAnchor, Constants.descriptionLabelTopPadding)
        descriptionLabel.pinLeft(to: articleImageView.trailingAnchor, Constants.descriptionLabelLeftPadding)
        descriptionLabel.pinRight(to: containerView)
        descriptionLabel.pinBottom(to: containerView, Constants.descriptionLabelBottomPadding, .lsOE)
    }
    
    // MARK: - Configuration
    func configure(with viewModel: News.NewsDisplayModel) {
        print("Обработка ячейки с заголовком: \(viewModel.title)")
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        
        if let imageUrl = viewModel.imageUrl {
            print("Скачивание изображения с URL: \(imageUrl)")
            loadImage(from: imageUrl)
        } else {
            print("No image URL provided")
            articleImageView.image = nil
        }
    }
    
    private func loadImage(from url: URL) {
        imageURL = url
        
        let task = DispatchWorkItem { [weak self] in
            guard let self = self,
                  self.imageURL == url else { return }
            
            do {
                let data = try Data(contentsOf: url)
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    // Проверяем, что URL не изменился пока загружалось изображение
                    if self.imageURL == url {
                        self.articleImageView.image = image
                    }
                }
            } catch {
                print("Ошибка загрузки изображения: \(error)")
            }
        }
        imageLoadTask = task
        DispatchQueue.global().async(execute: task)
    }
}
