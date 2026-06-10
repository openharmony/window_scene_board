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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, Level, when,
  ArgumentMatchers } from '@ohos/hypium'
import { SCBSceneSessionManager, SCBScreenSession } from '@ohos/windowscene';
import { SCBTvCastEventManager } from '../../../../../main/ets/manager/SCBTvCastEventManager';
import { SCBGeneralScreenViewModel } from '../../../../../main/ets/viewmodel/SCBGeneralScreenViewModel';
import { MockScreenSession } from '../mock/MockScreenSession.test';

export default function SCBGeneralScreenViewModelTest() {
  describe('SCBGeneralScreenViewModel_Init_Test', () => {
    let screenViewModel: SCBGeneralScreenViewModel;
    let screenSession: SCBScreenSession;
    let mockScreen: MockScreenSession = new MockScreenSession();
    let mocker: MockKit;

    beforeAll(() => {
      screenSession = new SCBScreenSession(mockScreen);
      screenViewModel = new SCBGeneralScreenViewModel(screenSession);
    });

    beforeEach(() => {
      mocker = new MockKit();
    });

    afterEach(() => {
      mocker.clearAll();
    });

    it('should_initialize_correctly', Level.LEVEL0, () => {
      screenViewModel.init();
      expect(screenViewModel.screenSession).assertInstanceOf('SCBScreenSession');
      expect(screenViewModel.scbScreenProperty).assertInstanceOf('SCBScreenProperty');
    });

    it('should_register_screenPropertyChangeListener', Level.LEVEL0, () => {
      let mockRegisterPropertyChange = mocker.mockFunc(screenSession, screenSession.registerPropertyChange);
      when(mockRegisterPropertyChange)(ArgumentMatchers.any).afterReturn(true);
      screenViewModel.init();
      mocker.verify('registerPropertyChange', [mockRegisterPropertyChange]).atLeast(1);
    });

    it('should_set_PanelLists_correctly', Level.LEVEL0, () => {
      let mockSetPanelLists = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().setPanelLists);
      when(mockSetPanelLists)(ArgumentMatchers.any).afterReturn(true);
      screenViewModel.init();
      mocker.verify('setPanelLists', [screenViewModel.scbScreenProperty.screenId]).atLeast(1);
    });

    it('should_initialize_SCBTvCastEventManager', Level.LEVEL0, () => {
      let mockInit = mocker.mockFunc(SCBTvCastEventManager.getInstance(), SCBTvCastEventManager.getInstance().init);
      when(mockInit)(ArgumentMatchers.any).afterReturn(true);
      screenViewModel.init();
      mocker.verify('init', [screenSession.session]).atLeast(1);
    });
  })
}