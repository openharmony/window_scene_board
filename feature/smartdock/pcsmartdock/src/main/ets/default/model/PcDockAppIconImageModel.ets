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

import { AppItemInfo, CommonConstants,
  ShortcutViewModel,
  StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { image } from '@kit.ImageKit';
import { AppIconData } from '@ohos/launchercommon/src/main/ets/launchericon/viewmodel/AppIconData';
import {
  bundleManagerFwk,
  DeviceHelper,
  GlobalContext,
  GraphicUtils, IconResourceManager,
  memoryCache,
  ResourceManager} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import drawableDescriptor, { LayeredDrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import { effectKit } from '@kit.ArkGraphics2D';
import IconInfo, { IconPicType } from '@ohos/frameworkwrapper/src/main/ets/resourcemanager/IconInfo';
import { CheckEmptyUtils, CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import type ctx from '@ohos.app.ability.common';

const TAG = 'PcDockAppIconImageModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

export class PcDockAppIconImageModel {
  private backgroundDescriptor: string | drawableDescriptor.DrawableDescriptor =
    new drawableDescriptor.DrawableDescriptor();
  private foregroundDescriptor: string | drawableDescriptor.DrawableDescriptor =
    new drawableDescriptor.DrawableDescriptor();
  private _iconBorderRadius: number;

  constructor(iconBorderRadius: number) {
    this._iconBorderRadius = iconBorderRadius;
  }

  private isPcResidentAbility(abilityName: string): boolean {
    return abilityName === CommonConstants.APPCENTER_ABILITY ||
      abilityName === CommonConstants.RECENT_ABILITY ||
      abilityName === CommonConstants.RECYCLE_BIN_ABILITY;
  }

  // 判断是否为分层日历图标，只有Pc-dock支持分层图标
  private isAdaptiveCalendarIcon(item: AppItemInfo, iconData: AppIconData): boolean {
    return iconData.isDynamicIcon && item.bundleName === CommonConstants.CALENDAR_BUNDLE;
  }

  private getPresetForeground(item: AppItemInfo): Resource | string {
    let foregroundResource: Resource | string = $r('app.media.adaptive_appcenter_foreground');
    switch (item.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        foregroundResource = $r('app.media.adaptive_appcenter_foreground');
        break;
      case CommonConstants.RECENT_ABILITY:
        foregroundResource = $r('app.media.adaptive_multitask_foreground');
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        const isRecycleBinEmpty: boolean | undefined = AppStorage.get<boolean>('isDockRecycleBinEmpty');
        if (isRecycleBinEmpty) {
          foregroundResource = StyleConstants.DEFAULT_RECYCLE_BIN_FOREGROUND_IMAGE;
        } else {
          foregroundResource = StyleConstants.DEFAULT_RECYCLE_BIN_FULL_FOREGROUND_IMAGE;
        }
        break;
      default:
        break;
    }
    return foregroundResource;
  }

  private getPcResidentIconName(item: AppItemInfo) {
    let iconName: string = '';
    switch (item.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        iconName = 'adaptive_appcenter_foreground';
        break;
      case CommonConstants.RECENT_ABILITY:
        iconName = 'adaptive_multitask_foreground';
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        iconName = 'adaptive_recycle_bin_foreground';
        break;
      default:
        break;
    }
    return iconName;
  }

  private getPresetBackground(item: AppItemInfo): Resource | string {
    let backgroundResource: Resource | string = $r('app.media.adaptive_appcenter_background');
    switch (item.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        backgroundResource = $r('app.media.adaptive_appcenter_background');
        break;
      case CommonConstants.RECENT_ABILITY:
        backgroundResource = $r('app.media.adaptive_multitask_background');
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        backgroundResource = StyleConstants.DEFAULT_RECYCLE_BIN_BACKGROUND_IMAGE;
        break;
      default:
        break;
    }
    return backgroundResource;
  }

  private async createShadowPixelMap(foregroundPixelMap: image.PixelMap,
      itemInfo: AppItemInfo, iconData: AppIconData): Promise<void> {
    let effectPixelMap: image.PixelMap | null = null;
    let lastShadowImage: image.PixelMap | null = iconData.shadowImagePixel as image.PixelMap;
    try {
      const filter = effectKit.createEffect(foregroundPixelMap)?.blur(this._iconBorderRadius);
      effectPixelMap = await filter.getEffectPixelMap();
      if (effectPixelMap) {
        iconData.shadowImagePixel = await effectPixelMap?.createAlphaPixelmap();
        ResourceManager.getInstance().setEffectKitCache(
          itemInfo?.appIconId, itemInfo?.abilityName, iconData.shadowImagePixel);
        log.showInfo(`createShadowPixelMap set shadowPixelmap,  ${itemInfo.bundleName}`);
      }
    } catch (e) {
      log.showError(`createShadowPixelMap error`, e);
    } finally {
      effectPixelMap?.release();
      lastShadowImage?.release();
    }
  }

  private createPcResidentShadowPixelMap(itemInfo: AppItemInfo, iconData: AppIconData): void {
    const residentShadowImagePixel: image.PixelMap = ResourceManager.getInstance().getCachedEffectKit(
      itemInfo.appIconId, itemInfo.abilityName);
    if (residentShadowImagePixel) {
      iconData.shadowImagePixel = residentShadowImagePixel;
      return;
    }

    const iconName = this.getPcResidentIconName(itemInfo);
    getContext().resourceManager.getMediaByName(iconName).then((value: Uint8Array) => {
      const buffer: ArrayBufferLike = value.buffer;
      const imageSource: image.ImageSource = image.createImageSource(buffer as ArrayBuffer);
      if (imageSource != undefined) {
        imageSource.createPixelMap().then((sourcePixelMap) => {
          if (sourcePixelMap != null) {
            this.createShadowPixelMap(sourcePixelMap, itemInfo, iconData).then(() => {
              sourcePixelMap?.release();
            });
          }
          imageSource?.release();
        }).catch((error: Error) => {
          imageSource?.release();
          log.showError(`${itemInfo.bundleName} createPixelMap ${error?.message}`);
        })
      }
    }).catch((error: Error) => {
      log.showError(`${itemInfo.bundleName} getMediaByName ${error?.message}`);
    });
  }

  private updateBackgroundImage(item: AppItemInfo, iconData: AppIconData): void {
    if (this.isPcResidentAbility(item.abilityName)) {
      iconData.backgroundImagePixel = this.getPresetBackground(item);
      return;
    }
    if (this.isAdaptiveCalendarIcon(item, iconData)) {
      iconData.backgroundImagePixel = ResourceManager.getInstance().getPixelMapByResourceName('ic_calendar_background',
        item.bundleName, item.moduleName);
      if (!CheckEmptyUtils.isEmptyPixelMap(iconData.backgroundImagePixel)) {
        log.showInfo('get calendar background ok');
        return;
      }
    }
    iconData.backgroundImagePixel = this.backgroundDescriptor;
  }

  private async updateForegroundImage(item: AppItemInfo, iconData: AppIconData): Promise<void> {
    if (this.isPcResidentAbility(item.abilityName)) {
      iconData.foregroundImagePixel = this.getPresetForeground(item);
      return;
    }
    iconData.isHighResolutionImage = true;
    if (this.isAdaptiveCalendarIcon(item, iconData)) {
      if (iconData.foregroundImagePixel) {
        log.showInfo('get calendar foreground image ok');
        // 日历图标时通过截图获取的，无需再做缩放
        return;
      }
      log.showError('get calendar foreground image error');
    }
    iconData.foregroundImagePixel = this.foregroundDescriptor;
  }

  private async createShadow(pixelStr: string, item: AppItemInfo, iconData: AppIconData): Promise<void> {
    let imageSource: image.ImageSource | null = null;
    let pixelMap: image.PixelMap | null = null;
    try {
      imageSource = image.createImageSource(pixelStr);
      pixelMap = await imageSource.createPixelMap();
      await this.createShadowPixelMap(pixelMap, item, iconData);
    } catch (e) {
      log.showError(`createShadow error`, e);
    } finally {
      imageSource?.release();
      pixelMap?.release();
    }
  }

  public async updateCalendarShadowImage(item: AppItemInfo, iconData: AppIconData): Promise<void> {
    log.showInfo(`isDynamicIcon: bundleName: ${item?.bundleName}`);
    if (item) {
      if (this.isAdaptiveCalendarIcon(item, iconData)) {
        // 日历图标阴影直接通过前景图生成
        await this.createShadowPixelMap(iconData.foregroundImagePixel as PixelMap, item, iconData);
        if (iconData.shadowImagePixel) {
          log.showInfo('create calendar shadow ok');
          return;
        }
        log.showInfo('create calendar shadow error');
      }
    }
  }

  private async updateShadowImage(item: AppItemInfo, iconData: AppIconData): Promise<void> {
    log.showInfo(`isDynamicIcon: ${iconData.isDynamicIcon}, bundleName: ${item.bundleName}`);
    if (item) {
      this.updateCalendarShadowImage(item, iconData);
      iconData.shadowImagePixel = ResourceManager.getInstance().getCachedEffectKit(item.appIconId,
        item.abilityName);
      if (!iconData.shadowImagePixel) {
        this.createShadow(this.foregroundDescriptor as string, item, iconData);
      };
    }
  }

  public async iconLoadCallback(image: IconInfo | string | PixelMap | LayeredDrawableDescriptor,
    isAdaptive: boolean, item: AppItemInfo, iconData: AppIconData): Promise<void> {
    if (item) {
      log.showInfo('iconLoadCallback icon isAdaptive=%{public}s, item.bundleName=%{public}s item.iconId=%{public}d',
        isAdaptive, item.bundleName, item.appIconId);
    } else {
      log.showError('iconLoadCallback item is null');
      return;
    }
    if (isAdaptive) {
      if (image instanceof LayeredDrawableDescriptor) {
        log.showInfo('iconLoadCallback image is type of LayeredDrawableDescriptor');
        const layerDescriptor: LayeredDrawableDescriptor = image as LayeredDrawableDescriptor;
        const backgroundDescriptor: drawableDescriptor.DrawableDescriptor = layerDescriptor.getBackground();
        const foregroundDescriptor: drawableDescriptor.DrawableDescriptor = layerDescriptor.getForeground();
        if (!backgroundDescriptor || !foregroundDescriptor) {
          log.showInfo('iconLoadCallback backgroundDescriptor=%{public}s, foregroundDescriptor=%{public}s', backgroundDescriptor, foregroundDescriptor);
          return;
        }
        this.backgroundDescriptor = backgroundDescriptor;
        this.updateBackgroundImage(item, iconData);
        this.foregroundDescriptor = foregroundDescriptor;
        this.updateForegroundImage(item, iconData);
      } else {
        log.showInfo('iconLoadCallback image is type of IconInfo');
        let adaptiveIcon: IconInfo = image as IconInfo;
        this.backgroundDescriptor = adaptiveIcon.adaptivePic[0];
        this.updateBackgroundImage(item, iconData);
        this.foregroundDescriptor = adaptiveIcon.adaptivePic[1];
        this.updateForegroundImage(item, iconData).then(() => this.updateShadowImage(item, iconData));
      }
    } else {
      iconData.image = image as string | PixelMap;
    }
  }

  private isValidIcon(iconSrc: string | image.PixelMap): boolean {
    if (typeof iconSrc === 'string') {
      return !CheckEmptyUtils.checkStrIsEmpty(iconSrc);
    } else {
      return !CheckEmptyUtils.isEmptyPixelMap(iconSrc);
    }
  }

  private getPcResidentIconDescriptor(itemInfo: AppItemInfo): LayeredDrawableDescriptor | undefined {
    let imageDescriptor: LayeredDrawableDescriptor | undefined = undefined;
    switch (itemInfo.abilityName) {
      case CommonConstants.APPCENTER_ABILITY:
        let foregroundApp: DrawableDescriptor =
          getContext().resourceManager.getDrawableDescriptor($r('app.media.adaptive_appcenter_foreground'))
        let backgroundApp: DrawableDescriptor =
          getContext().resourceManager.getDrawableDescriptor($r('app.media.adaptive_appcenter_background'));
        imageDescriptor = new LayeredDrawableDescriptor(foregroundApp, backgroundApp);
        break;
      case CommonConstants.RECENT_ABILITY:
        let foregroundRecent: DrawableDescriptor =
          getContext().resourceManager.getDrawableDescriptor($r('app.media.adaptive_multitask_foreground'))
        let backgroundRecent: DrawableDescriptor =
          getContext().resourceManager.getDrawableDescriptor($r('app.media.adaptive_multitask_background'));
        imageDescriptor = new LayeredDrawableDescriptor(foregroundRecent, backgroundRecent);
        break;
      case CommonConstants.RECYCLE_BIN_ABILITY:
        let foregroundRecycle: DrawableDescriptor =
          getContext().resourceManager.getDrawableDescriptor($r('app.media.adaptive_recycle_bin_foreground_full_pc'))
        const isRecycleBinEmpty: boolean | undefined = AppStorage.get<boolean>('isDockRecycleBinEmpty');
        if (isRecycleBinEmpty) {
          foregroundRecycle =
            getContext().resourceManager.getDrawableDescriptor($r('app.media.adaptive_recycle_bin_foreground_pc'))
        }
        let backgroundRecycle: DrawableDescriptor =
          getContext().resourceManager.getDrawableDescriptor($r('app.media.adaptive_recycle_bin_background_pc'));
        imageDescriptor = new LayeredDrawableDescriptor(foregroundRecycle, backgroundRecycle);
        break;
      default:
        break;
    }
    return imageDescriptor;
  }

  public async getPcResidentIconResource(itemInfo: AppItemInfo, iconData: AppIconData,
    iconSize: number): Promise<void> {
    let imageDescriptor: LayeredDrawableDescriptor | undefined = this.getPcResidentIconDescriptor(itemInfo);
    if (!imageDescriptor) {
      this.updateBackgroundImage(itemInfo, iconData);
      this.updateForegroundImage(itemInfo, iconData)
      return;
    }
    let maskImage = bundleManagerFwk.getMaskImage();
    let adaptivePic = await GraphicUtils.getForeGroundBackGroundBase64(itemInfo.bundleName, iconSize, imageDescriptor,
      maskImage);
    log.showInfo(`getIconResource getForeGroundBackGroundBase64 ${itemInfo.abilityName}, ${adaptivePic.length}`);
    if (!CommonUtils.containerIsEmpty(adaptivePic) && !CheckEmptyUtils.isEmpty(adaptivePic[0])) {
      iconData.isHighResolutionImage = true;
      this.backgroundDescriptor = adaptivePic[0];
      iconData.backgroundImagePixel = this.backgroundDescriptor;
      this.foregroundDescriptor = adaptivePic[1];
      iconData.foregroundImagePixel = this.foregroundDescriptor;
      if (itemInfo.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
        let resultInfo: IconInfo = new IconInfo();
        resultInfo.iconType = IconPicType.ADAPTIVE;
        resultInfo.adaptivePic = adaptivePic;
        log.showInfo(`setIconResourceBySize bundleName: ${itemInfo?.bundleName}, moduleName: ${itemInfo?.moduleName},` +
          `abilityName: ${itemInfo?.abilityName}, iconSize: ${iconSize}`);
        memoryCache.setIconResourceBySize(itemInfo.bundleName, itemInfo.moduleName, itemInfo.abilityName,
          iconSize, resultInfo);
      }
    } else {
      this.updateBackgroundImage(itemInfo, iconData);
      this.updateForegroundImage(itemInfo, iconData)
      return;
    }
  }

  public async updateIcon(itemInfo: AppItemInfo, iconData: AppIconData, iconSize: number): Promise<void> {
    if (itemInfo.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let image: string | image.PixelMap = await ShortcutViewModel.getInstance().getShortcutImageAsync(itemInfo);
      if (!this.isValidIcon(image)) {
        image = StyleConstants.DEFAULT_ICON;
        log.showError(`init icon image empty, use default icon, bundleName: ${itemInfo.bundleName}`);
      }
      this.iconLoadCallback(image, false, itemInfo, iconData);
      return;
    }
    if (this.isPcResidentAbility(itemInfo.abilityName)) {
      iconData.isLayeredIcons = true;
      this.createPcResidentShadowPixelMap(itemInfo, iconData);
      if (DeviceHelper.is2In1DevicePcType()) {
        this.getPcResidentIconResource(itemInfo, iconData, iconSize);
      } else {
        this.updateBackgroundImage(itemInfo, iconData);
        this.updateForegroundImage(itemInfo, iconData);
      }
      return;
    }
    const icon: IconInfo = await IconResourceManager.getInstance().getIconResourceBySize(itemInfo.bundleName,
      itemInfo.moduleName, itemInfo.abilityName, iconSize);
    iconData.isLayeredIcons = icon.iconType === IconPicType.ADAPTIVE ? true : false;
    log.showInfo(`updateIcon bundleName: ${itemInfo.bundleName}, isLayeredIcons: ${iconData.isLayeredIcons}`);
    if (iconData.isLayeredIcons) {
      await this.iconLoadCallback(icon, iconData.isLayeredIcons, itemInfo, iconData);
    } else {
      // 如果异常，再次获取图标
      if (CheckEmptyUtils.isEmpty(icon.combinePic)) {
        const image: image.PixelMap = await IconResourceManager.getInstance().getCombIcon(itemInfo.bundleName,
          itemInfo.moduleName, itemInfo.abilityName);
        if (CheckEmptyUtils.isEmptyPixelMap(image)) {
          icon.combinePic = StyleConstants.DEFAULT_ICON;
          log.showError(`init icon image empty, use default icon, bundleName: ${itemInfo.bundleName}`);
        } else {
          icon.combinePic = await GraphicUtils.changePixelToBase64(image);
        }
      }
      await this.iconLoadCallback(icon.combinePic, iconData.isLayeredIcons, itemInfo, iconData);
    }
  }
}