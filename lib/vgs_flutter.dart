import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

class VGSShowCardSensitiveData {
  VGSShowCardSensitiveData({
    required this.vaultId,
    required this.sandbox,
    required this.cardId,
    required this.customerToken,
  });

  final String vaultId;
  final bool sandbox;
  final String cardId;
  final String customerToken;
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

class VgsCardNumberShowView extends StatefulWidget {
  VgsCardNumberShowView({
    Key? key,
    required this.onPlatformViewCreated,
  }) : super(key: key);

  final VGSShowCardNumberController? Function(int) onPlatformViewCreated;

  @override
  _VGSShowCardNumberViewState createState() => _VGSShowCardNumberViewState();

  static Future<bool> showCardNumber(
    VGSShowCardNumberController showController,
    VGSShowCardSensitiveData vgsShowCardSensitiveData,
  ) async {
    Map<dynamic, dynamic> value = await showController.revealCardAsync(
      vgsShowCardSensitiveData,
    );

    final entries = value.entries;
    print("show value.entries: $entries");

    final errorCode = value[VgsPluginConfig.SHOW_ERROR_CODE_KEY];
    if (errorCode != null) {
      print("VGS Show SDK error code: $errorCode");

      final errorMessage = value[VgsPluginConfig.SHOW_ERROR_MESSAGE_KEY];
      if (errorMessage != null) {
        print("VGS Show SDK error message: $errorMessage");
      }
      return false;
    }

    final successStatusCode = value[VgsPluginConfig.SHOW_SUCCESS_CODE_KEY];
    if (successStatusCode != null) {
      print("VGS Show success status code: $successStatusCode");
    }

    return true;
  }
}

class _VGSShowCardNumberViewState extends State<VgsCardNumberShowView> {
  @override
  Widget build(BuildContext context) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return isAndroid ? _cardShow() : _cardShowNativeiOS();
  }

  Widget _cardShow() {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return SizedBox(
      height: 20.0,
      width: 160,
      child: PlatformViewLink(
        viewType: VgsPluginConfig.SHOW_CARD_NUMBER_VIEW_TYPE,
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          AndroidViewController _ctrl = controller as AndroidViewController;
          return AndroidViewSurface(
            controller: _ctrl,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          var platformView = PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: VgsPluginConfig.SHOW_CARD_NUMBER_VIEW_TYPE,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: StandardMessageCodec(),
          );
          platformView
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          platformView
              .addOnPlatformViewCreatedListener(_createCardShowController);
          platformView.create();
          return platformView;
        },
      ),
    );
  }

  Widget _cardShowNativeiOS() {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return SizedBox(
      height: 20.0,
      width: 160,
      child: Align(
        alignment: Alignment.centerRight,
        child: UiKitView(
          viewType: VgsPluginConfig.SHOW_CARD_NUMBER_VIEW_TYPE,
          onPlatformViewCreated: _createCardShowController,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        ),
      ),
    );
  }

  void _createCardShowController(int id) {
    print("Show View id = $id");
    widget.onPlatformViewCreated(id);
  }
}

class VGSShowCardNumberController {
  VGSShowCardNumberController(int id)
      : _channel =
            MethodChannel('${VgsPluginConfig.SHOW_CARD_NUMBER_VIEW_TYPE}/$id');

  final MethodChannel _channel;

  Future<Map<dynamic, dynamic>> revealCardAsync(
      VGSShowCardSensitiveData vgsShowCardSensitiveData) async {
    print(
        "${vgsShowCardSensitiveData.cardId} /n ${vgsShowCardSensitiveData.customerToken}");

    return await _channel.invokeMethod('revealCard', [
      vgsShowCardSensitiveData.vaultId,
      vgsShowCardSensitiveData.sandbox,
      vgsShowCardSensitiveData.customerToken,
      vgsShowCardSensitiveData.cardId,
    ]);
  }
}

class VgsCVVNumberShowView extends StatefulWidget {
  VgsCVVNumberShowView({
    Key? key,
    required this.onPlatformViewCreated,
  }) : super(key: key);

  final VGSShowCVVNumberController? Function(int) onPlatformViewCreated;

  @override
  _VGSShowCVVNumberViewState createState() => _VGSShowCVVNumberViewState();

