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

import { NotificationSettingDialogVm } from '@ohos/notificationcomponent/newIndex';
import { ScreenLockApi } from '@ohos/screenlockcommon';
import { IImmersiveNtfSettingDialogVm } from '../../../common/interface/IImmersiveNtfSettingDialogVm';

/**
 * 沉浸列表条目设置弹框业务管理
 */
@ObservedV2
export class ImmersiveNtfSettingDialogVm extends NotificationSettingDialogVm implements IImmersiveNtfSettingDialogVm {
  protected openNtfSetting(): void {
    ScreenLockApi.requestUnlock({
      success: () => {
        super.openNtfSetting();
      }
    });
  }

  onBackGestureEvent(): boolean {
    if (this.settingDiagData.isShowDialog) {
      this.hide();
      return true;
    }
    return false;
  }
}