//
//  CommentsList.swift
//  Reddit_Comments
//
//  Created by Bohdan on 29.04.2022.
//

import SwiftUI

struct CommentsTable: View {
    @EnvironmentObject var modelData: ModelData
    @State var post: Post
    var delegate: PostCellDelagate
    
    var body: some View {
        NavigationView {
            self.commentCollectionView
                .navigationBarHidden(true)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var commentCollectionView: some View {
        ScrollView {
            PostUIView(post: $post, delegate: self.delegate)
                .frame(height: 550)
            LazyVStack {
                ForEach(modelData.commentsParsed) { comment in
                    NavigationLink(
                        destination: CommentDetails(comment: comment),
                        label: { CommentCell(comment: comment) }
                    )
                }
                Color.clear
                    .frame(width: 0, height: 0, alignment: .bottom)
                    .onAppear {
                        modelData.getMoreComments()
                    }
            }
        }
    }
}

struct CommentsTable_Previews: PreviewProvider {
    static var previews: some View {
        CommentsTable(post: Post(), delegate: TableViewController())
            .environmentObject(ModelData(subreddit: "Music", id: "u5jfbi"))
    }
}



