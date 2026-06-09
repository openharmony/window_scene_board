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
import {
  SingletonHelper,
  LogDomain,
  LogHelper,
  CommonUtils,
  AnimateToScheduleUtils,
  DomainName,
  Trace,
  TraceUtil,
  AppStorageUtil,
  DataProperty
} from '@ohos/basicutils';
import {
  DropDownEvent,
  TargetPanel,
  TargetChangeState,
  WindowEvent,
  DropDownStatus,
  EvtBus,
  RequestWindowEvent,
  HiSysEventUtil,
  HiSysDataResult,
  DeviceHelper,
  ViewManagerPolicy,
  HiDfxEventUtil,
  sSettingsUtil,
  CutoutEvent,
  EventManager,
  ViewArea as ScreenRect,
} from '@ohos/frameworkwrapper';
import { DisplayMgr, ResUtils, SCBScreenSessionManager } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { RotationConstants } from '@ohos/commonconstants';
import { ViewType } from '@ohos/frameworkwrapper';
import curves from '@ohos.curves';
import { DropDownPanelManagerWrapper } from '@ohos/frameworkwrapper';
import settings from '@ohos.settings';
import display from '@ohos.display';
import performanceMonitor from '@ohos.arkui.performanceMonitor';
import { bannerMgr } from '../../../main/ets/banner/phone/BannerManager';
import { BannerPanelType } from '../../../main/ets/banner/common/info/BannerState';
import { NotificationSysEventReporter } from '../../../main/ets/utils/NotificationSysEventReporter';
import { SceneFlag } from '../../../main/ets/base/common/SceneFlag';
import screenLock from '@ohos.screenLock';
import { baseStateMgr } from '@ohos/systemuiutils';
import { ControlCenterAnimatingEvent, StaticBlurEvent } from '@ohos/systemuiutils/src/main/ets/sysdialog/CommonEvent';
import { StatisticsMaintenance } from '../../../main/ets/maintenance/StatisticsMaintenance';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { StatusBarMoveDownVmV1, StatusBarMoveDownVmV2 } from '../../../main/ets/statusbar/vm/StatusBarMoveDownVm';
import { SystemUICcmConfig } from '../../../main/ets/utils/SystemUICcmConfig';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { DropDownPanelManager } from '../../../main/ets/manager/DropDownPanelManager';
export default function DropDownPanelManagerTest() {
  describe('postRequestHideWindow_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_post_request_hide_window_event_with_isAnim_true', 0, () => {
      let mocker: MockKit = new MockKit();

      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      dropdownpanelmanager.postRequestHideWindow(true);

    });

    it('should_post_request_hide_window_event_with_isAnim_false', 0, () => {
      let mocker: MockKit = new MockKit();

      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      dropdownpanelmanager.postRequestHideWindow(false);

    });

    it('should_log_info_when_set_dismiss_callback', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      let callback: () => void = () => {};
      dropdownpanelmanager.setPanelDismissCallback(callback);

      expect(mockfunc).assertCalledWith("setPanelDismissCallback");
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_dismiss_callback_when_set_dismiss_callback', 0, () => {
      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      let callback: () => void = () => {};
      dropdownpanelmanager.setPanelDismissCallback(callback);

      expect(dropdownpanelmanager.dismissCallback).assertEqual(callback);
    });


    it('should_log_info_when_progress_and_moveY_are_valid', 0, () => {
      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

      let dropDownEvent: DropDownEvent = new DropDownEvent();
      dropDownEvent.progress = 1;
      dropDownEvent.moveY = 1;
      dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
      dropdownpanelmanager.dropDownEvent = dropDownEvent;

      dropdownpanelmanager.touchEndCheckAnim();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_release_live_list_when_progress_is_1_and_moveY_is_greater_than_0', 0, () => {
      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

      let dropDownEvent: DropDownEvent = new DropDownEvent();
      dropDownEvent.progress = 1;
      dropDownEvent.moveY = 1;
      dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
      dropdownpanelmanager.dropDownEvent = dropDownEvent;

      let mockfuncReleaseLiveList: Function = mocker.mockFunc(dropdownpanelmanager, dropdownpanelmanager.releaseLiveList);
      when(mockfuncReleaseLiveList)().afterReturn(undefined);

      dropdownpanelmanager.touchEndCheckAnim();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(dropdownpanelmanager, dropdownpanelmanager.releaseLiveList);
    });

    it('should_set_isEndAnimRunning_to_true_when_target_is_NOTIFICATION_PANEL', 0, () => {
      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

      let dropDownEvent: DropDownEvent = new DropDownEvent();
      dropDownEvent.progress = 1;
      dropDownEvent.moveY = 1;
      dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
      dropdownpanelmanager.dropDownEvent = dropDownEvent;

      dropdownpanelmanager.touchEndCheckAnim();

      expect(dropdownpanelmanager.dropDownEvent.isEndAnimRunning).assertTrue();

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_animate_to_end_when_target_is_NOTIFICATION_PANEL', 0, () => {
      let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

      let dropDownEvent: DropDownEvent = new DropDownEvent();
      dropDownEvent.progress = 1;
      dropDownEvent.moveY = 1;
      dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
      dropdownpanelmanager.dropDownEvent = dropDownEvent;

      let mockfuncGetEndAnim: Function = mocker.mockFunc(dropdownpanelmanager, dropdownpanelmanager.getEndAnim);
      let animateParam: AnimateParam = new AnimateParam();
      when(mockfuncGetEndAnim)().afterReturn(animateParam);

      dropdownpanelmanager.touchEndCheckAnim();

      expect(dropdownpanelmanager.dropDownEvent.moveY).assertEqual(0);
      expect(dropdownpanelmanager.dropDownEvent.translateY).assertEqual(0);
      expect(dropdownpanelmanager.dropDownEvent.targetChangedMove).assertEqual(0);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(dropdownpanelmanager, dropdownpanelmanager.getEndAnim);
    });

  it('should_post_request_hide_window_event_with_isAnim_true', 0, () => {
    let mocker: MockKit = new MockKit();

    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    dropdownpanelmanager.postRequestHideWindow(true);

  });

  it('should_post_request_hide_window_event_with_isAnim_false', 0, () => {
    let mocker: MockKit = new MockKit();

    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    dropdownpanelmanager.postRequestHideWindow(false);

  });

  it('should_log_info_when_set_dismiss_callback', 0, () => {
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.getInstance();
    let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    let callback: () => void = () => {};
    dropdownpanelmanager.setPanelDismissCallback(callback);

    expect(mockfunc).assertCalledWith("setPanelDismissCallback");
    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_set_dismiss_callback_when_set_dismiss_callback', 0, () => {
    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    let callback: () => void = () => {};
    dropdownpanelmanager.setPanelDismissCallback(callback);

    expect(dropdownpanelmanager.dismissCallback).assertEqual(callback);
  });


  it('should_log_info_when_progress_and_moveY_are_valid', 0, () => {
    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.getInstance();
    let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

    let dropDownEvent: DropDownEvent = new DropDownEvent();
    dropDownEvent.progress = 1;
    dropDownEvent.moveY = 1;
    dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
    dropdownpanelmanager.dropDownEvent = dropDownEvent;

    dropdownpanelmanager.touchEndCheckAnim();

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_release_live_list_when_progress_is_1_and_moveY_is_greater_than_0', 0, () => {
    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.getInstance();
    let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

    let dropDownEvent: DropDownEvent = new DropDownEvent();
    dropDownEvent.progress = 1;
    dropDownEvent.moveY = 1;
    dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
    dropdownpanelmanager.dropDownEvent = dropDownEvent;

    let mockfuncReleaseLiveList: Function = mocker.mockFunc(dropdownpanelmanager, dropdownpanelmanager.releaseLiveList);
    when(mockfuncReleaseLiveList)().afterReturn(undefined);

    dropdownpanelmanager.touchEndCheckAnim();

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(dropdownpanelmanager, dropdownpanelmanager.releaseLiveList);
  });

  it('should_set_isEndAnimRunning_to_true_when_target_is_NOTIFICATION_PANEL', 0, () => {
    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.getInstance();
    let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

    let dropDownEvent: DropDownEvent = new DropDownEvent();
    dropDownEvent.progress = 1;
    dropDownEvent.moveY = 1;
    dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
    dropdownpanelmanager.dropDownEvent = dropDownEvent;

    dropdownpanelmanager.touchEndCheckAnim();

    expect(dropdownpanelmanager.dropDownEvent.isEndAnimRunning).assertTrue();

    mocker.ignoreMock(logHelper, logHelper.showInfo);
  });

  it('should_animate_to_end_when_target_is_NOTIFICATION_PANEL', 0, () => {
    let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
    let mocker: MockKit = new MockKit();
    let logHelper: LogHelper = LogHelper.getInstance();
    let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
    when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

    let dropDownEvent: DropDownEvent = new DropDownEvent();
    dropDownEvent.progress = 1;
    dropDownEvent.moveY = 1;
    dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
    dropdownpanelmanager.dropDownEvent = dropDownEvent;

    let mockfuncGetEndAnim: Function = mocker.mockFunc(dropdownpanelmanager, dropdownpanelmanager.getEndAnim);
    let animateParam: AnimateParam = new AnimateParam();
    when(mockfuncGetEndAnim)().afterReturn(animateParam);

    dropdownpanelmanager.touchEndCheckAnim();

    expect(dropdownpanelmanager.dropDownEvent.moveY).assertEqual(0);
    expect(dropdownpanelmanager.dropDownEvent.translateY).assertEqual(0);
    expect(dropdownpanelmanager.dropDownEvent.targetChangedMove).assertEqual(0);

    mocker.ignoreMock(logHelper, logHelper.showInfo);
    mocker.ignoreMock(dropdownpanelmanager, dropdownpanelmanager.getEndAnim);
  });

