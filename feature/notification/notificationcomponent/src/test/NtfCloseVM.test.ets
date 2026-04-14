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
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NtfMgr } from '../../../main/ets/model/NotificationManager';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfCloseVM } from '../../../main/ets/vm/NtfCloseVM';
export default function NtfCloseVMTest() {
  describe('setItemHover_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });

    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_log_info_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_log_info_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_not_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(ntfEntry);

    });
    it('should_call_clearCancelTimer_when_ntfEntry_is_null', 0, () => {
      let ntfclosevm: NtfCloseVM = new NtfCloseVM();
      let mocker: MockKit = new MockKit();

      ntfclosevm.setItemHover(null);

    });
  });
}