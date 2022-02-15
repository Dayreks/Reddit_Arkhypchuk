//
//  DataStruct.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 15.02.2022.
//

import Foundation

class ParsedData{
    
    var username: String = ""
    var domain: String = ""
    var time: Double = 0.0
    var title: String = ""
    var image: String? = nil
    var rating: Int = 0
    var comments: Int = 0
    
    func fetchData(subreddit: String, limit: Int, after: String){
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)&after\(after)")!
        let dataTask = urlSession.dataTask(with: url) {data, response, error in
            guard let data = data,
                    let post = try? JSONDecoder().decode(RedditData.self, from: data)
            else { return }
            DispatchQueue.main.async {
                self.username = post.data.children[0].data.username
                self.domain = post.data.children[0].data.domain
                self.title = post.data.children[0].data.title
                if let url = post.data.children[0].data.preview?.images[0].source.url{self.image = url}
                self.rating = post.data.children[0].data.rating
                self.comments = post.data.children[0].data.comments
                
            }
        }
        dataTask.resume()
    }
    
}
