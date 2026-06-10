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
import { NotificationPrivacyVm } from '@ohos/notificationcomponent/src/main/ets/viewmodel/NotificationPrivacyVm';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import { ImmListDoubleTapHandler } from './ImmListDoubleTapHandler';

const TAG = 'ImmPrivacyItemDoubleTapHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸列表隐藏内容通知条目单双击处理
 */
export class ImmPrivacyItemDoubleTapHandler extends ImmListDoubleTapHandler {
  // 隐藏内容通知VM
  private _privacyVm: NotificationPrivacyVm;

  constructor(privacyVm: NotificationPrivacyVm) {
    super();
    this._privacyVm = privacyVm;
  }

  protected onSingleTap(): void {
    log.showInfo('privacy item is single-tapped in keyguard');
    let ntf = this.getTargetNtf();
    if (!ntf) {
      log.showWarn('privacy item on single-tap is null');
      return;
    }
    if (this._privacyVm.swipeVm?.offsetX !== 0) {
      this._callback?.();
      return;
    }
    let tip = !ntf.wantAgent ? ScreenLockNotificationConst.KG_NTF_NO_CONTENT_TIP :
    ScreenLockNotificationConst.KG_NTF_CLICK_TIP;
    this.promptFloatTip(tip);
  }

  protected onDoubleTap(): void {
    log.showInfo('privacy item is double-tapped in keyguard');
    let ntf = this.getTargetNtf();
    if (!ntf) {
      log.showWarn('privacy item on double-tap is null');
      return;
    }
    if (this._privacyVm.swipeVm?.offsetX !== 0) {
      this._callback?.();
      return;
    }
    if (!ntf.wantAgent) {
      this.promptFloatTip(ScreenLockNotificationConst.KG_NTF_NO_CONTENT_TIP);
      return;
    }
    this._callback?.();
  }

  private getTargetNtf(): NotificationBase | undefined {
    // 组通知视作其首条子通知进行响应
    if (this._privacyVm?.ntf?.isNormalGroup()) {
      if ((this._privacyVm.ntf.children?.length ?? 0) === 0) {
        return undefined;
      }
      return this._privacyVm.ntf.children[0];
    }
    return this._privacyVm?.ntf;
  }
}