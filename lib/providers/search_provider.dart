import 'package:flutter/material.dart';

class SearchProvider extends ChangeNotifier {
  final List<String> _searchHistory = [
    'ผักชี',
    'มังคุด',
    'ทุเรียน',
    'ข้าวเหนียว',
    'ข้าวโพด',
    'ส้มโอ',
    'มะม่วง',
  ];

  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<String> get searchHistory => _searchHistory;

  void addSearchToHistory(String query) {
    if (query.trim().isEmpty) return;
    
    if (!_searchHistory.contains(query.trim())) {
      _searchHistory.insert(0, query.trim());
      if (_searchHistory.length > 5) _searchHistory.removeLast();
      notifyListeners();
    }
  }

  void removeSearchFromHistory(String query) {
    _searchHistory.remove(query);
    notifyListeners();
  }

  void onSearchSubmitted() {
    final query = searchController.text.trim();
    if (query.isEmpty) return;

    addSearchToHistory(query);
    // เพิ่มโค้ดค้นหา
    print('ทำการค้นหา: $query');

    searchFocusNode.unfocus();
  }

  void onHistoryTapped(String query) {
    searchController.text = query;
    onSearchSubmitted();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }
}
