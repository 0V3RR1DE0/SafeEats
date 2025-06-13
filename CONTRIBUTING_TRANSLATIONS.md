# 🌍 Contributing Translations to SafeEats

Thank you for your interest in helping make SafeEats accessible to users worldwide! This guide will help you contribute translations to the project.

## 📋 Current Translation Status

### ✅ Available Languages
- **English (en)** - Complete (Base language)
- **Finnish (fi)** - Complete

### 🚧 Coming Soon via Crowdin
We're setting up a Crowdin project to make translation contributions easier for the community. This will allow:
- Real-time collaboration on translations
- Translation memory and consistency checks
- Easy contribution without technical knowledge
- Professional translation management tools

## 🎯 Translation Priorities

### High Priority Languages
1. **Spanish (es)** - Large user base
2. **French (fr)** - European market
3. **German (de)** - European market
4. **Portuguese (pt)** - Brazilian market
5. **Italian (it)** - European market
6. **Dutch (nl)** - European market

### Medium Priority Languages
1. **Swedish (sv)** - Nordic region
2. **Norwegian (no)** - Nordic region
3. **Danish (da)** - Nordic region
4. **Polish (pl)** - Eastern Europe
5. **Russian (ru)** - Eastern Europe
6. **Japanese (ja)** - Asian market

## 📁 Translation Files Structure

All translation files are located in the `lib/l10n/` directory:

```
lib/l10n/
├── app_en.arb    # English (base language)
├── app_fi.arb    # Finnish
└── app_*.arb     # Future languages
```

## 🔧 Technical Requirements

### ARB File Format
SafeEats uses Flutter's ARB (Application Resource Bundle) format for translations. Each translation file contains:

- **Key-value pairs** for text strings
- **Placeholders** for dynamic content
- **Descriptions** to help translators understand context
- **Metadata** for pluralization and formatting

### Example Translation Entry
```json
{
  "welcomeToSafeEats": "Welcome to SafeEats",
  "@welcomeToSafeEats": {
    "description": "Welcome message shown on the home screen"
  },
  
  "scanProduct": "Scan Product",
  "@scanProduct": {
    "description": "Button text to start scanning a product barcode"
  },
  
  "containsRestrictedItems": "Contains {count} restricted {count, plural, =1{item} other{items}}",
  "@containsRestrictedItems": {
    "description": "Warning message when product contains restricted ingredients",
    "placeholders": {
      "count": {
        "type": "int",
        "description": "Number of restricted items found"
      }
    }
  }
}
```

## 🎨 Translation Guidelines

### 1. Context Understanding
- **Food Safety Focus**: SafeEats helps users with dietary restrictions check food safety
- **Target Audience**: People with allergies, dietary preferences, or medical restrictions
- **Tone**: Clear, helpful, and reassuring

### 2. Key Terms to Maintain Consistency

| English Term | Context | Translation Notes |
|--------------|---------|-------------------|
| SafeEats | App name | Keep as "SafeEats" in all languages |
| Scan | Barcode scanning | Use common term for QR/barcode scanning |
| Profile | User dietary profile | Personal dietary restriction settings |
| Restrictions | Dietary limitations | Allergies, intolerances, preferences |
| Ingredients | Food components | List of what's in the product |
| Allergens | Allergy triggers | Substances that cause allergic reactions |
| Safety Check | Verification process | Checking if product is safe for user |

### 3. Cultural Considerations
- **Food Terms**: Use locally appropriate food terminology
- **Measurement Units**: Consider local preferences (metric vs imperial)
- **Dietary Concepts**: Adapt to local dietary restrictions and preferences
- **Formality Level**: Use appropriate level of formality for your culture

### 4. Technical Constraints
- **Button Text**: Keep concise for mobile UI
- **Error Messages**: Clear and actionable
- **Placeholders**: Maintain placeholder syntax `{variable}`
- **Pluralization**: Follow your language's plural rules

## 🚀 How to Contribute (Current Process)

### Option 1: Direct File Contribution
1. **Fork the repository** on GitHub
2. **Create a new branch** for your translation
3. **Copy `app_en.arb`** to `app_[language_code].arb`
4. **Translate all strings** following the guidelines above
5. **Test your translation** (if possible)
6. **Submit a Pull Request** with your translation

### Option 2: Issue-Based Contribution
1. **Create an issue** on GitHub titled "Translation: [Language Name]"
2. **Provide your translations** in the issue comments
3. **We'll format and integrate** your translations into the project

## 🔄 Crowdin Integration (Coming Soon)

We're working on setting up a Crowdin project that will provide:

### Features
- **Web-based translation interface** - No technical knowledge required
- **Translation memory** - Consistent translations across the app
- **Collaboration tools** - Work with other translators
- **Progress tracking** - See completion status for each language
- **Quality assurance** - Built-in checks for translation quality

### Benefits for Contributors
- **Easy contribution** - Just translate in your browser
- **Real-time updates** - See your translations in context
- **Community collaboration** - Work with other translators
- **Recognition** - Contributor credits in the app

## 📊 Translation Metrics

### Current Statistics
- **Total strings**: ~150 translatable strings
- **Categories**: 
  - UI Elements: ~60 strings
  - Messages: ~40 strings
  - Settings: ~25 strings
  - Errors: ~15 strings
  - Help Text: ~10 strings

### Estimated Time Investment
- **Complete translation**: 4-6 hours for experienced translator
- **Review and refinement**: 2-3 hours
- **Testing and validation**: 1-2 hours

## 🏆 Recognition

### Contributor Credits
All translation contributors will be:
- **Listed in the app** credits section
- **Mentioned in release notes** when their translation is included
- **Added to GitHub contributors** list
- **Invited to beta testing** for their language

### Translation Quality Levels
- **🥇 Gold**: Complete, tested, and culturally appropriate
- **🥈 Silver**: Complete but may need minor refinements
- **🥉 Bronze**: Partial translation (>70% complete)

## 📞 Contact and Support

### Questions?
- **GitHub Issues**: Create an issue with the "translation" label
- **Email**: [Your contact email when available]
- **Discord**: [Community Discord when available]

### Need Help?
- **Translation context**: Ask for clarification on any unclear strings
- **Technical setup**: We can help with ARB file format
- **Cultural adaptation**: Discuss local preferences and conventions

## 🔮 Future Plans

### Upcoming Features
- **Crowdin integration** - Professional translation management
- **In-app language switching** - Change language without restart
- **Regional variants** - Support for regional differences (e.g., pt-BR vs pt-PT)
- **RTL language support** - Right-to-left languages like Arabic, Hebrew
- **Voice interface translations** - For accessibility features

### Long-term Goals
- **50+ languages** supported
- **Community-driven translations** with regular updates
- **Professional translation review** for critical languages
- **Automated translation updates** via Crowdin integration

---

## 🙏 Thank You!

Your contribution helps make SafeEats accessible to users worldwide, potentially helping people with dietary restrictions stay safe and healthy. Every translation matters!

**Ready to contribute?** Start by checking our current translation files in `lib/l10n/` or create an issue to get started.
