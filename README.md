# SafeEats
## A food restriction scanner app

---

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg

---

## Description

SafeEats is a mobile application designed to help users identify and manage food restrictions by scanning barcodes on food products. The app provides detailed information about the product, including its name, brands, ingredients, and potential allergens. Users can also manually enter EAN codes to fetch product details.

## Features

### Barcode Scanning
- **Automated Scanning**: The app uses the device's camera to scan barcodes on food products.
- **Manual Entry**: Users can manually enter EAN codes if the barcode cannot be scanned.

### Product Information
- **Product Name**: Displays the name of the food product.
- **Brands**: Shows the brand(s) of the food product.
- **Ingredients**: Lists the ingredients of the food product.
- **Allergens**: Highlights any potential allergens present in the food product.

### User Settings
- **Food Restrictions**: Users can customize their food restrictions by adding, editing, or deleting specific ingredients or allergens.

## Installation

### Prerequisites
- Python 3.12 or newer
- OpenCV
- Kivy
- Pyzbar
- Pytesseract

### Installation Steps
1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/SafeEats.git
    ```
2. Navigate to the project directory:
    ```bash
    cd SafeEats
    ```
3. Install the required packages:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

1. Run the application:
    ```bash
    python main.py
    ```
2. Allow the app to access the device's camera.
3. Point the camera at the barcode on the food product.
4. The app will display detailed information about the product, including any potential food restrictions based on the user's settings.

### Manual Entry
If the barcode cannot be scanned:
1. Enter the EAN code manually in the provided input field.
2. Follow the same steps as above to fetch and display product information.

### User Settings
1. Click on the `Settings` button to access the user settings.
2. Here, you can:
    - View and edit existing food restrictions.
    - Add new food restrictions.
    - Save the updated settings.

## Upcoming Features
- [ ] **User Profile**: Allow users to create and manage profiles with personalized food restrictions.
- [ ] **Translations**: Translations for every language.
- [ ] **History**: Maintain a history of scanned products for easier reference.

## Fixes Needed
- [ ] Improve barcode scanning accuracy.
- [ ] Enhance user interface for better user experience.
- [ ] Optimize code for faster product information retrieval.
- [ ] UI Spacing.
- [ ] Popup box color flagging

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

