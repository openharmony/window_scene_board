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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit } from '@ohos/hypium';
import { UIExtentionLoadingStateMgr } from '../../../../../../main/ets/model/manager/UIExtentionLoadingStateMgr';

/**
 * 沉浸式锁屏测试用例
 */
export function UIExtentionLoadingStateMgrTest() {
  let mocker: MockKit;
  describe('UIExtentionLoadingStateMgrTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {

    });

    it('initTest', Level.LEVEL0, (): void => {
      let instance = UIExtentionLoadingStateMgr.getInstance();
      expect(instance).not().assertNull();
    });

    it('setDelayImmHashTest', Level.LEVEL0, (): void => {
      let instance = UIExtentionLoadingStateMgr.getInstance();
      let hashCode = 'myhashcode';
      (instance as object)['setDelayImmHash'](hashCode);
      (instance as object)['setDelayImmHash']();
      expect(instance).not().assertNull();
    });

    it('setCanLoadingStateTest', Level.LEVEL0, (): void => {
      let instance = UIExtentionLoadingStateMgr.getInstance();
      let hashCode = 'myhashcode';
      let isNotEnable = false;
      let isEnable = true;
      (instance as object)['setCanLoadingState'](hashCode, isNotEnable);
      (instance as object)['setCanLoadingState'](hashCode, isEnable);
      expect(instance).not().assertNull();
    });


    it('resetLoadingStateTest', Level.LEVEL0, (): void => {
      let instance = UIExtentionLoadingStateMgr.getInstance();
      instance.resetLoadingState();
      expect(instance).not().assertNull();
    });

    it('setCurShowingImmersiveTest', Level.LEVEL0, (): void => {
      let instance = UIExtentionLoadingStateMgr.getInstance();
      let hashCode = 'myhashcode';
      (instance as object)['setCurShowingImmersive'](hashCode);
      (instance as object)['setCurShowingImmersive']();
      expect(instance).not().assertNull();
    });

    it('setOnRemoteReadyTest', Level.LEVEL0, (): void => {
      let instance = UIExtentionLoadingStateMgr.getInstance();
      let isRemoteReady = true;
      let isNotRemoteReady = false;
      (instance as object)['setOnRemoteReady'](isRemoteReady);
      (instance as object)['setOnRemoteReady'](isNotRemoteReady);
      expect(instance).not().assertNull();
    });
  });
}



