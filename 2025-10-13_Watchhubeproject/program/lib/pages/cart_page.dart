import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cartItems = [
    CartItem(
      name: 'Rolex Submariner',
      description: 'Blue Dial with Gold Accents',
      image: 'https://i.imgur.com/FYw5qL2.jpeg',
      price: 300000,
      quantity: 1,
    ),
    CartItem(
      name: 'Omega Seamaster',
      description: 'Silver Dial with Steel Strap',
      image: 'https://i.imgur.com/pYV6bUO.jpeg',
      price: 250000,
      quantity: 1,
    ),
  ];

  bool selectAll = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidth = screenWidth > 1000 ? 800 : screenWidth * 0.95;

    double subtotal = cartItems
        .where((item) => item.selected)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
    double shippingFee = subtotal > 0 ? 500 : 0;
    double total = subtotal + shippingFee;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 249, 249),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.amber),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Icon(Icons.shopping_cart, size: 60, color: Colors.amber),
                    Text(
                      'My CART',
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(
                        child: Text(
                          'Your cart is empty!',
                          style: TextStyle(color: Colors.amber, fontSize: 18),
                        ),
                      )
                    : ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.amber, width: 1),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Checkbox(
                                  activeColor: Colors.amber,
                                  value: item.selected,
                                  onChanged: (value) {
                                    setState(() {
                                      item.selected = value ?? false;
                                      selectAll = cartItems
                                          .every((e) => e.selected);
                                    });
                                  },
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item.image,
                                    width: screenWidth < 600 ? 80 : 120,
                                    height: screenWidth < 600 ? 80 : 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        item.description,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 13,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Rs ${item.price ~/ 100000} Lakh',
                                        style: const TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.amber,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (item.quantity > 1) {
                                                  item.quantity--;
                                                }
                                              });
                                            },
                                          ),
                                          Text(
                                            '${item.quantity}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.amber,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                item.quantity++;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.amber, width: 1.5),
                  ),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: 10,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          activeColor: Colors.amber,
                          value: selectAll,
                          onChanged: (value) {
                            setState(() {
                              selectAll = value ?? false;
                              for (var item in cartItems) {
                                item.selected = selectAll;
                              }
                            });
                          },
                        ),
                        const Text(
                          "ALL",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              cartItems
                                  .removeWhere((item) => item.selected);
                            });
                          },
                          icon: const Icon(Icons.delete,
                              color: Colors.redAccent),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Subtotal: Rs. ${subtotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                        Text(
                          'Shipping Fee: Rs. ${shippingFee.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      onPressed: subtotal == 0
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  content: Text(
                                    'Proceeding to checkout — Total Rs. ${total.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                        color: Colors.amber),
                                  ),
                                ),
                              );
                            },
                      child: const Text("Check Out"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🧱 Model for Cart Item
class CartItem {
  final String name;
  final String description;
  final String image;
  final double price;
  int quantity;
  bool selected;

  CartItem({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.quantity = 1,
    this.selected = false,
  });
}
