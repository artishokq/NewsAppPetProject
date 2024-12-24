//
//  ArticleModel.swift
//  astkachuk_2PW5
//
//  Created by Artem Tkachuk on 23.12.2024.
//

import Foundation

struct NewsPage: Decodable {
    let newsSecondaryData: String?
    let news: [ArticleModel]?
    let requestId: String?
    let newsTotalCount: Int?
    let userNewsLeft: Int?
    
    private enum CodingKeys: String, CodingKey {
        case newsSecondaryData
        case news
        case requestId
        case newsTotalCount
        case userNewsLeft
    }
}

struct ArticleModel: Decodable {
    let newsId: Int?
    let title: String?
    let announce: String?
    let img: ImageContainer?
    let sourceLink: String?
    let sourceName: String?
    let date: String?
    
    var requestId: String?
    
    var articleUrl: URL? {
        guard let newsId = newsId, let requestId = requestId else {
            print("Cannot create URL: newsId = \(String(describing: newsId)), requestId = \(String(describing: requestId))")
            return nil
        }
        let urlString = "https://news.myseldon.com/ru/news/index/\(newsId)?requestId=\(requestId)"
        print("Creating URL: \(urlString)")
        return URL(string: urlString)
    }
}

struct ImageContainer: Decodable {
    let url: URL?
    let width: Int?
    let height: Int?
    let isRemote: Bool?
    
    private enum CodingKeys: String, CodingKey {
        case url = "url"
        case width
        case height
        case isRemote
    }
}

// MARK: - Helpers
extension CodingUserInfoKey {
    static let requestIdKey = CodingUserInfoKey(rawValue: "requestId")!
}

extension Decoder {
    func with(userInfo: [CodingUserInfoKey: Any]) -> Decoder {
        let newInfo = (self.userInfo).merging(userInfo) { $1 }
        return DecoderWithUserInfo(base: self, userInfo: newInfo)
    }
}

private struct DecoderWithUserInfo: Decoder {
    let base: Decoder
    var userInfo: [CodingUserInfoKey: Any]
    var codingPath: [CodingKey] { base.codingPath }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        try base.container(keyedBy: type)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        try base.unkeyedContainer()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        try base.singleValueContainer()
    }
}

extension KeyedDecodingContainer {
    func decodeIfPresent<T: Decodable>(_ type: T.Type, forKey key: Key, decoder: Decoder) throws -> T? {
        guard contains(key) else { return nil }
        _ = try nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try T(from: decoder)
    }
}

private struct JSONCodingKeys: CodingKey {
    var stringValue: String
    var intValue: Int?
    
    init?(stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }
    
    init?(intValue: Int) {
        self.stringValue = String(intValue)
        self.intValue = intValue
    }
}
