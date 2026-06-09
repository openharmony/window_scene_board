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

import { LocalWindowManager, MultiKeyCode, MultimodalInputManager } from '@ohos/systemuicommon';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import {
  LogDomain,
  LogHelper,
  Observer,
  Trace,
} from '@ohos/basicutils';
import {
  EventManager,
  EvtBus,
  PluginSlot,
  PluginWindowType,
  ScreenOnOffEvent,
  ViewArea,
  ViewCallback,
  viewMgrPolicy,
  ViewType,
  WindowEvent,
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import SoundPanelComponent from './SoundPanelComponent';
import StyleConfiguration, { CommonComponentStyle } from '../common/StyleConfiguration';
import Constants from '../common/Constants';
import {
  NormalPanelInfo,
  StatusBarPanelInfo,
  StatusBarPanelManager
} from '../../../common/manager/StatusBarPanelManager';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import {
  ExtendedScreenDialogController
} from '../../../SystemDialog/ExtendedScreenDialog/controller/ExtendedScreenDialogController';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';
import { PanelManager } from '../manager/PanelManager';

const TAG = 'SoundPanel-Index';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_TITLE = TAG + '_Text_soundMenuTitle';
const SOUND_KEY = 'h1_systemUI_product_pc_soundPanel';

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_SOUND_PANEL;

@Component
export struct SCBSoundPanel {
  @StorageLink('systemLanguage') @Watch('onLanguageChange') language: string = '';
  @Provide mWidth: number = Constants.WINDOW_WIDTH;
  @Provide mHeight: number = Constants.WINDOW_HEIGHT;
  @State soundPanelCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.SOUND_PANEL);
  @Provide persistentId: number = 0;
  @State panelInfo: StatusBarPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  private screenLockObserver: Observer = {
    notify: (): void => {
    }
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
  private extendedScreenDialogController: ExtendedScreenDialogController = ExtendedScreenDialogController.getInstance();

  private onLanguageChange(): void {
    ExtendedScreenDialogController.getInstance().rePublishNotification();
    PanelManager.getInstance().onLanguageChange();
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, start`);
    viewMgrPolicy.registerViewController(ViewType.SOUND_PANEL, this.soundPanelCtrl);
    this.soundPanelCtrl.updateId(this.persistentId);
    this.soundPanelCtrl.registerCallback(this.viewCallback);
    this.soundPanelCtrl.registerFocusCallback();
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: px2vp(PluginWindowType.getWindowWidth(PluginWindowType.TYPE_COMMON)),
      height: LocalWindowManager.PC_SOUND_PANEL_HEIGHT
    };
    this.soundPanelCtrl.updateArea(rect);
    this.soundPanelCtrl.updateRect(rect);
    this.initWindowPolicy();

    // Lock screen monitoring
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo('onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId);

    PanelManager.getInstance().init();
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  onPageShow() {
    log.showInfo(`onPageShow`);
    Trace.end(WINDOW_NAME);
  }

  onPageHide() {
    log.showInfo(`onPageHide`);
  }

  private onViewShow(): void {
    log.showDebug('onViewShow');
    // The requestFocus has time sequence restrictions.
    // Ensure that the requested component is in the focus state when the requestFocus is invoked
    this.mTimeMeterOfSoundPanel = setTimeout(() => {
      log.showDebug(`onViewShow runtask mTimeMeterOfSoundPanel`);
      let res: boolean = focusControl.requestFocus(Constants.REQUEST_FOCUS_MENU);
      log.showDebug(`requestFocus res => ${res}`);
    }, 20);
    AppStorage.setOrCreate('deskTopFocused', false);
    PanelManager.getInstance().onPageShow();
  }

  private onViewHide(): void {
    log.showDebug('onViewHide');
    if (this.mTimeMeterOfSoundPanel) {
      clearTimeout(this.mTimeMeterOfSoundPanel);
    }
    AppStorage.setOrCreate('deskTopFocused', true);
    PanelManager.getInstance().onPageHide();
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    screenLockMediator.deleteObserver(this.screenLockObserver);
    this.soundPanelCtrl.unRegisterCallback(this.viewCallback);
    this.soundPanelCtrl.unRegisterFocusCallback();

    PanelManager.getInstance().destroy();
  }

  build() {
    Flex() {
      Stack() {
        Column() {
          SoundPanel()
        }
        .width(this.mWidth)
        .height(this.mHeight)
        .defaultFocus(true)
        .onKeyEvent((event?: KeyEvent) => {
          this.doKeyEvent(event);
        })
      }
      .key(SOUND_KEY)
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
    log.showInfo(`init Sound panel window Policy`);
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
    log.showInfo(`hide anim start`);
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
struct SoundPanel {
  aboutToAppear() {
    log.showInfo(`aboutToAppear Start`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, justifyContent: FlexAlign.Center }) {
      CenterTitle()
      Column() {
        SoundPanelComponent()
      }
      .flexGrow(1)
    }
    .width('100%')
  }
}

@Component
struct CenterTitle {
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Consume persistentId: number;

  aboutToAppear() {
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    log.showInfo(`CenterTitle, aboutToAppear`);
  }

  aboutToDisappear() {
    log.showInfo(`CenterTitle, aboutToDisappear`);
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text($r('app.string.sound_menu_title'))
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
        .height(this.styleCommon.panelTitleHeight)
    }
    .width('100%')
    .height(this.styleCommon.panelTitleHeight) // 56
  }
}