  static Future<bool> showCVVNumber(
    VGSShowCVVNumberController showController,
    VGSShowCardSensitiveData vgsShowCardSensitiveData,
  ) async {
    Map<dynamic, dynamic> value = await showController.revealCVVAsync(
      vgsShowCardSensitiveData,
    );

    final entries = value.entries;
    print("show value.entries: $entries");

    final errorCode = value[VgsPluginConfig.SHOW_ERROR_CODE_KEY];
    if (errorCode != null) {
      print("error!");
      print("VGS Show SDK error code: $errorCode");

      final errorMessage = value[VgsPluginConfig.SHOW_ERROR_MESSAGE_KEY];
      if (errorMessage != null) {
        print("VGS Show SDK error message: $errorMessage");
      }
      return false;
    }

    final successStatusCode = value[VgsPluginConfig.SHOW_SUCCESS_CODE_KEY];
    if (successStatusCode != null) {
      print("VGS Show success status code: $successStatusCode");
    }

    return true;
  }
}

class _VGSShowCVVNumberViewState extends State<VgsCVVNumberShowView> {
  @override
  Widget build(BuildContext context) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;

    return isAndroid ? _cvvShow() : _cvvShowNativeiOS();
  }

  Widget _cvvShow() {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return SizedBox(
      height: 20.0,
      width: 160,
      child: PlatformViewLink(
        viewType: VgsPluginConfig.SHOW_CVV_VIEW_TYPE,
        surfaceFactory:
            (BuildContext context, PlatformViewController controller) {
          AndroidViewController _ctrl = controller as AndroidViewController;
          return AndroidViewSurface(
            controller: _ctrl,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          );
        },
        onCreatePlatformView: (PlatformViewCreationParams params) {
          var platformView = PlatformViewsService.initSurfaceAndroidView(
            id: params.id,
            viewType: VgsPluginConfig.SHOW_CVV_VIEW_TYPE,
            layoutDirection: TextDirection.ltr,
            creationParams: creationParams,
            creationParamsCodec: StandardMessageCodec(),
          );
          platformView
              .addOnPlatformViewCreatedListener(params.onPlatformViewCreated);
          platformView
              .addOnPlatformViewCreatedListener(_createCardShowCVVController);
          platformView.create();
          return platformView;
        },
      ),
    );
  }

  Widget _cvvShowNativeiOS() {
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    return SizedBox(
      height: 20.0,
      width: 160,
      child: Align(
        alignment: Alignment.centerRight,
        child: UiKitView(
          viewType: VgsPluginConfig.SHOW_CVV_VIEW_TYPE,
          onPlatformViewCreated: _createCardShowCVVController,
          creationParams: creationParams,
          creationParamsCodec: StandardMessageCodec(),
        ),
      ),
    );
  }

  void _createCardShowCVVController(int id) {
    print("Show View id = $id");
    widget.onPlatformViewCreated(id);
  }
}

class VGSShowCVVNumberController {
  VGSShowCVVNumberController(int id)
      : _channel = MethodChannel('${VgsPluginConfig.SHOW_CVV_VIEW_TYPE}/$id');

  final MethodChannel _channel;

  Future<Map<dynamic, dynamic>> revealCVVAsync(
      VGSShowCardSensitiveData vgsShowCardSensitiveData) async {
    print(
        "${vgsShowCardSensitiveData.cardId} /n ${vgsShowCardSensitiveData.customerToken}");

    return await _channel.invokeMethod('revealCVV', [
      vgsShowCardSensitiveData.vaultId,
      vgsShowCardSensitiveData.sandbox,
      vgsShowCardSensitiveData.customerToken,
      vgsShowCardSensitiveData.cardId,
    ]);
  }
}

class VgsPluginConfig {
  // ignore: non_constant_identifier_names
  static final SHOW_CARD_NUMBER_VIEW_TYPE = 'card-show-card-number-view';
  // ignore: non_constant_identifier_names
  static final SHOW_CVV_VIEW_TYPE = 'card-show-cvv-view';
  // ignore: non_constant_identifier_names
  static final SHOW_SUCCESS_CODE_KEY = 'show_status_code';
  // ignore: non_constant_identifier_names
  static final SHOW_ERROR_CODE_KEY = 'show_error_code';
  // ignore: non_constant_identifier_names
  static final SHOW_ERROR_MESSAGE_KEY = 'show_error_message';
}
