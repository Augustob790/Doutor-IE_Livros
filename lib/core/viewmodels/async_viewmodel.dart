import 'package:flutter/material.dart';

mixin AsyncViewModel on ChangeNotifier {
  AsyncViewState _state = AsyncViewState.initial;
  String? _errorMessage;

  AsyncViewState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _state == AsyncViewState.loading;

  @protected
  void setLoading({bool notify = true}) {
    _state = AsyncViewState.loading;
    if (notify) notifyListeners();
  }

  @protected
  void setSuccess({bool notify = true}) {
    _state = AsyncViewState.success;
    _errorMessage = null;
    if (notify) notifyListeners();
  }

  @protected
  void setError(String? message, {bool notify = true}) {
    _state = AsyncViewState.error;
    _errorMessage = message;
    if (notify) notifyListeners();
  }

  @protected
  void resetState({bool notify = true}) {
    _state = AsyncViewState.initial;
    _errorMessage = null;
    if (notify) notifyListeners();
  }
}

enum AsyncViewState { initial, loading, success, error }
