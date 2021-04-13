import 'package:custom_tab_bar/custom_tab_configs.dart';
import 'package:flutter/material.dart';

class HSYCustomSliverConfigs {
  /// 自定义TabBar组件的数据信息
  final HSYCustomTabBarConfigs tabBarConfigs;

  /// 组合组件的pages数据
  final List<HSYCustomSliverDatas> tabPageDatas;

  HSYCustomSliverConfigs({
    @required this.tabBarConfigs,
    @required this.tabPageDatas,
  }) : assert(
          tabBarConfigs.tabBarItemConfigs.length == tabPageDatas.length,
          '组合组件的数据源中，page数据个数必须和tab的item数据个数保持一致',
        );

  List<HSYCustomSliverDatas> get pagesDatas {
    return (this.tabPageDatas ?? []);
  }

  void updateSliverDatas(
    int pages,
    List<dynamic> news, [
    bool isLoading = false,
  ]) {
    HSYCustomSliverDatas newDatas = HSYCustomSliverDatas.defaults(news);
    if (isLoading) {
      final HSYCustomSliverDatas sliverDatas = this.pagesDatas[pages];
      newDatas.pageDatas.forEach((element) {
        sliverDatas.pageDatas.add(element);
      });
      newDatas = sliverDatas;
    }
    if (newDatas.pageDatas.isNotEmpty) {
      this.tabPageDatas.replaceRange(
        pages,
        (pages + 1),
        [newDatas],
      );
    }
  }
}

class HSYCustomSliverDatas {
  /// 每个page所对应的datas
  final List<dynamic> datas;

  HSYCustomSliverDatas({
    @required this.datas,
  });

  factory HSYCustomSliverDatas.defaults([
    List<dynamic> datas = const [],
  ]) {
    return HSYCustomSliverDatas(datas: datas);
  }

  List<dynamic> get pageDatas {
    return (this.datas ?? []);
  }
}
