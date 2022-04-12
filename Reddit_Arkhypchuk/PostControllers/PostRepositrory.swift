//
//  PostRepositrory.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 11.04.2022.
//

import Foundation

class PostRepository{
    
    var data: [Post] = []
    let emptyData = ParsedData()
    var after: String? = ""
    var subreddit = "ios"
    
    
    func initPosts(reloadData: @escaping () -> Void ){
        emptyData.fetchData(pagination: false,subreddit: subreddit, limit: 15, after: after!){postData in
            DispatchQueue.main.async {
                self.data = postData.posts
                reloadData()
            }
        }
    }
    
    
    func loadMorePosts(amount number: Int){
        guard !emptyData.paginating else{return}
        guard let afterID = self.data.last?.after else {
            print("After id is nill")
            return}
        emptyData.fetchData(pagination: true, subreddit: subreddit, limit: number, after: afterID){postData in
            DispatchQueue.main.async {
                self.data = postData.posts
                self.after =  self.data.last?.after
            }
        }
    }
    
    
}
