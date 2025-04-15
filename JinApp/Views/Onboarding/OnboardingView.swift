import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @Binding var isOnboardingComplete: Bool
    
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    init(isOnboardingComplete: Binding<Bool>) {
        self._isOnboardingComplete = isOnboardingComplete
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("Jin")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(goldColor)
                        .padding(.top)
                    
                    // Use a custom tab view implementation to avoid keyboard issues
                    CustomTabView(selection: $viewModel.currentStep) {
                        NameInputView(viewModel: viewModel)
                            .tag(OnboardingViewModel.OnboardingStep.name)
                        
                        ProfileSelectView(viewModel: viewModel)
                            .tag(OnboardingViewModel.OnboardingStep.profile)
                        
                        HSKSelectView(viewModel: viewModel)
                            .tag(OnboardingViewModel.OnboardingStep.hskLevel)
                        
                        GenreSelectView(viewModel: viewModel)
                            .tag(OnboardingViewModel.OnboardingStep.genres)
                        
                        ToneColorPickerView(viewModel: viewModel)
                            .tag(OnboardingViewModel.OnboardingStep.toneColors)
                    }
                    
                    Button(action: handleNextStep) {
                        Text(isLastStep ? "Get Started" : "Next")
                            .font(.headline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(goldColor)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(goldColor, lineWidth: 2)
                            )
                            .shadow(color: goldColor.opacity(0.3), radius: 5, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    .disabled(viewModel.currentStep == .name && viewModel.userName.isEmpty)
                    
                    OnboardingProgress(currentStep: viewModel.currentStep)
                        .padding(.bottom)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
    
    private var isLastStep: Bool {
        viewModel.currentStep.next == nil
    }
    
    private func handleNextStep() {
        if isLastStep {
            viewModel.completeOnboarding()
            isOnboardingComplete = true
        } else {
            viewModel.moveToNextStep()
        }
    }
}

// Custom tab view to avoid keyboard issues
struct CustomTabView<SelectionValue: Hashable, Content: View>: View {
    @Binding var selection: SelectionValue
    let content: () -> Content
    
    init(selection: Binding<SelectionValue>, @ViewBuilder content: @escaping () -> Content) {
        self._selection = selection
        self.content = content
    }
    
    var body: some View {
        TabView(selection: $selection) {
            content()
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct OnboardingProgress: View {
    let currentStep: OnboardingViewModel.OnboardingStep
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(OnboardingViewModel.OnboardingStep.allCases, id: \.self) { step in
                Circle()
                    .fill(step.rawValue <= currentStep.rawValue ? goldColor : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    OnboardingView(isOnboardingComplete: .constant(false))
} 