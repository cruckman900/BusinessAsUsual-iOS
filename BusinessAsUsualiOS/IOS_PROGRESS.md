# iOS Progress & Handoff Notes

_Last updated: 2026-08-08_

This file is a durable summary of the iOS app's state so any new session (or a
different model) can get oriented quickly by reading the code. **Source of truth
is the code + git history, not chat context.**

## Project shape
- Pure **SwiftUI + Swift Package Manager**. No CocoaPods, no Google MaterialComponents.
- Only third-party dependency: **Alamofire** (networking), pinned via SPM
  (`https://github.com/Alamofire/Alamofire.git`, upToNextMajor 5.9.1 → resolves 5.12.0).
- Deployment target iOS 26.2. Builds & installs successfully on iPhone 17 simulator (iOS 26.5).

## Migration off CocoaPods (done)
- Rewrote `BusinessAsUsualiOS.xcodeproj/project.pbxproj` clean: removed all `[CP]`
  script phases, Pods xcconfigs, and the `Pods_*.framework` link; properly declared
  Alamofire as an SPM package; dropped unused GRDB/KeychainSwift.
- Deleted `Pods/`, `Podfile`, `Podfile.lock`; removed the `Pods.xcodeproj` ref from
  `BusinessAsUsualiOS.xcworkspace`.
- Deleted the three dead "Material" files (`MaterialComponents.swift`,
  `MaterialMDComponents.swift`, `EmployeeListSpecViewMaterial.swift`). The live
  renderer is `EmployeeListSpecView.swift`.

## Theme system ✅
- `Presentation/Common/Theme/BAUTheme.swift` — SwiftUI port of the Android Compose
  Material 3 color schemes. 10 themes (bau, hazard, midnight, armada, ocean, steel,
  sunset, emerald, purple, brownstone) × light/dark, exact hex from
  `external-android/.../ui/theme/*.kt`. Accessed via `@Environment(\.bauTheme)`.

## Material-flavored components ✅
`Presentation/Common/Components/BAUMaterialStyle.swift` — all driven by `BAUTheme`, dependency-free:
- `BAUElevation` (levels 0–5) + `.bauElevation(_:)` shadow modifier.
- `BAUCard { }` container + `.bauCard()` modifier (surface, rounded, outline, elevation).
- Button styles: `.buttonStyle(.bauFilled | .bauTonal | .bauOutlined | .bauText)`
  with ripple-like press feedback (press scrim + scale + elevation), M3 pill shape,
  and `isEnabled` handling.
- `BAUFloatingActionButton(systemImage:title:action:)` — circular or extended pill FAB.

### ButtonStyle gotchas (already solved, keep in mind if editing)
- `makeBody` must use the concrete `ButtonStyleConfiguration` type.
- The nested body view must NOT be named `Body` (collides with the protocol's
  associated type) — named `StyleBody`.
- `StyleBody` must be internal (not `private`) to satisfy the protocol's accessibility.

## Shell / navigation ✅
`Presentation/Common/Components/`: `BAUScreenShell`, `BAUTopBar`, `BAUBreadcrumbBar`,
`BAUNavigationDrawer`, `ThemeDrawer`, `SideDrawer`, `DrawerProfileHeader`.

## Build command
```bash
xcodebuild -project BusinessAsUsualiOS.xcodeproj -scheme BusinessAsUsualiOS \
  -destination 'platform=iOS Simulator,name=iPhone 17' -configuration Debug build
```

## Reference apps (in repo)
- `external-android/` — Jetpack Compose Material 3 (design source of truth).
- `external-web/` — Blazor + MudBlazor.

---

## 🎯 Android Feature Parity Roadmap

The Android app uses a **contract-driven dynamic UI system**: business modules are discovered
from the backend at runtime, and their screens are rendered generically from JSON contracts
(no per-module code). iOS must match this architecture exactly.

### Architecture (from Android)
1. **Module discovery** → Dashboard shows module cards (HR, CRM, Finance, etc.) fetched from backend
2. **Contract fetch** → Tapping a module fetches its `ModuleUi` contract (screens, navigation, actions)
3. **Generic rendering** → All screens render from `ScreenSpec` (List, Detail, Form, Timeline, Board, CardCollection, Chart)
4. **In-module navigation** → Module host screen manages tab/section navigation within a module

### Phase 1: Domain Models & Data Layer ✅

#### Domain Models (match `external-android/domain/src/main/java/work/businessasusual/domain/model/`)
- [x] `BAUModule` (basic module metadata)
- [x] `ModuleUi` (full UI contract: screens, navigation, version)
- [x] `ScreenSpec` protocol & concrete types:
  - [x] `ListScreenSpec` (columns, filters, stats, actions, empty state)
  - [x] `DetailScreenSpec` (sections, fields, actions)
  - [x] `FormScreenSpec` (sections, fields, validation, actions)
  - [x] `TimelineScreenSpec` (item fields, stats, search, actions)
  - [x] `BoardScreenSpec` (kanban: columns, card layout, drag-to-move)
  - [x] `CardCollectionScreenSpec` (rich preview cards: email templates, etc.)
  - [x] `ChartScreenSpec` (line, bar, pie, donut, sparkline)
