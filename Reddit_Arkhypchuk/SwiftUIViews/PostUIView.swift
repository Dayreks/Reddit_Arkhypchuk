//
//  PostUIView.swift
//  Reddit_Arkhypchuk
//
//  Created by Bohdan on 13.05.2022.
//

import Foundation
import SwiftUI

struct PostUIView: UIViewRepresentable {
    
    @ Binding private var post: Post
    private var delegate: PostCellDelagate
    
    init(post: Binding<Post>, delegate: PostCellDelagate){
        self._post = post
        self.delegate = delegate
    }
   
    func makeUIView(context: Context) -> some PostView {
        let postView = PostView()
        postView.confirgureView(post: &post, delegate: self.delegate)
        return postView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

