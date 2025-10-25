# Calorie Detector Flutter App — AI Agent Instructions

This guide enables AI coding agents to be immediately productive in this codebase. It covers architecture, workflows, and conventions unique to this project.

## Quick Start

- Create `.env` at project root: `GOOGLE_AI_API_KEY=your_key_here` (required; app throws if missing)
- Install dependencies and generated files:
  - `flutter pub get`
  - `flutter pub run build_runner build --delete-conflicting-outputs` (for json_serializable models)
- Run locally: `flutter run`

## Architecture Overview

- **Bootstrap:** `lib/main.dart` loads `.env`, initializes `SharedPreferences`, wires up `FoodService` → `FoodRepository`, and provides `FoodLogCubit` for state management.
- **Data Layer:**
  - `lib/data/services/food_service.dart`: Integrates Google Gemini via `flutter_gemini`. Uses API key from `.env`. Main method: `detectFoodAndCalories(File)` returns `Either<String, FoodItem>`.
  - `lib/data/repositories/food_repository.dart`: Handles local persistence (via `SharedPreferences`) and delegates to `FoodService`. Keys: `food_log_YYYY-MM-DD`.
  - `lib/data/models/food_item.dart` (+ `food_item.g.dart`): Model and generated code (run build_runner after changes).
- **Presentation & State:**
  - `lib/presentation/cubit/food_log_cubit.dart`: Central state for meals, totals, charts. Key method: `addMealFromImage(File)`.
  - `lib/presentation/screens/*`: UI screens (Onboarding, Main, Home, Settings, etc.).
- **Core Helpers:**
  - `lib/core/utils/calorie_calculator.dart`: Fallback BMR and macro calculations.

## Project-Specific Patterns & Conventions

- `.env` is required and listed as asset in `pubspec.yaml`. Access API key via `dotenv.env['GOOGLE_AI_API_KEY']`.
- Gemini model string is set in `FoodService` (`_model = 'gemini-1.5-pro'`).
- Gemini prompt expects strict JSON; parsing uses RegExp to extract first `{...}`. Fragile—prefer strict JSON output or improve parsing.
- Service methods return `Either<String, FoodItem>` (from `dartz`). Errors are string messages (Left).
- Daily logs use key format `food_log_YYYY-MM-DD` (use `item.timestamp.toIso8601String().split('T')[0]`).
- Models use `json_serializable`; always run build_runner after model changes.

## Developer Workflows

- Install/build models: `flutter pub get` + `flutter pub run build_runner build --delete-conflicting-outputs`
- Run app: `flutter run`
- Analyze/lint: `flutter analyze`, `flutter format .`

## Common Pitfalls

- **Missing API key:** App throws if `.env` or key missing. Confirm `dotenv.load()` in `main.dart`.
- **Gemini JSON parsing:** If Gemini returns text around JSON, update prompt or parsing logic.
- **Stale generated files:** Always run build_runner after model annotation changes.
- **Large logs:** SharedPreferences may slow down with large logs; consider DB migration if needed.

## Typical Edits & Where to Make Them

- Change AI model/prompt: `lib/data/services/food_service.dart`
- Add fields to `FoodItem`: `lib/data/models/food_item.dart` + run build_runner
- Change storage: `lib/data/repositories/food_repository.dart`

## Examples

- Detect food from image:
  ```dart
  final result = await foodRepository.detectFoodFromImage(imageFile);
  result.fold((err) => /* handle error */, (food) => /* use FoodItem */);
  ```
- Add meal via cubit:
  ```dart
  await context.read<FoodLogCubit>().addMealFromImage(imageFile);
  ```

## Key Files for Deeper Understanding

- `lib/main.dart`
- `lib/data/services/food_service.dart`
- `lib/data/repositories/food_repository.dart`
- `lib/presentation/cubit/food_log_cubit.dart`
- `lib/data/models/food_item.dart`
- `lib/core/utils/calorie_calculator.dart`

## Next Steps You May Be Asked to Implement

- Add runtime toggle for Gemini model (e.g., configure `geminiModel` in `.env` and load in `FoodService`)
- Migrate persistence from SharedPreferences to a lightweight DB

---

If any section is unclear or incomplete, ask for feedback to iterate. For changes (e.g., new model, runtime selection), specify if you want code, config, or CI updates.
