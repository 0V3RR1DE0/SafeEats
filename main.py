import os
import json
import requests
from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.camera import Camera
from kivy.uix.button import Button
from kivy.uix.popup import Popup
from kivy.uix.textinput import TextInput
from kivy.uix.scrollview import ScrollView
from kivy.uix.gridlayout import GridLayout
from kivy.graphics import Color, Rectangle, Line
import cv2
import numpy as np
from pyzbar import pyzbar
import pytesseract

# Load user-defined food restrictions from config.json
try:
    with open("config.json", "r") as file:
        user_restrictions = json.load(file)
except (FileNotFoundError, json.decoder.JSONDecodeError):
    user_restrictions = []

def fetch_product_info(barcode):
    url = f'https://world.openfoodfacts.org/api/v0/product/{barcode}.json'
    
    response = requests.get(url)
    data = response.json()
    
    if data['status'] == 1:
        product = {
            'name': data['product']['product_name'],
            'brands': data['product']['brands'],
            'allergens': data['product'].get('allergens', []),
            'allergens_from_ingredients': data['product'].get('allergens_from_ingredients', []),
            'allergens_from_user': data['product'].get('allergens_from_user', []),
            'amino_acids_tags': data['product'].get('amino_acids_tags', []),
            'ingredients': [
                {
                    'ciqual_proxy_food_code': ingredient.get('ciqual_proxy_food_code', ''),
                    'id': ingredient['id'],
                    'percent_estimate': ingredient.get('percent_estimate', ''),
                    'percent_max': ingredient.get('percent_max', ''),
                    'percent_min': ingredient.get('percent_min', ''),
                    'rank': ingredient.get('rank', ''),
                    'text': ingredient['text'],
                    'vegan': ingredient.get('vegan', 'Unknown'),
                    'vegetarian': ingredient.get('vegetarian', 'Unknown'),
                    'from_palm_oil': ingredient.get('from_palm_oil', 'No')
                }
                for ingredient in data['product'].get('ingredients', [])  # Added .get() to handle missing 'ingredients'
            ]
        }
        
        if not product['ingredients']:
            product['ingredients'] = [{'text': 'No ingredients found'}]
        
        return product
    else:
        return None

def check_restrictions(product, user_restrictions):
    ingredients_list = []
    restricted = False
    for ingredient in product['ingredients']:
        ingredients_list.append(ingredient)
        for restriction in user_restrictions:
            if restriction.lower() in ingredient['text'].lower():
                restricted = True
            elif 'palm oil' in ingredient['text'].lower() and restriction.lower() == 'palm oil':
                restricted = True
    return not restricted, ingredients_list

