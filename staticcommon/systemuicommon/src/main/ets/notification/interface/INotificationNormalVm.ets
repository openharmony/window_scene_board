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

/**
 * 普通通知VM
 */
export interface INotificationNormalVm {
  /**
   * 组件ID
   */
  componentId: string;

  /**
   * 上半区组件ID
   */
  bodyComponentId: string;

  /**
   * 标题组件ID
   */
  titleComponentId: string;

  /**
   * 是否显示按钮
   */
  isShowActionButton: boolean;

  /**
   * 通知卡片时间左边距
   */
  timeMarginStart: LengthMetrics;

  /**
   * 通知卡片时间位移
   */
  timeTranslate?: TranslateOptions;

  /**
   * 内容偏移
   */
  contentTranslate?: TranslateOptions;

  /**
   * 上半区透明度
   */
  bodyOpacity?: number;

  /**
   * 是否为沉浸卡片展开
   */
  isExpandImmersive?: boolean;

  /**
   * 隐式动效
   */
  transition?: TransitionEffect;

  /**
   * 卡片高度
   */
  height: number | undefined;

  /**
   * 裁剪
   */
  clip: boolean;

  /**
   * 是否需要展示置顶标签
   */
  isShowPinTop: boolean;

  /**
   * 是否是紧急通知
   */
  isEmergencyNtf: boolean;

  /**
   * 点击卡片
   */
  onClick: () => void;

  /**
   * 是否使用RenderGroup
   */
  isRenderGroup: boolean;

  /**
   * 通知标题
   */
  ntfTitle: ResourceStr;

  /**
   * 获取通知内容
   */
  ntfContent: string;

  /**
   * 点击热榜内容
   *
   * @returns
   */
  onClickMultiContent: (title: string, index?: number) => void;

  /**
   * 判断热榜内容是否包含emoji表情字符
   *
   * @returns 是否包含emoji表情字符
   */
  hasEmojiInMultiLines: () => boolean;
}