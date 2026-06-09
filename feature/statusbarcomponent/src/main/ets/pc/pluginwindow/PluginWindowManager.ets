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

import { PluginNotifyBase } from '../pluginData/PluginNotifyBase';
import { window } from '@kit.ArkUI';
import { PluginProperty } from '../viewdata/PluginProperty';
import { ListenerPriority } from '../pluginData/StatusBarPluginEventListener';
import { StatusBarEventId, StatusBarEventManager } from '../manager/StatusBarEventManager';
import { WindowPosCalculateBase } from './control/WindowPosCalculateBase';
import PCM from '@ohos.pluginComponent';
import Want from '@ohos.application.Want';
import { StyleFactory } from '../pluginstyle/StyleFactory';
import { PanelChangeEvent, PluginAreaEvent } from '../utils/events';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import StatusBarEventPoster from '../manager/StatusBarEventPoster';
import { AbilityComponentMgr } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { PluginUtils } from '../utils/PluginUtils';
import { PluginStyleChangeListener, StyleSwitchManager } from '../pluginstyleswitch/StyleSwitchManager';
import { ArrayUtils, CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  DeviceHelper,
  GlobalContext,
  HideWindowPanelEvent,
  PluginAccessInfo,
  PluginInfo, PluginSlot,
  PluginWindowType,
  sEventManager,
  sOutSideWindowMgr,
  StatusBarTintEvent,
  viewMgrPolicy,
  ViewType,
  WindowEvent,
  WindowPositionChangeEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { DisplayMgr, SCBFoldStatePropertyChangeEvent,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  windowMgr } from '@ohos/windowscene/src/main/ets/TsIndex';
import { WindowConstants } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { BigScreenStatus } from '../common/BigScreenStatus';
import { statusbarPlCtrl } from '../../common/StatusBarPanelController';
import { PluginDisplayStyle } from '../common/PluginConstants';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'PluginWindowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 没有图标的状态栏插件
 */
const NO_ICON_PLUGINS = [
  PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE
];
const LOCAL_EVENT_TYPE = 'local';

interface PluginComponentTemplate {
  source: string;
  ability: string;
}

/**
 * 触发二级面板位置更新场景：
 * 1、点击状态栏图标
 * 2、状态栏图标位置更新
 * 3、二级面板位置更新
 *
 */
export class PluginWindowManager extends PluginNotifyBase implements PluginStyleChangeListener {
  private positionControl: WindowPosCalculateBase | undefined = undefined;

  /**
   * 当前显示窗口的图标
   */
  private curWindowSlot: string = '';

  /**
   * 变化后窗口的高度
   */
  private adaptiveScreenHeight: number | undefined = undefined;
  /**
   * 变化后窗口的宽度
   */
  private adaptiveScreenWidth: number | undefined = undefined;
  /**
   * 是否处于形态变化中
   */
  public isBigScreenStatusChange: boolean = false;
  /**
   * 定时器id
   */
  private statusDuringTimerId: number | null = null;
  /**
   * 能否更新选中态
   */
  private canUpdateSelectState: boolean = true;

  /**
   * 系统接入二级菜单缓存
   */
  private dynamicPanels: PluginInfo[] = [];
  /**
   * 生态接入二级菜单缓存
   */
  private accessPanels: PluginAccessInfo[] = [];

  /**
   * 形态变化时状态管理
   */
  private bigScreenStatus: BigScreenStatus = BigScreenStatus.getInstance();
  /**
   * 托盘位置(px)
   */
  private trayPanelRect: window.Rect | undefined = undefined;

  /**
   * 不需要计算二级菜单宽度的状态栏插件
   */
  private noNeedCalWidthPlugins: Set<string> = new Set([
    PluginSlot.SLOT_CONTROL_PRIVACY_PANEL
  ]);

  private static mInstance: PluginWindowManager;

  public static getInstance(): PluginWindowManager {
    if (!PluginWindowManager.mInstance) {
      PluginWindowManager.mInstance = new PluginWindowManager();
    }
    return PluginWindowManager.mInstance;
  }

  protected addPlugin(pluginInfos: PluginProperty[]): void {
    this.setPanelStorage();
    pluginInfos.forEach(plugin => this.checkoutClickWindow(plugin.pluginInfo));
  }

  protected removePlugin(pluginInfos: PluginProperty[]): void {
    this.setPanelStorage();
    pluginInfos.forEach(plugin => AbilityComponentMgr
      .destroyAbilityWindow(plugin.getSlot()));
  }

  protected updatePlugin(pluginInfos: PluginProperty[]): void {
  }

  protected initDiff(): void {
    log.showInfo('initDiff');
    this.positionControl = StyleFactory.getInstance().getStyleManager()?.getWindowPosControl();
    setTimeout(() => {this.dealNoIconPlugin()}, 1000);
    StatusBarEventManager.getInstance()
      .on(TAG, WindowPositionChangeEvent, this.handleWindowPositionEvent)
      .on(TAG, HideWindowPanelEvent, this.hideWindowPanel)
      .on(TAG, SCBFoldStatePropertyChangeEvent, this.onBigScreenStatusChange)
      .on(TAG, WindowEvent, this.handleWindowEvent)
      .on(TAG, StatusBarTintEvent, this.handleStatusBarTintEvent)// PC、桌面状态栏需要响应沉浸式效果，PC只关注窗口隐藏/显示，桌面状态栏关注全场景
      .onSpecial(TAG, StatusBarEventId.PLUGIN_AREA_EVENT, this.onPluginAreaEvent);
    sEventManager.subscribe(LOCAL_EVENT_TYPE, this.handleLocalEvent.bind(this));

    PCM.on('push', (source: Want, template: PluginComponentTemplate, data: PCM.KVObject, extraData: PCM.KVObject) => {
      if (CommonUtils.isBoolean(extraData?.isEditing) && CommonUtils.isString(extraData?.pluginSlot)) {
        if (!extraData?.isEditing) {
          windowMgr.hideWindowWithAnim(extraData?.pluginSlot as string);
        }
      }
    });
    StyleSwitchManager.getInstance().registerDataChangeListener(this);
  }

  private handleLocalEvent(canUpdateSelectState: boolean): void {
    this.canUpdateSelectState = canUpdateSelectState;
  }

  private setPanelStorage(): void {
    let pluginInfoList = PluginListAdapter.getInstance().getAllData();
    let dynamicPluginPanels: PluginInfo[] = [];
    let accessPluginPanels: PluginAccessInfo[] = [];
    pluginInfoList.forEach(pluginInfo => {
      if (CheckEmptyUtils.isEmpty(pluginInfo.pluginInfo)) {
        return;
      }
      if (!PluginUtils.needDynamicPluginPanel(pluginInfo.pluginInfo!)) {
        log.showInfo('setPanelStorage not need dynamic plugin panel: ' +
        pluginInfo.getSlot());
        return;
      }
      if (pluginInfo.isPluginTypeAccess()) {
        accessPluginPanels.push(pluginInfo.pluginInfo as PluginAccessInfo);
        return;
      }
      dynamicPluginPanels.push(pluginInfo.pluginInfo!);
    })

    this.accessPanels = accessPluginPanels;
    this.dynamicPanels = dynamicPluginPanels;
    StatusBarEventPoster.getInstance().postPanelChangeEvent(new PanelChangeEvent('dynamic', dynamicPluginPanels));
    StatusBarEventPoster.getInstance().postPanelChangeEvent(new PanelChangeEvent('access', accessPluginPanels));
  }

  public getDynamicPanels(): PluginInfo[] {
    return this.dynamicPanels;
  }

  public getAccessPanels(): PluginAccessInfo[] {
    return this.accessPanels;
  }

  /**
   * 隐藏应用中心或者多任务中心窗口
   */
  public hideAppOrRecentWindow(): void {
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER)) {
      if (GlobalContext.getInstance().hasObject('hideAppCenterWithAnimation')) {
        let hideAppCenterWithAnimation = (GlobalContext.getInstance()
          .getObject('hideAppCenterWithAnimation')) as Function;
        hideAppCenterWithAnimation();
      }
    }
    if (AppStorage.get('showRecent') as boolean) {
      AppStorage.setOrCreate('showRecent', false);
    }
  }

  public async updatePluginWindowPosition(slot: string): Promise<void> {
    let position = await this.calPluginWindowPosition(slot);
    windowMgr.updateWindowPosition(slot, position[0]);
    windowMgr.updateWindowAnimPivot(slot, position[1], position[2]);
  }

  /**
   * 检测是否创建点击事件窗口
   *
   * @param pluginInfo plugin信息
   */
  private checkoutClickWindow(pluginInfo: PluginInfo | null): void {
    // 检测点击类型为窗口类型
    if (!PluginUtils.hasClickWindow(pluginInfo)) {
      return;
    }
    let slot = pluginInfo?.getSlot();

    let clickInfo = pluginInfo?.pluginParseInfo?.clickInfo;
    let windowWidth = PluginWindowType.getWindowWidth(clickInfo?.windowType);
    if (windowWidth == 0) {
      log.showWarn('checkoutClickWindow window type invalid');
      return;
    }
    // 远程应用替换本地plugin的场景
    let oldPosition = windowMgr.getWindowPosition(slot);
    // 获取窗口宽高，默认位置0,0
    let position: window.Rect = {
      left: oldPosition.left,
      top: oldPosition.top,
      width: windowWidth,
      height: vp2px(clickInfo?.windowHeight)
    };
    let bundleName = pluginInfo?.pluginParseInfo.bundleName;
    AbilityComponentMgr.createAbilityWindow(slot, position, bundleName, clickInfo?.abilityName)
      .then((window) => {
        // 窗口背景模糊
        windowMgr.setWindowBackBlur(slot, WindowConstants.BLUR_BG_COLOR, WindowConstants.BLUR_RADIUS);
        // 圆角半径
        windowMgr.updateWindowRadius(slot, WindowConstants.getPcSecondaryWindowRadius());
        // 窗口阴影
        windowMgr.setWindowShadow(slot, WindowConstants.PC_SECONDARY_WINDOW_SHADOW_RADIUS,
          WindowConstants.PC_SECONDARY_WINDOW_SHADOW_COLOR, WindowConstants.SHADOW_OFFSET_X,
          WindowConstants.PC_SECONDARY_WINDOW_SHADOW_OFFSET_Y);
      });
  }

  /**
   * 处理状态栏窗口位置变更事件
   *
   * @param event 事件
   */
  private handleWindowPositionEvent = async (event: WindowPositionChangeEvent): Promise<void> => {
    log.showDebug(`handleWindowPositionEvent, event slot: ${event.windowName}`);
    this.updateWindowPosition(event.windowName, event.area);
    let plugin: PluginProperty | null = null;
    if (this.noNeedCalWidthPlugins.has(event.windowName)) {
      plugin = PluginListAdapter.getInstance().addEmptyData(event.windowName);
    } else {
      plugin = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.windowName);
    }
    if (plugin?.isFromControlCenter === false) {
      plugin?.setFromControlCenter(event.caller === PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    }
    let position = await this.calPluginWindowPosition(event.windowName,
      this.noNeedCalWidthPlugins.has(event.windowName));
    windowMgr.updateWindowAnimPivot(event.windowName, position[1], position[2]);
    this.updateWindowPosition(event.windowName, position[0]);
  }

  public hideWindowPanel = (): void => {
    log.showInfo('hideWindowPanel');
    PluginListAdapter.getInstance().getAllData().forEach(plugin => {
      windowMgr.hideWindowImmediately(plugin?.getSlot());
      log.showDebug(`hideWindowImmediately ${plugin?.getSlot()}`);
    });
  }

  public setTrayPanelRect(width: number, height: number): void {
    if (!this.trayPanelRect) {
      this.trayPanelRect = windowMgr.getWindowPosition(PluginSlot.SLOT_STATUS_TRAY_PANEL);
    }
    this.trayPanelRect.width = width;
    this.trayPanelRect.height = height;
  }

  private updateTrayPanelPositionSize(position: window.Rect, trayPanelRect: window.Rect): void {
    position.width = trayPanelRect.width;
    position.height = trayPanelRect.height;
  }

  private updateWindowPosition(slot: string, position: window.Rect): void {
    if (this.inBigScreenStatusChange()) {
      log.showInfo(`${slot} is in status change, no update WindowPostion!`);
      return;
    }
    if (slot === PluginSlot.SLOT_STATUS_TRAY_PANEL && this.trayPanelRect) {
      this.updateTrayPanelPositionSize(position, this.trayPanelRect);
    }
    windowMgr.updateWindowPosition(slot, position);
  }

  private inBigScreenStatusChange(): boolean {
    return this.isBigScreenStatusChange;
  }

  private onBigScreenStatusChange = (bigScreenStateProperty: SCBFoldStatePropertyChangeEvent) => {
    log.showInfo(`onBigScreenStatusChange property, bSideHeight: ${bigScreenStateProperty.bSideHeight}, ` +
      `curState: ${bigScreenStateProperty.curState}, tarState: ${bigScreenStateProperty.tarState}`);
    this.updateScreenInfo(bigScreenStateProperty);
    this.closeWindowOnStatusChange(bigScreenStateProperty);
  }

  private updateScreenInfo(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent): void {
    // 虚拟键盘和磁吸键盘存在
    if (this.bigScreenStatus.isKeyBoardExist(bigScreenStateProperty)) {
      this.adaptiveScreenHeight = bigScreenStateProperty.bSideHeight;
      this.adaptiveScreenWidth = bigScreenStateProperty.bSideWidth;
    } else {
      // 获取的整个屏幕的宽高
      let screenSession = SCBScreenSessionManager.getInstance().getMainScreenSession();
      // px
      this.adaptiveScreenHeight = screenSession.scbScreenProperty.height;
      this.adaptiveScreenWidth = screenSession.scbScreenProperty.width;
      log.showInfo('onBigScreenStatusChange, other state');
    }
    log.showInfo(`screenHeight: ${this.adaptiveScreenHeight}, screenWidth: ${this.adaptiveScreenWidth}`);
  }

  private closeWindowOnStatusChange(bigScreenStateProperty: SCBFoldStatePropertyChangeEvent) {
    if (BigScreenStatus.getInstance().isRotateStatus(bigScreenStateProperty)) {
      log.showInfo('this is rotating, no deal now');
      return;
    }
    // 没有窗口展示则不需要动效
    let windowName = statusbarPlCtrl.getCurWindow();
    windowMgr.hideWindowImmediately(windowName);
    this.setStatusDuringTimer(200);
  }

  private clearStatusDuringTimerId(): void {
    if (this.statusDuringTimerId) {
      log.showInfo(`clearStatusDuringTimerId happen : ${this.statusDuringTimerId}`);
      clearTimeout(this.statusDuringTimerId);
      this.statusDuringTimerId = null;
    }
  }

  private setStatusDuringTimer(during: number): void {
    this.clearStatusDuringTimerId();
    this.isBigScreenStatusChange = true;
    log.showInfo(`status change begin, isBigScreenStatusChange: ${this.isBigScreenStatusChange}`);
    this.statusDuringTimerId = setTimeout(() => {
      this.isBigScreenStatusChange = false;
      log.showInfo(`status change end, isBigScreenStatusChange: ${this.isBigScreenStatusChange}`);
      this.clearStatusDuringTimerId();
    }, during);
  }

  /**
   * 处理窗口显示/隐藏事件
   *
   * @param event 窗口事件
   */
  private handleWindowEvent = (event: WindowEvent): void => {
    if (CommonUtils.isInvalid(event)) {
      return;
    }
    if (!this.canUpdateSelectState) {
      log.showInfo('handleWindowEvent canUpdateControlPanelSelectState false');
      return;
    }
    // 窗口隐藏时，取消选中状态
    if (event.eventType == WindowEvent.EVENT_TYPE_HIDE &&
      event.eventState == WindowEvent.EVENT_STATE_END) {
      if (this.curWindowSlot === event.windowName) {
        this.curWindowSlot = '';
      }
      PluginListAdapter.getInstance().getPluginPropertyBySlot(event.windowName)?.setFromControlCenter(false);
      log.showDebug('handleWindowEvent hide window: ' + event.windowName);
    } else if (event.eventType == WindowEvent.EVENT_TYPE_SHOW &&
      event.eventState == WindowEvent.EVENT_STATE_START) {
      this.curWindowSlot = event.windowName;
      log.showDebug('handleWindowEvent show window: ' + event.windowName);
      if (DeviceHelper.is2In1DevicePcType() && viewMgrPolicy.isViewShowing(ViewType.GLOBAL_SEARCH)) {
        sOutSideWindowMgr.hideGlobalSearch();
      }
      this.hideAppOrRecentWindow();
    }
  }

  /**
   * 处理状态栏沉浸式事件
   *
   * @param event 事件
   */
  private handleStatusBarTintEvent = (event: StatusBarTintEvent): void => {
    log.showDebug(`handleStatusBarTintEvent, event.regionTint.length: ${event?.regionTint?.length}`);
    if (ArrayUtils.isEmpty(event.regionTint)) {
      return;
    }
    let firstTint = event.regionTint[0];
    // PC、桌面状态栏均需处理隐藏/显示窗口事件
    if (firstTint.isEnable) {
      windowMgr.showWindowImmediately(WindowConstants.WINDOW_NAME_STATUS_BAR);
    } else {
      windowMgr.hideWindowImmediately(WindowConstants.WINDOW_NAME_STATUS_BAR);
    }
  }

  /**
   * 获取屏幕宽度
   *
   * @return 屏幕宽度
   */
  private async getScreenWidth(): Promise<number> {
    return new Promise((resolve) => {
      DisplayMgr.getCurrentDisplay().then((display) => {
        resolve(display.width);
      });
    });
  }

  /**
   * 获取屏幕高度
   *
   * @return 屏幕高度
   */
  private async getScreenHeight(): Promise<number> {
    return new Promise((resolve) => {
      DisplayMgr.getCurrentDisplay().then((display) => {
        resolve(display.height);
      });
    });
  }

  /**
   * 图标位置变更回调
   *
   * @param event 事件
   */
  private onPluginAreaEvent = async (event: PluginAreaEvent) => {
    if (!event || !event.area) {
      log.showError('handlePluginAreaEvent error');
      return;
    }

    // 记录图标位置，检测是否变更沉浸式颜色
    windowMgr.setStatusIconCaches(event.slot, event.area as Area);
    if (event.slot === PluginSlot.SLOT_STATUS_CLOCK_PANEL) {
      event.slot = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;
      windowMgr.setStatusIconCaches(event.slot, event.area as Area);
    }
    let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.slot);
    let pluginSlot = event.slot;
    // 无窗口
    if (!PluginUtils.hasClickWindow(property?.pluginInfo ?? null) && pluginSlot !== PluginSlot.SLOT_STATUS_TRAY_PANEL) {
      return;
    }
    log.showInfo(`onPluginAreaEvent, slot: ${event.slot }, area: ${JSON.stringify(event.area)}, \
     curWindowSlot: ${this.curWindowSlot}`);
    let position = await this.calPluginWindowPosition(pluginSlot);
    windowMgr.updateWindowAnimPivot(pluginSlot, position[1], position[2]);
    this.updateWindowPosition(pluginSlot, position[0]);
  }


  /**
   * 对于打开面板时，没有图标情况时相应的面板位置计算
   */
  private dealNoIconPlugin() {
    NO_ICON_PLUGINS.forEach((pluginSlot) => {
      let oldPosition = windowMgr.getWindowPosition(pluginSlot);
      // 获取窗口宽高，默认位置0,0
      let position: window.Rect = {
        left: oldPosition.left,
        top: windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height,
        width: oldPosition.width,
        height: oldPosition.height
      };
      log.showInfo(`dealNoIconPlugin slot: ${pluginSlot}`)
      windowMgr.updateWindowPosition(pluginSlot, position);
      this.setMappingSlotArea(pluginSlot);
    });
  }

  /**
   * 设置图标映射位置
   * @param slot
   */
  private setMappingSlotArea(slot: string): void {
    let mappingSlot = this.positionControl?.getMappingSlot(slot) ?? slot;
    if (!windowMgr.getStatusIconCache(slot)) {
      let mappingIconArea = windowMgr.getStatusIconCache(mappingSlot) as Area;
      windowMgr.setStatusIconCaches(slot, mappingIconArea);
    }
  }

  private async calPluginWindowPosition(slot: string,
    isNoNeedCalWidth?: boolean): Promise<[window.Rect, number, number]> {
    let screenWidth = this.adaptiveScreenWidth ?? (await this.getScreenWidth());
    let screenHeight = this.adaptiveScreenHeight ?? (await this.getScreenHeight());

    let position = this.positionControl!.calPluginWindowPos(slot, screenWidth, screenHeight, isNoNeedCalWidth);
    log.showInfo('calPluginWindowPosition, slot:' + slot + ' screenWidth:' + screenWidth + ' screenHeight:' +
      screenHeight + ' position, left:' + position[0].left + ' top:' + position[0].top + ' width:' +
        position[0].width + ' height:' + position[0].height);
    return position;
  }

  protected deInitDiff(): void {
    log.showInfo('deInitDiff');
    StyleSwitchManager.getInstance().unregisterDataChangeListener(this);
    StatusBarEventManager.getInstance().offAll(TAG);
    sEventManager.off(LOCAL_EVENT_TYPE, this.handleLocalEvent.bind(this));
    this.positionControl = undefined;
  }

  getPriority(): ListenerPriority {
    return ListenerPriority.PLUGIN_WINDOW;
  }

  notifyPluginStyleChange(newStyle: PluginDisplayStyle, oldStyle: PluginDisplayStyle): void {
    PluginListAdapter.getInstance().removeEmptyData(this.noNeedCalWidthPlugins);
    this.positionControl = StyleFactory.getInstance().getStyleManager()?.getWindowPosControl();
    setTimeout(() => {this.dealNoIconPlugin()}, 100);
  }
}