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

import { restoringTipsController } from './RestoringTipsController';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'RestoringTipsDialog';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Entry
@Component
struct RestoringTipsDialog {

  async aboutToAppear() {
    AlertDialog.show({
      message: $r('app.string.restoring_tips_message'),
      autoCancel: true,
      alignment: DialogAlignment.Center,
      buttons: [{
        value: $r('app.string.restoring_tips_btn'),
        action: () => {
          restoringTipsController.destroy();
        }
      }],
      cancel: () => {
        restoringTipsController.destroy();
      }
    })
  }

  async aboutToDisappear() {
    log.showInfo('aboutToDisappear');
  }

  async onPageShow() {
    log.showInfo('onPageShow');
  }

  async onPageHide() {
    log.showInfo('onPageHide');
  }

  async onCancel() {
    log.showInfo('onCancel');
    restoringTipsController.destroy();
  }

  build() {
  }
}