- [x] Supporting models:
  - [x] `NavigationMap`, `NavItem`
  - [x] `ListColumn`, `Filter`, `FilterValue`, `StatCard`
  - [x] `ScreenAction` (navigate | api-call | custom, with confirmation)
  - [x] `BoardColumn`, `BoardCardLayout`, `CardLayout`
  - [x] `TimelineItemFields`
  - [x] `DetailSection`, `DetailField`
  - [x] `FormSection`, `FormField`, `SelectOption`, `FormValidation`
  - [x] `ChartSpec`, `ChartSeries`, `ChartDataPoint`
- [x] Constants: `ChartTypes`, `ActionTypes`, `FieldTypes`

#### Repositories & API Layer
- [x] `ModuleRepository` protocol + impl → `GET /api/modules` (discover modules)
- [x] `MobileUIRepository` protocol + impl → `GET /api/mobile-ui/{moduleId}` (fetch contract)
- [x] `UISpecRepository` enhancements → fetch row data for list/timeline/board screens
- [x] Alamofire-based JSON decoding for all contract types

#### Use Cases
- [x] `GetModulesUseCase` → fetch & cache discovered modules
- [x] `GetModuleUIContractUseCase` → fetch & cache module UI spec
- [x] `GetScreenDataUseCase` → fetch rows for a given screen (cached in ViewModel)

### Phase 2: Core Screens ✅

#### Splash Screen
- [x] `SplashScreen.swift` → animated logo, auto-navigate to Dashboard after 1.5s
- [x] Match Android's simple fade-in animation

#### Dashboard Screen
- [x] `DashboardScreen.swift` → welcome hero card + module grid
- [x] `DashboardViewModel` → fetch modules via `GetModulesUseCase`
- [x] Module cards: icon, name, description, tap → navigate to `module/{moduleId}`
- [x] Loading / error states

#### Module Host Screen
- [x] `ModuleHostScreen.swift` → generic container for any module
- [x] `ModuleHostViewModel` → fetch `ModuleUi` contract, manage selected screen state
- [x] Overview landing (card grid of module sections, like Android `ModuleOverview`)
- [x] Horizontal tab/chip navigation (Overview | section 1 | section 2 | ...)
- [x] Breadcrumbs: Dashboard > Module > Screen (integrate with `BAUBreadcrumbBar`)
- [x] In-module screen routing (resolve `/hr/employees/new` → `employee-form` screen key)

### Phase 3: Dynamic UI Renderers 🚧

Mirror `external-android/.../ui/mobileui/DynamicUi.kt` exactly — all screens driven by contracts.

#### List Screen (`DynamicListScreen`)
- [ ] Title, stats row, search field (if enabled)
- [ ] Filters (dropdown selectors)
- [ ] "Add" action button (navigates to form)
- [ ] **Adaptive layout**:
  - [ ] **Table mode** (when ≥5 columns or totalWidth > 560): horizontal scroll, dense rows
  - [ ] **Card mode** (mobile-native): title + label:value pairs
- [ ] Per-row actions menu (⋮ overflow)
- [ ] Confirmation dialogs for destructive actions
- [ ] Empty state message
- [ ] Navigate on row action (`resolveTargetScreenKey` logic)

#### Detail Screen (`DynamicDetailScreen`)
- [ ] Title
- [ ] Sections (cards): title + field rows (label + value + optional icon)
- [ ] Action buttons (e.g., Edit, Delete)

#### Form Screen (`DynamicFormScreen`)
- [ ] Title
- [ ] Sections: labeled groups of fields
- [ ] Dynamic fields by type:
  - [ ] `text`, `email`, `phone`, `number` → TextField with keyboard type
  - [ ] `select` → Picker/Menu
  - [ ] `date` → DatePicker
  - [ ] `multiselect` → multi-choice chips/tags
- [ ] Required field markers (`*`)
- [ ] Inline validation (required, minLength, maxLength, pattern/regex)
- [ ] Error messages (contract-driven or fallback)
- [ ] Submit / Cancel actions
- [ ] API call on submit (POST/PUT to `action.apiEndpoint`)

#### Timeline Screen (`DynamicTimelineScreen`)
- [ ] Title, stats row, search field
- [ ] Vertical timeline: colored nodes + connector lines
- [ ] Each item: icon, title, subtitle, description, timestamp, status chip, type, owner
- [ ] Status-based accent colors (positive/warning/negative/neutral)
- [ ] "Add" action button
- [ ] Empty state

#### Board Screen (`DynamicBoardScreen`)
- [ ] Title, search field
- [ ] Horizontal-scroll kanban lanes (grouped by `groupByField`)
- [ ] Each column: colored header, count badge, card stack
- [ ] Rich board cards: title, subtitle, value (bold + accent color), progress bar, badge, meta
- [ ] "Add" action button
- [ ] Empty state
- [ ] (Future: drag-to-move if `enableDragToMove` true)

