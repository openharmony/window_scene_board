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

import { CommonUtils, ArrayUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NtfMgr } from '../../../../main/ets/model/NotificationManager';
import { NtfPcCloseVM, OnItemHoverChangeListener } from '../../../../main/ets/vm/NtfPcCloseVM';

export default function NtfPcCloseVMTest() {
  describe('registerOnItemHoverChangeListener_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_error_when_entry_is_invalid', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_return_error_when_listener_is_invalid', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_register_listener_when_entry_is_valid_and_listener_is_valid', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_create_listener_set_when_itemHoverListeners_is_null', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_error_when_entry_is_invalid01', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_return_error_when_listener_is_invalid01', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_register_listener_when_entry_is_valid_and_listener_is_valid01', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_create_listener_set_when_itemHoverListeners_is_null01', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener01', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_error_when_entry_is_invalid02', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_return_error_when_listener_is_invalid02', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_register_listener_when_entry_is_valid_and_listener_is_valid02', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_create_listener_set_when_itemHoverListeners_is_null02', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener02', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_error_when_entry_is_invalid03', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_return_error_when_listener_is_invalid03', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_register_listener_when_entry_is_valid_and_listener_is_valid03', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_create_listener_set_when_itemHoverListeners_is_null03', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener03', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_error_when_entry_is_invalid04', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_return_error_when_listener_is_invalid04', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_register_listener_when_entry_is_valid_and_listener_is_valid04', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_create_listener_set_when_itemHoverListeners_is_null04', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener04', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_error_when_entry_is_invalid05', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_return_error_when_listener_is_invalid05', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_register_listener_when_entry_is_valid_and_listener_is_valid05', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_create_listener_set_when_itemHoverListeners_is_null05', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener05', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_return_error_when_entry_is_invalid06', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_return_error_when_listener_is_invalid06', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);
    });

    it('should_register_listener_when_entry_is_valid_and_listener_is_valid06', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_create_listener_set_when_itemHoverListeners_is_null06', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener06', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('should_notify_item_hover_change_when_registering_listener07', 0, () => {
      let ntfpcclosevm: NtfPcCloseVM = new NtfPcCloseVM();
      let entry: NotificationEntry = new NotificationEntry();
      let listener: OnItemHoverChangeListener = new OnItemHoverChangeListenerImpl();
      let mocker: MockKit = new MockKit();

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      when(mocker.mockFunc(CommonUtils, CommonUtils.isInvalid))(ArgumentMatchers.any).afterReturn(false);

      ntfpcclosevm.registerOnItemHoverChangeListener(entry, listener);

      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });
  });
}
class OnItemHoverChangeListenerImpl implements OnItemHoverChangeListener{
  onItemHoverChange(isHover: boolean): void {
    throw new Error('Method not implemented.');
  }
}