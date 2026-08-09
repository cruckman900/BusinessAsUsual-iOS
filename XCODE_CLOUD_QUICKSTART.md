# ✅ Xcode Cloud Quick Start Checklist

**Goal:** Get your iOS app on TestFlight in ~30 minutes (no physical devices needed!)

---

## Step 1: Create Your App in App Store Connect (5 min)

1. Go to: **https://appstoreconnect.apple.com**
2. Click **My Apps** → **+** button → **New App**
3. Fill in:
   - Platform: **iOS** ✓
   - Name: **Business As Usual** (or your preference)
   - Language: **English (US)**
   - Bundle ID: **com.lineardescent.BusinessAsUsualiOS**
   - SKU: **businessasusual-ios**
4. Click **Create**
5. ✅ Done! (Don't fill anything else yet)

---

## Step 2: Enable Xcode Cloud (10 min)

1. Open Xcode:
   ```bash
   open BusinessAsUsualiOS.xcworkspace
   ```

2. In Xcode menu: **Product** → **Xcode Cloud** → **Create Workflow...**

3. Follow the wizard:
   - **Select app:** BusinessAsUsualiOS → Next
   - **Grant GitHub access:** Authorize when browser opens → Next
   - **Choose workflow:** "TestFlight Build" (or Custom) → Next
   - **Review** → Create

4. ✅ Xcode Cloud is now connected!

---

## Step 3: Start Your First Build (2 min)

1. In Xcode: **Product** → **Xcode Cloud** → **Start Build**

2. Select workflow: **TestFlight Build**

3. Click **Start Build**

4. ⏱️ **Wait 10-20 minutes** (watch in Xcode's Cloud tab or Report Navigator)

5. ✅ Build will automatically upload to TestFlight!

---

## Step 4: Set Up Public TestFlight Link (10 min + 24hr wait)

1. After build uploads, go to: **https://appstoreconnect.apple.com**

2. **My Apps** → **Business As Usual** → **TestFlight** tab

3. Answer **compliance questions** (first-time only):
   - Export Compliance: Usually "No" (unless you do custom encryption beyond HTTPS)
   - Follow the prompts

4. **Create public link:**
   - Under **External Testing** → Click **+** or **Add Group**
   - Name it: **Public Beta**
   - Toggle **Enable Public Link** ON
   - Copy the link: `https://testflight.apple.com/join/XXXXXXXX`

5. ⏳ **Wait ~24 hours** for Apple's first-build review

6. ✅ After approval, share your link - **anyone can install!**

---

## 🎉 You're Done!

**Future builds are automatic:**
- Every commit to `main` branch → auto-build → auto-upload to TestFlight
- Or manually: **Product → Xcode Cloud → Start Build**

**Testers install:**
1. Download **TestFlight** app from App Store (free)
2. Open your public link
3. Install Business As Usual
4. Done!

---

## 📚 Full Documentation

See **XCODE_CLOUD_SETUP.md** for detailed instructions and troubleshooting.

---

## ⚡ Quick Commands

```bash
# Open project
open BusinessAsUsualiOS.xcworkspace

# Commit changes (triggers auto-build if enabled)
git add .
git commit -m "Update app"
git push origin main
```

---

**Current Status:**
- ✅ Xcode Cloud workflow created
- ✅ Scheme shared (required for Xcode Cloud)
- ✅ GitHub remote configured
- ✅ Everything pushed to GitHub
- 🎯 **Ready for Step 1!**

**Start here:** https://appstoreconnect.apple.com
