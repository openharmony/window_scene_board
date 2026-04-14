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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { INotificationCardVm, INotificationSwipeVm, NotificationItemBaseVm } from '@ohos/systemuicommon/newIndex';
import { NormalNotification, NotificationBase } from '@ohos/systemuicommon/newTsIndex';
import {
  INotificationPrivacyVm
} from '@ohos/systemuicommon/src/main/ets/notification/interface/INotificationPrivacyVm';
import { AppProtectedStatusVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedStatusVm';
import { hideBannerNtfContentObj } from '../../../main/ets/model/HideBannerNtfContentObj';
import { BannerShowStatusModel } from '@ohos/systemuicommon/src/main/ets/notification/model/BannerShowStatusModel';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NotificationPrivacyVm } from '../../../main/ets/viewmodel/NotificationPrivacyVm';
export default function NotificationPrivacyVmTest() {
  describe('latestNotification_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_first_child_when_ntf_is_normal_group', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let result = notificationprivacyvm.latestNotification;
      expect(result).assertInstanceOf(NormalNotification);
      mocker.ignoreMock(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
    });

    it('should_return_ntf_when_ntf_is_not_normal_group', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let result = notificationprivacyvm.latestNotification;
      expect(result).assertInstanceOf(NormalNotification);
      mocker.ignoreMock(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
    });

    it('should_return_first_child_when_ntf_is_normal_group', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let result = notificationprivacyvm.latestNotification;
      expect(result).assertInstanceOf(NormalNotification);
      mocker.ignoreMock(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
    });

    it('should_return_ntf_when_ntf_is_not_normal_group', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let result = notificationprivacyvm.latestNotification;
      expect(result).assertInstanceOf(NormalNotification);
      mocker.ignoreMock(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
    });

    it('should_return_first_child_when_ntf_is_normal_group', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let result = notificationprivacyvm.latestNotification;
      expect(result).assertInstanceOf(NormalNotification);
      mocker.ignoreMock(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
    });

    it('should_return_ntf_when_ntf_is_not_normal_group', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      let result = notificationprivacyvm.latestNotification;
      expect(result).assertInstanceOf(NormalNotification);
      mocker.ignoreMock(notificationprivacyvm.ntf, notificationprivacyvm.ntf.isNormalGroup);
    });
    it('should_log_info_when_offsetX_is_not_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 10, resetOffsetX: (x: boolean) => {} });
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = new LogDomain(0);
      when(logHelper)(ArgumentMatchers.any).afterReturn(logDomain);

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
    });

    it('should_call_getCardVm_onClick_when_offsetX_is_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      when(getCardVm)(ArgumentMatchers.any).afterReturn({ onClick: (x: NotificationBase) => {} });

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
    });

    it('should_reset_offsetX_to_zero_when_offsetX_is_not_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 10, resetOffsetX: (x: boolean) => {} });

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
    });

    it('should_set_protected_status_when_offsetX_is_zero_and_notification_is_protected', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
    });

    it('should_not_set_protected_status_when_offsetX_is_zero_and_notification_is_not_protected', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = false;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
    });

    it('should_hide_banner_when_offsetX_is_zero_and_notification_is_protected_and_banner_is_shown', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      let bannerShowStatusModel: BannerShowStatusModel = BannerShowStatusModel.instance;
      let mockBannerShowStatusModel: BannerShowStatusModel = mocker.mockFunc(bannerShowStatusModel, bannerShowStatusModel.hideBanner);
      when(mockBannerShowStatusModel)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      mocker.ignoreMock(bannerShowStatusModel, bannerShowStatusModel.hideBanner);
    });

    it('should_not_hide_banner_when_offsetX_is_zero_and_notification_is_protected_and_banner_is_not_shown', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined =
        mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0, resetOffsetX: (x: boolean) => {
        }
      });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is
      Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm =
        mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

    });

    it('should_log_info_when_offsetX_is_not_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 10, resetOffsetX: (x: boolean) => {} });
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = new LogDomain(0);
      when(logHelper)(ArgumentMatchers.any).afterReturn(logDomain);

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
    });

    it('should_call_getCardVm_onClick_when_offsetX_is_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      when(getCardVm)(ArgumentMatchers.any).afterReturn({ onClick: (x: NotificationBase) => {} });

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
    });

    it('should_reset_offsetX_to_zero_when_offsetX_is_not_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 10, resetOffsetX: (x: boolean) => {} });

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
    });

    it('should_set_protected_status_when_offsetX_is_zero_and_notification_is_protected', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
    });

    it('should_not_set_protected_status_when_offsetX_is_zero_and_notification_is_not_protected', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = false;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
    });

    it('should_hide_banner_when_offsetX_is_zero_and_notification_is_protected_and_banner_is_shown', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      let bannerShowStatusModel: BannerShowStatusModel = BannerShowStatusModel.instance;
      let mockBannerShowStatusModel: BannerShowStatusModel = mocker.mockFunc(bannerShowStatusModel, bannerShowStatusModel.hideBanner);
      when(mockBannerShowStatusModel)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      mocker.ignoreMock(bannerShowStatusModel, bannerShowStatusModel.hideBanner);
    });

    it('should_not_hide_banner_when_offsetX_is_zero_and_notification_is_protected_and_banner_is_not_shown', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined =
        mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0, resetOffsetX: (x: boolean) => {
        }
      });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is
      Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm =
        mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
    });

    it('should_log_info_when_offsetX_is_not_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 10, resetOffsetX: (x: boolean) => {} });
      let logHelper: LogHelper = LogHelper.getInstance();
      let logDomain: LogDomain = new LogDomain(0);
      when(logHelper)(ArgumentMatchers.any).afterReturn(logDomain);

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
    });

    it('should_call_getCardVm_onClick_when_offsetX_is_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      when(getCardVm)(ArgumentMatchers.any).afterReturn({ onClick: (x: NotificationBase) => {} });

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
    });

    it('should_reset_offsetX_to_zero_when_offsetX_is_not_zero', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 10, resetOffsetX: (x: boolean) => {} });

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
    });

    it('should_set_protected_status_when_offsetX_is_zero_and_notification_is_protected', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
    });

    it('should_not_set_protected_status_when_offsetX_is_zero_and_notification_is_not_protected', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = false;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
    });

    it('should_hide_banner_when_offsetX_is_zero_and_notification_is_protected_and_banner_is_shown', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({ offsetX: 0, resetOffsetX: (x: boolean) => {} });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm = mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      let bannerShowStatusModel: BannerShowStatusModel = BannerShowStatusModel.instance;
      let mockBannerShowStatusModel: BannerShowStatusModel = mocker.mockFunc(bannerShowStatusModel, bannerShowStatusModel.hideBanner);
      when(mockBannerShowStatusModel)(ArgumentMatchers.any).afterReturnNothing();

      notificationprivacyvm.onClick();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
      mocker.ignoreMock(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      mocker.ignoreMock(bannerShowStatusModel, bannerShowStatusModel.hideBanner);
    });

    it('should_not_hide_banner_when_offsetX_is_zero_and_notification_is_protected_and_banner_is_not_shown', 0, () => {
      let notificationprivacyvm: NotificationPrivacyVm = new NotificationPrivacyVm();
      let mocker: MockKit = new MockKit();
      let swipeVm: INotificationSwipeVm | undefined =
        mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.swipeVm);
      when(swipeVm)(ArgumentMatchers.any).afterReturn({
        offsetX: 0, resetOffsetX: (x: boolean) => {
        }
      });

      let getCardVm: INotificationCardVm = mocker.mockFunc(notificationprivacyvm, notificationprivacyvm.getCardVm);
      let notificationBase: NotificationBase = new NotificationBase();
      notificationBase.is
      Protected = true;
      when(getCardVm)(ArgumentMatchers.any).afterReturn(notificationBase);

      let appProtectedStatusVm: AppProtectedStatusVm = AppProtectedStatusVm.instance;
      let mockAppProtectedStatusVm: AppProtectedStatusVm =
        mocker.mockFunc(appProtectedStatusVm, appProtectedStatusVm.setAppNotificationPrivacyStatus);
      when(mockAppProtectedStatusVm)(ArgumentMatchers.any).afterReturnNothing();

      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.swipeVm);
      mocker.ignoreMock(notificationprivacyvm, notificationprivacyvm.getCardVm);
    });
  });
}