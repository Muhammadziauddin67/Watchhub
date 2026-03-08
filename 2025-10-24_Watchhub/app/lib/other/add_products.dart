// import 'package:cloud_firestore/cloud_firestore.dart';

// Future<void> uploadProducts() async {
//   final firestore = FirebaseFirestore.instance;

//   final Map<String, dynamic> products = {
//     "product01": {
//       "name": "Rolex Submariner",
//       "price": 300000,
//       "image": "assets/Images/watches/Product01.jpg",
//       "rating": 4.7,
//       "sold": 10,
//       "reviews": 8
//     },
//     "product02": {
//       "name": "Patek Philippe Calatrava",
//       "price": 850000,
//       "image": "assets/Images/watches/Product02.jpg",
//       "rating": 4.8,
//       "sold": 5,
//       "reviews": 7
//     },
//     "product03": {
//       "name": "Hublot Big Bang",
//       "price": 600000,
//       "image": "assets/Images/watches/Product03.jpg",
//       "rating": 4.6,
//       "sold": 9,
//       "reviews": 8
//     },
//     "product04": {
//       "name": "Vacheron Constantin Overseas",
//       "price": 850000,
//       "image": "assets/Images/watches/Product04.jpg",
//       "rating": 4.8,
//       "sold": 6,
//       "reviews": 10
//     },
//     "product05": {
//       "name": "Grand Seiko Spring Drive",
//       "price": 370000,
//       "image": "assets/Images/watches/Product05.jpg",
//       "rating": 4.8,
//       "sold": 17,
//       "reviews": 9
//     }
//   };

//   try {
//     for (final entry in products.entries) {
//       final docRef = firestore.collection('products').doc(entry.key);
//       final doc = await docRef.get();

//       if (doc.exists) {
//         print("⚠️ ${entry.key} already exists — skipped.");
//       } else {
//         await docRef.set(entry.value);
//         print("✅ Uploaded ${entry.key}");
//       }
//     }

//     print("🎯 All products processed successfully.");
//   } catch (e) {
//     print("❌ Error uploading products: $e");
//   }
// }
