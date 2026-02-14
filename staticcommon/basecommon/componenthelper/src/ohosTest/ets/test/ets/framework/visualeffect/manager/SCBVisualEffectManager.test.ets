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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { VisualEffectListener } from '../../../../../../../main/ets/manager/SCBVisualEffectManager';
import { SCBVisualEffectMgr, ListenerType } from '../../../../../../../main/ets/TsIndex';
import { power } from '@kit.BasicServicesKit';
import { StartExitMotionLevel } from '@ohos/commonconstants/src/main/ets/constants/VisualEffectConstants';

export function SCBVisualEffectManagerTest() {
  describe('SCBVisualEffectManagerTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('getFeatureParam_by_null_feature', Level.LEVEL0, (): void => {
      expect(SCBVisualEffectMgr.getFeatureParam(null) === undefined).assertTrue();
    });

    it('getFeatureParam_by_empty_feature', Level.LEVEL0, (): void => {
      let emptyFeature: string = '';
      expect(SCBVisualEffectMgr.getFeatureParam(emptyFeature) === undefined).assertTrue();
    });

    it('getFeatureParam_by_invalid_feature', Level.LEVEL0, (): void => {
      let invalidFeature: string = 'invalid_feature';
      expect(SCBVisualEffectMgr.getFeatureParam(invalidFeature) === undefined).assertTrue();
    });

    it('getFeatureParam_ntf_blur_disable_default', Level.LEVEL0, (): void => {
      let feature: string = 'notification_blur_effect_disable';
      expect(SCBVisualEffectMgr.getFeatureParam(feature) === 'false').assertTrue();
    });

    it('getFeatureParam_ntf_shadow_disable_default', Level.LEVEL0, (): void => {
      let feature: string = 'notification_shadow_disable';
      expect(SCBVisualEffectMgr.getFeatureParam(feature) === 'false').assertTrue();
    });

    it('getFeatureParam_ntf_brightens_disable_default', Level.LEVEL0, (): void => {
      let feature: string = 'notification_brightens_disable';
      expect(SCBVisualEffectMgr.getFeatureParam(feature) === 'false').assertTrue();
    });

    it('isFeatureParamTrue_by_invalid_feature', Level.LEVEL0, (): void => {
      let invalidFeature: string = 'invalid_feature';
      expect(SCBVisualEffectMgr.isFeatureParamTrue(invalidFeature)).assertFalse();
    });

    it('isPowerSaveMode_001', Level.LEVEL0, (): void => {
      power.setPowerMode(power.DevicePowerMode.MODE_POWER_SAVE);
      expect(SCBVisualEffectMgr.isPowerSaveMode()).assertInstanceOf('Boolean');
    });

    it('isPowerSaveMode_002', Level.LEVEL0, (): void => {
      power.setPowerMode(power.DevicePowerMode.MODE_EXTREME_POWER_SAVE);
      expect(SCBVisualEffectMgr.isPowerSaveMode()).assertTrue();
    });

    it('registerThermalLevelChange_003', Level.LEVEL0, () => {
      let callback: VisualEffectListener = {} as VisualEffectListener;
      const listenerTypes: ListenerType[] = [ListenerType.TEMPERATURE, ListenerType.BATTERY];
      let result = SCBVisualEffectMgr.registerVisualEffectLevelChange(listenerTypes, 'test', callback);
      expect(result == null).assertTrue();
    });

    it('unregisterThermalLevelChange_004', Level.LEVEL0, () => {
      const listenerTypes: ListenerType[] = [ListenerType.TEMPERATURE, ListenerType.BATTERY];
      let result = SCBVisualEffectMgr.unregisterVisualEffectLevelChange(listenerTypes, 'test');
      expect(result == null).assertTrue();
    });

    it('unregisterThermalLevelChange_004', Level.LEVEL0, () => {
      const listenerTypes: ListenerType[] = [ListenerType.TEMPERATURE, ListenerType.BATTERY];
      let result = SCBVisualEffectMgr.unregisterVisualEffectLevelChange(listenerTypes, 'test2');
      expect(result == null).assertTrue();
    });

    it('getStartExitMotionLevel_002', Level.LEVEL0, (): void => {
      let result = SCBVisualEffectMgr.getStartExitMotionLevel('icon_start_exit_motion_blur_level');
      expect(result === StartExitMotionLevel.NORMAL_BLUR).assertTrue();
    });

  });
}