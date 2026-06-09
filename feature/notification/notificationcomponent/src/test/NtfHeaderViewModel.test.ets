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
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { CommonUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfHeaderVM } from '../../../main/ets/vm/NtfHeaderVM';
export default function NtfHeaderVMTest() {
  describe('setItemExpandState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_call_callback_when_callback_is_not_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let callback: HeaderCallback = {
        onItemExpandChange: (isItemExpanded: boolean) => {
          expect(isItemExpanded).assertEqual(true);
        }
      };
      ntfheadervm.callback = callback;
      ntfheadervm.setItemExpandState(true);
    });

    it('should_not_call_callback_when_callback_is_null', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      ntfheadervm.callback = null;
      ntfheadervm.setItemExpandState(true);
    });

  });
  describe('refreshSubtext_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });

    it('should_return_immediately_when_entry_is_invalid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
    });

    it('should_call_onUpdateSubtext_when_entry_is_valid', 0, () => {
      let ntfheadervm: NtfHeaderVM = new NtfHeaderVM();
      let mocker: MockKit = new MockKit();
      let commonUtils: CommonUtils = CommonUtils.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(commonUtils, commonUtils.isInvalid);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let notificationEntry: NotificationEntry = new NotificationEntry();
      notificationEntry.notificationContent = { additionalText: 'test text' };
      let mockfunc2: Function = mocker.mockFunc(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
      when(mockfunc2)().afterReturn(notificationEntry);
      ntfheadervm.refreshSubtext();
      mocker.ignoreMock(commonUtils, commonUtils.isInvalid);
      mocker.ignoreMock(ntfheadervm.callback, ntfheadervm.callback.getNtfEntry);
    });
  });
}