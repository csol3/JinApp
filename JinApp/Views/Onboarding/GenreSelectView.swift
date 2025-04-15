import SwiftUI

struct GenreSelectView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    private let goldColor = Color(red: 0.831, green: 0.686, blue: 0.216)
    
    private let genres = [
        "Academic", "Press", "Fiction"
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select Your Interests")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            Text("Choose the types of content you want to study")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(genres, id: \.self) { genre in
                        Button(action: {
                            if viewModel.selectedGenres.contains(genre) {
                                viewModel.selectedGenres.remove(genre)
                            } else {
                                viewModel.selectedGenres.insert(genre)
                            }
                            // Update the corresponding preference
                            switch genre {
                            case "Academic":
                                viewModel.updateGenrePreferences(academic: viewModel.selectedGenres.contains(genre))
                            case "Press":
                                viewModel.updateGenrePreferences(press: viewModel.selectedGenres.contains(genre))
                            case "Fiction":
                                viewModel.updateGenrePreferences(fiction: viewModel.selectedGenres.contains(genre))
                            default:
                                break
                            }
                        }) {
                            Text(genre)
                                .font(.headline)
                                .foregroundColor(viewModel.selectedGenres.contains(genre) ? .black : .white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.selectedGenres.contains(genre) ? goldColor : Color.clear)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(goldColor, lineWidth: 2)
                                )
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    GenreSelectView(viewModel: OnboardingViewModel())
        .preferredColorScheme(.dark)
} 