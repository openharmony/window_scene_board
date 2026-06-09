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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { ClockData, ClockDataListener } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockData';
import { DesktopModeManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

export default function ClockDataTest() {
  describe('ClockDataTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('test_registerDataChanged', 0, (): void => {
      let listener: ClockDataListener = {
        onChanged: () => {}
      }
      let clockData = new ClockData();
      clockData.registerDataChanged(listener);
      expect(clockData).not().assertUndefined();
    });

    it('test_registerDataChanged_01', 0, (): void => {
      let listener: ClockDataListener = {
        onChanged: () => {}
      }
      AppStorage.set('isAodPreviewScene',true);
      let clockData = new ClockData();
      (clockData as object)['clockDataListeners'] = [listener]
      clockData.registerDataChanged(listener);
      expect(clockData).not().assertUndefined();
    });

    it('test_unregisterDataChanged', 0, (): void => {
      let clockData = new ClockData();
      let listener: ClockDataListener = {
        onChanged: () => {}
      }
      clockData.unregisterDataChanged(listener);
      expect(clockData).not().assertUndefined();
    });

    it('test_unregisterDataChanged_01', 0, (): void => {
      let clockData = new ClockData();
      let listener: ClockDataListener = {
        onChanged: () => {}
      };
      (clockData as object)['clockDataListeners'] = [listener];
      clockData.unregisterDataChanged(listener);
      expect(clockData).not().assertUndefined();
    });

    it('test_registerDateTimeEvent', 0, (): void => {
      let clockData = new ClockData();
      clockData.registerDateTimeEvent();
      expect(clockData).not().assertUndefined();
    });

    it('test_updateTime', 0, (): void => {
      let clockData = new ClockData();
      clockData.updateTime();
      expect(clockData).not().assertUndefined();
    });

    it('test_updateClockForPreview', 0, (): void => {
      let clockData = new ClockData();
      let dt = new Date();
      (clockData as object)['isAodPreviewScene'] = false;
      (clockData as object)['use24hFormat'] = true;
      (clockData as object)['updateClockForPreview'](dt);
      (clockData as object)['isAodPreviewScene'] = true;
      (clockData as object)['updateClockForPreview'](dt);
      (clockData as object)['use24hFormat'] = false;
      (clockData as object)['updateClockForPreview'](dt);
      expect(clockData).not().assertUndefined();
    });

    it('test_updateClockForPreview_01', 0, (): void => {
      let clockData = new ClockData();
      let dt = new Date();
      (clockData as object)['isAodPreviewScene'] = true;
      (clockData as object)['use24hFormat'] = true;
      dt.setHours(1);
      (clockData as object)['updateClockForPreview'](dt);
      (clockData as object)['isAodPreviewScene'] = true;
      (clockData as object)['use24hFormat'] = false;
      dt.setHours(12);
      (clockData as object)['updateClockForPreview'](dt);
      (clockData as object)['use24hFormat'] = false;
      (clockData as object)['updateClockForPreview'](dt);
      expect(clockData).not().assertUndefined();
    });

    it('test_needUpdateLockTime', 0, (): void => {
      let clockData = new ClockData();
      (clockData as object)['needUpdateLockTime']();
      expect(clockData).not().assertUndefined();
    });

    it('test_needUpdateLockTime_01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(mockFuc)().afterReturn(true);
      let clockData = new ClockData();
      (clockData as object)['needUpdateLockTime']();
      expect(clockData).not().assertUndefined();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    });

    it('test_registerDateTimeEventForPreview', 0, (): void => {
      let clockData = new ClockData();
      (clockData as object)['registerDateTimeEventForPreview']();
      expect(clockData).not().assertUndefined();
    });

    it('test_registerDateTimeEventForPreview_01', 0, (): void => {
      let clockData = new ClockData();
      AppStorage.setOrCreate('AodUIExtensionContext',undefined);
      (clockData as object)['registerDateTimeEventForPreview']();
      expect(clockData).not().assertUndefined();
    });

    it('test_updateClock_01', 0, (): void => {
      let clockData = new ClockData();
      let dt = new Date();
      AppStorage.set<boolean>('isAccessibilityMode', true);
      (clockData as object)['updateClock'](dt);
      expect(clockData).not().assertUndefined();
    });

  });
}