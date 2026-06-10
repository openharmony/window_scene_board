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
import { CommonUtils } from '@ohos/basicutils';
import { CustomPromise } from '@ohos/frameworkwrapper';

// 通知条目大小预切换监听
export type OnItemPreSizeChange = (paras: NotificationAnimationParas, isForceAnim?: boolean) => void;

/**
 * 通知动效配置参数
 *
 * @since 2023-09-03
 */
@Observed
export class NotificationAnimationParas {
  private itemPreSizeChange?: OnItemPreSizeChange;
  /**
   * 记录通知列表item X轴位移
   */
  public ntfItemTranslateX: number;
  public clearAnimOpacity: number;
  public clearAnimScale: number;

  /**
   * 通知列表item进入、退出时x轴旋转角度
   */
  public ntfItemRotateAngels: number;

  /**
   * 记录通知列表item Y轴位移
   */
  public ntfItemTranslateY: number;

  public ntfItemRotateCenterY: string | number;

  public ntfItemZIndex: number = 0; // 条目层级

  public itemScaleCenterY?: number; // 纵轴缩放中心点

  public ntfItemClipHeight: number = -1; // 条目裁切高度

  public ntfItemClipOffsetY: number = 0; // 条目裁切竖向偏移

  public isGroupExpanded: boolean = false; // 组通知是否展开状态

  private isItemTouchEnable?: boolean; // 通知条目是否开启触摸事件

  private clipAnim?: AnimateParam; // 更新切割时动效曲线

  private clipAnimWait?: CustomPromise<void>; // 切割动效等待

  private isDisableEffect?: boolean; // 是否临时关闭模糊效果

  public realHeight?: number | undefined;

  public templateTranslateY: number = 0;

  public isTopItem: boolean = false; // 是否是顶部通知

  public isBottomItem: boolean = false; // 是否是底部通知

  public clipArea: Area | undefined = undefined;

  constructor(transX: number, transY: number, opacity: number, scale: number, rotate: number) {
    this.ntfItemTranslateX = transX;
    this.ntfItemTranslateY = transY;
    this.clearAnimOpacity = opacity;
    this.clearAnimScale = scale;
    this.ntfItemRotateAngels = rotate;
    this.ntfItemRotateCenterY = '0%';
  }

  reset(transY: number = 0) {
    this.ntfItemTranslateX = 0;
    this.ntfItemTranslateY = transY;
    this.clearAnimOpacity = 1;
    this.clearAnimScale = 1;
    this.ntfItemRotateAngels = 0;
    this.ntfItemRotateCenterY = '0%';
    this.ntfItemZIndex = 0;
    this.ntfItemClipHeight = -1;
    this.ntfItemClipOffsetY = 0;
    this.isGroupExpanded = false;
  }

  public setItemPreSizeChange(listener?: OnItemPreSizeChange): NotificationAnimationParas { // 条目大小预切换监听
    this.itemPreSizeChange = listener;
    return this;
  }

  public updateItemPresSize(isForceAnim?: boolean): NotificationAnimationParas { // 条目大小预切换
    this.itemPreSizeChange?.(this, isForceAnim);
    return this;
  }

  public isTempDisableEffect(): boolean { // 关闭模糊
    return this.isDisableEffect ?? false;
  }

  public isItemEnable(): boolean { // 条目可触摸状态
    if (CommonUtils.isInvalid(this.isItemTouchEnable)) { // 无赋能时，用alpha替代
      let alpha = this.clearAnimOpacity ?? 1;
      // 阈值要保证用户明显感知卡片堆叠，避免堆叠不显著时用户无法点击卡片而造成误解
      return alpha >= 0.8;
    }
    return this.isItemTouchEnable as boolean;
  }

  public getClipAnim(): AnimateParam | undefined { // 裁切动效
    return this.clipAnim;
  }

  public updateGroupExpanded(isExpanded: boolean): NotificationAnimationParas { // 更新组通知状态
    this.isGroupExpanded = isExpanded;
    return this;
  }

  public updateItemTouchEnable(isEnable?: boolean): NotificationAnimationParas { // 更新可触摸状态
    this.isItemTouchEnable = isEnable;
    return this;
  }

  public updateTranX(tranX: number): NotificationAnimationParas { // 更新横向位移
    this.ntfItemTranslateX = tranX;
    return this;
  }

  public updateTranY(tranY: number): NotificationAnimationParas { // 更新竖向位移
    this.ntfItemTranslateY = tranY;
    return this;
  }

  public updateAlpha(alpha: number): NotificationAnimationParas { // 更新透明度
    this.clearAnimOpacity = alpha;
    return this;
  }

  public updateScale(scale: number): NotificationAnimationParas { // 更新缩放
    this.clearAnimScale = scale;
    return this;
  }

  public updateScaleCenterY(centerY?: number): NotificationAnimationParas { // 更新缩放纵轴中心点
    this.itemScaleCenterY = centerY;
    return this;
  }

  public updateClipHeight(clipHeight: number): NotificationAnimationParas { // 更新裁切高度
    this.ntfItemClipHeight = clipHeight;
    return this;
  }

  public updateClipOffsetY(clipOffsetY: number): NotificationAnimationParas { // 更新裁切纵向偏移
    this.ntfItemClipOffsetY = clipOffsetY;
    return this;
  }

  public updateClipAnim(anim?: AnimateParam): NotificationAnimationParas { // 更新切割动效参数
    this.clipAnim = anim;
    return this;
  }

  public updateZIndex(zIndex: number): NotificationAnimationParas { // 更新层级
    this.ntfItemZIndex = zIndex;
    return this;
  }

  public setClipAnimWait(): NotificationAnimationParas { // 标记裁切动效等待
    if (!this.clipAnimWait) {
      this.clipAnimWait = new CustomPromise();
    }
    return this;
  }

  public async startClipAnimWait(): Promise<void> { // 开启裁切动效等待
    if (this.clipAnimWait) {
      await this.clipAnimWait;
    }
  }

  public resolveClipAnimWait(): void { // 裁切动效放行
    setTimeout(() => {
      if (this.clipAnimWait) {
        this.clipAnimWait.resolve();
        this.clipAnimWait = undefined;
      }
    });
  }

  public updateDisableEffect(disable?: boolean): NotificationAnimationParas { // 临时关闭模糊
    this.isDisableEffect = disable;
    return this;
  }

  /**
   * 是否处理堆叠态
   *
   * @returns
   */
  public isStacking(): boolean {
    return this.clearAnimOpacity < 1;
  }

  public updateClipArea(clipArea: Area): void {
    this.clipArea = clipArea;
  }
}