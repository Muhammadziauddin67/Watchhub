import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _newBrandController = TextEditingController();

  bool _isAvailable = true;
  File? _selectedImage;

  final List<String> _brands = [
    'Rolex', 'Omega', 'Casio', 'Seiko', 'Tag Heuer', 'Citizen', 'Other'
  ];
  String? _selectedBrand;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved (placeholder)!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 1,
        title: const Text(
          'Add New Product',
          style: TextStyle(color: secondaryBlack, fontWeight: FontWeight.bold),
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
              // Product Image
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
                    child: _selectedImage == null
                        ? const Icon(Icons.add_a_photo, color: secondaryBlack, size: 40)
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_selectedImage!, fit: BoxFit.cover),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Product Name
              _buildInputField('Product Name', _nameController),
              const SizedBox(height: 16),

              // Brand Selector
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select Brand / Store',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: accentGold, width: 1.5),
                  ),
                ),
                value: _selectedBrand,
                items: _brands.map((b) => DropdownMenuItem(value: b, child: Text(b))).toList(),
                onChanged: (val) => setState(() => _selectedBrand = val),
                validator: (val) => val == null ? 'Select a brand' : null,
              ),
              const SizedBox(height: 16),

              if (_selectedBrand == 'Other')
                _buildInputField('Enter New Brand / Store', _newBrandController),

              const SizedBox(height: 16),
              _buildInputField('Description', _descController, maxLines: 3),
              const SizedBox(height: 16),
              _buildInputField('Price (PKR)', _priceController, keyboard: TextInputType.number),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Available for Sale', style: TextStyle(color: secondaryBlack)),
                value: _isAvailable,
                activeColor: accentGold,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 24),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: secondaryBlack),
                  label: const Text(
                    'Save Product',
                    style: TextStyle(color: secondaryBlack, fontWeight: FontWeight.bold),
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
