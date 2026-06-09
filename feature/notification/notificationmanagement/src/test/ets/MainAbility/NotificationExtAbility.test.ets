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

export default function OnSessionCreateTest() {
  describe('onSessionCreate', () => {
    it('should_load_ntf_and_status_bar_page_when_launch_home_page', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchHomePage: Function = mocker.mockFunc(param, param.isLaunchHomePage);
      when(mockIsLaunchHomePage)().afterReturn(true);

      let mockLoadNtfAndStatusBarPage: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
      when(mockLoadNtfAndStatusBarPage)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchHomePage);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
    });

    it('should_load_sub_page_by_home_when_launch_by_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(true);

      let mockLoadSubPageByHome: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
      when(mockLoadSubPageByHome)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_ntf_and_status_bar_page_when_launch_home_page', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchHomePage: Function = mocker.mockFunc(param, param.isLaunchHomePage);
      when(mockIsLaunchHomePage)().afterReturn(true);

      let mockLoadNtfAndStatusBarPage: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
      when(mockLoadNtfAndStatusBarPage)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchHomePage);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
    });

    it('should_load_sub_page_by_home_when_launch_by_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(true);

      let mockLoadSubPageByHome: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
      when(mockLoadSubPageByHome)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_ntf_and_status_bar_page_when_launch_home_page', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchHomePage: Function = mocker.mockFunc(param, param.isLaunchHomePage);
      when(mockIsLaunchHomePage)().afterReturn(true);

      let mockLoadNtfAndStatusBarPage: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
      when(mockLoadNtfAndStatusBarPage)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchHomePage);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
    });

    it('should_load_sub_page_by_home_when_launch_by_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(true);

      let mockLoadSubPageByHome: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
      when(mockLoadSubPageByHome)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_ntf_and_status_bar_page_when_launch_home_page', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchHomePage: Function = mocker.mockFunc(param, param.isLaunchHomePage);
      when(mockIsLaunchHomePage)().afterReturn(true);

      let mockLoadNtfAndStatusBarPage: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
      when(mockLoadNtfAndStatusBarPage)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchHomePage);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
    });

    it('should_load_sub_page_by_home_when_launch_by_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(true);

      let mockLoadSubPageByHome: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
      when(mockLoadSubPageByHome)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_ntf_and_status_bar_page_when_launch_home_page', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchHomePage: Function = mocker.mockFunc(param, param.isLaunchHomePage);
      when(mockIsLaunchHomePage)().afterReturn(true);

      let mockLoadNtfAndStatusBarPage: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
      when(mockLoadNtfAndStatusBarPage)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchHomePage);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
    });

    it('should_load_sub_page_by_home_when_launch_by_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(true);

      let mockLoadSubPageByHome: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
      when(mockLoadSubPageByHome)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_ntf_and_status_bar_page_when_launch_home_page', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchHomePage: Function = mocker.mockFunc(param, param.isLaunchHomePage);
      when(mockIsLaunchHomePage)().afterReturn(true);

      let mockLoadNtfAndStatusBarPage: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
      when(mockLoadNtfAndStatusBarPage)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchHomePage);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
    });

    it('should_load_sub_page_by_home_when_launch_by_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(true);

      let mockLoadSubPageByHome: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
      when(mockLoadSubPageByHome)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageByHome);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_sub_page_directly_when_not_launch_home_page_or_external', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchByExternal: Function = mocker.mockFunc(param, param.isLaunchByExternal);
      when(mockIsLaunchByExternal)().afterReturn(false);

      let mockLoadSubPageDirectly: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
      when(mockLoadSubPageDirectly)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchByExternal);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadSubPageDirectly);
    });

    it('should_load_ntf_and_status_bar_page_when_launch_home_page', 0, () => {
      let want: Want = new Want();
      let session: UIExtensionContentSession = new UIExtensionContentSession();
      let mocker: MockKit = new MockKit();

      let param: LaunchParam = new LaunchParam(want, session);
      let mockIsLaunchHomePage: Function = mocker.mockFunc(param, param.isLaunchHomePage);
      when(mockIsLaunchHomePage)().afterReturn(true);

      let mockLoadNtfAndStatusBarPage: Function = mocker.mockFunc(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
      when(mockLoadNtfAndStatusBarPage)(ArgumentMatchers.any).afterReturnNothing();

      const result = CalDevAccountRepository.onSessionCreate(want, session);

      mocker.ignoreMock(param, param.isLaunchHomePage);
      mocker.ignoreMock(CalDevAccountRepository, CalDevAccountRepository.loadNtfAndStatusBarPage);
    });
  });
}