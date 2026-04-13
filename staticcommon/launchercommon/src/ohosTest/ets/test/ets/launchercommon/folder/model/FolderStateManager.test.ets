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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { FolderState, FolderStateManager } from '../../../../../../../main/ets/folder/model/FolderStateManager';

export default function FolderStateManagerTest() {
  describe('FolderStateManagerTest', () => {
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

    it('test_canTransfer1', 0, () => {
      const instance: FolderStateManager = FolderStateManager.getInstance();
      expect(instance['transitions'][0].canTransfer(-1, -1)).assertFalse();
    })

    it('test_canTransfer1', 0, () => {
      const instance: FolderStateManager = FolderStateManager.getInstance();
      instance['transitions'][0]['whenCallback'] = (fromState: FolderState, toState: FolderState) => true;
      expect(instance['transitions'][0].canTransfer(FolderState.CLOSED, FolderState.OPENING)).assertTrue();
    })

    it('test_canTransfer1', 0, () => {
      const instance: FolderStateManager = FolderStateManager.getInstance();
      instance['transitions'][0]['performCallback'] = (fromState: FolderState, toState: FolderState) => true;
      instance['transitions'][0].doPerform(FolderState.CLOSED, FolderState.OPENING)
      expect(true).assertTrue();
    })

    it('test_doActionLater', 0, () => {
      const instance: FolderStateManager = FolderStateManager.getInstance();
      expect(instance['doActionLater'](instance['transitions'][0], FolderState.CLOSED)).assertFalse();
    })

    it('test_doAction1', 0, () => {
      const mocker: MockKit = new MockKit();
      const instance: FolderStateManager = FolderStateManager.getInstance();
      const trans = instance['transitions'][0];
      const canTransfer: Function = mocker.mockFunc(trans, trans.canTransfer);
      when(canTransfer)(ArgumentMatchers.any).afterReturn(false);
      expect(instance['doAction'](trans, 0)).assertFalse();
      mocker.clear(trans);
      mocker.clearAll();
    })

    it('test_doAction2', 0, () => {
      const mocker: MockKit = new MockKit();
      const instance: FolderStateManager = FolderStateManager.getInstance();
      const trans = instance['transitions'][0];
      const canTransfer: Function = mocker.mockFunc(trans, trans.canTransfer);
      when(canTransfer)(ArgumentMatchers.any).afterReturn(true);
      expect(instance['doAction'](trans, 0)).assertTrue();
      mocker.clear(trans);
      mocker.clearAll();
    })

    it('test_tryAction1', 0, () => {
      const mocker: MockKit = new MockKit();
      const instance: FolderStateManager = FolderStateManager.getInstance();
      const findTransition: Function = mocker.mockFunc(instance, instance['findTransition']);
      when(findTransition)(ArgumentMatchers.any).afterReturn(false);
      expect(instance.tryAction(0)).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_tryAction2', 0, () => {
      const mocker: MockKit = new MockKit();
      const instance: FolderStateManager = FolderStateManager.getInstance();
      const findTransition: Function = mocker.mockFunc(instance, instance['findTransition']);
      when(findTransition)(ArgumentMatchers.any).afterReturn(true);
      const doAction: Function = mocker.mockFunc(instance, instance['doAction']);
      when(doAction)(ArgumentMatchers.any).afterReturn(false);
      expect(instance.tryAction(0)).assertFalse();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_tryAction3', 0, () => {
      const mocker: MockKit = new MockKit();
      const instance: FolderStateManager = FolderStateManager.getInstance();
      const findTransition: Function = mocker.mockFunc(instance, instance['findTransition']);
      when(findTransition)(ArgumentMatchers.any).afterReturn(true);
      const doAction: Function = mocker.mockFunc(instance, instance['doAction']);
      when(doAction)(ArgumentMatchers.any).afterReturn(true);
      expect(instance.tryAction(0)).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    })

    it('test_getStatusDesc', 0, () => {
      const instance: FolderStateManager = FolderStateManager.getInstance();
      expect(instance.getStatusDesc().length > 0).assertTrue();
    })

  })
}