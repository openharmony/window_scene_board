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
import { PluginInfo } from '@ohos/frameworkwrapper';

export interface IStatusBarIconVm {
  /**
   * 图标基本信息
   */
  pluginInfo: PluginInfo | undefined;

  pluginName: string;

  /**
   * 组件ID
   */
  id: string;

  /**
   * 图标开关控制图标显隐
   */
  isOnTheTree: boolean;

  position: LocalizedEdges | undefined;

  /**
   * 图标marginEnd，用于跨孔
   */
  marginEnd: number;
  /**
   * 图标marginStart，用于通知图标的布局适配
   */
  marginStart: number;

  /**
   * 实际显示宽度，经过布局后获取到的值
   */
  width: number;

  /**
   * 预设显示尺寸，用来调整图标占位
   */
  showSize?: SizeOptions;

  /**
   * 图标延迟显示的透明度
   */
  iconDelayShowOpacity: number;

  /**
   * 受基础布局影响的透明度
   */
  baseLayoutOpacity: number;
  /**
   * 受胶囊影响的透明度
   */
  capsuleLayoutOpacity: number
  /**
   * x轴方向缩放比例
   */
  scaleX: number;
  /**
   * y轴方向缩放比例
   */
  scaleY: number;
  /**
   * 图标偏移
   */
  offset: number;
  /**
   * 图标纵向偏移
   */
  offsetY: number;
  /**
   * 组件像素级取整方式，系统图标需配置，避免onSizeChange回调为小数；胶囊不配置，避免胶囊圆饼被截断
   */
  pixelRound: PixelRoundPolicy | undefined;
  /**
   * 分隔符透明度
   */
  separatorOpacity: number;

  get getIconScale(): ScaleOptions;

  get getVisible(): Visibility;

  get getAnchor(): AlignRuleOption;

  getIsOnTheTree(): boolean;

  init(pluginInfo: PluginInfo): void;

  unInit(): void;

  getBuilder(): WrappedBuilder<[PluginInfo]>;

  getOpacity(isLeft: boolean): number;
}