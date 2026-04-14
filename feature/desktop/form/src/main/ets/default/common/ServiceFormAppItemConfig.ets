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

import { image } from '@kit.ImageKit';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import { ResourceManager, DeviceHelper, IconResourceManager } from '@ohos/frameworkwrapper';
import {
  CommonConstants,
  layoutConfigManager,
  SettingsModel,
  StyleConstants
} from '@ohos/launchercommon';
import FormStyleConstants from './constants/FormStyleConstants';
import { NoIconAppInfo, NoIconAppModel } from '@ohos/launchercommon/src/main/ets/model/NoIconAppModel';

const TAG = 'ServiceFormAppItemConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const DEFAULT_DESKTOP_ICON_SIZE = 58;
const DEFAULT_DESKTOP_ICON_RADIUS = 16;

@Observed
export class AppItemStyle {
  public icon: string | PixelMap | Resource = '';
  public appName: string = '';
}

export class ServiceAppItemInfo {
  public bundleName: string = '';
  public abilityName: string = '';
  public moduleName: string = '';
  public appLabelId: number = 0;
  public iconId: number = 0;
}

interface ServiceFormAppItemImageStyle {
  border: BorderOptions;
  imageIcon: Resource | string;
  fillColor: ResourceColor;
}

interface ServiceFormAppItemTextStyle {
  fontColor: ResourceColor;
}

interface ServiceFormAppItemStyle {
  imageStyle: ServiceFormAppItemImageStyle;
  textStyle: ServiceFormAppItemTextStyle;
}

export class ServiceFormAppItemConfig {
  private mResourceManager: ResourceManager = ResourceManager.getInstance();
  private static instance: ServiceFormAppItemConfig;
  private formAppIconSize: number = FormStyleConstants.FORM_SERVICE_APP_ICON_SIZE_WIDTH;
  private defaultAppIcon: string = '';

  static getInstance(): ServiceFormAppItemConfig {
    if (!ServiceFormAppItemConfig.instance) {
      ServiceFormAppItemConfig.instance = new ServiceFormAppItemConfig();
    }
    return ServiceFormAppItemConfig.instance;
  }

  static getServiceFormAppItemStyle(): ServiceFormAppItemStyle {
    if (DeviceHelper.isPhoneOrPad()) {
      return PHONE_STYLE;
    } else {
      return PC_STYLE;
    }
  }

  static imageStyle(): ServiceFormAppItemImageStyle {
    return ServiceFormAppItemConfig.getServiceFormAppItemStyle().imageStyle;
  }

  static textStyle(): ServiceFormAppItemTextStyle {
    return ServiceFormAppItemConfig.getServiceFormAppItemStyle().textStyle;
  }

  public getServiceFormAppItemImageRadius(): number {
    let formAppRadius: number = CommonConstants.DEFAULT_PC_FORM_CENTER_ICON_RADIUS;
    if (DeviceHelper.isPhone()) {
      formAppRadius = this.formAppIconSize / DEFAULT_DESKTOP_ICON_SIZE * DEFAULT_DESKTOP_ICON_RADIUS;
    }
    return formAppRadius;
  }

  public updateIcon(appItemInfo: ServiceAppItemInfo, appItemStyle: AppItemStyle): void {
    if (appItemInfo.bundleName && appItemInfo.moduleName) {
      IconResourceManager.getInstance().getCombIcon(appItemInfo.bundleName, appItemInfo.moduleName,
        appItemInfo?.abilityName, undefined, 'CombIcon_ServiceFormAppItem').then((iconResource: string | PixelMap) =>
      this.iconLoadCallback(appItemInfo, iconResource, appItemStyle));
    }
  }

  public updateNoIconAppInfo(bundle: string, appItemStyle: AppItemStyle): void {
    let noIconAppInfo: NoIconAppInfo = NoIconAppModel.getInstance().updateNoIconAppInfo(bundle);
    appItemStyle.appName = bundle === CommonConstants.SCENEBOARD_BUNDLE ?
      ResourceManager.getInstance().getStringByName('lock_screen') : noIconAppInfo.label;
    IconResourceManager.getInstance().getCombIcon(bundle).then((icon: image.PixelMap) => {
      appItemStyle.icon = icon;
    });
  }

  public updateName(appItemInfo: ServiceAppItemInfo, appItemStyle: AppItemStyle): void {
    if (CheckEmptyUtils.isEmpty(appItemStyle.appName)) {
      this.mResourceManager.getAppNameWithCache(appItemInfo.appLabelId, appItemInfo.bundleName, appItemInfo.moduleName,
        appItemStyle.appName, (name: string): void => this.appNameLoadCallback(name, appItemStyle));
    }
  }

  public updateSearchResult(matchedText: string, appItemStyle: AppItemStyle): string[] {
    let searchResult: string[] = [];
    let index: number = appItemStyle.appName.toLocaleLowerCase().indexOf(matchedText);
    if (CheckEmptyUtils.checkStrIsEmpty(matchedText) ||　index === -1) {
      return searchResult;
    }

    searchResult = [appItemStyle.appName.slice(0, index), appItemStyle.appName.slice(index, index + matchedText.length),
      appItemStyle.appName.slice(index + matchedText.length)];
    log.showDebug(`matchedText: ${matchedText}, searchResult: ${searchResult}`);
    return searchResult;
  }

  public updateNameWhenLanguageChange(appItemInfo: ServiceAppItemInfo, appItemStyle: AppItemStyle): void {
    this.mResourceManager.getAppNameWithCache(appItemInfo.appLabelId, appItemInfo.bundleName, appItemInfo.moduleName,
      appItemStyle.appName, (name: string): void => this.appNameLoadCallback(name, appItemStyle));
  }

  private appNameLoadCallback(name: string, appItemStyle: AppItemStyle): void {
    appItemStyle.appName = name;
  }

  private iconLoadCallback(appItemInfo: ServiceAppItemInfo, image: string | PixelMap,
                           appItemStyle: AppItemStyle): void {
    log.showInfo(`iconLoadCallback bundleName: ${appItemInfo.bundleName}, abilityName: ${appItemInfo.abilityName}`);
    if (SettingsModel.getInstance().getDevice() === CommonConstants.PAD_DEVICE_TYPE &&
      appItemInfo.bundleName === CommonConstants.LAUNCHER_BUNDLE) {
      appItemStyle.icon = this.getDefaultAppIcon(appItemInfo);
    } else {
      appItemStyle.icon = image;
    }
  }

  private getDefaultAppIcon(appItemInfo: ServiceAppItemInfo): string {
    if (appItemInfo.abilityName === CommonConstants.APPCENTER_ABILITY) {
      return StyleConstants.DEFAULT_ALL_APP_IMAGE;
    } else if (appItemInfo.abilityName === CommonConstants.RECENT_ABILITY) {
      return StyleConstants.DEFAULT_TASK_IMAGE;
    } else {
      return this.defaultAppIcon;
    }
  }
}

const PHONE_STYLE: ServiceFormAppItemStyle = {
  imageStyle: {
    border: { width: '1px', color: '#33808080' },
    imageIcon: $r('sys.media.ohos_ic_public_arrow_right'),
    fillColor: $r('sys.color.ohos_id_color_fourth')
  },
  textStyle: {
    fontColor: $r('sys.color.ohos_id_color_text_primary')
  }
};

export const PC_STYLE: ServiceFormAppItemStyle = {
  imageStyle: {
    border: {},
    imageIcon: '/common/pics/ic_arrow_right.svg',
    fillColor: ''
  },
  textStyle: {
    fontColor: $r('sys.color.ohos_id_color_text_primary_contrary')
  }
};
