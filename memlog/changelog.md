# SafeEats Project Changelog

## 2025-12-13
### COMPLETED ✅
- **FIXED**: Allergen detection now works correctly with improved matching algorithm
- **FIXED**: Recent scans are now saved and displayed on home screen
- **ADDED**: Complete dark mode system with theme switching
- **ADDED**: Professional app icon generation and configuration
- **ADDED**: Scan history service with persistent storage
- **IMPROVED**: Enhanced allergen matching with variations and synonyms
- **IMPROVED**: Better product safety checking logic
- **IMPROVED**: Home screen now shows recent scan history with visual indicators
- **ADDED**: Theme service with system/light/dark mode options
- **ADDED**: Complete localization for theme options in English and Finnish

### Technical Improvements
- Enhanced Product.containsRestriction() method with better matching
- Added ScanHistoryService for tracking scan history
- Implemented ThemeService for theme management
- Updated home screen to show dynamic recent scans
- Fixed all variable reference issues in scan screen
- Added proper error handling and fallbacks

### User Experience
- App icon now displays correctly on all devices
- Dark mode provides better accessibility and battery saving
- Recent scans show safety status with visual indicators
- Improved allergen detection catches more variations
- Scan history persists between app sessions

## 2025-12-06
### Added
- Created memlog system for project tracking
- Initial project analysis started

### Issues Identified
- Multiple functionality problems reported by user
- "Restrictions" terminology needs replacement
- iOS compilation not available on Windows
- Need for internationalization support
- Platform version updates required

### Planned Changes
- Fix core functionality issues
- Implement GitHub Actions for iOS builds
- Add i18n support (English, Finnish, Crowdin)
- Update to latest iOS/Android versions
- Replace "restrictions" with better terminology
