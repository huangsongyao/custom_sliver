import 'package:custom_sliver/custom_sliver_enum.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as HSY;

typedef HSYCustomSliverScrollChanged = void Function(
    HYSCustomSliverScrollStatus status, num offsets);

class HSYCustomSliverView extends StatefulWidget {
  final List<Widget> sliverHeaders;
  final double persistentHeaderHeights;
  final HSYCustomSliverScrollChanged onChanged;
  final Widget persistentHeader;
  final List<Key> positionKeys;
  final Widget nestedBody;

  HSYCustomSliverView({
    Key key,
    @required this.persistentHeaderHeights,
    @required this.persistentHeader,
    this.positionKeys = const [],
    this.sliverHeaders,
    this.nestedBody,
    this.onChanged,
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
        HYSCustomSliverScrollStatus status =
            HYSCustomSliverScrollStatus.InSlivers;
        if (_scrollController.offset ==
            _scrollController.position.minScrollExtent) {
          status = HYSCustomSliverScrollStatus.InSliverTops;
        } else if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent) {
          status = HYSCustomSliverScrollStatus.InSliverBottoms;
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
      innerScrollPositionKeyBuilder: (this.widget.positionKeys.isNotEmpty
          ? () {
              return this.widget.positionKeys.first;
            }
          : null),
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
  final Widget child;
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
