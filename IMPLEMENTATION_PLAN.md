# JinApp Implementation Plan

## Architecture Overview

```
JinApp/
├── Models/
│   ├── UserProfile.swift         # User preferences and settings
│   ├── VocabularySet.swift      # Vocabulary set model
│   ├── FlashCard.swift          # Individual card model
│   └── StudyProgress.swift      # Progress tracking model
│
├── ViewModels/
│   ├── OnboardingViewModel.swift # Handles questionnaire logic
│   ├── VocabSetViewModel.swift   # Manages vocabulary sets
│   ├── FlashCardViewModel.swift  # Manages flashcard interactions
│   └── ProgressViewModel.swift   # Handles progress tracking
│
├── Views/
│   ├── Onboarding/
│   │   ├── OnboardingView.swift  # Main onboarding container
│   │   ├── ProfileSelect.swift   # Learning profile selection
│   │   ├── HSKSelect.swift       # HSK level selection
│   │   ├── GenreSelect.swift     # Genre preferences
│   │   └── ToneColorPicker.swift # Tone color customization
│   │
│   ├── Main/
│   │   ├── LandingView.swift     # Main interface
│   │   ├── VocabSetCard.swift    # Individual set card
│   │   └── HeaderView.swift      # App header component
│   │
│   ├── Flashcard/
│   │   ├── FlashcardView.swift   # Main flashcard interface
│   │   ├── CardFront.swift       # Front of card
│   │   ├── CardBack.swift        # Back of card
│   │   └── ProgressBar.swift     # Progress indicator
│   │
│   └── Components/
│       ├── CustomButton.swift    # Reusable button styles
│       └── AnimatedCard.swift    # Card flip animation
│
└── backend/
    ├── api.py                    # FastAPI endpoints
    ├── data_loader.py           # CSV processing
    └── ai_helper.py             # Future AI integrations

```

## Implementation Phases

### Phase 1: Core Infrastructure (2-3 days)

1. **Setup Models & Basic ViewModels**
   - Location: `Models/` and `ViewModels/`
   - Priority: High
   - Focus on data structures and basic business logic
   - Implement UserDefaults for persistence

2. **CSV Data Processing**
   - Location: `backend/`
   - Priority: High
   - Convert CSV to efficient JSON format
   - Implement caching for faster load times

### Phase 2: User Interface (3-4 days)

1. **Onboarding Flow**
   - Location: `Views/Onboarding/`
   - Build modular components
   - Implement smooth transitions
   - Use lazy loading for better performance

2. **Main Interface**
   - Location: `Views/Main/`
   - Implement card-based layout
   - Use prefetching for smooth scrolling
   - Implement efficient list rendering

3. **Flashcard System**
   - Location: `Views/Flashcard/`
   - Optimize card flip animations
   - Implement memory-efficient card stack
   - Use view recycling for large sets

## Performance Optimizations

### 1. Data Management
- Pre-process CSV files into JSON at build time
- Implement efficient caching system
- Use lazy loading for vocabulary sets

### 2. UI Performance
- Use SwiftUI's `LazyVGrid` and `LazyHGrid`
- Implement view recycling for flashcards
- Minimize state updates
- Use async image loading

### 3. Memory Management
- Implement pagination for large vocabulary sets
- Clear cache when memory warning received
- Use weak references where appropriate

## Alternative Solutions Considered

1. **Data Storage**
   - Current: CSV → JSON
   - Alternative: Core Data
   - Decision: Stick with CSV→JSON for simplicity and speed

2. **Backend Architecture**
   - Current: FastAPI
   - Alternative: Firebase
   - Decision: FastAPI for control and CSV integration

3. **State Management**
   - Current: ObservableObject
   - Alternative: Redux/TCA
   - Decision: ObservableObject for simplicity

## Development Guidelines

1. **Code Organization**
   - Follow MVVM strictly
   - Keep views under 150 lines
   - Use extensions for clarity

2. **Performance**
   - Profile with Instruments regularly
   - Target 60 FPS animations
   - Keep main thread clear

3. **Testing**
   - Unit tests for ViewModels
   - UI tests for critical paths
   - Performance testing

## Implementation Order

1. **Foundation (Day 1)**
   - Basic models
   - CSV processing
   - User preferences

2. **Core Features (Days 2-3)**
   - Onboarding flow
   - Basic navigation
   - Data loading

3. **Flashcard System (Days 4-5)**
   - Card interface
   - Animations
   - Progress tracking

4. **Polish (Days 6-7)**
   - Performance optimization
   - UI refinement
   - Testing

## Phase Completion Checkpoints

### Testing Requirements
Each phase MUST be tested against PLANNED_INTERFACE.md specifications before proceeding:

1. **Phase 1 Checkpoints**
   - Verify data models match interface requirements
   - Test CSV to JSON conversion with all data files
   - Confirm UserDefaults properly stores all required preferences
   - **Success Criteria**: All data structures support planned interface features

2. **Phase 2 Checkpoints**
   - Test each onboarding screen against interface specs
   - Verify navigation flow matches planned interface
   - Confirm all UI components render as designed
   - **Success Criteria**: UI matches interface mockups exactly

3. **Flashcard System Checkpoints**
   - Test card flip animations at 60 FPS
   - Verify character/pinyin toggle functionality
   - Confirm progress tracking accuracy
   - **Success Criteria**: Flashcard interaction matches interface spec

4. **Final Polish Checkpoints**
   - Run full UI/UX test suite
   - Verify all animations and transitions
   - Test edge cases and error states
   - **Success Criteria**: App fully implements PLANNED_INTERFACE.md

### Iteration Protocol
If any checkpoint fails:
1. Document specific deviations from PLANNED_INTERFACE.md
2. Prioritize fixes based on user impact
3. Implement corrections
4. Retest entire phase
5. Only proceed when ALL checkpoints pass

## Success Metrics
- App launch < 2 seconds
- Flashcard flip animation @ 60 FPS
- Memory usage < 100MB
- Smooth scrolling (no dropped frames)
- CSV processing < 1 second 