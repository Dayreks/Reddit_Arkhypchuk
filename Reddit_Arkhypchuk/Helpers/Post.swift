//
//  Post.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 13.05.2022.
//

import Foundation

class Post: Codable{
    var username: String = "default"
    var domain: String = "/default"
    var time: String = "0h"
    var title: String = "None"
    var image: String? = nil
    var rating: Int = 0
    var comments: Int = 0
    var after: String? = nil
    var isSaved: Bool = false
    var link: String = ""
    var id: String = ""
    
    enum CodingKeys: String, CodingKey{
        case username
        case domain
        case time
        case title
        case image
        case rating
        case comments
        case after
        case isSaved
        case link
        case id
    }
    
}
