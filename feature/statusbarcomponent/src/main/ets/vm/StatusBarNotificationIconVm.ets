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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginInfo } from '@ohos/frameworkwrapper';
import { ResUtils } from '@ohos/windowscene';
import { InnerEventUtil, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { NotificationStatusView } from '../view/NotificationStatusView';
import { StatusBarIconBaseVm } from './StatusBarIconBaseVm';
import { StatusBarNotificationEvent } from '@ohos/systemuicommon/src/main/ets/event/NotificationEvent';
import { CutoutVm, DropdownVm, LiveVmInjectorFactory } from '@ohos/systemuicommon/newIndex';

const TAG = 'StatusBarNotificationIconVm'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class StatusBarNotificationIconVm extends StatusBarIconBaseVm {
  public id = 'PluginRootComponent_Stack_status_bar_notification_icon';
  @Trace public notificationList: Array<NotificationBase> = [];
  @Trace public showMaxIconCount: number = 5;
  @Trace public marginStart: number = 4; // 时间和通知图标间隔为4vp
  @Trace public refreshFlag: boolean = false;
  @Trace public ntfIconOpacity: number = 1;
  public defaultMaxIconCount: number = 5;
  public singleIconWidth: number = 14;
  public notificationUid2IndexMap: Map<string, number> = new Map();
  public dropdownVm: DropdownVm = DropdownVm.instance;
  public cutoutVm: CutoutVm = CutoutVm.instance;
  private timerId: number = -1;
  public statusBarLayoutVm = this.vmInjector.getStatusBarLayoutVm();
  public capsuleListVm = LiveVmInjectorFactory.get().getCapsuleListVm();

  initIcon(): void {
    try {
      InnerEventUtil.on(StatusBarNotificationEvent, this.onNtfStatusIconEvent);
    } catch (e) {
      log.showError('register notification event error:', e);
    }
  }


  unInitIcon(): void {
    InnerEventUtil.off(StatusBarNotificationEvent, this.onNtfStatusIconEvent);
  }

  /**
   * 通知图标宽度
   */
  getNtfIconWidth(): number {
    // margin + width
    return ResUtils.getConvertNumber($r('app.float.plugin_phone_ntf_icon_margin')) + this.singleIconWidth;
  }

  updateShowMaxIconCount(showMaxIconCount: number): void {
    this.showMaxIconCount = showMaxIconCount > this.defaultMaxIconCount ? this.defaultMaxIconCount : showMaxIconCount;
  }

  private onNtfStatusIconEvent = (event: StatusBarNotificationEvent): void => {
    log.showInfo(`onNtfStatusIconEvent, ntf num: ${event.notificationList.length}`);
    if (event.notificationList.length === 0) {
      this.notificationList = [];
      return;
    }
    let validList: NotificationBase[] = [];
    event.notificationList.forEach((ntf) => {
      if (ntf.isLiveView() && !ntf.isConvertFromNormal) {
        log.showInfo(`Skip live view ${ntf.toSimpleString()}.`);
        return;
      }
      validList.push(ntf);
    })
    log.showInfo(`valid num: ${validList.length}, Reserved num: ${this.defaultMaxIconCount}, show num: ${this.showMaxIconCount}`);
    validList = validList.splice(0, this.defaultMaxIconCount);
    this.notificationUid2IndexMap.clear();
    validList.forEach((value, index) => {
      this.notificationUid2IndexMap.set(value.uid, index);
    })
    this.notificationList = validList;
    // 强制刷新时，修改刷新标志，让ForEach的key发生变化
    if (event.forceRefresh) {
      this.refreshFlag = !this.refreshFlag;
    }
  }

  getBuilder(): WrappedBuilder<[PluginInfo]> {
    return wrapBuilder(ntfIconBuilder);
  }

  @Monitor('dropdownVm.isDropDown')
  onDropdownShowChange(): void {
    log.showWarn(`ondropdownShowChange: ${this.dropdownVm.isDropDown}, isMiddleCutout:${this.cutoutVm.isMiddleCutout()}, capsuleNum: ${this.capsuleListVm.liveList.length}`);
    if (!this.cutoutVm.isMiddleCutout() && !this.dropdownVm.isDropDown && this.capsuleListVm.liveList.length > 0) {
      if (this.timerId !== -1) {
        clearTimeout(this.timerId);
        this.timerId = -1;
      }
      this.ntfIconOpacity = 0;
      this.timerId = setTimeout(() => {
        this.ntfIconOpacity = 1;
      }, 100)
    }
  }

  getOpacity(isLeftIcon: boolean): number {
    return this.ntfIconOpacity;
  }
}

@Builder
function ntfIconBuilder(plugin: PluginInfo) {
  NotificationStatusView({ pluginInfo: plugin });
}