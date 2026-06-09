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
  SingletonHelper,
  LogDomain,
  LogHelper,
  CommonUtils
} from '@ohos/basicutils';
import {
  PluginClickInfo,
  PluginParseInfo,
  PluginComponentInfo,
  PluginInfo,
  obtainLocalEvent,
  sEventManager
} from '@ohos/frameworkwrapper';
import { FASlotName } from '@ohos/commonconstants';

import { PluginComponentMgr, PluginPushListener } from '@ohos/systemuicommon/src/main/ets/plugin/PluginComponentManager';
import { performanceMonitor } from '@kit.ArkUI';
import sDropDownPanelManager from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager'
import { SubpageElementInfo } from '@ohos/systemuicommon/src/main/ets/template/newStyle/SubpageMenuViewData';

const TAG = 'ToggleSubWindowController'
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 控制中心快捷开关二级页面窗口控制器
 *
 * @since 2023-03-04
 */
class ToggleSubWindowController implements PluginPushListener<PluginComponentInfo> {
  private subWindowInfo: Map<string, PluginInfo> = new Map();
  private currentShowingSlot = '';
  private currentClickInfo?: PluginClickInfo;
  private currentSubInfo?: SubpageElementInfo;

  /**
   * plugin解析信息
   *
   * PluginPushListener实现
   */
  public parseInfo: PluginParseInfo | undefined = undefined;

  /**
   * plugin对象创建器
   *
   * PluginPushListener实现
   */
  public pluginClassCreater = () => { return new PluginComponentInfo() };

  /**
   * 注册二级页面
   *
   * @param pluginSlot 插件标识
   * @param clickInfo 插件注册信息
   */
  registerSubWindowInfo(pluginSlot: string, pluginInfo: PluginInfo) {
    if (CommonUtils.isEmpty(pluginSlot) || CommonUtils.isInvalid(pluginInfo)) {
      return;
    }
    this.subWindowInfo.set(pluginSlot, pluginInfo);
  }

  /**
   * 获取二级页面插件信息
   *
   * @param pluginSlot 插件标识
   * @return PluginInfo 插件注册信息
   */
  getSubWindowInfo(pluginSlot: string): PluginInfo | undefined {
    if (CommonUtils.isEmpty(pluginSlot)) {
      return undefined;
    }
    return this.subWindowInfo.get(pluginSlot);
  }

  /**
   * 显示窗口
   *
   * @param toggleSlot 快捷开关名称
   */
  showSubWindow(toggleSlot: string): void {
    log.showInfo(`showSubWindow -> currentShowingSlot = ${this.currentShowingSlot}`);
    if (!CommonUtils.isEmpty(this.currentShowingSlot)) {
      log.showInfo(this.currentShowingSlot + ' is showing');
      return;
    }
    this.setShowingSlot(toggleSlot);
    this.parseInfo = this.getSubWindowInfo(this.currentShowingSlot)?.pluginParseInfo;
    PluginComponentMgr.registerPushListener(this)
    sEventManager.publish(obtainLocalEvent('ControlCenterState', 2));
  }

  /**
   * 通过clickInfo显示窗口
   *
   * @param toggleSlot 快捷开关名称
   * @param info Plugin点击信息
   */
  showSubWindowByClickInfo(toggleSlot: string, info: PluginClickInfo): void {
    log.showInfo(`showSubWindowByClickInfo -> currentShowingSlot = ${this.currentShowingSlot}`);
    if (!CommonUtils.isEmpty(this.currentShowingSlot)) {
      log.showInfo(this.currentShowingSlot + ' is showing');
      return;
    }
    this.setShowingSlot(toggleSlot);
    this.currentClickInfo = info;
    sEventManager.publish(obtainLocalEvent('ControlCenterState', 2));
  }

