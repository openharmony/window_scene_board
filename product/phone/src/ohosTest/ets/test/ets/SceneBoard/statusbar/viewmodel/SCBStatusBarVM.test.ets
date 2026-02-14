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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers,
  Level } from '@ohos/hypium';
import { SCBStatusBarVM } from '@ohos/phonebase/src/main/ets/SceneBoard/statusbar/viewmodel/SCBStatusBarVM';
import { viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { bannerMgr, BannerPanelType } from '@ohos/systemuicommon';

export function SCBStatusBarVMTest() {
  describe('SCBStatusBarVMTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('test_animateStatusBarOpacity', 0, () => {
      let scbStatusBarVM = new SCBStatusBarVM();
      Reflect.get(scbStatusBarVM, 'statusBarStatus')?.setStatusBarOpacity(0.5);
      scbStatusBarVM.animateStatusBarOpacity(true);
      scbStatusBarVM.animateStatusBarOpacity(false);
      expect(scbStatusBarVM !== undefined).assertTrue();
    })

    it('test_onIsBarShow', 0, () => {
      let scbStatusBarVM = new SCBStatusBarVM();
      let flag: boolean = true;
      let enableAnimation: boolean = true;
      scbStatusBarVM.onIsBarShow(flag, enableAnimation);
      flag = false;
      scbStatusBarVM.onIsBarShow(flag, enableAnimation);
      enableAnimation = false;
      scbStatusBarVM.onIsBarShow(flag, enableAnimation);
      expect(scbStatusBarVM !== undefined).assertTrue();
    })

    it('test_onFinishHideStatusBar', 0, () => {
      let scbStatusBarVM = new SCBStatusBarVM();
      expect(scbStatusBarVM !== null).assertTrue();
      let mock = new MockKit();
      let isViewShowing = mock.mockFunc(viewMgrPolicy, viewMgrPolicy.isViewShowing);
      let isBannerPanelType = mock.mockFunc(bannerMgr,  bannerMgr.isBannerPanelType);
      when(isViewShowing)(ViewType.DROPDOWN).afterReturn(false);
      when(isBannerPanelType)(BannerPanelType.TYPE_LIVE_LIST).afterReturn(false);
      Reflect.set(scbStatusBarVM,  'isTerminateHide', false);
      (scbStatusBarVM as object)['onFinishHideStatusBar']();
      expect(scbStatusBarVM !== undefined).assertTrue();
      mock.clear(viewMgrPolicy);
      mock.clear(bannerMgr);
      mock.clearAll();
    })
  })
}

export function SCBStatusBarVMTest1() {
  describe('SCBStatusBarVMTest1', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_unRegisterViewController',Level.LEVEL0,()=>{
        let sCBStatusBarVM = new SCBStatusBarVM();
        sCBStatusBarVM.unRegisterViewController();
        sCBStatusBarVM.getStatusBarStatus();
        expect(true).assertTrue();
    })

    it('test_hideStatusbarLockEditor',Level.LEVEL0,()=>{
      let sCBStatusBarVM = new SCBStatusBarVM();
      sCBStatusBarVM.hideStatusbarLockEditor();
      sCBStatusBarVM.hideStatusbarLockEditor('');
      expect(true).assertTrue();
    })

    it('test_showStatusbarLockEditor',Level.LEVEL0,()=>{
      let sCBStatusBarVM = new SCBStatusBarVM();
      sCBStatusBarVM.showStatusbarLockEditor('');
      expect(true).assertTrue();
    })
  })
}