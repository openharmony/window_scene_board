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

export default function OnSessionCreateTest() {
  describe('onSessionCreate', () => {
    it('should_terminate_session_with_result_when_bundleName_is_empty_or_uid_is_minus_one', 0, () => {
      let want: Want = { parameters: {} };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.PARAM_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showError);
    });

    it('should_terminate_session_with_result_when_ntfConfig_is_undefined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.GET_BUNDLE_INFO_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showWarn);
    });

    it('should_load_content_and_set_window_background_color_when_ntfConfig_is_defined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn(undefined);


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: '',
          appVersion: '',
          appBundleName: '',
          appUid: -1,
          systemApp: false,
          appIcon: '',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });

    it('should_register_window_size_change_when_session_is_active', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn({ label: 'testLabel', versionName: 'testVersion', bundle: 'testBundle', uid: 123, systemApp: false, icon: 'testIcon', appIndex: 0 });


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: 'testLabel',
          appVersion: 'testVersion',
          appBundleName: 'testBundle',
          appUid: 123,
          systemApp: false,
          appIcon: 'testIcon',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      expect(this.registerWindowSizeChange).assertCalledNothing();

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });

    it('should_terminate_session_with_result_when_bundleName_is_empty_or_uid_is_minus_one', 0, () => {
      let want: Want = { parameters: {} };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.PARAM_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showError);
    });

    it('should_terminate_session_with_result_when_ntfConfig_is_undefined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.GET_BUNDLE_INFO_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showWarn);
    });

    it('should_load_content_and_set_window_background_color_when_ntfConfig_is_defined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn(undefined);


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: '',
          appVersion: '',
          appBundleName: '',
          appUid: -1,
          systemApp: false,
          appIcon: '',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });

    it('should_register_window_size_change_when_session_is_active', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn({ label: 'testLabel', versionName: 'testVersion', bundle: 'testBundle', uid: 123, systemApp: false, icon: 'testIcon', appIndex: 0 });


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: 'testLabel',
          appVersion: 'testVersion',
          appBundleName: 'testBundle',
          appUid: 123,
          systemApp: false,
          appIcon: 'testIcon',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      expect(this.registerWindowSizeChange).assertCalledNothing();

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });

    it('should_terminate_session_with_result_when_bundleName_is_empty_or_uid_is_minus_one', 0, () => {
      let want: Want = { parameters: {} };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.PARAM_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showError);
    });

    it('should_terminate_session_with_result_when_ntfConfig_is_undefined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.GET_BUNDLE_INFO_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showWarn);
    });

    it('should_load_content_and_set_window_background_color_when_ntfConfig_is_defined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn(undefined);


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: '',
          appVersion: '',
          appBundleName: '',
          appUid: -1,
          systemApp: false,
          appIcon: '',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });

    it('should_register_window_size_change_when_session_is_active', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn({ label: 'testLabel', versionName: 'testVersion', bundle: 'testBundle', uid: 123, systemApp: false, icon: 'testIcon', appIndex: 0 });


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: 'testLabel',
          appVersion: 'testVersion',
          appBundleName: 'testBundle',
          appUid: 123,
          systemApp: false,
          appIcon: 'testIcon',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      expect(this.registerWindowSizeChange).assertCalledNothing();

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });

    it('should_terminate_session_with_result_when_bundleName_is_empty_or_uid_is_minus_one', 0, () => {
      let want: Want = { parameters: {} };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showError);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.PARAM_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showError);
    });

    it('should_terminate_session_with_result_when_ntfConfig_is_undefined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(log, log.showWarn);
      when(mockfunc2)(ArgumentMatchers.anyString).afterReturnNothing();


      onSessionCreate(want, session);

      expect(session.terminateSelfWithResult).assertCalledWith({ resultCode: ExtensionResult.GET_BUNDLE_INFO_ERROR });

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(log, log.showWarn);
    });

    it('should_load_content_and_set_window_background_color_when_ntfConfig_is_defined', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn(undefined);


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: '',
          appVersion: '',
          appBundleName: '',
          appUid: -1,
          systemApp: false,
          appIcon: '',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });

    it('should_register_window_size_change_when_session_is_active', 0, () => {
      let want: Want = { parameters: { 'ohos.aafwk.param.callerBundleName': 'testBundle', 'ohos.aafwk.param.callerUid': 123 } };
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(log, log.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockfunc2: Function = mocker.mockFunc(notificationSettingManager, notificationSettingManager.getAppItem);
      when(mockfunc2)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturn({ label: 'testLabel', versionName: 'testVersion', bundle: 'testBundle', uid: 123, systemApp: false, icon: 'testIcon', appIndex: 0 });


      onSessionCreate(want, session);

      expect(session.loadContent).assertCalledWith(PageConstants.NTF_MGMT_HALF_PATH, PageStorages.wrapPageCtxStorage({
        session, isFromHome: false,
        bundleInfo: {
          appTitle: 'testLabel',
          appVersion: 'testVersion',
          appBundleName: 'testBundle',
          appUid: 123,
          systemApp: false,
          appIcon: 'testIcon',
          appIndex: 0
        }
      }));

      expect(session.setWindowBackgroundColor).assertCalledWith('#00ffffff');

      expect(session.setHideNonSecureWindows).assertCalledWith(true);

      expect(this.registerWindowSizeChange).assertCalledNothing();

      mocker.ignoreMock(log, log.showInfo);
      mocker.ignoreMock(notificationSettingManager, notificationSettingManager.getAppItem);
    });
  });
}