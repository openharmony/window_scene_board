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
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { StartType } from '@ohos/basicutils';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { bundleManagerFwk, DeviceHelper, onLineThemeUtil, ResourceManager } from '@ohos/frameworkwrapper';
import {
  AppStatus,
  AppItemInfo,
  CommonConstants,
  GridLayoutUtil,
} from '../../../../../../../main/ets/TsIndex';
import { AppIconModel } from '../../../../../../../main/ets/launchericon/common/AppIconModel';

export function AppIconModelTest() {
  describe('AppIconModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getInstance', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();
      expect(instance).not().assertNull()
      expect(instance).assertEqual(AppIconModel.getInstance());
    });

    it('getIconId', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();
      let itemInfo: AppItemInfo = new AppItemInfo();

      itemInfo.bundleName = 'testBundleName';
      itemInfo.appIconId = 0;
      itemInfo.appStatus = AppStatus.INSTALLED;
      itemInfo.shortcutId = 'testShortcutId';
      itemInfo.appIndex = 1;
      itemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      itemInfo.abilityName = 'testAbility';
      itemInfo.moduleName = 'testModule';
      itemInfo.areaType = 0;

      let expectedIconId = 'AppIcon_Image_testBundleNametestAbilitytestModule1testShortcutId_undefined_0';
      let ret = instance.getIconId(itemInfo);
      expect(ret).assertEqual(expectedIconId);

      expectedIconId = 'AppIcon_Image_testBundleNametestAbilitytestModule1testShortcutId_extraId_0_OuterDesktop';
      ret = instance.getIconId(itemInfo, 'extraId', true);
      expect(ret).assertEqual(expectedIconId);

      expectedIconId = 'AppIcon_Image_testBundleNametestAbilitytestModule1testShortcutId_extraId_isOpenFolder_' +
        '0_OuterDesktop';
      ret = instance.getIconId(itemInfo, 'extraId', true, true);
      expect(ret).assertEqual(expectedIconId);
    })

    it('getBadgeId', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();

      let bundleName = 'testBundleName';
      let startType = StartType.DESKTOP_APP;
      let ret: string = instance.getBadgeId(bundleName, startType);
      expect(ret).assertEqual('AppIconModel_Badge_testBundleName_'+StartType.DESKTOP_APP);
    });

    it('isDynamicIcon', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();
      let itemInfo: AppItemInfo = new AppItemInfo();
      let mocker: MockKit = new MockKit();

      itemInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      let ret: boolean = instance.isDynamicIcon(itemInfo);
      expect(ret).assertFalse();

      itemInfo.typeId = CommonConstants.TYPE_APP;

      const mockFun: Function =
        mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getPixelMapByResourceName);
      when(mockFun)().afterReturn(undefined);

      itemInfo.bundleName  = CommonConstants.CLOCK_BUNDLE;
      let isPCMockFunction: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC)
      when(isPCMockFunction)(ArgumentMatchers.any).afterReturn(true);
      ret = instance.isDynamicIcon(itemInfo);
      expect(ret).assertFalse();

      itemInfo.bundleName  = CommonConstants.CLOCK_BUNDLE;
      when(isPCMockFunction)(ArgumentMatchers.any).afterReturn(false);
      ret = instance.isDynamicIcon(itemInfo);
      expect(ret).assertTrue();

      itemInfo.bundleName  = CommonConstants.SETTINGS_BUNDLE;
      ret = instance.isDynamicIcon(itemInfo);
      expect(ret).assertFalse();
    });

    it('atc_should_return_false_when_bundleName_is_CALENDAR_BUNDLE_and_DeviceHelper_is_Tv', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();
      let mocker: MockKit = new MockKit();
      let ret = instance.isDynamicIcon({ bundleName: CommonConstants.CALENDAR_BUNDLE });
      expect(ret).assertFalse();
    });

    it('atc_should_return_false_when_bundleName_is_CLOCK_BUNDLE_and_DeviceHelper_is_Tv', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();
      let mocker: MockKit = new MockKit();
      let ret = instance.isDynamicIcon({ bundleName: CommonConstants.CLOCK_BUNDLE });
      expect(ret).assertFalse();
    });

    it('isEnableIconShadow', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockFun: Function = mocker.mockFunc(SCBVisualEffectMgr, SCBVisualEffectMgr.isFeatureParamTrue);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      let mockFun2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isBarPhone);
      when(mockFun2)().afterReturn(false);
      let mockFun3: Function = mocker.mockFunc(onLineThemeUtil, onLineThemeUtil.isOnlineTheme);
      when(mockFun3)().afterReturn(false);

      let instance: AppIconModel = AppIconModel.getInstance();
      let ret: boolean = instance.isEnableIconShadow();
      expect(ret).assertTrue();

      ret = instance.isEnableIconShadow(false);
      expect(ret).assertFalse();

      mocker.clear(SCBVisualEffectMgr);
      mocker.clear(DeviceHelper);
      mocker.clear(onLineThemeUtil);
      mocker.clearAll();
    });

    it('getIconRadius', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();
      let ret: number = instance.getIconRadius(true);
      expect(ret).assertEqual(0);

      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(onLineThemeUtil, onLineThemeUtil.isOnlineTheme);
      when(mockFun)().afterReturn(false);
      ret = instance.getIconRadius(false, 1);
      expect(ret).assertEqual(1);

      when(mockFun)().afterReturn(true);
      ret = instance.getIconRadius();
      expect(ret).assertEqual(0);

      mocker.clear(onLineThemeUtil);
      mocker.clearAll();
    });

    it('getDragIconBuilderScale', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();

      let ret: ScaleOptions = instance.getDragIconBuilderScale(new AppItemInfo());
      expect(ret.x).assertEqual(1);
    });

    it('isValidCloneItem', 0, () => {
      let instance: AppIconModel = AppIconModel.getInstance();

      let item = new AppItemInfo();
      item.appIndex = 3;
      let ret: boolean = instance.isValidCloneItem(item);
      expect(ret).assertTrue();

      item.appIndex = 6;
      ret = instance.isValidCloneItem(item);
      expect(ret).assertFalse();

      item.appIndex = -1;
      ret = instance.isValidCloneItem(item);
      expect(ret).assertFalse();

      ret = instance.isValidCloneItem(null);
      expect(ret).assertNull();
    });
  });
}