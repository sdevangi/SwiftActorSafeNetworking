//
//  URLSessionNetworkClient.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//


import Foundation


/// Performs real HTTP requests using URLSession.
actor URLSessionNetworkClient : NetworkClient{
   
    /// Stores the base URL shared by all API endpoints.
    private let baseURL : URL
    
    /// Provides the URLSession used to execute network requests
    private let session : URLSession
    
    /// Creates a networking client with an injectable base URL and session.
    /// - Parameters:
    ///   - baseURL: The root URL of the backend API.
    ///   - session: The URLSession used for HTTP requests.
    init(baseURL: URL, session: URLSession = .shared) {
        // Saves the backend URL for subsequent requests.
        self.baseURL = baseURL
        
        // Uses the injected session or URLSession.shared by default.
        self.session = session
    }
    
    /// Fetches and decodes the users endpoint.
    /// - Returns: An array of User models.
    /// - Throws: A networking or decoding error if the request fails.
    func fetchUsers() async throws -> [User] {
        
        // Build the full endpoint URL.
        let url = baseURL.appendingPathComponent("/users")
        
        // Create the HTTP request.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Suspend while URLSession performs the network operation.
        // Other requests can proceed while this actor is suspended.
        let (data,response) = try await session.data(for: request)
        
        // Avoid processing the response if cancellation has been requested.
        try Task.checkCancellation()
        
        // Validate that the response is an HTTP response.
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        
        // Accept only successful HTTP status codes.
        guard 200..<300 ~= httpResponse.statusCode else{
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        // Convert the JSON response into the requested model type.
        do {
            return try JSONDecoder().decode([User].self,from: data)
        }catch{
            
            // Preserve cancellation instead of reporting it as a decoding error.
            try Task.checkCancellation()
            
            // Hide implementation-specific decoder details from the UI.
            throw NetworkError.decodingError
        }
    }
    
    /// Fetches and decodes the posts endpoint.
    /// - Returns: An array of Post models.
    /// - Throws: A networking or decoding error if the request fails.
    func fetchPosts() async throws -> [Post] {
        
        // Build the full endpoint URL.
        let url = baseURL.appendingPathComponent("/posts")
        
        // Create the HTTP request.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Suspend while URLSession performs the network operation.
        // Other requests can proceed while this actor is suspended.
        let (data,response) = try await session.data(for: request)
        
        // Avoid processing the response if cancellation has been requested.
        try Task.checkCancellation()
        
        // Validate that the response is an HTTP response.
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        
        // Accept only successful HTTP status codes.
        guard 200..<300 ~= httpResponse.statusCode else{
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        // Convert the JSON response into the requested model type.
        do {
            return try JSONDecoder().decode([Post].self,from: data)
        }catch{
            // Preserve cancellation instead of reporting it as a decoding error.
            try Task.checkCancellation()
            
            // Hide implementation-specific decoder details from the UI.
            throw NetworkError.decodingError
        }
    }
    
    /// Fetches and decodes the products endpoint.
    /// - Returns: An array of Product models.
    /// - Throws: A networking or decoding error if the request fails.
    func fetchProducts() async throws -> [Product] {
        
        // Build the full endpoint URL.
        let url = baseURL.appendingPathComponent("/products")
        
        // Create the HTTP request.
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Suspend while URLSession performs the network operation.
        // Other requests can proceed while this actor is suspended.
        let (data,response) = try await session.data(for: request)
        
        // Avoid processing the response if cancellation has been requested.
        try Task.checkCancellation()
        
        // Validate that the response is an HTTP response.
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponse
        }
        
        // Accept only successful HTTP status codes.
        guard 200..<300 ~= httpResponse.statusCode else{
            throw NetworkError.serverError(httpResponse.statusCode)
        }
        
        // Convert the JSON response into the requested model type.
        do {
            return try JSONDecoder().decode([Product].self,from: data)
        }catch{
            // Preserve cancellation instead of reporting it as a decoding error.
            try Task.checkCancellation()
            
            // Hide implementation-specific decoder details from the UI.
            throw NetworkError.decodingError
        }
    }
}
