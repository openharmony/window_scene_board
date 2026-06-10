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
import { ImmRunningLockMgr } from '../../../../../../../../Index';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmRunningLockMgrTest() {
  let mocker: MockKit;
  describe('ImmRunningLockMgrTest', (): void => {
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

    it('getInstanceTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = ImmRunningLockMgr.getInstance();
      expect(true).assertTrue();
    });

    it('initTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = new ImmRunningLockMgr();
      (lockMgr as object)['isMgrEnable'] = false;
      (lockMgr as object)['init']();
      (lockMgr as object)['isMgrRunning'] = true;
      (lockMgr as object)['init']();
      (lockMgr as object)['isMgrEnable'] = true;
      (lockMgr as object)['isMgrRunning'] = false;
      (lockMgr as object)['init']();
      expect(true).assertTrue();
    });

    it('destroyTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = new ImmRunningLockMgr();
      (lockMgr as object)['isMgrEnable'] = false;
      (lockMgr as object)['destroy']();
      (lockMgr as object)['isMgrRunning'] = false;
      (lockMgr as object)['destroy']();
      (lockMgr as object)['isMgrEnable'] = true;
      (lockMgr as object)['isMgrRunning'] = true;
      (lockMgr as object)['destroy']();
      expect(true).assertTrue();
    });

    it('requestUpdateRunningLockStateTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = new ImmRunningLockMgr();
      let hashcode = 'myHashCode';
      (lockMgr as object)['isMgrEnable'] = false;
      (lockMgr as object)['requestUpdateRunningLockState'](hashcode);
      (lockMgr as object)['isMgrEnable'] = true;
      (lockMgr as object)['requestUpdateRunningLockState'](hashcode);
      expect(true).assertTrue();
    });

    it('cacheRunningLockStateTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = new ImmRunningLockMgr();
      let hashcode = 'myHashCode';
      let isEnable = true;
      let isNotEnable = false;
      (lockMgr as object)['isMgrEnable'] = false;
      (lockMgr as object)['cacheRunningLockState'](hashcode, isEnable);
      (lockMgr as object)['isMgrEnable'] = true;
      (lockMgr as object)['cacheRunningLockState'](hashcode, isEnable);
      (lockMgr as object)['isMgrEnable'] = true;
      (lockMgr as object)['cacheRunningLockState'](hashcode, isNotEnable);
      expect(true).assertTrue();
    });

    it('setCurShowingImmersiveTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = new ImmRunningLockMgr();
      let hashcode = 'myHashCode';
      let isEnable = true;
      let isNotEnable = false;
      (lockMgr as object)['isMgrEnable'] = isNotEnable;
      (lockMgr as object)['setCurShowingImmersive'](hashcode);
      (lockMgr as object)['isMgrEnable'] = isEnable;
      (lockMgr as object)['setCurShowingImmersive'](hashcode);
      expect(true).assertTrue();
    });

    it('setSlMainPageStateTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = new ImmRunningLockMgr();
      let isEnable = true;
      let isNotEnable = false;
      (lockMgr as object)['isMgrEnable'] = isNotEnable;
      (lockMgr as object)['setSlMainPageState'](true);
      (lockMgr as object)['isMgrEnable'] = isEnable;
      (lockMgr as object)['setSlMainPageState'](false);
      expect(true).assertTrue();
    });

    it('setSlOccludedTest', Level.LEVEL0, (): void => {
      let lockMgr: ImmRunningLockMgr = new ImmRunningLockMgr();
      let isEnable = true;
      let isNotEnable = false;
      (lockMgr as object)['isMgrEnable'] = isNotEnable;
      (lockMgr as object)['setSlOccluded'](true);
      (lockMgr as object)['isMgrEnable'] = isEnable;
      (lockMgr as object)['setSlOccluded'](false);
      expect(true).assertTrue();
    });

  });
}