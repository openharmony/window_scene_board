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
import { StateManager } from '../manager/StateManager';
import { StatusBarEventId, StatusBarEventManager } from '../manager/StatusBarEventManager';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { StatusBarCustomEvent } from '../utils/events';
import { PluginProperty } from '../viewdata/PluginProperty';
// import statusBar from '@hms.pcService.statusBar';
import measure from '@ohos.measure';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/constants/CommonConstants';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { PreShowEvent } from '../utils/PreShowEvent';
import { PluginGroupingManager } from '../plugingroup/PluginGroupingManager';
import { PluginGroupType, PluginPositionType } from '../common/PluginConstants';
import { PluginNotifyBase } from '../pluginData/PluginNotifyBase';
import { statusbarPlCtrl } from '../../common/StatusBarPanelController';
import { AppClientNotifier } from '@ohos/statusbarextensionservice/src/main/ets/TsIndex';
import { PluginUtils } from '../utils/PluginUtils';
import { PluginWindowManager } from '../pluginwindow/PluginWindowManager';
import { ArrayUtils, CommonUtils, LogDomain, LogHelper, Trace } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  EvtBus,
  HiSysEventUtil,
  PluginAbilityType,
  PluginClickInfo,
  PluginClickType,
  PluginSlot,
  reportIntervalMgr,
  sEventManager,
  viewMgrPolicy,
  ViewType,
  WindowEvent } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { ResUtils, SCBSceneSessionManager, StartAbilityUtil, windowMgr } from '@ohos/windowscene/src/main/ets/TsIndex';
import { PluginStyleUtil } from '../common/PluginStyleUtil';

const TAG = 'PluginEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const REMOTE_PLUGIN_ARRAY = [
  PluginSlot.SLOT_STATUS_WIFI,
  PluginSlot.SLOT_STATUS_BLE,
  PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT,
  PluginSlot.SLOT_STATUS_SMART_SCREENSHOT,
  PluginSlot.SLOT_STATUS_SCREEN_RECORDER,
  PluginSlot.SLOT_STATUS_QUICK_NOTE,
  PluginSlot.SLOT_STATUS_HOS_KEY,
];
const TRIGGER_TYPE_VALUE = 'status-bar';
const LOCAL_EVENT_TYPE = 'local';

export class PluginEventManager extends PluginNotifyBase {
  /**
   * WLAN、蓝牙面板预加载事件
   */
  private preShowEvent: PreShowEvent = new PreShowEvent();

  /**
   * 能否更新选中态
   */
  private canUpdateSelectState: boolean = true;

  private static mInstance: PluginEventManager;

  public static getInstance(): PluginEventManager {
    if (!PluginEventManager.mInstance) {
      PluginEventManager.mInstance = new PluginEventManager();
    }
    return PluginEventManager.mInstance;
  }

  protected addPlugin(pluginInfos: PluginProperty[]): void {
    this.handlePlugin(pluginInfos);
  }

  protected removePlugin(pluginInfos: PluginProperty[]): void {
  }

  protected updatePlugin(pluginInfos: PluginProperty[]): void {
    this.handlePlugin(pluginInfos);
  }

  protected initDiff(): void {
    log.showInfo('initDiff');
    StatusBarEventManager.getInstance()
      .on(TAG, WindowEvent, this.handleWindowEvent)
      .onSpecial(TAG, StatusBarEventId.CUSTOM_EVENT, this.onCustomEvent);
    sEventManager.subscribe(LOCAL_EVENT_TYPE, this.handleLocalEvent.bind(this));
  }

  protected deInitDiff(): void {
    log.showInfo('deInitDiff');
    StatusBarEventManager.getInstance().offAll(TAG);
    sEventManager.off(LOCAL_EVENT_TYPE, this.handleLocalEvent.bind(this));
  }

  private handleLocalEvent(canUpdateSelectState: boolean): void {
    this.canUpdateSelectState = canUpdateSelectState;
  }

