//
//  DashboardViewModel.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

import Foundation
import Observation

/// Represents every user-visible dashboard loading state.
enum DashboardState: Equatable{
    
    /// No dashaboard request has started.
    case idle
    
    /// A Dashboard request is currently running.
    case loading
    
    /// All dashboard requestes completed successfully.
    case loaded
    
    /// A reuquest failed with a user-readable error message
    case failed(String)
    
    /// The active dashboard request was cancelled.
    case cancelled
}

/// Manages dashboard data and UI state on the main actor.
///
/// MainActor isolation ensures observable UI properties are updated
/// through the main actor rather than from arbitrary executors.

@MainActor
@Observable

final class DashboardViewModel{
    /// Users displayed by the dashboard.
    private(set) var users: [User] = []
    
    /// Posts displayed by the dashboard.
    private(set) var posts: [Post] = []
    
    /// Products displayed by the dashboard.
    private(set) var products: [Product] = []
    
    /// The current loading, success, failure, or cancellation state.
    private(set) var state: DashboardState = .idle
    
    /// Indicates whether a dashboard request is currently active.
    var isLoading: Bool {
        state == .loading
    }
    
    //MARK: Dependencies
    
    /// Performs the dashboard's concurrent networking operations.
    ///
    /// This immutable dependency does not need to be observed by SwiftUI.
    @ObservationIgnored
    private let service: DashboardService
    
    //MARK: Task Management
    
    /// Holds the currently managed dashboard task.
    ///
    /// Obeservation is unnecessary for this implementation detail.
    @ObservationIgnored
    private var loadTask:Task<Void,Never>?
    
    /// Identifies the active request to prevent stale results from
    /// modifying the state of a newer request.
    @ObservationIgnored
    private var activeRequestID: UUID?
    
    // MARK: - Initialization
    
    /// Injects the service used to retrieve dashboard data.
    /// - Parameter service: The dashboard networking service.
    init(service: DashboardService) {
        // Retains the service without coupling the ViewModel to a concrete client.
        self.service = service
    }
    
    // MARK: - Loading

   /// Starts loading the dashboard without blocking the caller.
   ///
   /// Duplicate requests are ignored while the dashboard is loading.
   func loadDashboard() {

       // Avoid starting another request while one is already active.
       guard !isLoading else { return }

       // Assign a unique identity to this request.
       let requestID = UUID()
       activeRequestID = requestID

       // Clear any previous error or cancellation state.
       state = .loading

       // Create a task that inherits MainActor isolation.
       // The networking operations suspend asynchronously.
       loadTask = Task { [weak self] in
           guard let self else { return }

        await self.performLoad(requestID: requestID)
       }
   }
    
    /// Performs the asynchronous load and updates observable state.
   ///
   /// - Parameter requestID: Identifies the request allowed to update
   ///   the dashboard.
   private func performLoad(requestID: UUID) async {

       // Clear task bookkeeping only if this is still the active request.
       // This prevents an older task from clearing a newer task's handle.
       defer {
           if activeRequestID == requestID {
               activeRequestID = nil
               loadTask = nil
           }
       }

       do {
           // Wait for all three resources to be retrieved concurrently.
           let dashboard = try await service.loadDashboard()

           // Do not commit results after cancellation has been observed.
           try Task.checkCancellation()

           // Ignore a result if this request is no longer current.
           guard activeRequestID == requestID else { return }

           // Commit the complete dashboard result on MainActor.
           users = dashboard.users
           posts = dashboard.posts
           products = dashboard.products

           // Report success only after all data has been committed.
           state = .loaded

       } catch is CancellationError {

           // Ignore cancellation from a task that is no longer current.
           guard activeRequestID == requestID else { return }

           // Cancellation is not displayed as a networking failure.
           state = .cancelled

       } catch {

           // Ignore failures from a stale request.
           guard activeRequestID == requestID else { return }

           // Distinguish cancellation from genuine request failures.
           if Task.isCancelled {
               state = .cancelled
           } else {
               state = .failed(error.localizedDescription)
           }
       }
   }
    
    // MARK: - Cancellation

    /// Cancels the active dashboard request.
    ///
    /// Cancellation is cooperative: unfinished operations must respond
    /// to the cancellation request.
    func cancelLoading() {

        // Nothing needs cancelling if the dashboard is not loading.
        guard isLoading else { return }

        // Invalidate the current request before cancelling its task.
        // This prevents a late result from changing the visible state.
        activeRequestID = nil

        // Request cancellation of the task and its structured children.
        loadTask?.cancel()

        // Release the stored task handle.
        loadTask = nil

        // Update the UI immediately rather than waiting for unwinding.
        state = .cancelled
    }
    
    // MARK: - Reset
    /// Clears dashboard data and returns the view model to its idle state.
    func reset(){
        
        // Cancel any active request before clearing the data.
        cancelLoading()
        // Removes all users from the dashboard state.
        users = []
        
        // Removes all posts from the dashboard state.
        posts = []
        
        // Removes all products from the dashboard state.
        products = []
        
        // Clears any existing error message.
        state = .idle
    }
}
