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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { OuterHomeManagerUtil } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/utils/OuterHomeManagerUtil';
import systemparameter from '@ohos.systemparameter';
import { SCBPropertyChangeReason } from '@ohos/windowscene';
import { slStateHelper } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/model/helper/SlStateHelper';
import { SlBindState } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock//model/data/SlBindState';

/**
 * 外部锁屏管理类测试用例
 */
export function OuterHomeManagerUtilTest() {
  describe('OuterHomeManagerUtilTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });
    it('test_getInstance', Level.LEVEL0, (): void => {
      let outerHomeManagerUtil = OuterHomeManagerUtil.getInstance();
      expect(util).not().assertNull();
    });
    it('test_setPersistentId', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      util.setPersistentId(0);
      expect(util).not().assertNull();
    });
    it('test_processSinglePocketExpandToFold', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['processSinglePocketExpandToFold']();
      expect(util).not().assertNull();
    });
    it('test_processSinglePocketFoldToExpand', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['processSinglePocketFoldToExpand']();
      expect(util).not().assertNull();
    });
    it('test_processSinglePocketExpandAndFold', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      let result = util.processSinglePocketExpandAndFold(SCBPropertyChangeReason.FOLD_TO_EXPAND);
      expect(result === null).assertTrue();
      util.processSinglePocketExpandAndFold(SCBPropertyChangeReason.EXPAND_TO_FOLD);
      expect(result === null).assertTrue();
    });
    it('test_setIsSmallOuterScreen', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      let slBindState: SlBindState = slStateHelper.getSlBindState();
      util.setIsSmallOuterScreen(SCBPropertyChangeReason.EXPAND_TO_FOLD);
      let result = slBindState.getIsSmallFoldOuterScreen();
      expect(result).assertEqual(true);
      util.setIsSmallOuterScreen(SCBPropertyChangeReason.FOLD_TO_EXPAND);
      result = slBindState.getIsSmallFoldOuterScreen();
      expect(result).assertEqual(false);
    });
    it('test_isFoldStatusChange', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['isFoldExpandChange'] = true;
      util.isFoldStatusChange();
      (util as object)['isFoldExpandChange'] = false;
      util.isFoldStatusChange();
      expect(util).not().assertNull();
    });
    it('test_refreshFoldStatusChange', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      util.refreshFoldStatusChange();
      expect(util).not().assertNull();
    });
    it('test_isNeedContinuationInOuterSrc01', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['appContinuationEnable'] = true;
      let result: boolean = (util as object)['isNeedContinuationInOuterSrc']();
      expect(util).not().assertNull();
    });
    it('test_isNeedContinuationInOuterSrc02', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['appContinuationEnable'] = false;
      let result: boolean = (util as object)['isNeedContinuationInOuterSrc']();
      expect(result).assertFalse();
    });
    it('test_isSkipFoldToLockScreen01', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['appContinuationEnable'] = false;
      let result: boolean = (util as object)['isSkipFoldToLockScreen']();
      expect(result).assertFalse();
    });
    it('test_isSkipFoldToLockScreen02', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['appContinuationEnable'] = true;
      systemparameter.setSync('persist.mmitest.isrunning', 'true');
      let result: boolean = (util as object)['isSkipFoldToLockScreen']();
      expect(result).assertTrue();
    });
    it('test_isSkipFoldToLockScreen03', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['appContinuationEnable'] = true;
      systemparameter.setSync('persist.mmitest.isrunning', 'false');
      let result: boolean = (util as object)['isSkipFoldToLockScreen']();
      expect(result).assertTrue();
    });
    it('test_setAppSwitchContinuation', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      util.setAppSwitchContinuation(true);
      util.setAppSwitchContinuation(false);
      expect(util).not().assertNull();
    });
    it('test_setAppSwitchContinuation01', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['appContinuationEnable'] = true;
      let result: boolean = util.getAppSwitchContinuation();
      expect(result).assertTrue();
    });
    it('test_setAppSwitchContinuation02', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['appContinuationEnable'] = false;
      let result: boolean = util.getAppSwitchContinuation();
      expect(result).assertFalse();
    });
    it('test_checkIsMmiTestRunningForbidden01', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      systemparameter.setSync('persist.mmitest.isrunning', 'true');
      let result: boolean = (util as object)['checkIsMmiTestRunningForbidden']();
      expect(result).assertTrue();
    });
    it('test_checkIsMmiTestRunningForbidden02', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      systemparameter.setSync('persist.mmitest.isrunning', 'false');
      let result: boolean = (util as object)['checkIsMmiTestRunningForbidden']();
      expect(result).assertFalse();
    });
    it('test_onInterceptedFromUnlockToForeground', Level.LEVEL0, (): void => {
      let util = OuterHomeManagerUtil.getInstance();
      (util as object)['onInterceptedFromUnlockToForeground']();
      expect(util).not().assertNull();
    });
  });
}