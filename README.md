# SwiftActorSafeNetworking

A portfolio project demonstrating modern Swift 6 concurrency and an actor-safe networking architecture using SwiftUI.

## Features

- Swift 6 concurrency and `Sendable` data models
- Actor-isolated `URLSession` networking client
- Protocol-based dependency injection
- Structured concurrency using `async let`
- Concurrent dashboard data loading
- Main actor-isolated observable view model
- Cooperative task cancellation
- Request identifiers to prevent stale results
- Explicit loading, success, failure, and cancellation states
- Retry support and a mock networking implementation
- SwiftUI state-driven user interface

## Architecture

The project separates the SwiftUI view, observable view model, dashboard service, networking protocol, and networking implementations.

The dashboard service concurrently retrieves users, posts, and products. The view model manages UI state and cancellation, while the networking layer handles requests and response decoding.

## Technologies

- Swift 6
- SwiftUI
- Foundation
- Observation
- URLSession
- Structured concurrency
- Actors and `Sendable`

## Getting Started

Open the project in Xcode, configure Swift 6 language mode, and run it on an iOS Simulator. The app uses mock data by default and does not require a backend.

To enable real networking, inject `URLSessionNetworkClient` with the base URL of an API that provides compatible `/users`, `/posts`, and `/products` endpoints.

## Learning Goals

This project demonstrates how to design asynchronous networking code, reason about actor isolation, handle errors and cancellation, and keep SwiftUI state consistent in a concurrent application.
