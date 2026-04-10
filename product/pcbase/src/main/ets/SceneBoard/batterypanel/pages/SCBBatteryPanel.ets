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
  Log,
  Observer,
  Trace,
} from '@ohos/basicutils';
import {
  viewMgrPolicy,
  ViewArea,
  ViewType,
  PluginSlot,
  EvtBus,
  EventManager,
  WindowEvent,
  ScreenOnOffEvent,
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { MultimodalInputManager, MultiKeyCode, } from '@ohos/systemuicommon';
import BatteryPanelComponent from './BatteryPanelComponent';
import StyleConfiguration, { CommonComponentStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import { LocalWindowManager } from '@ohos/systemuicommon';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import {
  NormalPanelInfo,
  StatusBarPanelInfo,
  StatusBarPanelManager
} from '../../../common/manager/StatusBarPanelManager';
import {
  ColorModeViewData,
  ColorModeViewModel
} from '@ohos/systemuicommon/Index';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';

const TAG = 'BatteryPanel-Index';
const BATTERY_KEY = 'h1_systemUI_product_pc_batteryPanel';

/**
 * 窗口名称
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_BATTERY_PANEL;

@Component
export struct SCBBatteryPanel {
  @Provide mWidth: number = Constants.WINDOW_WIDTH;
  @Provide mHeight: number = Constants.WINDOW_HEIGHT;
  private screenLockObserver: Observer | null = null;

  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  @State batteryPanelCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.BATTERY_PANEL);
  @Provide persistentId: number = 0;
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear, start`);
    viewMgrPolicy.registerViewController(ViewType.BATTERY_PANEL, this.batteryPanelCtrl);
    this.batteryPanelCtrl.updateId(this.persistentId);
    this.batteryPanelCtrl.registerFocusCallback();
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: LocalWindowManager.PC_BATTERY_PANEL_WIDTH,
      height: LocalWindowManager.PC_BATTERY_PANEL_HEIGHT
    };
    this.batteryPanelCtrl.updateArea(rect);
    this.batteryPanelCtrl.updateRect(rect);
    this.initWindowPolicy();
    // 窗口动画绑定onFrame
    windowMgr.startBindWinAnimOnFrame(WINDOW_NAME);

    // 锁屏监听
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

  onLockScreen(): void {
    this.hideWindow();
  }

  onPageShow() {
    Log.showInfo(TAG, `onPageShow`);
    Trace.end(WINDOW_NAME);
  }

  onPageHide() {
    Log.showInfo(TAG, `onPageHide`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    if (this.screenLockObserver) {
      screenLockMediator.deleteObserver(this.screenLockObserver);
    }
    this.batteryPanelCtrl.unRegisterFocusCallback();
  }

  build() {
    Flex() {
      Stack() {
        Column() {
          BatteryPanel()
        }
        .width(this.mWidth)
        .height(this.mHeight)
      }
      .key(BATTERY_KEY)
      .width(this.mWidth)
      .height(this.mHeight)
      .clip(true)
      .borderRadius(this.panelInfo?.panelRadius)
    }
    .defaultFocus(true)
    .onKeyEvent((keyEvent: KeyEvent) => {
      if ((keyEvent.keyCode === MultiKeyCode.ESC || keyEvent.keyCode === MultiKeyCode.BACK) &&
        keyEvent.type === KeyType.Up) {
        this.hideWindow();
      }
    })
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
    .width(this.mWidth)
    .height(this.mHeight)
  }

  /**
   * 窗口show/hide事件回调
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    if (event.isWindowStartShow()) {
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(WINDOW_NAME)) {
        this.hideWindow();
      }
    }
  }

  private initWindowPolicy() {
    Log.showInfo(TAG, `init Battery panel window Policy`);
    // 窗口show/hide事件
    this.eventMgr.on(WindowEvent, (event: WindowEvent) => {
      this.onWindowEvent(event)
    })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent) => {
        this.onScreenOnOffEvent(event)
      })
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
  }

  private hideWindow(): void {
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      return;
    }
    Log.showInfo(TAG, `hide anim start`);
    windowMgr.hideWindowWithAnim(WINDOW_NAME);
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
}

@Component
struct BatteryPanel {
  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear Start`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      CenterTitle()
      Column() {
        BatteryPanelComponent()
      }
      .flexGrow(1)
    }
    .width('100%')
  }
}

@Component
struct CenterTitle {
  @StorageLink('batterySoc') batterySoc: number = 100;
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @Consume persistentId: number;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

  aboutToAppear() {
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    Log.showInfo(TAG, `CenterTitle, aboutToAppear`);
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `CenterTitle, aboutToDisappear`);
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.battery_menu_title'))
        .draggable(false)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .fontSize(this.panelInfo?.titleTextSize)
        .fontWeight(FontWeight.Bold)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .margin({
          left: this.styleCommon.panelTitleMargin,
          right: this.styleCommon.panelTitleMargin,
          top: this.styleCommon.panelTitleMarginTop
        })
        .fontFamily('HarmonyHeiTi')
        .height(this.styleCommon.panelTitleTextHeight)
      Blank()
      Text(this.batterySoc + '%')
        .draggable(false)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontSize(this.panelInfo?.listTextSize)
        .fontWeight(FontWeight.Medium)
        .margin({
          left: this.styleCommon.panelTitleMargin,
          right: this.styleCommon.panelTitleMargin,
          top: this.styleCommon.panelTitleMarginTop
        })
        .fontFamily('HarmonyHeiTi')
        .height(this.styleCommon.panelTitleTextHeight)
    }
    .width('100%')
    .height(this.styleCommon.panelTitleHeight)
  }
}