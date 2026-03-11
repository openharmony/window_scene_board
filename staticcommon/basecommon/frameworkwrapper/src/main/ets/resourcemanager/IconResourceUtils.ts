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
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
  PixelMapUtil,
  Trace
} from '@ohos/basicutils';
import { BundleResourceInfo, LauncherAbilityResourceInfo } from '@ohos/windowsceneinterfaces';
import { bundleResourceManager } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import { resourceManager } from '@kit.LocalizationKit';
import { DrawableDescriptor } from '@kit.ArkUI';
import { SCBConstants } from '@ohos/commonconstants';
import IconInfo from './IconInfo';
import {
  bundleManagerFwk,
  CheckTransparentUtils,
  GlobalContext,
  GraphicUtils,
  HiSysEventUtil,
  IconExtendParam,
  IconPicType
} from '../TsIndex';

const TAG: string = 'IconResourceUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export class IconResourceUtils {
  static getResourceInfo(bundleName: string, moduleName: string, abilityName: string,
    appIndex: number): BundleResourceInfo | LauncherAbilityResourceInfo | undefined {
    let resourceFlag = bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_DRAWABLE_DESCRIPTOR;

    if (appIndex > 0) {
      // 分身图标资源获取flag需要加上GET_RESOURCE_INFO_WITH_ICON
      resourceFlag = resourceFlag | bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_ICON;
    }

    if (!CheckEmptyUtils.isEmpty(moduleName) && !CheckEmptyUtils.isEmpty(abilityName)) {
      log.showWarn(`getIconResource from bms getLauncherAbilityResourceInfo for ${bundleName} ${appIndex}`);
      return bundleResourceManager.getLauncherAbilityResourceInfo(bundleName, resourceFlag, appIndex)
          .find((curInfo) => curInfo.bundleName === bundleName && curInfo.moduleName === moduleName &&
            curInfo.abilityName === abilityName);
    }
    log.showWarn(`getIconResource from bms getBundleResourceInfo for ${bundleName} ${appIndex}`);
    return bundleResourceManager.getBundleResourceInfo(bundleName, resourceFlag, appIndex);
  }
}