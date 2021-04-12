import 'package:custom_tab_bar/custom_tab_configs.dart';
import 'package:flutter/material.dart';

class HSYCustomSliverConfigs {
  final HSYCustomTabBarConfigs tabBarConfigs;
  final List<HSYCustomSliverDatas> tabBarDatas;

  HSYCustomSliverConfigs({
    @required this.tabBarConfigs,
    @required this.tabBarDatas,
  });

  List<HSYCustomSliverDatas> get tabDatas {
    return (this.tabBarDatas ?? []);
  }
}

class HSYCustomSliverDatas {
  final List<dynamic> tabPageDatas;

  HSYCustomSliverDatas({
    @required this.tabPageDatas,
  });

  List<dynamic> get pageDatas {
    return (this.tabPageDatas ?? []);
  }
}
