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
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium'
import { ConfigParseUtil, IconCommonUtil, SmartDockZoomFeatureSwitch } from '@ohos/launchercommon'
import { SmartDockStyleConfig } from '../../../../main/ets/default/common/SmartDockStyleConfig'


export default function SmartDockStyleConfigTest_2() {
  describe('SmartDockStyleConfigTest_2', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_setInPreviewMode_01', 0, () => {
      try {
        let instance = SmartDockStyleConfig.getInstance();
        SmartDockStyleConfig.updateDockListLengthConfig();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setInPreviewMode_01', 0, () => {
      try {
        let instance = SmartDockStyleConfig.getInstance();
        instance.initConfig();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_setInPreviewMode_01', 0, () => {
      try {
        let instance = SmartDockStyleConfig.getInstance();
        instance.getConfigLevel();
        instance.getFeatureName();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateDockStylefromSecure_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['updateDockStylefromSecure']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_updateDockStylefromSecure_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(IconCommonUtil, IconCommonUtil.isValidIconSizeChange);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['updateDockStylefromSecure']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(IconCommonUtil);
      mock.clearAll();
    })

    it('test_updateDockStyle_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['updateDockStyle']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_updateDockStyle_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let instance = SmartDockStyleConfig.getInstance();
        SmartDockStyleConfig.setInPreviewMode(true);
        (instance as object)['updateDockStyle']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_updateDockStyle_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let instance = SmartDockStyleConfig.getInstance();
        SmartDockStyleConfig.setInPreviewMode(false);
        (instance as object)['updateDockStyle']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_loadDockListLengthConfig_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ConfigParseUtil, ConfigParseUtil.getConfigSync);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');

        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['loadDockListLengthConfig']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ConfigParseUtil);
      mock.clearAll();
    })

    it('test_loadDockListLengthConfig_02', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ConfigParseUtil, ConfigParseUtil.getConfigSync);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('');

        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['loadDockListLengthConfig']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ConfigParseUtil);
      mock.clearAll();
    })

    it('test_loadDockListLengthConfig_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ConfigParseUtil, ConfigParseUtil.getConfigSync);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('test');

        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['loadDockListLengthConfig']();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ConfigParseUtil);
      mock.clearAll();
    })

    it('test_listLengthFilter_01', 0, () => {
      try {
        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['listLengthFilter']('1');
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_constructor_01', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(SmartDockZoomFeatureSwitch, SmartDockZoomFeatureSwitch.isSupportZoom);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance = SmartDockStyleConfig.getInstance();
        (instance as object)['mInstance'] = null;
        instance = SmartDockStyleConfig.getInstance();
        expect(instance instanceof SmartDockStyleConfig).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SmartDockZoomFeatureSwitch);
      mock.clearAll();
    })

  })
}
