import 'dart:async';

typedef RefreshOperation = Future<String?> Function();

final class RefreshCoordinator {
  Future<String?>? _activeRefresh;

  Future<String?> refresh(RefreshOperation operation) {
    final active = _activeRefresh;
    if (active != null) return active;
    late final Future<String?> coordinated;
    coordinated = operation().whenComplete(() {
      if (identical(_activeRefresh, coordinated)) _activeRefresh = null;
    });
    _activeRefresh = coordinated;
    return coordinated;
  }
}
