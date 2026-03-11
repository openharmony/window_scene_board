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
import type Want from '@ohos.app.ability.Want';
import type { BusinessError } from '@ohos.base';
import { afterAll, afterEach,ArgumentMatchers,beforeAll, beforeEach, describe, expect,
  it, MockKit, when } from '@ohos/hypium';
import { SCBSceneSessionManager } from '../../../../../../main/ets/scene/session/SCBSceneSessionManager';
import { StartAbilityUtil } from '../../../../../../main/ets/startAbility/StartAbilityUtil';
import { SCBConstants } from '@ohos/commonconstants';
import { CommonUtils } from '@ohos/basicutils';
import { AccountConstants, AccountMgr } from '@ohos/frameworkwrapper';
import { GlobalContext } from '@ohos/frameworkwrapper';

export function StartAbilityUtilTest() {
  describe('StartAbilityUtilTest', () => {

    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterEach(() => {
    });
    afterAll(() => {
    });

    it('startLauncherAbilityTest01', 0, () => {
      let startParams: Map<string, Object> = new Map();
      startParams.set(SCBConstants.START_APP_CLONE_INDEX, 1);
      expect(StartAbilityUtil).not().assertNull();
      StartAbilityUtil.startLauncherAbility("testAbility", "testBundle", "testModule", startParams);
    });

    it('startLauncherAbilityTest02', 0, () => {
      let startParams: Map<string, Object> = new Map();
      expect(StartAbilityUtil).not().assertNull();
      StartAbilityUtil.startLauncherAbility("testAbility", "testBundle", "testModule", startParams);
    });

    it('startAbilityTest02', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockCommonUtils = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockCommonUtils)(ArgumentMatchers.any).afterReturn(true);
      let mockStartAbilityUtil: StartAbilityUtil = mocker.mockObject(StartAbilityUtil);

      let want: Want = {
        bundleName: 'testBundle',
        moduleName: 'testModule',
        abilityName: 'testAbility'
      };
      expect(StartAbilityUtil).not().assertNull();
      StartAbilityUtil.startAbility(want);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.clear(mockStartAbilityUtil);
    });

    it('startAbilityTest03', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockCommonUtils = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      const callback = (error?: BusinessError<void>): void => {};

      when(mockCommonUtils)(ArgumentMatchers.any).afterReturn(true);
      let want: Want = {
        bundleName: 'testBundle',
        moduleName: 'testModule',
        abilityName: 'testAbility'
      };
      expect(StartAbilityUtil).not().assertNull();
      StartAbilityUtil.startAbility(want, callback);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('stopServiceExtensionAbilityTest02', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockAccountMgr = mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      let mockContext = mocker.mockFunc(GlobalContext, GlobalContext.getContext);
      let want: Want = {
        bundleName: 'com.example.bundle'
      };
      when(mockAccountMgr)().afterReturn(Promise.resolve(123));
      expect(StartAbilityUtil).not().assertNull();
      StartAbilityUtil.stopServiceExtensionAbility(want);
      mocker.ignoreMock(GlobalContext, GlobalContext.getContext);
      done();
    });

    it('stopServiceExtensionAbilityTest03', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockAccountMgr = mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      let mockContext = mocker.mockFunc(GlobalContext, GlobalContext.getContext);
      let want: Want = {
        bundleName: 'com.example.bundle'
      };
      when(mockAccountMgr)().afterReturn(Promise.resolve(AccountConstants.INVALID_ID));
      expect(StartAbilityUtil).not().assertNull();
      StartAbilityUtil.stopServiceExtensionAbility(want);
      mocker.ignoreMock(GlobalContext, GlobalContext.getContext);
      done();
    });

    it('startAbilityByNameTest01', 0, () => {
      expect(StartAbilityUtil).not().assertNull();
      StartAbilityUtil.startAbilityByName("testAbility", "testBundle", "testModule");
    });

  });
}