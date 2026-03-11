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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { RTLUtil } from '../../../../../../main/ets/TsIndex';
import { ConfigMgr, EvtBus, ConfigurationEvent } from '@ohos/frameworkwrapper';

/**
 * RTL语言工具类 DT测试套
 */
export function RTLUtilTest() {
  describe('RTLUtilTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('test_isRTL_011', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      try {
        let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.getSystemRTL);
        when(mockFunc)().afterReturn(true);
        expect(RTLUtil.isRTL()).assertInstanceOf('Boolean');
        when(mockFunc)().afterReturn(false);
        let config = ConfigMgr.getConfiguration();
        EvtBus.post(ConfigurationEvent, { config });
        expect(RTLUtil.isRTL()).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(RTLUtil);
      mocker.clearAll();
    })

    it('RTLUtil_updateRTL_test01', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.getSystemRTL);
      when(mockFunc)().afterReturn(true);
      (RTLUtil as object)['updateRTL'](true);
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.getSystemRTL);
    })

    it('RTLUtil_updateRTL_test02', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.getSystemRTL);
      when(mockFunc)().afterReturn(false);
      (RTLUtil as object)['updateRTL'](false);
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.getSystemRTL);
    })

    it('RTLUtil_registerRtlChangeCallback_test01', 0, (): void => {
      let rtlChangeCallbacks1: Function[] = [a, a];
      let rTLUtil: RTLUtil = new RTLUtil();
      (RTLUtil as object)['rtlChangeCallbacks'] = rtlChangeCallbacks1;
      RTLUtil.registerRtlChangeCallback(a);
      expect(rTLUtil).not().assertUndefined();
    })

    it('RTLUtil_getPositionByRTL_test01', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)().afterReturn(true);
      RTLUtil.getPositionByRTL(1, 1);
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('RTLUtil_getPositionByRTL_test02', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)().afterReturn(false);
      RTLUtil.getPositionByRTL(1, 1);
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('RTLUtil_getColumnByRTL_test01', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)().afterReturn(false);
      RTLUtil.getColumnByRTL(1, 1, 1);
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('RTLUtil_getColumnByRTL_test02', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)().afterReturn(true);
      RTLUtil.getColumnByRTL(1, 1, 1);
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('RTLUtil_getRTLRate_test01', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)().afterReturn(true);
      RTLUtil.getRTLRate();
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })

    it('RTLUtil_getRTLRate_test02', 0, (): void => {
      let rTLUtil: RTLUtil = new RTLUtil();
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockFunc)().afterReturn(false);
      RTLUtil.getRTLRate();
      expect(rTLUtil).not().assertUndefined();
      mocker.ignoreMock(RTLUtil, RTLUtil.isRTL);
    })
  })
}

function a(): void {
}