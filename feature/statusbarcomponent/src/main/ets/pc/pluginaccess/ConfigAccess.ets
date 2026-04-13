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
import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  PluginClickType,
  PluginConstants, PluginInfo,
  PluginSlot,
  PluginStatusBarEvent,
  HideAppConfigLoadEvent,
  PluginType,
  PluginWindowType} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { StatusBarEventManager } from '../manager/StatusBarEventManager';
import { PluginAccessBase } from './PluginAccessBase';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
import { PcStatusBarIconManager } from '../manager/PcStatusBarIconManager';
import { Constants } from '../common/Constants';
import { GetHideAppsFromConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/GetHideAppsFromConfig';

const TAG = 'ConfigAccess';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

const LOCATION_BUNDLE_NAME = 'com.ohos.security.privacycenter';
const LOCATION_ABILITY_NAME = 'LocationIndicatorDetailingAbility';

/**
 * 本地图标或通过配置文件方式接入
 */
export class ConfigAccess extends PluginAccessBase {
  protected initDiff(): void {
    StatusBarEventManager.getInstance()
      .on(TAG, PluginStatusBarEvent, this.handlePluginEvent)// 注册状态栏plugin解析事件
    StatusBarEventManager.getInstance()
      .on(TAG, HideAppConfigLoadEvent, this.handleHideAppConfigLoadEvent)// 注册隐藏应用配置加载事件
    log.showInfo(`StatusBarEventManager on`);
  }

  /**
   * 处理状态栏plugin解析事件
   *
   * @param event 事件
   */
  private handlePluginEvent = (event: PluginStatusBarEvent): void => {
    log.showInfo('handlePluginEvent type: ' + event.eventType + ' length:' + event.pluginInfos.length);
    this.checkRemoveHideAppPlugins(event.pluginInfos);
    switch (event.eventType) {
      // 查询全部
      case PluginConstants.EVENT_TYPE_QUERY_ALL:
        this.handleQueryAllPlugins(event);
        break;
      // 新增plugin
      case PluginConstants.EVENT_TYPE_ADD_PLUGIN:
      // 更新plugin
      case PluginConstants.EVENT_TYPE_UPDATE_PLUGIN:
        // 直接更新数据
        this.handleAddOrUpdatePlugins(event);
        break;
      // 删除plugin
      case PluginConstants.EVENT_TYPE_DELETE_PLUGIN:
        this.handleRemovePlugins(event);
        break;
      default:
        break;
    }
  }

  private handleRemovePlugins(event: PluginStatusBarEvent) {
    this.notifyRemoveData(event.pluginInfos);
  }

  private handleAddOrUpdatePlugins(event: PluginStatusBarEvent) {
    this.notifyUpdateData(event.pluginInfos);
  }

  private handleQueryAllPlugins(event: PluginStatusBarEvent) {
    // 移除多余的plugin图标
    this.checkRemoveOldMorePlugins(event.pluginInfos);
    this.dealLocalPlugin(event.pluginInfos);
    this.notifyAddData(event.pluginInfos);

    let dynamicInfos = event.pluginInfos.filter(plugin => plugin.getSlot() != PluginSlot.SLOT_STATUS_LOCATION &&
      PluginType.isPluginType(plugin?.pluginParseInfo.pluginType));
    PcStatusBarIconManager.getInstance().initPluginInfo(dynamicInfos);
  }

  /**
   * 本地图标包名等相关信息替换
   * @param pluginInfos
   */
  private dealLocalPlugin(pluginInfos: PluginInfo[]): void {
    pluginInfos.forEach((pluginInfo) => {
      // 位置图标单独处理
      if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_LOCATION) {
        pluginInfo.pluginParseInfo.clickInfo.clickType = PluginClickType.TYPE_WINDOW;
        pluginInfo.pluginParseInfo.bundleName = LOCATION_BUNDLE_NAME;
        pluginInfo.pluginParseInfo.clickInfo.abilityName = LOCATION_ABILITY_NAME;
        pluginInfo.pluginParseInfo.pluginType = PluginType.PLUGIN_TYPE_MESSAGE;
        pluginInfo.pluginParseInfo.clickInfo.windowType = PluginWindowType.TYPE_LARGE;
        pluginInfo.pluginParseInfo.clickInfo.windowHeight = 160;
      }
      if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_USB) {
        pluginInfo.pluginParseInfo.pluginType = PluginType.PLUGIN_TYPE_MESSAGE;
        pluginInfo.pluginParseInfo.clickInfo.windowType = PluginWindowType.TYPE_LARGE;
        pluginInfo.pluginParseInfo.clickInfo.windowHeight = Constants.POPUP_MIN_TEXT_WIDTH;
      }
      if (pluginInfo.pluginParseInfo.pluginSlot === PluginSlot.SLOT_STATUS_ENTERPRISE_SPACE) {
        pluginInfo.pluginParseInfo.pluginType = PluginType.PLUGIN_TYPE_MESSAGE;
      }
    });
  }

  /**
   * 移除企业定制隐藏的plugin图标
   *
   * @param pluginInfos 当前最新plugin集
   */
  private checkRemoveHideAppPlugins(pluginInfos: PluginInfo[]): void {
    const getHideAppsFromConfig = GetHideAppsFromConfig.getInstance();
    if (!getHideAppsFromConfig.loadStatus) {
      log.showInfo(`checkRemoveHideAppPlugins: ${getHideAppsFromConfig.loadStatus}`);
      return;
    }
    let filterArr = pluginInfos.filter(pluginInfo =>
    getHideAppsFromConfig.isHideApp(pluginInfo.pluginParseInfo.bundleName));
    filterArr.forEach((info) => {
      ArrayUtils.delete(pluginInfos, info);
    });
  }

  /**
   * 隐藏应用配置加载事件回调函数
   *
   * @param HideAppConfigLoadEvent 隐藏应用配置加载事件
   */
  private handleHideAppConfigLoadEvent = (event: HideAppConfigLoadEvent): void => {
    log.showInfo(`handleHideAppConfigLoadEvent`);
    if (!event || !event.loadStatus) {
      return;
    }
    let moreArr: PluginInfo[] = PluginListAdapter.getInstance().getAllData().filter(info =>
    GetHideAppsFromConfig.getInstance().isHideApp(info.pluginInfo?.pluginParseInfo.bundleName))
      .map(plugin => plugin.pluginInfo!);
    if (moreArr.length === 0) {
      return;
    }
    this.notifyRemoveData(moreArr);
  }

  /**
   * 移除老的多余的plugin图标
   *
   * @param pluginInfos 当前最新plugin集
   */
  private checkRemoveOldMorePlugins(pluginInfos: PluginInfo[]): void {
    // 多余的图标
    let moreArr: PluginInfo[] = PluginListAdapter.getInstance().getAllData().filter(info => info.pluginInfo &&
      info.isConfigOrLocalPlugin() && !ArrayUtils.contains(pluginInfos, info.pluginInfo))
        .map(plugin => plugin.pluginInfo!);
    if (moreArr.length == 0) {
      return;
    }
    this.notifyRemoveData(moreArr);
  }

  protected deInitDiff(): void {
    StatusBarEventManager.getInstance().offAll(TAG);
  }
}