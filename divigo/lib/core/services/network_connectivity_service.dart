import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivityService {
  final _connectivity = Connectivity();
  DateTime? _lastConnectedTime;
  bool _isConnected = false;
  bool _isFirstCheck = true;

  StreamController<NetworkStatus> networkStatusController =
      StreamController<NetworkStatus>.broadcast();

  bool get isConnected => _isConnected;

  NetworkConnectivityService() {
    _initConnectivity();
  }

  void _initConnectivity() async {
    try {
      ConnectivityResult result = await _connectivity.checkConnectivity();
      _handleConnectivityChange(result);

      _connectivity.onConnectivityChanged.listen((result) {
        _handleConnectivityChange(result);
      });
    } catch (e) {
      print('Connectivity initialization error: $e');
    }
  }

  void _handleConnectivityChange(ConnectivityResult result) {
    bool isConnected = result != ConnectivityResult.none;

    if (isConnected != _isConnected || !_isFirstCheck) {
      _isConnected = isConnected;

      if (isConnected) {
        _lastConnectedTime = DateTime.now();
        networkStatusController.add(
          NetworkStatus(
            isConnected: true,
            duration: Duration.zero,
            message: '와이파이가 연결되었습니다.',
          ),
        );
      } else {
        final duration = _lastConnectedTime != null
            ? DateTime.now().difference(_lastConnectedTime!)
            : Duration.zero;

        networkStatusController.add(
          NetworkStatus(
            isConnected: false,
            duration: duration,
            message: '와이파이 연결이 해제되었습니다.\n연결 시간: ${_formatDuration(duration)}',
          ),
        );
        _lastConnectedTime = null;
      }
    }

    _isFirstCheck = false;
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}시간 ${duration.inMinutes.remainder(60)}분';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}분 ${duration.inSeconds.remainder(60)}초';
    } else {
      return '${duration.inSeconds}초';
    }
  }

  void dispose() {
    networkStatusController.close();
  }
}

class NetworkStatus {
  final bool isConnected;
  final Duration duration;
  final String message;

  NetworkStatus({
    required this.isConnected,
    required this.duration,
    required this.message,
  });
}
