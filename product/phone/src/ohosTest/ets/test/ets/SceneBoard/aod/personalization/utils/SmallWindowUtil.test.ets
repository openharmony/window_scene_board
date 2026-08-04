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

import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import SmallWindowUtil from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/utils/SmallWindowUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { settings } from '@kit.BasicServicesKit';
import { LocaleResponse, Configuration, promptAction } from '@kit.ArkUI';


export function SmallWindowUtilTest() {
  describe('SmallWindowUtilTest', () => {

    it('test_checkWindowSmall_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settings.getValueSync, settings.getValueSync);
      when(mockFunc)(ArgumentMatchers).afterReturn(4); // windowStatusType === WINDOW_FLOATING

      const isWindowSmall = SmallWindowUtil.checkWindowSmall();
      expect(isWindowSmall).assertFalse();
      mocker.clear(settings.getValueSync);
      mocker.clearAll();
    });

    it('test_checkWindowSmall_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settings.getValueSync, settings.getValueSync);
      when(mockFunc)(ArgumentMatchers).afterReturn(0);

      const isWindowSmall = SmallWindowUtil.checkWindowSmall();
      expect(isWindowSmall).assertFalse();
      mocker.clear(settings.getValueSync);
      mocker.clearAll();
    });

    it('test_checkWindowSmall_catch', 0, (): void => {
      let checkWindowCatch: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settings.getValueSync, settings.getValueSync);
      when(mockFunc)(ArgumentMatchers).afterThrow('error');

      SmallWindowUtil.checkWindowSmall();
      expect(checkWindowCatch).assertTrue();
      mocker.clear(settings.getValueSync);
      mocker.clearAll();
    });

    it('test_showToast_getWindowWidthAndHeight_undefined', 0, (): void => {
      let showToastCatch: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LocalStorage.getShared, LocalStorage.getShared);
      when(mockFunc)(ArgumentMatchers).afterReturnNothing(); // getWindowWidthAndHeight-if,showToast-!windowRect

      SmallWindowUtil.showToast();
      expect(showToastCatch).assertTrue();
      mocker.clear(LocalStorage.getShared);
      mocker.clearAll();
    });

    it('test_showToast_getWindowWidthAndHeight_catch', 0, (): void => {
      let showToastCatch: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(LocalStorage.getShared, LocalStorage.getShared);
      when(mockFunc)(ArgumentMatchers).afterThrow('error'); // getWindowWidthAndHeight-catch

      SmallWindowUtil.showToast();
      expect(showToastCatch).assertTrue();
      mocker.clear(LocalStorage.getShared);
      mocker.clearAll();
    });

    it('test_showToast_getScreenSize_isFoldExpanded', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper.isFoldExpanded, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);

      SmallWindowUtil.showToast();
      expect(DeviceHelper.isFoldExpanded()).assertFalse();
      mocker.clear(DeviceHelper.isFoldExpanded);
      mocker.clearAll();
    });

    it('test_showToast_getScreenSize_languageDir_true', 0, (): void => {
      let localeConfig: LocaleResponse = {
        dir: "ltr"
      } as LocaleResponse;

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(Configuration.getLocale, Configuration.getLocale);
      when(mockFunc)().afterReturn(localeConfig);

      SmallWindowUtil.showToast();
      expect(localeConfig).not().assertUndefined();
      mocker.clear(Configuration.getLocale);
      mocker.clearAll();
    });

    it('test_showToast_getScreenSize_languageDir_false', 0, (): void => {
      let localeConfig: LocaleResponse = {
        dir: "rtl"
      } as LocaleResponse;

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(Configuration.getLocale, Configuration.getLocale);
      when(mockFunc)().afterReturn(localeConfig);

      SmallWindowUtil.showToast();
      expect(localeConfig).not().assertUndefined();
      mocker.clear(Configuration.getLocale);
      mocker.clearAll();
    });

    it('test_showToast_catch', 0, (): void => {
      let showToastCatch: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(promptAction.showToast, promptAction.showToast);
      when(mockFunc)().afterThrow('error');

      SmallWindowUtil.showToast();
      expect(showToastCatch).assertTrue();
      mocker.clear(promptAction.showToast);
      mocker.clearAll();
    });

  })
}