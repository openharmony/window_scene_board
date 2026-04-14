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
  it,
  expect,
  MockKit,
  when,
} from '@ohos/hypium'
import {
  FormBackboardVm,
  FormItemRelativeVm,
  FormMaskVm,
} from '../../../../../../../main/ets/default/common/components/form/viewmodel/FormItemRelativeVm';
import {
  OverflowFormItemEvent
} from '../../../../../../../main/ets/default/common/components/form/viewmodel/OverflowFormItemEvent';
import {
  OverflowFormStatusController,
  OverflowOperation,
} from '../../../../../../../main/ets/default/common/components/liveform/controller/status/OverflowFormStatusController';
import {
  OverflowFormStatus,
  OverflowFormVm
} from '../../../../../../../main/ets/default/common/components/liveform/viewmodel/OverflowFormVm';

export default function OverflowFormStatusControllerTest() {
  describe('OverflowFormStatusControllerTest', () => {

    it('Test_updateOverflowFormActiveTimer', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      controller.initFunction(undefined, undefined, undefined);
      controller.updateOverflowFormActiveTimer(formItemEvent, overflowFormVm);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(controller, (controller as object)['getCanupdateStatus']);
      when(mockFunc)().afterReturn(true);
      controller.registerOperation(formItemEvent, OverflowFormStatus.PAUSE, true, overflowFormVm, null);
      (controller as object)['mOperationQueue'] = [];
      controller.updateStatus(formItemEvent, overflowFormVm, null);
      let operation: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.PAUSE, true);
      (controller as object)['mOperationQueue'] = [operation];
      controller.updateStatus(formItemEvent, overflowFormVm, null);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.clear(controller);
    });

    it('Test_reportGameCardEvent_pickFormalOperation', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      (controller as object)['reportGameCardEvent'](formItemEvent, OverflowFormStatus.INACTIVE);
      (controller as object)['reportGameCardEvent'](formItemEvent, OverflowFormStatus.PAUSE);
      let operation1: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.INACTIVE, true);
      let operation2: OverflowOperation =
        new OverflowOperation(new Date().getTime(), OverflowFormStatus.PAUSE, true);
      expect((controller as object)['pickFormalOperation'](operation1, operation2)).assertEqual(operation1);
      let operation3: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.PAUSE, true);
      let operation4: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.PAUSE, true);
      expect((controller as object)['pickFormalOperation'](operation3, operation4)).assertEqual(operation4);
      let operation5: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.PAUSE, true);
      expect((controller as object)['pickFormalOperation'](operation5, operation5)).assertEqual(operation5);
    });

    it('Test_canDoOperation', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      let operation1: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.INACTIVE, true);
      expect((controller as object)['canDoOperation'](operation1, formItemEvent, overflowFormVm, null)).assertTrue();
      let operation2: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.PAUSE, true);
      (controller as object)['canDoOperation'](operation2, formItemEvent, overflowFormVm, null);
      let operation3: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.ACTIVE, true);
      (controller as object)['canDoOperation'](operation3, formItemEvent, overflowFormVm, null);
      let operation4: OverflowOperation = new OverflowOperation(new Date().getTime(), 6, true);
      expect((controller as object)['canDoOperation'](operation4, formItemEvent, overflowFormVm, null)).assertFalse();
    });

    it('Test_canChangeToInactive', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      expect((controller as object)['canChangeToInactive']()).assertTrue();
    });

    it('Test_canChangeToPause', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.PAUSE;
      overflowFormVm.isInLongPress = false;
      expect((controller as object)['canChangeToPause'](overflowFormVm)).assertFalse();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.INACTIVE;
      expect((controller as object)['canChangeToPause'](overflowFormVm)).assertFalse();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      expect((controller as object)['canChangeToPause'](overflowFormVm)).assertTrue();
    });

    it('Test_canChangeToActive_1', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.ACTIVE;
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      expect((controller as object)['canChangeToActive'](formItemEvent, overflowFormVm, null)).assertFalse();
    });

    it('Test_canChangeToActive_2', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.INACTIVE;
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(controller, (controller as object)['isReadyChangeActive']);
      when(mockFunc)().afterReturn(true);
      expect((controller as object)['canChangeToActive'](formItemEvent, overflowFormVm, null)).assertFalse();
      mocker.clear(controller);
    });

    it('Test_canChangeToActive_3', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.INACTIVE;
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(controller, (controller as object)['isReadyChangeActive']);
      when(mockFunc)().afterReturn(false);
      expect((controller as object)['canChangeToActive'](formItemEvent, overflowFormVm, null)).assertFalse();
      mocker.clear(controller);
    });

    it('Test_handleFormalOperation', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      let formItemVm: FormItemRelativeVm = new FormItemRelativeVm();
      let formBackVm: FormBackboardVm = new FormBackboardVm();
      let formMaskVm: FormMaskVm = new FormMaskVm();
      let overflowFormVm: OverflowFormVm = new OverflowFormVm();
      overflowFormVm.overFlowFormStatus = OverflowFormStatus.INACTIVE;
      let formItemEvent: OverflowFormItemEvent = new OverflowFormItemEvent(formItemVm, formBackVm, formMaskVm);
      let operation: OverflowOperation = new OverflowOperation(new Date().getTime(), OverflowFormStatus.INACTIVE, true);
      operation.targetStatus = OverflowFormStatus.INACTIVE;
      operation.hasAnimation = true;
      (controller as object)['handleFormalOperation'](formItemEvent, operation, overflowFormVm);
      operation.hasAnimation = false;
      (controller as object)['handleFormalOperation'](formItemEvent, operation, overflowFormVm);
      operation.targetStatus = OverflowFormStatus.PAUSE;
      operation.hasAnimation = true;
      (controller as object)['handleFormalOperation'](formItemEvent, operation, overflowFormVm);
      operation.hasAnimation = false;
      (controller as object)['handleFormalOperation'](formItemEvent, operation, overflowFormVm);
      operation.targetStatus = OverflowFormStatus.ACTIVE;
      operation.hasAnimation = true;
      (controller as object)['handleFormalOperation'](formItemEvent, operation, overflowFormVm);
      operation.targetStatus = 5;
      operation.hasAnimation = true;
      (controller as object)['handleFormalOperation'](formItemEvent, operation, overflowFormVm);
      expect(operation.hasAnimation).assertTrue();
    });

    it('Test_clearOverflowFormActiveTimer', 0, () => {
      let controller: OverflowFormStatusController = new OverflowFormStatusController('cardId');
      (controller as object)['mPauseTimer'] = true;
      (controller as object)['clearOverflowFormActiveTimer']();
      expect((controller as object)['mPauseTimer']).assertUndefined();
    });
  })
}