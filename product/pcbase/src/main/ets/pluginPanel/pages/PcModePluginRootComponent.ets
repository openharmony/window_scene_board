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
  Log,
  Trace,
  CommonUtils,
  Observer, LogHelper, LogDomain,
} from '@ohos/basicutils';
import {
  ScreenOnOffEvent,
  RequestWindowEvent,
  EvtBus,
  EventManager,
  PluginInfo,
  WindowEvent,
  viewMgrPolicy,
  ViewArea,
  GlobalContext,
  SettingsUtil,
  sEventManager,
  obtainLocalEvent,
  PluginPosition,
  HideWindowPanelEvent
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { MultimodalInputManager, MultiKeyCode } from '@ohos/systemuicommon';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import screenLockMediator from '../../SceneBoard/screenlock/refactor/ScreenLockMediator';
import StyleConstants from '../../common/constants/StyleConstants';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper';
import { PluginSlot } from '@ohos/frameworkwrapper';
import window from '@ohos.window';
import { PcModeComponent } from './PcModeComponent';
import { settings } from '@kit.BasicServicesKit';
import { PluginDisplayStyle } from '@ohos/statusbarcomponent/src/main/ets/pc/common/PluginConstants';
import { PcStbSecondaryPanelController } from '../controller/PcStbSecondaryPanelController';

const TAG = 'PcModePluginRootComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
const STATUS_BAR_TYPE = 'settings_in_status_bar_type';
const LOCAL_EVENT_TYPE: string = 'local';

/**
 * AbilityComponent组件根布局
 *
 */

@Component
export struct PcModePluginRootComponent {
  /**
   * 窗口名
   */
  @State pluginSlot: string = '';
  /**
   * AbilityComponent组件包名
   */
  @State pluginBundleName: string = '';
  /**
   * AbilityComponent组件ability名
   */
  @State pluginAbilityName: string = '';
  @State @Watch('onViewDataChange') pluginPanelCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(this.pluginSlot);
  @State isShowing: boolean = false;
  private persistentId: number = 0;
  private pluginInfo: PluginInfo | null = null;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenLockObserver: Observer | null = null;
  private hideWindowPanelEvent = (event: HideWindowPanelEvent): void => {
    this.hideWindow();
  }

  aboutToAppear(): void {
    if (CommonUtils.isInvalid(this.pluginInfo)) {
      log.showWarn('pluginInfo invalid');
      return;
    }
    log.showDebug('bundleName:%{public}s,pluginSlot:%{public}s', this.pluginInfo?.pluginParseInfo.bundleName, this.pluginInfo?.pluginParseInfo.pluginSlot)
    let pluginParseInfo = this.pluginInfo?.pluginParseInfo;
    this.pluginSlot = pluginParseInfo?.pluginSlot || '';
    if (CommonUtils.isEmpty(this.pluginSlot)) {
      log.showWarn('pluginSlot invalid');
      return;
    }
    this.pluginPanelCtrl = new PcStbSecondaryPanelController(this.pluginSlot);
    viewMgrPolicy.registerViewController(this.pluginSlot, this.pluginPanelCtrl);
    this.pluginPanelCtrl.updateId(this.persistentId);
    this.pluginPanelCtrl.registerFocusCallback();
    let clickInfo = pluginParseInfo?.clickInfo;
    let bundleName = pluginParseInfo?.bundleName || '';
    let abilityName = clickInfo?.abilityName || '';
    if (CommonUtils.isEmpty(abilityName) || CommonUtils.isEmpty(bundleName)) {
      log.showWarn('abilityName or bundleName invalid');
      return;
    }
    this.pluginBundleName = bundleName;
    this.pluginAbilityName = abilityName;
    this.statusBarTypeChange();
    this.initWindowPolicy();
    this.eventMgr.on(HideWindowPanelEvent, this.hideWindowPanelEvent)
    statusbarPlCtrl.registerPanelName(this.pluginSlot);
    // Lock screen monitoring
    this.screenLockObserver = {
      notify: (): void => {
        log.showInfo('onLockScreen');
        this.hideWindow();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
  }

  initWindowPosition(height?: number): void {
    let windowHeight = height || 0;
    let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    let rect: ViewArea = {
      left: controlCenterPosition.left,
      top: controlCenterPosition.top,
      width: controlCenterPosition.width,
      height: windowHeight,
    };
    this.pluginPanelCtrl.updateArea(rect);
    this.pluginPanelCtrl.updateRect(rect);
    let position: Position = {x: rect.left, y: 0};
    let winIconArea : Area = {
      width: rect.width,
      height: vp2px(rect.height),
      position: position,
      globalPosition: position,
    };
    windowMgr.setStatusIconCaches(this.pluginSlot, winIconArea);
    let area: window.Rect = {
      left: rect.left,
      top: rect.top,
      width: rect.width,
      height: vp2px(rect.height)
    }
    log.showWarn('initWindowPosition, pluginSlot:' + this.pluginSlot + ' area, left:' + area.left + ' top:' +
      area.top + ' width:' + area.width + ' height:' + area.height + ' globalPos: ' + position.x);
    EvtBus.post(WindowPositionChangeEvent,
      { windowName: this.pluginSlot,
        position: PluginPosition.POSITION_NONE,
        area: area,
        caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER });
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll();
    settings.unregisterKeyObserver(GlobalContext.getContext(), STATUS_BAR_TYPE, settings.domainName.USER_SECURITY);
    this.pluginPanelCtrl.unRegisterFocusCallback();
    screenLockMediator.deleteObserver(this.screenLockObserver);
  }
  /*
  ** 用于初次加载时二级窗口的启动加载，后续窗口缓存下来，不再退出并重新加载，可能会消耗一些缓存
   */
  onViewDataChange() {
    if (this.isShowing === true) {
      return;
    }
    log.showInfo(`onViewDataChange this.pluginPanelCtrl.isShowing() = ${this.pluginPanelCtrl.isShowing()}`);
    this.isShowing = this.pluginPanelCtrl.isShowing();
  }

  private onRequestWindowEvent(event: RequestWindowEvent) {
    if (event.windowName === null && event.requestType === RequestWindowEvent.REQUEST_HIDE) {
      if (!windowMgr.isShowing(this.pluginSlot)) {
        return;
      }
      if (event.hasWindowAnim) {
        windowMgr.hideWindowWithAnim(this.pluginSlot);
      } else {
        windowMgr.hideWindowImmediately(this.pluginSlot);
      }
    }
  }

  onPageShow() {
    log.showInfo('ability onPageShow');
    Trace.end(this.pluginSlot);
  }

  /**
   * 关闭弹窗
   */
  private hideWindow(): void {
    if (!windowMgr.isShowing(this.pluginSlot)) {
      return;
    }
    windowMgr.hideWindowWithAnim(this.pluginSlot);
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
      windowMgr.hideWindowImmediately(this.pluginSlot);
    }
  }

  /**
   * 初始化
   */
  private initWindowPolicy(): void {
    log.showInfo(`init ${this.pluginSlot} window Policy`);
    // 监听窗口事件
    this.eventMgr.on(WindowEvent, (event) => this.onWindowEvent(event))
      .on(ScreenOnOffEvent, (event) => this.onScreenOnOffEvent(event))
      .on(RequestWindowEvent, (event) => this.onRequestWindowEvent(event))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        log.showInfo(`on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        log.showInfo(`on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }));
  }

  /**
   * 监听窗口show/hide事件
   *
   * @param event 事件
   */
  private onWindowEvent(event: WindowEvent): void {
    // 非当前窗口，如果是开始展示则隐藏
    if (event.isWindowStartShow()) {
      log.showInfo(`onWindowEvent ability: ${this.pluginSlot}, event type is ${event.eventType}`);
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(this.pluginSlot)) {
        this.hideWindow();
      } else {
        // pc点击文字弹出二级窗口，并关闭控制中心面板
        sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, false));
        windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
        // 设置二级页面窗口位置
        let position = windowMgr.getWindowPosition(this.pluginSlot);
        let controlCenterPosition = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
        let pos: Position = {x: controlCenterPosition.left, y: 0};
        let winIconArea : Area = {
          width: position.width,
          height: position.height,
          position: pos,
          globalPosition: pos,
        };
        windowMgr.setStatusIconCaches(this.pluginSlot, winIconArea);
        position.left = controlCenterPosition.left;
        position.width = controlCenterPosition.width;
        position.top = controlCenterPosition.top;
        EvtBus.post(WindowPositionChangeEvent, {
          windowName: this.pluginSlot,
          position: PluginPosition.POSITION_NONE,
          area: position,
          caller: PluginSlot.SLOT_STATUS_CONTROL_CENTER
        });
        let info = AppStorage.get<PluginInfo>(this.pluginSlot + '_info');
        windowMgr.setWindowData(this.pluginSlot, info);
        sEventManager.publish(obtainLocalEvent(LOCAL_EVENT_TYPE, true));
      }
    }
  }

  private statusBarTypeChange(): void {
    try {
      let pluginParseInfo = this.pluginInfo?.pluginParseInfo;
      let clickInfo = pluginParseInfo?.clickInfo;
      this.initWindowPosition(clickInfo?.windowHeight)
      windowMgr.updateWindowAnimPivot(this.pluginSlot, 1.0, 1.0);
    } catch (error) {
      log.showError(`read statusBarType Error: ${error}`)
    }
  }


  build() {
    PcModeComponent({
      pluginBundleName: this.pluginBundleName,
      pluginAbilityName: this.pluginAbilityName,
      pluginSlot: this.pluginSlot,
      isShowing: this.pluginPanelCtrl.isShowing(),
      clickInfo: this.pluginInfo?.pluginParseInfo.clickInfo,
    })
      .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
      .width(this.pluginPanelCtrl.getArea().width - StyleConstants.DEFAULT_BORDER_SIZE)
      .height(this.pluginPanelCtrl.getArea().height - StyleConstants.DEFAULT_BORDER_SIZE)
      .clip(true)
  }
}