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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationSwipeVm } from '../../../viewmodel/NotificationSwipeVm';
import { DeviceInfoVm } from '@ohos/systemuicommon/src/main/ets/vm/DeviceInfoVm';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'NotificationBannerSwipeVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);
/**
 * 左滑删除横幅，扩大位移，防止闪烁
 */
const HEADS_UP_LEFT_SWIPE_REMOVE_EXPAND = 1.1;

@ObservedV2
export class NotificationBannerSwipeVm extends NotificationSwipeVm {
  /**
   * 卡片删除偏移
   */
  @Computed get deleteOffset(): number {
    const bannerStyle = this.vmInjector.getBannerVm().notificationBannerStyle;
    if (bannerStyle) {
      const screenWidth = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width);
      return (screenWidth - this.itemWidth) / 2 + this.itemWidth;
    }
    return this.itemWidth;
  }

  protected handleActionStart(event: GestureEvent): void {
    this.vmInjector.getBannerVm().addWatcher();
    super.handleActionStart(event);
  }

  protected handleActionEnd(event: GestureEvent): void {
    this.vmInjector.getBannerVm().removeWatcher();
    super.handleActionEnd(event);
  }

  protected handleActionCancel(): void {
    this.vmInjector.getBannerVm().removeWatcher();
    super.handleActionCancel();
  }

  stop(offsetX: number): void {
    log.showInfo(`add remove distance of heads up`);
    if (this.isLeftToRight) {
      this.updateLeftToRight(offsetX);
    } else {
      this.updateRightToLeft(offsetX);
    }
  }

  handleSwipeSpeed(event: GestureEvent): boolean {
    log.showInfo(`handleSwipeSpeed direction: ${this.isLeftToRight}` +
      `, isRemoveAllowed: ${this.isRemoveAllowed()}, speed: ${event.velocity}`);
    if (!this.isRemoveAllowed()) {
      return false;
    }
    this.vmInjector.getBannerVm().addWatcher();
    const itemWidth = this.deleteOffset;
    // 横幅上达到速度条件直接删除
    const duration = Math.abs(itemWidth * this.getExpandDistance() - Math.abs(this.offsetX)) / event.velocity * 1000;
    this.remove(this.isLeftToRight ? itemWidth : -itemWidth, duration).then(() => {
      this.vmInjector.getBannerVm().removeWatcher();
    });
    return true;
  }

  protected getExpandDistance(): number {
    return HEADS_UP_LEFT_SWIPE_REMOVE_EXPAND;
  }
}