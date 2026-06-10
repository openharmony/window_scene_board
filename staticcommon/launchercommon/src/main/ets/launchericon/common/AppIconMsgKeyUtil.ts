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

import { LogDomain, LogHelper, StartType } from '@ohos/basicutils';
import { AppData } from '@ohos/windowscene';
import { AppItemInfo, CommonConstants } from '../../TsIndex';

const TAG = 'AppIconMsgKeyUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

class AppIconMsgKeyUtil {
  private static instance: AppIconMsgKeyUtil;
  private constructor() {}
  
  public static getInstance(): AppIconMsgKeyUtil {
    if (!AppIconMsgKeyUtil.instance) {
      AppIconMsgKeyUtil.instance = new AppIconMsgKeyUtil();
    }
    return AppIconMsgKeyUtil.instance;
  }
  
  public getIconContainerOpacityKey(itemInfo: AppItemInfo, appData?: AppData): string {
    if (!itemInfo) {
      log.showError('getIconContainerOpacityKey failed, itemInfo is invalid!');
      return 'Opacity_AppIconRelative';
    }

    if (appData?.startAppType === StartType.RECENT_DOCK_APP) {
      return `Opacity_AppIconRelative_${itemInfo.keyName}${appData.extraId ?? ''}`;
    }

    return `Opacity_AppIconRelative_${itemInfo.keyName}`;
  }
  
  public getIconAnimBackToIconKey(itemInfo: AppItemInfo, appData?: AppData): string {
    if (!itemInfo) {
      log.showError('getIconAnimBackToIconKey failed, itemInfo is invalid!');
      return `${CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON}`;
    }
    
    if (appData?.startAppType === StartType.RECENT_DOCK_APP) {
      return `${CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON}${itemInfo.keyName}${appData.extraId ?? ''}`;
    }
    
    return `${CommonConstants.EVENTHUB_ANIMATE_BACK_TO_ICON}${itemInfo.keyName}`;
  }
  
  public getItemAccessibilityClickKey(itemInfo: AppItemInfo): string {
    if (!itemInfo) {
      log.showError('getItemAccessibilityClickKey failed, itemInfo is invalid!');
      return 'appItemAccessibilityClick';
    }
    
    return `appItemAccessibilityClick${itemInfo.keyName}`;
  }
}

export const appIconMsgKeyUtil: AppIconMsgKeyUtil = AppIconMsgKeyUtil.getInstance();
