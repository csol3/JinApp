# JinApp - Mandarin Learning Interface Design

## Overview
JinApp is a SwiftUI-based mobile application designed to help English speakers learn Mandarin Chinese through an intuitive flashcard system. The interface prioritizes simplicity, user engagement, and effective learning progression.

## Interface Flow

### 1. First-Time User Experience (Onboarding)

#### Initial Questionnaire
- **Presentation**: Elegant modal overlay with progress indicators
- **Questions**:
  1. Learning Profile Selection
     - Student
     - Recreational Learner
     - Teacher
     - *Presented as: Large, card-style buttons with icons*

  2. HSK Level Selection
     - HSK 1 through HSK 5
     - *Presented as: Horizontal segmented control*

  3. Learning Genre Preferences
     - Academia
     - Press
     - Fiction
     - None
     - *Presented as: Multi-select checkboxes with descriptions*

  4. Tone Color Customization
     - Color picker for each tone (1-4)
     - Default colors provided
     - *Presented as: Color wheel or predefined palette*

#### Design Elements
- Smooth transitions between questions
- Progress bar showing completion (1/4, 2/4, etc.)
- "Skip for Now" option (small text at bottom)
- Save & Continue button (prominent, bottom-centered)

### 2. Main Interface (Landing Page)

#### Header Section
- Welcome message using selected learning profile
- Small profile icon (top-right)
- Settings gear icon (top-left)

#### Vocabulary Sets Display
```
┌────────────────────────────┐
│ HSK-Based Sets             │
├────────────────────────────┤
│ ┌──────┐ ┌──────┐ ┌──────┐│
│ │HSK 1 │ │HSK 2 │ │HSK 3 ││
│ └──────┘ └──────┘ └──────┘│
└────────────────────────────┘

┌────────────────────────────┐
│ Genre-Based Sets           │
├────────────────────────────┤
│ ┌────────┐  ┌──────────┐  │
│ │Academic│  │Press     │  │
│ └────────┘  └──────────┘  │
└────────────────────────────┘
```

#### Design Elements
- Cards with subtle shadows
- Progress indicators on each set
- Last studied timestamp
- Completion percentage

### 3. Flashcard Interface

#### Display Options
- Toggle switch in top-right corner:
  - Characters Only (默认 → Default)
  - Characters with Pinyin (默认 dèfēn)
- Selection persists across sessions
- Can be changed mid-study without affecting progress

#### Card Display
```
┌────────────────────────────┐
│ Progress: 7/20    [Toggle] │
├────────────────────────────┤
│                            │
│        默认               │
│       dèfēn               │ <- Only shown if pinyin enabled
│                            │
│   [Input Field Here]       │
│                            │
│   [Submit Button]          │
└────────────────────────────┘
```

#### Interaction States

1. **Initial State**
   - Chinese character(s) displayed prominently
   - Clean input field below
   - Submit button (inactive until input)

2. **After Submission**
   - Correct Answer:
     - Green highlight animation
     - Subtle success sound
     - +1 to score counter
   - Incorrect Answer:
     - Gentle shake animation
     - Soft error sound
     - Show correct answer in green

3. **Card Flip Animation**
   - Smooth 3D rotation
   - Reveals:
     - English translation
     - Pinyin with tone colors
     - Example sentence (if available)

#### Navigation Elements
- Exit button (top-left)
- Progress bar (top-center)
- Score display (top-right)

### 4. Completion Screen

#### Results Display
```
┌────────────────────────────┐
│         Great Job!         │
│                            │
│         85% Correct        │
│        (17/20 Cards)       │
│                            │
│    [Review Mistakes]       │
│    [Back to Sets]          │
└────────────────────────────┘
```

#### Features
- Animated completion celebration
- Score percentage with visual representation
- Option to review incorrect answers
- Return to landing page button
- Share results option

## Technical Considerations

### State Management
- User preferences stored locally
- Progress tracking per vocabulary set
- Session statistics for review

### Accessibility
- Support for VoiceOver
- Dynamic Type support
- High contrast mode
- Clear touch targets (minimum 44x44 points)

### Performance
- Smooth animations (60 fps target)
- Immediate feedback on user input
- Efficient loading of vocabulary sets

## Future Enhancements
1. Speech recognition for pronunciation practice
2. Handwriting recognition for character practice
3. Spaced repetition system integration
4. Social features (leaderboards, sharing)
5. Offline mode support 