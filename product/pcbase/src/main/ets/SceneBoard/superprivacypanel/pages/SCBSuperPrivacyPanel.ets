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

import { MultimodalInputManager, MultiKeyCode, LocalWindowManager } from '@ohos/systemuicommon';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import {
  LogDomain,
  Logger,
  Trace,
  Observer,
} from '@ohos/basicutils';
import {
  PluginSlot,
  PluginWindowType,
  EvtBus,
  EventManager,
  WindowEvent,
  ScreenOnOffEvent,
  viewMgrPolicy,
  ViewArea,
  ViewType,
  ViewCallback,
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { SuperPrivacyPanelView } from '@ohos/superprivacy/src/main/ets/pages/SuperPrivacyPanelView';
import {
  NormalPanelInfo,
  StatusBarPanelInfo,
  StatusBarPanelManager
} from '../../../common/manager/StatusBarPanelManager';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';

const TAG = 'SCBSuperPrivacyPanel-Index';
const log: Logger = Logger.getLogHelper(LogDomain.SCB);

/**
 * 窗口名
 */
const REQUEST_FOCUS_MENU = 'request_focus_menu_';

@Component
export struct SCBSuperPrivacyPanel {
  @State viewType: ViewType = ViewType.PC_SUPER_PRIVACY_PANEL;
  @State windowName: string = PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT;
  @State superPrivacyPanelCtrl: PcStbSecondaryPanelController =
    new PcStbSecondaryPanelController(this.viewType); // 注册事件
  @Provide persistentId: number = 0;
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private screenLockObserver: Observer = {
    notify: (): void => {}
  };
  private viewCallback: ViewCallback = {
    onShow: (): void => this.onViewShow(),
    onHide: (): void => this.onViewHide()
  };
  mTimeMeterOfSuperPrivacyPanel: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear() {
    log.info(TAG, `aboutToAppear, start, viewType: ${this.viewType}`);
    this.superPrivacyPanelCtrl = new PcStbSecondaryPanelController(this.viewType);
    viewMgrPolicy.registerViewController(this.viewType, this.superPrivacyPanelCtrl);
    this.superPrivacyPanelCtrl.updateId(this.persistentId);
    this.superPrivacyPanelCtrl.registerCallback(this.viewCallback);
    this.superPrivacyPanelCtrl.registerFocusCallback();
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(PluginWindowType.getWindowWidth(PluginWindowType.TYPE_LARGE)),
      height: LocalWindowManager.PC_SUPER_PRIVACY_PANEL_HEIGHT
    };
    this.superPrivacyPanelCtrl.updateArea(rect);
    this.superPrivacyPanelCtrl.updateRect(rect);
    this.initWindowPolicy();

    // Lock screen monitoring
    this.screenLockObserver = {
      notify: (): void => {
        log.info(TAG, `onLockScreen`);
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId);
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  onPageShow() {
    log.info(TAG, `onPageShow`);
  }

  onPageHide() {
    log.info(TAG, `onPageHide`);
  }

  private onViewShow(): void {
    log.debug(TAG, `onViewShow`);
    // The requestFocus has time sequence restrictions.
    // Ensure that the requested component is in the focus state when the requestFocus is invoked
    this.mTimeMeterOfSuperPrivacyPanel = setTimeout(() => {
      log.debug(TAG, `onViewShow runtask mTimeMeterOfSuperPrivacyPanel`);
      let res: boolean = focusControl.requestFocus(REQUEST_FOCUS_MENU + this.windowName);
      log.debug(TAG, `requestFocus res => ${res}`);
    }, 20);
    AppStorage.setOrCreate('deskTopFocused', false);
  }

  private onViewHide(): void {
    log.debug(TAG, `onViewHide`);
    if (this.mTimeMeterOfSuperPrivacyPanel) {
      clearTimeout(this.mTimeMeterOfSuperPrivacyPanel);
    }
    AppStorage.setOrCreate('deskTopFocused', true);
  }

  aboutToDisappear() {
    log.info(TAG, `aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(this.windowName);
    screenLockMediator.deleteObserver(this.screenLockObserver);
    this.superPrivacyPanelCtrl.unRegisterCallback(this.viewCallback);
    this.superPrivacyPanelCtrl.unRegisterFocusCallback();
    viewMgrPolicy.unregisterViewController(this.viewType);
  }

  build() {
    SuperPrivacyPanelView({
      baseViewController: this.superPrivacyPanelCtrl,
      windowName: this.windowName
    })
      .key(REQUEST_FOCUS_MENU + this.windowName)
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowStartShow()) {
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(this.windowName)) {
        this.hideWindow();
      }
    }
  }

  initWindowPolicy() {
    log.info(TAG, `init SuperPrivacy panel window Policy`);
    // 监听show/hide
    this.eventMgr.on(WindowEvent, (event: WindowEvent): void => {
      this.onWindowEvent(event)
    })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
        this.onScreenOnOffEvent(event)
      })
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.info(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.info(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }));
  }

  private doKeyEvent(keyEvent?: KeyEvent) {
    if ((keyEvent?.keyCode === MultiKeyCode.ESC || keyEvent?.keyCode === MultiKeyCode.BACK) &&
      keyEvent?.type === KeyType.Up) {
      this.hideWindow();
    }
  }

  private hideWindow() {
    if (!windowMgr.isShowing(this.windowName)) {
      return;
    }
    log.info(TAG, `hide anim start`);
    windowMgr.hideWindowWithAnim(this.windowName);
  }

  /**
   * 亮灭屏事件
   *
   * @param event 事件
   */
  private onScreenOnOffEvent(event: ScreenOnOffEvent): void {
    // 熄屏隐藏面板
    if (event.isScreenOff()) {
      // 提前隐藏弹框
      windowMgr.hideWindowImmediately(this.windowName);
    }
  }
}
