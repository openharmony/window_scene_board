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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiDfxEventUtil, IconResourceManager, onLineThemeUtil } from '@ohos/frameworkwrapper';
import {
  AppIconModel,
  AppItemInfo,
  AppStatus,
  CommonConstants,
  ShortcutViewModel,
  StyleConstants
} from '../../TsIndex';
import { AppIconConfig } from '../config/AppIconConfig';
import { AppIconResIface } from '../interface/AppIconResIface';
import { AppIconData } from './AppIconData';

const TAG = 'AppIconResConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);

export interface AppIconResConfigParam {
  iconData: AppIconData;
  iconConfig: AppIconConfig;
}

export class AppIconResConfig implements AppIconResIface {
  private isIconReady: boolean = false;

  public async initIconImage(itemInfo: AppItemInfo, iconData: AppIconData): Promise<void> {
    if (!itemInfo || !iconData) {
      log.showError('initIconImage failed, itemInfo or iconData is invalid!');
      return;
    }

    this.isIconReady = false;
    iconData.isDynamicIcon = AppIconModel.getInstance().isDynamicIcon(itemInfo);
    iconData.isOnlineTheme = onLineThemeUtil.isOnlineTheme();
    log.showInfo(`init icon image bundleName:${itemInfo.bundleName}, appIndex:${itemInfo.appIndex}, ` +
      `typeId:${itemInfo.typeId}, shortcutId:${itemInfo.shortcutId}, isDynamicIcon:${iconData.isDynamicIcon}, ` +
      `isOnlineTheme:${iconData.isOnlineTheme}, appStatus:${itemInfo.appStatus}, ` +
      `iconResource is invalid:${CheckEmptyUtils.checkStrIsEmpty(itemInfo.iconResource)}`);
    if (iconData.isDynamicIcon) {
      iconData.image = '';
      this.loadStaticCache(itemInfo);
      this.isIconReady = true;
      return;
    }

    let image: string | image.PixelMap = await this.getNonDynamicImage(itemInfo, iconData);
    if (this.isValidIcon(image)) {
      iconData.image = image;
    } else {
      // 设置默认四叶草图标
      iconData.image = StyleConstants.DEFAULT_ICON;
      log.showError(`init icon image empty, use default icon, bundleName: ${itemInfo.bundleName}`);
    }
    this.isIconReady = true;
  }

  private loadStaticCache(itemInfo: AppItemInfo): void {
    // 三级缓存中提前缓存时钟静态资源, 用于文件夹大到小动效
    if (itemInfo.bundleName === CommonConstants.CLOCK_BUNDLE) {
      IconResourceManager.getInstance().getCombIcon(
        itemInfo.bundleName, itemInfo.moduleName, itemInfo.abilityName, undefined, 'loadStaticCache');
    }
  }

  public async reInitIconImage(itemInfo: AppItemInfo, iconData: AppIconData): Promise<void> {
    if (!itemInfo || !iconData) {
      log.showError('reInitIconImage failed, itemInfo or iconData is invalid!');
      return;
    }

    if (!this.isIconReady) {
      // 正在获取图标资源，无需重新获取
      return;
    }

    let isValidIcon: boolean = this.isValidIcon(iconData.image);
    log.showWarn(`bundleName:${itemInfo.bundleName}, isValidIcon:${isValidIcon}, imageSrc is empty:${!iconData.image}`);
    if (!isValidIcon) {
      await this.initIconImage(itemInfo, iconData);
    }
  }

  private async getNonDynamicImage(itemInfo: AppItemInfo, iconData: AppIconData): Promise<string | image.PixelMap> {
    if (!itemInfo || !iconData) {
      log.showError('getNonDynamicImage failed, itemInfo or iconData is invalid!');
      return '';
    }

    if (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      return await ShortcutViewModel.getInstance().getShortcutImageAsync(itemInfo);
    }

    if (itemInfo.appStatus === AppStatus.INSTALLED ||
      (itemInfo.appStatus === AppStatus.UPDATING && !iconData?.image) || !itemInfo.iconResource) {
      return await this.loadIconResourceByCache(itemInfo);
    }
    return itemInfo.iconResource as string;
  }

  private async loadIconResourceByCache(itemInfo: AppItemInfo): Promise<image.PixelMap> {
    let iconSrc: image.PixelMap = await IconResourceManager.getInstance().getCombIcon(
      itemInfo.bundleName, itemInfo.moduleName, itemInfo.abilityName, itemInfo.appIndex, TAG,
      false);

    if (CheckEmptyUtils.isEmptyPixelMap(iconSrc)) {
      // 如果获取到的PixelMap无效则重新获取一次
      log.showError(`getCombIcon is invalid, will try again, bundleName: ${itemInfo.bundleName}`);
      await IconResourceManager.getInstance().deleteIconResource(itemInfo.bundleName);
      iconSrc = await IconResourceManager.getInstance().getCombIcon(
        itemInfo.bundleName, itemInfo.moduleName, itemInfo.abilityName, itemInfo.appIndex, TAG,
        false);
    }
    // iconSrc重试获取后仍然异常打点上报
    if (CheckEmptyUtils.isEmptyPixelMap(iconSrc)) {
      log.showError(`loadIconResourceByCache is invalid, bundleName: ${itemInfo.bundleName}`);
      HiDfxEventUtil.reportIconStatusAbnormal('get icon from cache failed', itemInfo.bundleName);
    }
    return iconSrc;
  }

  private isValidIcon(iconSrc: string | image.PixelMap): boolean {
    if (typeof iconSrc === 'string') {
      return !CheckEmptyUtils.checkStrIsEmpty(iconSrc);
    } else {
      return !CheckEmptyUtils.isEmptyPixelMap(iconSrc);
    }
  }
}