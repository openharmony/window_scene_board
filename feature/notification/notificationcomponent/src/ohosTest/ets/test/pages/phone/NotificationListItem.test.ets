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

import { CommonData } from '@ohos/screenlockcommon';
import { NotificationEntry } from '../../../../main/ets/model/NotificationEntry';
import { NotificationGroupItem } from '../../../../main/ets/pages/phone/NotificationGroupItem';
import { NotificationSingleItem } from '../../../../main/ets/pages/phone/NotificationSingleItem';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { AppBubbleWrapper } from '@ohos/launchercommon';
import { NotificationConstants } from '../../../../main/ets/common/NotificationConstants';
import { NotificationAnimationParas } from '../../../../main/ets/common/NotificationAnimationParas';
import { NotificationUtils } from '../../../../main/ets/common/NotificationUtils';
import { NotificationType } from '../../../../main/ets/common/NotificationType';
import { notificationStyle } from '../../../../main/ets/vm/style/NotificationStyle';
import { NotificationMenuComponent } from '../../../../main/ets/pages/common/NotificationMenuComponent';
import { DarkModeState, FrameCount, immersiveKgMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { NotificationAggregateItem } from '../../../../main/ets/pages/phone/aggregate/NotificationAggregateItem';
import { NotificationItemStyle } from '../../../../main/ets/vm/style/NotificationItemStyle';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { NtfAnimVM } from '../../../../main/ets/vm/NtfAnimVM';
import {
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { OverlayAnimData } from '@ohos/systemuicommon/Index';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationListItem';
export default function Test() {
  describe('onNtfDataUpdate_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_execute_all_branches_when_newEntry_is_not_null_and_needBuildLockNtf_is_true', async () => {
      // Arrange
      let newEntry: NotificationEntry = new NotificationEntry({
        postData: {
          notificationType: NotificationType.NOTIFICATION_TYPE_LOCKSCREEN
        }
      });
      let ntfGroupItem: NotificationGroupItem = new NotificationGroupItem();
      let ntfSingleItem: NotificationSingleItem = new NotificationSingleItem();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logShowInfoMock: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(logShowInfoMock)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let bubbleWrapper: AppBubbleWrapper = new AppBubbleWrapper();
      let immersiveKgMgrMock: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getImmersiveKgMgr);
      when(immersiveKgMgrMock)().afterReturn(immersiveKgMgr);

      let notificationStyleMock: Function = mocker.mockFunc(notificationStyle, notificationStyle.getNotificationStyle);
      when(notificationStyleMock)().afterReturn(notificationStyle);

      let notificationMenuComponentMock: Function =
        mocker.mockFunc(NotificationMenuComponent, NotificationMenuComponent.showNotificationMenu);
      when(notificationMenuComponentMock)().afterReturnNothing();

      let notificationAggregateItemMock: Function =
        mocker.mockFunc(NotificationAggregateItem, NotificationAggregateItem.updateNotification);
      when(notificationAggregateItemMock)().afterReturnNothing();

      let notificationItemStyleMock: Function =
        mocker.mockFunc(NotificationItemStyle, NotificationItemStyle.updateNotification);
      when(notificationItemStyleMock)().afterReturnNothing();

      let ntfAnimMock: Function = mocker.mockFunc(ntfAnimVM, ntfAnimVM.stop);
      when(ntfAnimMock)().afterReturnNothing();

      let ntfColorModeMock: Function = mocker.mockFunc(ntfColorModeVM, ntfColorModeVM.setColorMode);
      when(ntfColorModeMock)().afterReturnNothing();

      let appProtectedMock: Function = mocker.mockFunc(appProtectedVm, appProtectedVm.updateAppprotectedState);
      when(appProtectedMock)().afterReturnNothing();

      let bubbleMock: Function = mocker.mockFunc(bubbleWrapper, bubbleWrapper.show);
      when(bubbleMock)().afterReturnNothing();

      let mocker: MockKit = new MockKit();
      let commonDataMock: Function = mocker.mockFunc(CommonData, CommonData.pushData);
      when(commonDataMock)().afterReturnNothing();

      // Act
      await ntfGroupItem.onNtfDataUpdate(newEntry);

      // Assert
      expect(ntfGroupItem.ntfGroupEntry).assertEqual(newEntry);
      expect(ntfGroupItem.newSingleNft).assertEqual(ntfSingleItem);
      expect(ntfGroupItem.refreshNtfCount).assertCalled();
      expect(ntfGroupItem.refreshGroupItem).assertCalled();
      expect(logShowInfoMock).assertCalled();
      expect(ntfAnimMock).assertCalled();
      expect(ntfColorModeMock).assertCalled();
      expect(appProtectedMock).assertCalled();
      expect(bubbleMock).assertCalled();

      mocker.ignoreMock(CommonData, CommonData.pushData);
    });

    it('should_execute_all_branches_when_newEntry_is_not_null_and_needBuildLockNtf_is_false', async () => {
      // Arrange
      let newEntry: NotificationEntry = new NotificationEntry({
        postData: {
          notificationType: NotificationType.NOTIFICATION_TYPE_LOCKSCREEN
        }
      });
      let ntfGroupItem: NotificationGroupItem = new NotificationGroupItem();
      let ntfSingleItem: NotificationSingleItem = new NotificationSingleItem();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logShowInfoMock: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(logShowInfoMock)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let appProtectedVm: AppProtectedVm = new AppBubbleWrapper();
      let bubbleWrapper: AppBubbleWrapper = new AppBubbleWrapper();
      let immersiveKgMgrMock: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getImmersiveKgMgr);
      when(immersiveKgMgrMock)().afterReturn(immersiveKgMgr);

      let notificationStyleMock: Function = mocker.mockFunc(notificationStyle, notificationStyle.getNotificationStyle);
      when(notificationStyleMock)().afterReturn(notificationStyle);

      let notificationMenuComponentMock: Function =
        mocker.mockFunc(NotificationMenuComponent, NotificationMenuComponent.showNotificationMenu);
      when(notificationMenuComponentMock)().afterReturnNothing();

      let notificationAggregateItemMock: Function =
        mocker.mockFunc(NotificationAggregateItem, NotificationAggregateItem.updateNotification);
      when(notificationAggregateItemMock)().afterReturnNothing();

      let notificationItemStyleMock: Function =
        mocker.mockFunc(NotificationItemStyle, NotificationItemStyle.updateNotification);
      when(notificationItemStyleMock)().afterReturnNothing();

      let ntfAnimMock: Function = mocker.mockFunc(ntfAnimVM, ntfAnimVM.stop);
      when(ntfAnimMock)().afterReturnNothing();

      let ntfColorModeMock: Function = mocker.mockFunc(ntfColorModeVM, ntfColorModeVM.setColorMode);
      when(ntfColorModeMock)().afterReturnNothing();

      let appProtectedMock: Function = mocker.mockFunc(appProtectedVm, appProtectedVm.updateAppprotectedState);
      when(appProtectedMock)().afterReturnNothing();

      let bubbleMock: Function = mocker.mockFunc(bubbleWrapper, bubbleWrapper.show);
      when(bubbleMock)().afterReturnNothing();

      let mocker: MockKit = new MockKit();
      let commonDataMock: Function = mocker.mockFunc(CommonData, CommonData.pushData);
      when(commonDataMock)().afterReturnNothing();

      // Act
      await ntfGroupItem.onNtfDataUpdate(newEntry);

      // Assert
      expect(ntfGroupItem.ntfGroupEntry).assertEqual(newEntry);
      expect(ntfGroupItem.newSingleNft).assertEqual(null);
      expect(ntfGroupItem.refreshNtfCount).assertCalled();
      expect(ntfGroupItem.refreshGroupItem).assertCalled();
      expect(logShowInfoMock).assertCalled();
      expect(ntfAnimMock).assertCalled();
      expect(ntfColorModeMock).assertCalled();
      expect(appProtectedMock).assertCalled();
      expect(bubbleMock).assertCalled();

      mocker.ignoreMock(CommonData, CommonData.pushData);
    });

    it('should_execute_all_branches_when_newEntry_is_not_null_and_needBuildLockNtf_is_true', async () => {
      // Arrange
      let newEntry: NotificationEntry = new NotificationEntry({
        postData: {
          notificationType: NotificationType.NOTIFICATION_TYPE_LOCKSCREEN
        }
      });
      let ntfGroupItem: NotificationGroupItem = new NotificationGroupItem();
      let ntfSingleItem: NotificationSingleItem = new NotificationSingleItem();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logShowInfoMock: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(logShowInfoMock)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let bubbleWrapper: AppBubbleWrapper = new AppBubbleWrapper();
      let immersiveKgMgrMock: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getImmersiveKgMgr);
      when(immersiveKgMgrMock)().afterReturn(immersiveKgMgr);

      let notificationStyleMock: Function = mocker.mockFunc(notificationStyle, notificationStyle.getNotificationStyle);
      when(notificationStyleMock)().afterReturn(notificationStyle);

      let notificationMenuComponentMock: Function = mocker.mockFunc(NotificationMenuComponent, NotificationMenuComponent.showNotificationMenu);
      when(notificationMenuComponentMock)().afterReturnNothing();

      let notificationAggregateItemMock: Function = mocker.mockFunc(NotificationAggregateItem, NotificationAggregateItem.updateNotification);
      when(notificationAggregateItemMock)().afterReturnNothing();

      let notificationItemStyleMock: Function = mocker.mockFunc(NotificationItemStyle, NotificationItemStyle.updateNotification);
      when(notificationItemStyleMock)().afterReturnNothing();

      let ntfAnimMock: Function = mocker.mockFunc(ntfAnimVM, ntfAnimVM.stop);
      when(ntfAnimMock)().afterReturnNothing();

      let ntfColorModeMock: Function = mocker.mockFunc(ntfColorModeVM, ntfColorModeVM.setColorMode);
      when(ntfColorModeMock)().afterReturnNothing();

      let appProtectedMock: Function = mocker.mockFunc(appProtectedVm, appProtectedVm.updateAppprotectedState);
      when(appProtectedMock)().afterReturnNothing();

      let bubbleMock: Function = mocker.mockFunc(bubbleWrapper, bubbleWrapper.show);
      when(bubbleMock)().afterReturnNothing();

      let mocker: MockKit = new MockKit();
      let commonDataMock: Function = mocker.mockFunc(CommonData, CommonData.pushData);
      when(commonDataMock)().afterReturnNothing();

      // Act
      await ntfGroupItem.onNtfDataUpdate(newEntry);

      // Assert
      expect(ntfGroupItem.ntfGroupEntry).assertEqual(newEntry);
      expect(ntfGroupItem.newSingleNft).assertEqual(ntfSingleItem);
      expect(ntfGroupItem.refreshNtfCount).assertCalled();
      expect(ntfGroupItem.refreshGroupItem).assertCalled();
      expect(logShowInfoMock).assertCalled();
      expect(ntfAnimMock).assertCalled();
      expect(ntfColorModeMock).assertCalled();
      expect(appProtectedMock).assertCalled();
      expect(bubbleMock).assertCalled();

      mocker.ignoreMock(CommonData, CommonData.pushData);
    });

    it('should_execute_all_branches_when_newEntry_is_not_null_and_needBuildLockNtf_is_false', async () => {
      // Arrange
      let newEntry: NotificationEntry = new NotificationEntry({
        postData: {
          notificationType: NotificationType.NOTIFICATION_TYPE_LOCKSCREEN
        }
      });
      let ntfGroupItem: NotificationGroupItem = new NotificationGroupItem();
      let ntfSingleItem: NotificationSingleItem = new NotificationSingleItem();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logShowInfoMock: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(logShowInfoMock)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let appProtectedVm: AppProtectedVm = new AppBubbleWrapper();
      let bubbleWrapper: AppBubbleWrapper = new AppBubbleWrapper();
      let immersiveKgMgrMock: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getImmersiveKgMgr);
      when(immersiveKgMgrMock)().afterReturn(immersiveKgMgr);

      let notificationStyleMock: Function = mocker.mockFunc(notificationStyle, notificationStyle.getNotificationStyle);
      when(notificationStyleMock)().afterReturn(notificationStyle);

      let notificationMenuComponentMock: Function = mocker.mockFunc(NotificationMenuComponent, NotificationMenuComponent.showNotificationMenu);
      when(notificationMenuComponentMock)().afterReturnNothing();

      let notificationAggregateItemMock: Function = mocker.mockFunc(NotificationAggregateItem, NotificationAggregateItem.updateNotification);
      when(notificationAggregateItemMock)().afterReturnNothing();

      let notificationItemStyleMock: Function = mocker.mockFunc(NotificationItemStyle, NotificationItemStyle.updateNotification);
      when(notificationItemStyleMock)().afterReturnNothing();

      let ntfAnimMock: Function = mocker.mockFunc(ntfAnimVM, ntfAnimVM.stop);
      when(ntfAnimMock)().afterReturnNothing();

      let ntfColorModeMock: Function = mocker.mockFunc(ntfColorModeVM, ntfColorModeVM.setColorMode);
      when(ntfColorModeMock)().afterReturnNothing();

      let appProtectedMock: Function = mocker.mockFunc(appProtectedVm, appProtectedVm.updateAppprotectedState);
      when(appProtectedMock)().afterReturnNothing();

      let bubbleMock: Function = mocker.mockFunc(bubbleWrapper, bubbleWrapper.show);
      when(bubbleMock)().afterReturnNothing();

      let mocker: MockKit = new MockKit();
      let commonDataMock: Function = mocker.mockFunc(CommonData, CommonData.pushData);
      when(commonDataMock)().afterReturnNothing();

      // Act
      await ntfGroupItem.onNtfDataUpdate(newEntry);

      // Assert
      expect(ntfGroupItem.ntfGroupEntry).assertEqual(newEntry);
      expect(ntfGroupItem.newSingleNft).assertEqual(null);
      expect(ntfGroupItem.refreshNtfCount).assertCalled();
      expect(ntfGroupItem.refreshGroupItem).assertCalled();
      expect(logShowInfoMock).assertCalled();
      expect(ntfAnimMock).assertCalled();
      expect(ntfColorModeMock).assertCalled();
      expect(appProtectedMock).assertCalled();
      expect(bubbleMock).assertCalled();

      mocker.ignoreMock(CommonData, CommonData.pushData);
    });

    it('should_execute_all_branches_when_newEntry_is_not_null_and_needBuildLockNtf_is_true', async () => {
      // Arrange
      let newEntry: NotificationEntry = new NotificationEntry({
        postData: {
          notificationType: NotificationType.NOTIFICATION_TYPE_LOCKSCREEN
        }
      });
      let ntfGroupItem: NotificationGroupItem = new NotificationGroupItem();
      let ntfSingleItem: NotificationSingleItem = new NotificationSingleItem();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logShowInfoMock: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(logShowInfoMock)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let bubbleWrapper: AppBubbleWrapper = new AppBubbleWrapper();
      let immersiveKgMgrMock: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getImmersiveKgMgr);
      when(immersiveKgMgrMock)().afterReturn(immersiveKgMgr);

      let notificationStyleMock: Function = mocker.mockFunc(notificationStyle, notificationStyle.getNotificationStyle);
      when(notificationStyleMock)().afterReturn(notificationStyle);

      let notificationMenuComponentMock: Function = mocker.mockFunc(NotificationMenuComponent, NotificationMenuComponent.showNotificationMenu);
      when(notificationMenuComponentMock)().afterReturnNothing();

      let notificationAggregateItemMock: Function = mocker.mockFunc(NotificationAggregateItem, NotificationAggregateItem.updateNotification);
      when(notificationAggregateItemMock)().afterReturnNothing();

      let notificationItemStyleMock: Function = mocker.mockFunc(NotificationItemStyle, NotificationItemStyle.updateNotification);
      when(notificationItemStyleMock)().afterReturnNothing();

      let ntfAnimMock: Function = mocker.mockFunc(ntfAnimVM, ntfAnimVM.stop);
      when(ntfAnimMock)().afterReturnNothing();

      let ntfColorModeMock: Function = mocker.mockFunc(ntfColorModeVM, ntfColorModeVM.setColorMode);
      when(ntfColorModeMock)().afterReturnNothing();

      let appProtectedMock: Function = mocker.mockFunc(appProtectedVm, appProtectedVm.updateAppprotectedState);
      when(appProtectedMock)().afterReturnNothing();

      let bubbleMock: Function = mocker.mockFunc(bubbleWrapper, bubbleWrapper.show);
      when(bubbleMock)().afterReturnNothing();

      let mocker: MockKit = new MockKit();
      let commonDataMock: Function = mocker.mockFunc(CommonData, CommonData.pushData);
      when(commonDataMock)().afterReturnNothing();

      // Act
      await ntfGroupItem.onNtfDataUpdate(newEntry);

      // Assert
      expect(ntfGroupItem.ntfGroupEntry).assertEqual(newEntry);
      expect(ntfGroupItem.newSingleNft).assertEqual(ntfSingleItem);
      expect(ntfGroupItem.refreshNtfCount).assertCalled();
      expect(ntfGroupItem.refreshGroupItem).assertCalled();
      expect(logShowInfoMock).assertCalled();
      expect(ntfAnimMock).assertCalled();
      expect(ntfColorModeMock).assertCalled();
      expect(appProtectedMock).assertCalled();
      expect(bubbleMock).assertCalled();

      mocker.ignoreMock(CommonData, CommonData.pushData);
    });

    it('should_execute_all_branches_when_newEntry_is_not_null_and_needBuildLockNtf_is_false', async () => {
      // Arrange
      let newEntry: NotificationEntry = new NotificationEntry({
        postData: {
          notificationType: NotificationType.NOTIFICATION_TYPE_LOCKSCREEN
        }
      });
      let ntfGroupItem: NotificationGroupItem = new NotificationGroupItem();
      let ntfSingleItem: NotificationSingleItem = new NotificationSingleItem();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logShowInfoMock: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(logShowInfoMock)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let appProtectedVm: AppProtectedVm = new AppBubbleWrapper();
      let bubbleWrapper: AppBubbleWrapper = new AppBubbleWrapper();
      let immersiveKgMgrMock: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getImmersiveKgMgr);
      when(immersiveKgMgrMock)().afterReturn(immersiveKgMgr);

      let notificationStyleMock: Function = mocker.mockFunc(notificationStyle, notificationStyle.getNotificationStyle);
      when(notificationStyleMock)().afterReturn(notificationStyle);

      let notificationMenuComponentMock: Function = mocker.mockFunc(NotificationMenuComponent, NotificationMenuComponent.showNotificationMenu);
      when(notificationMenuComponentMock)().afterReturnNothing();

      let notificationAggregateItemMock: Function = mocker.mockFunc(NotificationAggregateItem, NotificationAggregateItem.updateNotification);
      when(notificationAggregateItemMock)().afterReturnNothing();

      let notificationItemStyleMock: Function = mocker.mockFunc(NotificationItemStyle, NotificationItemStyle.updateNotification);
      when(notificationItemStyleMock)().afterReturnNothing();

      let ntfAnimMock: Function = mocker.mockFunc(ntfAnimVM, ntfAnimVM.stop);
      when(ntfAnimMock)().afterReturnNothing();

      let ntfColorModeMock: Function = mocker.mockFunc(ntfColorModeVM, ntfColorModeVM.setColorMode);
      when(ntfColorModeMock)().afterReturnNothing();

      let appProtectedMock: Function = mocker.mockFunc(appProtectedVm, appProtectedVm.updateAppprotectedState);
      when(appProtectedMock)().afterReturnNothing();

      let bubbleMock: Function = mocker.mockFunc(bubbleWrapper, bubbleWrapper.show);
      when(bubbleMock)().afterReturnNothing();

      let mocker: MockKit = new MockKit();
      let commonDataMock: Function = mocker.mockFunc(CommonData, CommonData.pushData);
      when(commonDataMock)().afterReturnNothing();

      // Act
      await ntfGroupItem.onNtfDataUpdate(newEntry);

      // Assert
      expect(ntfGroupItem.ntfGroupEntry).assertEqual(newEntry);
      expect(ntfGroupItem.newSingleNft).assertEqual(null);
      expect(ntfGroupItem.refreshNtfCount).assertCalled();
      expect(ntfGroupItem.refreshGroupItem).assertCalled();
      expect(logShowInfoMock).assertCalled();
      expect(ntfAnimMock).assertCalled();
      expect(ntfColorModeMock).assertCalled();
      expect(appProtectedMock).assertCalled();
      expect(bubbleMock).assertCalled();

      mocker.ignoreMock(CommonData, CommonData.pushData);
    });
    it('should_execute_all_branches_when_newEntry_is_not_null_and_needBuildLockNtf_is_true', async () => {
      // Arrange
      let ntfGroupItem: NotificationGroupItem = new NotificationGroupItem();
      let ntfSingleItem: NotificationSingleItem = new NotificationSingleItem();
      let commonUtils: CommonUtils = new CommonUtils();
      let logHelper: LogHelper = LogHelper.getInstance();
      let logShowInfoMock: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(logShowInfoMock)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let ntfAnimVM: NtfAnimVM = new NtfAnimVM();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let appProtectedVm: AppProtectedVm = new AppProtectedVm();
      let bubbleWrapper: AppBubbleWrapper = new AppBubbleWrapper();
      let immersiveKgMgrMock: Function = mocker.mockFunc(immersiveKgMgr, immersiveKgMgr.getImmersiveKgMgr);
      when(immersiveKgMgrMock)().afterReturn(immersiveKgMgr);

      let notificationStyleMock: Function = mocker.mockFunc(notificationStyle, notificationStyle.getNotificationStyle);
      when(notificationStyleMock)().afterReturn(notificationStyle);

      let notificationMenuComponentMock: Function = mocker.mockFunc(NotificationMenuComponent, NotificationMenuComponent.showNotificationMenu);
      when(notificationMenuComponentMock)().afterReturnNothing();

      let notificationAggregateItemMock: Function = mocker.mockFunc(NotificationAggregateItem, NotificationAggregateItem.updateNotification);
      when(notificationAggregateItemMock)().afterReturnNothing();

      let notificationItemStyleMock: Function = mocker.mockFunc(NotificationItemStyle, NotificationItemStyle.updateNotification);
      when(notificationItemStyleMock)().afterReturnNothing();

      let ntfAnimMock: Function = mocker.mockFunc(ntfAnimVM, ntfAnimVM.stop);
      when(ntfAnimMock)().afterReturnNothing();

      let ntfColorModeMock: Function = mocker.mockFunc(ntfColorModeVM, ntfColorModeVM.setColorMode);
      when(ntfColorModeMock)().afterReturnNothing();

      let appProtectedMock: Function = mocker.mockFunc(appProtectedVm, appProtectedVm.updateAppprotectedState);
      when(appProtectedMock)().afterReturnNothing();

      let bubbleMock: Function = mocker.mockFunc(bubbleWrapper, bubbleWrapper.show);
      when(bubbleMock)().afterReturnNothing();

      let mocker: MockKit = new MockKit();
      let commonDataMock: Function = mocker.mockFunc(CommonData, CommonData.pushData);
      when(commonDataMock)().afterReturnNothing();

      await ntfGroupItem.onNtfDataUpdate(newEntry);
      expect(ntfGroupItem.ntfGroupEntry).assertEqual(newEntry);
      expect(ntfGroupItem.newSingleNft).assertEqual(ntfSingleItem);
      expect(ntfGroupItem.refreshNtfCount).assertCalled();
      expect(ntfGroupItem.refreshGroupItem).assertCalled();
      expect(logShowInfoMock).assertCalled();
      expect(ntfAnimMock).assertCalled();
      expect(ntfColorModeMock).assertCalled();
      expect(appProtectedMock).assertCalled();
      expect(bubbleMock).assertCalled();
      mocker.ignoreMock(CommonData, CommonData.pushData);
    });
  })
}