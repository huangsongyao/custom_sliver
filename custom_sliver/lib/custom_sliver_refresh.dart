import 'package:custom_sliver/custom_sliver_enum.dart';
import 'package:flutter/material.dart';

class HSYCustomSliverHeaderRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HSYCustomSliverFooterRefresh extends StatelessWidget {
  /// 外部自定义text
  final Widget text;

  HSYCustomSliverFooterRefresh({
    this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: kToolbarHeight,
      child: (this.text ??
          Text(
            'Loading...',
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.w100,
            ),
          )),
    );
  }
}

class HSYCustomSliverEmpty extends StatelessWidget {
  /// 悬浮组件的高度，既TabBar的高度
  final double tabHeights;

  /// 上拉加载更多的结果
  final HSYSliverRefreshResult reqResult;

  /// 占位图图片信息
  final Map<HSYSliverRefreshResult, String> images;

  /// 占位文字信息
  final Map<HSYSliverRefreshResult, String> texts;

  HSYCustomSliverEmpty({
    this.tabHeights = kToolbarHeight,
    this.reqResult = HSYSliverRefreshResult.NotData,
    this.images = const {
      HSYSliverRefreshResult.Failure: 'assets/img_no_network.png',
      HSYSliverRefreshResult.NotData: 'assets/img_no_records.png',
    },
    this.texts = const {
      HSYSliverRefreshResult.Failure: 'Request Failure',
      HSYSliverRefreshResult.NotData: 'No Records',
    },
  });

  @override
  Widget build(BuildContext context) {
    final String text = this.texts[this.reqResult];
    final String image = this.images[this.reqResult];
    final num contentHeights = HSYCustomSliverEmpty.contentHeights(
      context,
      this.tabHeights,
    );
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 16.0)
          .copyWith(top: ((contentHeights - 190.0) / 2.0)),
      child: ((image ?? '').isEmpty
          ? Container(
              height: contentHeights,
            )
          : Column(
              children: [
                Image.asset(
                  image,
                  width: 100.0,
                  height: 100.0,
                  package: 'custom_sliver',
                ),
                Container(
                  margin: EdgeInsets.only(top: 35.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                )
              ],
            )),
    );
  }

  static num contentHeights(
    BuildContext context, [
    num tabHeights = kToolbarHeight,
  ]) {
    return MediaQuery.of(context).size.height -
        ((MediaQuery.of(context).padding.top * 2.0) +
            kToolbarHeight +
            tabHeights);
  }
}
