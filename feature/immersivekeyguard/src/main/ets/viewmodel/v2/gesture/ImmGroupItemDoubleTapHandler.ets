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
import { NotificationNormalGroupVm } from '@ohos/notificationcomponent/newIndex';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { ImmListDoubleTapHandler } from './ImmListDoubleTapHandler';

const TAG = 'ImmGroupItemDoubleTapHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸列表组通知条目单双击处理
 */
export class ImmGroupItemDoubleTapHandler extends ImmListDoubleTapHandler {
  // 组通知条目VM
  private _groupVm: NotificationNormalGroupVm;

  // 菜单是否展开
  private _isMenuExpanded: boolean = false;

  public setIsMenuExpanded(menuExpanded: boolean): void {
    this._isMenuExpanded = menuExpanded;
  }

  public getIsMenuExpanded(): boolean {
    return this._isMenuExpanded;
  }

  constructor(groupVm: NotificationNormalGroupVm) {
    super();
    this._groupVm = groupVm;
  }

  protected onSingleTap(): void {
    log.showInfo('group item is single-tapped in keyguard');
    if (this._isMenuExpanded || !this._isDoubleTapSupported) {
      this._callback?.();
      return;
    }
    let tip = this._groupVm.isExpanded ? ScreenLockNotificationConst.DOUBLE_CLICK_COLLAPSE_TIP :
    ScreenLockNotificationConst.DOUBLE_CLICK_EXPAND_TIP;
    this.promptFloatTip(tip);
  }

  protected onDoubleTap(): void {
    log.showInfo('group item is double-tapped in keyguard');
    this._callback?.();
  }
}