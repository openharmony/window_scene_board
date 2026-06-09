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
import { NtfItemSwipeController } from '../../../main/ets/controller/NtfItemSwipeController';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NtfCloseVM } from '../../../main/ets/vm/NtfCloseVM';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfSingleItemModifier } from '../../../main/ets/model/NtfItemModifier';
export default function NtfSingleItemModifierTest() {
  describe('applyNormalAttribute_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

    it('should_call_onAreaChange_and_onHover_when_closeVM_is_not_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnAreaChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      let mockOnHover: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onHover);

      when(mockOnAreaChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);
      when(mockOnHover)(ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onAreaChange);
      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onHover);
    });

    it('should_call_onSizeChange_when_closeVM_is_null', 0, () => {
      let mocker: MockKit = new MockKit();
      let swipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      let ntfSingleItemModifier: NtfSingleItemModifier = new NtfSingleItemModifier(swipeController, closeVM);

      let mockOnSizeChange: Function = mocker.mockFunc(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);

      when(mockOnSizeChange)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(null);

      let instance: ColumnAttribute = new ColumnAttribute();
      ntfSingleItemModifier.applyNormalAttribute(instance);

      mocker.ignoreMock(ntfSingleItemModifier, ntfSingleItemModifier.onSizeChange);
    });

  });
}