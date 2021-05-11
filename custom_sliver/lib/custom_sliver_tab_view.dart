import 'dart:async';

import 'package:custom_sliver/custom_sliver.dart';
import 'package:custom_sliver/custom_sliver_configs.dart';
import 'package:custom_sliver/custom_sliver_devices.dart';
import 'package:custom_sliver/custom_sliver_enum.dart';
import 'package:custom_sliver/custom_sliver_refresh.dart';
import 'package:custom_tab_bar/custom_tab_bar.dart';
import 'package:custom_tab_bar/custom_tab_configs.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as HSY;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

typedef HSYCustomSliverBuilder = Widget Function(
    dynamic item, int index, int pages);
typedef HSYCustomSliverRefreshResult = void Function(
    HSYSliverRefreshResult result);
typedef HSYCustomSliverRefresh = void Function(
    int pages, HSYCustomSliverRefreshResult result);
typedef HSYCustomNestedTabChanged = void Function(
    int index,
    HSYCustomTabBarItemConfigs itemConfigs,
    bool isClickedTabBar,
    bool toChangedOthers);

const String _HSYCustomSliverKeyPrefix = 'HSYCustomSliverKeyPrefix';

class HSYCustomSliverTabView extends StatefulWidget {
  /// 初始选中的tab位置
  final int initSelectedIndex;

  /// 自定义tabBar的背景色
  final BoxDecoration tabBarBackground;

  /// 整个组合组件的数据源
  final HSYCustomSliverConfigs customSliverConfigs;

  /// 组合组件的滚动状态监听
  final HSYCustomSliverScrollChanged onSliverChanged;

  /// 外部通过这个builder来创建每个page中的小部件
  final HSYCustomSliverBuilder onBuilder;

  /// 下拉刷新事件
  final HSYCustomSliverRefresh onRefresh;

  /// 上拉加载更多事件
  final HSYCustomSliverRefresh onLoading;

  /// 点击TabBar或者滑动TabBarView的切换事件
  final HSYCustomNestedTabChanged onChanged;

  /// 组合组件的头部
  final List<Widget> sliverHeaders;

  /// 下拉刷新的头部
  final Widget refreshHeader;

  /// 上拉加载更多的底部
  final Widget refreshFooter;

  /// 是否添加下拉刷新
  final bool openDownRefresh;

  /// 是否添加上拉加载更多，这个是一个外部控制的bool集合，元素对应了每个page
  final List<bool> openUpRefreshs;

  /// 整个悬浮Bar的高度，这个高度包含了[tabHeights]+[tabHeader]+[tabFooter]的高度
  final double sliverTabBarHeights;

  /// TabBar的高度，默认为kToolbarHeight
  final double tabHeights;

  /// Tabbar的头部部件
  final Widget tabHeader;

  /// Tabbar的底部部件
  final Widget tabFooter;

  /// page为空数据时的占位小部件
  final Widget empty;

  HSYCustomSliverTabView({
    Key key,
    @required this.customSliverConfigs,
    this.initSelectedIndex = 0,
    this.tabHeights = kToolbarHeight,
    this.openDownRefresh = false,
    this.tabBarBackground,
    this.openUpRefreshs,
    this.sliverHeaders,
    this.refreshHeader,
    this.refreshFooter,
    this.sliverTabBarHeights,
    this.onSliverChanged,
    this.onChanged,
    this.onBuilder,
    this.onRefresh,
    this.onLoading,
    this.tabHeader,
    this.tabFooter,
    this.empty,
  }) : super(key: key);

  @override
  _HSYCustomSliverTabViewState createState() => _HSYCustomSliverTabViewState();
}

