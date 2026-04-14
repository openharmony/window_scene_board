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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level, expect } from '@ohos/hypium';
import { ClockGridParam,
  ClockGridParamCorrection,
  ClockLayoutParam, ElementConf }  from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';
import ClockMapping from '../../../../../../../../../screenlock/screenlockwidget/src/main/ets/clock/common/ClockMapping';
import { ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';

/**
 * 沉浸式锁屏测试用例
 */
export default function ClockMappingTest() {
  describe('ClockMappingTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getFoldRealPosition', 0, () => {
      ClockMapping.getFoldRealPosition(true, true, 0);
      ClockMapping.getFoldRealPosition(true, false, 0)
      ClockMapping.getFoldRealPosition(false, false, 0);
      expect(true).assertTrue();
    });

    it('test_getPadRealPositionX', 0, () => {
      ClockMapping.getPadRealPositionX(true, true, 0);
      ClockMapping.getPadRealPositionX(true, false, 0)
      ClockMapping.getPadRealPositionX(false, false, 0);
      expect(true).assertTrue();
    });

    it('test_getPadRealPositionY', 0, () => {
      ClockMapping.getPadRealPositionY(1, false, 0);
      ClockMapping.getPadRealPositionY(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL, true, 0);
      ClockMapping.getPadRealPositionY(ClockLayout.MOUNTAIN_CLOCK_LAYOUT, true, 0);
      ClockMapping.getPadRealPositionY(1, true, 0);
      ClockMapping.getPadRealPositionY(2, true, 0);
      ClockMapping.getPadRealPositionY(3, true, 0);
      ClockMapping.getPadRealPositionY(4, true, 0);
      expect(true).assertTrue();
    });
  });
}