import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CheckoutStep2(),
  ));
}

class CheckoutStep2 extends StatefulWidget {
  const CheckoutStep2({super.key});

  @override
  State<CheckoutStep2> createState() => _CheckoutStep2State();
}

class _CheckoutStep2State extends State<CheckoutStep2> {
  final List<Map<String, dynamic>> paymentMethods = [
    {
      "name": "Credit/Debit Card",
      "icon": Icons.credit_card,
    },
    {
      "name": "Jazz Cash",
      "icon": Icons.account_balance_wallet,
    },
    {
      "name": "Easy Paisa",
      "icon": Icons.payments_rounded,
    },
    {
      "name": "Bank Alfalah",
      "icon": Icons.account_balance,
    },
  ];

  double subtotal = 300000.00;
  double shippingFee = 500.00;

  @override
  Widget build(BuildContext context) {
    double total = subtotal + shippingFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Checkout step 02",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.amber.shade600, width: 1),
              ),
            ),
            child: const Text(
              "Select Payment Method",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paymentMethods.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.amber.shade200,
                height: 0,
              ),
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                return ListTile(
                  leading: Icon(
                    method["icon"],
                    color: Colors.amber.shade700,
                    size: 30,
                  ),
                  title: Text(
                    method["name"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.amber.shade700,
                    size: 18,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("${method["name"]} selected"),
                      backgroundColor: Colors.amber.shade700,
                      duration: const Duration(seconds: 1),
                    ));
                  },
                );
              },
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.amber.shade300, width: 1),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Product Subtotal",
                        style: TextStyle(fontSize: 15)),
                    Text("Rs. ${subtotal.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Shipping Fee Subtotal",
                        style: TextStyle(fontSize: 15)),
                    Text("Rs. ${shippingFee.toStringAsFixed(0)}",
                        style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "Rs. ${total.toStringAsFixed(0)}",
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Order placed successfully!"),
                        ),
                      );
                    },
                    child: const Text(
                      "Buy Now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
