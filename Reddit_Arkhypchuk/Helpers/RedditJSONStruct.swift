//
//  RedditFlow.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 15.02.2022.
//

import Foundation

struct RedditData: Codable{
    let data: Details
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct Details:Codable{
    let after: String?
    let children: [Child]
    
    enum CodingKeys: String, CodingKey {
        case children
        case after
    }
}

struct Child: Codable{
    let data: Info
    
    enum CodingKeys: String, CodingKey{
        case data
    }
}

struct Info:Codable{
    let username: String
    let domain: String
    let time: Double
    let title: String
    let preview: Preview?
    let rating: Int
    let comments: Int
    
    enum CodingKeys: String, CodingKey{
        case username = "author"
        case domain
        case time = "created_utc"
        case title
        case preview
        case rating = "score"
        case comments = "num_comments"
    }
}

struct Preview: Codable{
    let images: [Image]
    
    enum CodingKeys: String, CodingKey{
        case images
    }
}

struct Image:Codable{
    let source: Source
    enum CodingKeys:String, CodingKey{
        case source
    }
}

struct Source: Codable{
    let url: String
    
    enum CodingKeys:String, CodingKey{
        case url
    }
}
