// Nama fungsi mengikuti modul praktikum (info_card).
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

/// Kotak informasi skor di bawah judul (Langkah / Nilai).
Widget info_card(String title, String info) {
  return Expanded(
    child: Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8A2040),
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            info,
            style: const TextStyle(
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2B2B2B),
            ),
          ),
        ],
      ),
    ),
  );
}
