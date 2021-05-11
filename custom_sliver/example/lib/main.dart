import 'dart:math';

import 'package:custom_sliver/custom_sliver_configs.dart';
import 'package:custom_sliver/custom_sliver_enum.dart';
import 'package:custom_tab_bar/custom_tab_configs.dart';
import 'package:custom_sliver/custom_sliver_tab_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TestCustomTabBar2(title: 'Flutter Demo Home Page'),
    );
  }
}

class TestCustomTabBar2 extends StatefulWidget {
  final String title;

  TestCustomTabBar2({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  _TestCustomTabBar2State createState() => _TestCustomTabBar2State();
}

class _TestCustomTabBar2State extends State<TestCustomTabBar2>
    with TickerProviderStateMixin {
  TabController _tabController;
  List<HSYCustomTabBarItemConfigs> _configs;
  HSYCustomSliverConfigs _sliverConfigs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _configs = [
      HSYCustomTabBarItemConfigs(
        text: '已入金',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已注册',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已交易',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已认证',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已理财',
        horizontals: 16.0,
      ),
      HSYCustomTabBarItemConfigs(
        text: '已登录',
        horizontals: 16.0,
      )
    ];
    _tabController = TabController(
      length: _configs.length,
      vsync: this,
    )..addListener(() {
        print(
            '------------_tabController.index=${_tabController.index}---------');
      });

    _sliverConfigs = HSYCustomSliverConfigs(
      tabBarConfigs: HSYCustomTabBarConfigs(
        itemConfigs: _configs,
        indicatorConfig:
            HSYCustomTabBarIndicatorConfig.indicator3(Size(24.0, 2.0)),
        tabPadding: EdgeInsets.symmetric(horizontal: 8.0),
      ),
      tabPageDatas: _configs.map((tab) {
        return HSYCustomSliverDatas(
          datas: (_configs.indexOf(tab) == 1
              ? []
              : _datas().map((index) {
                  return (int.tryParse(index) + Random().nextInt(100));
                }).toList()),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: HSYCustomSliverTabView(
        customSliverConfigs: _sliverConfigs,
        openUpRefreshs: _sliverConfigs.pagesDatas
            .map((datas) => datas.pageDatas.isNotEmpty)
            .toList(),
        onLoading: (int pages, HSYCustomSliverRefreshResult result) {
          Future.delayed(
            Duration(seconds: 2),
            () {
              final nexts = _datas().map((index) {
                return (int.tryParse(index) + Random().nextInt(100));
              }).toList();
              _sliverConfigs.updateSliverDatas(
                pages,
                nexts,
                true,
              );
              result(HSYSliverRefreshResult.Completed);
              setState(() {});
            },
          );
        },
        sliverTabBarHeights: 82,
        tabHeader: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Text('TabBar的头部'),
          color: Colors.limeAccent,
          width: MediaQuery.of(context).size.width,
          height: (82 - kToolbarHeight),
        ),
        openDownRefresh: true,
        onRefresh: (int pages, HSYCustomSliverRefreshResult result) {
          Future.delayed(
            Duration(seconds: 2),
            () {
              final nexts = _datas().map((index) {
                return (int.tryParse(index) + Random().nextInt(100));
              }).toList();
              _sliverConfigs.updateSliverDatas(
                pages,
                nexts,
              );
              result(HSYSliverRefreshResult.Completed);
              setState(() {});
            },
          );
        },
        onBuilder: (dynamic item, int index, int pages) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 15.0),
            alignment: Alignment.center,
            child: Text('$index-$item'),
          );
        },
        sliverHeaders: [
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.black26,
            height: 100,
          ),
          Container(
            color: Colors.cyanAccent,
            height: 100,
          ),
          Container(
            color: Colors.cyan,
            height: 100,
          ),
          Container(
            color: Colors.amber,
            height: 100,
          ),
          Container(
            color: Colors.black38,
            height: 100,
          ),
          Container(
            color: Colors.blue,
            height: 100,
          ),
          Container(
            color: Colors.deepOrange,
            height: 100,
          ),
          Container(
            color: Colors.black,
            height: 100,
          ),
          Container(
            color: Colors.greenAccent,
            height: 100,
          ),
        ],
      ),
    );
  }

  List<String> _datas() {
    final datas = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '7',
      '8',
      '9',
      '10',
      '11',
      '12',
      '13',
      '14',
      '15',
      '16',
      '17',
      '18',
      '19',
    ];
    return datas;
  }
}
