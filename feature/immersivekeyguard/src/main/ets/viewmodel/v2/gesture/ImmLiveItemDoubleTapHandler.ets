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
import { NotificationCardVm, NotificationNormalVm } from '@ohos/notificationcomponent/newIndex';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import { ImmListDoubleTapHandler } from './ImmListDoubleTapHandler';

const TAG = 'ImmLiveItemDoubleTapHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸列表实况通知条目单双击处理
 */
export class ImmLiveItemDoubleTapHandler extends ImmListDoubleTapHandler {
  // 实况通知条目VM
  private _itemVm: NotificationCardVm;

  constructor(itemVm: NotificationCardVm) {
    super();
    this._itemVm = itemVm;
  }

  protected onSingleTap(): void {
    log.showInfo('live item is single-tapped in keyguard');
    if (!this._itemVm) {
      log.showError('itemVm is null');
    }
    if (!this._isDoubleTapSupported || this._itemVm?.isSwiped()) {
      this._callback?.();
      return;
    }

    this.promptFloatTip(ScreenLockNotificationConst.KG_NTF_CLICK_TIP);
    NotificationNormalVm.hideActionButtons(SystemUIUseScene.KG);
  }

  protected onDoubleTap(): void {
    log.showInfo('live item is double-tapped in keyguard');
    this._callback?.();
  }
}