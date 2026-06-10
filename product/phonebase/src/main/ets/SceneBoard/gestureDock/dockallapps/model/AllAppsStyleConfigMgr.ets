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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { GestureDockConstants } from '../../common/GestureDockConstants';
import { AllAppsConstants } from './AllAppsConstants';
import { AllAppsStyleConfig } from './AllAppsStyleConfig';

const TAG = 'AllAppsStyleConfig';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * allApps配置
 */
export class AllAppsStyleConfigMgr {
  /**
   * 获取style配置
   *
   * @returns AllAppsStyleConfig
   */
  public static getStyleConfig(): AllAppsStyleConfig {
    // 默认小图标规格
    let result: AllAppsStyleConfig = {
      nameWidth: AllAppsConstants.ALL_APPS_NAME_WIDTH,
      iconSize: AllAppsConstants.ALL_APPS_APP_SIZE,
      touchHotAreaSize: AllAppsConstants.ALL_APPS_NAME_WIDTH,
      gutter: AllAppsConstants.ALL_APPS_GUTTER,
      itemWidth: AllAppsConstants.ALL_APPS_APP_SIZE + GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS,
      itemHeight: AllAppsConstants.ALL_APPS_NAME_HEIGHT + AllAppsConstants.ALL_APPS_APP_SIZE +
      GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS,
      iconRadius: AllAppsConstants.ALL_APPS_ICON_RADIO,
    };
    log.showInfo(`getStyleConfig FoldExpandStatus:${desktopUtil.isFoldExpandStatus()}; isPad:${DeviceHelper.isPad()}`);
    if (desktopUtil.isFoldExpandStatus() || DeviceHelper.isPad()) {
      log.showInfo('getStyleConfig Larger result');
      // 折叠屏展开和PAD为大图标规格
      result = {
        nameWidth: AllAppsConstants.ALL_APPS_NAME_WIDTH_FOLDER,
        iconSize: AllAppsConstants.ALL_APPS_APP_SIZE_FOLDER,
        touchHotAreaSize: AllAppsConstants.ALL_APPS_NAME_WIDTH_FOLDER,
        gutter: AllAppsConstants.ALL_APPS_GUTTER,
        itemWidth: AllAppsConstants.ALL_APPS_APP_SIZE_FOLDER + GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS,
        itemHeight: AllAppsConstants.ALL_APPS_NAME_HEIGHT + AllAppsConstants.ALL_APPS_APP_SIZE_FOLDER +
        GestureDockConstants.GESTURE_DOCK_EDIT_ICON_ALL_APPS,
        iconRadius: AllAppsConstants.ALL_APPS_ICON_RADIO_FOLDER,
      };
    }
    return result;
  }
}