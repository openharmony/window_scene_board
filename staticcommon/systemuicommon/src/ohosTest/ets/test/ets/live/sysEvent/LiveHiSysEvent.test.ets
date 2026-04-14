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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { HiSysReportBase } from '../../../../../../main/ets/hiSysEvent/HiSysReportBase';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import {
  LiveEvent,
  LiveHiSysEvent, RecordCapsuleClickParams } from '../../../../../../main/ets/live/sysEvent/LiveHiSysEvent';


export default function LiveHiSysEventTest() {
  describe('reportRecordCapsuleClickEvent_testSuite', () => {
    let mocker: MockKit;
    let mockRecordCapsuleClickParams: RecordCapsuleClickParams;

    beforeEach(() => {
      mocker = new MockKit();
      mockRecordCapsuleClickParams = mocker.mockFunc(RecordCapsuleClickParams.prototype, RecordCapsuleClickParams.prototype.init);
      when(mockRecordCapsuleClickParams)(ArgumentMatchers.any).afterReturn(new RecordCapsuleClickParams());
    });

    afterEach(() => {
      mocker.ignoreMock(RecordCapsuleClickParams.prototype, RecordCapsuleClickParams.prototype.init);
    });

    it('should_report_event_with_correct_params_when_live_is_not_null', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1;
      live.creatorBundleName = "com.example";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example",
        NOTIFICATION_ID: "1"
      });
    });

    it('should_report_event_with_default_notification_id_when_live_id_is_null', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = null;
      live.creatorBundleName = "com.example";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_empty_creator_bundle_name_when_live_creatorBundleName_is_null', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1;
      live.creatorBundleName = null;

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "1"
      });
    });

    it('should_not_report_event_when_live_is_null', 0, async () => {
      let live: LiveNotification = null;

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertNotCalled();
    });

    it('should_handle_error_when_recordCapsuleClickParams_init_fails', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1;
      live.creatorBundleName = "com.example";

      when(mockRecordCapsuleClickParams)(ArgumentMatchers.any).afterThrow(new Error("Initialization failed"));

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertNotCalled();
    });

    it('should_report_event_with_correct_params_when_live_has_non_numeric_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "non-numeric";
      live.creatorBundleName = "com.example";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example",
        NOTIFICATION_ID: "non-numeric"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_empty_string_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "";
      live.creatorBundleName = "com.example";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example",
        NOTIFICATION_ID: ""
      });
    });

    it('should_report_event_with_correct_params_when_live_has_zero_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 0;
      live.creatorBundleName = "com.example";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_negative_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = -1;
      live.creatorBundleName = "com.example";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example",
        NOTIFICATION_ID: "-1"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_large_number_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1234567890;
      live.creatorBundleName = "com.example";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example",
        NOTIFICATION_ID: "1234567890"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "1"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_empty_string_creatorBundleName', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1;
      live.creatorBundleName = "";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "1"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_null_creatorBundleName_and_non_numeric_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "non-numeric";
      live.creatorBundleName = null;

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "non-numeric"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_empty_string_creatorBundleName_and_non_numeric_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "non-numeric";
      live.creatorBundleName = "";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "non-numeric"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_null_creatorBundleName_and_empty_string_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "";
      live.creatorBundleName = null;

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: ""
      });
    });

    it('should_report_event_with_correct_params_when_live_has_empty_string_creatorBundleName_and_empty_string_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "";
      live.creatorBundleName = "";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: ""
      });
    });

    it('should_report_event_with_correct_params_when_live_has_null_creatorBundleName_and_zero_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 0;
      live.creatorBundleName = null;

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_empty_string_creatorBundleName_and_zero_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 0;
      live.creatorBundleName = "";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_null_creatorBundleName_and_negative_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = -1;
      live.creatorBundleName = null;

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "-1"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_empty_string_creatorBundleName_and_negative_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = -1;
      live.creatorBundleName = "";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "-1"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_null_creatorBundleName_and_large_number_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1234567890;
      live.creatorBundleName = null;

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "1234567890"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_empty_string_creatorBundleName_and_large_number_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1234567890;
      live.creatorBundleName = "";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "",
        NOTIFICATION_ID: "1234567890"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_non_numeric_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "non-numeric";
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "non-numeric"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_empty_string_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "";
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: ""
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_zero_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 0;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_negative_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = -1;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "-1"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_large_number_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1234567890;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "1234567890"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_null_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = null;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_undefined_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = undefined;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_non_numeric_id_and_null_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "non-numeric";
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "non-numeric"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_empty_string_id_and_null_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = "";
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: ""
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_zero_id_and_null_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 0;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "0"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_negative_id_and_null_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = -1;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "-1"
      });
    });

    it('should_report_event_with_correct_params_when_live_has_special_characters_in_creatorBundleName_and_large_number_id_and_null_id', 0, async () => {
      let live: LiveNotification = new LiveNotification();
      live.id = 1234567890;
      live.creatorBundleName = "com.example!@#$%^&*()";

      await LiveHiSysEvent.reportRecordCapsuleClickEvent(live);

      expect(HiSysReportBase.reportBehavior).assertCalledWith(LiveEvent.NOTIFICATION_CLICK_BUTTON, {
        SCRRECORD_CAPSULE_CLICK_BUTTON: 1,
        CREATOR_BUNDLE_NAME: "com.example!@#$%^&*()",
        NOTIFICATION_ID: "1234567890"
      });
    });

