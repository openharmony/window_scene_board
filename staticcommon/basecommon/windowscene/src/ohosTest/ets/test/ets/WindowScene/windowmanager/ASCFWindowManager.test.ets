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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { ASCFWindowManager, WindowMode } from '../../../../../../main/ets/windowmanager/ASCFWindowManager';


interface AtomicServiceInfoParam {
  resizable: number;
  deviceTypes: string[];
  supportWindowMode: string[];
}

export function ASCFWindowManagerTest() {
  describe('ASCFWindowManagerTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('should_return_undefined_when_bundleName_is_empty', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = '';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      const result = ascfwindowmanager.queryFullScreenModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertUndefined();
    });

    it('should_return_COMPATIBLE_FULLSCREEN_when_bundleName_exists_and_mode_is_COMPATIBLE_FULLSCREEN', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = 'testBundle';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      atomicServiceInfoParam.resizable = 0;
      atomicServiceInfoParam.supportWindowMode = ['floating'];
      atomicServiceInfoParam.deviceTypes = ['phone'];
      (ascfwindowmanager as object)['bundleNameParamsMap'].set(bundleName, WindowMode.COMPATIBLE_FULLSCREEN);
      const result = ascfwindowmanager.queryFullScreenModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertEqual(WindowMode.COMPATIBLE_FULLSCREEN);
    });

    it('should_return_SPREAD_FULLSCREEN_when_resizable_is_0', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = 'testBundle';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      atomicServiceInfoParam.resizable = 0;
      atomicServiceInfoParam.supportWindowMode = ['floating'];
      atomicServiceInfoParam.deviceTypes = ['phone'];
      (ascfwindowmanager as object)['bundleNameParamsMap'].set(bundleName, WindowMode.COMPATIBLE_FULLSCREEN);
      const result = ascfwindowmanager.queryFullScreenModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertEqual(WindowMode.SPREAD_FULLSCREEN);
    });

    it('should_return_SPREAD_FULLSCREEN_when_resizable_is_1_and_deviceTypes_includes_DEVICE_TYPE', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = 'testBundle';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      atomicServiceInfoParam.resizable = 1;
      atomicServiceInfoParam.supportWindowMode = ['floating'];
      atomicServiceInfoParam.deviceTypes = ['phone'];
      (ascfwindowmanager as object)['bundleNameParamsMap'].set(bundleName, WindowMode.COMPATIBLE_FULLSCREEN);
      const result = ascfwindowmanager.queryFullScreenModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertEqual(WindowMode.SPREAD_FULLSCREEN);
    });

    it('should_return_COMPATIBLE_FULLSCREEN_when_resizable_is_1_and_deviceTypes_does_not_include_DEVICE_TYPE', 0,
      () => {
        let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
        let bundleName: string = 'testBundle';
        let atomicServiceInfoParam: AtomicServiceInfoParam = {
          resizable: 1,
          deviceTypes: [],
          supportWindowMode: []
        };
        atomicServiceInfoParam.resizable = 1;
        atomicServiceInfoParam.supportWindowMode = ['floating'];
        atomicServiceInfoParam.deviceTypes = ['otherDeviceType'];
        (ascfwindowmanager as object)['bundleNameParamsMap'].set(bundleName, WindowMode.COMPATIBLE_FULLSCREEN);
        const result = ascfwindowmanager.queryFullScreenModeSync(bundleName, atomicServiceInfoParam);
        expect(result).assertEqual(WindowMode.COMPATIBLE_FULLSCREEN);
      });

    it('should_return_undefined_when_bundleName_is_empty', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = '';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      const result = ascfwindowmanager.queryWindowModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertUndefined();
    });

    it('should_return_FLOATINGWINDOW_when_bundleName_is_valid_and_FLOATINGWINDOW_is_supported', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = 'validBundleName';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      atomicServiceInfoParam.supportWindowMode = ['floating'];
      const result = ascfwindowmanager.queryWindowModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertEqual(WindowMode.FLOATINGWINDOW);
    });

    it('should_return_COMPATIBLE_FULLSCREEN_when_bundleName_is_valid_and_COMPATIBLE_FULLSCREEN_is_supported', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = 'validBundleName';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      atomicServiceInfoParam.supportWindowMode = ['compatible_fullscreen'];
      const result = ascfwindowmanager.queryWindowModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertEqual(WindowMode.COMPATIBLE_FULLSCREEN);
    });

    it('should_return_SPREAD_FULLSCREEN_when_bundleName_is_valid_and_resizable_is_0_or_deviceTypes_includes_DEVICE_TYPE',
      0, () => {
        let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
        let bundleName: string = 'validBundleName';
        let atomicServiceInfoParam: AtomicServiceInfoParam = {
          resizable: 1,
          deviceTypes: [],
          supportWindowMode: []
        };
        atomicServiceInfoParam.resizable = 0;
        atomicServiceInfoParam.deviceTypes = ['phone'];
        const result = ascfwindowmanager.queryWindowModeSync(bundleName, atomicServiceInfoParam);
        expect(result).assertEqual(WindowMode.SPREAD_FULLSCREEN);
      });

    it('should_return_SPREAD_FULLSCREEN_when_bundleName_is_valid_and_resizable_is_1_and_supportWindowMode_includes_spread_fullscreen',
      0, () => {
        let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
        let bundleName: string = 'validBundleName';
        let atomicServiceInfoParam: AtomicServiceInfoParam = {
          resizable: 1,
          deviceTypes: [],
          supportWindowMode: []
        };
        atomicServiceInfoParam.resizable = 1;
        atomicServiceInfoParam.supportWindowMode = ['spread_fullscreen'];
        const result = ascfwindowmanager.queryWindowModeSync(bundleName, atomicServiceInfoParam);
        expect(result).assertEqual(WindowMode.SPREAD_FULLSCREEN);
      });

    it('should_return_COMPATIBLE_FULLSCREEN_when_bundleName_is_valid_and_resizable_is_1_and_no_other_mode_is_supported',
      0, () => {
        let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
        let bundleName: string = 'validBundleName';
        let atomicServiceInfoParam: AtomicServiceInfoParam = {
          resizable: 1,
          deviceTypes: [],
          supportWindowMode: []
        };
        atomicServiceInfoParam.resizable = 1;
        const result = ascfwindowmanager.queryWindowModeSync(bundleName, atomicServiceInfoParam);
        expect(result).assertEqual(WindowMode.COMPATIBLE_FULLSCREEN);
      });

    it('should_return_undefined_when_all_conditions_are_met_but_resizable_is_not_0_or_1', 0, () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      let bundleName: string = 'validBundleName';
      let atomicServiceInfoParam: AtomicServiceInfoParam = {
        resizable: 1,
        deviceTypes: [],
        supportWindowMode: []
      };
      atomicServiceInfoParam.resizable = 2;
      const result = ascfwindowmanager.queryWindowModeSync(bundleName, atomicServiceInfoParam);
      expect(result).assertUndefined();
    });

    it('queryWindowMode_bundleName_is_empty', 0, async () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      const result = await ascfwindowmanager.queryWindowMode('');
      expect(result).assertEqual(undefined);
    });

    it('queryWindowMode_FLOATINGWINDOW', 0, async () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      const result = await ascfwindowmanager.queryWindowMode('com.atomicservice.5765880207853275489');
      expect(result).assertEqual(WindowMode.FLOATINGWINDOW);
    });

    it('queryWindowMode_SPREAD_FULLSCREEN', 0, async () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      const result = await ascfwindowmanager.queryWindowMode('com.atomicservice.5765880207853636497');
      expect(result).assertEqual(WindowMode.SPREAD_FULLSCREEN);
    });

    it('queryFullScreenMode_bundleName_is_empty', 0, async () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      const result = await ascfwindowmanager.queryFullScreenMode('');
      expect(result).assertEqual(undefined);
    });

    it('queryFullScreenMode_FLOATINGWINDOW', 0, async () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      const result = await ascfwindowmanager.queryFullScreenMode('com.atomicservice.5765880207853275489');
      expect(result).assertEqual(WindowMode.COMPATIBLE_FULLSCREEN);
    });

    it('queryFullScreenMode_SPREAD_FULLSCREEN', 0, async () => {
      let ascfwindowmanager: ASCFWindowManager = new ASCFWindowManager();
      const result = await ascfwindowmanager.queryFullScreenMode('com.atomicservice.5765880207853636497');
      expect(result).assertEqual(WindowMode.SPREAD_FULLSCREEN);
    });
  });
}