#### Card Collection Screen (`DynamicCardCollectionScreen`)
- [ ] Title, search field, filters
- [ ] Vertical stack of rich preview cards
- [ ] Card layout: icon, title, subtitle, preview snippet, status chip, badge, meta
- [ ] Per-card actions menu
- [ ] "Add" action button
- [ ] Empty state

#### Chart Screen (`ChartDashboard`)
- [ ] Title
- [ ] Chart grid (1–2 columns depending on screen width)
- [ ] Chart types:
  - [ ] **Line** (use Swift Charts `LineMark`)
  - [ ] **Bar** (use Swift Charts `BarMark`)
  - [ ] **Pie** (use Swift Charts `SectorMark`)
  - [ ] **Donut** (pie with inner radius)
  - [ ] **Sparkline** (mini line chart, no axes)
- [ ] Chart title + subtitle
- [ ] Empty state

### Phase 4: Specialized UI Components 🚧

All cells/widgets used by the dynamic screens (match Android's rendering exactly):

- [ ] **StatusChip** → rounded chip with icon + label, color-coded by tone (positive/warning/negative/neutral)
- [ ] **ProgressBarCell** → thin colored bar + label ("60%" or "36/50"), web parity thresholds
- [ ] **PercentRing** → small circular progress indicator (like Android `CircularProgressIndicator`)
- [ ] **StarRatingCell** → 1–5 stars (filled / half / empty) from numeric value
- [ ] **RowActionsMenu** → ⋮ overflow menu, destructive items tinted red
- [ ] **DynamicFilter** → dropdown selector (ExposedDropdownMenu equivalent)
- [ ] **StatCardsRow** → horizontal scroll of small stat tiles (icon, value, label, semantic color)
- [ ] **TimelineItemRow** → vertical timeline entry (node + connector + outlined card)
- [ ] **BoardLane** → kanban column (header + card stack)
- [ ] **BoardCard** → rich opportunity card
- [ ] **PreviewCard** → email template / document preview card

### Phase 5: Icon Resolution ✅

Android uses `MaterialIconResolver` (reflection-based icon name → ImageVector lookup).
iOS equivalent:

- [x] `iconFor(_ name: String) -> Image` function (implemented as `IconResolver.resolve()`)
- [x] Map contract icon names to SF Symbols (e.g., `"dashboard"` → `"square.grid.2x2"`)
- [x] Fallback icon for unknown names (`"questionmark.square.dashed"`)
- [x] Common mappings:
  - `people`, `person`, `hr` → `person.2`
  - `finance`, `money` → `dollarsign.circle`
  - `crm`, `customers` → `briefcase`
  - `dashboard` → `square.grid.2x2`
  - `add`, `create` → `plus.circle`
  - `edit` → `pencil`
  - `delete` → `trash`
  - `search` → `magnifyingglass`
  - 100+ additional mappings in `IconResolver.swift`

### Phase 6: Navigation & App Shell Integration ✅

- [x] `BAUScreenShell` exists and works
- [ ] Wire Dashboard → Module Host → Dynamic Screens
- [ ] Drawer menu: Dashboard always first, then discovered module entries (dynamic)
- [ ] Breadcrumbs: 1–3 levels (Dashboard > Module > Screen)
- [ ] Theme switching via drawer (already works)

### Phase 7: Testing & Polish 🚧

- [ ] Test all 7 screen types with real backend contracts
- [ ] Test all field types, validation rules, action types
- [ ] Test navigation flows (list → detail → form → back)
- [ ] Test light/dark theme × all 10 color schemes
- [ ] Test empty states, loading states, error states
- [ ] Test confirmation dialogs, destructive actions
- [ ] Performance: large lists (100+ rows), chart rendering
- [ ] Accessibility: VoiceOver labels, Dynamic Type support

---

## Current Status Summary

| Feature | iOS | Android |
|---------|-----|---------|
| Theme system | ✅ | ✅ |
| Shell/navigation | ✅ | ✅ |
| Material-style components | ✅ | ✅ |
| **Contract models** | ✅ | ✅ |
| **Repositories/API** | ✅ | ✅ |
| **Icon resolution** | ✅ | ✅ |
| **Module discovery** | ✅ | ✅ |
| **Dashboard** | ✅ | ✅ |
| **Splash screen** | ✅ | ✅ |
| **Module host (generic)** | ✅ | ✅ |
| Dynamic list screen | ⚠️ partial | ✅ |
| Dynamic detail screen | ❌ | ✅ |
| Dynamic form screen | ❌ | ✅ |
| Dynamic timeline screen | ❌ | ✅ |
| Dynamic board screen | ❌ | ✅ |
| Dynamic card collection | ❌ | ✅ |
| Chart dashboard | ❌ | ✅ |

**Legend:** ✅ done | ⚠️ partial | ❌ not started
