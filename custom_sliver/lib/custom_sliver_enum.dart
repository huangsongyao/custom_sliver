import 'package:flutter/material.dart';

enum HYSCustomSliverScrollStatus {
  InSliverTops, // 组合组件滚动到顶部
  InSlivers, // 组合组件滚动区域为 > 0 && < 悬浮组件的位置
  InSliverBottoms, // 组合组件滚动到悬浮组件的位置
}

enum HSYSliverRefreshResult {
  Failure, // 上拉加载更多或者下拉刷新请求---失败
  Completed, // 上拉加载更多或者下拉刷新请求---完成
  NotData, // 上拉加载更多或者下拉刷新请求---没有更多数据
}
