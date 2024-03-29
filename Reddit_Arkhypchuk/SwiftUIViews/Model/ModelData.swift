//
//  ModelData.swift
//  Reddit_Comments
//
//  Created by Bohdan on 29.04.2022.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    
    @Published var commentsParsed: [UIComment] = []
    let emptyData = ParsedDataUI()
    
    init(subreddit: String, id: String) {
        emptyData.load("https://www.reddit.com/r/\(subreddit)/comments/\(id).json?limit=10"){ [weak self] commentsData in
            DispatchQueue.main.async {
                self?.commentsParsed = commentsData.comments
            }
        }
    }
    
    func getMoreComments(){
        emptyData.loadChilds(){ [weak self] commentsChildsData in
            DispatchQueue.main.async {
                self?.commentsParsed = commentsChildsData.comments
            }
        }
    }
}

class ParsedDataUI{
    var comments: [UIComment] = []
    var childrenIDs: [String] = []
    
    func load(_ link: String, onCompleted: @escaping (ParsedDataUI) -> Void) {
        let urlSession = URLSession(configuration: .default)
        let url = URL(string: link)!
        let _ = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, let dataList = try? JSONDecoder().decode([CommentsList].self, from: data) else {return }
            self.addComment(dataList[1].data.children)
            onCompleted(self)
        }.resume()
    }
    
    func loadChilds(onCompleted: @escaping (ParsedDataUI) -> Void){
        if (childrenIDs.isEmpty){ return }
        
        let array = childrenIDs.prefix(10)
        childrenIDs = Array(childrenIDs.dropFirst(10))
        var additionalIDs = Array(array).reduce("", {x,y in x + "," + y})
        additionalIDs.remove(at: additionalIDs.startIndex)
        
        guard let parent_id = comments.last?.parent_id else {return}
        
        let urlSession = URLSession(configuration: .default)
        let _ = urlSession.dataTask(with: URL(string: "https://www.reddit.com/api/morechildren.json?depth=0&link_id=\(parent_id)&api_type=json&children=\(additionalIDs)")!) { data, response, error in
            guard let data = data, let json = try? JSONDecoder().decode(Json.self, from: data) else { return }
            self.addComment(json.json.data.things)
            onCompleted(self)
        }.resume()
    }
    
    func addComment(_ arrayOfComments: [GeneralChilds]){
        for child in arrayOfComments{
            var tempComment = UIComment()
            tempComment.body = child.comment.body
            if let time = child.comment.created{
                tempComment.created = ParsedDataUI.convertToNice(time - Date().timeIntervalSince1970)
            }
            tempComment.depth = child.comment.depth
            tempComment.permalink = child.comment.permalink
            tempComment.username = child.comment.username
            tempComment.rating = child.comment.rating
            tempComment.children = child.comment.children
            if (child.kind == "more"){
                guard let id = child.comment.children else {return}
                childrenIDs.append(contentsOf: id)
            }
            tempComment.parent_id = child.comment.parent_id
            self.comments.append(tempComment)
        }
    }
    
    static func convertToNice(_ time: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 1
        
        return formatter.string(from: time) ?? String(time)
    }
}
