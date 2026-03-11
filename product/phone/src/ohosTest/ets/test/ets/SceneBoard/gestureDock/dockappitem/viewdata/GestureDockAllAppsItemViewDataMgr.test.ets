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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { GestureDockMode } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import GestureDockAllAppsViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockAllAppsViewDataMgr';
import GestureDockAllAppsViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewevent/GestureDockAllAppsViewEventMgr';
import GestureDockAllAppsItemViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockappitem/viewmodel/viewdata/GestureDockAllAppsItemViewDataMgr';

export default function GestureDockAllAppsItemViewDataMgrTest() {
  describe('GestureDockAllAppsItemViewDataMgrTest', () => {
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

    it('GestureDockAllAppsItemViewDataMgr_getHitTestBehavior_1', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.EDIT;
      allAppsItemViewDataMgr.appItemParam.isShowBadge = false;
      expect(allAppsItemViewDataMgr.getHitTestBehavior() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getHitTestBehavior_2', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      allAppsItemViewDataMgr.appItemParam.isShowBadge = true;
      expect(allAppsItemViewDataMgr.getHitTestBehavior() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getHitTestBehavior_3', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.EDIT;
      allAppsItemViewDataMgr.appItemParam.isShowBadge = true;
      expect(allAppsItemViewDataMgr.getHitTestBehavior() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_1', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.EDIT;
      allAppsItemViewDataMgr.appItemParam.isShowBadge = true;
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_2', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.EDIT;
      allAppsItemViewDataMgr.appItemParam.isShowBadge = false;
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_3', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_1', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_2', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_3', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_4', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_5', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_6', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_7', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_8', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_9', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_10', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_11', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_12', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_13', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_14', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_15', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_16', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_17', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_18', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_19', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_20', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_21', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_22', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_23', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_24', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_25', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_26', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_27', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_28', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_29', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_30', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_31', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_32', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_33', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_34', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_35', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_36', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_37', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_38', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_39', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_40', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_41', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_42', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_43', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_44', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_45', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_46', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_47', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_48', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_49', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_50', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_51', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAllAppsItemViewDataMgr_getOpacity_copy_52', 0, async (done: Function) => {
      let allAppsItemViewDataMgr: GestureDockAllAppsItemViewDataMgr = new GestureDockAllAppsItemViewDataMgr();
      let allAppsViewDataMgr: GestureDockAllAppsViewDataMgr = new GestureDockAllAppsViewDataMgr();
      let allAppsViewEventMgr: GestureDockAllAppsViewEventMgr = new GestureDockAllAppsViewEventMgr(allAppsViewDataMgr);
      allAppsViewEventMgr.allAppsParam.gestureDockShowMode = GestureDockMode.ALL_APPS
      expect(allAppsItemViewDataMgr.getOpacity() !== undefined).assertTrue();
      done();
    });
  })
}