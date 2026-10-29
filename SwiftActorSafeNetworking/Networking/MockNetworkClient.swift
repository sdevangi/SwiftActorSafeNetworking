//
//  MockNetworkClient.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

/// Supplies sample data for development and concurrency demonstrations.
struct MockNetworkClient: NetworkClient{
    
    /// Simulates retrieving users asynchronously.
    /// - Returns: Sample users after a simulated two-second delay.
    func fetchUsers() async throws -> [User] {
     
        // Logs when the mock users request begins.
        print("Users request started")
        
        // Suspends the current task to simulate network latency.
        try await Task.sleep(for: .seconds(2))
        
        // Throws CancellationError if cancellation was requested.
        try Task.checkCancellation()
        
        // Logs successful completion of the simulated request.
        print("Users request completed")
        
        // Returns sample users without requiring a real API.
        return [
            User(
                id: 1,
                name: "John Smith",
                email: "john@example.com"
            ),
            User(
                id: 2,
                name: "Sarah Johnson",
                email: "sarah@example.com"
            ),
            User(
                id: 3,
                name: "Michael Brown",
                email: "michael@example.com"
            )
        ]
    }
    
    /// Simulates retrieving posts asynchronously.
    /// - Returns: Sample posts after a simulated three-second delay.
    func fetchPosts() async throws -> [Post] {
        
        // Logs when the mock posts request begins.
        print("Posts request started")
        
        // Simulates the latency of a slower endpoint.
        try await Task.sleep(for: .seconds(3))
        
        // Stops execution if the current task has been cancelled.
        try Task.checkCancellation()
        
        // Logs successful completion of the simulated request.
        print("Posts request completed")
        
        // Returns sample posts for the dashboard.
        return [
            Post(
                id: 1,
                title: "Swift 6 Concurrency",
                body: "Learning modern Swift concurrency."
            ),
            Post(
                id: 2,
                title: "Async Await",
                body: "Building asynchronous applications."
            ),
            Post(
                id: 3,
                title: "Actors",
                body: "Protecting shared mutable state."
            )
        ]
    }
    
    /// Simulates retrieving products asynchronously.
    /// - Returns: Sample products after a simulated one-second delay.
    func fetchProducts() async throws -> [Product] {
        
        // Logs when the mock products request begins.
        print("Products request started")
        
        // Simulates the shortest network delay in this example.
        try await Task.sleep(for: .seconds(1))
        
        // Checks whether cancellation occurred during the delay.
        try Task.checkCancellation()
        
        // Logs successful completion of the simulated request.
        print("Products request completed")
        
        // Returns sample products with prices in USD.
        return [
            Product(
                id: 1,
                name: "iPhone",
                price: 999.00
            ),
            Product(
                id: 2,
                name: "MacBook Air",
                price: 1299.00
            ),
            Product(
                id: 3,
                name: "iPad",
                price: 599.00
            )
        ]
    }
    
}
