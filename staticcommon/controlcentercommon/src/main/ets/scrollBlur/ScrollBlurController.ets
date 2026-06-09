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

import uiEffect from '@ohos.graphics.uiEffect';
import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { EvtBus, EventManager } from '@ohos/frameworkwrapper';
import { ScrollBlurViewData } from './ScrollBlurViewData';
import { ScrollBlurEvent } from './ScrollBlurEvent';
import { DISABLE_HEAD_BLUR_EFFECT } from '@ohos/systemuicommon/src/main/ets/template/common/SCBVisualEffectOption';

const TAG = 'ScrollBlurController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);

const HEAD_BLUR_RADIUS: number = 40;

/**
 * 列表头部模糊控制器
 * 可指定头部区域和列表起始坐标，当列表内容滚动到指定头部区域时，头部区域会有背景模糊效果
 */
export class ScrollBlurController {
  private scroller: Scroller;
  private blurArea: RectInfo = new RectInfo();
  private listStartOffset: number;

  // 模糊效果总控制开关，该开关如果关闭，所有的判断模糊是否应该生效的逻辑将不起作用，开关默认开启
  private isScrollBlurEnabled: boolean = true;
  private isScrollBlurActive: boolean = false; // 新建本地变量，避免滑动过程中频繁读取observed对象导致额外开销
  private scrollBlurViewData: ScrollBlurViewData = new ScrollBlurViewData(); // 直接控制模糊效果是否生效的变量
  private eventMgr: EventManager = EvtBus.createEventManager();

  constructor(scroller: Scroller, listStartOffset: number) {
    this.isScrollBlurEnabled = !DISABLE_HEAD_BLUR_EFFECT;
    this.scroller = scroller;
    this.listStartOffset = listStartOffset;
    this.register();
  }

  onReceiveScrollBlurEvent(event: number) {
    switch (event) {
      case 0:
        this.inactiveScrollerBlur();
        break;
      case 1:
        this.onListScrollWithBlur();
        break;
      default:
        break;
    }
  }

  init(blurArea: RectInfo, scrollBlurViewData: ScrollBlurViewData): void {
    this.blurArea = blurArea;
    this.scrollBlurViewData = scrollBlurViewData;
  }

  public getListStartOffset(): number {
    return this.listStartOffset;
  }

  public getBlurArea(): RectInfo {
    return this.blurArea;
  }

  public getBlurActiveState(): boolean {
    return !this.isScrollBlurEnabled ? false : this.scrollBlurViewData.getBlurActive();
  }

  public activeScrollerBlur(): void {
    if (this.isScrollBlurActive) {
      return;
    }
    if (!this.isScrollBlurEnabled) {
      log.showInfo('scroll blur effect is disable');
      return;
    }
    log.showInfo('activeScrollerBlur');
    this.scrollBlurViewData.setBlurActive(true);
    this.isScrollBlurActive = true;
  }

  public activeScrollerBlurAnimate(): void {
    if (this.isScrollBlurActive) {
      return;
    }
    if (!this.isScrollBlurEnabled) {
      return;
    }
    animateTo({
      duration: 300
    }, () => {
      this.scrollBlurViewData.setBlurActive(true);
      this.isScrollBlurActive = true;
    })
  }

  public inactiveScrollerBlur(): void {
    if (!this.isScrollBlurActive) {
      return;
    }
    log.showInfo('inactiveScrollerBlur');
    this.scrollBlurViewData.setBlurActive(false);
    this.isScrollBlurActive = false;
  }

  public getScrollBlurEnableState(): boolean {
    return this.isScrollBlurEnabled;
  }

  public enableScrollBlur(): void {
    if (DISABLE_HEAD_BLUR_EFFECT) {
      log.showInfo('product not support this visual effect');
      return;
    }
    if (this.isScrollBlurEnabled === true) {
      return;
    }
    this.isScrollBlurEnabled = true;
  }

  public disableScrollBlur(): void {
    if (!this.isScrollBlurEnabled) {
      return;
    }
    this.inactiveScrollerBlur();
    this.isScrollBlurEnabled = false;
  }

  public resetScroll(): void {
    log.showInfo('resetScroll');
    this.scroller.scrollTo({xOffset: 0, yOffset: -this.listStartOffset});
    this.inactiveScrollerBlur();
  }

  public scrollToWithBlur(y: number): void {
    this.scroller.scrollTo({xOffset: 0, yOffset: y});
    if (!this.isScrollBlurEnabled) {
      log.showInfo('scroll blur effect is disable');
      return;
    }
    log.showInfo('scrollToWithBlur');
    this.onScrollWithBlur();
  }

  public onListScrollWithBlur(): void {
    if (Math.round(this.scroller.getItemRect(0)?.y) < (this.blurArea.height as number)) {
      this.activeScrollerBlur();
    } else if (Math.round(this.scroller.getItemRect(0)?.y) >= (this.blurArea.height as number)) {
      this.inactiveScrollerBlur();
    }
  }

  public onListScrollWithBlurAnimate(): void {
    if (this.scroller.getItemRect(0) && Math.round(this.scroller.getItemRect(0)?.y) <
      (this.blurArea.height as number)) {
      this.activeScrollerBlurAnimate();
    } else {
      this.inactiveScrollerBlur();
    }
  }

  public onScrollWithBlur(): void {
    if (Math.round(this.scroller.currentOffset()?.yOffset) > (this.listStartOffset - (this.blurArea.height ?? 0))) {
      this.activeScrollerBlur();
    } else if (Math.round(this.scroller.currentOffset()?.yOffset) <=
      (this.listStartOffset - (this.blurArea.height ?? 0))) {
      this.inactiveScrollerBlur();
    }
  }

  /**
   * 设置渐变模糊合成滤镜效果
   *
   * @param filter Filter实例
   * @returns filter | undefined 挂载了模糊效果的Filter实例，异常时返回undefined
   */
  public getBlurCompositingFilter(filter: uiEffect.Filter): Filter | undefined {
    try {
      filter = uiEffect.createFilter();
      return filter.radiusGradientBlur(HEAD_BLUR_RADIUS, {
        fractionStops: [[1, 0], [0, 1]],
        direction: GradientDirection.Bottom
      });
    } catch (e) {
      log.showError(`get HeadBlurArea radiusGradientBlur failed, err: ${e}`);
      return undefined;
    }
  }

  public unregister() {
    this.eventMgr.offAll();
  }

  public register() {
    this.eventMgr.on(ScrollBlurEvent, (event: ScrollBlurEvent): void => {
      if (event?.command == null) {
        return;
      }
      this.onReceiveScrollBlurEvent(event.command)
    })
  }

  /**
   * 滚动条到头部Index0，刷新List前一帧变化（List加载的时候会默认取前一帧的位置数据，位置计算不准）
   */
  public setScrollToIndex(): void {
    this.scroller.scrollToIndex(0);
    this.inactiveScrollerBlur();
  }
}