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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { KeyguardStatusService } from '../../../../../main/ets/manager/KeyguardStatusService'
import { KeyGuardLockStatus, KeyGuardMode, KeyGuardPage } from '../../../../../main/ets/TsIndex'

/**
 * 锁屏状态服务测试
 */
export default function KeyguardStatusServiceTest() {
  describe('KeyguardStatusServiceTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('KeyguardStatusService_isOccluded', Level.LEVEL0, () => {
      let result = KeyguardStatusService.isOccluded();
      expect(result).not().assertNull();
    })

    it('KeyguardStatusService_isCoverMode', Level.LEVEL0, () => {
      let isCoverMode: boolean = KeyguardStatusService.isCoverMode();
      expect(isCoverMode).not().assertNull();
    })

    it('KeyguardStatusService_isSpecialMode', Level.LEVEL1, () => {
      let isSpecialMode: boolean = KeyguardStatusService.isSpecialMode();
      expect(isSpecialMode).not().assertNull();
    })

    it('KeyguardStatusService_isLockStatus', Level.LEVEL1, () => {
      let isLockStatus: boolean = KeyguardStatusService.isLockStatus(KeyGuardLockStatus.UNLOCKED);
      expect(isLockStatus).not().assertNull();
    })

    it('KeyguardStatusService_isPage', Level.LEVEL1, () => {
      let result = KeyguardStatusService.isPage(KeyGuardPage.HOME_PAGE);
      expect(result).not().assertNull();
    })

    it('KeyguardStatusService_isMode', Level.LEVEL1, () => {
      let isThemeEditMode: boolean = KeyguardStatusService.isMode(KeyGuardMode.THEME_EDIT);
      expect(isThemeEditMode).assertFalse();
    })
  })
}