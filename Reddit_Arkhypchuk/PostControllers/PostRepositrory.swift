//
//  PostRepositrory.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 11.04.2022.
//

import Foundation
import UIKit

class PostRepository{
    
    var data: [Post] = []
    var dataSaved: [Post] = []
    var dataBackUp: [Post] = []
    let emptyData = ParsedData()
    var after: String? = ""
    var subreddit = "ios"
    var path = FileManager.default.urls(for: .documentDirectory,in: .userDomainMask)[0].appendingPathComponent("SavedPosts.json")
    
    static let shared = PostRepository()
    
    func initPosts(reloadData: @escaping () -> Void ){
        emptyData.fetchData(pagination: false,subreddit: subreddit, limit: 15, after: after!){postData in
            DispatchQueue.main.async {
                self.data = postData.posts.map{ post in
                    for savedPost in PostRepository.shared.dataSaved{
                        if (savedPost.id == post.id) {
                            post.isSaved = true
                        }
                    }
                    return post
                }
                self.dataBackUp.append(contentsOf: self.data)
                reloadData()
            }
            print(self.path)
        }
    }
    
    
    func loadMorePosts(amount number: Int){
        guard !emptyData.paginating else{return}
        guard let afterID = self.data.last?.after else {
            print("After id is nill")
            return}
        emptyData.fetchData(pagination: true, subreddit: subreddit, limit: number, after: afterID){postData in
            DispatchQueue.main.async {
                self.data = postData.posts.map{ post in
                    for savedPost in PostRepository.shared.dataSaved{
                        if (savedPost.id == post.id) {
                            post.isSaved = true
                        }
                    }
                    return post
                }
                self.dataBackUp.append(contentsOf: self.data)
                self.after =  self.data.last?.after
            }
        }
    }
    
    func savePost(_ post: Post){
        self.dataSaved.append(post)
        
    }
    
    
    func removePost(_ post: Post){
        self.dataSaved.removeAll{ $0.id == post.id}
    }
    
    func loadSavedPosts(){
        do {
            let data = try Data(contentsOf: self.path)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([Post].self, from: data)
            self.dataSaved = jsonData
            
        } catch {
            print("post loading error:\(error)")
        }
    }
    
    func savePostsBeforeExit(){
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try! encoder.encode(self.dataSaved)
        do {
            try String(data: data, encoding: .utf8)!.write(to: self.path, atomically: true, encoding: .utf8)
        } catch {
            print("post saving error: \(error.localizedDescription)")
        }
    }
    

    
}
