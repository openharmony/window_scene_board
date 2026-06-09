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
  Observer,
} from '@ohos/basicutils';
import {
  EvtBus,
  EventManager,
  PluginWindowType,
  WindowEvent,
  ScreenOnOffEvent,
  RequestWindowEvent,
  viewMgrPolicy,
  ViewType,
  ViewArea,
  PluginClickInfo,
  PluginSlot,
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { MultimodalInputManager,
  MultiKeyCode
} from '@ohos/systemuicommon';
import screenLockMediator from '../../SceneBoard/screenlock/refactor/ScreenLockMediator';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import StyleConstants from '../../common/constants/StyleConstants';
import { WindowPositionChangeEvent } from '@ohos/frameworkwrapper';
import { PrivacyAbilityComponent } from './PrivacyAbilityComponent';
import { PrivacyEvent } from '../../SceneBoard/controlpanel/Event/PrivacyEvent';
import { ScrollBlurEvent } from '@ohos/controlcentercommon/src/main/ets/scrollBlur/ScrollBlurEvent';
import { PcStbSecondaryPanelController } from '../controller/PcStbSecondaryPanelController';

const TAG = 'PrivacyPluginAbilityComponent';

/**
 * PrivacyPluginAbilityComponent组件根布局
 *
 * @since 2024-09-13
 */

@Component
export struct PrivacyPluginRootComponent {
  pluginViewType: ViewType | undefined = undefined;
  private screenLockObserver: Observer | null = null;
  private privacyEvent: PrivacyEvent = new PrivacyEvent();
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
  @State @Watch('onViewDataChange') pluginPanelCtrl: PcStbSecondaryPanelController = new PcStbSecondaryPanelController(ViewType.SLOT_CONTROL_PRIVACY_PANEL);
  @State isIntWithoutShow: boolean = false;
  @State canDestroy: boolean = true;
  @State showControlOrSubPanel: boolean = false;
  persistentId: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear(): void {
    if (this.pluginViewType === undefined) {
      Log.showError(TAG, 'invalid init');
      return;
    }
    Log.showInfo(TAG, `this.pluginViewType: ${this.pluginViewType}`)
    this.pluginPanelCtrl = new PcStbSecondaryPanelController(this.pluginViewType);
    viewMgrPolicy.registerViewController(this.pluginViewType, this.pluginPanelCtrl);
    this.pluginPanelCtrl.updateId(this.persistentId);
    this.pluginPanelCtrl.registerFocusCallback();
    this.onViewDataChange();
    this.initWindowPolicy();

    windowMgr.onTouchOutside(this.pluginSlot, () => {
      windowMgr.hideWindowWithAnim(this.pluginSlot)
    })

    // 锁屏监听
    this.screenLockObserver = {
      notify: (): void => {
        Log.showInfo(TAG, 'onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);

    this.eventMgr.on(PrivacyEvent, (event: PrivacyEvent): void => {
      if (event?.isIntWithoutShow == null) {
        return;
      }
      this.onPriViewDataChange(event.isIntWithoutShow)
    })
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  onPriViewDataChange(isIntWithoutShow: boolean) {
    this.isIntWithoutShow = isIntWithoutShow;
  }

  onViewDataChange() {
    if (CommonUtils.isInvalid(this.pluginPanelCtrl)) {
      return;
    }
    if (CommonUtils.isInvalid(this.pluginPanelCtrl?.getViewData())) {
      Log.showInfo(TAG, 'pluginPanelCtrl!.getViewData() isInvalid');
      return;
    }
    Log.showDebug(TAG, 'onShowPluginChange:pluginInfo:bundleName:%{public}s',
      this.pluginPanelCtrl!.getViewData().pluginParseInfo.bundleName)
    let pluginParseInfo = this.pluginPanelCtrl!.getViewData()?.pluginParseInfo;
    let clickInfo = pluginParseInfo?.clickInfo;
    let bundleName = pluginParseInfo?.bundleName;
    let abilityName = clickInfo?.abilityName;
    if (CommonUtils.isEmpty(abilityName) ||
    CommonUtils.isEmpty(bundleName) ||
      bundleName === this.pluginBundleName ||
      abilityName === this.pluginAbilityName) {
      Log.showWarn(TAG, 'Check abilityName/bundleName/pluginBundleName/pluginAbilityName invalid');
      return;
    }
    this.pluginBundleName = bundleName;
    this.pluginAbilityName = abilityName;
    this.pluginSlot = pluginParseInfo?.pluginSlot;
    this.registerWindowCallBack();
    statusbarPlCtrl.registerPanelName(this.pluginSlot);
    this.initWindowPosition(clickInfo);
    // 窗口动画绑定onFrame
    windowMgr.startBindWinAnimOnFrame(this.pluginSlot);
  }

  initWindowPosition(clickInfo?: PluginClickInfo): void {
    let windowWidth = PluginWindowType.getWindowWidth(clickInfo?.windowType);
    if (windowWidth == 0) {
      Log.showWarn(TAG, 'window type invalid');
      return;
    }
    let oldPosition = windowMgr.getWindowPosition(this.pluginSlot);
    let rect: ViewArea = {
      left: px2vp(oldPosition.left),
      top: px2vp(oldPosition.top),
      width: px2vp(windowWidth),
      height: clickInfo?.windowHeight ?? 0
    };
    this.pluginPanelCtrl?.updateArea(rect);
    this.pluginPanelCtrl?.updateRect(rect);
    let area = {
      left: oldPosition.left,
      top: oldPosition.top,
      width: windowWidth,
      height: vp2px(clickInfo?.windowHeight ?? 0)
    } as ViewArea;
    EvtBus.post(WindowPositionChangeEvent,
      { windowName: this.pluginSlot,
        position: this.pluginPanelCtrl!.getViewData()?.pluginParseInfo.pluginPosition,
        area: area });
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll();
    if (CommonUtils.isInvalid(this.screenLockObserver)) {
      return;
    }
    screenLockMediator.deleteObserver(this.screenLockObserver as Observer);
    this.pluginPanelCtrl.unRegisterFocusCallback();
  }

  private onRequestWindowEvent(event: RequestWindowEvent) {
    if (event.windowName === null && event.requestType === RequestWindowEvent.REQUEST_HIDE) {
      if (!windowMgr.isShowing(this.pluginSlot) && !windowMgr.isShowing(PluginSlot.SLOT_STATUS_CONTROL_CENTER)) {
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
    if (!windowMgr.isShowing(this.pluginSlot) || windowMgr.isShowing(PluginSlot.SLOT_STATUS_CONTROL_CENTER)) {
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
    this.eventMgr.on(WindowEvent, (event: WindowEvent): void => {
      this.onWindowEvent(event)
    })
      .on(ScreenOnOffEvent, (event: ScreenOnOffEvent): void => {
        this.onScreenOnOffEvent(event)
      })
      .on(RequestWindowEvent, (event: RequestWindowEvent): void => {
        this.onRequestWindowEvent(event)
      })
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
        if (event.windowName === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
          return;
        }
        Log.showInfo(TAG, `event.windowName: ${event.windowName}`);
        this.hideWindow();
      }
    }
    if (event.windowName === this.pluginSlot || event.windowName === PluginSlot.SLOT_STATUS_CONTROL_CENTER) {
      this.showControlOrSubPanel = windowMgr.isShowing(this.pluginSlot) ||
        windowMgr.isShowing(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    }
  }

  private registerWindowCallBack(): void {
    if (!this.pluginSlot) {
      Log.showInfo(TAG, 'component doesnt have pluginslot');
      return;
    }
    if (this.pluginSlot === '') {
      Log.showInfo(TAG, 'pluginSlot is empty');
      return;
    }
    windowMgr.unregisterWindowDestroyCallBack(this.pluginSlot);
    windowMgr.registerWindowDestroyCallBack(this.pluginSlot,
      (destroyState: boolean): void => this.refreshDestoryState(destroyState));
  }

  refreshDestoryState(destroyState: boolean): void {
    this.canDestroy = destroyState;
    if (!this.canDestroy) {
      Log.showInfo(TAG, `${this.pluginSlot} can't destory`);
    }
  }

  build() {
    PrivacyAbilityComponent({
      pluginBundleName: this.pluginBundleName,
      pluginAbilityName: this.pluginAbilityName,
      pluginSlot: this.pluginSlot,
      isShowing: this.pluginPanelCtrl?.isShowing(),
      canDestroy: this.canDestroy,
      isIntWithoutShow: this.isIntWithoutShow,
      showControlOrSubPanel: this.showControlOrSubPanel,
    })
      .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
      .width(this.pluginPanelCtrl?.getArea().width - StyleConstants.DEFAULT_BORDER_SIZE)
      .height(this.pluginPanelCtrl?.getArea().height - StyleConstants.DEFAULT_BORDER_SIZE)
      .clip(true)
  }
}