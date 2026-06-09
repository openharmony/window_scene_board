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
import { NotificationAction, SceneSessionAdapter } from '@ohos/systemuicommon';
import { FocusChangeReason } from '@ohos/windowscene';
import { NotificationActionButtonVm } from '../../../viewmodel/NotificationActionButtonVm';

const TAG = 'NotificationActionButtonBannerVm';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

@ObservedV2
export class NotificationActionButtonBannerVm extends NotificationActionButtonVm {
  @Computed public get paddingBottom(): number {
    return this.vmInjector.getVerticalSwipeVm()?.isSupportFloating ? 10 : 0;
  }

  async onClickActionButton(action: NotificationAction, buttonIndex?: number, isInGroup?: boolean): Promise<void> {
    if (action.userInputKey) {
      const persistentId = this.vmInjector.getBannerVm().persistentId;
      log.showInfo(`Click for banner persistentId ${persistentId}`);
      if (persistentId) {
        SceneSessionAdapter.setFocusable(persistentId, true);
        SceneSessionAdapter.requestFocus(persistentId, true, FocusChangeReason.CLICK);
      }
      this.ntf.isHeadsUpStick = true;
    }
    super.onClickActionButton(action, buttonIndex);
  }
}