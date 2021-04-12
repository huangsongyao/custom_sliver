import 'package:custom_sliver/custom_sliver_enum.dart';
import 'package:flutter/material.dart';

class HSYCustomSliverHeaderRefresh extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class HSYCustomSliverFooterRefresh extends StatelessWidget {
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
  final HSYSliverRefreshResult reqResult;

  HSYCustomSliverEmpty({
    this.reqResult = HSYSliverRefreshResult.NotData,
  });

  @override
  Widget build(BuildContext context) {
    final String image = {
      HSYSliverRefreshResult.Failure: 'assets/img_no_network.png',
      HSYSliverRefreshResult.NotData: 'assets/img_no_records.png',
    }[this.reqResult];
    final String text = {
      HSYSliverRefreshResult.Failure: 'Request Failure',
      HSYSliverRefreshResult.NotData: 'No Records',
    }[this.reqResult];
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      child: ((image ?? '').isEmpty
          ? Container(
              height: MediaQuery.of(context).size.height,
            )
          : Column(
              children: [
                Image.asset(
                  image,
                  width: 100.0,
                  height: 100.0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 35.0),
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
}
