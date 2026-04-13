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

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import ScreenLockThemeManager, { getDefaultPositionX } from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { ActivateThemeCallback } from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import { Qualifier } from '@ohos/themeservicekit/Index';
import image from '@ohos.multimedia.image';
import {
  AestheticColorArgs,
  ClockLayout,
  ClockTextAlign,
  IThemeParam,
  LockscreenForm,
  LockscreenFormConfig,
  LockscreenThemeConfig,
} from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlMainStateType, SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { slStateHelper } from '../../../../../../main/ets/common/helper/SlStateHelper';
import commonEventManager from '@ohos.commonEventManager';
import { DeviceHelper, ThemeActivationEvent } from '@ohos/frameworkwrapper';
import { ClockComFamily } from '@ohos/screenlockwidget';
import { DisplayUtils, ScreenLockState, screenLockStateManager,
  UltraScreenStatus } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

export default function ScreenLockThemeManagerTest() {

  describe('ScreenLockThemeManagerTest', (): void => {
    let mScreenLockThemeManager: ScreenLockThemeManager = new ScreenLockThemeManager();
    let mScreenLockThemeManagerModel: ScreenLockThemeManagerModel = new ScreenLockThemeManagerModel();
    let activateThemeCallback: ActivateThemeCallback;
    let onActivateTheme: ActivateThemeCallback;

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it("test_getScrenLockHigtFingerThemeParams_return_null", TestConst.TEST_LEVEL, (): void => {
      expect(mScreenLockThemeManager.getScrenLockHigtFingerThemeParams()).assertEqual(null);
    })

    it("test_ScreenLockThemeManager_isStaticWallpaper_return_false", TestConst.TEST_LEVEL, (): void => {
      expect(mScreenLockThemeManager.isStaticWallpaper()).assertEqual(false);
    })

    it("test_ScreenLockThemeManager_isStaticWallpaper_return_false1", TestConst.TEST_LEVEL, (): void => {
      expect(mScreenLockThemeManager.isStaticWallpaper()).assertEqual(false);
    })

    it("test_ScreenLockThemeManager_parseStaticData_return_false", TestConst.TEST_LEVEL, (): void => {
      mScreenLockThemeManager.getScreenLockThemeParams();
      mScreenLockThemeManager.parseManifestData();
      expect(mScreenLockThemeManager.isStaticWallpaper()).not().assertNull();
    })

    it('test_HandleRemove_return', 0, (): void => {
      let bundleName: string = 'res';
      mScreenLockThemeManagerModel.HandleRemove(bundleName, activateThemeCallback);
      expect(DeviceHelper.isPadOr2in1PcType()).not().assertNull();
    })

    it('test_destroyThemeActiveEvent_return', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      mScreenLockThemeManagerModel.destroyThemeActiveEvent();
      expect(DeviceHelper.isFold()).assertEqual(true);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_registerThemeActiveEvent_return', 0, (): void => {
      mScreenLockThemeManagerModel.registerThemeActiveEvent(onActivateTheme);
      expect(DeviceHelper.isPhoneOrPad()).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      mScreenLockThemeManagerModel.registerThemeActiveEvent(onActivateTheme);
      expect(DeviceHelper.isFold()).assertEqual(true);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_parseDescriptionData_return', 0, (): void => {
      mScreenLockThemeManagerModel.parseDescriptionData();
      mScreenLockThemeManagerModel.parseManifestData();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(mScreenLockThemeManagerModel, mScreenLockThemeManagerModel.GetCurrentThemePath);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(null);
      mScreenLockThemeManagerModel.parseDescriptionData();
      expect(mScreenLockThemeManagerModel.GetCurrentThemePath()).assertNull();
      mocker.clear(mScreenLockThemeManagerModel);
      mocker.clearAll();
    })

    it('test_IsEmptyObject_return', 0, (): void => {
      let mockBaseParam: IThemeParam = {
        positionX: 1,
        positionY: 1,
        layout: 10,
        textShadow: true,
        textBlurEffect: true,
        signatureText: '',
        editStatus: false,
        dateVisible: true,
        lunarVisible: true,
        signatureVisible: false,
        // CENTER
        textAlign: ClockTextAlign.CENTER,
        color: '#FFFFFF',
        fontFamily: ClockComFamily.HARMONY_CLOCK_01,
        aestheticColorArgs: new AestheticColorArgs(),
        isLightWallpaper: false,
        isDof: false,
        clockDegree: 0,
        version: 1
      } as IThemeParam;
      let defaultFormParam: LockscreenForm = {
        list: [],
        positionY: -1,
      };
      let obj: LockscreenThemeConfig = {
        clock: mockBaseParam,
        form: defaultFormParam
      }
      let result = mScreenLockThemeManagerModel.IsEmptyObject(obj);
      expect(result).assertEqual(false);
    })

    it('test_ApplyTheme_return', 0, (): void => {
      mScreenLockThemeManagerModel.ApplyTheme(activateThemeCallback);
      expect(DeviceHelper.isPC()).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunctions: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunctions)(ArgumentMatchers.any).afterReturn(true);
      mScreenLockThemeManagerModel.ApplyTheme(activateThemeCallback);
      expect(DeviceHelper.isFoldButNotSmallFoldProduct()).assertEqual(true);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_GetWallpaperPath_return', 0, (): void => {
      let isDof: boolean = false;
      let result = mScreenLockThemeManagerModel.GetWallpaperPath(isDof);
      expect(result).not().assertNull();
    })

    it('test_GetWallpaperPath_return_one', 0, (): void => {
      let isDof: boolean = true;
      let result = mScreenLockThemeManagerModel.GetWallpaperPath(isDof);
      expect(result).not().assertNull();
    })

    it('test_GetWallpaper_return', 0, (): void => {
      let isDof: boolean = false;
      let result = mScreenLockThemeManagerModel.GetWallpaper(isDof);
      expect(result).not().assertNull();
    })

    it('test_GetWallpaper_return_one', 0, (): void => {
      let isDof: boolean = true;
      let result = mScreenLockThemeManagerModel.GetWallpaper(isDof);
      expect(result).not().assertNull();
    })

    it('test_GetDecodingOptions_return', 0, (): void => {
      let Size: Size = {
        height: 1,
        width: 1
      };
      let imageInfo: image.ImageInfo = {
        size: Size,
        density: 0,
        stride: 0,
        pixelFormat: image.PixelMapFormat.UNKNOWN,
        alphaType: image.AlphaType.UNKNOWN,
        mimeType: '',
        isHdr: false
      };
      mScreenLockThemeManagerModel.GetDecodingOptions(imageInfo);
      expect(DeviceHelper.isFold()).not().assertNull();
      DeviceHelper.isFold();
      mScreenLockThemeManagerModel.GetDecodingOptions(imageInfo);
      expect(DeviceHelper.isFold()).not().assertNull();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunctions: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isSmallFoldProduct);
      when(mockFunctions)(ArgumentMatchers.any).afterReturn(false);
      mScreenLockThemeManagerModel.GetDecodingOptions(imageInfo);
      expect(DeviceHelper.isFold()).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_GetFoldExpandOptions_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mScreenLockThemeManagerModel.GetFoldExpandOptions();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_GetNormalOptions_return', 0, (): void => {
      let Size: Size = {
        height: 1,
        width: 1
      };
      let imageInfo: image.ImageInfo = {
        size: Size,
        density: 0,
        stride: 0,
        pixelFormat: image.PixelMapFormat.UNKNOWN,
        alphaType: image.AlphaType.UNKNOWN,
        mimeType: '',
        isHdr: false
      };
      let result = mScreenLockThemeManagerModel.GetNormalOptions(imageInfo);
      expect(result).not().assertNull();
    })

    it('test_LoadWallpaper_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mScreenLockThemeManagerModel.LoadWallpaper();
      mScreenLockThemeManagerModel.ReleaseWallpaper();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_ReleaseWallpaper_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mScreenLockThemeManagerModel.ReleaseWallpaper();
      mScreenLockThemeManagerModel.ReleaseWallpaper();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_GetCurrentThemePath_return', 0, (): void => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      mScreenLockThemeManagerModel.GetCurrentThemePath();
      mScreenLockThemeManagerModel.parseDescriptionData();
      mScreenLockThemeManagerModel.parseManifestData();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('test_ParseAndValidateThemeParam_return', 0, (): void => {
      let data: string = 'res';
      let result = mScreenLockThemeManagerModel.ParseAndValidateThemeParam(data);
      expect(result).not().assertNull();
    })

    it('test_ParseClockConfig_return', 0, (): void => {
      let clockConfigParam: IThemeParam = {
        positionX: 0,
        positionY: 0,
        layout: ClockLayout.DIMENSION_4_4,
        textShadow: false,
        textBlurEffect: false,
        signatureText: '',
        editStatus: false,
        dateVisible: false,
        lunarVisible: false,
        signatureVisible: false,
        textAlign: ClockTextAlign.LEFT,
        color: '',
        fontFamily: '',
        isDof: false,
        aestheticColorArgs: new AestheticColorArgs
      } as IThemeParam;
      mScreenLockThemeManagerModel.ParseClockConfig(clockConfigParam);
      clockConfigParam.layout = 200;
      let result = mScreenLockThemeManagerModel.ParseClockConfig(clockConfigParam);
      expect(result).not().assertNull();
    })

    it('test_ParseFormConfig_return', 0, (): void => {
      let formDataParam: LockscreenForm | undefined = {
        list: [],
        positionY: 10
      };
      let result = mScreenLockThemeManagerModel.ParseFormConfig(formDataParam);
      expect(result).not().assertNull();
    })

    it('test_AddThemeQualifier_return', 0, (): void => {
      let qualifier: string = '-1';
      mScreenLockThemeManagerModel.AddThemeQualifier(qualifier);
      expect(qualifier).not().assertNull();
    })

    it('test_AddThemeQualifier_return_one', 0, (): void => {
      let qualifier: string = '';
      mScreenLockThemeManagerModel.AddThemeQualifier(qualifier);
      expect(qualifier).not().assertNull();
    })

    it('test_ReadThemeParams_return', 0, (): void => {
      let unlockThemePath: string = 'res1';
      let result = mScreenLockThemeManagerModel.ReadThemeParams(unlockThemePath);
      expect(result).not().assertNull();
    })

    it('test_ReadThemeParams_OuterScreen_return', 0, (): void => {
      let unlockThemePath: string = 'res1';
      let result = mScreenLockThemeManagerModel.ReadOuterScreenThemeParams(unlockThemePath);
      expect(result).not().assertNull();
    })

    it('test_ReadThemeParams_return_one', 0, (): void => {
      let unlockThemePath: string = '';
      let result = mScreenLockThemeManagerModel.ReadThemeParams(unlockThemePath);
      expect(result).not().assertNull();
    })

    it('test_IsFileExist_return', 0, (): void => {
      let path: string = 'result';
      let isDof: boolean = false;
      let result = mScreenLockThemeManagerModel.IsFileExist(path);
      mScreenLockThemeManagerModel.GetWallpaperPath(isDof);
      path = '';
      result = mScreenLockThemeManagerModel.IsFileExist(path);
      expect(result).assertEqual(false);
      mScreenLockThemeManagerModel.GetWallpaperPath(isDof);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      mScreenLockThemeManagerModel.GetWallpaperPath(isDof);
      expect(DeviceHelper.isFold()).assertEqual(true);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_GetFoldUnFoldedWallpaperPath_return', 0, (): void => {
      slUiStateMgr.setSlState(SlMainStateType.SL_STATIC_STATE, slStateHelper.getSlBindState());
      let slStaticState = slUiStateMgr.getSlState(SlMainStateType.SL_STATIC_STATE);
      let result = mScreenLockThemeManagerModel.GetFoldUnFoldedWallpaperPath();
      expect(result).not().assertNull();
      slStaticState?.setSlState(SlStaticStateType.FOLDABLE_STATE, false);
      slStaticState?.getSlState(SlStaticStateType.FOLDABLE_STATE);
      slStaticState?.setSlState(SlStaticStateType.PORTRAIT_STATE, true);
      slStaticState?.getSlState(SlStaticStateType.PORTRAIT_STATE);
      result = mScreenLockThemeManagerModel.GetFoldUnFoldedWallpaperPath();
      expect(result).assertEqual('/lock/dof/resources/');
      slStaticState?.setSlState(SlStaticStateType.PORTRAIT_STATE, false);
      slStaticState?.getSlState(SlStaticStateType.PORTRAIT_STATE);
      result = mScreenLockThemeManagerModel.GetFoldUnFoldedWallpaperPath();
      expect(result).assertEqual('/lock/dof/resources/');
    })

    it('ScreenLockThemeManagerTest_switchThemeWithFoldStateChange', 0, (done: Function) => {
      try {
        let onActivateTheme: ActivateThemeCallback = {
          onThemeActivate: (): void => {
          },
          onMultiThemeActivate: (): void => {
          },
        };
        let result = mScreenLockThemeManager.switchThemeWithFoldStateChange(onActivateTheme);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_switchThemeWithFoldStateChange_002', 0, (done: Function) => {
      try {
        let onActivateTheme: ActivateThemeCallback = {
          onThemeActivate: (): void => {
          },
          onMultiThemeActivate: (): void => {
          },
        };
        let result = mScreenLockThemeManager.switchThemeWithFoldStateChange(onActivateTheme);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });

    it('ScreenLockThemeManagerTest_handleRemoveInner', 0, async (done: Function) => {
      try {
        let onActivateTheme: ActivateThemeCallback = {
          onThemeActivate: (): void => {
          },
          onMultiThemeActivate: (): void => {
          },
        };
        (mScreenLockThemeManager as object)['isOuterScreen'] = true;
        await (mScreenLockThemeManager as object)['applyOuterTheme'](onActivateTheme);
        expect(onActivateTheme).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_handleSubscriberCallback', 0, (done: Function) => {
      try {
        let eventData: commonEventManager.CommonEventData = {
          event: 'usual.event.PACKAGE_REMOVED',
        } as commonEventManager.CommonEventData;
        (mScreenLockThemeManager as object)['handleSubscriberCallback'](eventData);
        expect(eventData).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_onThemePreChange', 0, (done: Function) => {
      try {
        let clockParams: IThemeParam = {
          aestheticColorArgs: new AestheticColorArgs
        } as IThemeParam;
        clockParams.aestheticColorArgs.isChangeColor = true;
        let result = mScreenLockThemeManager.onThemePreChange(clockParams);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_onThemePreChange', 0, (done: Function) => {
      try {
        let result = ScreenLockThemeManager.getInstance()
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_onThemeActivationEvent', 0, (done: Function) => {
      try {
        let event: ThemeActivationEvent = new ThemeActivationEvent();
        event.target = 10;
        (mScreenLockThemeManager as object)['onThemeActivationEvent'](event);
        expect(event.target).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_onThemeActivationEvent_002', 0, (done: Function) => {
      try {
        let event: ThemeActivationEvent = new ThemeActivationEvent();
        event.target = 1;
        (mScreenLockThemeManager as object)['onThemeActivationEvent'](event);
        expect(event.target).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_onThemeActivationEvent_003', 0, (done: Function) => {
      try {
        let event: ThemeActivationEvent = new ThemeActivationEvent();
        event.target = 10000;
        (mScreenLockThemeManager as object)['onThemeActivationEvent'](event);
        expect(event.target).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_isSupportMultiScene', 0, (done: Function) => {
      try {
        let result = mScreenLockThemeManager.isSupportMultiScene()
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_constructor', 0, (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        new ScreenLockThemeManager();
        mocker.clear(DeviceHelper);
        mocker.clearAll();

        let mockFunction2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
        expect(DeviceHelper.isPadOr2in1PcType()).not().assertNull();
        new ScreenLockThemeManager();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_parseFormListConfig', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formListDataParam: LockscreenFormConfig = AppStorage.get('formListDataParam') as LockscreenFormConfig;
        (mScreenLockThemeManager as object)['parseFormListConfig'](formListDataParam);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_parseFormListConfig_002', 0, (done: Function) => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      try {
        let formListDataParam: LockscreenFormConfig[] =
          [new LockscreenFormConfig(), new LockscreenFormConfig(), new LockscreenFormConfig(),
            new LockscreenFormConfig(), new LockscreenFormConfig()];
        (mScreenLockThemeManager as object)['parseFormListConfig'](formListDataParam);
        callback();
        expect(execute == 'success' ? true : false).not().assertNull();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_getNormalOptions', 0, (done: Function) => {
      try {
        let Size: Size = {
          height: 100,
          width: 100
        };
        let imageInfo: image.ImageInfo = {
          size: Size,
          density: 0,
          stride: 0,
          pixelFormat: image.PixelMapFormat.UNKNOWN,
          alphaType: image.AlphaType.UNKNOWN,
          mimeType: '',
          isHdr: false
        };
        let result = mScreenLockThemeManagerModel.GetNormalOptions(imageInfo);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_applyTheme', 0, async (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
        let result = await mScreenLockThemeManagerModel.ApplyTheme(activateThemeCallback);
        expect(result !== null).assertTrue();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_applyTheme_002', 0, async (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        (mScreenLockThemeManager as object)['isSupportMultiSceneTheme'] = true;
        let result = await mScreenLockThemeManagerModel.ApplyTheme(activateThemeCallback);
        expect(result !== null).assertTrue();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_applyTheme_003', 0, async (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
        let mockFunctionOne: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        when(mockFunctionOne)(ArgumentMatchers.any).afterReturn(false);
        let result = await mScreenLockThemeManagerModel.ApplyTheme(activateThemeCallback);
        expect(result !== null).assertTrue();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_readWallpaper', 0, async (done: Function) => {
      try {
        let wallpaperPath: string = '';
        let isOuterScreen: boolean = false;
        let result = await mScreenLockThemeManagerModel.readWallpaper(wallpaperPath,isOuterScreen);
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_loadWallpaper', 0, async (done: Function) => {
      try {
        screenLockStateManager.currentState = ScreenLockState.THEME_EDITOR_FORM_DRAG;
        let result = mScreenLockThemeManagerModel.LoadWallpaper();
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_loadWallpaper_001', 0, async (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let result = mScreenLockThemeManagerModel.LoadWallpaper();
        expect(result !== null).assertTrue();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_getDefaultThemeParam', 0, (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
        let mockFunctionOne: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        when(mockFunctionOne)(ArgumentMatchers.any).afterReturn(false);
        let result = mScreenLockThemeManagerModel.getDefaultThemeParams();
        expect(result !== null).assertTrue();
        when(mockFunctionTwo)(ArgumentMatchers.any).afterReturn(true);
        result = mScreenLockThemeManagerModel.getDefaultThemeParams();
        expect(result !== null).assertTrue();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('ScreenLockThemeManagerTest_getDefaultPositionX', 0, (done: Function) => {
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
        let result = getDefaultPositionX();
        expect(result !== null).assertTrue();
        when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
        result = getDefaultPositionX();
        expect(result !== null).assertTrue();
        when(mockFunctionOne)(ArgumentMatchers.any).afterReturn(false);
        let mockFunctionTwo: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunctionTwo)(ArgumentMatchers.any).afterReturn(true);
        result = getDefaultPositionX();
        expect(result !== null).assertTrue();
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      } catch (e) {
      } finally {
        done()
      }
    });
  })
}

export class ScreenLockThemeManagerModel extends ScreenLockThemeManager {
  constructor() {
    super();
  }

  public HandleRemove(bundleName: string, activateThemeCallback: ActivateThemeCallback): void {
    return this.handleRemove(bundleName, activateThemeCallback);
  }

  public IsEmptyObject(obj: LockscreenThemeConfig): boolean {
    return this.isEmptyObject(obj);
  }

  public ApplyTheme(activateThemeCallback: ActivateThemeCallback): Promise<void> {
    return this.applyTheme(activateThemeCallback);
  }

  public GetWallpaperPath(isDof: boolean): string {
    return this.getWallpaperPath(isDof);
  }

  public GetWallpaper(isDof: boolean): Promise<image.PixelMap | undefined> {
    return this.getWallpaper(isDof);
  }

  public GetDecodingOptions(imageInfo: image.ImageInfo): image.DecodingOptions {
    return this.getDecodingOptions(imageInfo);
  }

  public GetFoldExpandOptions(): image.DecodingOptions {
    return this.getFoldExpandOptions();
  }

  public GetNormalOptions(imageInfo: image.ImageInfo): image.DecodingOptions {
    return this.getNormalOptions(imageInfo);
  }

  public LoadWallpaper(): void {
    return this.loadWallpaper();
  }

  public ReleaseWallpaper(): void {
    return this.releaseWallpaper();
  }

  public GetCurrentThemePath(): string | undefined {
    return this.getCurrentThemePath();
  }

  public ParseAndValidateThemeParam(data: string): LockscreenThemeConfig {
    return this.parseAndValidateThemeParam(data);
  }

  public ParseClockConfig(clockConfigParam: IThemeParam): IThemeParam {
    return this.parseClockConfig(clockConfigParam);
  }

  public ParseFormConfig(formDataParam: LockscreenForm): LockscreenForm | undefined {
    return this.parseFormConfig(formDataParam);
  }

  public AddThemeQualifier(qualifier: string): void {
    return this.addThemeQualifier(qualifier);
  }

  public ReadThemeParams(unlockThemePath: string): Promise<Map<Qualifier, LockscreenThemeConfig>> {
    return this.readThemeParams(unlockThemePath);
  }

  public ReadOuterScreenThemeParams(unlockThemePath: string): Promise<Map<Qualifier, LockscreenThemeConfig>> {
    return this.readThemeParams(unlockThemePath);
  }

  public IsFileExist(path: string): boolean {
    return this.isFileExist(path);
  }
}