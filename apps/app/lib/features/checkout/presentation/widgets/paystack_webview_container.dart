import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/theme/app_colors.dart';

/// Embedded Webview container that renders Paystack's official multi-channel checkout
/// (Card, OPay, Bank Transfer, USSD, Apple Pay) inside a modal bottom sheet.
class PaystackWebviewContainer extends StatefulWidget {
  const PaystackWebviewContainer({
    super.key,
    required this.authorizationUrl,
    required this.initialReference,
    required this.onSuccess,
    required this.onClose,
    this.onError,
  });

  final String authorizationUrl;
  final String initialReference;
  final ValueChanged<String> onSuccess;
  final VoidCallback onClose;
  final ValueChanged<String>? onError;

  @override
  State<PaystackWebviewContainer> createState() =>
      _PaystackWebviewContainerState();
}

class _PaystackWebviewContainerState extends State<PaystackWebviewContainer> {
  WebViewController? _controller;
  bool _isLoading = true;
  bool _hasTriggeredSuccess = false;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    try {
      final ctrl = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (url) {
              _checkUrlForCompletion(url);
            },
            onPageFinished: (_) {
              if (mounted) setState(() => _isLoading = false);
            },
            onWebResourceError: (error) {
              // Graceful log without breaking navigation
            },
            onNavigationRequest: (request) {
              return _handleNavigation(request.url);
            },
          ),
        );
      ctrl.loadRequest(Uri.parse(widget.authorizationUrl)).catchError((e) {
        widget.onError?.call(e.toString());
      });
      _controller = ctrl;
    } catch (e) {
      widget.onError?.call(e.toString());
    }
  }

  NavigationDecision _handleNavigation(String url) {
    if (_checkUrlForCompletion(url)) {
      return NavigationDecision.prevent;
    }
    if (url.startsWith('tel:') || url.startsWith('sms:')) {
      return NavigationDecision.prevent;
    }
    return NavigationDecision.navigate;
  }

  bool _checkUrlForCompletion(String url) {
    if (_hasTriggeredSuccess) return true;
    final uri = Uri.tryParse(url);
    if (uri == null) return false;

    final isCallback = url.contains('standard.paystack.co/close') ||
        url.contains('/callback') ||
        uri.queryParameters.containsKey('trxref') ||
        uri.queryParameters.containsKey('reference');

    if (isCallback) {
      final ref = uri.queryParameters['reference'] ??
          uri.queryParameters['trxref'] ??
          widget.initialReference;

      if (ref.isNotEmpty) {
        _hasTriggeredSuccess = true;
        widget.onSuccess(ref);
        return true;
      }
    }

    if (url.contains('/cancel') || url.contains('cancel_action')) {
      widget.onClose();
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller;
    if (ctrl == null) {
      return const Center(
        child: Text(
          'Unable to load web checkout.',
          style: TextStyle(color: AppColors.error),
        ),
      );
    }

    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: WebViewWidget(controller: ctrl),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
      ],
    );
  }
}
