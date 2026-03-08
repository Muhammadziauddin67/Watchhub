import 'package:flutter/material.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);

    // Sample FAQ list
    final List<Map<String, String>> faqs = [
      {
        'question': 'How do I place an order?',
        'answer':
            'Browse our catalog, select your preferred watch, add it to your cart, and proceed to checkout.'
      },
      {
        'question': 'What payment methods are accepted?',
        'answer':
            'We accept major credit/debit cards, JazzCash, and Easypaisa.'
      },
      {
        'question': 'How long does shipping take?',
        'answer': 'Orders are typically delivered within 3-5 business days.'
      },
      {
        'question': 'Can I return or exchange a watch?',
        'answer':
            'Yes, you can return or exchange within 7 days of delivery. Ensure the product is unused and in original packaging.'
      },
      {
        'question': 'Is my purchase covered by a warranty?',
        'answer':
            'All watches come with a manufacturer warranty. Warranty duration varies by brand.'
      },
      {
        'question': 'How can I contact support?',
        'answer':
            'You can reach us anytime at support@watchhub.com or through our contact form on the website.'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: gold),
        title: const Text(
          'Help Center',
          style: TextStyle(color: gold, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '''
Welcome to the WatchHub Help Center!

Here you’ll find answers to frequently asked questions about shopping, delivery, warranties, and payments.
''',
                style: TextStyle(
                    color: Colors.black87, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // FAQ section
              ...faqs.map((faq) => ExpansionTile(
                    title: Text(
                      faq['question']!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.black87),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Text(
                          faq['answer']!,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
