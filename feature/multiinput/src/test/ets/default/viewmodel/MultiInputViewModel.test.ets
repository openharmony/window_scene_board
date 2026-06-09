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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType } from '@ohos/hypium'
import { MultiInputViewModel } from '../../../../main/ets/default/common/viewmodel/MultiInputViewModel'
import EventConstants from '../../../../main/ets/default/common/constants/EventConstants'
import { MouseEvent, ToolType } from '@ohos.multimodalInput.mouseEvent';
import { localEventManager, viewMgrPolicy, ViewType } from '@ohos/frameworkwrapper';
import { ReflectionUtils } from '../../../../../../pcmode/src/ohosTest/ets/test/ets/ReflectionUtils'

/**
 * MultiInputViewModel测试
 *
 * @since 2023-11-30
 */
let multiInputViewModel: MultiInputViewModel;

export default function MultiInputViewModelTest() {
  describe('MultiInputViewModelTest', (): void => {
    beforeAll((): void => {
      multiInputViewModel = MultiInputViewModel.getInstance();
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
      multiInputViewModel.unregisterEventListener();
    })

    it('Test_ShorCut_Key_win_tab', 0, (): void => {
      AppStorage.setOrCreate('winTab', true);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_TAB, null);
      let showRecent: boolean = AppStorage.get<boolean>('showRecent') as boolean;
      expect(showRecent).assertTrue();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_TAB_UP, null);
    })

    it('Test_ShorCut_Key_win_dpad_up', 0, (): void => {
      AppStorage.setOrCreate('winTab', true);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_DPAD_UP, null);
      let showRecent: boolean = AppStorage.get<boolean>('showRecent') as boolean;
      expect(showRecent).assertFalse();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_TAB_UP, null);
    })

    it('Test_ShorCut_Key_alt_tab', 0, (): void => {
      AppStorage.setOrCreate('altTab', true);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_ALT_TAB, null);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_TAB_UP, null);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_ALT_UP, null);
    })

    it('Test_ShorCut_Key_win_up', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_UP, null);
      expect(viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)).assertTrue();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_UP, null);
    })

    it('Test_ShorCut_Key_win_shift_s', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_SHIFT_S, null);
    })

    it('Test_ShorCut_Key_fn_sysrq', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_FN_SYSRQ, null);
    })

    it('Test_ShorCut_Key_win_shift_r', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_SHIFT_R, null);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_SHIFT_R, null);
    })

    it('Test_ShorCut_Key_win_s', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_S, null);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_S, null);
    })

    it('Test_ShorCut_Key_win_slash', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_SLASH, null);
      let isShortcutKeyPanelShow: boolean = AppStorage.get<boolean>('isShortcutKeyPanelShow') as boolean;
      expect(isShortcutKeyPanelShow).assertTrue();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_SLASH, null);
    })

    it('Test_ShorCut_Key_win_l', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_L, null);
      expect(viewMgrPolicy.isViewShowing(ViewType.KEYGUARD)).assertTrue();
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_L, null);
    })

    it('Test_ShorCut_Key_win_f', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_F, null);
    })

    it('Test_ShorCut_Key_win_dpad_left', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_DPAD_LEFT, null);
      let focusedSessionExist: boolean = (AppStorage.get<number>('focusedSessionId') as number) ? true : false;
      expect(focusedSessionExist).assertTrue();
    })

    it('Test_ShorCut_Key_win_dpad_right', 0, (): void => {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_WIN_DPAD_RIGHT, null);
      let focusedSessionExist: boolean = (AppStorage.get<number>('focusedSessionId') as number) ? true : false;
      expect(focusedSessionExist).assertTrue();
    })

    it('Test_ShorCut_Key_mouseEvent', 0, (): void => {
      let mouseEvent: MouseEvent = {
        action: 1,
        pressedKeys: [],
        ctrlKey: false,
        altKey: false,
        shiftKey: false,
        logoKey: false,
        fnKey: false,
        id: 0,
        button: -1,
        actionTime: 3234849130,
        deviceId: 2,
        rawDeltaX: 0,
        rawDeltaY: 0,
        screenId: 0,
        screenX: 378,
        screenY: 1365,
        windowId: 0,
        windowX: 378,
        windowY: 1365,
        axes: [{
          "axis": -1, "value": -1
        }],
        pressedButtons: [],
        capsLock: false,
        numLock: false,
        scrollLock: false,
        toolType: ToolType.MOUSE
      };
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_SHORT_CUT_PANEL_STATUS_CHANGE, mouseEvent);
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_DOCK_DISPLAY_STATUS_CHANGE, mouseEvent);
    })

    it('hoverHideStatusBarAndTitleTest', 0, () => {
      let mouseEvent: MouseEvent = {
        action: 1,
        pressedKeys: [],
        ctrlKey: false,
        altKey: false,
        shiftKey: false,
        logoKey: false,
        fnKey: false,
        id: 0,
        button: -1,
        actionTime: 3234849130,
        deviceId: 2,
        rawDeltaX: 0,
        rawDeltaY: 0,
        screenId: 0,
        screenX: 378,
        screenY: 1365,
        windowId: 0,
        windowX: 378,
        windowY: 1365,
        axes: [{
          "axis": -1, "value": -1
        }],
        pressedButtons: [],
        capsLock: false,
        numLock: false,
        scrollLock: false,
        toolType: ToolType.MOUSE
      };
      ReflectionUtils.setProperty(multiInputViewModel, 'lastScreenId', 1);
      ReflectionUtils.useFunc(multiInputViewModel, 'hoverHideStatusBarAndTitle', null, 71, mouseEvent);
      let lastScreenId: number | undefined = ReflectionUtils.getProperty(multiInputViewModel, 'lastScreenId');
      expect(lastScreenId).assertUndefined();
    })

    it('updateStatusAndFloatingTitleTest', 0, () => {
      let mouseEvent: MouseEvent = {
        action: 1,
        pressedKeys: [],
        ctrlKey: false,
        altKey: false,
        shiftKey: false,
        logoKey: false,
        fnKey: false,
        id: 0,
        button: -1,
        actionTime: 3234849130,
        deviceId: 2,
        rawDeltaX: 0,
        rawDeltaY: 0,
        screenId: 0,
        screenX: 378,
        screenY: 1365,
        windowId: 0,
        windowX: 378,
        windowY: 1365,
        axes: [{
          "axis": -1, "value": -1
        }],
        pressedButtons: [],
        capsLock: false,
        numLock: false,
        scrollLock: false,
        toolType: ToolType.MOUSE
      };
      ReflectionUtils.setProperty(multiInputViewModel, 'lastScreenId', undefined);
      ReflectionUtils.useFunc(multiInputViewModel, 'updateStatusAndFloatingTitle', mouseEvent);
      let lastScreenId: number | undefined = ReflectionUtils.getProperty(multiInputViewModel, 'lastScreenId');
      expect(lastScreenId).assertEqual(0);
    })
  })
}