# custom_sliver

重定义NestedScrollView+TabBarView的滚动效果列表

# 依赖组件

extended_nested_scroll_view: ^2.0.1
custom_tab_bar: ^0.1.0
pull_to_refresh: ^1.5.7

# 功能概况

1、支持自定义上拉加载更多UI
2、支持自定义下拉刷新的头部UI，默认动画为放缩，暂不支持自定义动画
3、支持自定义TabBar的UI效果，主要集中于对于指示器Indicator的自定义效果
4、支持小组件自定义，也支持使用组合组件自定义
5、暂不支持对于TabBarView的子child-ListView的状态持有
  
# 使用范例

使用请见example/main.dart的范例代码

``` 

HSYCustomSliverTabView(
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
      )

```