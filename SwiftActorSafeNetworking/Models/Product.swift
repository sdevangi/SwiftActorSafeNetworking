//
//  Products.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//
import Foundation

/// Represents a product returned by the networking layer.
struct Product: Codable,Identifiable,Sendable{
    
    /// Uniquely Identifies the product.
    let id : Int
    
    /// Stores the product's display name.
    let name : String
    
    /// Stores the product price in the configured courrency.
    let price : Double
}
