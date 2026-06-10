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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import {
  DesktopMode, EmergencyManager
} from '../../../../../../main/ets/com/ohos/viewModel/EmergencyManager';
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopMode';

export function EmergencyManagerTest() {

  describe('EmergencyManagerTest', (): void => {
    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {

    })

    it('EmergencyManagerTest_Test001', 0, (): void => {
      let desktopMode: DesktopMode = EmergencyManager.getInstance().getData();
      expect(desktopMode.desktopMode).assertEqual(DesktopModeEnum.BASE_MODE);
      EmergencyManager.getInstance().unRegisterDesktopModeChange();
    })
  })
}