it('should_post_request_hide_window_event_with_isAnim_true', 0, () => {
  let mocker: MockKit = new MockKit();

  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  dropdownpanelmanager.postRequestHideWindow(true);

});

it('should_post_request_hide_window_event_with_isAnim_false', 0, () => {
  let mocker: MockKit = new MockKit();

  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  dropdownpanelmanager.postRequestHideWindow(false);

});

it('should_log_info_when_set_dismiss_callback', 0, () => {
  let mocker: MockKit = new MockKit();
  let logHelper: LogHelper = LogHelper.getInstance();
  let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
  when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let callback: () => void = () => {};
  dropdownpanelmanager.setPanelDismissCallback(callback);

  expect(mockfunc).assertCalledWith("setPanelDismissCallback");
  mocker.ignoreMock(logHelper, logHelper.showInfo);
});

it('should_set_dismiss_callback_when_set_dismiss_callback', 0, () => {
  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let callback: () => void = () => {};
  dropdownpanelmanager.setPanelDismissCallback(callback);

  expect(dropdownpanelmanager.dismissCallback).assertEqual(callback);
});


it('should_log_info_when_progress_and_moveY_are_valid', 0, () => {
  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let mocker: MockKit = new MockKit();
  let logHelper: LogHelper = LogHelper.getInstance();
  let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
  when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

  let dropDownEvent: DropDownEvent = new DropDownEvent();
  dropDownEvent.progress = 1;
  dropDownEvent.moveY = 1;
  dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
  dropdownpanelmanager.dropDownEvent = dropDownEvent;

  dropdownpanelmanager.touchEndCheckAnim();

  mocker.ignoreMock(logHelper, logHelper.showInfo);
});

