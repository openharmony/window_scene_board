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
  LogDomain,
  LogHelper,
  Trace,
  Observer,
} from '@ohos/basicutils';
import {
  PluginPosition,
  PluginSlot,
  PluginWindowType,
  WindowEvent,
  EvtBus,
  EventManager,
  ScreenOnOffEvent,
  viewMgrPolicy,
  ViewArea,
  ViewType,
  ViewCallback,
  WindowPositionChangeEvent,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import {
  windowMgr
} from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import StyleConfiguration, { CommonComponentStyle } from '../common/StyleConfiguration';
import InputMethodPanelComponent from './InputMethodPanelComponent';
import Constants, { InputMethodInfo, InputMethodSubtypeInfo } from '../common/Constants';

import ViewModel from '../viewmodel/InputMethodPanelViewModel';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import window from '@ohos.window';
import inputMethod from '@ohos.inputMethod';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { MultimodalInputManager, MultiKeyCode } from '@ohos/systemuicommon';
import { LocalWindowManager } from '@ohos/systemuicommon';
import StyleConstants from '../../../common/constants/StyleConstants';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { LengthMetricsUtil } from '@ohos/statusbarcomponent/src/main/ets/pc/common/LengthMetricsUtil';
import { componentUtils } from '@kit.ArkUI';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';
import InputMethodUtils from '@ohos/inputmethodcomponent/src/main/ets/default/common/InputMethodUtils';

const TAG = 'InputMethodPanel-Index';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_CENTER_TITLE = TAG + '_CenterTitle_Text_title';

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_INPUT_METHOD;

const COMPONENT_INPUTMETHOD_PANEL = 'COMPONENT_INPUTMETHOD_PANEL';

@Component
export struct SCBInputMethodPanel {
  mTimeMeterOfInputMethod: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenLockObserver: Observer = {
    notify: (): void => {
    }
  };
  private viewCallback: ViewCallback = {
    onShow: () => this.onViewShow(),
    onHide: () => this.onViewHide()
  };
  @StorageLink('inputMethodList') mInputMethodList: Array<InputMethodInfo> = new Array();
  @State inputPanelCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.INPUT_METHOD_PANEL);
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @Provide persistentId: number = 0;
  @Provide pluginSlot: PluginSlot = PluginSlot.SLOT_STATUS_INPUT_METHOD;

  onLockScreen(): void {
    this.hideWindow();
  }

  /**
   * 刷新二级界面窗口大小
   */
  async updateInputMethodPanelWindow() {
    let defaultRect = windowMgr.getWindowPosition(WINDOW_NAME);
    let heightWin = defaultRect.height;

    let itemNum = this.mInputMethodList.length;
    heightWin = vp2px(56) + // center title
      itemNum * vp2px(40) + // list
      vp2px(2) * (itemNum - 1) + // margin
      vp2px(9) + // divider
      vp2px(40) + // setting
      vp2px(4); // bottom

    const isVoice: boolean = await this.isVoiceAbility();
    if (isVoice && !DeviceHelper.is2In1DevicePcType()) {
      let statusBarSettingHeight: number =
        componentUtils.getRectangleById('hide_input_method_status_bar_text')?.size?.height;
      if (!statusBarSettingHeight) {
        statusBarSettingHeight = vp2px(40);
      }
      heightWin = heightWin +
        vp2px(32) + // menu title
        statusBarSettingHeight + // input method status bar setting
        vp2px(8); // divider
    }

    let updateRect: window.Rect = {
      top: defaultRect.top,
      left: defaultRect.left,
      width: defaultRect.width,
      height: heightWin + StyleConstants.DEFAULT_BORDER_SIZE
    };
    log.showInfo(`[updateInputMethodPanelWindow]: updateRect: ${JSON.stringify(updateRect)}`);
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: WINDOW_NAME,
      position: PluginPosition.POSITION_RIGHT,
      area: updateRect
    });
  }

  private async isVoiceAbility(): Promise<boolean> {
    try {
      const currentIme: inputMethod.InputMethodProperty | null = await InputMethodUtils.queryCurrentInputMethod();
      return currentIme?.name === 'com.ohos.inputmethod';
    } catch (error) {
      log.showError(`getCurrentInputMethod fail, error: ${error}`);
      return false;
    }
  }

  initWindowPolicy() {
    log.showInfo(`init InputMethod panel window Policy`);
    // 监听show/hide
    this.eventMgr.on(WindowEvent, (event) => this.onWindowEvent(event))
      .on(ScreenOnOffEvent, (event) => this.onScreenOnOffEvent(event))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
  }

  private onViewShow(): void {
    log.showDebug('onViewShow');
    /**
     * The requestFocus has time sequence restrictions.
     * Ensure that the requested component is in the
     * focus state when the requestFocus is invoked
     */
    this.mTimeMeterOfInputMethod = setTimeout(() => {
      log.showInfo(`onViewShow runtask mTimeMeterOfInputMethod`);
      let res: boolean = focusControl.requestFocus(Constants.REQUEST_FOCUS_MENU);
      log.showInfo(`requestFocus res => ${res}`);
    }, 20);
    ViewModel.updateState(true);
    AppStorage.setOrCreate('deskTopFocused', false);
  }

  private onViewHide(): void {
    log.showDebug('onViewHide');
    if (this.mTimeMeterOfInputMethod) {
      clearTimeout(this.mTimeMeterOfInputMethod);
    }
    ViewModel.updateState(false);
    AppStorage.setOrCreate('deskTopFocused', true);
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

  private doKeyEvent(keyEvent: KeyEvent) {
    if ((keyEvent.keyCode === MultiKeyCode.ESC || keyEvent.keyCode === MultiKeyCode.BACK) &&
      keyEvent.type === KeyType.Up) {
      this.hideWindow();
    }
  }

  private hideWindow(): void {
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

  onPageShow() {
    log.showInfo(`onPageShow`);
    Trace.end(WINDOW_NAME);
    ViewModel.updateState(true);
  }

  onPageHide() {
    log.showInfo(`onPageHide`);
    ViewModel.updateState(false);
  }

  aboutToAppear() {
    log.showInfo(`aboutToAppear, start`);
    ViewModel.registerUpdatePanelWindowListener(this);
    ViewModel.registerCommonEventChange();
    ViewModel.initViewModel();
    viewMgrPolicy.registerViewController(ViewType.INPUT_METHOD_PANEL, this.inputPanelCtrl);
    this.inputPanelCtrl.updateId(this.persistentId);
    this.inputPanelCtrl.registerCallback(this.viewCallback);
    this.inputPanelCtrl.registerFocusCallback();
    let rect: ViewArea = {
      left: 0,
      top: 0,
      width: PluginWindowType.getWindowWidth(PluginWindowType.TYPE_COMMON),
      height: vp2px(LocalWindowManager.PC_INPUT_PANEL_HEIGHT)
    };
    this.inputPanelCtrl.updateArea(rect);
    this.inputPanelCtrl.updateRect(rect);
    this.initWindowPolicy();

    // 锁屏监听
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo('onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
  }

  aboutToDisappear() {
    log.showInfo(`aboutToDisappear`);
    this.eventMgr.offAll();
    windowMgr.offTouchOutside(WINDOW_NAME);
    ViewModel.unregisterUpdatePanelWindowListener(this);
    ViewModel.unregisterCommonEventChange();
    screenLockMediator.deleteObserver(this.screenLockObserver);
    this.inputPanelCtrl.unRegisterCallback(this.viewCallback);
    this.inputPanelCtrl.unRegisterFocusCallback();
  }

  build() {
    Flex() {
      InputMethodPanel()
    }
    .id(COMPONENT_INPUTMETHOD_PANEL)
    .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
    .width(this.inputPanelCtrl.getArea().width - StyleConstants.DEFAULT_BORDER_SIZE)
    .height(this.inputPanelCtrl.getArea().height - StyleConstants.DEFAULT_BORDER_SIZE)
    .backgroundBrightnessInternal(this.colorModeViewData.statusBarPanelOption)
    .defaultFocus(true)
    .onKeyEvent((event?: KeyEvent) => {
      if (event) {
        this.doKeyEvent(event);
      }
    })
  }
}

@Component
struct InputMethodPanel {
  aboutToAppear() {
    log.showInfo(`aboutToAppear Start`);
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
      CenterTitle()
      Column() {
        InputMethodPanelComponent()
      }
    }
    .width('100%')
  }
}

@Component
struct CenterTitle {
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();

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
      Text($r('app.string.input_menu_title'))
        .draggable(false)
        .id(COMPONENT_ID_CENTER_TITLE)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .align(Alignment.Center)
        .fontSize(this.panelInfo?.titleTextSize)
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyHeiTi')
        .width(this.styleCommon.inputMethodPanelTextWidth)
        .height('100%')
        .margin({
          start: LengthMetricsUtil.Length2LengthMetrics(this.styleCommon.inputMethodPanelTitleMargin as Resource),
        })
    }
    .width('100%')
    .height(this.styleCommon.inputMethodPanelTitleHeight)
  }
}