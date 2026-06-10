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

import { MultimodalInputManager, MultiKeyCode, LocalWindowManager } from '@ohos/systemuicommon';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import {
  LogDomain,
  LogHelper,
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
import {
  NormalPanelInfo,
  StatusBarPanelInfo,
  StatusBarPanelManager
} from '../../../common/manager/StatusBarPanelManager';
import StyleConfiguration, { CommonComponentStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import MicrophonePanelViewModel, { CurrentMicrophoneMuteStatusForUIListener } from '../viewmodel/MicrophonePanelViewModel';
import MicrophonePanelComponent from './MicrophonePanelComponent';
import MicrophonePanelModel from '../model/MicrophonePanelModel';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';

const TAG = 'MicrophonePanel-Index';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_TITLE = TAG + '_text_microphoneMenuTitle';
const COMPONENT_ID_TOGGLE = TAG + '_toggle_microphoneToggle';
const MICROPHONE_KEY = 'h1_systemUI_product_pc_microphonePanel';

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_MICROPHONE_PANEL;

@Component
export struct SCBMicrophonePanel {
  @Provide mWidth: number = Constants.WINDOW_WIDTH;
  @Provide mHeight: number = Constants.WINDOW_HEIGHT;
  @State microphonePanelCtrl: PcStbSecondaryPanelController =
    new PcStbSecondaryPanelController(ViewType.MICROPHONE_PANEL); // 注册事件
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
  mTimeMeterOfSoundPanel: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear() {
    log.showInfo(`${TAG} aboutToAppear, start`);
    viewMgrPolicy.registerViewController(ViewType.MICROPHONE_PANEL, this.microphonePanelCtrl);
    this.microphonePanelCtrl.updateId(this.persistentId);
    this.microphonePanelCtrl.registerCallback(this.viewCallback);
    this.microphonePanelCtrl.registerFocusCallback();
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(PluginWindowType.getWindowWidth(PluginWindowType.TYPE_COMMON)),
      height: LocalWindowManager.PC_SOUND_PANEL_HEIGHT
    };
    this.microphonePanelCtrl.updateArea(rect);
    this.microphonePanelCtrl.updateRect(rect);
    this.initWindowPolicy();

    // Lock screen monitoring
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo(`${TAG} onLockScreen`);
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
    log.showInfo(`${TAG} onPageShow`);
    Trace.end(WINDOW_NAME);
  }

  onPageHide() {
    log.showInfo(`${TAG} onPageHide`);
  }

  private onViewShow(): void {
    log.showDebug(`${TAG} onViewShow`);
    MicrophonePanelModel.refreshAllStatusInfo();
    MicrophonePanelViewModel.refreshStateChange(true);
    // The requestFocus has time sequence restrictions.
    // Ensure that the requested component is in the focus state when the requestFocus is invoked
    this.mTimeMeterOfSoundPanel = setTimeout(() => {
      log.showDebug(`${TAG} onViewShow runtask mTimeMeterOfSoundPanel`);
      let res: boolean = focusControl.requestFocus(Constants.REQUEST_FOCUS_MENU);
      log.showDebug(`${TAG} requestFocus res => ${res}`);
    }, 20);
    AppStorage.setOrCreate('deskTopFocused', false);
  }

  private onViewHide(): void {
    log.showDebug(`${TAG} onViewHide`);
    if (this.mTimeMeterOfSoundPanel) {
      clearTimeout(this.mTimeMeterOfSoundPanel);
    }
    MicrophonePanelViewModel.refreshStateChange(false);
    AppStorage.setOrCreate('deskTopFocused', true);
  }

  aboutToDisappear() {
    log.showInfo(`${TAG} aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    screenLockMediator.deleteObserver(this.screenLockObserver);
    this.microphonePanelCtrl.unRegisterCallback(this.viewCallback);
    this.microphonePanelCtrl.unRegisterFocusCallback();
  }

  build() {
    Flex() {
      Stack() {
        Column() {
          MicrophonePanel()
        }
        .width(this.mWidth)
        .height(this.mHeight)
        .defaultFocus(true)
        .onKeyEvent((event?: KeyEvent) => {
          this.doKeyEvent(event);
        })
      }
      .key(MICROPHONE_KEY)
      .width(this.mWidth)
      .height(this.mHeight)
      .clip(true)
      .borderRadius(this.panelInfo?.panelRadius)
    }
    .backgroundBrightnessInternal(this.colorModeViewData.statusBarPanelOption)
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
    .width(this.mWidth)
    .height(this.mHeight)
    .shadow(ShadowStyle.OUTER_DEFAULT_MD)
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
      if (!event.isMatchName(WINDOW_NAME)) {
        this.hideWindow();
      }
    }
  }

  initWindowPolicy() {
    log.showInfo(`${TAG} init Sound panel window Policy`);
    // 监听show/hide
    this.eventMgr.on(WindowEvent, (event: WindowEvent): void => {
      this.onWindowEvent(event)
    })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
        this.onScreenOnOffEvent(event)
      })
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
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
    if (!windowMgr.isShowing(WINDOW_NAME)) {
      return;
    }
    log.showInfo(`${TAG} hide anim start`);
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
struct MicrophonePanel {
  aboutToAppear() {
    log.showInfo(`${TAG} aboutToAppear Start`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      CenterTitle()
      Column() {
        MicrophonePanelComponent()
      }
      .flexGrow(1)
    }
    .width(Constants.CARD_WIDTH)
  }
}

@Component
struct CenterTitle {
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume persistentId: number;
  @StorageLink('MicrophonePanelCurrentEnable') isMicrophoneEnable: boolean = true;

  aboutToAppear() {
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    log.showInfo(`${TAG} CenterTitle, aboutToAppear`);
    MicrophonePanelViewModel
      .registerCurrentMicrophoneMuteStatusForUIListener(this.currentMicrophoneMuteStatusForUIListener);
    this.isMicrophoneEnable = !MicrophonePanelViewModel.getCurrentMicrophoneMuteStatus();
  }

  aboutToDisappear() {
    log.showInfo(`${TAG} CenterTitle, aboutToDisappear`);
    MicrophonePanelViewModel
      .unregisterCurrentMicrophoneMuteStatusForUIListener(this.currentMicrophoneMuteStatusForUIListener);
  }

  // 麦克风静音UI参数变更的监听回调
  private currentMicrophoneMuteStatusForUIListener: CurrentMicrophoneMuteStatusForUIListener = {
    onCurrentMicrophoneMuteStatusForUI: (isMute: boolean) => {
      this.isMicrophoneEnable = !isMute;
    }
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.microphone'))
        .draggable(false)
        .id(COMPONENT_ID_TITLE)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .fontSize(this.panelInfo?.titleTextSize)
        .fontWeight(FontWeight.Bold)
        .margin({
          left: this.styleCommon.panelTitleMargin,
          right: this.styleCommon.panelTitleMargin
        })
        .height(this.styleCommon.panelTitleTextHeight)

      Blank();

      Toggle({ type: ToggleType.Switch, isOn: this.isMicrophoneEnable })
        .key(COMPONENT_ID_TOGGLE)
        .hoverEffect(HoverEffect.None)
        .height(this.styleCommon.panelTitleToggleHeight)
        .margin({
          left: this.styleCommon.panelTitleMargin,
          right: this.styleCommon.panelTitleMargin
        })
        .onChange((isOn) => {
          log.showInfo(`${TAG} microphone toggle change: ${isOn}`);
          if (isOn !== this.isMicrophoneEnable) {
            log.showInfo(`${TAG} set microphone mute: ${!isOn}`);
            MicrophonePanelViewModel.setMicrophoneMute(!isOn, TAG);
          }
        })
    }
    .width(Constants.CARD_WIDTH)
    .height(this.styleCommon.panelTitleHeight) // 56
  }
}
