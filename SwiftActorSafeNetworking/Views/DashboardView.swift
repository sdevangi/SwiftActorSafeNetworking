//
//  DashboardView.swift
//  SwiftActorSafeNetworking
//
//  Created by Devangi Shah on 10/23/26.
//

import SwiftUI


/// Displays the dashboard and its users, posts, and products.
struct DashboardView: View{
    
    /// Stores the observable ViewModel for this view's lifetime.
    @State private var viewModel : DashboardViewModel
    
    /// Initializes the view with its injected ViewModel.
    /// - Parameter viewModel: The ViewModel that supplies dashboard state.
    init(viewModel: DashboardViewModel) {
        // Initializes SwiftUI state with the supplied observable reference.
       _viewModel = State(initialValue: viewModel)
    }
    
    /// Describes the dashboard's complete SwiftUI interface.
    var body: some View{
        
        // Provides navigation and a title for the dashboard screen.
        NavigationStack{
            
            // Allows the dashboard content to scroll vertically.
            ScrollView{
                
                // Arranges the dashboard sections with consistent spacing.
                VStack(alignment: .leading, spacing: 24){
                    
                    // Displays the dashboard title and subtitle.
                    header
                    
                    // Show loading, error, success, or cancellation UI.
                    statusView
                    
                    // Renders the users returned by the service.
                    userSection
                    
                    // Renders the posts returned by the service.
                    postSection
                    
                    // Renders the products returned by the service.
                    productSection
                }
                // Adds space around the dashboard content.
                .padding()
            }
            // Sets the navigation bar title.
            .navigationTitle("Dashboard")
            .toolbar{
                
                // Adds a reload action to the navigation ba
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Reload"){
                        viewModel.loadDashboard()
                    }
                    // Prevents reloading while a load is already in progress.
                    .disabled(viewModel.isLoading)
                }
            }
            // Loads dashboard data when the view's task starts.
            .task {
                // Automatically start loading when the view first appears.
               // The view model prevents duplicate active requests.
               if viewModel.state == .idle {
                   viewModel.loadDashboard()
               }
            }
            .onDisappear {
                // Cancel an unfinished request when leaving the screen.
                viewModel.cancelLoading()
            }
        }
    }
}
// MARK: - Header
private extension DashboardView{
    
    /// Builds the title and subtitle displayed at the top of the screen.
    var header:some View{
        
        // Stacks the title and subtitle vertically.
        VStack(alignment: .leading, spacing: 8){
            
            // Displays the name of the demo project.
            Text("Swift 6 Networking")
                .font(.title.bold())
            
            // Explains the concurrency concept demonstrated by the app.
            Text("Concurrent reuquest using async/await")
                .foregroundStyle(.secondary)
        }
        
    }
}


// MARK: - Loading and Error States
/// Renders the UI corresponding to the current dashboard state.
private extension DashboardView{
    @ViewBuilder
    var statusView: some View {
        switch viewModel.state {
            
        case .idle:
            // Give the user an explicit way to start loading.
            Button("Load Dashboard") {
                viewModel.loadDashboard()
            }
            .buttonStyle(.borderedProminent)
            
        case .loading:
            // Show progress and allow the user to cancel.
            VStack(spacing: 12) {
                ProgressView("Loading dashboard...")
                
                Button("Cancel Loading", role: .destructive) {
                    viewModel.cancelLoading()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
        case .loaded:
            // Confirm that all dashboard data loaded successfully.
            Label(
                "Dashboard loaded successfully",
                systemImage: "checkmark.circle.fill"
            )
            .foregroundStyle(.green)
            
        case .failed(let message):
            // Display the error and let the user retry.
            VStack(alignment: .leading, spacing: 12) {
                Label(
                    "Unable to load dashboard",
                    systemImage: "exclamationmark.triangle.fill"
                )
                .font(.headline)
                
                Text(message)
                    .foregroundStyle(.secondary)
                
                Button("Retry") {
                    viewModel.loadDashboard()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.red.opacity(0.08))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
        case .cancelled:
            // Cancellation is a separate state, not a network error.
            VStack(alignment: .leading, spacing: 8) {
                Text("Loading cancelled")
                    .foregroundStyle(.secondary)
                
                Button("Try Again") {
                    viewModel.loadDashboard()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

// MARK: - Users
private extension DashboardView{
    
    /// Builds the section containing all loaded users.
    var userSection : some View{
        
        // Groups the section title and user rows vertically.
        VStack(alignment: .leading, spacing: 12)
        {
            // Labels the users section.
            Text("Users")
                .font(.headline)
            
            // Creates a row for each identifiable user.
            ForEach(viewModel.users){ user in
                
                // Groups the user's name and email vertically.
                VStack(alignment: .leading, spacing: 4)
                {
                    // Displays the user's name.
                    Text(user.name)
                        .font(.body.bold())
                    
                    // Displays the user's email in secondary text.
                    Text(user.email)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
            }
        }
    }
}

// MARK: - Posts
private extension DashboardView{
    
    /// Builds the section containing all loaded posts.
    var postSection : some View{
        
        // Groups the section title and post rows vertically.
        VStack(alignment: .leading, spacing: 12)
        {
            // Labels the posts section.
            Text("Posts")
                .font(.headline)
            
            // Creates a row for each identifiable post.
            ForEach(viewModel.posts){ post in
                
                // Groups the post title and body vertically.
                VStack(alignment: .leading, spacing: 4)
                {
                    // Displays the post's title.
                    Text(post.title)
                        .font(.body.bold())
                    
                    // Displays the post's descriptive content.
                    Text(post.body)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
            }
        }
    }
}

// MARK: - Products
private extension DashboardView{
    
    /// Builds the section containing all loaded products.
    var productSection : some View{
        
        // Groups the section title and product rows vertically.
        VStack(alignment: .leading, spacing: 12)
        {
            // Labels the products section.
            Text("Products")
                .font(.headline)
            
            // Creates a row for each identifiable product.
            ForEach(viewModel.products){ product in
                
                // Places the product name and price on one line.
                HStack{
                    // Displays the product's name.
                    Text(product.name)
                    
                    // Pushes the price to the trailing edge.
                    Spacer()
                    
                    // Displays the product price in US dollar format.
                    Text(product.price,format: .currency(code: "USD"))
    
                }
                
            }
        }
    }
}
