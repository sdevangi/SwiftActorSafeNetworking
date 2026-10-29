//
//  Posts.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

import Foundation

/// Represents a post retrieved from the networking layer.
struct Post: Codable,Identifiable,Sendable{
    
    /// Uniquely identifies the post.
    let id : Int
    
    /// Contains the post's title.
    let title: String
    
    /// Contains the post's descriptive content.
    let body: String
}
