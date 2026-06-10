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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AccessibilityVm, INotificationCardVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotificationGroup, NotificationBase, NotificationCategory } from '@ohos/systemuicommon/newTsIndex';
import { NotificationConfig } from '../../../main/ets/common/NotificationConfig';
import {
  ClickNotificationMaintenance
} from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { curves } from '@kit.ArkUI';
import { AppProtectedStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedStatusVm';
import { ClickNotificationErrorCode } from '@ohos/systemuicommon';
import { sSettingsUtil } from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import { NotificationConstants } from '../../../main/ets/common/NotificationConstants';
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
import { NotificationCardVm } from '../../../main/ets/viewmodel/NotificationCardVm';

export default function NotificationCardVmTest() {
  describe('deleteChainAnimation_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_translateY_when_scale_and_opacity_are_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let translateY: number = 10;
      notificationcardvm.deleteChainAnimation(translateY);
      expect(notificationcardvm.translateY).assertEqual(translateY);
    });

    it('should_update_translateY_and_scale_when_scale_is_defined_and_opacity_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let translateY: number = 10;
      let scale: number = 0.5;
      notificationcardvm.deleteChainAnimation(translateY, scale);
      expect(notificationcardvm.translateY).assertEqual(translateY);
      expect(notificationcardvm.scale).assertEqual(scale);
    });

    it('should_update_translateY_and_opacity_when_opacity_is_defined_and_scale_is_undefined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let translateY: number = 10;
      let opacity: number = 0.5;
      notificationcardvm.deleteChainAnimation(translateY, undefined, opacity);
      expect(notificationcardvm.translateY).assertEqual(translateY);
      expect(notificationcardvm.opacity).assertEqual(opacity);
    });

    it('should_update_translateY_scale_and_opacity_when_all_are_defined', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      let translateY: number = 10;
      let scale: number = 0.5;
      let opacity: number = 0.5;
      notificationcardvm.deleteChainAnimation(translateY, scale, opacity);
      expect(notificationcardvm.translateY).assertEqual(translateY);
      expect(notificationcardvm.scale).assertEqual(scale);
      expect(notificationcardvm.opacity).assertEqual(opacity);
    });

    it('should_set_containerClip_to_true_when_translateY_is_0', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.translateY = 0;
      notificationcardvm.height = 100;
      notificationcardvm.liveViewCardClip();
      expect(notificationcardvm.containerClip).assertEqual(true);
    });

    it('should_set_containerClip_to_correct_rect_when_translateY_is_greater_than_0', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.translateY = 10;
      notificationcardvm.height = 100;
      notificationcardvm.liveViewCardClip();
      expect(notificationcardvm.containerClip).assertDeepEquals({
        width: '100%',
        height: 90 - 10 + CLIP_HEIGHT,
        radius: NotificationConfig.BORDER_RADIUS,
      });
    });

    it('should_set_containerClip_to_correct_rect_when_translateY_is_less_than_0', 0, () => {
      let notificationcardvm: NotificationCardVm = new NotificationCardVm();
      notificationcardvm.translateY = -10;
      notificationcardvm.height = 100;
      notificationcardvm.liveViewCardClip();
      expect(notificationcardvm.containerClip).assertDeepEquals({
        width: '100%',
        height: 110 + 10 + CLIP_HEIGHT,
        radius: NotificationConfig.BORDER_RADIUS,
        y: -10 - CLIP_HEIGHT
      });
    });

  });
}
