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

import {
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { AodLayerProvider } from '@ohos/aod/src/main/ets/theme/layerprovider/AodLayerProvider';
import { IAodTaskContext, AodStatus, IAodMoveData } from '@ohos/aod/src/main/ets/model/AodModel';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import aodThemeManager from '@ohos/aod/src/main/ets/theme/AodThemeManager';
import { ComponentRect } from '@ohos/aod/src/main/ets/model/ComponentModel';
import fs from '@ohos.file.fs';
import { IAodApplyStyleInfo } from '@ohos/aod/src/main/ets/model/AodThemeConfig';
import aodBatteryModule from '@ohos/aod/src/main/ets/module/AodBatteryModule';
import { AodViewModel, OuterClockParam } from '@ohos/aod/src/main/ets/theme/viewmodel/AodViewModel';
import AodHardwareConfig from '@ohos/screenlockcommon/src/main/ets/aod/config/AodHardwareConfig';
import {
  AodDisplayScreen,
  AodOperate,
  AodState,
  AodSwitchType
} from '@ohos/aod/src/main/ets/model/AodConfigModel';
import { AodConstants } from '@ohos/aod/src/main/ets/model/AodConstants';
import {
  AodLayerProviderOuterDigitalClock
} from '@ohos/aod/src/main/ets/theme/layerprovider/AodLayerProviderOuterDigitalClock';
import aodSettingsModule from '@ohos/aod/src/main/ets/module/AodSettingsModule';
import { AodUtil } from '@ohos/aod/src/main/ets/utils/AodUtil';
import { AodOuterUtil } from '@ohos/aod/src/main/ets/utils/AodOuterUtil';
import aod from '@ohos/aod/src/main/ets/adapter/AodAdapter';
import {
  AodViewControllerOuterDigitalClock
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerOuterDigitalClock';
import { AodDisplayMode } from '@ohos/aodcommon';

const AOD_OPEN_STATE: AodState = {
  switch: AodSwitchType.OPEN,
  displayMode: AodDisplayMode.INTELLIGENT_SHOW,
  startHour: AodConstants.DEFAULT_START_HOUR,
  startMinute: AodConstants.DEFAULT_MINUTE,
  endHour: AodConstants.DEFAULT_END_HOUR,
  endMinute: AodConstants.DEFAULT_MINUTE,
  displayScreen: AodDisplayScreen.OUTER,
  aodOperate: AodOperate.USER,
}

const AOD_CLOSE_STATE: AodState = {
  switch: AodSwitchType.CLOSE,
  displayMode: AodDisplayMode.INTELLIGENT_SHOW,
  startHour: AodConstants.DEFAULT_START_HOUR,
  startMinute: AodConstants.DEFAULT_MINUTE,
  endHour: AodConstants.DEFAULT_END_HOUR,
  endMinute: AodConstants.DEFAULT_MINUTE,
  displayScreen: AodDisplayScreen.OUTER,
  aodOperate: AodOperate.USER,
}

export function AodLayerProviderOuterDigitalClockTest() {
  describe('AodLayerProviderOuterDigitalClockTest', () => {
    beforeEach((): void => {
      let contextInit: IAodTaskContext = {
        layers: [],
        triggers: [],
        isFingerprintEnable: true,
        isShowAodContent: false,
        status: AodStatus.INITIAL,
        isFirstStart: true,
        isFailed: false,
        screenStatus: 0,
      };
      AodLayerProvider.setContext(contextInit);
      AodLayerProvider.setViewController(AodViewControllerOuterDigitalClock.getInstance());
    });

    it('should_have_only_one_instance_when_call_any_times_getInstance', 0, () => {
      const instance0 = AodLayerProviderOuterDigitalClock.getInstance();
      const instance1 = AodLayerProviderOuterDigitalClock.getInstance();

      expect(instance0).assertDeepEquals(instance1);
    });

    it('test_setClockImage', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodLayerProvider, 'setDigitalClockImage');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setClockNumberImage');
      await aodLayerProvider.setClockImageTest();
      const context = aodLayerProvider.context;
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_setClockTrigger', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodLayerProvider, 'setDigitalClockTrigger');
      aodLayerProvider.setClockTriggerTest();
      const context = aodLayerProvider.context;
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_setBackgroundImage', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodLayerProvider, 'getBackgroundImage');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAndReleaseImage');
      MockUtil.mockFuncForObj(aodLayerProvider, 'updateContext');
      await aodLayerProvider.setBackgroundImageTest();
      const context = aodLayerProvider.context;
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_setBackgroundTrigger', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodLayerProvider, 'addStartTrigger');
      MockUtil.mockFuncForObj(aodLayerProvider, 'addProximityLightTrigger');
      MockUtil.mockFuncForObj(aodSettingsModule, 'isIntelligentMode', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addLightlyTouchTrigger');
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      let action: aod.ScreenOnTimeoutAction = {
        actionType: aod.ActionType.SCREEN_ON_TIMEOUT,
        timeout: AodConstants.SCREEN_ON_ALWAYS,
      };
      let funcImpl = (): aod.ScreenOnTimeoutAction[] => {
        return [action];
      };
      MockUtil.mockFuncForObj(aodLayerProvider, 'getBackgroundTrigger', funcImpl);
      aodLayerProvider.setBackgroundTriggerTest();
      const context = aodLayerProvider.context;
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_setBackgroundTrigger_1', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodLayerProvider, 'addStartTrigger');
      MockUtil.mockFuncForObj(aodLayerProvider, 'addProximityLightTrigger');
      MockUtil.mockFuncForObj(aodSettingsModule, 'isIntelligentMode', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      let aodMoveData: IAodMoveData = {
        minRange: {
          x: 0,
          y: 0,
        },
        maxRange: {
          x: 0,
          y: 0,
        },
        moveDirect: {
          x: 0,
          y: 0,
        },
      };
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getLayerMoveData',
        (componentRect: ComponentRect): IAodMoveData => {
          return aodMoveData;
        });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addAbiTrigger');
      let action: aod.ScreenOnTimeoutAction = {
        actionType: aod.ActionType.SCREEN_ON_TIMEOUT,
        timeout: AodConstants.SCREEN_ON_ALWAYS,
      };
      let funcImpl = (): aod.ScreenOnTimeoutAction[] => {
        return [action];
      };
      MockUtil.mockFuncForObj(aodLayerProvider, 'getBackgroundTrigger', funcImpl);
      aodLayerProvider.setBackgroundTriggerTest();
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', () => {
        return true;
      });
      aodLayerProvider.setBackgroundTriggerTest();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_setBackgroundTrigger_2', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodSettingsModule, 'getAodState', (): AodState => {
        return AOD_OPEN_STATE;
      });
      aodSettingsModule.init();
      MockUtil.mockFuncForObj(aodSettingsModule, 'isIntelligentMode', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addStartTrigger');
      MockUtil.mockFuncForObj(aodLayerProvider, 'addProximityLightTrigger');
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      let aodMoveData: IAodMoveData = {
        minRange: {
          x: 0,
          y: 0,
        },
        maxRange: {
          x: 0,
          y: 0,
        },
        moveDirect: {
          x: 0,
          y: 0,
        },
      };
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getLayerMoveData',
        (componentRect: ComponentRect): IAodMoveData => {
          return aodMoveData;
        });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addAbiTrigger');
      let action: aod.ScreenOnTimeoutAction = {
        actionType: aod.ActionType.SCREEN_ON_TIMEOUT,
        timeout: AodConstants.SCREEN_ON_ALWAYS,
      };
      let funcImpl = (): aod.ScreenOnTimeoutAction[] => {
        return [action];
      };
      aodLayerProvider.setBackgroundTriggerTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });


    it('test_setBackgroundTrigger_3', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodSettingsModule, 'getAodState', (): AodState => {
        return AOD_OPEN_STATE;
      });
      aodSettingsModule.init();
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addStartTrigger');
      MockUtil.mockFuncForObj(aodLayerProvider, 'addProximityLightTrigger');
      MockUtil.mockFuncForObj(aodSettingsModule, 'isIntelligentMode', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      let aodMoveData: IAodMoveData = {
        minRange: {
          x: 0,
          y: 0,
        },
        maxRange: {
          x: 0,
          y: 0,
        },
        moveDirect: {
          x: 0,
          y: 0,
        },
      };
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getLayerMoveData',
        (componentRect: ComponentRect): IAodMoveData => {
          return aodMoveData;
        });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addAbiTrigger');
      let action: aod.ScreenOnTimeoutAction = {
        actionType: aod.ActionType.SCREEN_ON_TIMEOUT,
        timeout: AodConstants.SCREEN_ON_ALWAYS,
      };
      aodLayerProvider.setBackgroundTriggerTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });

    it('test_setBackgroundTrigger_4', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodSettingsModule, 'getAodState', (): AodState => {
        return AOD_CLOSE_STATE;
      });
      aodSettingsModule.init();
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addStartTrigger');
      MockUtil.mockFuncForObj(aodLayerProvider, 'addProximityLightTrigger');
      MockUtil.mockFuncForObj(aodSettingsModule, 'isIntelligentMode', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      let aodMoveData: IAodMoveData = {
        minRange: {
          x: 0,
          y: 0,
        },
        maxRange: {
          x: 0,
          y: 0,
        },
        moveDirect: {
          x: 0,
          y: 0,
        },
      };
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getLayerMoveData',
        (componentRect: ComponentRect): IAodMoveData => {
          return aodMoveData;
        });
      MockUtil.mockFuncForObj(aodLayerProvider, 'addAbiTrigger');
      let action: aod.ScreenOnTimeoutAction = {
        actionType: aod.ActionType.SCREEN_ON_TIMEOUT,
        timeout: AodConstants.SCREEN_ON_ALWAYS,
      };
      aodLayerProvider.setBackgroundTriggerTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });

    it('test_setOnGoingNtfLayerTest', 0, () => {
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.setOnGoingNtfLayerTest();
      const context = aodLayerProvider.context;
      expect(context.layers.length).not().assertEqual(0);
    });

    it('test_setForeground', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.setForegroundTest();
      expect(true).assertTrue();
      done();
    });

    it('test_configureLayers', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      let img: aod.Image = {
        imageType: aod.ImageType.BACKGROUND,
        imageSrc: [],
        isDarken: false,
      };
      let funcImpl = (): aod.Image => {
        return img;
      };
      MockUtil.mockFuncForObj(aodLayerProvider, 'getBackgroundImage', funcImpl);
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getOnGoingNtfImages');
      MockUtil.mockFuncForObj(aodLayerProvider, 'getBackgroundTrigger');
      AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = true;
      MockUtil.mockFuncForObj(AodViewControllerOuterDigitalClock.getInstance(), 'isLayoutCenter', () => {
        return false;
      });
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', () => {
        return false;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAndReleaseImage');
      try {
        await aodLayerProvider.configureLayersTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      aodLayerProvider.updateIsShowAodContent(true)
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', () => {
        return true;
      });
      try {
        await aodLayerProvider.configureLayersTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = false;
      try {
        await aodLayerProvider.configureLayersTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = true;
      MockUtil.mockFuncForObj(AodViewControllerOuterDigitalClock.getInstance(), 'isLayoutCenter', () => {
        return true;
      });
      try {
        await aodLayerProvider.configureLayersTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = false;
      MockUtil.clearAll();
      done();
    });

    it('test_setOnGoingNtfImage', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getOnGoingNtfImages');
      try {
        await aodLayerProvider.setOnGoingNtfImageTest();
      } catch (e) {
        expect(false).assertFalse();
      }
      MockUtil.clearAll();
      done();
    });

    it('test_setDigitalClockTrigger', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      let aodMoveData: IAodMoveData = {
        minRange: {
          x: 0,
          y: 0,
        },
        maxRange: {
          x: 0,
          y: 0,
        },
        moveDirect: {
          x: 0,
          y: 0,
        },
      };
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getLayerMoveData',
        (componentRect: ComponentRect): IAodMoveData => {
          return aodMoveData;
        });
      aodLayerProvider.updateIsShowAodContent(false);
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return false;
      });
      aodLayerProvider.setDigitalClockTriggerTest();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      aodLayerProvider.setDigitalClockTriggerTest();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_setOnGoingNtfTrigger', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return false;
      });
      aodLayerProvider.setOnGoingNtfTriggerTest();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(AodHardwareConfig, 'isSupportGlance', (): boolean => {
        return true;
      });
      aodLayerProvider.setOnGoingNtfTriggerTest();
      expect(true).assertTrue();
      MockUtil.clearAll();
      done();
    });

    it('test_setOnGoingNtfTrigger1', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return false;
      });
      aodLayerProvider.setOnGoingNtfTriggerTest();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(AodHardwareConfig, 'isSupportGlance', (): boolean => {
        return false;
      });
      aodLayerProvider.setOnGoingNtfTriggerTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationTrigger', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', () => {
        return true;
      });
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aodSettingsModule, aodSettingsModule.getAodState);
      when(mockFunc)().afterReturn({ switch: 1 });
      aodLayerProvider.setAnimationTriggerTest();
      when(mockFunc)().afterReturn({ switch: 0 });
      aodLayerProvider.setAnimationTriggerTest();
      expect(true).assertTrue();
      mocker.clear(aodSettingsModule);
      mocker.clearAll();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationTrigger1', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', () => {
        return true;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      aodLayerProvider.setAnimationTriggerTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationTrigger2', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      MockUtil.mockFuncForObj(AodOuterUtil, 'checkOuterWallpaperDisplaySwitchOpen', () => {
        return false;
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'needLightlyTouchTrigger', (): boolean => {
        return true;
      });
      const viewController = AodViewControllerOuterDigitalClock.getInstance();
      MockUtil.mockFuncForObj(viewController, 'isIntelligentMode', (): boolean => {
        return true;
      });
      aodLayerProvider.setAnimationTriggerTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationRes', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      const applyInfo: IAodApplyStyleInfo = {
        styleName: '',
        absolutePath: '',
        animations: [
          {
            prefix: 'prefix',
            frame: 1
          }
        ]
      };

      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(aodBatteryModule, aodBatteryModule.isCharging);
      let mockFunc2: Function = mocker.mockFunc(aodBatteryModule, aodBatteryModule.isLowerStatus);
      let mockFunc3: Function = mocker.mockFunc(AodUtil, AodUtil.isPlayMusic);
      try {
        AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = true;
        aodLayerProvider.setAnimationResTest(applyInfo);
        AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = false;
        when(mockFunc1)().afterReturn(true);
        aodLayerProvider.setAnimationResTest(applyInfo);
        when(mockFunc1)().afterReturn(false);
        when(mockFunc2)().afterReturn(true);
        aodLayerProvider.setAnimationResTest(applyInfo);
        when(mockFunc2)().afterReturn(false);
        when(mockFunc3)().afterReturn(true);
        aodLayerProvider.setAnimationResTest(applyInfo);
        when(mockFunc3)().afterReturn(false);
        aodLayerProvider.setAnimationResTest(applyInfo);
      } catch (e) {
        expect(false).assertFalse();
      }
      mocker.clear(aodBatteryModule);
      mocker.clear(AodUtil);
      mocker.clearAll();
      done();
    });

    it('test_setAnimationRes1', 0, async (done: Function) => {
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      const applyInfo: IAodApplyStyleInfo = {
        styleName: '',
        absolutePath: '',
        animations: [
          {
            prefix: 'prefix',
            frame: 1
          }
        ]
      };
      try {
        let aodViewModel = new AodViewModel();
        let outerClockParam = new OuterClockParam();
        aodViewModel.updateOuterThemeParam(aodThemeManager.getAodManifest(), outerClockParam);
        let animationMap: Map<string, number> = new Map();
        animationMap.set('', 0);
        outerClockParam.animationMap = animationMap;
        aodViewModel.aodThemeParam = outerClockParam;

        AodViewControllerOuterDigitalClock.getInstance().setAodViewModel(aodViewModel);
        MockUtil.mockFuncForObj(aod.setAnimationRes, 'aod.setAnimationRes', (): Promise<number> | number => {
          return 1;
        });
        await aodLayerProvider.setAnimationResTest(applyInfo);
      } catch (e) {
        expect(aodLayerProvider).not().assertNull();
      }
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationRes2', 0, async (done: Function) => {
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      const applyInfo: IAodApplyStyleInfo = {
        styleName: '',
        absolutePath: '',
        animations: [
          {
            prefix: 'prefix',
            frame: 1
          }
        ]
      };
      try {
        let aodViewModel = new AodViewModel();
        let outerClockParam = new OuterClockParam();
        aodViewModel.updateOuterThemeParam(aodThemeManager.getAodManifest(), outerClockParam);
        let animationMap: Map<string, number> = new Map();
        animationMap.set('', 0);
        outerClockParam.animationMap = animationMap;
        aodViewModel.aodThemeParam = outerClockParam;

        AodViewControllerOuterDigitalClock.getInstance().setAodViewModel(aodViewModel);
        MockUtil.mockFuncForObj(aod.setAnimationRes, 'aod.setAnimationRes', (): Promise<number> | number => {
          return 0;
        });
        await aodLayerProvider.setAnimationResTest(applyInfo);
      } catch (e) {
        expect(aodLayerProvider).not().assertNull();
      }
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationRes3', 0, async (done: Function) => {
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      const applyInfo: IAodApplyStyleInfo = {
        styleName: '',
        absolutePath: '',
        animations: [
          {
            prefix: 'prefix',
            frame: 1
          }
        ]
      };
      try {
        AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = false;
        MockUtil.mockFuncForObj(aodBatteryModule, 'isCharging', (): boolean => {
          return false;
        });
        MockUtil.mockFuncForObj(aodBatteryModule, 'isWarnToLowerStatus', (): boolean => {
          return false;
        });
        MockUtil.mockFuncForObj(AodUtil, 'isPlayMusic', (): boolean => {
          return true;
        });
        await aodLayerProvider.setAnimationResTest(applyInfo);
      } catch (e) {
        expect(aodLayerProvider).not().assertNull();
      }
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationRes4', 0, async (done: Function) => {
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      const applyInfo: IAodApplyStyleInfo = {
        styleName: '',
        absolutePath: '',
        animations: [
          {
            prefix: 'prefix',
            frame: 1
          }
        ]
      };
      AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = false;
      MockUtil.mockFuncForObj(aodBatteryModule, 'isCharging', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(aodBatteryModule, 'isWarnToLowerStatus', (): boolean => {
        return false;
      });
      MockUtil.mockFuncForObj(AodUtil, 'isPlayMusic', (): boolean => {
        return false;
      });
      let aodViewModel = new AodViewModel();
      let outerClockParam = new OuterClockParam();
      aodViewModel.updateOuterThemeParam(aodThemeManager.getAodManifest(), outerClockParam);
      aodViewModel.aodThemeParam = outerClockParam;
      AodViewControllerOuterDigitalClock.getInstance().setAodViewModel(aodViewModel);

      await aodLayerProvider.setAnimationResTest(applyInfo);
      expect(aodLayerProvider).not().assertNull();

      MockUtil.clearAll();
      done();
    });

    it('test_setAnimationRes5', 0, async (done: Function) => {
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      const applyInfo: IAodApplyStyleInfo = {
        styleName: '',
        absolutePath: ''
      };
      try {
        AodViewControllerOuterDigitalClock.getInstance().hasOnGoingNtf = false;
        MockUtil.mockFuncForObj(aodBatteryModule, 'isCharging', (): boolean => {
          return false;
        });
        MockUtil.mockFuncForObj(aodBatteryModule, 'isWarnToLowerStatus', (): boolean => {
          return false;
        });
        MockUtil.mockFuncForObj(AodUtil, 'isPlayMusic', (): boolean => {
          return false;
        });
        let aodViewModel = new AodViewModel();
        let outerClockParam = new OuterClockParam();
        aodViewModel.updateOuterThemeParam(aodThemeManager.getAodManifest(), outerClockParam);
        aodViewModel.aodThemeParam = outerClockParam;
        AodViewControllerOuterDigitalClock.getInstance().setAodViewModel(aodViewModel);

        await aodLayerProvider.setAnimationResTest(applyInfo);
      } catch (e) {
        expect(aodLayerProvider).not().assertNull();
      }

      MockUtil.clearAll();
      done();
    });


    it('test_setAnimation1', 0, async (done: Function) => {
      MockUtil.mockFuncForObj(AodOuterUtil, 'needShowOuterAodWallpaper', (): boolean => {
        return true;
      });
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.context.isShowAodContent = false;
      await aodLayerProvider.setAnimationTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimation2', 0, async (done: Function) => {
      MockUtil.mockFuncForObj(AodOuterUtil, 'needShowOuterAodWallpaper', (): boolean => {
        return true;
      });
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.context.isShowAodContent = true;
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAodApplyStyleInfo', (): IAodApplyStyleInfo => {
        return {
          styleName: '',
          absolutePath: ''
        };
      });
      await aodLayerProvider.setAnimationTest();
      expect(aodLayerProvider).not().assertNull();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimation3', 0, async (done: Function) => {
      MockUtil.mockFuncForObj(AodOuterUtil, 'needShowOuterAodWallpaper', (): boolean => {
        return true;
      });
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.context.isShowAodContent = true;
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAodApplyStyleInfo', (): IAodApplyStyleInfo => {
        return {
          styleName: '',
          absolutePath: '',
          animations: [
            {
              prefix: '',
              frame: 0
            }
          ]
        };
      });
      await aodLayerProvider.setAnimationTest();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimation4', 0, async (done: Function) => {
      MockUtil.mockFuncForObj(AodOuterUtil, 'needShowOuterAodWallpaper', (): boolean => {
        return true;
      });
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.context.isShowAodContent = true;
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAodApplyStyleInfo', (): IAodApplyStyleInfo => {
        return {
          styleName: '',
          absolutePath: '',
          animations: [
            {
              prefix: 'prefix',
              frame: 1
            }
          ]
        };
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationRes');
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAnimationRect');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationLayer');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationTrigger');

      MockUtil.mockFuncForObj(fs.accessSync, 'fs.accessSync', (): boolean => {
        return true;
      });
      await aodLayerProvider.setAnimationTest();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimation5', 0, async (done: Function) => {
      MockUtil.mockFuncForObj(AodOuterUtil, 'needShowOuterAodWallpaper', (): boolean => {
        return true;
      });
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.context.isShowAodContent = true;
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAodApplyStyleInfo', (): IAodApplyStyleInfo => {
        return {
          styleName: '',
          absolutePath: '',
          animations: [
            {
              prefix: 'prefix',
              frame: 1
            }
          ]
        };
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationRes');
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAnimationRect');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationLayer');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationTrigger');
      MockUtil.mockFuncForObj(fs.accessSync, 'fs.accessSync', (): boolean => {
        return false;
      });
      await aodLayerProvider.setAnimationTest();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimation6', 0, async (done: Function) => {
      MockUtil.mockFuncForObj(AodOuterUtil, 'needShowOuterAodWallpaper', (): boolean => {
        return true;
      });
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.context.isShowAodContent = true;
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAodApplyStyleInfo', (): IAodApplyStyleInfo => {
        return {
          styleName: '',
          absolutePath: '',
          animations: [
            {
              prefix: 'prefix',
              frame: 1
            }
          ]
        };
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationRes');
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAnimationRect');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationLayer');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationTrigger');
      let access = fs.accessSync('');
      expect(access).assertFalse();
      await aodLayerProvider.setAnimationTest();
      MockUtil.clearAll();
      done();
    });

    it('test_setAnimation7', 0, async (done: Function) => {
      MockUtil.mockFuncForObj(AodOuterUtil, 'needShowOuterAodWallpaper', (): boolean => {
        return true;
      });
      const aodLayerProvider: AodLayerProviderDigitalClockTestClass = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.context.isShowAodContent = true;
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAodApplyStyleInfo', (): IAodApplyStyleInfo => {
        return {
          styleName: '',
          absolutePath: '',
          animations: [
            {
              prefix: 'prefix',
              frame: 1
            }
          ]
        };
      });
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationRes');
      MockUtil.mockFuncForObj(aodLayerProvider.viewController, 'getAnimationRect');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationLayer');
      MockUtil.mockFuncForObj(aodLayerProvider, 'setAnimationTrigger');
      let access = fs.accessSync(aodThemeManager.getCurrentThemePath(false));
      expect(access).assertTrue();

      await aodLayerProvider.setAnimationTest();
      MockUtil.clearAll();
      done();
    });

    it('test_setBackground', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(AodOuterUtil, AodOuterUtil.checkOuterWallpaperDisplaySwitchOpen);
      let mockFunc2: Function = mocker.mockFunc(aodSettingsModule, aodSettingsModule.getAodState);
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      when(mockFunc1)().afterReturn(false);
      aodLayerProvider.setBackgroundTest();
      when(mockFunc1)().afterReturn(true);
      when(mockFunc2)().afterReturn({ switch: 1 });
      aodLayerProvider.setBackgroundTest();
      mocker.clear(AodUtil);
      mocker.clear(aodSettingsModule);
      mocker.clearAll();
      done();
    });

    it('test_setAnimationLayer', 0, async (done: Function) => {
      const aodLayerProvider = new AodLayerProviderDigitalClockTestClass();
      aodLayerProvider.setAnimationLayerTest({
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
      });
      done();
    });
  });

  class AodLayerProviderDigitalClockTestClass extends AodLayerProviderOuterDigitalClock {
    constructor() {
      super();
    }

    public async setForegroundTest(): Promise<void> {
      await this.setForeground();
    }

    public async configureLayersTest(): Promise<void> {
      await this.configureLayers();
    }

    public async setClockImageTest(): Promise<void> {
      await this.setClockImage();
    }

    public setClockTriggerTest(): void {
      this.setClockTrigger();
    }

    public async setBackgroundImageTest(): Promise<void> {
      await this.setBackgroundImage();
    }

    public setBackgroundTriggerTest(): void {
      this.setBackgroundTrigger();
    }

    public async setOnGoingNtfImageTest(): Promise<void> {
      await this.setOnGoingNtfImage();
    }

    public setOnGoingNtfLayerTest(): void {
      this.setOnGoingNtfLayer();
    }

    public setOnGoingNtfTriggerTest(): void {
      this.setOnGoingNtfTrigger();
    }

    public setDigitalClockTriggerTest(): void {
      this.setDigitalClockTrigger();
    }

    public setAnimationTriggerTest(): void {
      this.setAnimationTrigger();
    }

    public async setAnimationResTest(applyInfo: IAodApplyStyleInfo): Promise<void> {
      await this.setAnimationRes(applyInfo);
    }

    public async setAnimationTest(): Promise<void> {
      await this.setAnimation();
    }

    public async setBackgroundTest(): Promise<void> {
      await this.setBackground();
    }

    public setAnimationLayerTest(animationRect: ComponentRect): void {
      this.setAnimationLayer(animationRect);
    }

    public updateIsShowAodContent(isShowAodContent: boolean): void {
      let newContext: IAodTaskContext = {
        layers: [],
        triggers: [],
        isFingerprintEnable: true,
        isShowAodContent: isShowAodContent,
        status: AodStatus.INITIAL,
        isFirstStart: true,
        isFailed: false,
        screenStatus: 0,
      };
      AodLayerProvider.setContext(newContext);
    }
  }
}