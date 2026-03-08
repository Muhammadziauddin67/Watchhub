import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class AddProductScreen extends StatefulWidget {
  final bool editMode;
  final String? productId;
  final Map<String, dynamic>? existingData;

  const AddProductScreen({
    super.key,
    this.editMode = false,
    this.productId,
    this.existingData,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _customBrandController = TextEditingController();

  bool _isAvailable = true;
  File? _selectedImage;
  String? _imagePath;
  String? _selectedBrand;

  final List<Map<String, String>> _brands = [
    {'name': 'Rolex', 'image': 'assets/Images/brands/rolex.png'},
    {'name': 'Seiko', 'image': 'assets/Images/brands/seiko.png'},
    {'name': 'Omega', 'image': 'assets/Images/brands/omega.png'},
    {'name': 'Patek Philippe', 'image': 'assets/Images/brands/patek.png'},
    {'name': 'Tag Heuer', 'image': 'assets/Images/brands/tag.png'},
    {'name': 'Casio', 'image': 'assets/Images/brands/casio.png'},
    {'name': 'Hublot', 'image': 'assets/Images/brands/hublot.png'},
    {'name': 'Citizen', 'image': 'assets/Images/brands/citizen.png'},
    {'name': 'Other', 'image': 'assets/Images/brands/default.png'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.editMode && widget.existingData != null) {
      _nameController.text = widget.existingData!['name'] ?? '';
      _descController.text = widget.existingData!['description'] ?? '';
      _priceController.text = widget.existingData!['price'].toString();
      _isAvailable = widget.existingData!['available'] ?? true;
      _imagePath = widget.existingData!['image'];

      final existingBrand = widget.existingData!['brand'];
      if (_brands.any((b) => b['name'] == existingBrand)) {
        _selectedBrand = existingBrand;
      } else {
        _selectedBrand = 'Other';
        _customBrandController.text = existingBrand ?? '';
      }
    }
  }

  Uint8List? _webImageBytes; // 👈 Add this field at the top of your _AddProductScreenState

/// 🖼️ Pick image (works for Web + Mobile + Desktop)
Future<void> _pickImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);
  if (picked == null) return;

  if (kIsWeb) {
    // 🌐 Web: store bytes in memory and filename for Firestore reference
    final bytes = await picked.readAsBytes();
    setState(() {
      _webImageBytes = bytes;
      _imagePath = 'assets/Images/watches/${picked.name}';
    });
  } else {
    // 📱 Local (Android / Windows / macOS)
    final dir = Directory('assets/Images/watches');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final newPath = p.join(dir.path, picked.name);
    final newFile = await File(picked.path).copy(newPath);

    setState(() {
      _selectedImage = newFile;
      _imagePath = newFile.path.replaceAll('\\', '/');
    });
  }
}

/// 🖼️ Safe image preview for all platforms
Widget _getPreviewImage() {
  // Fix double-prefix paths (assets/assets/)
  String? img = _imagePath;
  if (img != null && img.startsWith('assets/assets/')) {
    img = img.replaceFirst('assets/assets/', 'assets/');
  }
    if (img != null && !img.startsWith('assets/')) {
  img = 'assets/Images/watches/$img';
}

  // 🌐 Web: use memory preview if available
  if (kIsWeb) {
    if (_webImageBytes != null) {
      return Image.memory(
        _webImageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          'assets/Images/default-product.png',
          fit: BoxFit.cover,
        ),
      );
    } else if (img != null && img.isNotEmpty) {
      return Image.asset(
        img,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset('assets/Images/default-product.png', fit: BoxFit.cover),
      );
    } else {
      return Image.asset('assets/Images/default-product.png', fit: BoxFit.cover);
    }
  }

  // 📱 Local preview (Android / Desktop)
  if (_selectedImage != null) {
    return Image.file(_selectedImage!, fit: BoxFit.cover);
  } else if (img != null && img.isNotEmpty) {
    if (File(img).existsSync()) {
      return Image.file(File(img), fit: BoxFit.cover);
    } else {
      return Image.asset(
        img,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Image.asset('assets/Images/default-product.png', fit: BoxFit.cover),
      );
    }
  } else {
    return Image.asset('assets/Images/default-product.png', fit: BoxFit.cover);
  }



}


  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final brandName = _selectedBrand == 'Other'
        ? _customBrandController.text.trim()
        : _selectedBrand ?? 'Unknown';

    final brandImage = _brands
            .firstWhere((b) => b['name'] == _selectedBrand,
                orElse: () => {'image': 'assets/Images/brands/default.png'})['image'] ??
        'assets/Images/brands/default.png';

    try {
      final data = {
        'name': _nameController.text.trim(),
        'description': _descController.text.trim(),
        'price': double.tryParse(_priceController.text) ?? 0,
        'brand': brandName,
        'brandImage': brandImage,
        'available': _isAvailable,
        'rating': 0,
        'reviewsCount': 0,
        'sold': 0,
        'image': _imagePath ?? 'assets/Images/default-product.png',
      };

      final firestore = FirebaseFirestore.instance;

      if (widget.editMode && widget.productId != null) {
        await firestore.collection('products').doc(widget.productId).update(data);
        Get.snackbar("Updated", "Product updated successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await firestore.collection('products').add(data);
        Get.snackbar("Added", "Product added successfully",
            backgroundColor: Colors.green, colorText: Colors.white);
      }

      Navigator.pop(context);
    } catch (e) {
      Get.snackbar("Error", "Failed to save product: $e",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 1,
        title: Text(
          widget.editMode ? 'Edit Product' : 'Add New Product',
          style: const TextStyle(color: secondaryBlack, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: secondaryBlack),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: accentGold, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: _getPreviewImage(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              _buildInputField('Product Name', _nameController),
              const SizedBox(height: 16),

              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Select Brand / Store',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: accentGold, width: 1.5),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBrand,
                    isExpanded: true,
                    hint: const Text('Choose Brand'),
                    items: _brands.map((brand) {
                      return DropdownMenuItem<String>(
                        value: brand['name'],
                        child: Row(
                          children: [
                            Image.asset(brand['image']!, width: 30, height: 30),
                            const SizedBox(width: 10),
                            Text(brand['name']!),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) => setState(() => _selectedBrand = val),
                  ),
                ),
              ),

              if (_selectedBrand == 'Other') ...[
                const SizedBox(height: 12),
                _buildInputField('Enter New Brand Name', _customBrandController),
              ],

              const SizedBox(height: 16),
              _buildInputField('Description', _descController, maxLines: 3),
              const SizedBox(height: 16),
              _buildInputField('Price (PKR)', _priceController,
                  keyboard: TextInputType.number),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Available for Sale',
                    style: TextStyle(color: secondaryBlack)),
                value: _isAvailable,
                activeColor: accentGold,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: secondaryBlack),
                  label: Text(
                    widget.editMode ? 'Update Product' : 'Save Product',
                    style: const TextStyle(
                        color: secondaryBlack, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentGold,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  onPressed: _saveProduct,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboard = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: accentGold, width: 2)),
      ),
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );
  }
}
