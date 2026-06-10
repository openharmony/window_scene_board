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

import { Log, Observer, Trace } from '@ohos/basicutils';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import {
  PluginSlot,
  PluginWindowType,
  EvtBus,
  EventManager,
  viewMgrPolicy,
  ViewArea,
  ViewType,
  ScreenOnOffEvent,
  WindowEvent,
  ReportIntervalManager,
  reportIntervalMgr,
  ViewCallback,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { MultimodalInputManager, MultiKeyCode, } from '@ohos/systemuicommon';
import SystemPanelComponent from './SystemPanelComponent';
import StyleConfiguration, { CommonComponentStyle } from '../common/StyleConfiguration';
import mModel from '../model/SystemPanelModel';
import Constants from '../common/Constants';
import screenlock from '@ohos.screenLock';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import { BusinessError } from '@ohos.base';
import { StatusBarPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import StyleConstants from '../../../common/constants/StyleConstants';
import ScreenLockService from '../../screenlock/refactor/ScreenLockService';
import ctrlAltDelPanelModel from '../../ctrlaltdelpanel/model/CtrlAltDelPanelModel';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';

const TAG = 'SystemPanel-Index';
const SYSTEM_KEY = 'h1_systemUI_product_pc_systemPanel';

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_PERSONAL;

@Component
export struct SCBSystemPanel {
  @State systemPanelCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.SYSTEM_PANEL);
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Provide persistentId: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenLockObserver: Observer = {
    notify: (): void => {
    }
  };
  private viewCallback: ViewCallback = {
    onShow: (): void => this.onViewShow(),
    onHide: (): void => this.onViewHide()
  };
  mTimeMeterOfSystemPanel: number = 0;

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);
    viewMgrPolicy.registerViewController(ViewType.SYSTEM_PANEL, this.systemPanelCtrl);
    this.systemPanelCtrl.updateId(this.persistentId);
    this.systemPanelCtrl.registerCallback(this.viewCallback);
    this.systemPanelCtrl.registerFocusCallback();
    this.updateSceneRect();
    this.initWindowPolicy();

    // Lock screen monitoring
    this.screenLockObserver = {
      notify: (): void => {
        Log.showInfo(TAG, 'onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
    this.eventMgr.offAll();
    this.systemPanelCtrl.unRegisterCallback(this.viewCallback);
    this.systemPanelCtrl.unRegisterFocusCallback();
    screenLockMediator.deleteObserver(this.screenLockObserver);
  }

  private onViewShow(): void {
    Log.showDebug(TAG, 'onViewShow');
    /**
     * The requestFocus has time sequence restrictions.
     * Ensure that the requested component is in the focus
     * state when the requestFocus is invoked
     */
    this.mTimeMeterOfSystemPanel = setTimeout(() => {
      Log.showInfo(TAG, `onViewShow runtask mTimeMeterOfSystemPanel`);
      let res: boolean = focusControl.requestFocus(Constants.REQUEST_FOCUS_MENU);
      Log.showInfo(TAG, `requestFocus res => ${res}`);
    }, 20);
    AppStorage.setOrCreate('deskTopFocused', false);
  }

  private onViewHide(): void {
    Log.showDebug(TAG, 'onViewHide');
    if (this.mTimeMeterOfSystemPanel) {
      clearTimeout(this.mTimeMeterOfSystemPanel);
    }
    mModel.updateState(false);
    AppStorage.setOrCreate('deskTopFocused', true);
  }

  /**
   * 窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    Log.showInfo(TAG, `onWindowEvent ${event.eventType} ${event.windowName}`);
    if (event.isWindowStartShow()) {
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(WINDOW_NAME)) {
        this.hideWindow();
      } else {
        mModel.updateState(true);
      }
    }
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
      windowMgr.hideWindowImmediately(WINDOW_NAME);
    }
  }

  private hideWindow(): void {
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      return;
    }
    Log.showInfo(TAG, `hide anim start`);
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
  }

  private doKeyEvent(keyEvent: KeyEvent) {
    if ((keyEvent.keyCode === MultiKeyCode.ESC || keyEvent.keyCode === MultiKeyCode.BACK) &&
      keyEvent.type === KeyType.Up) {
      this.hideWindow();
    }
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  onPageShow() {
    Log.showInfo(TAG, `onPageShow`);
    Trace.end(WINDOW_NAME);
  }

  onPageHide() {
    Log.showInfo(TAG, `onPageHide`);
    mModel.updateState(false);
  }

  private updateSceneRect(): void {
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(PluginWindowType.getWindowWidth(PluginWindowType.TYPE_SMALL)) +
      StyleConstants.DEFAULT_BORDER_SIZE,
      height: this.getWindowHeight(),
    };
    this.systemPanelCtrl.updateArea(rect);
    this.systemPanelCtrl.updateRect(rect);
  }

  private initWindowPolicy() {
    Log.showInfo(TAG, `init System panel window Policy`);
    // 监听窗口show/hide
    this.eventMgr.on(WindowEvent, (event: WindowEvent): void => this.onWindowEvent(event))
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => this.onScreenOnOffEvent(event))

    this.eventMgr.addOff(MultimodalInputManager
      .subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.L], true, (data) => {
        AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
        if (ctrlAltDelPanelModel?.checkCtrlAltDelPanelShow()) {
          Log.showInfo(TAG, 'ctrlAltDel Panel Show');
          return;
        }
        if (ScreenLockService.getLock()) {
          return;
        }
        screenLockMediator.doScreenLockWithLocalCallback(() => {
          Log.showInfo(TAG, 'lockScreen success');
          AppStorage.setOrCreate('isLock', true);
        });
        reportIntervalMgr.addEventCount(ReportIntervalManager.LOGO_L);
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }));
    this.eventMgr.addOff(MultimodalInputManager
      .subscribeCombinationKey([MultiKeyCode.WIN_RIGHT, MultiKeyCode.L], true, (data) => {
        AppStorage.setOrCreate('isShortcutKeyPanelShow', false);
        if (ctrlAltDelPanelModel?.checkCtrlAltDelPanelShow()) {
          Log.showInfo(TAG, 'ctrlAltDel Panel Show');
          return;
        }
        if (ScreenLockService.getLock()) {
          return;
        }
        screenLockMediator.doScreenLockWithLocalCallback(() => {
          Log.showInfo(TAG, 'lockScreen success');
          AppStorage.setOrCreate('isLock', true);
        });
        reportIntervalMgr.addEventCount(ReportIntervalManager.LOGO_L);
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN_RIGHT, MultiKeyCode.C], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN_RIGHT, MultiKeyCode.N], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }));
  }

  private getWindowHeight(): number {
    if (DeviceHelper.isEmulator()) {
      return Constants.EMULATOR_SYSTEM_PANEL_HEIGHT;
    } else if (DeviceHelper.isHAD()) {
      return Constants.HAD_SYSTEM_PANEL_HEIGHT;
    }
    return Constants.DEFAULT_SYSTEM_PANEL_HEIGHT;
  }

  build() {
    Flex() {
      Stack() {
        Column() {
          SystemPanel()
        }
        .width(Constants.WINDOW_WIDTH)
        .defaultFocus(true)
        .onKeyEvent((event?: KeyEvent) => {
          if (event) {
            this.doKeyEvent(event);
          }
        })
      }
      .key(SYSTEM_KEY)
      .width(Constants.WINDOW_WIDTH)
      .clip(true)
      .borderRadius(this.panelInfo?.panelRadius)
    }
    .backgroundBrightnessInternal(this.colorModeViewData.statusBarPanelOption)
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
    .width(this.systemPanelCtrl.getArea().width - StyleConstants.DEFAULT_BORDER_SIZE)
    .height(this.systemPanelCtrl.getArea().height - StyleConstants.DEFAULT_BORDER_SIZE)
  }
}

@Component
struct SystemPanel {
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
  }

  build() {
    SystemPanelComponent()
  }
}
