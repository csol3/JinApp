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
            
            // Use a custom color picker implementation to avoid constraint issues
            ColorPickerButton(color: $color)
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

// Custom color picker button to avoid constraint issues
struct ColorPickerButton: View {
    @Binding var color: Color
    @State private var showingColorPicker = false
    
    var body: some View {
        Button(action: {
            showingColorPicker.toggle()
        }) {
            Circle()
                .fill(color)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
        .fullScreenCover(isPresented: $showingColorPicker) {
            NavigationView {
                RGBColorPicker(color: $color)
                    .padding()
                    .navigationTitle("Choose Color")
                    .navigationBarItems(trailing: Button("Done") {
                        showingColorPicker = false
                    })
            }
        }
    }
}

// Custom RGB color picker using sliders
struct RGBColorPicker: View {
    @Binding var color: Color
    
    // Extract RGB components from the color
    private var red: Double {
        let components = color.components
        return components.red
    }
    
    private var green: Double {
        let components = color.components
        return components.green
    }
    
    private var blue: Double {
        let components = color.components
        return components.blue
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Color preview
            RoundedRectangle(cornerRadius: 12)
                .fill(color)
                .frame(height: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            // RGB sliders
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text("Red")
                        .frame(width: 40, alignment: .leading)
                    Slider(value: Binding(
                        get: { red },
                        set: { updateColor(red: $0, green: green, blue: blue) }
                    ), in: 0...1)
                    Text("\(Int(red * 255))")
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    Text("Green")
                        .frame(width: 40, alignment: .leading)
                    Slider(value: Binding(
                        get: { green },
                        set: { updateColor(red: red, green: $0, blue: blue) }
                    ), in: 0...1)
                    Text("\(Int(green * 255))")
                        .frame(width: 30, alignment: .trailing)
                }
                
                HStack {
                    Text("Blue")
                        .frame(width: 40, alignment: .leading)
                    Slider(value: Binding(
                        get: { blue },
                        set: { updateColor(red: red, green: green, blue: $0) }
                    ), in: 0...1)
                    Text("\(Int(blue * 255))")
                        .frame(width: 30, alignment: .trailing)
                }
            }
            
            // Preset colors
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(presetColors, id: \.self) { presetColor in
                        Circle()
                            .fill(presetColor)
                            .frame(width: 30, height: 30)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .onTapGesture {
                                color = presetColor
                            }
                    }
                }
                .padding(.vertical, 10)
            }
            
            Spacer()
        }
    }
    
    // Update the color with new RGB values
    private func updateColor(red: Double, green: Double, blue: Double) {
        color = Color(red: red, green: green, blue: blue)
    }
    
    // Preset colors for quick selection
    private let presetColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .purple,
        .pink, .brown, .black, .gray, .white
    ]
}

// Extension to extract RGB components from Color
extension Color {
    var components: (red: Double, green: Double, blue: Double, opacity: Double) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var o: CGFloat = 0
        
        guard UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &o) else {
            return (0, 0, 0, 0)
        }
        
        return (Double(r), Double(g), Double(b), Double(o))
    }
}

#Preview {
    ToneColorPickerView(viewModel: OnboardingViewModel())
} 