  /**
   * 将groupProperty分组
   */
  private handlePlugin(pluginInfos: PluginProperty[]) {
    pluginInfos.forEach((property: PluginProperty) => {
      if (property.getSlot() == PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL ||
        property.getSlot() == PluginSlot.SLOT_STATUS_WIFI_PANEL) {
        AppStorage.setOrCreate(property.getSlot() + '_info', property.pluginInfo);
      }
    })
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

    let slot = event.windowName;
    if (PluginStyleUtil.isMacStyle() &&
      event.windowName === PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL) {
      slot = PluginSlot.SLOT_STATUS_CLOCK_PANEL;
    }

    // 托盘show时重置组件状态
    if (event.eventType == WindowEvent.EVENT_TYPE_SHOW &&
      event.eventState == WindowEvent.EVENT_STATE_START && slot === PluginSlot.SLOT_STATUS_TRAY_PANEL) {
      this.resetTrayStates();
      return;
    }

    let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(slot);
    if (property == null) {
      return;
    }
    // 窗口隐藏时，取消选中状态
    if (event.eventType == WindowEvent.EVENT_TYPE_HIDE &&
      event.eventState == WindowEvent.EVENT_STATE_END) {
      log.showDebug('handleWindowEvent hide window: ' + event.windowName);
      this.updateSingleSelectState(property, false);
    } else if (event.eventType == WindowEvent.EVENT_TYPE_SHOW &&
      event.eventState == WindowEvent.EVENT_STATE_START) {
      log.showDebug('handleWindowEvent show window: ' + event.windowName);
      this.updateSingleSelectState(property, true);
    }
  }

  /**
   * 托盘区组件状态重置
   */
  resetTrayStates(): void {
    PluginGroupingManager.getInstance().getPluginGroup(PluginPositionType.BOTTOM_RIGHT,
      PluginGroupType.TRAY)?.getPluginList().forEach((plugin) => {
      StateManager.getInstance().updateSelectedState(plugin.getSlot(), false);
      StateManager.getInstance().updateClickedState(plugin.getSlot(), false);
      StateManager.getInstance().updateHoveredState(plugin.getSlot(), false)
    })
  }

  /**
   * 状态栏自定义事件回调
   * 这里不能用异步，可能会导致时序
   */
  private onCustomEvent = (event: StatusBarCustomEvent) => {
    switch (event.eventType) {
      case 'click':
        this.resolveClickEvent(event);
        break;
      case 'doubleClick':
        this.resolveDoubleClickEvent(event);
        break;
      case 'touch':
        this.resolveTouchEvent(event);
        break;
      case 'mouse':
        this.resolveMouseEvent(event);
        break;
      case 'longClick':
        this.resolveLongClickEvent(event);
        break;
      case 'rightClick':
        this.resolveRightClickEvent(event);
        break;
      case 'hover':
        this.resolveHoverEvent(event);
        break;
      case 'none':
        log.showError('event invalid');
        break;
    }
  }


  /**
   * 状态栏图标点击事件处理
   *
   * @param event 事件
   */
  private async resolveClickEvent(event: StatusBarCustomEvent): Promise<void> {
    if (!event) {
      log.showError('resolveClickEvent error');
      return;
    }
    let plugin = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.slot);
    plugin?.setFromControlCenter(false);

