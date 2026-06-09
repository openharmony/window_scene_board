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
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import {
  CommonUtils,
  LogDomain,
  LogHelper,
  Trace,
  ArrayUtils
} from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { baseStateMgr,
  CardScaleType,
  CardScaleUtil,
  FrameCount, ImmersiveBaseState, StateType, SystemUICommonUtil } from '@ohos/systemuicommon';
import { LiveUseScene, BannerDeformState, LiveViewData } from '@ohos/systemuicommon';
import { NtfAppIconModifier } from '../../../../main/ets/vm/style/NtfAppIconModifier';
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { BannerFloatingController } from '../../../../main/ets/controller/BannerFloatingController';
import { RootCard } from '@ohos/systemuicommon/Index';
import { NotificationContentInTint } from '../../../../main/ets/pages/phone/NotificationContentInTint';
import { NotificationContent } from '../../../../main/ets/pages/phone/NotificationContent';
import { NtfTimeVM } from '../../../../main/ets/vm/NtfTimeVM';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { NtfSingleItemVM } from '../../../../main/ets/vm/NtfSingleItemVM';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationHeadsUp';
export default function Test() {
  describe('aboutToDisappear_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_unregister_data_update_listener_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfEntry.aboutToDisappear();

    });

    it('should_cancel_item_hover_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_item_translate_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_focusable_to_false_when_persistentId_is_not_zero', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.persistentId = 1;
      let mocker: MockKit = new MockKit();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new SCBSystemSceneSession());

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
    });

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_unregister_data_update_listener_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfEntry.aboutToDisappear();

    });

    it('should_cancel_item_hover_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_item_translate_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_focusable_to_false_when_persistentId_is_not_zero', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.persistentId = 1;
      let mocker: MockKit = new MockKit();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new SCBSystemSceneSession());

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
    });
    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_unregister_data_update_listener_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfEntry.aboutToDisappear();

    });

    it('should_cancel_item_hover_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_item_translate_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_focusable_to_false_when_persistentId_is_not_zero', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.persistentId = 1;
      let mocker: MockKit = new MockKit();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new SCBSystemSceneSession());

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
    });
    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_unregister_data_update_listener_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfEntry.aboutToDisappear();

    });

    it('should_cancel_item_hover_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_item_translate_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_focusable_to_false_when_persistentId_is_not_zero', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.persistentId = 1;
      let mocker: MockKit = new MockKit();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new SCBSystemSceneSession());

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
    });
    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_unregister_data_update_listener_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfEntry.aboutToDisappear();

    });

    it('should_cancel_item_hover_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_item_translate_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_focusable_to_false_when_persistentId_is_not_zero', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.persistentId = 1;
      let mocker: MockKit = new MockKit();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new SCBSystemSceneSession());

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
    });
    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_log_info_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_unregister_data_update_listener_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfEntry.aboutToDisappear();

    });

    it('should_cancel_item_hover_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_item_translate_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_focusable_to_false_when_persistentId_is_not_zero', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.persistentId = 1;
      let mocker: MockKit = new MockKit();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new SCBSystemSceneSession());

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
    });
    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_log_info_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_unregister_data_update_listener_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();

      ntfEntry.aboutToDisappear();

    });

    it('should_cancel_item_hover_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_item_translate_when_aboutToDisappear_is_called', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      let mocker: MockKit = new MockKit();
      let closeVM: NtfCloseVM = new NtfCloseVM();
      ntfEntry.closeVM = closeVM;

      ntfEntry.aboutToDisappear();

    });

    it('should_set_focusable_to_false_when_persistentId_is_not_zero', 0, () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.persistentId = 1;
      let mocker: MockKit = new MockKit();
      let sceneSessionManager: SCBSceneSessionManager = SCBSceneSessionManager.getInstance();
      let mockfunc: Function = mocker.mockFunc(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(new SCBSystemSceneSession());

      ntfEntry.aboutToDisappear();

      mocker.ignoreMock(sceneSessionManager, sceneSessionManager.getSystemSceneSessionWithId);
    });
  });
}
