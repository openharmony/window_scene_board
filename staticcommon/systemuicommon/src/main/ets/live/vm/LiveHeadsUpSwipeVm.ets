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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveItemBaseVm } from './LiveBaseVm';
import { LiveNotification } from '../model/LiveNotification';
import { LiveVmInjector } from '../LiveVmInjector';
import { ILiveHeadsUpSwipeVm } from '../interface/ILiveHeadsUpSwipeVm';
import { AnimationBase } from '../../animation/AnimationBase';
import { NotificationDataManager } from '../../manager/NotificationDataManager';
import { DeleteNotificationMaintenance } from '../../maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '../../maintenance/StatisticsConstants';
import { InnerEventUtil } from '../../utils/InnerEventUtil';
import { BannerSlideUpEvent } from '../../event/NotificationEvent'
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'LiveHeadsUpSwipeVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 向上快滑阻尼系数，竖移值*系数
 */
const VERTICAL_FAST_SWIPE_DAMP = 0.25;

/**
 * 向上慢滑阻尼系数，竖移值*系数
 */
const VERTICAL_SLOW_SWIPE_DAMP = 0.5;

/**
 * 向上滑动速度阈值
 */
const VERTICAL_VELOCITY = 300;

/**
 * 向下竖滑阻尼系数，竖移值*系数
 */
const SWIPE_DAMP_DOWN = 0.15;

/**
 * 竖滑往下的最大位移
 */
const BANNER_DOWN_MAX_OFFSET = 160;

/**
 * 横滑阻尼系数，竖移值*系数
 */
const HORIZONTAL_SWIPE_DAMP = 0.4;

/**
 * 横幅上滑阈值隐藏
 */
const HIDE_HEADS_UP_DISTANCE = 25;

@ObservedV2
export class LiveHeadsUpSwipeVm extends LiveItemBaseVm implements ILiveHeadsUpSwipeVm {
  protected headVm = this.vmInjector.getLiveHeadsUpVm();
  /**
   * 开始滑动时的横向偏移量
   */
  protected startOffsetX: number = 0;

  /**
   * 开始滑动时的纵向偏移量
   */
  protected startOffsetY: number = 0;

  /**
   * 是否从左向右横滑
   */
  protected isLeftToRight: boolean = false;

  /**
   * 是否从下往上竖滑
   */
  protected isBottomToTop: boolean = false;

  /**
   * 是否正在触摸
   */
  @Trace public isTouching: boolean = false;

  public verticalDamp: number = VERTICAL_SLOW_SWIPE_DAMP;

  protected animation = new AnimationBase(AnimationBase.NAMES.LIVE_HEAD_UP_SWIPE_ANIMATION, true);

  constructor(vmInjector: LiveVmInjector, live: LiveNotification) {
    super(vmInjector, live);
  }

  public onHorizontalPanStart = (event: GestureEvent): void => {
    log.showInfo(`onHorizontalPanStart for ${this.live.hashCode}, event.offsetX: ${event.offsetX}`);
    this.isTouching = true;
    this.startOffsetX = this.headVm.contentOffsetX;
  };

  public onHorizontalPanUpdate = (event: GestureEvent): void => {
    log.showInfo(`onHorizontalPanUpdate for ${this.live.hashCode}, event.offsetX: ${event.offsetX}`);
    this.updateHorizontal(this.startOffsetX + event.offsetX, false);
  };

  public onHorizontalPanEnd = async (event: GestureEvent): Promise<void> => {
    log.showInfo(`onHorizontalPanEnd for ${this.live.hashCode}, event.offsetX: ${event.offsetX}`);

    this.isLeftToRight = event.offsetX > 0;
    this.isTouching = false;
    this.stopHorizontal(event.offsetX);
    const headUpVm = this.vmInjector.getLiveHeadsUpVm();
    if (headUpVm.isTimeout) {
      if (this.live.isInstantBanner()) {
        DeleteNotificationMaintenance.addNtfMap([this.live],
          DeleteNotificationType.INSTANT_BANNER_SWIPE_TIMEOUT_DELETE, false);
        NotificationDataManager.instance.removeLiveView([this.live]);
      } else {
        await headUpVm.hide(this.live);
      }
    }
  };

  public onHorizontalPanCancel = (): void => {
    this.isTouching = false;
    this.stopHorizontal(0);
  };

  public onVerticalPanStart = (event: GestureEvent): void => {
    log.showInfo(`onVerticalPanStart for ${this.live.hashCode}, event.offsetX: ${event.offsetY}, velocity
      ${event.velocity}`);
    if (event.velocity > VERTICAL_VELOCITY) {
      this.verticalDamp = VERTICAL_FAST_SWIPE_DAMP;
    } else {
      this.verticalDamp = VERTICAL_SLOW_SWIPE_DAMP;
    }
    this.isTouching = true;
    this.startOffsetY = this.headVm.contentOffsetY;
  };

  public onVerticalPanUpdate = (event: GestureEvent): void => {
    log.showInfo(`onVerticalPanUpdate for ${this.live.hashCode}, event.offsetY: ${event.offsetY}`);
    this.updateVertical(this.startOffsetY + event.offsetY, false);
  };