  /**
   * 通过自定义的二级页信息subInfo显示窗口
   *
   * @param toggleSlot 快捷开关名称
   * @param info Plugin 点击信息
   * @param subInfo 二级页信息
   */
  public showCustomSubWindowByClick(toggleSlot: string, info: PluginClickInfo, subInfo: SubpageElementInfo): void {
    log.showInfo(`showSubWindowWithoutUIEByClick -> currentShowingSlot = ${this.currentShowingSlot}`);
    if (!CommonUtils.isEmpty(this.currentShowingSlot)) {
      log.showInfo(this.currentShowingSlot + ' is showing');
      return;
    }
    this.setShowingSlot(toggleSlot);
    this.currentClickInfo = info;
    this.currentSubInfo = subInfo;
    sEventManager.publish(obtainLocalEvent('ControlCenterState', 2));
  }

  /**
   * 设置当前展示的slot
   * @param toggleSlot
   */
  public setShowingSlot(toggleSlot: string): void {
    log.showInfo(`setShowingSlot current: ${this.currentShowingSlot} target: ${toggleSlot}`);
    this.currentShowingSlot = toggleSlot;
  }

  /**
   * 隐藏二级页面窗口
   *
   * @param toggleSlot 二级页面标识
   */
  hideWindow() {
    log.showInfo('hideSubWindow');
    sEventManager.publish(obtainLocalEvent('ControlCenterState', 0));
    this.setShowingSlot('');
    PluginComponentMgr.unregisterPushListener(this);
  }

  /**
   * 息屏时关闭窗口
   */
  onScreenOff() {
    this.hideWindow();
  }

  /**
   * 返回键，关闭窗口
   *
   * @return true 处理了返回事件，false 未消费事件
   */
  onBackPress(): boolean {
    log.showInfo('onBackPress, close subWindow');
    if (CommonUtils.isEmpty(this.currentShowingSlot)) {
      return false;
    }
    if (this.currentShowingSlot === FASlotName.WIFI_UI_EXTENSION) {
      performanceMonitor.begin('EXIT_CC_SUB_WIFI_ANI', performanceMonitor.ActionType.LAST_UP);
    } else if (this.currentShowingSlot === FASlotName.BLUETOOTH_UI_EXTENSION) {
      performanceMonitor.begin('EXIT_CC_SUB_BLUETOOTH_ANI', performanceMonitor.ActionType.LAST_UP);
    }
    this.hideWindow();
    return true;
  }

  /**
   * 是否是二级页面窗口
   *
   * @param windowName 窗口名称
   */
  isSubpageWindow(windowName: string): boolean {
    return this.subWindowInfo.has(windowName);
  }

  /**
   * 获取二级页面窗口配置
   *
   * @param slot 窗口的标识
   */
  getClickInfo(slot: string): PluginClickInfo | undefined {
    return this.subWindowInfo.get(slot)?.pluginParseInfo?.subPageClickInfo;
  }

  /**
   * 获取当前显示窗口的标识
   *
   * @return 当前显示的窗口的标识
   */
  getCurrentSubPanelSlot(): string {
    return this.currentShowingSlot;
  }

  /**
   * 获取当前点击跳转信息
   *
   * @return 当前点击跳转信息
   */
  getCurrentClickInfo(): PluginClickInfo | undefined {
    return this.currentClickInfo;
  }

  /**
   * 获取当前二级页信息
   *
   * @return 当前点击跳转信息
   */
  getSubpageElementInfo(): SubpageElementInfo | undefined {
    return this.currentSubInfo;
  }

  /**
   * 清除二级页信息
   */
  public clearSubpageInfo(): void {
    this.currentSubInfo = undefined;
    log.showInfo('clearSubpageInfo');
  }

  /**
   * 接收二级页面应用消息，关闭二级页面窗口
   *
   * @param pluginInfo 插件消息
   */
  onPush(pluginInfo: PluginComponentInfo) {
    log.showInfo('onPush');
    if (pluginInfo.pluginParseInfo.pluginSlot !== this.currentShowingSlot) {
      return;
    }
    if (pluginInfo.requestCloseWindow) {
      sDropDownPanelManager.hideWindowDirectly();
      this.hideWindow();
    }
  }
}

export let sToggleSubWindowController = SingletonHelper.getInstance(ToggleSubWindowController, TAG);