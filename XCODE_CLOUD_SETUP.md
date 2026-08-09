# Xcode Cloud Setup for TestFlight

**Goal:** Build your iOS app on Apple's servers and upload directly to TestFlight (no local device registration needed!)

## ✅ Prerequisites

- [x] Apple Developer Program membership ($99/year) - You have this
- [x] Git repository for your code - You have this
- [ ] App Store Connect app record - **We'll create this together**

---

## 📱 Step 1: Create App in App Store Connect

1. **Go to [App Store Connect](https://appstoreconnect.apple.com)**
   - Sign in with: `cruckman900@cardinal.wheeling.edu`

2. **Click "My Apps" → Plus (+) button → "New App"**

3. **Fill in the form:**
   - **Platforms:** iOS ✓
   - **Name:** Business As Usual (or whatever you want publicly visible)
   - **Primary Language:** English (US)
   - **Bundle ID:** Select `com.lineardescent.BusinessAsUsualiOS` (should be in dropdown)
   - **SKU:** `businessasusual-ios` (internal identifier, can be anything unique)
   - **User Access:** Full Access

4. **Click "Create"**

5. **Don't worry about filling everything else yet** - you just need the app record to exist for Xcode Cloud to work.

---

## ⚙️ Step 2: Enable Xcode Cloud in Your Project

1. **Open Xcode** (if not already open):
   ```bash
   open BusinessAsUsualiOS.xcworkspace
   ```

2. **In Xcode's top menu:**
   - Click **Product** → **Xcode Cloud** → **Create Workflow...**
   
3. **Xcode Cloud Setup Wizard will appear:**

   **a) Select your App**
   - Choose: **BusinessAsUsualiOS**
   - Click **Next**

   **b) Grant Source Code Access**
   - Xcode will ask to connect to your Git repository
   - If it's a GitHub repo: Xcode will open a browser to authorize GitHub access
   - If it's a local Git repo: You may need to set up remote access
   - **Grant the necessary permissions**
   - Click **Next**

   **c) Choose Workflow**
   - You should see the workflow I created: **"TestFlight Build"**
   - Or select **"Custom"** to edit it
   - Click **Next**

   **d) Review and Create**
   - Review the workflow settings
   - Click **Create**

4. **Xcode will now:**
   - Connect to Xcode Cloud
   - Set up your project
   - May ask you to agree to additional terms
   - Show you the Xcode Cloud dashboard

---

## 🚀 Step 3: Start Your First Build

1. **In Xcode:**
   - Go to **Report Navigator** (icon looks like a speech bubble, or press ⌘9)
   - Click the **Cloud** tab at the top

2. **Start a Build:**
   - Click **"Start Build"** button
   - Or: **Product** → **Xcode Cloud** → **Start Build**

3. **Select Workflow:**
   - Choose **"TestFlight Build"**
   - Click **Start Build**

4. **What Happens Now:**
   - ✅ Xcode Cloud clones your repo on Apple's servers
   - ✅ Installs Swift packages (Alamofire)
   - ✅ Builds the Release configuration
   - ✅ Archives the app into an .ipa
   - ✅ Automatically code signs with Apple Distribution certificate (created by Xcode Cloud)
   - ✅ Uploads to App Store Connect / TestFlight
   - ⏱️ **Takes ~10-20 minutes for first build**

5. **Monitor Progress:**
   - Watch in Xcode's Cloud tab (live logs)
   - Or go to [App Store Connect](https://appstoreconnect.apple.com) → **Xcode Cloud**

---

## 📲 Step 4: Access Your App in TestFlight

1. **After build completes and uploads:**
   - Go to [App Store Connect](https://appstoreconnect.apple.com)
   - Click **My Apps** → **Business As Usual**
   - Go to **TestFlight** tab (on the left)

2. **First Build Compliance:**
   - Apple will review your first TestFlight build (~24 hours)
   - You'll need to answer some compliance questions (encryption, etc.)
   - Just answer honestly (most apps just use HTTPS, no custom encryption)

3. **Create Public TestFlight Link:**
   - In TestFlight tab, under **External Testing**
   - Click **Add Group** → name it "Public Beta"
   - Enable **Public Link**
   - Copy the public link (looks like: `https://testflight.apple.com/join/XXXXXXXX`)
   - **Share this link anywhere** - anyone can install!

4. **Testers Install:**
   - They download **TestFlight** app from App Store (free)
   - Open your public link → installs Business As Usual
   - Done! They now have your app

---

## 🔄 Future Builds (After First Setup)

**It's automatic now!**

Every time you commit to `main` branch:
- Xcode Cloud automatically builds
- Uploads to TestFlight
- Your testers get updates automatically

Or manually trigger:
- In Xcode: **Product** → **Xcode Cloud** → **Start Build**

---

## ⚡ Quick Commands Reference

```bash
# Open your project in Xcode
cd /Users/christopherruckman/Desktop/Development/BusinessAsUsualiOS
open BusinessAsUsualiOS.xcworkspace

# Commit and push to trigger auto-build (if enabled)
git add .
git commit -m "Update for TestFlight"
git push origin main
```

---

## 🆘 Troubleshooting

### "No schemes available"
- Make sure your scheme is **Shared**: In Xcode, **Product → Scheme → Manage Schemes** → check **Shared** box next to BusinessAsUsualiOS

### "Source control not configured"
- Your project needs to be in a Git repo with a remote
- Run: `git remote -v` to verify you have a remote
- If not, you'll need to push to GitHub/GitLab/Bitbucket first

### "Build failed on Xcode Cloud"
- Check the logs in Xcode's Cloud tab
- Common issues:
  - Missing scheme (must be shared)
  - Missing Swift package access
  - Build settings issue (we can fix)

### "No bundle ID available in App Store Connect"
- You need to register the Bundle ID at developer.apple.com first:
  - Go to [Identifiers](https://developer.apple.com/account/resources/identifiers/list)
  - Click **+** → **App IDs** → **App**
  - Bundle ID: `com.lineardescent.BusinessAsUsualiOS`
  - Description: Business As Usual iOS
  - Save

---

## 📊 What You Get

✅ **No local code signing issues** - Apple handles it  
✅ **Builds on Apple's servers** - Consistent environment  
✅ **Auto-upload to TestFlight** - One less manual step  
✅ **Public beta link** - Share with anyone (up to 10,000 testers)  
✅ **Automatic updates** - Push code, testers get new version  
✅ **Build history** - See all builds in App Store Connect  

---

## 🎯 Next Steps

1. ✅ Create app in App Store Connect (Step 1)
2. ✅ Enable Xcode Cloud in Xcode (Step 2)
3. ✅ Start first build (Step 3)
4. ⏳ Wait ~24 hours for Apple's first-build review
5. ✅ Get public TestFlight link (Step 4)
6. 🎉 Share link - anyone can install!

**You're ready! Let's do Step 1 first (create the app in App Store Connect).**
