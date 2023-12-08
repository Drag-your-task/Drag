import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../utils/uil.dart';
import '../../viewmodels/task_viewmodel.dart';



class WordCloudScreen extends StatefulWidget {
  const WordCloudScreen({Key? key}) : super(key: key);

  @override
  State<WordCloudScreen> createState() => _WordCloudScreenState();
}

class _WordCloudScreenState extends State<WordCloudScreen> {
  String _base64Image = '';

  Future<void> generateWordCloud(String text) async {
    print('hhh');
    final response = await http.post(
      Uri.parse('https://stark-oasis-98237-ace4ec22c82d.herokuapp.com/generate_wordcloud'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'text': text}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _base64Image = json.decode(response.body)['image'];
      });
    } else {
      print('Failed to generate image: ${response.body}');
    }
  }

  Future<void> shareImage(String base64Image) async {
    // base64 문자열을 바이트 데이터로 변환
    final decodedBytes = base64Decode(base64Image);

    // 파일 시스템에 저장할 디렉터리를 얻음
    final directory = await getApplicationDocumentsDirectory();

    // 파일 경로 생성
    final imagePath = '${directory.path}/word_cloud.png';
    final file = File(imagePath);

    // 파일로 이미지 데이터 저장
    await file.writeAsBytes(decodedBytes);

    // 파일 공유
    Share.shareXFiles([XFile(imagePath)]);
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
      generateWordCloud(await taskViewModel.drawWordCloud());
    });
  }


  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    String thisMonth = months[ DateTime.now().month -1];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Word Cloud - 2023 '+ thisMonth,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () async {
                    generateWordCloud(await taskViewModel.drawWordCloud());
                  },
                  icon: Icon(
                    CupertinoIcons.arrow_clockwise_circle_fill,
                    size: 20,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (_base64Image.isNotEmpty) {
                      shareImage(_base64Image);
                      //print(_base64Image);
                    }
                  },
                  icon: Icon(
                    CupertinoIcons.download_circle_fill,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
        Divider(),
        _base64Image.isNotEmpty
            ? Image.memory(base64Decode(_base64Image))
            : Container(
          height: 200,
          alignment: Alignment.center,
            child: Image.asset('assets/icons/progress_icon.gif', width: 50,)
        ),
      ],
    );
  }
}