def scan_barcode(image):
    # Convert the image to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Use Otsu's thresholding to binarize the image
    _, thresh = cv2.threshold(gray, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    
    # Find contours in the binary image
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    # Loop over the contours to find the barcode
    for contour in contours:
        # Approximate the contour to a polygon
        epsilon = 0.04 * cv2.arcLength(contour, True)
        approx = cv2.approxPolyDP(contour, epsilon, True)
        
        # If the contour has 4 vertices, it could be a barcode
        if len(approx) == 4:
            # Sort the vertices of the contour
            vertices = np.squeeze(approx)
            sorted_vertices = sorted(vertices, key=lambda x: x[0])
            top_left, _, bottom_left, _ = sorted(sorted_vertices, key=lambda x: x[1])
            
            # Crop and warp the barcode region
            barcode_width = np.sqrt((bottom_left[0] - top_left[0])**2 + (bottom_left[1] - top_left[1])**2)
            dst = np.array([[0, 0], [barcode_width - 1, 0], [barcode_width - 1, 49], [0, 49]], dtype="float32")
            M = cv2.getPerspectiveTransform(np.array([top_left, bottom_left, sorted_vertices[2], sorted_vertices[3]], dtype="float32"), dst)
            warped = cv2.warpPerspective(gray, M, (int(barcode_width), 50))
            
            # Decode the barcode using pyzbar
            barcode_data = pyzbar.decode(warped)
            
            if barcode_data:
                return barcode_data[0].data.decode("utf-8"), barcode_data[0].type, cv2.boundingRect(contour)
    
    return None, None, None

class FoodScannerApp(App):
    def build(self):
        self.layout = BoxLayout(orientation='vertical')
        
        self.camera = Camera(resolution=(640, 480), play=True)
        self.camera.bind(on_texture=self.update)
        
        self.result_label = Label(text='Scan a barcode to check food restrictions', size_hint=(1, 0.1))
        
        self.capture_button = Button(text='[b][color=000000]Scan[/color][/b]', size_hint=(0.2, 0.1), background_normal='', background_color=(1, 1, 1, 1), pos_hint={'center_x': 0.5}, markup=True)
        self.capture_button.bind(on_press=self.capture_barcode)
        
        self.settings_button = Button(text="Settings", size_hint=(1, 0.1))
        self.settings_button.bind(on_press=self.show_settings)

        self.manual_entry_input = TextInput(hint_text="Enter EAN code manually", size_hint=(1, 0.1))
        
        self.layout.add_widget(self.camera)
        self.layout.add_widget(self.capture_button)
        self.layout.add_widget(self.result_label)
        self.layout.add_widget(self.settings_button)
        self.layout.add_widget(self.manual_entry_input)
        
        return self.layout

    def update(self, *args):
        pass

    def capture_barcode(self, instance):
        self.capture_button.disabled = True
        self.capture_button.background_color = (1, 1, 1, 1)
    
        image_texture = self.camera.texture
        image_data = image_texture.pixels
        image = cv2.cvtColor(np.frombuffer(image_data, dtype=np.uint8).reshape(image_texture.height, image_texture.width, 4), cv2.COLOR_RGBA2RGB)
    
        barcode_data, barcode_type, barcode_rect = scan_barcode(image)
    
        if barcode_data:
            # Fetch product information from OpenFoodFacts API
            product = fetch_product_info(barcode_data)
            
            if product:
                # Check product restrictions
                allowed, ingredients_list = check_restrictions(product, user_restrictions)
                
                if allowed:
                    self.result_label.text = f"Product Name: {product['name']}\nBrands: {', '.join(product['brands'])}\nStatus: Allowed"
                    self.show_ingredients(ingredients_list)
                else:
                    self.result_label.text = f"Product Name: {product['name']}\nBrands: {', '.join(product['brands'])}\nStatus: Restricted"
                    self.show_ingredients(ingredients_list)
            else:
                self.result_label.text = "Product information not found"
                
        elif barcode_rect:
            # Extract the area below the barcode
            x, y, w, h = barcode_rect
            roi = image[y+h:y+2*h, x:x+w]

            # Use OCR to recognize the numeric code
            numeric_code = pytesseract.image_to_string(roi, config='--psm 6 digits')
        
            if numeric_code:
                # Fetch product information from OpenFoodFacts API using numeric code
                product = fetch_product_info(numeric_code)
                
                if product:
                    # Check product restrictions
                    allowed, ingredients_list = check_restrictions(product, user_restrictions)
                    
                    if allowed:
                        self.result_label.text = f"Product Name: {product['name']}\nBrands: {', '.join(product['brands'])}\nStatus: Allowed"
                        self.show_ingredients(ingredients_list)
                    else:
                        self.result_label.text = f"Product Name: {product['name']}\nBrands: {', '.join(product['brands'])}\nStatus: Restricted"
                        self.show_ingredients(ingredients_list)
                else:
                    self.result_label.text = "Product information not found"
            else:
                self.result_label.text = "No barcode or numeric code detected"
        else:
            # Check if manual entry is provided
            manual_code = self.manual_entry_input.text.strip()
            if manual_code:
                # Fetch product information from OpenFoodFacts API using manual code
                product = fetch_product_info(manual_code)
                
                if product:
                    # Check product restrictions
                    allowed, ingredients_list = check_restrictions(product, user_restrictions)
                    
                    if allowed:
                        self.result_label.text = f"Product Name: {product['name']}\nBrands: {', '.join(product['brands'])}\nStatus: Allowed"
                        self.show_ingredients(ingredients_list)
                    else:
                        self.result_label.text = f"Product Name: {product['name']}\nBrands: {', '.join(product['brands'])}\nStatus: Restricted"
                        self.show_ingredients(ingredients_list)
                else:
                    self.result_label.text = "Product information not found"
            else:
                self.result_label.text = "No barcode detected"
    
        self.capture_button.disabled = False
        self.capture_button.background_color = (1, 1, 1, 1)

    def show_settings(self, instance):
        self.popup = Popup(title='Settings', size_hint=(0.8, 0.6))
        
        self.popup_layout = BoxLayout(orientation='vertical')
        
        self.restrictions_label = Label(text='Food restrictions:')
        self.restrictions_list = ScrollView()
        
        self.grid = GridLayout(cols=1, spacing=10, size_hint_y=None)
        self.grid.bind(minimum_height=self.grid.setter('height'))
        
        for restriction in user_restrictions:
            btn = Button(text=restriction, size_hint_y=None, height=40)
            btn.bind(on_press=self.show_edit_or_delete)
            self.grid.add_widget(btn)
        
        self.add_restriction_button = Button(text='Add Restriction', size_hint_y=None, height=40)
        self.add_restriction_button.bind(on_press=self.show_add_restriction)
        
        self.save_button = Button(text='Save Settings', size_hint_y=None, height=40)
        self.save_button.bind(on_press=self.save_settings)
        
        self.grid.add_widget(self.add_restriction_button)
        self.grid.add_widget(self.save_button)
        
        self.restrictions_list.add_widget(self.grid)
        
        self.popup_layout.add_widget(self.restrictions_label)
        self.popup_layout.add_widget(self.restrictions_list)
        
        self.popup.content = self.popup_layout
        self.popup.open()

    def show_add_restriction(self, instance):
        self.add_popup = Popup(title='Add Restriction', size_hint=(0.5, 0.3))
        
        self.add_layout = BoxLayout(orientation='vertical')
        
        self.add_input = TextInput(hint_text='Enter new restriction')
        self.add_save_button = Button(text='Add', on_press=self.add_new_restriction)
        
        self.add_layout.add_widget(self.add_input)
        self.add_layout.add_widget(self.add_save_button)
        
        self.add_popup.content = self.add_layout
        self.add_popup.open()

    def add_new_restriction(self, instance):
        new_restriction = self.add_input.text.strip()
        if new_restriction and new_restriction not in user_restrictions:
            user_restrictions.append(new_restriction)
            
            with open("config.json", "w") as file:
                json.dump(user_restrictions, file)
            
            self.add_popup.dismiss()
            self.show_settings(self.settings_button)

    def show_edit_or_delete(self, instance):
        self.edit_or_delete_popup = Popup(title='Edit or Delete', size_hint=(0.5, 0.3))
        
        self.edit_or_delete_layout = BoxLayout(orientation='vertical')
        
        self.edit_button = Button(text='Edit', on_press=self.show_edit)
        self.delete_button = Button(text='Delete', on_press=self.delete_restriction)
        
        self.original_btn = instance
        
        self.edit_or_delete_layout.add_widget(self.edit_button)
        self.edit_or_delete_layout.add_widget(self.delete_button)
        
        self.edit_or_delete_popup.content = self.edit_or_delete_layout
        self.edit_or_delete_popup.open()

    def show_edit(self, instance):
        self.edit_popup = Popup(title='Edit Restriction', size_hint=(0.5, 0.3))
        
        self.edit_layout = BoxLayout(orientation='vertical')
        
        self.edit_input = TextInput(text=self.original_btn.text, hint_text='Enter edited restriction')
        self.edit_save_button = Button(text='Save', on_press=lambda x: self.save_edited_restriction(x, self.original_btn))
        
        self.edit_layout.add_widget(self.edit_input)
        self.edit_layout.add_widget(self.edit_save_button)
        
        self.edit_popup.content = self.edit_layout
        self.edit_popup.open()

    def save_edited_restriction(self, instance, original_btn):
        global user_restrictions
        edited_restriction = self.edit_input.text.strip()
        if edited_restriction:
            index = user_restrictions.index(original_btn.text)
            user_restrictions[index] = edited_restriction
            
            with open("config.json", "w") as file:
                json.dump(user_restrictions, file)
            
            self.edit_popup.dismiss()
            self.edit_or_delete_popup.dismiss()
            self.show_settings(self.settings_button)

    def delete_restriction(self, instance):
        global user_restrictions
        user_restrictions.remove(self.original_btn.text)
        
        with open("config.json", "w") as file:
            json.dump(user_restrictions, file)
        
        self.edit_or_delete_popup.dismiss()
        self.show_settings(self.settings_button)

    def save_settings(self, instance):
        self.popup.dismiss()
        self.manual_entry_input.focus = True

    def show_ingredients(self, ingredients_list):
        self.ingredients_popup = Popup(title='Ingredients', size_hint=(0.8, 0.6))
        
        self.ingredients_layout = BoxLayout(orientation='vertical')
        
        self.ingredients_label = Label(text='Ingredients:')
        self.ingredients_list = ScrollView()
        
        self.ingredients_grid = GridLayout(cols=1, spacing=10, size_hint_y=None)
        self.ingredients_grid.bind(minimum_height=self.ingredients_grid.setter('height'))
        
        for ingredient in ingredients_list:
            label_text = f"{ingredient['text']}"
            if ingredient['vegan'] != 'Unknown':
                label_text += f"\nVegan: {ingredient['vegan']}"
            if ingredient['vegetarian'] != 'Unknown':
                label_text += f"\nVegetarian: {ingredient['vegetarian']}"
            if ingredient['from_palm_oil'] != 'No':
                label_text += f"\nFrom Palm Oil: {ingredient['from_palm_oil']}"
            btn = Button(text=label_text, size_hint_y=None, height=100, markup=True)
            self.ingredients_grid.add_widget(btn)
        
        self.ingredients_list.add_widget(self.ingredients_grid)
        
        self.ingredients_layout.add_widget(self.ingredients_label)
        self.ingredients_layout.add_widget(self.ingredients_list)
        
        self.ingredients_popup.content = self.ingredients_layout
        self.ingredients_popup.open()

if __name__ == '__main__':
    FoodScannerApp().run()
