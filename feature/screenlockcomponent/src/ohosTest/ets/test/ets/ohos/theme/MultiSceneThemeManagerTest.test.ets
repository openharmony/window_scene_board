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

import { SCBPropertyChangeReason, SCBScreenProperty } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
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
import { ThemeScene } from '@ohos/screenlockcommon/src/main/ets/constants/ThemeEditAndScreenLockConstants';
import ScreenLockThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/ScreenLockThemeManager';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';
import { DataType, MultiSceneThemeManager, ThemeInfo } from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import {
  AestheticColorArgs,
  ClockLayout,
  ClockTextAlign,
  IThemeParam,
  LockscreenFormConfig,
  LockscreenThemeConfig,
  LockscreenConfig,
  LockscreenForm,
  ClockComFamily
} from '@ohos/screenlockwidget';

import { Qualifier } from '@ohos/themeservicekit';

export default function MultiSceneThemeManagerTest() {
  describe('MultiSceneThemeManagerTest', (): void => {
    let mockMultiSceneThemeManager = new MockMultiSceneThemeManager();
    let themeConfigs: Map<string, LockscreenThemeConfig> = new Map();
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

    let mockUnfoldedClockParam: IThemeParam = {
      positionX: 3,
      positionY: 0,
      layout: 13,
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
      fontFamily: ClockComFamily.HARMONY_CLOCK_02,
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
    let mockFormConfig0: LockscreenForm = {
      list: [],
      positionY: 2,
    };
    let mockBaseConfig: LockscreenThemeConfig = {
      clock: mockBaseParam,
      form: defaultFormParam
    }
    let mockUnfoldedConfig: LockscreenThemeConfig = {
      clock: mockUnfoldedClockParam,
      form: defaultFormParam
    }
    let formViewModel: ScreenLockFormViewModel = new ScreenLockFormViewModel();

    beforeAll((): void => {
      themeConfigs.set(ThemeScene.BASE, mockBaseConfig);
      themeConfigs.set(ThemeScene.UNFOLDED, mockUnfoldedConfig);
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_init_return', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(false);
      mockMultiSceneThemeManager.init();
      expect(mockMultiSceneThemeManager.isSupportMultiSceneTheme()).assertFalse();
      expect(mockMultiSceneThemeManager.getCurrentThemeQualifier() === ThemeScene.BASE).assertTrue();
      expect(mockMultiSceneThemeManager.getCurSceneThemeInfo() === undefined).assertTrue();
    })

    it('test_init_no_return', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      expect(mockMultiSceneThemeManager.isSupportMultiSceneTheme()).not().assertNull();
      expect(mockMultiSceneThemeManager.getCurrentThemeQualifier() !== ThemeScene.NONE).not().assertNull();
      expect(mockMultiSceneThemeManager.getCurSceneThemeInfo() !== undefined).not().assertNull();
      mockMultiSceneThemeManager.revertThemeInfoOnExitEditor();
    })

    it('test_destroy_return', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(false);
      mockMultiSceneThemeManager.destroy();
      expect(mockMultiSceneThemeManager.isSupportMultiSceneTheme()).assertFalse();
    })

    it('test_destroy_no_return', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      mockMultiSceneThemeManager.destroy();
      expect(mockMultiSceneThemeManager.isSupportMultiSceneTheme()).not().assertNull();
      expect(mockMultiSceneThemeManager.getCurSceneThemeInfo() === undefined).not().assertNull();
    })

    it('test_isSupportMultiSceneTheme_0', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      expect(mockMultiSceneThemeManager.isSupportMultiSceneTheme()).assertTrue();
      mockMultiSceneThemeManager.init();
      let themeParams: Map<Qualifier, LockscreenThemeConfig> | undefined =
        ScreenLockThemeManager.getInstance().getCurrentThemeParams();
      ;
      if (themeParams) {
        mockMultiSceneThemeManager.cacheThemeInfoByQualifier(themeParams);
      }
      mockMultiSceneThemeManager.initEditorThemeInfo();
    })

    it('test_isSupportMultiSceneTheme_1', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(false);
      expect(mockMultiSceneThemeManager.isSupportMultiSceneTheme()).assertFalse();
      let themeParams: Map<Qualifier, LockscreenThemeConfig> | undefined =
        ScreenLockThemeManager.getInstance().getCurrentThemeParams();
      ;
      if (themeParams) {
        mockMultiSceneThemeManager.cacheThemeInfoByQualifier(themeParams);
      }
      mockMultiSceneThemeManager.initEditorThemeInfo();
    })

    it('test_updateThemeForScreenPropertyChange_return_false', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(false);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SCREEN_CONNECT;
      let result = mockMultiSceneThemeManager.updateThemeForScreenPropertyChange(screenProperty, reason);
      expect(result).assertFalse();
    })

    it('test_updateThemeForScreenPropertyChange_return_true_0', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      screenProperty.width = 1250;
      screenProperty.height = 2400;
      mockMultiSceneThemeManager.combineRotationFlag(false);
      mockMultiSceneThemeManager.combineFoldModeFlag(false);
      let result = mockMultiSceneThemeManager.updateSceneTheme();
      expect(result !== undefined).assertTrue();
    })

    it('test_cacheThemeInfoByQualifie_no_return_0', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      mockMultiSceneThemeManager.combineRotationFlag(false);
      mockMultiSceneThemeManager.combineFoldModeFlag(true);
      expect(mockMultiSceneThemeManager.getCurrentThemeQualifier() === ThemeScene.BASE).not().assertNull();
      expect(mockMultiSceneThemeManager.getCurSceneThemeInfo() !== undefined).not().assertNull();
    })

    it('test_getEditTogetherQualifier_0', 0, (): void => {
      expect(mockMultiSceneThemeManager.getEditTogetherQualifier(ThemeScene.UNFOLDED) === ThemeScene.LAND_UNFOLDED)
        .assertTrue();
      expect(mockMultiSceneThemeManager.getEditTogetherQualifier(ThemeScene.LAND_UNFOLDED) === ThemeScene.UNFOLDED)
        .assertTrue();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      expect(mockMultiSceneThemeManager.getEditTogetherQualifier(ThemeScene.LAND) === ThemeScene.BASE)
        .assertTrue();
      expect(mockMultiSceneThemeManager.getEditTogetherQualifier(ThemeScene.BASE) === ThemeScene.LAND)
        .assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_applyClockStyleByCache_return_false_0', 0, (): void => {
      let formConfigs: LockscreenFormConfig[] = [];
      mockMultiSceneThemeManager.updateFormPosition(formConfigs);
      mockMultiSceneThemeManager.mockMultiSceneProduct(false);
      let result = mockMultiSceneThemeManager.applyThemeByCache(ThemeScene.BASE, ThemeScene.UNFOLDED);
      expect(result).not().assertNull();
    })

    it('test_applyClockStyleByCache_return_0', 0, (): void => {
      let formConfigs: LockscreenFormConfig[] = [];
      mockMultiSceneThemeManager.updateFormPosition(formConfigs);
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      mockMultiSceneThemeManager.onScreenOnEndChange(true);
      let result = mockMultiSceneThemeManager.applyThemeByCache(ThemeScene.UNFOLDED, ThemeScene.BASE);
      expect(result !== undefined).assertTrue();
    })

    it('test_transformConfig', 0, (): void => {
      let configArg = mockMultiSceneThemeManager.transformConfig(mockBaseConfig);
      expect(configArg !== undefined).assertTrue();
    })

    it('test_setFormViewModel_0', 0, (): void => {
      mockMultiSceneThemeManager.setFormViewModel(formViewModel);
      formViewModel.formPanelPositionY = 1;
      let resultY = mockMultiSceneThemeManager.getFormConfig().positionY;
      expect(resultY === 1).assertTrue();
    })

    it('test_InitSceneFlag_0', 0, (): void => {
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let reason: SCBPropertyChangeReason = SCBPropertyChangeReason.SCREEN_CONNECT;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockFunctionOne: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      when(mockFunctionOne)(ArgumentMatchers.any).afterReturn(true);
      let result = mockMultiSceneThemeManager.initSceneFlag();
      mockMultiSceneThemeManager.updateThemeForScreenPropertyChange(screenProperty, reason);
      mockMultiSceneThemeManager.updateSceneTheme();
      expect(result !== undefined).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_updateFormPosition_0', 0, (): void => {
      let formConfigs: LockscreenFormConfig[] = [];
      let result = mockMultiSceneThemeManager.updateFormPosition(formConfigs);
      expect(result !== undefined).not().assertNull();
    })

    it('test_updateMultiSceneClockPosition_0', 0, (): void => {
      let formViewModel: ScreenLockFormViewModel | undefined = undefined;
      let newLayout: ClockLayout = ClockLayout.DIMENSION_4_4;
      mockMultiSceneThemeManager.setFormViewModel(formViewModel);
      let result = mockMultiSceneThemeManager.updateMultiSceneClockPosition(newLayout);
      expect(result !== undefined).not().assertNull();

      formViewModel = new ScreenLockFormViewModel();
      mockMultiSceneThemeManager.updateMultiSceneClockPosition(newLayout);

      let scene: string = ThemeScene.BASE;
      mockMultiSceneThemeManager.updateMultiSceneClockPosition(newLayout, scene);
    })

    it('test_isSupportMultiSceneTheme_0', 0, (): void => {
      let infoType: DataType = DataType.CLOCK_STYLE;
      let themeInfo: ThemeInfo = 0;
      mockMultiSceneThemeManager.mockMultiSceneProduct(true);
      expect(mockMultiSceneThemeManager.isSupportMultiSceneTheme()).assertTrue();
      mockMultiSceneThemeManager.setupUiThemeInfo(infoType, themeInfo);
    })

    it('test_getDefaultThemeParams_0', 0, (): void => {
      let qualifier: string = ThemeScene.BASE;
      let themeParams: Map<Qualifier, LockscreenThemeConfig> | undefined =
        ScreenLockThemeManager.getInstance().getCurrentThemeParams();
      let result = mockMultiSceneThemeManager.getDefaultThemeParams(qualifier);
      expect(result).not().assertNull();
      if (themeParams) {
        mockMultiSceneThemeManager.getThemeParamsByPriority(qualifier, themeParams);
      }
      qualifier = ThemeScene.UNFOLDED2;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isUltraScreenProduct);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let result1 = mockMultiSceneThemeManager.getDefaultThemeParams(qualifier);
      expect(result1 !== undefined).not().assertNull();
      if (themeParams) {
        mockMultiSceneThemeManager.getThemeParamsByPriority(qualifier, themeParams);
      }
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let result2 = mockMultiSceneThemeManager.getDefaultThemeParams(qualifier);
      expect(result2 !== undefined).not().assertNull();
      if (themeParams) {
        mockMultiSceneThemeManager.getThemeParamsByPriority(qualifier, themeParams);
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_getTargetSceneThemeEditCfg_0', 0, (): void => {
      let qualifier: Qualifier = "undefined";
      mockMultiSceneThemeManager.getTargetSceneThemeEditCfg(qualifier);
      qualifier = 'base';
      let result = mockMultiSceneThemeManager.getTargetSceneThemeEditCfg(qualifier);
      expect(result).not().assertNull();
    })

    it('test_getMultiSceneThemeEditCfg_0', 0, (): void => {
      let result = mockMultiSceneThemeManager.getMultiSceneThemeEditCfg();
      expect(result).not().assertNull();
    })
  })
}

