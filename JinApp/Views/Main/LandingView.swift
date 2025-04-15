import SwiftUI

struct LandingView: View {
    @StateObject private var viewModel: VocabSetViewModel
    @StateObject private var userProfile: UserProfile
    
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    init(userProfile: UserProfile) {
        _userProfile = StateObject(wrappedValue: userProfile)
        _viewModel = StateObject(wrappedValue: VocabSetViewModel(userProfile: userProfile))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Welcome, \(userProfile.userName)")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        Text("HSK-Based Sets")
                            .font(.title2)
                            .foregroundColor(goldColor)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(1...userProfile.hskLevel.rawValue, id: \.self) { level in
                                    VocabSetCard(
                                        vocabularySet: viewModel.vocabularySet(for: .hsk(level: level)),
                                        studyProgress: viewModel.studyProgress(for: .hsk(level: level))
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Text("Genre-Based Sets")
                            .font(.title2)
                            .foregroundColor(goldColor)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                if userProfile.genrePreferences.academic {
                                    VocabSetCard(
                                        vocabularySet: viewModel.vocabularySet(for: .genre(.academic)),
                                        studyProgress: viewModel.studyProgress(for: .genre(.academic))
                                    )
                                }
                                if userProfile.genrePreferences.press {
                                    VocabSetCard(
                                        vocabularySet: viewModel.vocabularySet(for: .genre(.press)),
                                        studyProgress: viewModel.studyProgress(for: .genre(.press))
                                    )
                                }
                                if userProfile.genrePreferences.fiction {
                                    VocabSetCard(
                                        vocabularySet: viewModel.vocabularySet(for: .genre(.fiction)),
                                        studyProgress: viewModel.studyProgress(for: .genre(.fiction))
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .task {
                await viewModel.loadVocabularySets()
            }
        }
    }
}

#Preview {
    LandingView(userProfile: UserProfile())
} 