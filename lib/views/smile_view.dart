import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

Widget buildSmileIDPlatformView({
  required BuildContext context,
  required String viewType,
  required Map<String, dynamic> creationParams,
  required void Function(String result) onSuccess,
  required void Function(String error) onError,
}) {
  void onPlatformViewCreated(int id) {
    final channel = MethodChannel("${viewType}_$id");
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "onSuccess":
          onSuccess(call.arguments);
          break;
        case "onError":
          onError(call.arguments);
          break;
        default:
          throw MissingPluginException('Unknown method ${call.method}');
      }
    });
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return SafeArea(
        child: PlatformViewLink(
          viewType: viewType,
          surfaceFactory: (context, controller) {
            return AndroidViewSurface(
              controller: controller as AndroidViewController,
              hitTestBehavior: PlatformViewHitTestBehavior.opaque,
              gestureRecognizers: const {
                Factory<OneSequenceGestureRecognizer>(
                    EagerGestureRecognizer.new)
              },
            );
          },
          onCreatePlatformView: (params) {
            return PlatformViewsService.initExpensiveAndroidView(
              id: params.id,
              viewType: viewType,
              layoutDirection: Directionality.of(context),
              creationParams: creationParams,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () {
                params.onFocusChanged(true);
              },
            )
              ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
              ..addOnPlatformViewCreatedListener(onPlatformViewCreated)
              ..create();
          },
        ),
      );
    case TargetPlatform.iOS:
      return UiKitView(
        viewType: viewType,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: onPlatformViewCreated,
      );
    default:
      throw UnsupportedError("Unsupported platform");
  }
}
