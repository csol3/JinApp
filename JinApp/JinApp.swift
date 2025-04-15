import SwiftUI

@main
struct JinApp: App {
    @State private var hasCompletedOnboarding = false
    @StateObject private var userProfile = UserProfile()
    
    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                OnboardingView(isOnboardingComplete: $hasCompletedOnboarding)
            } else {
                LandingView(userProfile: userProfile)
            }
        }
    }
} 
