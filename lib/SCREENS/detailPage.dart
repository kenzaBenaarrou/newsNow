import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/route_manager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../MODELS/articleModel.dart';
import '../WIDGETS/alert.dart';

class DetailPage extends StatefulWidget {
  final Article? article;
  const DetailPage({super.key, this.article});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text(
              widget.article!.title,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            ),
          ),
          body: SafeArea(
            child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..setNavigationDelegate(
                    NavigationDelegate(
                      onProgress: (int progress) {
                        CircularProgressIndicator(
                          value: progress.toDouble(),
                        );
                      },
                      onWebResourceError: (WebResourceError error) {
                        alert(
                            "Something went wrong with link, try again later.",
                            Colors.black,
                            3);
                        Get.back();
                      },
                    ),
                  )
                  ..loadRequest(Uri.parse(widget.article!.url))),
          )),
    );
  }
}
