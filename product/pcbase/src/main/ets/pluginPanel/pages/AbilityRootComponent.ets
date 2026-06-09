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

import { Log, Trace, CommonUtils, Observer, } from '@ohos/basicutils';
import {
  WindowPositionChangeEvent,
  ScreenOnOffEvent,
  RequestWindowEvent,
  EvtBus,
  EventManager,
  PluginWindowType,
  WindowEvent,
  viewMgrPolicy,
  ViewType,
  ViewArea,
  PluginClickInfo,
  PluginSlot,
} from '@ohos/frameworkwrapper';
import { windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { BaseViewController } from '@ohos/frameworkcommon';
import { MultimodalInputManager, MultiKeyCode } from '@ohos/systemuicommon';
import screenLockMediator from '../../SceneBoard/screenlock/refactor/ScreenLockMediator';
import { CustomRemoteAbilityComponent } from './CustomRemoteAbilityComponent';
import { statusbarPlCtrl } from '@ohos/statusbarcomponent/src/main/ets/common/StatusBarPanelController';
import StyleConstants from '../../common/constants/StyleConstants';
import { PluginVM } from '@ohos/plugincomponent/src/main/ets/vm/PluginVM';
import { PreShowEvent } from '@ohos/statusbarcomponent/src/main/ets/pc/utils/PreShowEvent';
import { PcStbSecondaryPanelController } from '../controller/PcStbSecondaryPanelController';

const TAG = 'AbilityRootComponent';

/**
 * AbilityComponent组件根布局
 *
 * @since 2022-10-22
 */

@Component
export struct AbilityRootComponent {
  pluginViewType: ViewType | undefined = undefined;
  pluginParams: Record<string, Object> | undefined = undefined;
  private screenLockObserver: Observer | null = null;
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
  @State @Watch('onViewDataChange') pluginPanelCtrl: PcStbSecondaryPanelController | undefined = undefined;
  @State canDestroy: boolean = true;
  @State isNeedPreShow: boolean = false;
  private isStart: boolean = false;
  private pluginVM: PluginVM = new PluginVM();
  persistentId: number = 0;
  /**
   * 多事件管理器
   */
  private eventMgr: EventManager = EvtBus.createEventManager();

  aboutToAppear(): void {
    if (this.pluginViewType === undefined) {
      Log.showInfo(TAG, 'invalid init');
      return;
    }
    this.pluginPanelCtrl = new PcStbSecondaryPanelController(this.pluginViewType);
    viewMgrPolicy.registerViewController(this.pluginViewType, this.pluginPanelCtrl);
    this.pluginPanelCtrl.updateId(this.persistentId);
    this.pluginPanelCtrl.registerFocusCallback();
    this.onViewDataChange();
    this.initWindowPolicy();

    // 锁屏监听
    this.screenLockObserver = {
      notify: (): void => {
        Log.showInfo(TAG, 'onLockScreen');
        this.onLockScreen();
      }
    };
    screenLockMediator.addObserver(this.screenLockObserver);

    this.eventMgr.on(PreShowEvent, (event: PreShowEvent): void => {
      if (event?.isNeedPreShow == null) {
        return;
      }
      this.onPriViewDataChange(event.isNeedPreShow);
    })
  }

  onLockScreen(): void {
    this.hideWindow();
  }

  onPriViewDataChange(isNeedPreShow: boolean) {
    this.isNeedPreShow = isNeedPreShow;
  }

  onViewDataChange() {
    if (CommonUtils.isInvalid(this.pluginPanelCtrl!.getViewData())) {
      Log.showInfo(TAG, `pluginPanelCtrl!.getViewData() isInvalid`);
      return;
    }
    if (!this.isStart) {
      this.pluginVM.init(this.pluginPanelCtrl!.getViewData());
    }
    this.isStart = true;
    Log.showInfo(TAG, 'onShowPluginChange:pluginInfo:bundleName:%{public}s',
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

    interface rectTS {
      left: number;
      top: number;
      width: number;
      height: number;
    }

    let rect: rectTS = {
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
      {
        windowName: this.pluginSlot,
        position: this.pluginPanelCtrl!.getViewData()?.pluginParseInfo.pluginPosition,
        area: area
      });
  }

  aboutToDisappear(): void {
    this.eventMgr.offAll();
    this.pluginVM.onDestroy();
    this.pluginPanelCtrl?.unRegisterFocusCallback();
    screenLockMediator.deleteObserver(this.screenLockObserver as Observer);
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
        this.hideWindow();
      }
    }
    if ((event.isMatchName(PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL) ||
    event.isMatchName(PluginSlot.SLOT_STATUS_WIFI_PANEL)) &&
    event.isWindowHide()) {
      this.isNeedPreShow = false;
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

  updateHeight(height: number) {
    Log.showInfo(TAG, `updateHeight height: ${height}`);
    let oldPosition = windowMgr.getWindowPosition(this.pluginSlot);
    let area: ViewArea = {
      left: oldPosition.left,
      top: oldPosition.top,
      width: oldPosition.width,
      height: height
    };
    EvtBus.post(WindowPositionChangeEvent, {
      windowName: this.pluginSlot, position: this.pluginPanelCtrl!.getViewData()?.pluginParseInfo.pluginPosition,
      area: area
    })
    Log.showInfo(TAG, `WindowPositionChangeEvent before: ${oldPosition.height}, after:${height}`);
  }

  build() {
    CustomRemoteAbilityComponent({
      pluginBundleName: this.pluginBundleName,
      pluginAbilityName: this.pluginAbilityName,
      pluginSlot: this.pluginSlot,
      pluginParams: this.pluginParams,
      isShowing: this.pluginPanelCtrl?.isShowing(),
      canDestroy: this.canDestroy,
      isNeedPreShow: this.isNeedPreShow,
      updateHeight: (height) => {
        this.updateHeight(height);
      }
    })
      .saturate(WindowConstants.PC_SECONDARY_WINDOW_SATURATE)
      .width(this.pluginPanelCtrl!.getArea().width - StyleConstants.DEFAULT_BORDER_SIZE)
      .height(this.pluginPanelCtrl!.getArea().height - StyleConstants.DEFAULT_BORDER_SIZE)
      .clip(true)
  }
}