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

import { CommonUtils } from '@ohos/basicutils';
import { PluginConstants, PluginLocalInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { PluginProperty } from '../viewdata/PluginProperty';

/**
 * 当前应用plugin图标资源
 *
 * @since 2022-10-24
 */
export class PcLocalPluginStyle {

  /**
   * 最大自适应宽度
   */
  public static readonly STATUS_BAR_ICON_MAX_AUTO_WIDTH: Map<string, number> = new Map([
    [PluginSlot.SLOT_STATUS_CLOCK_PANEL, 200],
    [PluginSlot.SLOT_STATUS_SEARCH, 150]
  ])
  /**
   * 本地plugin图标资源解析
   *
   * @param pluginInfo 本地plugin信息
   */
  static parseLocalIconStyle(pluginInfo: PluginProperty): void {
    if (CommonUtils.isInvalid(pluginInfo) || !pluginInfo.pluginInfo?.pluginParseInfo?.isLocalPlugin) {
      return;
    }
    let info = pluginInfo.pluginInfo as PluginLocalInfo;
    let action = info.pluginParseInfo?.action;
    let slot = info.getSlot();
    let localIcon = PcLocalPluginStyle.getLocalIcons(action)?.get(slot);
    if (!CommonUtils.isInvalid(localIcon)) {
      info.icon = localIcon;
    }
    let maxAutoWidth = PcLocalPluginStyle.STATUS_BAR_ICON_MAX_AUTO_WIDTH.get(slot);
    if (!CommonUtils.isInvalid(maxAutoWidth)) {
      info.maxAutoWidth = maxAutoWidth;
    }
  }

  /**
   * 获取本地plugin图标集
   *
   * @param action plugin action
   * @return 图标集
   */
  static getLocalIcons(action: string): Map<string, Resource> | undefined {
    // TODO 控制中心本地图标
    if (action == PluginConstants.ACTION_PLUGIN_TOGGLE) {
      return new Map([]);
    }
    return undefined;
  }
}