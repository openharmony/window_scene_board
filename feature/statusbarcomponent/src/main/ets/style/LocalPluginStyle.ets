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
import {
    PluginConstants,
    PluginInfo,
    PluginLocalInfo,
    PluginSlot,
    DeviceHelper
} from '@ohos/frameworkwrapper';

/**
 * 当前应用plugin图标资源
 *
 * @since 2022-10-24
 */
export class LocalPluginStyle {

    /**
     * 状态栏local图标，Phone
     * plugin slot => 图标资源
     */
    public static readonly STATUS_BAR_ICON_PHONE: Map<string, Resource> = new Map([]);

    /**
     * 最大自适应宽度
     */
    public static readonly STATUS_BAR_ICON_MAX_AUTO_WIDTH: Map<string, number> = new Map([
        [PluginSlot.LIVE_VIEW_CAPSULE, 1000]
    ])

    /**
     * 本地plugin图标资源解析
     *
     * @param pluginInfo 本地plugin信息
     */
    public static parseLocalIconStyle(pluginInfo: PluginInfo): void {
        if (CommonUtils.isInvalid(pluginInfo) || !pluginInfo.pluginParseInfo?.isLocalPlugin) {
            return;
        }
        let info = pluginInfo as PluginLocalInfo;
        let action = info.pluginParseInfo?.action;
        let slot = info.pluginParseInfo?.pluginSlot;
        let localIcon = LocalPluginStyle.getLocalIcons(action)?.get(slot);
        if (!CommonUtils.isInvalid(localIcon)) {
            info.icon = localIcon;
        }
        let maxAutoWidth = LocalPluginStyle.STATUS_BAR_ICON_MAX_AUTO_WIDTH.get(slot);
        if (!CommonUtils.isInvalid(maxAutoWidth)) {
            info.maxAutoWidth = maxAutoWidth;
        }
        // TODO 状态栏 label
    }

    /**
     * 获取本地plugin图标集
     *
     * @param action plugin action
     * @return 图标集
     */
    public static getLocalIcons(action: string): Map<string, Resource> | undefined {
        // TODO 控制中心本地图标
        if (action == PluginConstants.ACTION_PLUGIN_TOGGLE) {
            return new Map([]);
        }
        // 状态栏区分PC、Phone
        if (DeviceHelper.isPC()) {
            return undefined;
        }
        return LocalPluginStyle.STATUS_BAR_ICON_PHONE;
    }
}