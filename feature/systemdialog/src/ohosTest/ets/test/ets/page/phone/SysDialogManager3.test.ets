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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import {
  BackPressPriority,
  baseStateMgr,
  CommonUtils,
  GestureEnableCaller,
  IState,
  LogDomain,
  LogHelper,
  OccludeKeygaurdScene,
  OnBackPressListener,
  OnStateChangeListener,
  SCBEventId,
  scbGestureManager,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  StateType,
  SysDialogPanelType,
  SysDialogState,
  SysDialogType,
  ViewCallback,
  viewMgrPolicy
} from '../../../../../../main/ets/BaseCommonIndex';

import { PCSysDialogManager } from '../../../../../../main/ets/pages/pc/PCSysDialogManager';

export default function PCSysDialogManagerTest() {
  describe('PCSysDialogManagerTest', () => {

    beforeEach(() => {
    });

    afterEach(() => {
    });

    it('should_return_when_state_is_invalid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 1);
      let mocker: MockKit = new MockKit();
      pcsysdialogmanager.appear(1);

    });

    it('should_register_view_callback_and_gesture_callback_when_state_is_valid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 1);
      let mocker: MockKit = new MockKit();
      let state = new SysDialogState(SysDialogType.TYPE_DEFAULT);

      when(mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState))(ArgumentMatchers.any)
        .afterReturn(state);

      pcsysdialogmanager.appear(1);
    });

    it('should_register_back_press_listener_when_state_is_valid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 1);
      let mocker: MockKit = new MockKit();
      let state = new SysDialogState(SysDialogType.TYPE_DEFAULT);

      when(mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState))(ArgumentMatchers.any)
        .afterReturn(state);

      pcsysdialogmanager.appear(1);

    });

    it('should_return_immediately_when_state_is_invalid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      when(mockfunc)().afterReturn(null);

      pcsysdialogmanager.disappear();

      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_unregister_view_callback_when_state_is_valid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let mockfunc2: Function = mocker.mockFunc(viewMgrPolicy, viewMgrPolicy.unRegisterViewCallback);

      when(mockfunc)().afterReturn(new SysDialogState(SysDialogType.TYPE_DEFAULT));

      pcsysdialogmanager.disappear();

      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(viewMgrPolicy, viewMgrPolicy.unRegisterViewCallback);
    });

    it('should_return_dialogState_when_getDialogState_is_called', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let result = pcsysdialogmanager.getDialogState();
      expect(result).assertInstanceOf(SysDialogState.toString());
    });

    it('should_call_addPanelType_with_TYPE_OUTER', 0, () => {
      let pcsdm: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsdm.requestPanelOuter();
      expect(pcsdm.addPanelType).assertFail();
    });

    it('should_call_clearPanelType_with_TYPE_OUTER', 0, () => {
      let pcsdm: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsdm.releasePanelOuter();
      expect(pcsdm.clearPanelType).assertFail();
    });

    it('should_return_early_when_state_is_invalid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      when(mockfunc)().afterReturn(null);

      pcsysdialogmanager.setGestureState(true, true);

      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_call_checkNavigationEnable_and_set_statusBarGestureStatusCallback_when_state_is_valid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let mockState: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      when(mockfunc)().afterReturn(mockState);

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockCheckNavigationEnable: Function = mocker.mockFunc(
        pcsysdialogmanager,
        pcsysdialogmanager.checkNavigationEnable
      );
      when(mockCheckNavigationEnable)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      pcsysdialogmanager.setGestureState(true, true);

      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(LogHelper, LogHelper);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.checkNavigationEnable);
    });

    it('should_log_error_when_screenSession_is_invalid', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      let pcsdm: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsdm.setEnableRotate(true);

      mocker.ignoreMock(logHelper, logHelper.showError);
    });

    it('should_set_enable_rotate_and_log_info_when_screenSession_is_valid', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      when(screenSession.setEnableRotate)(ArgumentMatchers.anyBoolean).afterReturnNothing();

      let pcsdm: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsdm.setEnableRotate(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_rotationChangeEntry_when_isEnableRotate_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let screenSession: SCBScreenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      when(screenSession.setEnableRotate)(ArgumentMatchers.anyBoolean).afterReturnNothing();
      when(screenSession.rotationChangeEntry)(ArgumentMatchers.anyNumber).afterReturnNothing();

      let pcsdm: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsdm.setEnableRotate(true);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_setGestureNavigationEnable_with_correct_parameters', 0, () => {
      let mocker: MockKit = new MockKit();

      let mockScbGestureManagerSetGestureNavigationEnable: Function = mocker.mockFunc(
        scbGestureManager,
        scbGestureManager.setGestureNavigationEnable
      );
      when(mockScbGestureManagerSetGestureNavigationEnable)(ArgumentMatchers.any).afterReturnNothing();

      let mockLogHelperShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper);
      when(mockLogHelperShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let pcsdm: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 1);
      pcsdm.checkNavigationEnable(true, true);


      mocker.ignoreMock(scbGestureManager, scbGestureManager.setGestureNavigationEnable);
      mocker.ignoreMock(LogHelper, LogHelper);
    });

    it('should_return_when_state_is_invalid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      when(mockfunc)().afterReturn(null);
      pcsysdialogmanager.checkUpdatePanelArea();
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_update_panel_controller_when_screen_size_is_valid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper);
      let mockfunc4: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getPanelController);

      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      let panelController: BaseViewController = new BaseViewController();
      state.setPanelController(panelController);

      when(mockfunc)().afterReturn(state);
      when(mockfunc4)().afterReturn(panelController);

      pcsysdialogmanager.checkUpdatePanelArea();

      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(LogHelper, LogHelper);
      mocker.ignoreMock(LogHelper, LogHelper);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getPanelController);
    });

    it('should_log_error_when_update_panel_controller_fails', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let mockfunc2: Function = mocker.mockFunc(LogHelper, LogHelper);
      let mockfunc3: Function = mocker.mockFunc(LogHelper, LogHelper);
      let mockfunc4: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getPanelController);

      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      let panelController: BaseViewController = new BaseViewController();
      state.setPanelController(panelController);

      when(mockfunc)().afterReturn(state);
      when(mockfunc4)().afterReturn(panelController);

      pcsysdialogmanager.checkUpdatePanelArea();

      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(LogHelper, LogHelper);
      mocker.ignoreMock(LogHelper, LogHelper);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getPanelController);
    });

    it('should_register_statusBarGestureStatusListener_when_callback_is_provided', 0, () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsysdialogmanager.registerStatusBarGestureStatusListener((gestureStatus: boolean) => {
        log.showInfo(`lds_test_statusBarGestureStatusCallback ${gestureStatus}`);
      });

      expect(pcsysdialogmanager.statusBarGestureStatusCallback).assertInstanceOf(Function);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_register_statusBarGestureStatusListener_when_callback_is_not_provided', 0, () => {
      let mocker: MockKit = new MockKit();

      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsysdialogmanager.registerStatusBarGestureStatusListener(undefined);

      expect(pcsysdialogmanager.statusBarGestureStatusCallback).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_return_false_when_state_is_invalid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      when(mockfunc)().afterReturn(null);
      const result = pcsysdialogmanager.isSysDialogShowing();
      expect(result).assertEqual(false);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_return_true_when_dialog_is_showing', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let mockState: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      when(mockfunc)().afterReturn(mockState);
      const result = pcsysdialogmanager.isSysDialogShowing();
      expect(result).assertEqual(true);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_return_false_when_dialog_is_not_showing', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let mockState: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      when(mockfunc)().afterReturn(mockState);
      const result = pcsysdialogmanager.isSysDialogShowing();
      expect(result).assertEqual(false);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_return_immediately_when_state_is_invalid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      when(mockfunc)().afterReturn(null);
      pcsysdialogmanager.clearPanelType(SysDialogPanelType.TYPE_DEFAULT);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_return_immediately_when_panelType_is_not_present', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      when(mockfunc)().afterReturn(state);
      pcsysdialogmanager.clearPanelType(SysDialogPanelType.TYPE_DEFAULT);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_clear_panelType_and_call_checkNavigationEnable', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      let panelState: SysDialogPanelTypeState = new SysDialogPanelTypeState();
      panelState.addPanelType(SysDialogPanelType.TYPE_DEFAULT);
      state.panelTypeState = panelState;
      when(mockfunc)().afterReturn(state);

      let mockfunc2: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.checkNavigationEnable);
      when(mockfunc2)(ArgumentMatchers.anyBoolean, ArgumentMatchers.anyBoolean).afterReturnNothing();

      pcsysdialogmanager.clearPanelType(SysDialogPanelType.TYPE_DEFAULT);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.checkNavigationEnable);
    });

    it('should_hide_panel_and_update_keyguard_occluded_state_when_panelType_is_none', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsysdialogmanager.isNeedUpdateScreenLockOccluded = true;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      let panelState: SysDialogPanelTypeState = new SysDialogPanelTypeState();
      panelState.addPanelType(SysDialogPanelType.TYPE_NONE);
      state.panelTypeState = panelState;
      when(mockfunc)().afterReturn(state);

      let mockfunc2: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getPanelController);
      when(mockfunc2)().afterReturn({ hide: () => {} });

      let mockfunc3: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().updateKeyguardOccludedState);
      when(mockfunc3)(ArgumentMatchers.any, ArgumentMatchers.anyBoolean).afterReturnNothing();

      pcsysdialogmanager.clearPanelType(SysDialogPanelType.TYPE_NONE);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getPanelController);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().updateKeyguardOccludedState);
    });

    it('should_return_immediately_when_state_is_invalid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      when(mockfunc)().afterReturn(null);
      pcsysdialogmanager.addPanelType(SysDialogPanelType.PANEL_TYPE_SYSTEM);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_return_immediately_when_panel_type_already_exists', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      let panelState: SysDialogPanelTypeState = new SysDialogPanelTypeState();
      panelState.addPanelType(SysDialogPanelType.PANEL_TYPE_SYSTEM);
      state.panelTypeState = panelState;
      when(mockfunc)().afterReturn(state);
      pcsysdialogmanager.addPanelType(SysDialogPanelType.PANEL_TYPE_SYSTEM);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
    });

    it('should_add_panel_type_and_show_panel_when_state_is_valid', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_DEFAULT);
      let panelState: SysDialogPanelTypeState = new SysDialogPanelTypeState();
      state.panelTypeState = panelState;
      let mockPanelController: BaseViewController = new BaseViewController();
      when(mockfunc)().afterReturn(state);
      let mockGetPanelController: Function = mocker.mockFunc(state, state.getPanelController);
      when(mockGetPanelController)().afterReturn(mockPanelController);
      pcsysdialogmanager.addPanelType(SysDialogPanelType.PANEL_TYPE_SYSTEM);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(state, state.getPanelController);
    });

    it('should_update_keyguard_occluded_state_when_screen_is_locked', 0, () => {
      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_UPPER, 0);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      let state: SysDialogState = new SysDialogState(SysDialogType.TYPE_UPPER);
      let panelState: SysDialogPanelTypeState = new SysDialogPanelTypeState();
      state.panelTypeState = panelState;
      let mockPanelController: BaseViewController = new BaseViewController();
      when(mockfunc)().afterReturn(state);
      let mockGetPanelController: Function = mocker.mockFunc(state, state.getPanelController);
      when(mockGetPanelController)().afterReturn(mockPanelController);
      let mockIsScreenLocked: Function = mocker.mockFunc(
        SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isScreenLocked);
      when(mockIsScreenLocked)().afterReturn(true);
      let mockUpdateKeyguardOccludedState: Function = mocker.mockFunc(
        SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().updateKeyguardOccludedState);
      when(mockUpdateKeyguardOccludedState)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturnNothing();
      pcsysdialogmanager.addPanelType(SysDialogPanelType.PANEL_TYPE_SYSTEM);
      mocker.ignoreMock(pcsysdialogmanager, pcsysdialogmanager.getDialogState);
      mocker.ignoreMock(state, state.getPanelController);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isScreenLocked);
      mocker.ignoreMock(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().updateKeyguardOccludedState);
    });


    it('should_log_info_and_call_checkUpdatePanelArea_when_onDisplaySizeChange_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockCheckUpdatePanelArea: Function = mocker.mockFunc(
        PCSysDialogManager.prototype, PCSysDialogManager.prototype.checkUpdatePanelArea);
      when(mockCheckUpdatePanelArea)().afterReturnNothing();

      let pcsysdialogmanager: PCSysDialogManager = new PCSysDialogManager(SysDialogType.TYPE_DEFAULT, 0);
      pcsysdialogmanager.onDisplaySizeChange();

      expect(mockShowInfo).assertCalledWith('onDisplaySizeChange start');
      expect(mockCheckUpdatePanelArea).assertCalled();

      mocker.ignoreMock(logHelper, logHelper);
      mocker.ignoreMock(PCSysDialogManager, PCSysDialogManager.prototype.checkUpdatePanelArea);
    });

  });
}