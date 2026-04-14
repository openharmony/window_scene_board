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
import { CustomPromise } from '@ohos/frameworkwrapper';
import { DomainName, LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationEvent } from '../../../main/ets/event/NotificationEvent';
import { NotificationBase } from '../../../main/ets/model/NotificationBase';
import { InnerEventUtil } from '../../../main/ets/utils/InnerEventUtil';
import { Singleton } from '../../../main/ets/utils/Singleton';
import { notificationSubscribe } from '@kit.NotificationKit';
import { crossModuleCallUtil } from '../../../main/ets/utils/CrossModuleCallUtil';
import { TraceUtil } from '@ohos/basicutils';
import {
  DeleteNotificationErrorCode,
  DeleteNotificationMaintenance } from '../../../main/ets/maintenance/DeleteNotificationMaintenance';
import { LiveNotification } from '../../../main/ets/live/model/LiveNotification';
import { WantAgent } from '@ohos.app.ability.wantAgent';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationDataManager } from '../../../main/ets/manager/NotificationDataManager';
export default function NotificationDataManagerTest() {
  describe('saveNtf_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_false_when_ntfMap_does_not_have_ntf_hashCode', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_ntfMap_has_ntf_hashCode', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      notificationdatamanager.ntfMap.set(ntf.hashCode, ntf);
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_tryCancelOldWantAgent_and_releaseImages_when_isUpdate_is_true', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockTryCancelOldWantAgent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      when(mockTryCancelOldWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let mockReleaseImages: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      when(mockReleaseImages)(ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      notificationdatamanager.ntfMap.set(ntf.hashCode, ntf);
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
    });

    it('should_not_call_tryCancelOldWantAgent_and_releaseImages_when_isUpdate_is_false', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockTryCancelOldWantAgent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      when(mockTryCancelOldWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let mockReleaseImages: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      when(mockReleaseImages)(ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
    });

    it('should_log_info_when_isUpdate_is_true', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      notificationdatamanager.ntfMap.set(ntf.hashCode, ntf);
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_when_isUpdate_is_false', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_ntfMap_does_not_have_ntf_hashCode', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_ntfMap_has_ntf_hashCode', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      notificationdatamanager.ntfMap.set(ntf.hashCode, ntf);
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_tryCancelOldWantAgent_and_releaseImages_when_isUpdate_is_true', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockTryCancelOldWantAgent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      when(mockTryCancelOldWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let mockReleaseImages: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      when(mockReleaseImages)(ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      notificationdatamanager.ntfMap.set(ntf.hashCode, ntf);
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
    });

    it('should_not_call_tryCancelOldWantAgent_and_releaseImages_when_isUpdate_is_false', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockTryCancelOldWantAgent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      when(mockTryCancelOldWantAgent)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let mockReleaseImages: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      when(mockReleaseImages)(ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.tryCancelOldWantAgent);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
    });

    it('should_log_info_when_isUpdate_is_true', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      notificationdatamanager.ntfMap.set(ntf.hashCode, ntf);
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(true);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_info_when_isUpdate_is_false', 0, () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntf: NotificationBase = new NotificationBase();
      const result = notificationdatamanager.saveNtf(ntf);
      expect(result).assertEqual(false);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_log_warn_when_ntf_not_found_in_ntfMap', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowWarn: Function = mocker.mockFunc(logHelper, logHelper.showWarn);
      when(mockShowWarn)(ArgumentMatchers.anyString).afterReturnNothing();

      let oldNtfList: NotificationBase[] = [new NotificationBase()];
      await notificationdatamanager.updateExistNtf(oldNtfList, false);

      mocker.ignoreMock(logHelper, logHelper.showWarn);
    });

    it('should_update_ntf_and_post_event_when_ntf_found_in_ntfMap', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockPostNtfEvent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.postNtfEvent);
      let mockEnableHeadsUp: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.enableHeadsUp);
      let mockClone: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.clone);

      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockPostNtfEvent)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(new CustomPromise());
      when(mockEnableHeadsUp)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(mockClone)().afterReturn(new NotificationBase());

      let oldNtfList: NotificationBase[] = [new NotificationBase()];
      await notificationdatamanager.updateExistNtf(oldNtfList, false);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.postNtfEvent);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.enableHeadsUp);
      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.clone);
    });

    it('should_remove_ntfs_when_isInMap_is_true_and_ntfMap_has_ntf_hashCode', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();

      let mockReleaseImages: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      when(mockReleaseImages)(ArgumentMatchers.any).afterReturnNothing();

      let mockHas: Function = mocker.mockFunc(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.has);
      when(mockHas)(ArgumentMatchers.any).afterReturn(true);

      let mockDelete: Function = mocker.mockFunc(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.delete);
      when(mockDelete)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockPostNtfEvent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.postNtfEvent);
      when(mockPostNtfEvent)(ArgumentMatchers.anyNumber, ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturn(new CustomPromise<void>(() => {}));

      let mockCheckFreeze: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.checkFreeze);
      when(mockCheckFreeze)().afterReturn(new CustomPromise<void>(() => {}));

      let ntfList: NotificationBase[] = [new NotificationBase(), new NotificationBase()];

      await notificationdatamanager.removeLocalNtf(ntfList, true);

      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      mocker.ignoreMock(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.has);
      mocker.ignoreMock(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.delete);
      mocker.ignoreMock(LogHelper.prototype, LogHelper.prototype.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.postNtfEvent);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.checkFreeze);
    });

    it('should_remove_ntfs_when_isInMap_is_false_and_ntfMap_has_ntf_hashCode', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();

      let mockReleaseImages: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      when(mockReleaseImages)(ArgumentMatchers.any).afterReturnNothing();

      let mockHas: Function = mocker.mockFunc(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.has);
      when(mockHas)(ArgumentMatchers.any).afterReturn(true);

      let mockDelete: Function = mocker.mockFunc(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.delete);
      when(mockDelete)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockPostNtfEvent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.postNtfEvent);
      when(mockPostNtfEvent)(ArgumentMatchers.anyNumber, ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturn(new CustomPromise<void>(() => {}));

      let mockCheckFreeze: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.checkFreeze);
      when(mockCheckFreeze)().afterReturn(new CustomPromise<void>(() => {}));

      let ntfList: NotificationBase[] = [new NotificationBase(), new NotificationBase()];

      await notificationdatamanager.removeLocalNtf(ntfList, false);

      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      mocker.ignoreMock(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.has);
      mocker.ignoreMock(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.delete);
      mocker.ignoreMock(LogHelper.prototype, LogHelper.prototype.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.postNtfEvent);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.checkFreeze);
    });

    it('should_remove_ntfs_when_isInMap_is_true_and_ntfMap_does_not_have_ntf_hashCode', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();

      let mockReleaseImages: Function = mocker.mockFunc(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      when(mockReleaseImages)(ArgumentMatchers.any).afterReturnNothing();

      let mockHas: Function = mocker.mockFunc(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.has);
      when(mockHas)(ArgumentMatchers.any).afterReturn(false);

      let mockDelete: Function = mocker.mockFunc(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.delete);
      when(mockDelete)(ArgumentMatchers.any).afterReturnNothing();

      let mockShowInfo: Function = mocker.mockFunc(LogHelper.prototype, LogHelper.prototype.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let mockPostNtfEvent: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.postNtfEvent);
      when(mockPostNtfEvent)(ArgumentMatchers.anyNumber, ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturn(new CustomPromise<void>(() => {}));

      let mockCheckFreeze: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.checkFreeze);
      when(mockCheckFreeze)().afterReturn(new CustomPromise<void>(() => {}));

      let ntfList: NotificationBase[] = [new NotificationBase(), new NotificationBase()];

      await notificationdatamanager.removeLocalNtf(ntfList, true);

      mocker.ignoreMock(NotificationBase.prototype, NotificationBase.prototype.releaseImages);
      mocker.ignoreMock(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.has);
      mocker.ignoreMock(notificationdatamanager.ntfMap, notificationdatamanager.ntfMap.delete);
      mocker.ignoreMock(LogHelper.prototype, LogHelper.prototype.showInfo);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.postNtfEvent);
      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.checkFreeze);
    });

    it('should_log_info_when_ntf_is_not_in_map', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let hashCodes: string[] = ['123', '456'];
      await notificationdatamanager.removeLocalNtfByHashCode(hashCodes);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_removeLocalNtf_when_ntfList_is_not_empty', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationdatamanager, notificationdatamanager.removeLocalNtf);
      when(mockfunc)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(new CustomPromise());

      let hashCodes: string[] = ['123'];
      await notificationdatamanager.removeLocalNtfByHashCode(hashCodes);

      mocker.ignoreMock(notificationdatamanager, notificationdatamanager.removeLocalNtf);
    });

    it('should_do_nothing_when_ntfList_is_empty', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let hashCodes: string[] = ['123'];
      await notificationdatamanager.removeLocalNtfByHashCode(hashCodes);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_log_info_and_call_removeAnsNtf_and_removeLocalNtf_when_removeByClick_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationDataManager: NotificationDataManager = new NotificationDataManager();
      let mockRemoveAnsNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeAnsNtf);
      when(mockRemoveAnsNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let mockRemoveLocalNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeLocalNtf);
      when(mockRemoveLocalNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(new CustomPromise<void>(() => {}));

      let ntfList: NotificationBase[] = [new NotificationBase(), new NotificationBase()];
      await notificationDataManager.removeByClick(ntfList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeAnsNtf);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeLocalNtf);
    });

    it('should_handle_error_when_removeAnsNtf_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationDataManager: NotificationDataManager = new NotificationDataManager();
      let mockRemoveAnsNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeAnsNtf);
      let errorMsg = "Error occurred while removingAnsNtf";
      when(mockRemoveAnsNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.any).afterThrow(errorMsg);

      let mockRemoveLocalNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeLocalNtf);
      when(mockRemoveLocalNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterReturn(new CustomPromise<void>(() => {}));

      let ntfList: NotificationBase[] = [new NotificationBase(), new NotificationBase()];
      await notificationDataManager.removeByClick(ntfList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeAnsNtf);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeLocalNtf);
    });

    it('should_handle_error_when_removeLocalNtf_fails', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationDataManager: NotificationDataManager = new NotificationDataManager();
      let mockRemoveAnsNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeAnsNtf);
      when(mockRemoveAnsNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.any).afterReturn(new CustomPromise<void>(() => {}));

      let mockRemoveLocalNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeLocalNtf);
      let errorMsg = "Error occurred while removingLocalNtf";
      when(mockRemoveLocalNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterThrow(errorMsg);

      let ntfList: NotificationBase[] = [new NotificationBase(), new NotificationBase()];
      await notificationDataManager.removeByClick(ntfList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeAnsNtf);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeLocalNtf);
    });

    it('should_log_error_when_removeAnsNtf_and_removeLocalNtf_fail', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let notificationDataManager: NotificationDataManager = new NotificationDataManager();
      let mockRemoveAnsNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeAnsNtf);
      let errorMsg1 = "Error occurred while removingAnsNtf";
      when(mockRemoveAnsNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.any).afterThrow(errorMsg1);

      let mockRemoveLocalNtf: Function = mocker.mockFunc(notificationDataManager, notificationDataManager.removeLocalNtf);
      let errorMsg2 = "Error occurred while removingLocalNtf";
      when(mockRemoveLocalNtf)(ArgumentMatchers.anyObj, ArgumentMatchers.anyBoolean).afterThrow(errorMsg2);

      let ntfList: NotificationBase[] = [new NotificationBase(), new NotificationBase()];
      await notificationDataManager.removeByClick(ntfList);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeAnsNtf);
      mocker.ignoreMock(notificationDataManager, notificationDataManager.removeLocalNtf);
    });
    it('should_resolve_immediately_when_freezePromise_is_null', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      notificationdatamanager.freezePromise = null;
      await notificationdatamanager.checkFreeze();
    });
    it('should_resolve_immediately_when_freezePromise_is_undefined', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      notificationdatamanager.freezePromise = undefined;
      await notificationdatamanager.checkFreeze();
    });
    it('should_resolve_immediately_when_freezePromise_is_ unresolved', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let customPromise: CustomPromise<void> = new CustomPromise<void>();
      notificationdatamanager.freezePromise = customPromise.getPromise();
      await notificationdatamanager.checkFreeze();
    });
    it('should_resolve_immediately_when_freezePromise_is_resolved', 0, async () => {
      let notificationdatamanager: NotificationDataManager = new NotificationDataManager();
      let customPromise: CustomPromise<void> = new CustomPromise<void>();
      customPromise.resolve();
      notificationdatamanager.freezePromise = customPromise.getPromise();
      await notificationdatamanager.checkFreeze();
    });
  });
}