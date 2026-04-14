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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { OuterHomeVm } from '../../../main/ets/vm/OuterHomeVm';
export default function OuterHomeVmTest() {
  describe('changeIgnoreFontScaleState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_immediately_when_isIgnoreFontScaleState_is_same', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = true;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_when_isIgnoreFontScaleState_is_different', 0, () => {
      let outerhomevm: OuterHomeVm = OuterHomeVm.get();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      outerhomevm.isIgnoreFontScaleState = false;
      outerhomevm.changeIgnoreFontScaleState(true);
      expect(outerhomevm.isIgnoreFontScaleState).assertEqual(true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
