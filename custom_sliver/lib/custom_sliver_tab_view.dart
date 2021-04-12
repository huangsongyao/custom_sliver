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
typedef HSYCustomTabChanged = void Function(
    int index, HSYCustomTabBarItemConfigs itemConfigs, bool isClickedTabBar);

const String _HSYCustomSliverKeyPrefix = 'HSYCustomSliverKeyPrefix';

class HSYCustomSliverTabView extends StatefulWidget {
  final int initSelectedIndex;
  final BoxDecoration backgroundDecoration;
  final HSYCustomSliverConfigs customSliverConfigs;
  final HSYCustomSliverScrollChanged onSliverChanged;
  final HSYCustomSliverBuilder onBuilder;
  final HSYCustomSliverRefresh onRefresh;
  final HSYCustomSliverRefresh onLoading;
  final HSYCustomTabChanged onChanged;
  final List<Widget> sliverHeaders;
  final Widget refreshHeader;
  final Widget refreshFooter;
  final bool openDownRefresh;
  final bool openUpRefresh;
  final double tabHeights;
  final Widget empty;

  HSYCustomSliverTabView({
    Key key,
    @required this.customSliverConfigs,
    this.backgroundDecoration,
    this.initSelectedIndex = 0,
    this.tabHeights = kToolbarHeight,
    this.openDownRefresh = false,
    this.openUpRefresh = true,
    this.sliverHeaders,
    this.refreshHeader,
    this.refreshFooter,
    this.onSliverChanged,
    this.onChanged,
    this.onBuilder,
    this.onRefresh,
    this.onLoading,
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
        this.widget.onRefresh == null,
        '如果支持下拉刷新操作，则下拉请求事件不能为null',
      );
    }
    if (this.widget.openUpRefresh) {
      assert(
        this.widget.onLoading == null,
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
      length: this.widget.customSliverConfigs.tabDatas.length,
      vsync: this,
    )..addListener(() {
        _selectedIndex = _tabController.index;
        _onChangedPage(
          _selectedIndex,
          this
              .widget
              .customSliverConfigs
              .tabBarConfigs
              .tabBarItemConfigs[_selectedIndex],
          false,
        );
      });
    _positionKeys = this.widget.customSliverConfigs.tabDatas.map((tabData) {
      return Key(
          '$_HSYCustomSliverKeyPrefix.${this.widget.customSliverConfigs.tabDatas.indexOf(tabData)}');
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
      sliverHeaders: (this.widget.sliverHeaders ?? Container()),
      persistentHeaderHeights: this.widget.tabHeights,
      persistentHeader: HSYCustomTabBar(
        initTabBarConfigs: this.widget.customSliverConfigs.tabBarConfigs,
        backgroundDecoration: this.widget.backgroundDecoration,
        initSelectedIndex: _selectedIndex,
        tabHeights: this.widget.tabHeights,
        tabController: _tabController,
        onChanged: (int index, HSYCustomTabBarItemConfigs itemConfigs) {
          _selectedIndex = _tabController.index;
          _onChangedPage(
            index,
            itemConfigs,
          );
        },
      ),
      nestedBody: TabBarView(
        controller: _tabController,
        children: this.widget.customSliverConfigs.tabDatas.map((datas) {
          final int pages =
              this.widget.customSliverConfigs.tabDatas.indexOf(datas);
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
              : (this.widget.empty ??
                  [
                    HSYCustomSliverEmpty(
                      reqResult: HSYSliverRefreshResult.NotData,
                    ),
                  ]));
          if (HSYDevicesStatus.hasBottomsPadding(context)) {
            children.add(HSYIosBottomSafeWidget());
          }
          return HSY.NestedScrollViewInnerScrollPositionKeyWidget(
            _positionKeys[pages],
            SmartRefresher(
              controller: _refreshControllers[pages],
              enablePullDown: this.widget.openDownRefresh,
              enablePullUp: this.widget.openUpRefresh,
              header: CustomHeader(
                builder: (BuildContext context, RefreshStatus mode) {
                  return (this.widget.refreshHeader ??
                      HSYCustomSliverHeaderRefresh());
                },
              ),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  return (this.widget.refreshFooter ??
                      HSYCustomSliverFooterRefresh());
                },
              ),
              onRefresh: () {
                _onRefresh(pages);
              },
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
      onSliverChanged: this.widget.onSliverChanged,
    );
  }

  void _onRefresh([
    int pages = 0,
  ]) {
    this.widget.onRefresh(
      pages,
      (HSYSliverRefreshResult result) {
        switch (result) {
          case HSYSliverRefreshResult.Failure:
            _refreshControllers[pages].refreshFailed();
            break;
          case HSYSliverRefreshResult.Completed:
          case HSYSliverRefreshResult.NotData:
            _refreshControllers[pages].refreshCompleted();
            break;
        }
      },
    );
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

  void _onChangedPage(
    int index,
    HSYCustomTabBarItemConfigs itemConfigs, [
    bool isClickedTabBar = true,
  ]) {
    if (this.widget.onChanged != null) {
      this.widget.onChanged(
            index,
            itemConfigs,
            isClickedTabBar,
          );
    }
  }
}
