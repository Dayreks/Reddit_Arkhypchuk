//
//  DataStruct.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 15.02.2022.
//

import Foundation

class ParsedData{
    var posts: [Post] = []
    
    func fetchData(subreddit: String, limit: Int, after: String, onCompleted: @escaping (ParsedData) -> Void){
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)&after=\(after)")!
        let _ = urlSession.dataTask(with: url) {data, response, error in
            guard let data = data, let post = try? JSONDecoder().decode(RedditData.self, from: data) else { return }
            for child in post.data.children{
                var post = Post()
                post.username = child.data.username
                post.domain = child.data.domain
                post.title = child.data.title
                if let url = child.data.preview?.images[0].source.url{post.image = url.replacingOccurrences(of: "amp;", with: "")}
                post.rating = child.data.rating
                post.comments = child.data.comments
                let calendar = Calendar.current
                let timePassed = calendar.component(.hour, from: Date(timeIntervalSince1970: child.data.time))
                post.time = "\(timePassed-2)h"
                self.posts.append(post)
            }
                onCompleted(self)
        }.resume()
    }
    
}

struct Post{
    var username: String = "default"
    var domain: String = "/default"
    var time: String = "0h"
    var title: String = "None"
    var image: String? = nil
    var rating: Int = 0
    var comments: Int = 0
}
