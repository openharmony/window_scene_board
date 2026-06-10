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
import { CapsuleShowType } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';

/**
 * 实况胶囊跑马灯VM
 */
export interface ILiveCapsuleMarqueeVm {
  /**
   * 实况
   */
  live: LiveNotification;
  /**
   * 文本的宽度，单位vp
   */
  textWidth: number;
  /**
   * 扩展文本的宽度，单位vp
   */
  extendTextWidth: number;
  /**
   * 主文本字体大小
   */
  textSize: Length;
  /**
   * 副文本字体大小
   */
  extendTextSize: Length;
  /**
   * 胶囊透明度
   */
  opacity: number;
  /**
   * 胶囊横向缩放
   */
  scaleX: number;
  /**
   * 胶囊纵向缩放
   */
  scaleY: number;
  /**
   * 胶囊文本横向缩放中心
   */
  centerX: number | string;
  /**
   * 胶囊文本纵向缩放中心
   */
  centerY: number | string;
  /**
   * 胶囊文本模糊
   */
  radius: number;
  /**
   * 文本颜色
   */
  textColor: ResourceColor;
  /**
   * 文本是否超出了最大宽度
   */
  hasScroll: boolean;

  /**
   * 副文本是否超出了最大宽度
   */
  hasExtendScroll: boolean;
  /**
   * 是否在跑动中
   * 跑动结束后需要完成一段还原动效
   */
  isRunning: boolean;
  /**
   * 是否扩展文本在跑动中
   * 跑动结束后需要完成一段还原动效
   */
  isExtendRunning: boolean;
  /**
   * 经过布局计算后的文本宽度
   */
  fixedTextWidth: number;
  /**
   * 经过布局计算后的拓展文本宽度
   */
  fixedExtendTextWidth: number;
  /**
   * 经过布局计算后的主文本字体大小
   */
  fixedTextSize: Length;
  /**
   * 经过布局计算后的副文本字体大小
   */
  fixedExtendTextSize: Length;
  /**
   * 经过布局计算后是否拼接主副文本
   */
  fixedIsSplicing: boolean;
  /**
   * 是否拼接主副文本
   */
  isSplicing: boolean;
  /**
   * 胶囊文本横向偏移量，单位vp
   */
  offsetX: number;
  /**
   * 经过布局计算后胶囊文本横向偏移量，单位vp
   */
  fixedOffsetX: number;
  /**
   * 跑马灯在更新过程中的动效偏移
   */
  needFixOffsetX: number;
  /**
   * 胶囊是否启动跑马灯
   */
  isMarqueeEnabled: boolean;
  /**
   * 胶囊经过计算后是否启动跑马灯
   */
  fixedIsMarqueeEnabled: boolean;
  /**
   * 胶囊是否启动跑马灯
   */
  isExtendTextMarqueeEnabled: boolean;
  /**
   * 胶囊经过计算后是否启动跑马灯
   */
  fixedIsExtendTextMarqueeEnabled: boolean;
  /**
   * 跑马灯策略
   */
  marqueeStrategy: MarqueeUpdateStrategy;
  /**
   * 拓展态是否显示
   */
  isExtendShow: boolean;
  /**
   * 是否创建赛事比分文本
   */
  isBuildScoreText: boolean;
  /*
   * 是否隐藏实况内容
   */
  isHideContent: boolean;

  /**
   * 文本的内容
   */
  getText(liveNotification?: LiveNotification, capsuleShowType?: CapsuleShowType, isSplicing?: boolean): string;

  /**
   * 获取扩展文本
   * @returns 扩展文本
   */
  getExtendText(liveNotification?: LiveNotification, capsuleShowType?: CapsuleShowType): string;

  /**
   * 获取主文本
   */
  getMainText(liveNotification?: LiveNotification): string;

  /**
   * 获取无障碍字符串
   */
  getAccessibilityText(isExtend: boolean): string;

  /**
   * 更新跑马灯文字属性
   */
  updateUIProperty(): void;

  /**
   * 是否跑马灯滚动方向镜像
   * @param isExtend 是否拓展组件
   * @returns
   */
  isCapsuleMarqueeRTL(isExtend: boolean): boolean;

  /**
   * 获取组件对齐方式
   * @param isExtend 是否拓展组件
   * @returns
   */
  getCapsuleMarqueeAlign(isExtend: boolean): Alignment;

  /**
   * 是否启用跑马灯
   * @param isExtend 是否拓展组件
   * @returns 是否启用跑马灯
   */
  isEnabled(isExtend: boolean): boolean;

  /**
   * 更新接口
   */
  onUpdate(live: LiveNotification): void;
}