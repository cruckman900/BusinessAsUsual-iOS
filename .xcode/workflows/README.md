# Xcode Cloud Workflows

This directory contains Xcode Cloud workflow configurations for automated building and distribution.

## Workflows

### `testflight.xcodeworkflow.yml`
**Purpose:** Build and upload to TestFlight for public beta testing

**Triggers:**
- Commits to `main` branch
- Manual build via Xcode

**Actions:**
- Builds Release configuration
- Archives app (.ipa)
- Code signs with Apple Distribution certificate (automatic)
- Uploads to App Store Connect / TestFlight
- Notifies on success/failure

## How to Use

### Via Xcode
1. Open project in Xcode
2. **Product** → **Xcode Cloud** → **Start Build**
3. Select workflow: "TestFlight Build"
4. Monitor in Cloud tab

### Automatic (after setup)
- Just push to `main` branch
- Xcode Cloud builds automatically
- TestFlight gets updated

## Setup Required

See `XCODE_CLOUD_SETUP.md` and `XCODE_CLOUD_QUICKSTART.md` in the project root for complete setup instructions.

## Editing Workflows

You can edit workflows:
1. In Xcode: **Product** → **Xcode Cloud** → **Manage Workflows**
2. Or edit the `.yml` files directly

## Documentation

- [Xcode Cloud Documentation](https://developer.apple.com/xcode-cloud/)
- [Workflow Configuration Reference](https://developer.apple.com/documentation/xcode/xcode-cloud-workflow-reference)