it('should_release_live_list_when_progress_is_1_and_moveY_is_greater_than_0', 0, () => {
  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let mocker: MockKit = new MockKit();
  let logHelper: LogHelper = LogHelper.getInstance();
  let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
  when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

  let dropDownEvent: DropDownEvent = new DropDownEvent();
  dropDownEvent.progress = 1;
  dropDownEvent.moveY = 1;
  dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
  dropdownpanelmanager.dropDownEvent = dropDownEvent;

  let mockfuncReleaseLiveList: Function = mocker.mockFunc(dropdownpanelmanager, dropdownpanelmanager.releaseLiveList);
  when(mockfuncReleaseLiveList)().afterReturn(undefined);

  dropdownpanelmanager.touchEndCheckAnim();

  mocker.ignoreMock(logHelper, logHelper.showInfo);
  mocker.ignoreMock(dropdownpanelmanager, dropdownpanelmanager.releaseLiveList);
});

it('should_set_isEndAnimRunning_to_true_when_target_is_NOTIFICATION_PANEL', 0, () => {
  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let mocker: MockKit = new MockKit();
  let logHelper: LogHelper = LogHelper.getInstance();
  let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
  when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

  let dropDownEvent: DropDownEvent = new DropDownEvent();
  dropDownEvent.progress = 1;
  dropDownEvent.moveY = 1;
  dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
  dropdownpanelmanager.dropDownEvent = dropDownEvent;

  dropdownpanelmanager.touchEndCheckAnim();

  expect(dropdownpanelmanager.dropDownEvent.isEndAnimRunning).assertTrue();

  mocker.ignoreMock(logHelper, logHelper.showInfo);
});

