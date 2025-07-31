import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _searchHistory = [
    'ผักชี',
    'มังคุด',
    'ทุเรียน',
    'ข้าวเหนียว',
    'ข้าวโพด',
    'ส้มโอ',
    'มะม่วง',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addSearchToHistory(String query) {
    if (query.trim().isEmpty) return;

    setState(() {
      if (!_searchHistory.contains(query.trim())) {
        _searchHistory.insert(0, query.trim());
        if (_searchHistory.length > 5) {
          _searchHistory.removeLast();
        }
      }
    });
  }

  void _removeSearchFromHistory(String query) {
    setState(() {
      _searchHistory.remove(query);
    });
  }

  void _onSearchSubmitted(String query) {
    _addSearchToHistory(query);
    // เพิ่มโค้ดค้นหา
    print('ทำการค้นหา: $query');

    FocusScope.of(context).unfocus();
  }

  void _onHistoryTapped(String query) {
    _searchController.text = query;
    _onSearchSubmitted(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'ค้นหาสินค้าที่นี่',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  _onSearchSubmitted(_searchController.text);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
            ),
            onChanged: (value) {
              setState(() {});
            },
            onSubmitted: _onSearchSubmitted,
          ),
        ),
      ),
      body:
          ListView.builder(
              itemCount: _searchHistory.length,
              itemBuilder: (context, index) {
                final String query = _searchHistory[index];
                return ListTile(
                  title: Text(query),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () {
                      _removeSearchFromHistory(query);
                    },
                  ),
                  onTap: () {
                    _onHistoryTapped(query);
                  },
                );
              },
            ),
    );
  }
}