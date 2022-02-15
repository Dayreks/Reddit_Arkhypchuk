//
//  DataStruct.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 15.02.2022.
//

import Foundation

class ParsedData{
    
    var username: String = "default"
    var domain: String = "/default"
    var time: String = "0h"
    var title: String = "None"
    var image: String? = nil
    var rating: Int = 0
    var comments: Int = 0
    
    func fetchData(subreddit: String, limit: Int, after: String, onCompleted: @escaping (ParsedData) -> Void){
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: "https://www.reddit.com/r/\(subreddit)/top.json?limit=\(limit)&after=\(after)")!
        let _ = urlSession.dataTask(with: url) {data, response, error in
            guard let data = data, let post = try? JSONDecoder().decode(RedditData.self, from: data) else { return }
                self.username = post.data.children[0].data.username
                self.domain = post.data.children[0].data.domain
                self.title = post.data.children[0].data.title
                if let url = post.data.children[0].data.preview?.images[0].source.url{self.image = url.replacingOccurrences(of: "amp;", with: "")}
                self.rating = post.data.children[0].data.rating
                self.comments = post.data.children[0].data.comments
                let calendar = Calendar.current
                let timePassed = calendar.component(.hour, from: Date(timeIntervalSince1970: post.data.children[0].data.time))
                self.time = "\(timePassed-2)h"
                onCompleted(self)
        }.resume()
    }
    
}
