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

export default function ClickMoreSettingTest() {
  describe('clickMoreSetting', () => {
    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });

    it('should_report_ntf_menu_click_more_setting', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let hiDfxEventUtilMock = mocker.mockFunc(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
      when(hiDfxEventUtilMock)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn();

      clickMoreSetting.clickMoreSetting();

      expect(hiDfxEventUtilMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(HiDfxEventUtil, HiDfxEventUtil.reportNtfMenuClickMoreSetting);
    });

    it('should_handle_more_setting_click_when_is_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let screenLockApiMock = mocker.mockFunc(ScreenLockApi, ScreenLockApi.requestUnlock);
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);

      clickMoreSetting.clickMoreSetting();

      expect(screenLockApiMock).assertCalledWith(ArgumentMatchers.any);
      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      mocker.ignoreMock(ScreenLockApi, ScreenLockApi.requestUnlock);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
    });

    it('should_hide_dialog_and_collapse_panel_when_is_not_keyguard', 0, () => {
      let clickMoreSetting: ClickMoreSetting = new ClickMoreSetting();
      let mocker: MockKit = new MockKit();
      let ntfSettingsDcMock = mocker.mockFunc(NtfSettingsDC, NtfSettingsDC.hideDialog);
      let notificationPanelManagerMock = mocker.mockFunc(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);

      clickMoreSetting.clickMoreSetting();

      expect(ntfSettingsDcMock).assertCalledWith(ArgumentMatchers.any);
      expect(notificationPanelManagerMock).assertCalledWith(ArgumentMatchers.any, ArgumentMatchers.any);
      mocker.ignoreMock(NtfSettingsDC, NtfSettingsDC.hideDialog);
      mocker.ignoreMock(NotificationPanelManager, NotificationPanelManager.collapseNtfPanel);
    });
  });
}
