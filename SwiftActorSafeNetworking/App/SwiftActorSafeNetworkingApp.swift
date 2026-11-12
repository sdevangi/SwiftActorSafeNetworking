//
//  SwiftActorSafeNetworkingApp.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

import SwiftUI

/// The main entry point of the SwiftUI application.
@main
struct SwiftActorSafeNetworkingApp: App {
    
    /// Holds the ViewModel shared with the dashboard view.
    private var viewModel : DashboardViewModel
    
    /// Creates the networking dependencies and injects them into the ViewModel.
    init() {
        
        // Creates a mock client so the app works without a backend.
        let networkClient = MockNetworkClient()
        
        // Provides the networking client to the dashboard service.
        let service = DashboardService(client: networkClient)
        
        // Creates the ViewModel responsible for dashboard state and business logic.
        self.viewModel = DashboardViewModel(service: service)
    }
    /// Defines the app's main window and its root view.
    var body: some Scene {
        WindowGroup {
            DashboardView(viewModel: viewModel)
        }
    }
}
