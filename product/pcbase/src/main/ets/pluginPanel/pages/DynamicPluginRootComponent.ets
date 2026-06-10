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

import { RemoteAbilityComponent } from '@ohos/plugincomponent/src/main/ets/pages/RemoteAbilityComponent';
import { Log, Trace, CommonUtils, Observer, } from '@ohos/basicutils';
import {
  ScreenOnOffEvent,
  RequestWindowEvent,
  EvtBus,
  EventManager,
  PluginInfo,
  PluginWindowType,
  WindowEvent,
  viewMgrPolicy,
  ViewArea,
  PluginClickInfo
} from '@ohos/frameworkwrapper';
import { windowMgr, } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { MultimodalInputManager, MultiKeyCode, } from '@ohos/systemuicommon';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import { CustomRemoteAbilityComponent } from './CustomRemoteAbilityComponent';
import screenLockMediator from '../../SceneBoard/screenlock/refactor/ScreenLockMediator';
import StyleConstants from '../../common/constants/StyleConstants';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper';
import window from '@ohos.window';
import { PcStbSecondaryPanelController } from '../controller/PcStbSecondaryPanelController';

const TAG = 'DynamicPluginRootComponent';

/**
 * AbilityComponent组件根布局
 *
 * @since 2022-10-22
 */

@Component
export struct DynamicPluginRootComponent {
  private pluginInfo: PluginInfo | null = null;
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
  @State @Watch('onViewDataChange') pluginPanelCtrl: PcStbSecondaryPanelController =
    new PcStbSecondaryPanelController(this.pluginSlot);
  @State isShowing: boolean = false;
  persistentId: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();
  private screenLockObserver: Observer | null = null;

  aboutToAppear(): void {
    if (CommonUtils.isInvalid(this.pluginInfo)) {
      Log.showWarn(TAG, 'pluginInfo invalid');
      return;
    }
    Log.showDebug(TAG, 'bundleName:%{public}s,pluginSlot:%{public}s', this.pluginInfo?.pluginParseInfo.bundleName,
      this.pluginInfo?.pluginParseInfo.pluginSlot)
    let pluginParseInfo = this.pluginInfo?.pluginParseInfo;
    this.pluginSlot = pluginParseInfo?.pluginSlot || '';
    if (CommonUtils.isEmpty(this.pluginSlot)) {
      Log.showWarn(TAG, 'pluginSlot invalid');
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
      Log.showWarn(TAG, 'abilityName or bundleName invalid');
      return;
    }
    this.pluginBundleName = bundleName;
    this.pluginAbilityName = abilityName;
    this.initWindowPosition(clickInfo);
    this.initWindowPolicy();
    statusbarPlCtrl.registerPanelName(this.pluginSlot);
    // Lock screen monitoring
    this.screenLockObserver = {
      notify: (): void => {
        Log.showInfo(TAG, 'onLockScreen');
        this.hideWindow();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);
  }

  initWindowPosition(clickInfo?: PluginClickInfo): void {
    let windowWidth = PluginWindowType.getWindowWidth(clickInfo?.windowType || '');
    if (windowWidth === 0) {
      Log.showWarn(TAG, 'window type invalid');
      return;
    }
    let oldPosition = windowMgr.getWindowPosition(this.pluginSlot);
    let windowHeight = clickInfo?.windowHeight || 0;
    let rect: ViewArea = {
      left: px2vp(oldPosition.left),
      top: px2vp(oldPosition.top),
      width: px2vp(windowWidth) + StyleConstants.DEFAULT_BORDER_SIZE,
      height: windowHeight + StyleConstants.DEFAULT_BORDER_SIZE,
    };
    this.pluginPanelCtrl.updateArea(rect);
    this.pluginPanelCtrl.updateRect(rect);
    let area: window.Rect = {
      left: vp2px(rect.left),
      top: vp2px(rect.top),
      width: vp2px(rect.width),
      height: vp2px(rect.height)
    }
    Log.showWarn(TAG, 'initWindowPosition, pluginSlot:' + this.pluginSlot + ' area, left:' + area.left +
      ' top:' + area.top + ' width:' + area.width + ' height:' + area.height);
    EvtBus.post(WindowPositionChangeEvent,
      {
        windowName: this.pluginSlot,
        position: this.pluginInfo?.pluginParseInfo.pluginPosition,
        area: area
      });
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll();
    screenLockMediator.deleteObserver(this.screenLockObserver);
    this.pluginPanelCtrl.unRegisterFocusCallback();
  }

  /*
  ** 用于初次加载时二级窗口的启动加载，后续窗口缓存下来，不再退出并重新加载，可能会消耗一些缓存
   */
  onViewDataChange() {
    if (this.isShowing === true) {
      return;
    }
    Log.showInfo(TAG, `onViewDataChange this.pluginPanelCtrl.isShowing() = ${this.pluginPanelCtrl.isShowing()}`);
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
    Log.showInfo(TAG, 'ability onPageShow');
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
    Log.showInfo(TAG, `init ${this.pluginSlot} window Policy`);
    // 监听窗口事件
    this.eventMgr.on(WindowEvent, (event) => this.onWindowEvent(event))
      .on(ScreenOnOffEvent, (event) => this.onScreenOnOffEvent(event))
      .on(RequestWindowEvent, (event) => this.onRequestWindowEvent(event))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.C], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
        this.hideWindow();
      }))
      .addOff(MultimodalInputManager.subscribeCombinationKey([MultiKeyCode.WIN, MultiKeyCode.N], true, (data) => {
        Log.showInfo(TAG, `on CombinationKeyEvent: data: ${data}`);
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
      Log.showInfo(TAG, `onWindowEvent ability: ${this.pluginSlot}, event type is ${event.eventType}`);
      if (event.isMatchName(WindowConstants.WINDOW_NAME_BANNER)) {
        return;
      }
      if (!event.isMatchName(this.pluginSlot)) {
        this.hideWindow();
      }
    }
  }

  build() {
    CustomRemoteAbilityComponent({
      pluginBundleName: this.pluginBundleName,
      pluginAbilityName: this.pluginAbilityName,
      pluginSlot: this.pluginSlot,
      isShowing: this.pluginPanelCtrl.isShowing()
    })
      .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
      .width(this.pluginPanelCtrl.getArea().width - StyleConstants.DEFAULT_BORDER_SIZE)
      .height(this.pluginPanelCtrl.getArea().height - StyleConstants.DEFAULT_BORDER_SIZE)
      .clip(true)
  }
}