// search_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:local_shopee/providers/search_provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    final history = provider.searchHistory;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        // ให้ AppBar สูงพอสำหรับแสดง Chips
        toolbarHeight: 100,
        title: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextField(
            controller: provider.searchController,
            focusNode: provider.searchFocusNode,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => provider.onSearchSubmitted(),
            decoration: InputDecoration(
              hintText: 'ค้นหาสินค้าที่นี่',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: provider.onSearchSubmitted,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(history.isNotEmpty ? 90 : 0),
          child: Container(
            height: history.isNotEmpty ? 90 : 0,        // สูงพอ 2 แถว
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            alignment: Alignment.topLeft,
            child: history.isEmpty
                ? const SizedBox.shrink()
                : Wrap(
                    spacing: 8,     // ระยะห่างแนวนอน
                    runSpacing: 4,  // ระยะห่างแนวตั้ง
                    children: history.map((query) {
                      return InputChip(
                        label: Text(query),
                        onPressed: () => provider.onHistoryTapped(query),
                        onDeleted: () => provider.removeSearchFromHistory(query),
                      );
                    }).toList(),
                  ),
          ),
        ),

      ),
      body: Center(
        child: provider.searchController.text.isEmpty
            ? const Text('กรอกคำค้นหาแล้วกดค้นหา')
            : Text(
                'ผลลัพธ์ของ "${provider.searchController.text}"',
                style: const TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}