    this.togglePluginIconSelectState(event);
    this.updateClickedState(event.slot, event.actsOn);
  }

  /**
   * 状态栏图标双击事件处理
   *
   * @param event
   */
  private resolveDoubleClickEvent(event: StatusBarCustomEvent): void {
    if (!event) {
      log.showError('resolveDoubleClickEvent error');
      return;
    }
    let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.actsOn);
    if (!property || !property.pluginInfo) {
      log.showDebug('resolveDoubleClickEvent --zpan-- ');
      return;
    }
    log.showInfo('resolveDoubleClickEvent --zpan-- slot: ' + event.slot + ' act on ' + event.actsOn);
    this.resolvePluginClick(property, true, 'doubleClickInfo');
    this.updateClickedState(event.slot, event.actsOn);
  }

  /**
   * 切换plugin图标选中状态
   *
   * @param info plugin信息
   * @param isSelected 选中状态
   */
  private async togglePluginIconSelectState(event: StatusBarCustomEvent): Promise<void> {
    if (!event) {
      log.showError('togglePluginIconSelectState error');
      return;
    }
    log.showInfo('togglePluginIconSelectState --zpan--');
    // 选中状态切换
    let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.actsOn);
    if (!property) {
      log.showDebug('togglePluginIconSelectState property error ' + event.slot + ' act on ' + event.actsOn);
      return;
    }
    this.checkAndUpdateSelectState(event.actsOn);
    let pluginState = StateManager.getInstance().getState(property.getSlot());
    let isSelected = !pluginState.isSelected;
    // 处理点击事件
    isSelected = await this.resolvePluginClick(property, isSelected, 'clickInfo');

    // 更新选中状态
    log.showInfo('updatePluginIconSelectState slot: ' + event.slot + ' act on ' +
      event.actsOn + ', selected: ' + isSelected);
    StateManager.getInstance().updateSelectedState(event.actsOn, isSelected);
    if (event.slot !== event.actsOn) {
      // 更新容器选中态
      StateManager.getInstance().updateSelectedState(event.slot, isSelected);
    }
  }

  /**
   * 处理图标点击
   *
   * @param PluginProperty 图标属性
   * @param isSelected 是否选中
   * @return 最终是否选中
   */
  private async resolvePluginClick(property: PluginProperty, isSelected: boolean, type: string): Promise<boolean> {
    if (!property || !property.pluginInfo) {
      return false;
    }

    // 判断是否有点击信息
    let clickInfo: PluginClickInfo = property.pluginInfo.pluginParseInfo[type];
    if (CommonUtils.isInvalid(clickInfo)) {
      log.showInfo('resolvePluginClick has not click info');
      return false;
    }
    log.showInfo(`resolvePluginClick slot: ${property.getSlot()}
      click type: ${clickInfo.clickType} , selected: ${isSelected}`);
    // 增加点击胶囊打开二级页面的trace
    if (isSelected) {
      Trace.start(property.getSlot());
    }
    reportIntervalMgr.addEventCount(property.getSlot());
    if (property.getSlot() === PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT ||
      property.getSlot() === PluginSlot.SLOT_STATUS_SMART_SCREENSHOT ||
      property.getSlot() === PluginSlot.SLOT_STATUS_SCREEN_RECORDER) {
      if (viewMgrPolicy.isViewShowing(ViewType.TRAY_PANEL)) {
        windowMgr.hideWindowWithAnim(PluginSlot.SLOT_STATUS_TRAY_PANEL);
      }
      let shotType =
        property.getSlot() === PluginSlot.SLOT_STATUS_SMART_SCREENSHOT ? 'smart-shot' :
          'normal_type';
      let area = property.isWindowType() && property.getPluginInGroup() === PluginGroupType.TRAY ?
        windowMgr.getStatusIconCache(PluginSlot.SLOT_STATUS_TRAY_PANEL) : property.area;
      setTimeout(() => {
        StartAbilityUtil.startServiceExtensionAbility({
          bundleName: property.pluginInfo?.pluginParseInfo.bundleName,
          abilityName: property.pluginInfo?.pluginParseInfo.pluginAbilityName,
          parameters: {
            shot_type: shotType,
            trigger_type: TRIGGER_TYPE_VALUE,
            isWindowType: property.isWindowType(),
            area: area
          }
        })
      }, 100);
    }
    switch (clickInfo.clickType) {
      // 直接拉起ability，无选中效果
      case PluginClickType.TYPE_ABILITY:
        // 一步直达
        if (property.isPluginTypeAccess()) {
          AppClientNotifier.getInstance().notifyClientIconClicked(property.getSlot(), 'leftClick');
          PluginWindowManager.getInstance().hideAppOrRecentWindow();
          return false;
        }
        let result = this.startAbilityByClickPlugin(property);
        PluginWindowManager.getInstance().hideAppOrRecentWindow();
        return result;
      // 展示窗口
      case PluginClickType.TYPE_WINDOW:
        return await this.updateWindowVisibleByClickPlugin(property, isSelected);
      // 其他场景不处理
      default:
        let bundleName = property.pluginInfo.pluginParseInfo?.bundleName;
        HiSysEventUtil.hiSysOnIconItemsClick(bundleName, property.getSlot(),
          PluginStyleUtil.getCurStatusBarTypeValue());
        return false;
    }
  }

  private startAbilityByClickPlugin(property: PluginProperty): boolean {
    if (!property || !property.pluginInfo) {
      return false;
    }
    let clickInfo = property.pluginInfo.pluginParseInfo.clickInfo;
    let bundleName = property.pluginInfo.pluginParseInfo?.bundleName;
    let abilityName = clickInfo.abilityName;
    let moduleName = property.pluginInfo.pluginParseInfo?.moduleName;
    HiSysEventUtil.hiSysOnIconItemClick(property.getSlot());
    HiSysEventUtil.hiSysOnIconItemsClick(bundleName, property.getSlot(),
      PluginStyleUtil.getCurStatusBarTypeValue());
    // 区分启动ability和serviceExtensionAbility
    if (PluginAbilityType.isTypeExtension(clickInfo.abilityType)) {
      if (property.getSlot() === PluginSlot.SLOT_STATUS_HOS_KEY) {
        StartAbilityUtil.startServiceExtensionAbility({
          bundleName: bundleName,
          abilityName: abilityName,
          moduleName: moduleName,
          parameters: {
            screenId: SCBSceneSessionManager.getInstance().mainScreenId
          }
        })
      } else {
        StartAbilityUtil.startServiceExtensionAbility({
          bundleName: bundleName,
          abilityName: abilityName,
          moduleName: moduleName
        })
      }
      log.showInfo('ability startServiceExtensionAbility --zpan-- over');
    } else {
      if (bundleName === undefined || bundleName === '' || moduleName === undefined) {
        log.showError('resolvePluginClick has not bundleName or moduleName');
        return false;
      }
      StartAbilityUtil.startAbility({
        bundleName: bundleName,
        abilityName: abilityName,
        moduleName: moduleName,
        parameters: {
          'LaunchType': 'Plugin'
        }
      });
      log.showInfo('ability startAbility --zpan-- over');
    }
    return false;
  }

  private async updateWindowVisibleByClickPlugin(property: PluginProperty, isSelected: boolean): Promise<boolean> {
    if (!property || !property.pluginInfo) {
      return false;
    }
    let slot = property.getSlot();
    if (slot === PluginSlot.SLOT_STATUS_CLOCK_PANEL) {
      slot = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;
    }
    if (!isSelected) {
      windowMgr.hideWindowWithAnim(slot);
      log.showInfo(`window hideWindowWithAnim --zpan-- over ${slot}`);
      return isSelected;
    }
    // PC打点
    HiSysEventUtil.hiSysOnIconItemClick(slot);
    let bundleName = property.pluginInfo.pluginParseInfo?.bundleName;
    HiSysEventUtil.hiSysOnIconItemsClick(bundleName, property.getSlot(),
      PluginStyleUtil.getCurStatusBarTypeValue());
    log.showInfo('window hiSysOnIconItemClick --zpan-- over');
    // 如果是插件，设置插件组件需要的参数
    if (!PluginUtils.isLocalPlugin(property.pluginInfo) || slot === PluginSlot.SLOT_STATUS_LOCATION) {
      windowMgr.setWindowData(slot, property.pluginInfo);
    }

    log.showInfo('hiSysOnIconItemClick slot:' + slot);
    // 更新窗口位置
    PluginWindowManager.getInstance().updatePluginWindowPosition(slot);

    windowMgr.showWindowWithAnim(slot, true);
    log.showInfo(`window showWindowWithAnim --zpan-- over ${slot}`);
    return isSelected;
  }

  /**
   * 检查并刷新当前选中态
   *
   * @param event 事件
   */
  private checkAndUpdateSelectState(actsOn: string): void {
    let tmpActsOn = actsOn;
    if (tmpActsOn === PluginSlot.SLOT_STATUS_CLOCK_PANEL) {
      tmpActsOn = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;
    }
    let isShowing = statusbarPlCtrl.getStatusBarPanelMap().get(tmpActsOn) as boolean;
    // 以窗口状态为准
    StateManager.getInstance().updateSelectedState(actsOn, isShowing);
  }

  /**
   * 状态栏图标触摸事件处理
   *
   * @param event 事件
   */
  private resolveTouchEvent(event: StatusBarCustomEvent): void {
    if (!event) {
      log.showError('resolveTouchEvent error');
      return;
    }
    let property : PluginProperty | undefined = undefined;
    if (PluginStyleUtil.isWindowStyle()) {
      property = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.actsOn) as PluginProperty;
    }
    log.showDebug('resolveTouchEvent --zpan-- slot: ' + event.slot + ' act on ' + event.actsOn);
    let touchEvent = event.event as TouchEvent;
    this.clockToNotification(event);
    switch (touchEvent?.type) {
      // down时记录图标slot
      case TouchType.Down:
        this.reportPluginTouch(event.actsOn);
        if (property && property.getSlot() !== PluginSlot.SLOT_STATUS_HOS_KEY) {
          log.showInfo('resolveDownEvent --zpan-- slot: ' + event.slot + ' act on ' + event.actsOn);
          this.updateSingleSelectState(property as PluginProperty, true);
        }
        break;
      // 复位slot
      case TouchType.Cancel:
      case TouchType.Up:
        if (property && property.getSlot() !== PluginSlot.SLOT_STATUS_HOS_KEY) {
          log.showInfo('resolveUpEvent --zpan-- slot: ' + event.slot + ' act on ' + event.actsOn);
          this.updateSingleSelectState(property as PluginProperty, false);
        }
        break;
      default:
        break;
    }
  }


  /**
   * 检查并更新当前图标选中态，和控制中心窗口状态保持一致
   *
   * @param property 当前图标属性
   */
  private checkAndUpdateCPSelectState(property: PluginProperty): void {
    if (!property) {
      log.showError('checkAndUpdateCPSelectState invalid');
      return;
    }
    let isShowing = statusbarPlCtrl.getStatusBarPanelMap().get(PluginSlot.SLOT_STATUS_CONTROL_CENTER) as boolean;
    let control = PluginListAdapter.getInstance().getPluginPropertyBySlot(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
    if (!control) {
      log.showError('control is null');
      return;
    }
    let localGroup = PluginGroupingManager.getInstance().getGroupPropertyByOpenPanel(control.getSlot());
    // 以控制中心窗口状态为准
    StateManager.getInstance().updateSelectedState(control?.getSlot() ?? '', isShowing);
    if (localGroup) {
      StateManager.getInstance().updateSelectedState(localGroup.getGroupName(), isShowing);
    }
  }

  /**
   * 更新单个图标选中状态
   *
   * @param slotKey plugin slot
   * @param isSelected 是否选中
   */
  private updateSingleSelectState(property: PluginProperty, isSelected: boolean): void {
    if (!property) {
      log.showError('updateSingleSelectState invalid');
      return;
    }
    // windows不涉及
    if (property.getSlot() === PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL ||
      property.getSlot() === PluginSlot.SLOT_STATUS_WIFI_PANEL ||
      property.getSlot() === PluginSlot.SLOT_STATUS_FOCUS_MODE_PADDLE ||
      property.getSlot() === PluginSlot.SLOT_STATUS_SOUND_PANEL) {
      this.checkAndUpdateCPSelectState(property);
    }
    StateManager.getInstance().updateSelectedState(property.getSlot(), isSelected);
    // 获取local group type.
    let localGroup = PluginGroupingManager.getInstance()
      .getGroupPropertyByOpenPanel(property.getSlot());
    if (localGroup) {
      StateManager.getInstance().updateSelectedState(localGroup.getGroupName(), isSelected);
    }
  }

  private clockToNotification(event: StatusBarCustomEvent) {
    if (event.actsOn === PluginSlot.SLOT_STATUS_CLOCK_PANEL) {
      event.actsOn = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;
    }
  }

  /**
   * 上报触摸图标事件
   *
   * @param slot 图标唯一标识
   */
  private reportPluginTouch(slot: string) {
    if (slot === PluginSlot.SLOT_STATUS_CAPSULE_SCREENSHOT ||
      slot === PluginSlot.SLOT_STATUS_SMART_SCREENSHOT ||
      slot === PluginSlot.SLOT_STATUS_SCREEN_RECORDER) {
      reportIntervalMgr.addEventCount(slot);
    }
  }


  /**
   * 状态栏图标鼠标事件处理
   *
   * @param event 事件
   */
  private resolveMouseEvent(event: StatusBarCustomEvent): void {
    if (!event) {
      log.showError('resolveMouseEvent error');
      return;
    }
    let mouseEvent = event.event as MouseEvent;
    let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.actsOn);
    if (!property) {
      log.showDebug('resolveMouseEvent --zpan-- error slot: ' + event.slot + ' act on ' + event.actsOn);
      return;
    }
    if (property.pluginInfo?.pluginParseInfo?.rightClickInfo?.clickType === PluginClickType.TYPE_CUSTOM &&
      !REMOTE_PLUGIN_ARRAY.includes(property.getSlot()) &&
      mouseEvent.button === MouseButton.Right && mouseEvent.action === MouseAction.Press) {
      this.updateClickedState(event.slot, event.actsOn);
    }
    if (property.pluginInfo?.pluginParseInfo?.isAccessPlugin && mouseEvent.button === MouseButton.Right) {
      this.calMenuPlacement(property);
    }
    if (mouseEvent.button === MouseButton.Right) {
      this.resolveRightClickEvent(event);
    }
  }

  /**
   * 计算右键菜单出现位置
   */
  private async calMenuPlacement(property: PluginProperty): Promise<void> {
    // 菜单宽度: 基础宽度为160vp
    let maxMenuWidth = ResUtils.getNumber($r('app.float.menu_min_width'));
    if (!ArrayUtils.isEmpty(property.groupMenuInfo)) {
      property.groupMenuInfo.forEach((menus: Array<ESObject>) => {
        menus.forEach((menuItem: ESObject) => {
          let curMenuWidth = this.setTextWidth(menuItem.title, menuItem.subMenu);
          maxMenuWidth = curMenuWidth > maxMenuWidth ? curMenuWidth : maxMenuWidth;
        })
      })
    }
    let screenWidth = AppStorage.get('screenWidth') as number;
    const constrainMaxWidth = ResUtils.getNumber($r('app.float.menu_max_width_ration')) * screenWidth;
    maxMenuWidth = maxMenuWidth > constrainMaxWidth ? constrainMaxWidth : maxMenuWidth;
    // 图标下方左对齐剩余间距
    const pluginArea = windowMgr.getStatusIconCache(property.getSlot());
    const pluginLeft = (pluginArea.globalPosition?.x ?? 0) as number;
    log.showInfo(`maxMenuWidth: ${maxMenuWidth} pluginLeft: ${pluginLeft}`);
    const remainSpace = screenWidth - pluginLeft;
    // 动态计算右键菜单对齐位置，优先左对齐，位置不足右对齐
    const menuPadding = ResUtils.getNumber($r('app.float.menu_right_padding'));
    property.updateMenuPlaceMent(maxMenuWidth + menuPadding < remainSpace ? Placement.BottomLeft :
    Placement.BottomRight);
  }

  /**
   * 获取右键菜单项宽度
   * @param title 标题
   * @param subMenu 二级菜单
   * @returns 菜单项宽度值
   */
  private setTextWidth(title: string, subMenu?: Array<ESObject>): number {
    const needTextWidth = Math.round(px2vp(measure.measureText({
      textContent: title,
      fontSize: StyleConstants.MENU_FONTSIZE,
      fontWeight: FontWeight.Medium,
      overflow: TextOverflow.Ellipsis,
      maxLines: 1
    }))) + ResUtils.getNumber($r('app.float.menu_text_padding'));
    return subMenu ? (needTextWidth + ResUtils.getNumber($r('app.float.arrow_right_width'))) : needTextWidth;
  }

  /**
   * 更新图标点击状态
   */
  private updateClickedState(slot: string, actsOn: string): void {
    if (slot !== actsOn) {
      return;
    }
    // 此处在图标选中之后设置点击态，是为了分离模式下的图标动效
    StateManager.getInstance().updateClickedState(actsOn, true);
  }

  /**
   * 状态栏图标右键点击事件处理
   *
   * @param event 事件
   */
  private resolveRightClickEvent(event: StatusBarCustomEvent): void {
    if (!event) {
      log.showError('resolveRightClickEvent error');
      return;
    }
    this.clockToNotification(event);
    log.showInfo('resolveRightClickEvent --zpan-- error slot: ' + event.slot + ' act on ' + event.actsOn);
    if (windowMgr.isShowing(event.actsOn)) {
      log.showInfo(`right click close window ${event.actsOn}`);
      windowMgr.hideWindowWithAnim(event.actsOn);
    }
  }

  /**
   * 状态栏图标长按事件处理
   *
   * @param event 事件
   */
  private resolveLongClickEvent(event: StatusBarCustomEvent): void {
    if (!event) {
      log.showError('resolveLongClickEvent error');
      return;
    }
    log.showInfo('resolveLongClickEvent --zpan-- slot: ' + event.slot + ' act on ' + event.actsOn);
    if (event.actsOn === PluginSlot.SLOT_STATUS_CLOCK_PANEL) {
      event.actsOn = PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL;
    }
    if (windowMgr.isShowing(event.actsOn)) {
      log.showInfo(`right click close window ${event.actsOn}`);
      windowMgr.hideWindowWithAnim(event.actsOn);
    }
  }

  /**
   * 状态栏右键点击事件处理
   *
   * @param event 事件
   */
  private resolveHoverEvent(event: StatusBarCustomEvent): void {
    if (!event) {
      log.showError('resolveHoverEvent error');
      return;
    }
    log.showInfo('resolveHoverEvent, slot:' + event.slot + ' actsOn:' + event.actsOn);
    let property = PluginListAdapter.getInstance().getPluginPropertyBySlot(event.actsOn);
    if (!property || !property.pluginInfo) {
      log.showDebug('resolveHoverEvent --zpan-- ');
      return;
    }
    if (property?.pluginInfo?.pluginParseInfo?.clickInfo?.clickType === PluginClickType.TYPE_CUSTOM &&
      !REMOTE_PLUGIN_ARRAY.includes(property.getSlot())) {
      return;
    }
    StateManager.getInstance().updateHoveredState(event.slot, event.isHovered ?? false);
    if ((event.actsOn === PluginSlot.SLOT_STATUS_BLUETOOTH_PANEL ||
      event.actsOn === PluginSlot.SLOT_STATUS_WIFI_PANEL)) {
      this.preShowEvent.setValue(event.isHovered!);

      EvtBus.post(PreShowEvent, this.preShowEvent);
    }
  }
}