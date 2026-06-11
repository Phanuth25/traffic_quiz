# Cambodia Traffic Law Quiz Challenge

An interactive Flutter-based quiz application designed to help users prepare for the Cambodian driver's license exam. The app covers a wide range of topics including general traffic laws, road signs, technical knowledge, and emergency procedures.

## 🚀 Features

*   **Multi-Section Quiz Flow**: The exam is divided into logical segments to cover all necessary knowledge:
    *   **General Knowledge**: Basics of traffic rules and regulations.
    *   **Traffic Signs**: Identification and understanding of road signs.
    *   **Technical Knowledge**: Vehicle mechanics and maintenance basics.
    *   **Emergency Procedures**: Proper actions during accidents or emergencies.
    *   **Priority Rules**: Mastery of right-of-way scenarios (**Critical Section**).
*   **Timed Simulation**: A 45-minute timer (2700 seconds) simulates the pressure of the actual exam.
*   **Real-time Progress Tracking**: Visual progress bar and question counters keep users informed of their status.
*   **Automatic Failure System**: Reflecting real-world standards, failing a "Priority" question results in an immediate exam failure.
*   **Khmer Language Support**: Question content is localized in Khmer for authentic preparation.
*   **Randomized Questions**: Questions are shuffled within each category to ensure a fresh experience every attempt.
*   **Modern UI**: Clean design using Material 3, a deep purple theme, and intuitive navigation.

## 🚦 Exam Criteria

*   **Total Questions**: 45
*   **Passing Score**: 39 points or higher.
*   **Critical Requirement**: All **Priority** questions must be answered correctly. Any error in this section triggers an automatic "Failed" status.

## 🛠️ Technical Implementation

*   **State Management**: Uses `ValueNotifier` and `ValueListenableBuilder` for efficient, reactive UI updates without the overhead of heavy providers.
*   **Navigation**: Manages a complex quiz state across multiple screens using `Navigator`.
*   **Data Models**: Structured models for different question types (General, Sign, Priority, etc.).
*   **Timer Logic**: Global timer managed in a central notifier to persist across different quiz sections.

## 📁 Project Structure

The core logic resides in `lib/assignment2/`:
*   `data/`: Raw question sets and global state management (`notifier.dart`).
*   `model/`: Data definitions for questions.
*   `screen/`: UI components for the Welcome screen, individual quiz sections, and the Result summary.
*   `main.dart`: App entry point and Welcome screen.

## ⚙️ How to Run

1.  Clone the repository.
2.  Run `flutter pub get` to install dependencies.
3.  Ensure you have the required Khmer fonts configured in `pubspec.yaml` (referenced as 'KhmerFont' in the code).
4.  Run the app using `flutter run`.

---
*Created as part of a Flutter development assignment.*
