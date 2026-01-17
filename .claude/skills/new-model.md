# New Model

Create a new data model following the project's architecture.

## Arguments

- `name`: The name of the model (e.g., "UserPreference", "DailyLog")

## Instructions

When the user invokes this skill, create a new model file in the `Data/Models` directory.

### Model Template (Data/Models/{Name}.swift)

```swift
import Foundation

// MARK: - {Name} Model

struct {Name}: Identifiable, Codable, Hashable {
    let id: UUID
    let dateKey: String              // yyyy-MM-dd (Asia/Seoul)
    // Add properties based on requirements
    let createdAt: Date

    init(
        id: UUID = UUID(),
        dateKey: String = {Name}.todayDateKey(),
        // Add parameters
        createdAt: Date = Date()
    ) {
        self.id = id
        self.dateKey = dateKey
        self.createdAt = createdAt
    }

    static func todayDateKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: date)
    }
}
```

### Repository Template (Data/Repositories/{Name}Repository.swift)

```swift
import Foundation

final class {Name}Repository {
    static let shared = {Name}Repository()

    private let storageKey = "{name}_entries"
    private let defaults = UserDefaults.standard

    private init() {}

    func saveTodayEntry(_ entry: {Name}) {
        var entries = loadAllEntries()
        entries.removeAll { $0.dateKey == entry.dateKey }
        entries.append(entry)
        saveEntries(Array(entries.suffix(30)))
    }

    func getTodayEntry() -> {Name}? {
        let todayKey = {Name}.todayDateKey()
        return loadAllEntries().first { $0.dateKey == todayKey }
    }

    func getRecentEntries(maxCount: Int = 7) -> [{Name}] {
        let entries = loadAllEntries().sorted { $0.dateKey > $1.dateKey }
        return Array(entries.prefix(maxCount))
    }

    private func loadAllEntries() -> [{Name}] {
        guard let data = defaults.data(forKey: storageKey) else { return [] }
        return (try? JSONDecoder().decode([{Name}].self, from: data)) ?? []
    }

    private func saveEntries(_ entries: [{Name}]) {
        if let data = try? JSONEncoder().encode(entries) {
            defaults.set(data, forKey: storageKey)
        }
    }
}
```

## Storage Rules (per specification)

- One entry per day (overwrite allowed)
- Keep only recent 30 days
- Use Asia/Seoul timezone for dateKey

## Conformances

All models should conform to:
- `Identifiable` - For SwiftUI list compatibility
- `Codable` - For JSON serialization (UserDefaults)
- `Hashable` - For NavigationPath compatibility

## Post-Creation Checklist

- [ ] Model conforms to Identifiable, Codable, Hashable
- [ ] Uses Asia/Seoul timezone for dateKey
- [ ] Repository follows singleton pattern
- [ ] Repository has save/get/getRecent methods
