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
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NtfItemSwipeController } from '../../../../main/ets/controller/NtfItemSwipeController';
import { ntfSettingsDC as NtfSettingsDC } from '../../../../main/ets/controller/NtfSettingsDialogController';
import { LogDomain, LogHelper, CommonUtils, ArrayUtils, RectInfo } from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { HiDfxEventUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { ResUtils, SCBSystemSceneSession, SCBSceneSessionManager } from '@ohos/windowscene';
import { NotificationType } from '../../../../main/ets/common/NotificationType';
import {
  immersiveKgMgr,
  ImmersiveAodStyle,
  NotificationSysEventReporter,
  DefaultPanelZIndex
} from '@ohos/systemuicommon';
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { BlurButtonVM, blurButtonVM } from '../../../../main/ets/vm/BlurButtonVM';
import { ScreenLockBlurButtonVM, screenLockBlurButtonVM } from '../../../../main/ets/vm/ScreenLockBlurButtonVM';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { ntfViewConfigManager } from '../../../../main/ets/vm/config/NtfViewConfigManager';
import { LengthMetrics } from '@ohos.arkui.node';
import { DeleteNotificationMaintenance } from '@ohos/systemuicommon/src/main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../../../../main/ets/maintenance/NotificationExceptionCode';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/common/NotificationMenuRow';
export default function Test() {
  describe('onUpdateItemTranX_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_setMenuIconAlpha_0_when_menuWidth_is_invalid', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(0, false);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, false);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_0_when_isStart2End_is_false', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(100, false);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, false);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_0_when_posTranX_is_greater_than_menuWidth', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(200, false);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, false);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setCoverState_and_setBinTransAnim_when_swipeController_isItemCanClear_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationEntry, notificationEntry.setCoverState);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry, notificationEntry.setBinTransAnim);
      when(mockfunc1)().afterReturnNothing();
      when(mockfunc2)().afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(100, false);
      expect(notificationEntry.setCoverState).assertCalled();
      expect(notificationEntry.setBinTransAnim).assertCalled();
      mocker.ignoreMock(notificationEntry, notificationEntry.setCoverState);
      mocker.ignoreMock(notificationEntry, notificationEntry.setBinTransAnim);
    });

    it('should_setButtonDelTransX_and_setDelButtonScale_when_posTranX_is_less_than_binDelTransXThreshold', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationEntry, notificationEntry.setButtonDelTransX);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry, notificationEntry.setDelButtonScale);
      when(mockfunc1)().afterReturnNothing();
      when(mockfunc2)().afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(50, false);
      expect(notificationEntry.setButtonDelTransX).assertCalled();
      expect(notificationEntry.setDelButtonScale).assertCalled();
      mocker.ignoreMock(notificationEntry, notificationEntry.setButtonDelTransX);
      mocker.ignoreMock(notificationEntry, notificationEntry.setDelButtonScale);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_dropTransX_is_greater_than_binDelTransXThreshold_and_isRemoveEntry_is_true',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(200, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_0_when_dropTransX_is_0_and_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(0, true);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, true);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_delIconAlpha_is_0_and_isRemoveEntry_is_true_and_swipeController_isItemCanClear_is_false',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_settingIconAlpha_is_MAX_ALPHA_and_isRemoveEntry_is_false_and_delIconAlpha_is_0',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, false);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, false);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setButtonDelTransX_and_setDelButtonScale_when_posTranX_is_less_than_binDelTransXThreshold', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationEntry, notificationEntry.setButtonDelTransX);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry, notificationEntry.setDelButtonScale);
      when(mockfunc1)().afterReturnNothing();
      when(mockfunc2)().afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(50, false);
      expect(notificationEntry.setButtonDelTransX).assertCalled();
      expect(notificationEntry.setDelButtonScale).assertCalled();
      mocker.ignoreMock(notificationEntry, notificationEntry.setButtonDelTransX);
      mocker.ignoreMock(notificationEntry, notificationEntry.setDelButtonScale);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_dropTransX_is_greater_than_binDelTransXThreshold_and_isRemoveEntry_is_true',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(200, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_0_when_dropTransX_is_0_and_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(0, true);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, true);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_delIconAlpha_is_0_and_isRemoveEntry_is_true_and_swipeController_isItemCanClear_is_false',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_settingIconAlpha_is_MAX_ALPHA_and_isRemoveEntry_is_false_and_delIconAlpha_is_0',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, false);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, false);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setButtonDelTransX_and_setDelButtonScale_when_posTranX_is_less_than_binDelTransXThreshold', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationEntry, notificationEntry.setButtonDelTransX);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry, notificationEntry.setDelButtonScale);
      when(mockfunc1)().afterReturnNothing();
      when(mockfunc2)().afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(50, false);
      expect(notificationEntry.setButtonDelTransX).assertCalled();
      expect(notificationEntry.setDelButtonScale).assertCalled();
      mocker.ignoreMock(notificationEntry, notificationEntry.setButtonDelTransX);
      mocker.ignoreMock(notificationEntry, notificationEntry.setDelButtonScale);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_dropTransX_is_greater_than_binDelTransXThreshold_and_isRemoveEntry_is_true',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(200, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_0_when_dropTransX_is_0_and_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(0, true);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, true);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_delIconAlpha_is_0_and_isRemoveEntry_is_true_and_swipeController_isItemCanClear_is_false',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_settingIconAlpha_is_MAX_ALPHA_and_isRemoveEntry_is_false_and_delIconAlpha_is_0',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, false);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, false);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setButtonDelTransX_and_setDelButtonScale_when_posTranX_is_less_than_binDelTransXThreshold', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationEntry, notificationEntry.setButtonDelTransX);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry, notificationEntry.setDelButtonScale);
      when(mockfunc1)().afterReturnNothing();
      when(mockfunc2)().afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(50, false);
      expect(notificationEntry.setButtonDelTransX).assertCalled();
      expect(notificationEntry.setDelButtonScale).assertCalled();
      mocker.ignoreMock(notificationEntry, notificationEntry.setButtonDelTransX);
      mocker.ignoreMock(notificationEntry, notificationEntry.setDelButtonScale);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_dropTransX_is_greater_than_binDelTransXThreshold_and_isRemoveEntry_is_true',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(200, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_0_when_dropTransX_is_0_and_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(0, true);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, true);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_delIconAlpha_is_0_and_isRemoveEntry_is_true_and_swipeController_isItemCanClear_is_false',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_settingIconAlpha_is_MAX_ALPHA_and_isRemoveEntry_is_false_and_delIconAlpha_is_0',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, false);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, false);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setButtonDelTransX_and_setDelButtonScale_when_posTranX_is_less_than_binDelTransXThreshold', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationEntry, notificationEntry.setButtonDelTransX);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry, notificationEntry.setDelButtonScale);
      when(mockfunc1)().afterReturnNothing();
      when(mockfunc2)().afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(50, false);
      expect(notificationEntry.setButtonDelTransX).assertCalled();
      expect(notificationEntry.setDelButtonScale).assertCalled();
      mocker.ignoreMock(notificationEntry, notificationEntry.setButtonDelTransX);
      mocker.ignoreMock(notificationEntry, notificationEntry.setDelButtonScale);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_dropTransX_is_greater_than_binDelTransXThreshold_and_isRemoveEntry_is_true',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(200, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_0_when_dropTransX_is_0_and_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(0, true);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, true);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_delIconAlpha_is_0_and_isRemoveEntry_is_true_and_swipeController_isItemCanClear_is_false',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_settingIconAlpha_is_MAX_ALPHA_and_isRemoveEntry_is_false_and_delIconAlpha_is_0',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, false);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, false);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setButtonDelTransX_and_setDelButtonScale_when_posTranX_is_less_than_binDelTransXThreshold', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(notificationEntry, notificationEntry.setButtonDelTransX);
      let mockfunc2: Function = mocker.mockFunc(notificationEntry, notificationEntry.setDelButtonScale);
      when(mockfunc1)().afterReturnNothing();
      when(mockfunc2)().afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(50, false);
      expect(notificationEntry.setButtonDelTransX).assertCalled();
      expect(notificationEntry.setDelButtonScale).assertCalled();
      mocker.ignoreMock(notificationEntry, notificationEntry.setButtonDelTransX);
      mocker.ignoreMock(notificationEntry, notificationEntry.setDelButtonScale);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_dropTransX_is_greater_than_binDelTransXThreshold_and_isRemoveEntry_is_true',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(200, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_0_when_dropTransX_is_0_and_isRemoveEntry_is_true', 0, () => {
      let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
      let notificationEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
        .afterReturnNothing();
      ntfItemSwipeController.onUpdateItemTranX(0, true);
      expect(notificationEntry.setMenuIconAlpha).assertCalledWith(0, false, true);
      mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
    });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_delIconAlpha_is_0_and_isRemoveEntry_is_true_and_swipeController_isItemCanClear_is_false',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, true);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, true);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });

    it('should_setMenuIconAlpha_MAX_ALPHA_when_settingIconAlpha_is_MAX_ALPHA_and_isRemoveEntry_is_false_and_delIconAlpha_is_0',
      0, () => {
        let ntfItemSwipeController: NtfItemSwipeController = new NtfItemSwipeController();
        let notificationEntry: NotificationEntry = new NotificationEntry();
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(notificationEntry, notificationEntry.setMenuIconAlpha);
        when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean)
          .afterReturnNothing();
        ntfItemSwipeController.onUpdateItemTranX(0, false);
        expect(notificationEntry.setMenuIconAlpha).assertCalledWith(MAX_ALPHA, false, false);
        mocker.ignoreMock(notificationEntry, notificationEntry.setMenuIconAlpha);
      });
  });
}
