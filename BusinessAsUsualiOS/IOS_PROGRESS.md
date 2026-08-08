# iOS Progress & Handoff Notes

_Last updated: 2026-08-07_

This file is a durable summary of the iOS app's state so any new session (or a
different model) can get oriented quickly by reading the code. **Source of truth
is the code + git history, not chat context.**

## Project shape
- Pure **SwiftUI + Swift Package Manager**. No CocoaPods, no Google MaterialComponents.
- Only third-party dependency: **Alamofire** (networking), pinned via SPM
  (`https://github.com/Alamofire/Alamofire.git`, upToNextMajor 5.9.1 → resolves 5.12.0).
- Deployment target iOS 26.2. Builds green on the iPhone 17 Pro simulator.

## Migration off CocoaPods (done)
- Rewrote `BusinessAsUsualiOS.xcodeproj/project.pbxproj` clean: removed all `[CP]`
  script phases, Pods xcconfigs, and the `Pods_*.framework` link; properly declared
  Alamofire as an SPM package; dropped unused GRDB/KeychainSwift.
- Deleted `Pods/`, `Podfile`, `Podfile.lock`; removed the `Pods.xcodeproj` ref from
  `BusinessAsUsualiOS.xcworkspace`.
- Deleted the three dead "Material" files (`MaterialComponents.swift`,
  `MaterialMDComponents.swift`, `EmployeeListSpecViewMaterial.swift`). The live
  renderer is `EmployeeListSpecView.swift`.

## Theme system
- `Presentation/Common/Theme/BAUTheme.swift` — SwiftUI port of the Android Compose
  Material 3 color schemes. 10 themes (bau, hazard, midnight, armada, ocean, steel,
  sunset, emerald, purple, brownstone) × light/dark, exact hex from
  `external-android/.../ui/theme/*.kt`. Accessed via `@Environment(\.bauTheme)`.

## Material-flavored components (no package) — `Presentation/Common/Components/BAUMaterialStyle.swift`
All driven by `BAUTheme`, dependency-free:
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

## Shell / navigation (Android parity)
`Presentation/Common/Components/`: `BAUScreenShell`, `BAUTopBar`, `BAUBreadcrumbBar`,
`BAUNavigationDrawer`, `ThemeDrawer`, `SideDrawer`, `DrawerProfileHeader`.

## Build command
```bash
xcodebuild -project BusinessAsUsualiOS.xcodeproj -scheme BusinessAsUsualiOS \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -configuration Debug build
```

## Reference apps (in repo)
- `external-android/` — Jetpack Compose Material 3 (design source of truth).
- `external-web/` — Blazor + MudBlazor.
