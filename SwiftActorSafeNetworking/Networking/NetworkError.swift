//
//  NetworkError.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//
import Foundation

/// Defines networking errors that can be displayed or handled by the app.
enum NetworkError: Error,LocalizedError,Sendable{
    
    /// Indicates that the requested URL could not be constructed.
    case invalidURL
    
    /// Indicates that the response was not a valid HTTP response.
    case invalidResponse
    
    /// Indicates that the server returned an unsuccessful HTTP status.
    case serverError(Int)
    
    /// Indicates that response data could not be decoded.
    case decodingError
    
    /// Represents an unexpected networking failure.
    case unknown
    
    /// Provides a user-readable description for each error.
    var errorDescripption: String{
        switch self{
        case .invalidURL:
            // Explains that the URL is invalid.
            return "Invalid URL."
            
        case .invalidResponse:
            // Explains that the server response is invalid.
            return "Invalid Response."
            
        case .serverError(let  statusCode):
            // Includes the HTTP status code for debugging.
            return "Server Error \(statusCode)."
            
        case .decodingError:
            // Indicates that the response format does not match the model.
            return "Unable to decode the response."
            
        case .unknown:
            // Provides a fallback description for unexpected errors.
            return "An unknown networking error occured."
            
        }
    }
}
