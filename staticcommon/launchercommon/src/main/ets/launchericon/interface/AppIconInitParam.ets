/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { AppIconShadowData } from '../../bean/AppIconShadowData';
import { AppItemInfo } from '../../TsIndex';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconBackplaneVm } from '../viewmodel/AppIconBackplaneVm';
import { AppIconBadgeVm } from '../viewmodel/AppIconBadgeVm';
import { AppIconData } from '../viewmodel/AppIconData';
import { AppIconDisableMaskVm } from '../viewmodel/AppIconDisableMaskVm';
import { AppIconDynamicShadowData } from '../viewmodel/AppIconDynamicShadowData';
import { AppIconMenuVm } from '../viewmodel/AppIconMenuVm';
import { AppNameVm } from '../viewmodel/AppNameVm';
import { AppIconContainerModifier } from './AppIconContainerModifier';
import { AppIconDefaultModifier } from './AppIconDefaultModifier';

export interface AppIconInitParam {
  // Item基本信息
  itemInfo: AppItemInfo;
  // iconData, 状态变量
  iconData: AppIconData;
  // icon 配置信息
  iconConfig: AppIconConfig;
  // 获取IconSize
  iconSizeCb: () => number;
  // 是否在拖拽状态
  isInDragCb: () => boolean;
  // 是否显示取消对话框
  isShowCancelDialogCb: (isShow: boolean) => void;
  // UIContext信息
  uiContextCb: UIContext;
  // 长按浮起截图
  longPressImageBuilder: CustomBuilder;
  // 拖拽截图Builder
  dragIconBuilder: CustomBuilder;
  // 长按菜单Builder
  longPressMenuBuilder: CustomBuilder;
  // 右键菜单Builder
  rightClickMenuBuilder: CustomBuilder;
  // 是否初始化IconId，默认true；组件重用时，不进行初始化
  isInitIconId: boolean;
  // Icon组件Modifier
  iconModifier: AppIconDefaultModifier;
  // Icon Container组件Modifier
  iconContainerModifier: AppIconContainerModifier;
  // appName VM
  appNameVm: AppNameVm;
  // 背板VM
  backplaneVm: AppIconBackplaneVm;
  // 置灰蒙层VM
  disableMaskVm: AppIconDisableMaskVm;
  // 分层图标中间阴影层
  appIconShadowData: AppIconShadowData | undefined;
  // 图标动态阴影
  appIconDynamicShadowData: AppIconDynamicShadowData | undefined;
  // 角标VM
  iconBadgeVm: AppIconBadgeVm;
  // 菜单VM
  iconMenuVm: AppIconMenuVm;
};