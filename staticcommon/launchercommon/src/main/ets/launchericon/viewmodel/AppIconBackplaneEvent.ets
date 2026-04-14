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

import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { CommonConstants } from '../../constants/CommonConstants';
import { AppIconBackplaneVm } from './AppIconBackplaneVm'

const TAG = 'AppIconBackplaneEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export class AppIconBackplaneEvent {
  private appKeyName: string = '';
  private backplaneVm: AppIconBackplaneVm;
  private onCoveredAppEvent: (isShow: boolean) => void = (isShow: boolean): void => {
    this.onEventhubCoveredItemEvent(isShow);
  };
  private readonly SUPPORT_DRAG_TYPE: number[] = [
    CommonConstants.DRAG_FROM_DESKTOP, CommonConstants.DRAG_FROM_DOCK,
    CommonConstants.DRAG_FROM_FOLDER, CommonConstants.DRAG_FROM_FOLDER_IN_DOCK, CommonConstants.DRAG_FROM_SHORTCUT,
  ];
  private appNameAnimate?: (isAppBackplaneOpen: boolean) => void;

  constructor(vm: AppIconBackplaneVm) {
    this.backplaneVm = vm;
  }

  public init(keyName: string, appNameAnimate: (isAppBackplaneOpen: boolean) => void): void {
    this.appKeyName = keyName;
    this.appNameAnimate = appNameAnimate;
    // 注册appItem覆盖背板动效事件
    let coveredItemEventId: string = this.getAppIconCoveredEventId();
    GlobalContext.getContext()?.eventHub?.off(coveredItemEventId, this.onCoveredAppEvent);
    GlobalContext.getContext()?.eventHub?.on(coveredItemEventId, this.onCoveredAppEvent);
  }

  public destroy(): void {
    GlobalContext.getContext()?.eventHub?.off(this.getAppIconCoveredEventId(), this.onCoveredAppEvent);
  }

  private getAppIconCoveredEventId(): string {
    return `coveredApp${this.appKeyName}`;
  }

  private onEventhubCoveredItemEvent(isShow: boolean): void {
    log.showInfo(`onEventhubCoveredItemEvent item:${this.appKeyName}, isShow:${isShow}`);
    const dragItemType: number = AppStorage.get<number>('dragItemType') as number;
    if (this.SUPPORT_DRAG_TYPE.includes(dragItemType) &&
      AppStorage.get<string>('device') === CommonConstants.DEFAULT_DEVICE_TYPE) {
      this.showAppBackplaneAnimate(isShow);
    }
  }

  // 拖动app到app触发动效：APP背板放大 || 缩小
  private showAppBackplaneAnimate(isAppBackplaneOpen: boolean): void {
    this.appNameAnimate?.(isAppBackplaneOpen);
    log.showInfo(`showAppBackplaneAnimate: ${isAppBackplaneOpen}`);
    if (isAppBackplaneOpen) {
      this.backplaneVm.visible = true;
      animateTo({
        curve: curves.springCurve(1.5, 1.5, 230, 25),
      }, () => {
        this.backplaneVm.scale = 1.15;
      })
    } else {
      animateTo({
        curve: curves.springCurve(1.5, 1.5, 230, 25),
      }, () => {
        this.backplaneVm.visible = false;
        this.backplaneVm.scale = 1.0;
      })
    }
  }
}