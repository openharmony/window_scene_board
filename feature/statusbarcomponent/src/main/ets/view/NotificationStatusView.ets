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

import { NormalNotification } from '@ohos/systemuicommon/newTsIndex';
import { LengthMetrics } from '@ohos.arkui.node';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { PluginInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { ResourceVm, StatusBarVmInjector } from '@ohos/systemuicommon/newIndex';
import { NtfIconStyle } from '../style/NtfIconStyle';
import { StatusBarNotificationIconVm } from '../vm/StatusBarNotificationIconVm';
import { ResUtils } from '@ohos/windowscene';
import { LogWithHa } from '@ohos/systemuicommon';
import {
  NotificationExceptionCode
} from '@ohos/notificationcomponent/src/main/ets/maintenance/NotificationExceptionCode';

// instrument ignore file

const TAG = 'NotificationStatusView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ComponentV2
export struct NotificationStatusView {
  @Param @Require pluginInfo: PluginInfo;
  @Consumer() statusBarVmInjector: StatusBarVmInjector = StatusBarVmInjector.HOLDER;
  notificationVm = this.statusBarVmInjector.getStatusBarIconVm(
    PluginSlot.SLOT_STATUS_NOTIFICATION) as StatusBarNotificationIconVm;

  @Local ntfIconOpacity: number = 1;
  public defaultMaxIconCount: number = 5;
  /**
   * 资源样式
   */
  private style: NtfIconStyle = new NtfIconStyle();

  private getAccessibilityText(ntfEntry: NormalNotification): string {
    const res = getContext(this).resourceManager;
    const content = ntfEntry?.content?.contentTitle || '';
    return res.getStringByNameSync('accessibility_notifications_icon', ntfEntry?.appLabel, content);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.notificationVm.init(this.pluginInfo);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.notificationVm.unInit();
  }

  @Builder
  buildAppImage(ntfEntry: NormalNotification) {
    Image(ntfEntry?.getAppIcon(false))
      .id(ntfEntry?.hashCode + '_StatusBarAppIcon')
      .objectFit(ImageFit.ScaleDown)
      .width(this.style.ntfIconSize)
      .height(this.style.ntfIconSize)
      .draggable(false)
      .syncLoad(false)
      .interpolation(ImageInterpolation.Medium)
      .autoResize(false)
      .onError((error) => {
        const key = ntfEntry.groupKey;
        LogWithHa.error(log, `Load image error, key is: ${key}, message is: ${error?.message}`,
          NotificationExceptionCode.NOTIFICATION_ICON_ERROR, undefined, key);
      })
      .onComplete((event) => {
        log.showWarn(`Load complete, key is: ${ntfEntry.groupKey}, status is: ${event?.loadingStatus}`)
      })
  }

  @Builder
  buildAppIcon(ntfEntry: NormalNotification) {
    Row() {
      this.buildAppImage(ntfEntry)
    }
    .justifyContent(FlexAlign.Center)
  }

  /**
   * 通知图标布局
   *
   * @param item 图标数据
   * @param index 图标位置索引
   */
  @Builder
  private buildNtfIcon(item: NormalNotification) {
    // 不超出边界
    Row() {
      this.buildAppIcon(item);
    }
    .width(this.style.ntfIconSize)
    .height(this.style.ntfIconSize)
    .margin({
      end: LengthMetrics.resource(this.style.ntfIconMargin)
    })
    .opacity(this.getOpacity(item.uid))
    .offset(this.getOffset(item.uid))
    .scale(this.getScale(item.uid))
    .accessibilityLevel(this.getOpacity(item.uid) === 1 ? 'yes' : 'no')
    .accessibilityGroup(true)
    .accessibilityText(this.getAccessibilityText(item))
  }

  private getOpacity(uid: string): number {
    const index = this.notificationVm.notificationUid2IndexMap.get(uid);
    if (index === undefined) {
      log.showWarn(`index is undefined`);
      return 0;
    }
    return index >= this.notificationVm.showMaxIconCount ? 0 : 1
  }

  private getOffset(uid: string): Position {
    const index = this.notificationVm.notificationUid2IndexMap.get(uid);
    const maxCount = this.notificationVm.showMaxIconCount;
    if (index != undefined && index >= maxCount) {
      // 通知图标偏移量需要累加，是需要隐藏的图标整体等比例变化
      let offset = 0;
      if (ResourceVm.instance.isRTL) {
        offset = (index - maxCount) * ResUtils.getNumber(this.style.ntfIconSize) / 2;
      } else {
        offset = (index - maxCount) * -ResUtils.getNumber(this.style.ntfIconSize) / 2;
      }
      return { x: offset };
    } else {
      return { x: 0 };
    }
  }

  private getScale(uid: string): ScaleOptions {
    const index = this.notificationVm.notificationUid2IndexMap.get(uid)
    if (index != undefined && index >= this.notificationVm.showMaxIconCount) {
      let scaleCenterX = '0%';
      if (ResourceVm.instance.isRTL) {
        scaleCenterX = '100%'
      }
      return { x: 0.25, y: 0.25, centerX: scaleCenterX };
    } else {
      return { x: 1, y: 1 };
    }
  }

  build() {
    if (this.notificationVm.notificationList.length > 0) {
      Row() {
        ForEach(this.notificationVm.notificationList,
          (item: NormalNotification) => { this.buildNtfIcon(item)},
          (item: NormalNotification, index?: number) => item.uid + index?.toString() + this.notificationVm.refreshFlag )
      }
      .padding({start: LengthMetrics.resource(this.style.ntfContainerPadding),
        end: LengthMetrics.resource(this.style.ntfContainerPadding)})
      .height('100%')
    }
  }
}