import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpeechWebView extends StatefulWidget {
  final Function(String text) onResult;

  const SpeechWebView({super.key, required this.onResult});

  @override
  State<SpeechWebView> createState() => _SpeechWebViewState();
}

class _SpeechWebViewState extends State<SpeechWebView> {
  late WebViewController _controller;

  final String htmlContent = '''
    <!DOCTYPE html>
    <html>
    <body style="background-color:#0A0B1F;color:white;font-family:sans-serif;">
      <h3>Listening...</h3>
      <script>
        const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
        const recognition = new SpeechRecognition();
        recognition.lang = 'en-US';
        recognition.interimResults = false;
        recognition.maxAlternatives = 1;

        recognition.onresult = (event) => {
          const result = event.results[0][0].transcript;
          SpeechResult.postMessage(result);
        };

        recognition.onerror = (e) => {
          SpeechResult.postMessage('');
        };

        recognition.start();
      </script>
    </body>
    </html>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speak now')),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
          _controller.loadHtmlString(htmlContent);
        },
        javascriptChannels: {
          JavascriptChannel(
            name: 'SpeechResult',
            onMessageReceived: (message) {
              widget.onResult(message.message);
              Navigator.pop(context); // Close when result is received
            },
          ),
        },
      ),
    );
  }
}
