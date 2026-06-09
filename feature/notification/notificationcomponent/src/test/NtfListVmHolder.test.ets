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
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { NtfListVm } from '../main/ets/model/NtfListVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfListVmHolder } from '..//main/ets/model/NtfListVmHolder';
export default function NtfListVmHolderTest() {
  describe('getNtfListVmInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_type_is_not_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertNull();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_ntfListVm_when_type_is_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertInstanceOf(NtfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('setNtfListVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      ntflistvmholder.setNtfListVm(1, new NtfListVm());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_ntfListVm_to_ntfVmMap_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      expect(ntflistvmholder.ntfVmMap.has(1)).assertTrue();
      expect(ntflistvmholder.ntfVmMap.get(1)).assertDeepEquals(ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callbacks_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let callback: NtfListVmCallback = {
        onNtfListVmChange: (type: number, ntfListVm: NtfListVm) => {
          expect(type).assertEqual(1);
          expect(ntfListVm).assertInstanceOf(NtfListVm);
        }
      };
      ntflistvmholder.callbacks.add(callback);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('getNtfListVmInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_type_is_not_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertNull();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_ntfListVm_when_type_is_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertInstanceOf(NtfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('setNtfListVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      ntflistvmholder.setNtfListVm(1, new NtfListVm());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_ntfListVm_to_ntfVmMap_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      expect(ntflistvmholder.ntfVmMap.has(1)).assertTrue();
      expect(ntflistvmholder.ntfVmMap.get(1)).assertDeepEquals(ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callbacks_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let callback: NtfListVmCallback = {
        onNtfListVmChange: (type: number, ntfListVm: NtfListVm) => {
          expect(type).assertEqual(1);
          expect(ntfListVm).assertInstanceOf(NtfListVm);
        }
      };
      ntflistvmholder.callbacks.add(callback);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('getNtfListVmInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_type_is_not_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertNull();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_ntfListVm_when_type_is_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertInstanceOf(NtfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('setNtfListVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      ntflistvmholder.setNtfListVm(1, new NtfListVm());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_ntfListVm_to_ntfVmMap_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      expect(ntflistvmholder.ntfVmMap.has(1)).assertTrue();
      expect(ntflistvmholder.ntfVmMap.get(1)).assertDeepEquals(ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callbacks_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let callback: NtfListVmCallback = {
        onNtfListVmChange: (type: number, ntfListVm: NtfListVm) => {
          expect(type).assertEqual(1);
          expect(ntfListVm).assertInstanceOf(NtfListVm);
        }
      };
      ntflistvmholder.callbacks.add(callback);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('getNtfListVmInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_type_is_not_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertNull();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_ntfListVm_when_type_is_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertInstanceOf(NtfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('setNtfListVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      ntflistvmholder.setNtfListVm(1, new NtfListVm());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_ntfListVm_to_ntfVmMap_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      expect(ntflistvmholder.ntfVmMap.has(1)).assertTrue();
      expect(ntflistvmholder.ntfVmMap.get(1)).assertDeepEquals(ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callbacks_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let callback: NtfListVmCallback = {
        onNtfListVmChange: (type: number, ntfListVm: NtfListVm) => {
          expect(type).assertEqual(1);
          expect(ntfListVm).assertInstanceOf(NtfListVm);
        }
      };
      ntflistvmholder.callbacks.add(callback);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('getNtfListVmInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_type_is_not_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertNull();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_ntfListVm_when_type_is_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertInstanceOf(NtfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('setNtfListVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      ntflistvmholder.setNtfListVm(1, new NtfListVm());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_ntfListVm_to_ntfVmMap_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      expect(ntflistvmholder.ntfVmMap.has(1)).assertTrue();
      expect(ntflistvmholder.ntfVmMap.get(1)).assertDeepEquals(ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_callbacks_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let callback: NtfListVmCallback = {
        onNtfListVmChange: (type: number, ntfListVm: NtfListVm) => {
          expect(type).assertEqual(1);
          expect(ntfListVm).assertInstanceOf(NtfListVm);
        }
      };
      ntflistvmholder.callbacks.add(callback);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('getNtfListVmInstance_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_null_when_type_is_not_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertNull();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_ntfListVm_when_type_is_in_map', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let result = ntflistvmholder.getNtfListVmInstance(1);
      expect(result).assertInstanceOf(NtfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
  describe('setNtfListVm_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      ntflistvmholder.setNtfListVm(1, new NtfListVm());
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_add_ntfListVm_to_ntfVmMap_when_setNtfListVm_is_called', 0, () => {
      let ntflistvmholder: NtfListVmHolder = new NtfListVmHolder();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      let ntfListVm: NtfListVm = new NtfListVm();
      ntflistvmholder.setNtfListVm(1, ntfListVm);
      expect(ntflistvmholder.ntfVmMap.has(1)).assertTrue();
      expect(ntflistvmholder.ntfVmMap.get(1)).assertDeepEquals(ntfListVm);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

  });
}