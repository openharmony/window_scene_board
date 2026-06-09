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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ControlCenterWindowManager } from '../../manager/ControlCenterWindowManager';
import { ControlCenterConstants } from '../constants/ControlCenterConstants';
import { VisionAdjustmentConstants, } from '../constants/VisionAdjustmentConstants';

const TAG = 'VisionAdjustmentStepsComponent';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct VisionAdjustmentStepsComponent {
  aboutToAppear() {
    log.showInfo(`aboutToAppear`);
  }

  build() {
    Column({ space: VisionAdjustmentConstants.VISION_ADJUSTMENT_SPACE }) {
      UIExtensionComponent({
        bundleName: 'com.ohos.visionglass',
        abilityName: 'VisionAdjustmentAbility',
        parameters: {
          'ability.want.params.uiExtensionType': 'sys/commonUI'
        }
      })
        .width(ControlCenterConstants.FULL_SIZE)
        .height(ControlCenterConstants.FULL_SIZE)
        .onTerminated(() => {
          log.showInfo(`onTerminated`);
          ControlCenterWindowManager.getInstance().closeCurSubWindow();
        })
        .onError(() => {
          log.showInfo(`onError`);
          ControlCenterWindowManager.getInstance().closeCurSubWindow();
        })
    }
    .width(ControlCenterConstants.FULL_SIZE)
    .height(ControlCenterConstants.FULL_SIZE)
  }
}