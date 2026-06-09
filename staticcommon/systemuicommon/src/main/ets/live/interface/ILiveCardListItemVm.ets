/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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
import type { LiveNotification } from '../model/LiveNotification';

/**
 * 实况卡片列表项VM
 */
export interface ILiveCardListItemVm {
  /**
   * 实况数据
   */
  live: LiveNotification;
  /**
   * ZIndex
   */
  zIndex: number;
  /**
   * 卡片尺寸
   */
  cardWidth: number;
  /**
   * 卡片缩放
   */
  cardScale?: ScaleOptions;
  /**
   * 卡片下边距
   */
  marginBottom: number;
  /**
   * 列表项组件ID
   */
  componentId: string;
  /**
   * 容器尺寸，动画过程中裁剪内容使用
   */
  containerSize: SizeOptions;
  /**
   * 容器透明度
   */
  containerOpacity: number;
  /**
   * 容器圆角参数
   */
  containerBorderRadius: Length;
  /**
   * 内容尺寸
   */
  contentSize?: SizeOptions;
  /**
   * 内容对齐方式
   */
  contentAlign: Alignment;
  /**
   * 左边偏移量
   */
  containerOffsetX: number;
  /**
   * 上边偏移量
   */
  containerOffsetY: number;
  /**
   * 内容透明度
   */
  contentOpacity: number;
  /**
   * 内容模糊
   */
  contentBlur: number;
  /**
   * 卡片外框缩放比例
   */
  containerScale?: ScaleOptions;
  /**
   * 卡片内容缩放比例
   */
  contentScale?: ScaleOptions;
  /**
   * 渐变主题色
   */
  cardGradientColor: Array<[ResourceColor, number]>;
  /**
   * 渐变透明度
   */
  cardGradientOpacity: number;
  /**
   * 卡片背板透明度
   */
  cardBackOpacity: number;
  /**
   * 卡片阴影
   */
  cardShadow?: ShadowStyle;
  /**
   * 内容圆角参数
   */
  contentBorderRadius: number;

  /**
   * 入场/出场动效参数
   */
  transition?: TransitionEffect;

  /**
   * 手势
   */
  gesture: GestureGroupHandler;

  /**
   * 更新左右横滑动效
   * @param offsetLeft 滑动目标位置
   * @param animation 是否需要动画
   */
  updateSwipeOffset(offsetLeft: number, animation: boolean): Promise<void>;

  /**
   * 做滑动删除动效
   */
  doRemoveAnimation(): Promise<void>;

  /**
   * touch卡片做缩放动效
   */
  onTouchEvent(event: TouchEvent): void;

  /**
   * 点击卡片处理
   */
  onClick(): void;

  /**
   * 处理头像点击事件
   *
   * @param groupKey
   */
  onIconClick?(groupKey: string): void;

  /**
   * 卡片尺寸变化事件
   * @param size
   */
  onSizeChange?(size: SizeOptions): void;
}