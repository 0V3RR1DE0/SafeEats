# SafeEats - Food Restriction Scanner 🍎

<div align="center">

![SafeEats Logo](assets/images/app_icon.png)

**Scan. Check. Eat Safely.**

[![Download APK](https://img.shields.io/badge/Download-Android%20APK-green?style=for-the-badge&logo=android)](https://eats.netique.lol/download/)
[![Website](https://img.shields.io/badge/Website-eats.netique.lol-blue?style=for-the-badge&logo=google-chrome)](https://eats.netique.lol)
[![License](https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey?style=for-the-badge)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

[![GitHub Downloads](https://img.shields.io/github/downloads/0V3RR1DE0/SafeEats/total?style=flat-square&logo=github&label=Total%20Downloads)](https://github.com/0V3RR1DE0/SafeEats/releases)
[![GitHub Release](https://img.shields.io/github/v/release/0V3RR1DE0/SafeEats?style=flat-square&logo=github)](https://github.com/0V3RR1DE0/SafeEats/releases/latest)
[![GitHub Stars](https://img.shields.io/github/stars/0V3RR1DE0/SafeEats?style=flat-square&logo=github)](https://github.com/0V3RR1DE0/SafeEats/stargazers)

</div>

## 📱 About SafeEats

SafeEats is a powerful mobile application designed to help people with food allergies and dietary restrictions make informed decisions about the products they consume. By simply scanning barcodes, users can instantly access detailed ingredient information and receive alerts about potential allergens.

### ✨ Key Features

- 🔍 **Smart Barcode Scanning** - Instant product identification using your device's camera
- 📋 **Detailed Product Information** - Complete ingredient lists and nutritional data
- 👥 **Multiple Profiles** - Manage dietary restrictions for family members
- ⚠️ **Allergen Alerts** - Real-time warnings for specified food restrictions
- 📚 **Scan History** - Keep track of all scanned products
- 🌍 **Multi-Language Support** - Available in English and Finnish

## 🚀 Download & Installation

### Android
1. **Enable Unknown Sources**: Go to Settings → Security → Install unknown apps
2. **Download APK**: Click the download button above
3. **Install**: Open the downloaded file and tap Install

### iOS
iOS version is available! Check the [releases page](https://github.com/0V3RR1DE0/SafeEats/releases) for the latest iOS build.

## 🌐 Website

Visit our website at [eats.netique.lol](https://eats.netique.lol) for more information, features overview, and easy download access.

## 📊 Statistics

- **50K+** Products in Database
- **v1.0.0-beta** Current Version
- **~31MB** App Size
- **2** Languages Supported (English, Finnish)

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **Database**: Local SQLite storage
- **Barcode Scanning**: Mobile Scanner Plugin
- **API**: OpenFoodFacts Integration
- **Platforms**: Android & iOS

## 📱 Detailed Features

### Multiple Profiles
- Create and manage multiple restriction profiles
- Perfect for families or individuals with different dietary needs
- Easy profile switching
- Each profile maintains its own set of restrictions

### Smart Restriction Management
- **Categorized Restrictions:**
  - Allergens (e.g., peanuts, dairy, gluten)
  - Dietary (e.g., vegetarian, vegan)
  - Religious (e.g., halal, kosher)
  - Medical (e.g., low sodium, sugar-free)
  - Custom categories (currently not supported)
- **Severity Levels:**
  - High: Strict avoidance required
  - Medium: Moderate concern
  - Low: Preference
- Pre-configured common restrictions
- Custom restriction support

### Advanced Product Scanning
- Fast and accurate barcode scanning
- Manual barcode entry option
- Comprehensive product information:
  - Product name and brand
  - Complete ingredient list
  - Allergen warnings
  - Nutritional information
  - Product images

### Intelligent Safety Analysis
- Real-time safety checking against active profile
- Clear safety indicators
- Detailed ingredient analysis
- "May contain" warnings for high-severity restrictions
- Category-based organization of detected restrictions

## 🔧 Development Setup

### Prerequisites
- Flutter SDK (>=3.27.0)
- Dart SDK (>=3.5.0)
- Android Studio / VS Code
- Android device or emulator

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/0V3RR1DE0/SafeEats.git
   cd SafeEats
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Project Structure
```
lib/
├── models/          # Data models (Profile, etc.)
├── screens/         # UI screens
├── services/        # Business logic services
├── l10n/           # Localization files
└── main.dart       # App entry point
```

## 🤝 Contributing

We welcome contributions! Please feel free to submit issues, feature requests, or pull requests.

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).

[![CC BY-NC-SA 4.0](https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png)](http://creativecommons.org/licenses/by-nc-sa/4.0/)

## 🔗 Links

- [Website](https://eats.netique.lol)
- [Download APK](https://eats.netique.lol/download/)
- [Privacy Policy](https://eats.netique.lol/privacy.html)
- [Terms of Service](https://eats.netique.lol/terms.html)
- [Report Issues](https://github.com/0V3RR1DE0/SafeEats/issues)
- [Feature Requests](https://github.com/0V3RR1DE0/SafeEats/issues/new?template=feature_request.md)

## 🙏 Acknowledgments

- [OpenFoodFacts](https://openfoodfacts.org/) for their comprehensive food database
- Flutter team for the amazing framework
- All contributors and testers who help make SafeEats better

---

<div align="center">

**Made with ❤️ for safer eating**

</div>