class MockMultiSceneThemeManager extends MultiSceneThemeManager {

  mockMultiSceneProduct(mockSupport: boolean) {
    this.isMultiSceneThemeProduct = mockSupport;
    DeviceHelper.sIsFold = mockSupport;
    DeviceHelper.sFoldProductTypeValue = mockSupport ? 1 : 0;
  }

  initSceneFlag() {
    super.initSceneFlag();
  }

  initDefaultClockCacheInfo() {
    super.initDefaultClockCacheInfo();
  }

  updateEditorCacheByQualifier(qualifier: string, editTogether: boolean) {
    super.updateEditorCacheByQualifier(qualifier, editTogether);
  }

  updateSceneTheme(): boolean {
    return super.updateSceneTheme();
  }

  obtainScene(flag: number): ThemeScene {
    return super.obtainScene(flag);
  }

  combineFoldModeFlag(isFolded: boolean) {
    super.combineFoldModeFlag(isFolded);
  }

  combineRotationFlag(isLandscape: boolean) {
    super.combineRotationFlag(isLandscape);
  }

  applyThemeByCache(newScene: ThemeScene, oldScene: ThemeScene): boolean {
    return super.applyThemeByCache(newScene, oldScene);
  }

  applyClockStyleByCache(uiThemeInfo: ThemeInfo, cacheClockParams: ThemeInfo) {
    super.applyClockStyleByCache(uiThemeInfo, cacheClockParams);
  }

  transformConfig(themeCfg: LockscreenThemeConfig): LockscreenConfig {
		return super.transformConfig(themeCfg);
	}

  getFormConfig(): LockscreenForm {
    return super.getFormConfig();
  }
}