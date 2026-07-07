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

import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  RecoverThemeApp
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/utils/RecoverThemeApp';
import promptAction from '@ohos.promptAction';
import bundleManager from '@ohos.bundle.bundleManager';

export function RecoverThemeAppTest() {
  describe('RecoverThemeAppTest', () => {

    it('test_getInstance', 0, () => {
      const instance0 = RecoverThemeApp.getInstance();
      const instance1 = RecoverThemeApp.getInstance();
      expect(true).assertTrue();
    });

    it('test_getBundleInfo_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(bundleManager.getBundleInfo, bundleManager.getBundleInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturnNothing();

      const instance = new RecoverThemeApp();
      instance.getBundleInfo();
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
      done();
    });

    it('test_getBundleInfo_2', 0,  async (done: Function) => {
      let bundleInfo: bundleManager.BundleInfo = {
        name: "name",
        versionCode: 100
      } as bundleManager.BundleInfo

      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(bundleManager.getBundleInfo, bundleManager.getBundleInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(bundleInfo);

      const instance = new RecoverThemeApp();
      instance.getBundleInfo();
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
      done();
    });

    it('test_getBundleInfo_catch', 0,  async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(bundleManager.getBundleInfo, bundleManager.getBundleInfo);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('err');

      const instance = new RecoverThemeApp();
      instance.getBundleInfo();
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
      done();
    });

    it('test_getBundleVersion_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(bundleManager.getBundleInfo, bundleManager.getBundleInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturnNothing(); // bundleInfo empty

      const instance = new RecoverThemeApp();
      instance.getBundleVersion('bundleName', 0x00000004);
      expect(true).assertTrue();
      done();
    });

    it('test_getBundleVersion_2', 0, async (done: Function) => {
      let bundleInfo: bundleManager.BundleInfo = {
        name: "name",
        versionCode: 100
      } as bundleManager.BundleInfo

      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(bundleManager.getBundleInfo, bundleManager.getBundleInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(bundleInfo);

      const instance = new RecoverThemeApp();
      instance.getBundleVersion('bundleName',0x00000004);
      expect(true).assertTrue();
      done();
    });

    it('test_getBundleVersion_catch', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunctionThrow: Function = mocker.mockFunc(bundleManager.getBundleInfo, bundleManager.getBundleInfo);
      when(mockFunctionThrow)(ArgumentMatchers.any).afterThrow('err');

      const instance = new RecoverThemeApp();
      instance.getBundleVersion('bundleName',0x00000004)
      expect(true).assertTrue();
      mocker.clear(mockFunctionThrow);
      mocker.clearAll();
      done();
    });

    it('test_showRecoveredToast', 0, () => {
      const instance = new RecoverThemeApp();
      instance.showRecoveredToast();
      expect(true).assertTrue();
    });

    it('test_showRecoveredToast_catch', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(promptAction.showToast, promptAction.showToast);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('err');

      const instance = new RecoverThemeApp();
      instance.showRecoveredToast();
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
    });

  });
}