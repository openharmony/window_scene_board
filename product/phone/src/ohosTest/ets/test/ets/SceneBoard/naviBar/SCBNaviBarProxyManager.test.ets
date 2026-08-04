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
  NaviBarRegisterFunc,
  SCBNaviBarProxyManager,
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/proxy/SCBNaviBarProxyManager';
import { SCBNaviBarConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/SCBNaviBarConstants';
import { rpc } from '@kit.IPCKit';
import { SCBNaviBarCallBack } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/proxy/SCBNaviBarCallBack';
import { ReflectionUtils } from '../scenemanager/multiwindow/ReflectionUtils';


export default function SCBNaviBarProxyManagerTest() {

  let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack("");

  describe('SCBNaviBarProxyManagerTest', () => {
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

    it('SCBNaviBarProxyManagerTest_registerProxyCallback', Level.LEVEL0, (): void => {
      expect(SCBNaviBarProxyManager.getInstance().registerProxyCallback('test', () => {
      }) === undefined).assertTrue();
    })

    it('SCBNaviBarProxyManagerTest_executeCallbackByType', Level.LEVEL0, (): void => {
      expect(SCBNaviBarProxyManager.getInstance().executeCallbackByType('test') === undefined).assertTrue();
    })

    it('SCBNaviBarProxyManagerTest_executeCallback', Level.LEVEL0, (): void => {
      expect(SCBNaviBarProxyManager.getInstance().executeCallback() === undefined).assertTrue();
    })

    it('SCBNaviBarProxyManagerTest_getConnectHaloStatus', Level.LEVEL0, (): void => {
      SCBNaviBarProxyManager.getInstance().initConnectHaloStatus();
      expect(SCBNaviBarProxyManager.getInstance().getConnectHaloStatus() === 0).assertTrue();
    })

    it('SCBNaviBarProxyManagerTest_unRegisterProxyCallback_01', Level.LEVEL0, (): void => {
      expect(SCBNaviBarProxyManager.getInstance().unRegisterProxyCallback("test") === undefined).assertTrue();
    })

    it('SCBNaviBarProxyManagerTest_unRegisterProxyCallback_02', Level.LEVEL0, (): void => {
      expect(SCBNaviBarProxyManager.getInstance().unRegisterProxyCallback("test1") === undefined).assertTrue();
    })

    it('SCBNaviBarProxyManagerTest_callback', Level.LEVEL0, (): void => {
      SCBNaviBarProxyManager.getInstance().executeCallbackByType(NaviBarRegisterFunc.NAVIBAR_EXIT_FUNC);
      SCBNaviBarProxyManager.getInstance().executeCallback();
      expect(SCBNaviBarProxyManager).not().assertUndefined();
    })
  })
}