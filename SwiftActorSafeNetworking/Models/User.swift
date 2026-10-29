//
//  Users.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

import Foundation

/// Represents a user returned by the networking layer.
struct User: Codable,Identifiable,Sendable{
    
    /// Provides a unique identifier for SwiftUI lists.
    let id: Int

    /// Stores the user's display name.
    let name : String
    
    /// Stores the user's  email address.
    let email : String
    
}
