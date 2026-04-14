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
import { NotificationNormalVm } from '@ohos/notificationcomponent/newIndex';
import { ScreenLockNotificationConst } from '@ohos/screenlockcommon';
import { SystemUIUseScene } from '@ohos/systemuicommon/newTsIndex';
import { ImmListDoubleTapHandler } from './ImmListDoubleTapHandler';

const TAG = 'ImmNormalItemDoubleTapHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸列表普通通知条目单双击处理
 */
export class ImmNormalItemDoubleTapHandler extends ImmListDoubleTapHandler {
  // 普通通知条目VM
  private _itemVm: NotificationNormalVm;

  constructor(itemVm: NotificationNormalVm) {
    super();
    this._itemVm = itemVm;
  }

  protected onSingleTap(): void {
    log.showInfo('normal item is single-tapped in keyguard');
    if (this._itemVm.swipeVm?.offsetX !== 0) {
      this._callback?.();
      return;
    }
    if (this.isActionButtonsFolded()) {
      // 支持双击时，单击弹出提示，否则直接展开按钮
      if (this._isDoubleTapSupported) {
        this.promptFloatTip(ScreenLockNotificationConst.DOUBLE_CLICK_EXPAND_TIP);
        return;
      }
      this._callback?.();
      return;
    }
    if (!this._itemVm?.ntf?.wantAgent) {
      this.promptFloatTip(ScreenLockNotificationConst.KG_NTF_NO_CONTENT_TIP);
      NotificationNormalVm.hideActionButtons(SystemUIUseScene.KG);
      return;
    }
    if (!this._isDoubleTapSupported || this._itemVm?.isShowActionButton) {
      this._callback?.();
      return;
    }
    this.promptFloatTip(ScreenLockNotificationConst.KG_NTF_CLICK_TIP);
    NotificationNormalVm.hideActionButtons(SystemUIUseScene.KG);
  }

  protected onDoubleTap(): void {
    log.showInfo('normal item is double-tapped in keyguard');
    if (this.isActionButtonsFolded() || this._itemVm.swipeVm?.offsetX !== 0) {
      this._callback?.();
      return;
    }
    if (!this._itemVm?.ntf?.wantAgent) {
      this.promptFloatTip(ScreenLockNotificationConst.KG_NTF_NO_CONTENT_TIP);
      NotificationNormalVm.hideActionButtons(SystemUIUseScene.KG);
      return;
    }
    this._callback?.();
  }

  /**
   * 通知是否带按钮且未展开
   *
   * @returns true 通知带按钮且未展开
   */
  private isActionButtonsFolded(): boolean {
    return this._itemVm.ntf.actionButtons?.length !== 0 && !this._itemVm.isShowActionButton;
  }
}