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

import formInfo from '@ohos.app.form.formInfo';
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
  ArgumentMatchers,
} from '@ohos/hypium';


import {
  FormBackboardVm,
  FormItemRelativeVm,
  FormMaskVm,
} from '../../../../../main/ets/default/common/components/form/viewmodel/FormItemRelativeVm';
import {
  OverflowSceneAnimationFormEvent
} from '../../../../../main/ets/default/common/components/liveform/event/OverflowSceneAnimationFormEvent';
import {
  OverflowViewModel
} from '../../../../../main/ets/default/common/components/liveform/viewmodel/OverflowViewModel';

function createOverflowSceneAnimationFormEvent(): OverflowSceneAnimationFormEvent {
  let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
  let formBackVm: FormBackboardVm = new FormBackboardVm();
  let formMaskVm: FormMaskVm = new FormMaskVm();
  return (new OverflowSceneAnimationFormEvent(formItemVm, formBackVm, formMaskVm));
}

function createOverflowInfo(): formInfo.OverflowInfo {
  let overflowInfo: formInfo.OverflowInfo = {
    area: {
      left: -25,
      top: -25,
      width: 150,
      height: 150
    },
    duration: 3500
  }
  return overflowInfo;
}

export function OverflowViewModelTest() {
  describe('OverflowViewModelTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    it('test_requestOverflow_overflowListener_does_not_exist', 0, () => {
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let key: string = '1';
      let overflowInfo: formInfo.OverflowInfo = createOverflowInfo();
      let result: boolean = overflowViewModel.requestOverflow(key, overflowInfo);
      expect(result).assertFalse();
    })

    it('test_requestOverflow_succeed', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      let overflowInfo: formInfo.OverflowInfo = createOverflowInfo();
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.requestOverflow);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = overflowViewModel.requestOverflow(key, overflowInfo);
      expect(result).assertTrue();
    })

    it('test_requestOverflow_failure', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      let overflowInfo: formInfo.OverflowInfo = createOverflowInfo();
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.requestOverflow);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = overflowViewModel.requestOverflow(key, overflowInfo);
      expect(result).assertFalse();
    })

    it('test_cancelOverflow_overflowListener_does_not_exist', 0, () => {
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let key: string = '1';
      let result: boolean = overflowViewModel.cancelOverflow(key);
      expect(result).assertFalse();
    })

    it('test_cancelOverflow_succeed', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.cancelOverflow);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = overflowViewModel.cancelOverflow(key);
      expect(result).assertTrue();
    })

    it('test_cancelOverflow_failure', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.cancelOverflow);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = overflowViewModel.cancelOverflow(key);
      expect(result).assertFalse();
    })

    it('test_activateSceneAnimation_overflowListener_does_not_exist', 0, () => {
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let key: string = '1';
      let result: boolean = overflowViewModel.activateSceneAnimation(key);
      expect(result).assertFalse();
    })

    it('test_activateSceneAnimation_succeed', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.activateSceneAnimation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = overflowViewModel.activateSceneAnimation(key);
      expect(result).assertTrue();
    })

    it('test_activateSceneAnimation_failure', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.activateSceneAnimation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = overflowViewModel.activateSceneAnimation(key);
      expect(result).assertFalse();
    })

    it('test_deactivateSceneAnimation_overflowListener_does_not_exist', 0, () => {
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let key: string = '1';
      let result: boolean = overflowViewModel.deactivateSceneAnimation(key);
      expect(result).assertFalse();
    })

    it('test_deactivateSceneAnimation_succeed', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.deactivateSceneAnimation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let result: boolean = overflowViewModel.deactivateSceneAnimation(key);
      expect(result).assertTrue();
    })

    it('test_deactivateSceneAnimation_failure', 0, () => {
      let mocker: MockKit = new MockKit();
      let overflowViewModel: OverflowViewModel = OverflowViewModel.getInstance();
      let overflowSceneAnimationFormEvent: OverflowSceneAnimationFormEvent = createOverflowSceneAnimationFormEvent();
      let key: string = '1';
      overflowViewModel.registerOverflowListener(key, overflowSceneAnimationFormEvent);
      let mockFunc: Function = mocker.mockFunc(overflowSceneAnimationFormEvent,
        overflowSceneAnimationFormEvent.deactivateSceneAnimation);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let result: boolean = overflowViewModel.deactivateSceneAnimation(key);
      expect(result).assertFalse();
    })
  })
}