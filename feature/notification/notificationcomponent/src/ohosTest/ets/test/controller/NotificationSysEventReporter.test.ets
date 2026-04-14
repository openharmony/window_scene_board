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

import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import { NtfControlConfig } from '@ohos/systemuicommon/src/main/ets/model/NtfControlFlags'
import {
  BaseNotification,
  NotificationSysEventReporter, SystemuiConstants } from '@ohos/systemuicommon/src/main/ets/TsIndex'

export default function NotificationSysEventReporterTest() {
  let entry: BaseNotification = new BaseNotification();
  describe('NotificationSysEventReporterTest', (): void => {
    beforeAll((): void => {
      entry.creatorBundleName = SystemuiConstants.PUSH_BUNDLE_NAME;
      entry.slotType = 3;
      entry.id = Math.random();
      const controlConfig: NtfControlConfig = new NtfControlConfig(1 << 25);
      entry.controlConfig = controlConfig;
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('should_reporter_notificationSlipLeft', 0, () => {
      NotificationSysEventReporter.notificationSlipLeft({
        CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
        NOTIFICATION_SLOT_TYPE: entry?.slotType,
        TIME_STAMP: `${new Date().getTime()}`,
        NOTIFICATION_ID: entry?.id,
        NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags
      });
      expect(NotificationSysEventReporter.NOTIFICATION_UE).assertEqual('NOTIFICATION_UE');
    });

    it('should_reporter_notificationSlipLeftRight', 0, () => {
      NotificationSysEventReporter.notificationSlipLeftRight({
        CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
        NOTIFICATION_ID: entry?.id,
        NOTIFICATION_SLOT_TYPE: 3,
        DISPLAY_SCENE: 2,
        TIME_STAMP: `${new Date().getTime()}`,
        IS_GROUP: 0,
        IS_AGGREGATE: 0,
        NOTIFICATION_CONTROL_FLAGS: entry.controlConfig?.flags
      });
      expect(NotificationSysEventReporter.NOTIFICATION_UE).assertEqual('NOTIFICATION_UE');
    });

    it('should_reporter_notificationClickButton', 0, () => {
      NotificationSysEventReporter.notificationClickButton({
        DISPLAY_SCENE: 4,
        IS_LIVE: 1,
        CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
        NOTIFICATION_ID: entry?.id,
        NOTIFICATION_SLOT_TYPE: 3,
        TIME_STAMP: `${new Date().getTime()}`,
        BUTTON_INDEX: 1,
        IS_IN_GROUP: 0,
        IS_IN_AGGREGATE: 0,
        NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags
      });
      expect(NotificationSysEventReporter.NOTIFICATION_UE).assertEqual('NOTIFICATION_UE');
    });

    it('should_reporter_notificationPanelSlipLeftDelete', 0, () => {
      NotificationSysEventReporter.notificationPanelSlipLeftDelete({
        DISPLAY_SCENE: 4,
        CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
        NOTIFICATION_ID: entry?.id,
        NOTIFICATION_SLOT_TYPE: 3,
        TIME_STAMP: `${new Date().getTime()}`,
        IS_GROUP: 0,
        IS_AGGREGATE: 1,
        NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags
      });
      expect(NotificationSysEventReporter.NOTIFICATION_UE).assertEqual('NOTIFICATION_UE');
    });

    it('should_reporter_notificationClickApp', 0, () => {
      NotificationSysEventReporter.notificationClickApp({
        DISPLAY_SCENE: 2,
        CREATOR_BUNDLE_NAME: entry?.creatorBundleName,
        IS_LIVE: 1,
        NOTIFICATION_ID: entry?.id,
        NOTIFICATION_SLOT_TYPE: entry?.slotType,
        TIME_STAMP: `${new Date().getTime()}`,
        IS_IN_GROUP: 0,
        IS_IN_AGGREGATE: 0,
        IS_MIDSCENE: 0,
        NOTIFICATION_CONTROL_FLAGS: entry?.controlConfig?.flags
      });
      expect(NotificationSysEventReporter.NOTIFICATION_UE).assertEqual('NOTIFICATION_UE');
    });

    it('should_reporter_notificationOnScreen', 0, () => {
      NotificationSysEventReporter.notificationOnScreen({
        IS_PUSH: 0,
        IS_GROUP: 0,
        CREATOR_BUNDLE_NAME: entry.creatorBundleName,
        NOTIFICATION_ID: entry.id,
        NOTIFICATION_SLOT_TYPE: 3,
        DISPLAY_SCENE: 3,
        NOTIFICATION_CONTROL_FLAGS: entry.controlConfig?.flags
      });
      expect(NotificationSysEventReporter.NOTIFICATION_UE).assertEqual('NOTIFICATION_UE');
    });
  })
}
