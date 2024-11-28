import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'LocalhostTest.dart';
import 'LocalhostWebView.dart';
import 'bolgguri.dart';
import 'bolgguri_test.dart';
import 'mukgguri.dart';
import 'jalgguri.dart';
import 'KeywordBolgguri.dart';
import 'tripbolgguri.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tour_friend',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isTextVisible = false; // 텍스트 가시성 상태 관리
  String content = '- 문의: bluelegend75@gmail.com';

  void _toggleTextVisibility() {
    setState(() {
      _isTextVisible = !_isTextVisible; // 버튼 클릭 시 텍스트의 가시성 토글
    });
  }

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    fetchContent();
  }

  Future<void> fetchContent() async {
    //final response = await http.get(Uri.parse('https://aws.bluelegend.net/getAppMsg'));
    final url = Uri.parse('https://aws.bluelegend.net/getAppMsg');
    final headers = {"Content-Type": "application/json"};
    try {
      final response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          content = data['message'];
          content = data['message'].replaceAll('\\n', '\n');
          print('content:'+content);
        });
      } else {
        setState(() {
          content = '메세지를 가져오지 못했습니다.';
        });
      }
    } catch(error){
      setState(() {
        content = '오류가 발생했습니다: $error';
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      await Permission.location.request();
    }
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final imageSize = screenHeight > 700 ? 350.0 : 200.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('여행친구',
                    style: GoogleFonts.eastSeaDokdo(
                      fontSize: 48,
                      fontWeight: FontWeight.w300,
                      textStyle: TextStyle(color: Colors.blue, letterSpacing: 5.5),
                    ),
          // style: GoogleFonts(),
          // googleFonts.pacifico( // Pacifico 폰트 사용
          //   fontSize: 25.0, // 폰트 크기
          //   color: Colors.white, // 텍스트 색상
          // ),
            // style: TextStyle(
            //   fontSize: 20.0, // 폰트 크기
            //   fontWeight: FontWeight.bold, // 굵은 글씨
            //   color: Colors.white, // 텍스트 색상
            //   shadows: [
            //     Shadow(
            //       color: Colors.black54, // 그림자 색상
            //       offset: Offset(2.0, 2.0), // 그림자 위치
            //       blurRadius: 4.0, // 그림자 흐림 정도
            //     ),
            //   ],
            // ),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(Icons.favorite,color: Colors.red, size: 25.0),
          //   onPressed: _toggleTextVisibility, // 버튼을 눌렀을 때 텍스트 입력 창 보여주기
          // ),
           // SizedBox(width:0), // 간격 조정 (0으로 설정하면 간격이 없게됨)
          TextButton(
            child: Text('♥공지&후원', style: TextStyle(fontSize: 20.0,color: Colors.red)),
            onPressed: _toggleTextVisibility, // 버튼 클릭 시 텍스트 토글
          ),
        ],
      ),
      body:SingleChildScrollView( // 스크롤 기능 추가
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              // Padding(
              //   padding: EdgeInsets.all(16.0), // 모든 방향에 16픽셀 패딩
              //   child: SelectableText('선택 가능한 텍스트'),
              // )
            children: <Widget>[
              if (_isTextVisible) // 가시성에 따라 텍스트 표시 여부 결정
                Padding(
                  // padding: EdgeInsets.all(25.0), // 모든 방향에 16픽셀 패딩
                  padding: EdgeInsets.symmetric(horizontal: 30.0), // 좌우에만 패딩
                  child: SelectableText(
                    content,
                    //' 앱에 만족하시면 더 많은 프로그램을 개발할수 있도록 '
                    //  '백수개발자를 후원해 주세요.^^\n'
                    //  '- 우리은행 신동철\n'
                    //  '022-204590-02-101\n'
                    // '앱 관련 문의: bluelegend75@gmail.com',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.left,),
                ),
              Image.asset(
                  'assets/earth_white.gif',
                  width: imageSize,  // 원하는 너비로 변경
                  height: imageSize, // 원하는 높이로 변경
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => PageOne()),
              //     );
              //   },
              //   child: Text('Go to Page One'),
              // ),
              // ElevatedButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => PageTwo()),
              //     );
              //   },
              //   child: Text('Go to Page Two'),
              // ),
              // SizedBox(height: 10),
              // buildButton('Localhost_copilot', 'assets/view_icon.png', 30, LocalhostWebView()),
              // SizedBox(height: 10),
              // buildButton('LocalhostTest_GPT', 'assets/view_icon.png', 30, LocalhostTest()),
              // SizedBox(height: 10),
              // buildButton('볼꺼리Test', 'assets/view_icon.png', 30, BolgguriTest()),
              SizedBox(height: 10),
              buildButton('볼꺼리', 'assets/view_icon.png', 30, Bolgguri()),
              SizedBox(height: 10),
              buildButton('먹꺼리', 'assets/food_icon.png', 30, Mukgguri()),
              SizedBox(height: 10),
              buildButton('잘꺼리', 'assets/hotel_icon.png', 30, Jalgguri()),
              SizedBox(height: 10),
              buildButton('경로 주변 탐색', 'assets/car_icon.png', 30, TripBolgguri()),
              SizedBox(height: 10),
              buildButton('키워드 검색', null, 30, KeywordBolgguri(), useIcon: Icons.search),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton buildButton(String text, String? iconPath, double iconSize, Widget page, {IconData? useIcon}) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
      },
      style: ElevatedButton.styleFrom(minimumSize: Size(200, 60)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPath != null)
            Image.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
            ),
          if (useIcon != null)
            Icon(useIcon, size: iconSize),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 30)),
        ],
      ),
    );
  }
}



class PageOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page One'),
      ),
      body: Center(
        child: Text('This is Page One'),
      ),
    );
  }
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page Two'),
      ),
      body: Center(
        child: Text('This is Page Two'),
      ),
    );
  }
}
