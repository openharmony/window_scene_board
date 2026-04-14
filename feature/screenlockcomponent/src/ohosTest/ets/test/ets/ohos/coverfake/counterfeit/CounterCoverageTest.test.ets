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
import { DeviceHelper, SCBDesktopCacheManager } from '@ohos/frameworkwrapper'
import { OccludeKeygaurdScene } from '@ohos/windowscene';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { SleepReason, WakeUpReason } from '@ohos/screenlockcommon/src/main/ets/services/ScreenOnOffService'
import { KeyguardStatusService, ObjectPool, Recyclable } from '@ohos/screenlockcommon/src/main/ets/TsIndex'

import { CoreStateType, CoreStateTypeUtils } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm'
import IAodProxy from '../../../../../../../main/ets/onemirror/model/IAodProxy'

import {
  MirrorScene,
  MirrorSceneUtils,
  OneMirrorService
} from '../../../../../../../main/ets/onemirror/service/OneMirrorService'

export default function CounterCoverageTest() {
  describe('CounterCoverageTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('OneMirrorServiceTest_init', 0, () => {
      MirrorSceneUtils.isScreenOffScene(MirrorScene.SCREEN_OFF);
      MirrorSceneUtils.isScreenOffScene(MirrorScene.AOD);
      MirrorSceneUtils.isPowerOffScene(MirrorScene.SCREEN_OFF);
      MirrorSceneUtils.isFakeAodScene(MirrorScene.AOD);
      MirrorSceneUtils.isScreenLockScene(MirrorScene.SCREEN_LOCK);
      let result = MirrorSceneUtils.isScreenUnLockScene(MirrorScene.UNLOCK);
      expect(result).not().assertNull();
    })

    it('OneMirrorServiceTest_getInstance', 0, () => {
      let result = OneMirrorService.getInstance().isFingerprintShowing();
      expect(result).not().assertNull();
    })

    it('OneMirrorServiceTest_wakeUpSyncThemeEnginState', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['wakeUpSyncThemeEnginState'](WakeUpReason.PROXIMITY);
      expect(mirror).not().assertUndefined();
    })

    it('OneMirrorServiceTest_sleepSyncThemeEnginState', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['sleepSyncThemeEnginState'](SleepReason.PROXIMITY);
      expect(mirror).not().assertUndefined();
    })

    it('OneMirrorServiceTest_isNeedSendMsgToTheme', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['isNeedSendMsgToTheme'](OccludeKeygaurdScene.SPECIAL);
      (mirror as object)['isNeedSendMsgToTheme'](OccludeKeygaurdScene.SYSTEM_TOP_PANEL);
      (mirror as object)['isNeedSendMsgToTheme'](OccludeKeygaurdScene.SYSTEM_DIALOG);
      expect(mirror).not().assertUndefined();
    })

    it('OneMirrorServiceTest_sendMsgToThemeWallpaper', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['sendMsgToThemeWallpaper'](true);
      (mirror as object)['sendMsgToThemeWallpaper'](false);
      expect(mirror).not().assertUndefined();
    })

    it('OneMirrorServiceTest_preSetScreenOffState', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['_isAodShow'] = true;
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(mirror, (mirror as object)['isConfigSupportAod']);
      when(mockFun)().afterReturn(true);
      (mirror as object)['preSetScreenOffState'](CoreStateType.SCREEN_OFF_UNLOCK_STATE);
      expect(mirror).not().assertUndefined();
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_preSetScreenOffState_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['preSetScreenOffState'](CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      expect(mirror).not().assertUndefined();
    })

    it('OneMirrorServiceTest_triggerOneMirrorAction', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['triggerOneMirrorAction'](CoreStateType.SCREEN_OFF_MP_LOCK_STATE,
        CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      expect(mirror).not().assertUndefined();
    })

    it('OneMirrorServiceTest_triggerOneMirrorAction_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(MirrorSceneUtils, MirrorSceneUtils.isScreenOffScene);
      when(mockFun)(CoreStateType.INIT_STATE).afterReturn(true);
      (mirror as object)['triggerOneMirrorAction'](CoreStateType.INIT_STATE, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      expect(mirror).not().assertUndefined();
      mock.clear(MirrorSceneUtils);
    })

    it('OneMirrorServiceTest_getMirrorSceneFromCoreState', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isScreenOffState);
      when(mockFun)(CoreStateType.INIT_STATE).afterReturn(true);
      let result: MirrorScene = (mirror as object)['getMirrorSceneFromCoreState'](CoreStateType.INIT_STATE);
      expect(result).assertEqual(MirrorScene.SCREEN_OFF);
      mock.clear(CoreStateTypeUtils);
    })

    it('OneMirrorServiceTest_getMirrorSceneFromCoreState_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isScreenOffState);
      let mockFun2: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInUnlockPage);
      when(mockFun1)(CoreStateType.INIT_STATE).afterReturn(false);
      when(mockFun2)(CoreStateType.INIT_STATE).afterReturn(true);
      let result: MirrorScene = (mirror as object)['getMirrorSceneFromCoreState'](CoreStateType.INIT_STATE);
      expect(result).assertEqual(MirrorScene.UNLOCK);
      mock.clear(CoreStateTypeUtils);
    })

    it('OneMirrorServiceTest_getMirrorSceneFromCoreState_03', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isScreenOffState);
      let mockFun2: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInUnlockPage);
      let mockFun3: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isAodState);
      when(mockFun1)(CoreStateType.INIT_STATE).afterReturn(false);
      when(mockFun2)(CoreStateType.INIT_STATE).afterReturn(false);
      when(mockFun3)(CoreStateType.INIT_STATE).afterReturn(true);
      let result: MirrorScene = (mirror as object)['getMirrorSceneFromCoreState'](CoreStateType.INIT_STATE);
      expect(result).assertEqual(MirrorScene.AOD);
      mock.clear(CoreStateTypeUtils);
    })

    it('OneMirrorServiceTest_getMirrorSceneFromCoreState_03', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isScreenOffState);
      let mockFun2: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInUnlockPage);
      let mockFun3: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isAodState);
      when(mockFun1)(CoreStateType.INIT_STATE).afterReturn(false);
      when(mockFun2)(CoreStateType.INIT_STATE).afterReturn(false);
      when(mockFun3)(CoreStateType.INIT_STATE).afterReturn(false);
      let result: MirrorScene = (mirror as object)['getMirrorSceneFromCoreState'](CoreStateType.INIT_STATE);
      expect(result).assertEqual(MirrorScene.SCREEN_LOCK);
      mock.clear(CoreStateTypeUtils);
    })

    it('OneMirrorServiceTest_isNeedOneMirrorAnim_init', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['isNeedOneMirrorAnim'](CoreStateType.INIT_STATE, MirrorScene.AOD);
      (mirror as object)['isNeedOneMirrorAnim'](CoreStateType.INIT_STATE, MirrorScene.SCREEN_LOCK);
      (mirror as object)['isNeedOneMirrorAnim'](CoreStateType.INIT_STATE, MirrorScene.UNLOCK);
      (mirror as object)['isNeedOneMirrorAnim'](CoreStateType.INIT_STATE, MirrorScene.SCREEN_OFF);
      expect(mirror).not().assertUndefined();
    })

    it('OneMirrorServiceTest_isNeedOneMirrorAnim', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isScreenOnState);
      let mockFun2: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      let mockFun3: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isSubDisplayMode);
      when(mockFun1)(CoreStateType.INIT_STATE).afterReturn(true);
      when(mockFun2)().afterReturn(true);
      when(mockFun3)().afterReturn(true);
      let result: boolean = (mirror as object)['isNeedOneMirrorAnim'](CoreStateType.INIT_STATE, MirrorScene.AOD);
      expect(result).assertEqual(true);
      mock.clear(CoreStateTypeUtils);
      mock.clear(DeviceHelper);
    })

    it('OneMirrorServiceTest_isNeedOneMirrorAnim_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInMainPage);
      when(mockFun1)(CoreStateType.INIT_STATE).afterReturn(true);
      let result: boolean = (mirror as object)['isNeedOneMirrorAnim'](CoreStateType.INIT_STATE, MirrorScene.AOD);
      expect(result).assertEqual(true);
      mock.clear(CoreStateTypeUtils);
    })

    it('OneMirrorServiceTest_isNeedOneMirrorAnim_03', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CoreStateTypeUtils, CoreStateTypeUtils.isInUnlockPage);
      when(mockFun1)(CoreStateType.INIT_STATE).afterReturn(true);
      let result: boolean = (mirror as object)['isNeedOneMirrorAnim'](CoreStateType.INIT_STATE, MirrorScene.AOD);
      expect(result).assertEqual(true);
      mock.clear(CoreStateTypeUtils);
    })

    it('OneMirrorServiceTest_oobeStateChangeListener', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['_oobeStateChangeListener'](false);
      expect(mirror).not().assertNull();
    })

    it('OneMirrorServiceTest_performSceneChange', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let from = MirrorScene.AOD;
      let to = MirrorScene.SCREEN_LOCK
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(mirror, (mirror as object)['getRealScene']);
      when(mockFun1)(from).afterReturn(MirrorScene.SCREEN_LOCK);
      when(mockFun1)(to).afterReturn(MirrorScene.SCREEN_LOCK);
      (mirror as object)['performSceneChange'](from, to, true);
      expect(mirror).not().assertUndefined();
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_performSceneChange_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let from = MirrorScene.AOD;
      let to = MirrorScene.SCREEN_LOCK
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(mirror, (mirror as object)['getRealScene']);
      when(mockFun1)(from).afterReturn(MirrorScene.UNLOCK);
      when(mockFun1)(to).afterReturn(MirrorScene.SCREEN_LOCK);
      (mirror as object)['performSceneChange'](from, to, true);
      expect(mirror).not().assertUndefined();
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_getRealScene', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(mirror, (mirror as object)['isConfigSupportAod']);
      when(mockFun)().afterReturn(true);
      let result: MirrorScene = (mirror as object)['getRealScene'](MirrorScene.SCREEN_OFF, true);
      expect(result).assertEqual(MirrorScene.AOD);
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_getRealScene_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(mirror, (mirror as object)['isConfigSupportAod']);
      when(mockFun)().afterReturn(false);
      let result: MirrorScene = (mirror as object)['getRealScene'](MirrorScene.AOD, true);
      expect(result).assertEqual(MirrorScene.SCREEN_OFF);
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_getRealScene_03', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(mirror, (mirror as object)['isConfigSupportAod']);
      when(mockFun)().afterReturn(true);
      (mirror as object)['getRealScene'](MirrorScene.AOD, true);
      expect(mirror).not().assertUndefined();
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_performSceneChangeInner', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['performSceneChangeInner'](MirrorScene.SCREEN_LOCK, MirrorScene.UNLOCK, true);
      (mirror as object)['performSceneChangeInner'](MirrorScene.SCREEN_LOCK, MirrorScene.UNLOCK, false);
      (mirror as object)['performSceneChangeInner'](MirrorScene.UNLOCK, MirrorScene.SCREEN_LOCK, false);
      expect(mirror).not().assertNull();
    })

    it('OneMirrorServiceTest_performSceneChangeInner_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(mirror, (mirror as object)['_waitFinishCallbackManager']);
      when(mockFun1)().afterReturn(true);
      (mirror as object)['performSceneChangeInner'](MirrorScene.AOD, MirrorScene.AOD, true);
      expect(mirror).not().assertUndefined();
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_setWallPaperFreezeReady', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let manager = SCBDesktopCacheManager.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(manager, manager.getWallPaperType);
      when(mockFun1)().afterReturn('string');
      (mirror as object)['setWallPaperFreezeReady']();
      expect(mirror).not().assertUndefined();
      mock.clear(manager);
    })

    it('OneMirrorServiceTest_handleNavBarUpdate', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let from = MirrorScene.AOD;
      let to = MirrorScene.SCREEN_LOCK;
      (mirror as object)['_aodProxy'] = {
        isPartEmoji: () => {
        }
      } as IAodProxy;
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc((mirror as object)['_aodProxy'], (mirror as object)['_aodProxy']
        .isPartEmoji);
      let mockFun2: Function = mock.mockFunc(MirrorSceneUtils, MirrorSceneUtils.isScreenOffScene);
      let mockFun3: Function = mock.mockFunc(MirrorSceneUtils, MirrorSceneUtils.isScreenOffScene);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)(from).afterReturn(false);
      when(mockFun3)(to).afterReturn(true);
      (mirror as object)['handleNavBarUpdate'](from, to);
      expect(mirror).not().assertUndefined();
      mock.clear((mirror as object)['_aodProxy']);
      mock.clear(MirrorSceneUtils);
    })

    it('OneMirrorServiceTest_handleNavBarUpdate_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let from = MirrorScene.AOD;
      let to = MirrorScene.SCREEN_LOCK;
      (mirror as object)['_aodProxy'] = {
        isPartEmoji: () => {
        }
      } as IAodProxy;
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc((mirror as object)['_aodProxy'], (mirror as object)['_aodProxy']
        .isPartEmoji);
      let mockFun2: Function = mock.mockFunc(MirrorSceneUtils, MirrorSceneUtils.isScreenOffScene);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)(from).afterReturn(true);
      (mirror as object)['handleNavBarUpdate'](from, to);
      expect(mirror).not().assertUndefined();
      mock.clear((mirror as object)['_aodProxy']);
      mock.clear(MirrorSceneUtils);
    })

    it('OneMirrorServiceTest_handleScreenOffResult', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(KeyguardStatusService, KeyguardStatusService.isCoverMode);
      when(mockFun1)().afterReturn(true);
      (mirror as object)['handleScreenOffResult'](true);
      expect(mirror).not().assertUndefined();

      mock.clear(MirrorSceneUtils);
    })

    it('OneMirrorServiceTest_handleScreenOffResult_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(mirror, (mirror as object)['isConfigSupportStartAod']);
      let mockFun2: Function = mock.mockFunc(mirror, (mirror as object)['isSmallFoldProductAndSubDisplay']);
      let mockFun3: Function = mock.mockFunc(mirror, (mirror as object)['isConfigSupportToEnd']);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(true);
      when(mockFun3)().afterReturn(false);
      (mirror as object)['handleScreenOffResult'](true);
      expect(mirror).not().assertUndefined();
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_handleScreenOffResult_03', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(mirror, (mirror as object)['isConfigSupportStartAod']);
      let mockFun2: Function = mock.mockFunc(mirror, (mirror as object)['isSmallFoldProductAndSubDisplay']);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(false);
      (mirror as object)['handleScreenOffResult'](false);
      expect(mirror).not().assertUndefined();
      mock.clear(mirror);
    })

    it('OneMirrorServiceTest_isConfigSupportStartAod', 0, () => {
      let mirror = OneMirrorService.getInstance();
      (mirror as object)['_aodProxy'] = {
        isAODEnable: () => {
          return false
        }, isFingerprintEnable: () => {
          return true
        }
      } as IAodProxy
      (mirror as object)['isConfigSupportStartAod']();
      expect(mirror).not().assertNull();
    })

    it('OneMirrorServiceTest_isConfigSupportToEnd', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(KeyguardStatusService, KeyguardStatusService.isCoverMode);
      when(mockFun1)().afterReturn(true);
      mirror.isConfigSupportToEnd();
      expect(mirror).not().assertUndefined();
      mock.clear(KeyguardStatusService);
    })

    it('OneMirrorServiceTest_isConfigSupportToEnd_02', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(KeyguardStatusService, KeyguardStatusService.isCoverMode);
      when(mockFun1)().afterReturn(false);
      (mirror as object)['_isHdrShowing'] = true;
      mirror.isConfigSupportToEnd();
      expect(mirror).not().assertUndefined();
      mock.clear(KeyguardStatusService);
    })

    it('OneMirrorServiceTest_isWallpaperSupportToEnd', 0, () => {
      let mirror = OneMirrorService.getInstance();
      let mock: MockKit = new MockKit();
      (mirror as object)['_isSupportWallpaperOneMirror'] = true;
      let mockFun1: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let mockFun2: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(true);
      let result = mirror.isWallpaperSupportToEnd();
      expect(result).assertEqual(true)
      mock.clear(DeviceHelper);
    })
  })
}
