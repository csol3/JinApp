import SwiftUI

struct ToneColorPickerView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Customize Tone Colors")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top)
            
            Text("Choose colors to represent different tones")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            VStack(spacing: 24) {
                ColorPickerRow(
                    tone: "First Tone (ā)",
                    color: Binding(
                        get: { viewModel.toneColors[1] ?? .red },
                        set: { viewModel.updateToneColor(tone: 1, color: $0) }
                    ),
                    example: "mā (妈)"
                )
                
                ColorPickerRow(
                    tone: "Second Tone (á)",
                    color: Binding(
                        get: { viewModel.toneColors[2] ?? .orange },
                        set: { viewModel.updateToneColor(tone: 2, color: $0) }
                    ),
                    example: "má (麻)"
                )
                
                ColorPickerRow(
                    tone: "Third Tone (ǎ)",
                    color: Binding(
                        get: { viewModel.toneColors[3] ?? .green },
                        set: { viewModel.updateToneColor(tone: 3, color: $0) }
                    ),
                    example: "mǎ (马)"
                )
                
                ColorPickerRow(
                    tone: "Fourth Tone (à)",
                    color: Binding(
                        get: { viewModel.toneColors[4] ?? .blue },
                        set: { viewModel.updateToneColor(tone: 4, color: $0) }
                    ),
                    example: "mà (骂)"
                )
            }
            .padding(.top, 30)
            
            Button("Reset to Default Colors") {
                viewModel.resetToneColors()
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.top)
            
            Spacer()
        }
        .padding()
    }
}

struct ColorPickerRow: View {
    let tone: String
    @Binding var color: Color
    let example: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(tone)
                    .font(.headline)
                
                Text(example)
                    .font(.subheadline)
                    .foregroundColor(color)
            }
            
            Spacer()
            
            ColorPicker("", selection: $color)
                .labelsHidden()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2),
                       radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    ToneColorPickerView(viewModel: OnboardingViewModel())
} 