class _HSYCustomSliverTabViewState extends State<HSYCustomSliverTabView>
    with TickerProviderStateMixin {
  int _selectedIndex;
  TabController _tabController;
  List<RefreshController> _refreshControllers;
  List<Key> _positionKeys;

  void _asserts() {
    if (this.widget.openDownRefresh) {
      assert(
        this.widget.onRefresh != null,
        '如果支持下拉刷新操作，则下拉请求事件不能为null',
      );
    }
    if ((this.widget.openUpRefreshs ?? []).isNotEmpty) {
      assert(
        this.widget.onLoading != null,
        '如果支持上拉加载更多操作，则上拉请求事件不能为null',
      );
    }
    assert(
      this.widget.customSliverConfigs != null,
      '数据配置及相关内容不能为null',
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _asserts();
    _selectedIndex = (this.widget.initSelectedIndex ?? 0);
    _tabController = TabController(
      initialIndex: _selectedIndex,
      length: this.widget.customSliverConfigs.pagesDatas.length,
      vsync: this,
    )..addListener(
        () {
          _selectedIndex = _tabController.index;
          _onChangedPage(
            index: _selectedIndex,
            itemConfigs: this
                .widget
                .customSliverConfigs
                .tabBarConfigs
                .tabBarItemConfigs[_selectedIndex],
            isClickedTabBar: false,
          );
        },
      );
    _positionKeys = this.widget.customSliverConfigs.pagesDatas.map((tabData) {
      return Key(
          '$_HSYCustomSliverKeyPrefix.${this.widget.customSliverConfigs.pagesDatas.indexOf(tabData)}');
    }).toList();
    _refreshControllers = _positionKeys.map((key) {
      return RefreshController();
    }).toList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
    _refreshControllers.forEach((element) {
      element.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return HSYCustomSliverView(
      positionKeys: _positionKeys,
      onTabChanged: (List<Key> positionKeys) {
        return positionKeys[_selectedIndex];
      },
      sliverHeaders: (this.widget.sliverHeaders ?? Container()),
      persistentHeaderHeights: (this.widget.sliverTabBarHeights ??
          (this.widget.tabHeights ?? kToolbarHeight)),
      persistentHeader: Container(
        child: Column(
          children: [
            (this.widget.tabHeader ?? Container()),
            HSYCustomTabBar(
              delayedListener: false,
              initTabBarConfigs: this.widget.customSliverConfigs.tabBarConfigs,
              backgroundDecoration: this.widget.tabBarBackground,
              tabHeights: this.widget.tabHeights,
              initSelectedIndex: _selectedIndex,
              tabController: _tabController,
              onChanged: (int index, HSYCustomTabBarItemConfigs itemConfigs,
                  bool toChangedOthers) {
                _selectedIndex = _tabController.index;
                _onChangedPage(
                  index: index,
                  itemConfigs: itemConfigs,
                  toChangedOthers: toChangedOthers,
                );
              },
            ),
            (this.widget.tabFooter ?? Container()),
          ],
        ),
      ),
      nestedBody: TabBarView(
        controller: _tabController,
        children: this.widget.customSliverConfigs.pagesDatas.map((datas) {
          final int pages =
              this.widget.customSliverConfigs.pagesDatas.indexOf(datas);
          final List<Widget> children = (datas.pageDatas.isNotEmpty
              ? (this.widget.onBuilder != null
                  ? datas.pageDatas.map((item) {
                      return this.widget.onBuilder(
                            item,
                            datas.pageDatas.indexOf(item),
                            pages,
                          );
                    }).toList()
                  : [])
              : [
                  (this.widget.empty ??
                      HSYCustomSliverEmpty(
                        reqResult: HSYSliverRefreshResult.NotData,
                      )),
                ]);
          if (HSYDevicesStatus.hasBottomsPadding(context)) {
            children.add(HSYIosBottomSafeWidget());
          }
          return HSY.NestedScrollViewInnerScrollPositionKeyWidget(
            _positionKeys[pages],
            SmartRefresher(
              enablePullDown: false,
              enablePullUp: this.widget.openUpRefreshs[pages],
              controller: _refreshControllers[pages],
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  return HSYCustomSliverFooterRefresh(
                    child: this.widget.refreshFooter,
                  );
                },
              ),
              onLoading: () {
                _onLoading(pages);
              },
              child: ListView(
                children: children,
              ),
            ),
          );
        }).toList(),
      ),
      onSliverChanged: (HYSCustomSliverScrollStatus status, num offsets) {
        if (this.widget.onSliverChanged != null) {
          this.widget.onSliverChanged(status, offsets);
        }
      },
      onRefresh: (this.widget.openDownRefresh
          ? () {
              return _onRefresh(_selectedIndex).stream.first;
            }
          : null),
    );
  }

  StreamController _onRefresh([
    int pages = 0,
  ]) {
    StreamController<HSYSliverRefreshResult> streamController =
        StreamController<HSYSliverRefreshResult>();
    this.widget.onRefresh(
      pages,
      (HSYSliverRefreshResult result) {
        streamController.sink.add(result);
        streamController.close();
      },
    );
    return streamController;
  }

  void _onLoading([
    int pages = 0,
  ]) {
    this.widget.onLoading(
      pages,
      (HSYSliverRefreshResult result) {
        switch (result) {
          case HSYSliverRefreshResult.Failure:
            _refreshControllers[pages].loadFailed();
            break;
          case HSYSliverRefreshResult.Completed:
            _refreshControllers[pages].loadComplete();
            break;
          case HSYSliverRefreshResult.NotData:
            _refreshControllers[pages].loadNoData();
            break;
        }
      },
    );
  }

  void _onChangedPage({
    @required int index,
    @required HSYCustomTabBarItemConfigs itemConfigs,
    bool isClickedTabBar = true,
    bool toChangedOthers = false,
  }) {
    if (this.widget.onChanged != null) {
      this.widget.onChanged(
            index,
            itemConfigs,
            isClickedTabBar,
            toChangedOthers,
          );
    }
  }
}
