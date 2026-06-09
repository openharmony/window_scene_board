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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { clockWidgetConfigManager }  from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockWidgetConfigManager';
import { ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

/**
 * 沉浸式锁屏测试用例
 */
export default function ClockWidgetConfigManagerTest() {
  describe('ClockWidgetConfigManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getExpandClockStyleByType', Level.LEVEL0, (): void => {
      clockWidgetConfigManager.getExpandClockStyleByType(ClockLayout.DIMENSION_4_4);
      clockWidgetConfigManager.getExpandClockStyleByType(ClockLayout.DIMENSION_4_2);
      clockWidgetConfigManager.getExpandClockStyleByType(ClockLayout.DIMENSION_2_4);
      clockWidgetConfigManager.getExpandClockStyleByType(ClockLayout.DIMENSION_6_6);
      clockWidgetConfigManager.getExpandClockStyleByType(ClockLayout.DIMENSION_3_6);
      expect(clockWidgetConfigManager).not().assertNull();
    });

    it('test_getCollapseClockStyleByType', Level.LEVEL0, (): void => {
      clockWidgetConfigManager.getCollapseClockStyleByType(ClockLayout.DIMENSION_4_4);
      clockWidgetConfigManager.getCollapseClockStyleByType(ClockLayout.DIMENSION_4_2);
      clockWidgetConfigManager.getCollapseClockStyleByType(ClockLayout.DIMENSION_2_4);
      clockWidgetConfigManager.getCollapseClockStyleByType(ClockLayout.DIMENSION_6_6);
      clockWidgetConfigManager.getCollapseClockStyleByType(ClockLayout.DIMENSION_3_6);
      expect(clockWidgetConfigManager).not().assertNull();
    });

    it('test_getExpandClockGridType', Level.LEVEL0, (): void => {
      clockWidgetConfigManager.getExpandClockGridType(ClockLayout.DIMENSION_4_4);
      clockWidgetConfigManager.getExpandClockGridType(ClockLayout.DIMENSION_4_2);
      clockWidgetConfigManager.getExpandClockGridType(ClockLayout.DIMENSION_2_4);
      clockWidgetConfigManager.getExpandClockGridType(ClockLayout.DIMENSION_6_6);
      clockWidgetConfigManager.getExpandClockGridType(ClockLayout.DIMENSION_3_6);
      expect(clockWidgetConfigManager).not().assertNull();
    });

    it('test_getCollapseClockGridType', Level.LEVEL0, (): void => {
      clockWidgetConfigManager.getCollapseClockGridType(ClockLayout.DIMENSION_4_4);
      clockWidgetConfigManager.getCollapseClockGridType(ClockLayout.DIMENSION_4_2);
      clockWidgetConfigManager.getCollapseClockGridType(ClockLayout.DIMENSION_2_4);
      clockWidgetConfigManager.getCollapseClockGridType(ClockLayout.DIMENSION_6_6);
      clockWidgetConfigManager.getCollapseClockGridType(ClockLayout.DIMENSION_3_6);
      expect(clockWidgetConfigManager).not().assertNull();
    });

    it('test_getClockDefaultFontFamily', Level.LEVEL0, (): void => {
      clockWidgetConfigManager.getClockDefaultFontFamily(ClockLayout.DIMENSION_4_4);
      clockWidgetConfigManager.getClockDefaultFontFamily(ClockLayout.DIMENSION_4_2);
      clockWidgetConfigManager.getClockDefaultFontFamily(ClockLayout.DIMENSION_2_4);
      clockWidgetConfigManager.getClockDefaultFontFamily(ClockLayout.DIMENSION_6_6);
      clockWidgetConfigManager.getClockDefaultFontFamily(ClockLayout.DIMENSION_3_6);
      expect(clockWidgetConfigManager).not().assertNull();
    });

    it('test_initForOneShot', Level.LEVEL0, (): void => {
      (clockWidgetConfigManager as object)['initForOneShot']();
      expect(clockWidgetConfigManager).not().assertNull();
    });
  });
}