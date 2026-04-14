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
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { PluginInfo, PluginType, PluginWindowType } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { PluginProperty } from '../viewdata/PluginProperty';

const TAG = 'StyleChangeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class PluginUtils {

  /**
   * 是否需要动态胶囊二级面板
   *
   * @param pluginInfo
   * @returns
   */
  public static needDynamicPluginPanel(pluginInfo: PluginInfo): boolean {
    // 检测点击类型为窗口类型
    if (!PluginUtils.hasClickWindow(pluginInfo)) {
      return false;
    }
    // 本地plugin，无需使用AbilityComponent窗口
    if (PluginUtils.isLocalPlugin(pluginInfo)) {
      return false;
    }
    // 非动态胶囊
    if (!PluginType.isPluginType(pluginInfo?.pluginParseInfo?.pluginType)) {
      return false;
    }
    let clickInfo = pluginInfo?.pluginParseInfo?.clickInfo;
    let windowWidth = PluginWindowType.getWindowWidth(clickInfo.windowType);
    if (windowWidth == 0) {
      log.showWarn('checkoutClickWindow window type invalid');
      return false;
    }
    return true;
  }

  /**
   * 判断图标是否有对应的点击弹窗
   *
   * @param info 图标信息
   */
  public static hasClickWindow(info: PluginInfo | null): boolean {
    if (CommonUtils.isInvalid(info)) {
      return false;
    }
    return info!.hasClickWindow();
  }

  /**
   * 判断图标是否为本应用内部图标
   *
   * @param info 图标信息
   */
  public static isLocalPlugin(info: PluginInfo): boolean {
    if (CommonUtils.isInvalid(info) || CommonUtils.isInvalid(info.pluginParseInfo)) {
      return false;
    }
    return info.pluginParseInfo.isLocalPlugin;
  }

  public static getAccessPluginKey(plugin: PluginProperty): string {
    if (plugin.pluginInfo?.pluginParseInfo.instanceKey === '') {
      return plugin.pluginInfo?.pluginParseInfo.bundleName;
    }
    return plugin.pluginInfo?.pluginParseInfo.bundleName + ' ' +
      plugin.pluginInfo?.pluginParseInfo.instanceKey;
  }
}