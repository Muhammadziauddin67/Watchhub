import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/appbar.dart';
import '../widgets/sidebar.dart';
import 'product-details.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;

  // 🔹 Filters
  String selectedBrand = 'All';
  double minPrice = 0;
  double maxPrice = 1000000;
  double selectedRating = 0.0;

  List<String> availableBrands = ['All'];

  @override
  void initState() {
    super.initState();
    fetchBrands();
    fetchProducts(); // load all by default
  }

  Future<void> fetchBrands() async {
    final snapshot = await _firestore.collection('products').get();
    final brands = snapshot.docs
        .map((doc) => doc['brand']?.toString() ?? '')
        .where((b) => b.isNotEmpty)
        .toSet()
        .toList();
    setState(() {
      availableBrands = ['All', ...brands];
    });
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);
    final snapshot = await _firestore.collection('products').get();
    final data = snapshot.docs.map((doc) {
      final product = doc.data();
      return {'id': doc.id, ...product};
    }).toList();
    setState(() {
      searchResults = data;
      isLoading = false;
    });
  }

  Future<void> searchProducts() async {
    setState(() => isLoading = true);

    try {
      final snapshot = await _firestore.collection('products').get();
      final allResults = snapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data};
      }).toList();

      final query = _searchController.text.toLowerCase();

      final filtered = allResults.where((product) {
        final name = (product['name'] ?? '').toString().toLowerCase();
        final brand = (product['brand'] ?? '').toString().toLowerCase();
        final price = (product['price'] ?? 0).toDouble();
        final rating = (product['rating'] ?? 0).toDouble();

        final matchesSearch =
            name.contains(query) || brand.contains(query);
        final matchesBrand = selectedBrand == 'All' ||
            brand == selectedBrand.toLowerCase();
        final matchesPrice = price >= minPrice && price <= maxPrice;
        final matchesRating = rating >= selectedRating;

        return matchesSearch &&
            matchesBrand &&
            matchesPrice &&
            matchesRating;
      }).toList();

      setState(() {
        searchResults = filtered;
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to search: $e');
    }

    setState(() => isLoading = false);
  }

  Widget buildFilters() {
    return ExpansionTile(
      title: const Text(
        "Filters",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      children: [
        // 🔹 Brand Filter
        DropdownButton<String>(
          value: selectedBrand,
          items: availableBrands
              .map((brand) => DropdownMenuItem(
                    value: brand,
                    child: Text(brand),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() => selectedBrand = value!);
            searchProducts();
          },
        ),

        // 🔹 Price Filter
        const SizedBox(height: 10),
        const Text("Price Range"),
        RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          min: 0,
          max: 1000000,
          divisions: 20,
          labels: RangeLabels(
              'Rs ${minPrice.toStringAsFixed(0)}',
              'Rs ${maxPrice.toStringAsFixed(0)}'),
          activeColor: const Color(0xFFD4AF37),
          onChanged: (values) {
            setState(() {
              minPrice = values.start;
              maxPrice = values.end;
            });
            searchProducts();
          },
        ),

        // 🔹 Rating Filter
        const SizedBox(height: 10),
        const Text("Minimum Rating"),
        Slider(
          value: selectedRating,
          min: 0,
          max: 5,
          divisions: 5,
          label: selectedRating.toString(),
          activeColor: const Color(0xFFD4AF37),
          onChanged: (value) {
            setState(() {
              selectedRating = value;
            });
            searchProducts();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      drawer: const ProfileSidebar(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => searchProducts(),
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon:
                    const Icon(Icons.search, color: Color(0xFFD4AF37)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    fetchProducts();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 🔽 Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: buildFilters(),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          "No products found",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          final item = searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => ProductDetailsPage(product: item));
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                    child: Image.asset(
                                      item['image'] ?? '',
                                      width: 110,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'] ?? 'Unknown',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "Rs ${item['price'].toString()}",
                                            style: const TextStyle(
                                              color: Colors.redAccent,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star,
                                                  color: Colors.amber,
                                                  size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                  "${item['rating'] ?? 'N/A'}"),
                                              const SizedBox(width: 8),
                                              Text(
                                                "${item['sold'] ?? 0} sold",
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
