//
//  NetworkClient.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

import Foundation

/// Defines the operations supported by every network client.
/// Sendable allows conforming client values to be passed safely
/// across concurrency boundaries under Swift's concurrency rules.
protocol NetworkClient: Sendable {

    /// Retrieves the list of users asynchronously.
    func fetchUsers() async throws -> [User]

    /// Retrieves the list of posts asynchronously.
    func fetchPosts() async throws -> [Post]

    /// Retrieves the list of products asynchronously.
    func fetchProducts() async throws -> [Product]
}
