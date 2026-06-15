import 'package:flutter/material.dart';
import '../models/publication.dart';
import '../services/openalex_service.dart';

class PublicationProvider with ChangeNotifier {
  final OpenAlexService _service = OpenAlexService();
  
  List<Publication> _publications = [];
  List<Publication> get publications => _publications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> search(String keyword) async {
    if (keyword.trim().isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    _publications = [];
    notifyListeners();

    try {
      _publications = await _service.searchPublications(keyword.trim());
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
