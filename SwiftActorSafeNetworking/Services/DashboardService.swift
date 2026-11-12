//
//  DashboardService.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

import Foundation

/// Coordinates data retrieval required by the dashboard.
/// Sendable allows the service to be passed safely across concurrency
/// boundaries when its stored dependencies meet Sendable requirements.

struct DashboardService: Sendable{
    
    /// Abstract networking dependency injected into the service.
    private let client : any NetworkClient
    
    //// Injects the network client, making the service easy to test.
    ///
    /// - Parameter client: A mock or live implementation of NetworkClient.
    init(client: any NetworkClient) {
        // Stores the dependency instead of constructing a client internally.
        self.client = client
    }
    
    /// Loads all dashboard datasets concurrently.
    /// - Returns: A DashboardData value containing users, posts, and products.
    /// - Throws: An error if a child request fails or is cancelled.
    func loadDashboard() async throws -> DashboardData{
        
        // Starts the users operation as a structured child task.
        async let users: [User] = client.fetchUsers()
        
        // Starts the posts operation concurrently with the users request.
        async let posts: [Post] = client.fetchPosts()
        
        // Starts the products operation concurrently with the other requests.
        async let products: [Product] = client.fetchProducts()
        
        // Awaits the results and combines them into one dashboard model.
        // The parent scope waits for its async-let child tasks to complete.
        return try await DashboardData(users: users, posts: posts, products: products)
    }
    
}