  public onVerticalPanEnd = async (event: GestureEvent): Promise<void> => {
    log.showInfo(`onVerticalPanEnd for ${this.live.hashCode}, event.offsetY: ${event.offsetY}`);

    this.isTouching = false;
    this.isBottomToTop = event.offsetY < 0;
    this.stopSwipeVertical(event.offsetY);

    const headUpVm = this.vmInjector.getLiveHeadsUpVm();
    if (headUpVm.isTimeout) {
      log.showInfo('Hide liveHeadsUp because time out');
      if (this.live.isInstantBanner()) {
        DeleteNotificationMaintenance.addNtfMap([this.live],
          DeleteNotificationType.INSTANT_BANNER_SWIPE_TIMEOUT_DELETE, false);
        NotificationDataManager.instance.removeLiveView([this.live]);
      } else {
        await headUpVm.hide(this.live);
      }
    }
    // 超过上划阈值,只要是横幅都默认可以被上划收起或者删除
    if (event.offsetY < -HIDE_HEADS_UP_DISTANCE) {
      // 上滑打断铃声和振动
      InnerEventUtil.post(BannerSlideUpEvent, new BannerSlideUpEvent());
      log.showInfo('Hide liveHeadsUp because offsetY is exceed');
      if (this.live.isInstantBanner()) {
        // 先隐藏横幅后删除消息
        await this.vmInjector.getLiveHeadsUpVm().hide(this.live);
        DeleteNotificationMaintenance.addNtfMap([this.live],
          DeleteNotificationType.INSTANT_BANNER_SWIPE_UP_DELETE, false);
        NotificationDataManager.instance.removeLiveView([this.live]);
      } else {
        await headUpVm.hide(this.live);
        headUpVm.clearTimeout(this.live);
      }
    }
  };

  public onVerticalPanCancel = (): void => {
    log.showInfo(`onVerticalPanCancel for ${this.live.hashCode}`);
    this.isTouching = false;
    this.stopSwipeVertical(0);
  };

  private async updateHorizontal(endOffsetX: number, animation: boolean): Promise<void> {
    await this.updateSwipeHorizontalOffset(endOffsetX, animation);
  }

  private async updateVertical(offsetTop: number, animation: boolean): Promise<void> {
    this.isBottomToTop = offsetTop < 0;
    await this.updateSwipeVerticalOffset(offsetTop, animation);
  }

  public async updateSwipeHorizontalOffset(offsetLeft: number, animation: boolean): Promise<void> {
    if (this.headVm.contentOffsetX === offsetLeft) {
      return;
    }
    log.showInfo(`updateSwipeOffset ${this.live?.hashCode} from ${this.headVm.contentOffsetX} to ${offsetLeft}` +
      `, animation: ${animation}`);
    if (animation) {
      await this.animation.executeAnimation([{
        curve: AnimationBase.CURVES.BANNER_SWIPE_CURVE,
        event: () => {
          this.headVm.contentOffsetX = offsetLeft * HORIZONTAL_SWIPE_DAMP;
        }
      }], `UpdateSwipeOffset:${this.live.hashCode}`);
    } else {
      this.headVm.contentOffsetX = offsetLeft * HORIZONTAL_SWIPE_DAMP;
    }
  }

  public async updateSwipeVerticalOffset(offsetTop: number, animation: boolean): Promise<void> {
    if (this.headVm.contentOffsetY === offsetTop) {
      return;
    }
    log.showInfo(`updateSwipeVerticalOffset ${this.live?.hashCode} from ${this.headVm.contentOffsetY} to ${offsetTop}` +
      `, animation: ${animation},  isBottomToTop ${this.isBottomToTop} verticalDamp ${this.verticalDamp}`);
    const damp = this.isBottomToTop ? this.verticalDamp : SWIPE_DAMP_DOWN;
    if (animation) {
      await this.animation.executeAnimation([{
        curve: AnimationBase.CURVES.BANNER_SWIPE_CURVE,
        event: () => {
          this.headVm.contentOffsetY = offsetTop * damp;

        }
      }], `updateSwipeVerticalOffset:${this.live.hashCode}`);
    } else {
      this.headVm.contentOffsetY = offsetTop * damp;
    }
  }

  private stopHorizontal(offsetX: number): void {
    log.showInfo(`Stop Horizontal ${this.live.hashCode} offsetX: ${offsetX}`);
    const isLeftToRight = offsetX > 0;
    let endOffsetX = 0;

    if (isLeftToRight) {
      // 右滑超过临界值
      if (offsetX >= HIDE_HEADS_UP_DISTANCE) {
        endOffsetX = 0;
      } else {
        endOffsetX = this.startOffsetX;
      }
    } else {
      // 左滑超过临界值
      if (offsetX <= -HIDE_HEADS_UP_DISTANCE) {
      } else {
        endOffsetX = this.startOffsetX;
      }
    }
    this.updateHorizontal(endOffsetX, true);
  }

  private stopSwipeVertical(offsetY: number): void {
    log.showInfo(`Stop swipe vertical ${this.live.hashCode} offsetY: ${offsetY}`);
    const isBottomToTop = offsetY < 0;
    let endOffsetY = 0;

    if (isBottomToTop) {
      // 上滑超过临界值
      if (Math.abs(offsetY) >= HIDE_HEADS_UP_DISTANCE) {
        endOffsetY = 0;
      } else {
        endOffsetY = this.startOffsetY;
      }
    } else {
      // 下滑超过临界值
      if (offsetY > BANNER_DOWN_MAX_OFFSET) {
        endOffsetY = this.startOffsetY;
      }
    }
    this.updateVertical(endOffsetY, true);
  }
}