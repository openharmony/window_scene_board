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

import { LogDomain, LogHelper, Trace, Observer, } from '@ohos/basicutils';
import {
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
  PluginPosition,
  DeviceHelper
} from '@ohos/frameworkwrapper';
import { SCBScreenProperty, windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import StyleConfiguration, { CommonComponentStyle } from '../common/StyleConfiguration';
import InputMethodPanelComponent from './InputMethodPanelComponent';
import Constants, { InputMethodInfo, InputMethodSubtypeInfo } from '../common/Constants';
import ViewModel from '../viewmodel/InputMethodPanelViewModel';
import screenLockMediator from '../../screenlock/refactor/ScreenLockMediator';
import window from '@ohos.window';
import { NormalPanelInfo, StatusBarPanelManager } from '../../../common/manager/StatusBarPanelManager';
import { MultimodalInputManager, MultiKeyCode, StatusBarType } from '@ohos/systemuicommon';
import { LocalWindowManager } from '@ohos/systemuicommon';
import StyleConstants from '../../../common/constants/StyleConstants';
import { ColorModeViewData, ColorModeViewModel } from '@ohos/systemuicommon/Index';
import { LengthMetricsUtil } from '@ohos/statusbarcomponent/src/main/ets/pc/common/LengthMetricsUtil';
import { PcStbSecondaryPanelController } from '../../../pluginPanel/controller/PcStbSecondaryPanelController';
import { display } from '@kit.ArkUI';
import { PcSmartDockStyleManager } from '@ohos/pcsmartdock/src/main/ets/default/common/PcSmartDockStyleManager';
import { PluginStyleUtil } from '@ohos/statusbarcomponent/src/main/ets/pc/common/PluginStyleUtil';
import { Constants as StatusbarConstants } from '@ohos/statusbarcomponent/src/main/ets/pc/common/Constants';

const TAG = 'InputMethodPanel-Index';
const log = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const COMPONENT_ID_CENTER_TITLE = TAG + '_CenterTitle_Text_title';

/**
 * 窗口名
 */
const WINDOW_NAME = PluginSlot.SLOT_STATUS_INPUT_PANEL;
const REQUEST_FOCUS_DELAY_TIME = 20;
const COMPONENT_INPUTMETHOD_SUBTYPE_PANEL = 'COMPONENT_INPUTMETHOD_SUBTYPE_PANEL';

@Component
export struct SCBInputMethodSubtypePanel {
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
  @StorageLink('languageList') mLanguageList: Array<InputMethodSubtypeInfo> = [];
  @State inputPanelCtrl: PcStbSecondaryPanelController =
    new PcStbSecondaryPanelController(ViewType.INPUT_METHOD_SUBTYPE_PANEL);
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @State currentItemNum: number | undefined = undefined;
  @Provide persistentId: number = 0;
  @Provide pluginSlot: PluginSlot = PluginSlot.SLOT_STATUS_INPUT_PANEL;
  @Link screenProp: SCBScreenProperty;

  onLockScreen(): void {
    this.hideWindow();
  }

  /**
   * 刷新二级界面窗口大小
   */
  updateInputMethodPanelWindow(itemNum?: number) {
    let defaultRect = windowMgr.getWindowPosition(WINDOW_NAME);
    let heightWin = this.getSubTypePanelWinHeightPx(defaultRect, itemNum);
    let updateRect: window.Rect = {
      top: defaultRect.top,
      left: defaultRect.left,
      width: defaultRect.width,
      height: heightWin + StyleConstants.DEFAULT_BORDER_SIZE
    };
    log.showInfo(`[updateInputMethodSubTypePanelWindow]: updateRect: ${JSON.stringify(updateRect)}`);
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: WINDOW_NAME,
      position: PluginPosition.POSITION_RIGHT,
      area: updateRect
    });
  }

  initWindowPolicy() {
    log.showInfo('init InputMethod panel window Policy');
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
      log.showDebug('onViewShow runtask mTimeMeterOfInputMethod');
      let res: boolean = focusControl.requestFocus(Constants.REQUEST_FOCUS_MENU);
      log.showInfo(`requestFocus res => ${res}`);
    }, REQUEST_FOCUS_DELAY_TIME);
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
    log.showInfo('hide anim start');
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

  private getSubTypePanelWinHeightPx(defaultRect: window.Rect, itemNum?: number): number {
    let winHeight = defaultRect.height;
    if (this.currentItemNum === undefined) {
      this.currentItemNum = this.mLanguageList.length;
    }
    if (itemNum !== undefined) {
      this.currentItemNum = itemNum;
    }
    winHeight = vp2px(56) + // center title
      this.currentItemNum * vp2px(40) + // list
      Math.floor(vp2px(2)) * (this.currentItemNum - 1) + // margin
    vp2px(4); // bottom
    const maxWinHeight: number = vp2px(this.getMaxWindowHeightVp());
    log.showInfo(`currentItemNum is ${this.currentItemNum}, \
    calcute window height is ${winHeight}, maxWinHeight is ${maxWinHeight}`);
    winHeight = winHeight < maxWinHeight ? winHeight : maxWinHeight;
    return winHeight;
  }

  private getMaxWindowHeightVp(): number {
    if (!this.screenProp?.height) {
      log.showError(`screenProp height error`);
      return 0;
    }
    const isWindowStyle: boolean = PluginStyleUtil.isWindowStyle();
    let maxHeight: number = 0;
    if (DeviceHelper.isFold()) {
      maxHeight = isWindowStyle ?
      LocalWindowManager.PC_HOPPER_WINDOWS_MAX_HEIGHT_WINDOW : LocalWindowManager.PC_HOPPER_WINDOWS_MAX_HEIGHT_MAC;
      log.showInfo(`fold machine maxHeight: ${maxHeight}`);
      return maxHeight;
    }
    const dockHeight = PcSmartDockStyleManager.getStyle(this.screenProp).mDockHeight;
    const statusbarHeight: number = viewMgrPolicy.getViewController(ViewType.STATUS_BAR)?.getArea().height ?? 0;
    maxHeight = px2vp(this.screenProp?.height) - dockHeight - statusbarHeight -
      StatusbarConstants.DEFAULT_DOCK_GAP * 2;
    log.showInfo(`screenPropHeight: ${this.screenProp?.height}, maxHeight: ${maxHeight}, dockHeight: ${dockHeight}, statusbarHeightPx: ${statusbarHeight}`);
    return maxHeight;
  }

  onPageShow() {
    log.showDebug('onPageShow');
    Trace.end(WINDOW_NAME);
    ViewModel.updateState(true);
  }

  onPageHide() {
    log.showInfo('onPageHide');
    ViewModel.updateState(false);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear, start');
    ViewModel.registerUpdatePanelWindowListener(this);
    ViewModel.registerCommonEventChange();
    ViewModel.initViewModel();
    viewMgrPolicy.registerViewController(ViewType.INPUT_METHOD_SUBTYPE_PANEL, this.inputPanelCtrl);
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
    log.showInfo('aboutToDisappear');
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
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        CenterTitle()
        Column() {
          InputMethodPanelComponent({
            updateInputMethodSubTypeNumber:
            (itemNum: number): void => this.updateInputMethodPanelWindow(itemNum)
          })
        }
      }
      .width('100%')
    }
    .id(COMPONENT_INPUTMETHOD_SUBTYPE_PANEL)
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
struct CenterTitle {
  @Consume persistentId: number;
  @State panelInfo: NormalPanelInfo | undefined = undefined;
  @State styleCommon: CommonComponentStyle = StyleConfiguration.getCommonComponentStyle();
  @State colorModeViewData: ColorModeViewData = ColorModeViewModel.getInstance().getViewData();
  @StorageLink('currentInputMethodTitle') mCurrentInputTitle: string = '';

  aboutToAppear() {
    this.panelInfo = StatusBarPanelManager.getInstance()
      .getStatusBarInfoById(this.persistentId) as NormalPanelInfo;
    log.showInfo('CenterTitle, aboutToAppear');
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      Text(this.mCurrentInputTitle)
        .draggable(false)
        .id(COMPONENT_ID_CENTER_TITLE)
        .fontColor(this.colorModeViewData.wifiOffTextColor)
        .foregroundBrightness(this.colorModeViewData.foregroundPrimaryOption)
        .align(Alignment.Center)
        .fontSize(this.panelInfo?.titleTextSize)
        .fontWeight(FontWeight.Bold)
        .fontFamily('HarmonyHeiTi')
        .height('100%')
        .margin({
          start: LengthMetricsUtil.Length2LengthMetrics(this.styleCommon.inputMethodPanelTitleMargin),
        })
    }
    .width('100%')
    .height(this.styleCommon.inputMethodPanelTitleHeight)
  }
}