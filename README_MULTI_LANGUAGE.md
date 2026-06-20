# NatordPlus - Multi-Language Implementation

This repository now includes implementations of the Natural Order String Comparison algorithm in multiple programming languages:

## Implementations

### TypeScript (NPM)

**Location:** `typescript/`

**Installation:**
```bash
npm install natord-plus
```

**Usage:**
```typescript
import { natord, createNatordComparator } from 'natord-plus';

// Basic comparison
const result = natord('Vol 2', 'Vol 10'); // Returns: -1

// For sorting arrays
const items = ['Vol 10', 'Vol 2', 'Vol 3'];
items.sort(createNatordComparator());
```

**Build:**
```bash
cd typescript
npm install
npm run build
```

### Rust (Cargo)

**Location:** `rust/`

**Installation (in Cargo.toml):**
```toml
[dependencies]
natord-plus = "1.0.0"
```

**Usage:**
```rust
use natord_plus::natord;
use std::cmp::Ordering;

let result = natord("Vol 2", "Vol 10", false);
assert_eq!(result, Ordering::Less);

// For sorting vectors
let mut items = vec!["Vol 10", "Vol 2", "Vol 3"];
items.sort_by(|a, b| natord(a, b, false));
```

**Build:**
```bash
cargo build
```

**Tests:**
```bash
cargo test
```

### Swift (SPM)

**Location:** `swift/`

**Installation (in Package.swift):**
```swift
.package(url: "https://github.com/tachibana-shin/natord-plus-lua.git", from: "1.0.0")
```

**Usage:**
```swift
import NatordPlus

let result = NatordPlus.natord("Vol 2", "Vol 10", ignoreCase: false)

// Using String extension
let comparisonResult = "Vol 2".naturalCompare(with: "Vol 10")

// For sorting arrays
var items = ["Vol 10", "Vol 2", "Vol 3"]
items.sort { NatordPlus.natord($0, $1, ignoreCase: false) < 0 }
```

**Build:**
```bash
swift build
```

**Tests:**
```bash
swift test
```

### Kotlin (Gradle)

**Location:** `kotlin/`

**Installation (in build.gradle.kts):**
```kotlin
dependencies {
    implementation("dev.tachibana:natord-plus:1.0.0")
}
```

**Usage:**
```kotlin
import dev.tachibana.natord.NatordPlus

val result = NatordPlus.natord("Vol 2", "Vol 10")

// Using extension function
val result2 = "Vol 2".natordCompare("Vol 10")

// For sorting lists
val items = mutableListOf("Vol 10", "Vol 2", "Vol 3")
items.sortWith(NatordPlus.createComparator())
```

**Build:**
```bash
./gradlew build
```

**Publish to Maven Local:**
```bash
./gradlew publishToMavenLocal
```

## Common Features

All implementations provide:

- **Natural order comparison**: Sorts strings containing numbers in a natural, human-readable way
- **Fixed-point support**: Correctly handles decimal numbers (e.g., "3" < "3.14159")
- **Case-insensitive option**: Optionally ignore case differences
- **Zero external dependencies**: Pure implementations with no external libraries
- **Full compatibility**: All versions produce identical sorting results

## Testing

All implementations include test suites to verify correctness. Run tests with the language-specific build tools:

```bash
# TypeScript
npm test

# Rust
cargo test

# Swift
swift test

# Kotlin
./gradlew test
```

## Credits

Based on the Natural Order String Comparison algorithm developed by **Martin Pool** (https://github.com/sourcefrog).

Fixed-point implementation by **Tachibana Shin** (https://github.com/tachibana-shin).

All implementations are distributed under the **GNU GPL v3** license.

## License

GNU General Public License v3.0 - See LICENSE file for details.