it('should_animate_to_end_when_target_is_NOTIFICATION_PANEL', 0, () => {
  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let mocker: MockKit = new MockKit();
  let logHelper: LogHelper = LogHelper.getInstance();
  let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
  when(mockfunc)(ArgumentMatchers.anyString).afterReturn(undefined);

  let dropDownEvent: DropDownEvent = new DropDownEvent();
  dropDownEvent.progress = 1;
  dropDownEvent.moveY = 1;
  dropDownEvent.target = TargetPanel.NOTIFICATION_PANEL;
  dropdownpanelmanager.dropDownEvent = dropDownEvent;

  let mockfuncGetEndAnim: Function = mocker.mockFunc(dropdownpanelmanager, dropdownpanelmanager.getEndAnim);
  let animateParam: AnimateParam = new AnimateParam();
  when(mockfuncGetEndAnim)().afterReturn(animateParam);

  dropdownpanelmanager.touchEndCheckAnim();

  expect(dropdownpanelmanager.dropDownEvent.moveY).assertEqual(0);
  expect(dropdownpanelmanager.dropDownEvent.translateY).assertEqual(0);
  expect(dropdownpanelmanager.dropDownEvent.targetChangedMove).assertEqual(0);

  mocker.ignoreMock(logHelper, logHelper.showInfo);
  mocker.ignoreMock(dropdownpanelmanager, dropdownpanelmanager.getEndAnim);
});


it('should_post_request_hide_window_event_with_isAnim_true', 0, () => {
  let mocker: MockKit = new MockKit();

  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  dropdownpanelmanager.postRequestHideWindow(true);

});

it('should_post_request_hide_window_event_with_isAnim_false', 0, () => {
  let mocker: MockKit = new MockKit();

  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  dropdownpanelmanager.postRequestHideWindow(false);

});

it('should_log_info_when_set_dismiss_callback', 0, () => {
  let mocker: MockKit = new MockKit();
  let logHelper: LogHelper = LogHelper.getInstance();
  let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
  when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let callback: () => void = () => {};
  dropdownpanelmanager.setPanelDismissCallback(callback);

  expect(mockfunc).assertCalledWith("setPanelDismissCallback");
  mocker.ignoreMock(logHelper, logHelper.showInfo);
});

it('should_set_dismiss_callback_when_set_dismiss_callback', 0, () => {
  let dropdownpanelmanager: DropDownPanelManager = new DropDownPanelManager();
  let callback: () => void = () => {};
  dropdownpanelmanager.setPanelDismissCallback(callback);

  expect(dropdownpanelmanager.dismissCallback).assertEqual(callback);
});
};
}
