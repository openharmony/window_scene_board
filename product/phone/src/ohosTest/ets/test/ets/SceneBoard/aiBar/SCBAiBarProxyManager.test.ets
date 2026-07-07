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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, TestType, Size, Level } from '@ohos/hypium';
import {
  AiBarRegisterFunc,
  SCBAiBarProxyManager,
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/proxy/SCBAiBarProxyManager';
import { SCBAiBarConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/SCBAiBarConstants';
import { rpc } from '@kit.IPCKit';
import { SCBAiBarCallBack } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/proxy/SCBAiBarCallBack';
import { ReflectionUtils } from '../scenemanager/multiwindow/ReflectionUtils';


export default function SCBAiBarProxyManagerTest() {

  let proxy: rpc.IRemoteObject = new SCBAiBarCallBack("");

  describe('SCBAiBarProxyManagerTest', () => {
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

    it('SCBAiBarProxyManagerTest_registerProxyCallback', Level.LEVEL0, (): void => {
      expect(SCBAiBarProxyManager.getInstance().registerProxyCallback('test', () => {
      }) === undefined).assertTrue();
    })

    it('SCBAiBarProxyManagerTest_executeCallbackByType', Level.LEVEL0, (): void => {
      expect(SCBAiBarProxyManager.getInstance().executeCallbackByType('test') === undefined).assertTrue();
    })

    it('SCBAiBarProxyManagerTest_executeCallback', Level.LEVEL0, (): void => {
      expect(SCBAiBarProxyManager.getInstance().executeCallback() === undefined).assertTrue();
    })

    it('SCBAiBarProxyManagerTest_getConnectHaloStatus', Level.LEVEL0, (): void => {
      SCBAiBarProxyManager.getInstance().initConnectHaloStatus();
      expect(SCBAiBarProxyManager.getInstance().getConnectHaloStatus() === 0).assertTrue();
    })

    it('SCBAiBarProxyManagerTest_unRegisterProxyCallback_01', Level.LEVEL0, (): void => {
      expect(SCBAiBarProxyManager.getInstance().unRegisterProxyCallback("test") === undefined).assertTrue();
    })

    it('SCBAiBarProxyManagerTest_unRegisterProxyCallback_02', Level.LEVEL0, (): void => {
      expect(SCBAiBarProxyManager.getInstance().unRegisterProxyCallback("test1") === undefined).assertTrue();
    })

    it('SCBAiBarProxyManagerTest_callback', Level.LEVEL0, (): void => {
      SCBAiBarProxyManager.getInstance().executeCallbackByType(AiBarRegisterFunc.AIBAR_EXIT_FUNC);
      SCBAiBarProxyManager.getInstance().executeCallback();
      expect(SCBAiBarProxyManager).not().assertUndefined();
    })
  })
}