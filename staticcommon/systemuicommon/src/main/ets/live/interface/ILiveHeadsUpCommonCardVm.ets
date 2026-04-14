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

import { LiveNotification } from '../model/LiveNotification';
import { ILiveHeadsUpCardVm } from './ILiveHeadsUpCardVm';

export interface ILiveHeadsUpCommonCardVm extends ILiveHeadsUpCardVm {
  /**
   * 卡片ID
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
   * 黑色背景透明度
   */
  backCardOpacity: number
  /**
   * 卡片尺寸
   */
  cardWidth: Length;
  /**
   * 卡片缩放
   */
  cardScale?: ScaleOptions;
}