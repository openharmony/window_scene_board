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
import { desktopUtil } from '@ohos/componenthelper';
import { afterAll, afterEach, beforeAll, beforeEach, describe, it, MockKit, when, ArgumentMatchers,
  expect } from '@ohos/hypium';
import {
  ThreeButtonUpgradeData,
  ThreeButtonUpgradeViewData
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/ThreeButtonUpgradeViewData';
import {
  ThreeButtonUpgradeViewModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/ThreeButtonUpgradeViewModel';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { display } from '@kit.ArkUI';

export default function ThreeButtonUpgradeViewModelTest() {
  describe('ThreeButtonUpgradeViewModelTest', () => {
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
    it('aboutToAppear_001', 0, () => {
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(
        new ThreeButtonUpgradeData(), new ThreeButtonUpgradeViewData());

      let mocker = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)(ArgumentMatchers.any).afterReturn(true);

      upgradeViewModel.aboutToAppear();
      expect(upgradeViewModel).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    })
    it('aboutToAppear_002', 0, () => {
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(
        new ThreeButtonUpgradeData(), new ThreeButtonUpgradeViewData());

      let mocker = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)(ArgumentMatchers.any).afterReturn(false);
      let isPhone = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(isPhone)(ArgumentMatchers.any).afterReturn(false);

      upgradeViewModel.aboutToAppear();
      expect(upgradeViewModel).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    })
    it('aboutToAppear_003', 0, () => {
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(
        new ThreeButtonUpgradeData(), new ThreeButtonUpgradeViewData());

      let mocker = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)(ArgumentMatchers.any).afterReturn(false);
      let isPhone = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(isPhone)(ArgumentMatchers.any).afterReturn(true);
      let isFold = mocker.mockFunc(desktopUtil, desktopUtil.isFold);
      when(isFold)(ArgumentMatchers.any).afterReturn(true);
      let isFoldExpanded = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(false);

      upgradeViewModel.aboutToAppear();
      expect(upgradeViewModel).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpanded);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
    })
    it('aboutToAppear_004', 0, () => {
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(
        new ThreeButtonUpgradeData(), new ThreeButtonUpgradeViewData());

      let mocker = new MockKit();
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)(ArgumentMatchers.any).afterReturn(false);
      let isPhone = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(isPhone)(ArgumentMatchers.any).afterReturn(true);
      let isFold = mocker.mockFunc(desktopUtil, desktopUtil.isFold);
      when(isFold)(ArgumentMatchers.any).afterReturn(true);
      let isFoldExpanded = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(isFoldExpanded)(ArgumentMatchers.any).afterReturn(true);

      upgradeViewModel.aboutToAppear();
      expect(upgradeViewModel).not().assertUndefined();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(desktopUtil, desktopUtil.isFold);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isFoldExpanded);
    })
    it('playLottie_001', 0, () => {
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      let lottieName = upgradeViewData.swiperItems[0].name;
      upgradeViewData.swiperItems[0].name = `${upgradeViewData.swiperItems[0].name}s`;
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(
        new ThreeButtonUpgradeData(), upgradeViewData);
      upgradeViewModel.playLottie(0);
      upgradeViewModel.playLottie(1);
      upgradeViewData.swiperItems[0].name = lottieName;
      expect(upgradeViewModel).not().assertUndefined();
    })
    it('playLottie_002', 0, () => {
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      let lottieName = upgradeViewData.swiperItems[0].name;
      upgradeViewData.swiperItems[0].name = `${upgradeViewData.swiperItems[0].name}s`;
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(
        new ThreeButtonUpgradeData(), upgradeViewData);

      upgradeViewModel.aboutToAppear();

      upgradeViewModel.playLottie(0);
      upgradeViewModel.playLottie(1);
      upgradeViewData.swiperItems[0].name = lottieName;
      expect(upgradeViewModel).not().assertUndefined();
    })
    it('closeSelf_001', 0, () => {
      let upgradeData = new ThreeButtonUpgradeData();
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(upgradeData, upgradeViewData);
      upgradeViewModel.closeSelf();
      expect(upgradeViewModel).not().assertUndefined();
    })
    it('closeSelf_002', 0, () => {
      let upgradeData = new ThreeButtonUpgradeData();
      upgradeData.session = LocalStorage.getShared()?.get<UIExtensionContentSession>('session');
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(upgradeData, upgradeViewData);
      upgradeViewModel.closeSelf();
      expect(upgradeViewModel).not().assertUndefined();
    })
    it('swiperChangeStart_001', 0, () => {
      let upgradeData = new ThreeButtonUpgradeData();
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(upgradeData, upgradeViewData);
      upgradeViewModel.aboutToAppear();
      upgradeViewModel.playLottie(0);
      upgradeViewModel.swiperChangeStart(0);
      upgradeViewModel.swiperChangeStart(1);
      upgradeViewModel.swiperChangeStart(100);
      expect(upgradeViewModel).not().assertUndefined();
    })
    it('swiperChangeEnd_001', 0, () => {
      let upgradeData = new ThreeButtonUpgradeData();
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(upgradeData, upgradeViewData);
      upgradeViewModel.aboutToAppear();
      upgradeViewModel.playLottie(0);
      upgradeViewModel.swiperChangeEnd(0);
      upgradeViewModel.swiperChangeEnd(1);
      upgradeViewModel.swiperChangeEnd(100);
      expect(upgradeViewModel).not().assertUndefined();
    })
    it('setButtonOpacity_001', 0, () => {
      let upgradeData = new ThreeButtonUpgradeData();
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      upgradeViewData.buttonOpacity = 1;
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(upgradeData, upgradeViewData);
      upgradeViewModel.setButtonOpacity(0);
      expect(upgradeViewModel).not().assertUndefined();
    })
    it('setButtonOpacity_002', 0, () => {
      let upgradeData = new ThreeButtonUpgradeData();
      let upgradeViewData = new ThreeButtonUpgradeViewData();
      upgradeViewData.buttonOpacity = 0;
      let upgradeViewModel: ThreeButtonUpgradeViewModel = new ThreeButtonUpgradeViewModel(upgradeData, upgradeViewData);
      upgradeViewModel.setButtonOpacity(0);
      upgradeViewModel.setButtonOpacity(1);
      upgradeViewModel.setButtonOpacity(2);
      expect(upgradeViewModel).not().assertUndefined();
    })
  })
}
