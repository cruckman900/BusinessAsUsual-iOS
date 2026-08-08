//
//  BAUModule.swift
//  BusinessAsUsualiOS
//
//  A discoverable business module. The backend provides icon keys (e.g. "hr",
//  "finance", "people") which are resolved to SF Symbols at render time. Module
//  discovery happens via the ModuleRepository at runtime (Android parity).
//

import Foundation

/// A discoverable business module shown on the dashboard and in the navigation drawer.
/// Matches Android's `work.businessasusual.domain.model.Module`.
struct BAUModule: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let description: String
    /// Backend-provided icon key (e.g. "hr", "finance", "people") resolved at render time.
    let icon: String
    /// Destination route (typically "module/{moduleId}").
    let route: String
}
