import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

class VGSFlutter {
  static const MethodChannel _channel = MethodChannel('vgs_flutter');

  static Future<String?> send({required VGSCollectData data}) async {
    try {
      return await _channel.invokeMethod<String>('sendData', data.toMap());
    } on PlatformException catch (e) {
      log('VGS Exception: $e');
      return null;
    }
  }
}

class VGSCollectData {
  VGSCollectData({
    required this.vaultId,
    required this.sandbox,
    required this.headers,
    required this.extraData,
  });

  final String vaultId;
  final bool sandbox;
  final Map<String, String> headers;
  final VGSExtraData extraData;

  Map<String, Object> toMap() {
    return {
      'vaultId': vaultId,
      'sandbox': sandbox,
      'headers': headers,
      'data': extraData.toMap(),
    };
  }
}

class VGSExtraData {
  VGSExtraData({
    required this.query,
    required this.variables,
  });

  final String query;
  final Map<String, Object> variables;

  Map<String, Object> toMap() {
    return {
      'query': query,
      'variables': variables,
    };
  }
}
