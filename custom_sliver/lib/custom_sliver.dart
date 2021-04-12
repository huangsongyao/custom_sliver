import 'package:custom_sliver/custom_sliver_enum.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as HSY;

typedef HSYCustomSliverScrollChanged = void Function(
    HYSCustomSliverScrollStatus status, num offsets);
typedef HSYCustomSliverPositionKeyBuilder = Key Function(
    List<Key> positionKeys);

class HSYCustomSliverView extends StatefulWidget {
  /// 组合组件的头部
  final List<Widget> sliverHeaders;

  /// 组合组件的悬浮部件的高度
  final double persistentHeaderHeights;

  /// 监听整个组合组件的滚动位置
  final HSYCustomSliverScrollChanged onSliverChanged;

  /// 反向监听切换tab的动作，用于内部报错列表的状态
  final HSYCustomSliverPositionKeyBuilder onTabChanged;

  /// 组合组件的悬浮部件
  final Widget persistentHeader;

  /// 组合组件的keys
  final List<Key> positionKeys;

  /// 组合组件的body组件
  final Widget nestedBody;

  HSYCustomSliverView({
    Key key,
    @required this.persistentHeaderHeights,
    @required this.persistentHeader,
    this.positionKeys = const [],
    this.onSliverChanged,
    this.sliverHeaders,
    this.onTabChanged,
    this.nestedBody,
  }) : super(key: key);

  @override
  _HSYCustomSliverViewState createState() => _HSYCustomSliverViewState();
}

class _HSYCustomSliverViewState extends State<HSYCustomSliverView> {
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (this.widget.onSliverChanged != null) {
          HYSCustomSliverScrollStatus status =
              HYSCustomSliverScrollStatus.InSlivers;
          if (_scrollController.offset ==
              _scrollController.position.minScrollExtent) {
            status = HYSCustomSliverScrollStatus.InSliverTops;
          } else if (_scrollController.offset ==
              _scrollController.position.maxScrollExtent) {
            status = HYSCustomSliverScrollStatus.InSliverBottoms;
          }
          this.widget.onSliverChanged(status, _scrollController.offset);
        }
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HSY.NestedScrollView(
      controller: _scrollController,
      innerScrollPositionKeyBuilder: () {
        if (this.widget.onTabChanged != null &&
            this.widget.positionKeys.isNotEmpty) {
          return this.widget.onTabChanged(this.widget.positionKeys);
        }
        return Key('None');
      },
      pinnedHeaderSliverHeightBuilder: () {
        return this.widget.persistentHeaderHeights;
      },
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverOverlapAbsorber(
            handle:
                HSY.NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: (this.widget.sliverHeaders ?? []),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: _HSYCustomSliverPersistentHeaderDelegate(
              persistentHeaderHeights: this.widget.persistentHeaderHeights,
              child: this.widget.persistentHeader,
            ),
          ),
        ];
      },
      body: this.widget.nestedBody,
    );
    ;
  }
}

class _HSYCustomSliverPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  /// 自定义悬浮组件的协议的内容小部件
  final Widget child;

  /// 自定义悬浮组件的协议的悬浮高度
  final double persistentHeaderHeights;

  _HSYCustomSliverPersistentHeaderDelegate({
    @required this.child,
    @required this.persistentHeaderHeights,
  });

  @override
  double get minExtent => this.persistentHeaderHeights;

  @override
  double get maxExtent => this.persistentHeaderHeights;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: this.child,
    );
  }

  @override
  bool shouldRebuild(_HSYCustomSliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
