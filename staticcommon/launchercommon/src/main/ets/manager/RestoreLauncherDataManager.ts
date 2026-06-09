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

import { AppItemInfo, AppStatus, CommonConstants } from '../TsIndex';
import { image } from '@kit.ImageKit';
import fileuri from '@ohos.file.fileuri';
import fs from '@ohos.file.fs';
import preferences from '@ohos.data.preferences';
import { CommonUtils, LogDomain, LogHelper, PixelMapUtil } from '@ohos/basicutils/src/main/ets/TsIndex';
import {
  GlobalContext,
  Nullable,
  RdbStoreConfig,
  rdbStoreHelper,
  sSettingsUtil
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import type ctx from '@ohos.app.ability.common';
import rdb from '@ohos.data.relationalStore';
import GridLayoutInfoColumns from '../db/column/GridLayoutInfoColumns';
import { GraphicUtils } from '@ohos/frameworkwrapper';
import { settings } from '@kit.BasicServicesKit';

const TAG: string = 'RestoreLauncherDataManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.BACKUP, TAG);
const ICONS_DIR = '/RestoreIconData/';
const UPGRADE_ICONS_DIR = '/oldIcons/';
const ICONS_COMPATIBILITY = 'deal_clone_icons_scale_compatibility';
const UPGRADE_ICONS_COMPATIBILITY = 'deal_upgrade_icons_scale_compatibility';

/**
 * 克隆占位管理类
 *
 * @since 2025-01-09
 */
export class RestoreLauncherDataManager {
  private static instance: RestoreLauncherDataManager;

  private readonly filesDir: string =
    (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.filesDir;

  static getInstance(): RestoreLauncherDataManager {
    if (RestoreLauncherDataManager.instance == null) {
      RestoreLauncherDataManager.instance = new RestoreLauncherDataManager();
    }
    return RestoreLauncherDataManager.instance;
  }

  /**
   * 处理克隆图标兼容性
   *
   * @param path 图标路径
   * @returns 图标URI
   */
  public async dealCloneIconsCompatibility(context: ctx.ServiceExtensionContext): Promise<void> {
    this.setShortcutSupportCloneFlag();
    let compatibilityType: string = sSettingsUtil.getValue(ICONS_COMPATIBILITY, CompatibilityType.NONE, context);
    if (compatibilityType === CompatibilityType.COMPLETED) {
      // 读settingsdata，判断是否处理过兼容性
      log.showDebug(`icon compatibility has been processed, compatibilityType: ${compatibilityType}`);
      return;
    }
    log.showWarn(`start processing icon compatibility`);
    let count: number = 0;
    const resultList: AppItemInfo[] = await this.queryCloneIconsUri();
    try {
      for (const item of resultList) {
        if (!item || !item.iconResource || item.iconResource.indexOf(ICONS_DIR) === -1) {
          // icon_resource为/RestoreIconData/ 的占位图标路径
          log.showDebug(`the icon resource path is abnormal, iconResource: ${item.iconResource}`);
          continue;
        }
        count++;
        await this.getIconScaleUri(item.iconResource);
        log.showDebug(`icon resource after enlargement: ${item.iconResource}`);
      }
    } catch (err) {
      log.error('dealCloneIconsCompatibility err:', err);
    }
    sSettingsUtil.setValue(ICONS_COMPATIBILITY, CompatibilityType.COMPLETED, context);
    log.showWarn(`icon compatibility processing completed, length: ${resultList.length}, count: ${count}`);
  }

  /**
   * 处理升级图标兼容性
   *
   * @param path 图标路径
   * @returns
   */
  public async dealUpgradeIconsCompatibility(context: ctx.ServiceExtensionContext): Promise<void> {
    let compatibilityType: string = sSettingsUtil.getValueEx(settings.domainName.USER_PROPERTY, UPGRADE_ICONS_COMPATIBILITY, CompatibilityType.NONE, context);
    if (compatibilityType === CompatibilityType.COMPLETED) {
      // 读settingsdata，判断是否处理过兼容性
      log.showDebug(`upgrade icon compatibility has been processed, compatibilityType: ${compatibilityType}`);
      return;
    }
    log.showWarn(`start processing upgrade icon compatibility`);
    let count: number = 0;
    const resultList: AppItemInfo[] = await this.queryCloneIconsUri();
    try {
      for (const item of resultList) {
        if (!item || CommonUtils.isEmpty(item.iconResource) ||
          item.iconResource.indexOf(UPGRADE_ICONS_DIR) === CommonConstants.INVALID_VALUE) {
          // icon_resource为/oldIcons/的占位图标路径
          log.showDebug(`the icon resource path is abnormal, iconResource: ${item.iconResource}`);
          continue;
        }
        count++;
        await this.scaleIconUri(item.iconResource);
      }
    } catch (err) {
      log.error('dealUpgradeIconsCompatibility err:', err);
    }
    sSettingsUtil.setValueEx(settings.domainName.USER_PROPERTY, UPGRADE_ICONS_COMPATIBILITY, CompatibilityType.COMPLETED, context);
    log.showWarn(`upgrade icon compatibility processing completed, length: ${resultList.length}, count: ${count}`);
  }

  /**
   * 将图标放大后原路径写回
   *
   * @param path 图标路径
   * @returns
   */
  public async scaleIconUri(iconUri: string): Promise<void> {
    let pixelMap: image.PixelMap | null = null;
    try {
      pixelMap = await this.loadImageFromDisk(iconUri);
      if (pixelMap) {
        const size: image.Size = pixelMap.getImageInfoSync().size;
        await pixelMap.scale(CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE,
          CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE);
        let region: image.Region = {
          x: (CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE - 1) * size.width / 2,
          y: (CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE - 1) * size.height / 2,
          size: { height: size.height, width: size.width }
        };
        // 裁剪多余部分
        await pixelMap.crop(region);
        await this.saveImage2Disk(iconUri, pixelMap);
        return;
      }
    } catch (err) {
      log.error('getIconScaleUri err', err);
    } finally {
      pixelMap?.release();
    }
    return;
  }

  /**
   * 设置快捷方式支持克隆的标价位，带上了该标记版本，支持应用内加桌的快捷方式克隆
   *
   */
  private setShortcutSupportCloneFlag(): void {
    try {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      const preference: preferences.Preferences =
        preferences.getPreferencesSync(context, { name: 'DESKTOP_LAYOUT_INFO' });
      preference.putSync(CommonConstants.SHORTCUT_CLONE, CommonConstants.SHORTCUT_CLONE_FLAG);
      preference.flushSync();
      log.showWarn(`setShortcutSupportCloneFlag success`);
    } catch (error) {
      log.showError(`setShortcutSupportCloneFlag failed ${error}`, );
    }
  }

  private async queryCloneIconsUri(): Promise<AppItemInfo[]> {
    const resultList: AppItemInfo[] = [];
    let resultSet: rdb.ResultSet | undefined = undefined;
    try {
      // 查询gridlayout_info表的appstatus为9的占位图标路径
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.gridLayoutInfo.tableName);
      predicates.equalTo(GridLayoutInfoColumns.APP_STATUS, AppStatus.WAIT_FOR_HARMONY);
      predicates.and().equalTo(GridLayoutInfoColumns.TYPE_ID, CommonConstants.TYPE_APP);
      resultSet =
        await rdbStoreHelper.query(predicates, [GridLayoutInfoColumns.ICON_RESOURCE, GridLayoutInfoColumns.INTENT]);
      while (resultSet && resultSet.goToNextRow()) {
        let appItemInfo = new AppItemInfo();
        appItemInfo.iconResource = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.ICON_RESOURCE));
        appItemInfo.intent = resultSet.getString(resultSet.getColumnIndex(GridLayoutInfoColumns.INTENT));
        resultList.push(appItemInfo);
      }
    } catch (err) {
      log.error('queryCloneIconsUri err :', err);
    } finally {
      resultSet?.close();
      resultSet = undefined;
    }
    return resultList;
  }

  /**
   * 获取放大后的图标URI
   *
   * @param path 图标路径
   * @returns 图标URI
   */
  public async getIconScaleUri(iconUri: string): Promise<string> {
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      pixelMap = await this.loadImageFromDisk(iconUri);
      if (pixelMap) {
        const size: image.Size = pixelMap.getImageInfoSync().size;
        await pixelMap.scale(CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE,
          CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE);
        let region: image.Region = {
          x: (CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE - 1) * size.width / 2,
          y: (CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE - 1) * size.height / 2,
          size: { height: size.height, width: size.width }
        };
        // 裁剪多余部分
        await pixelMap.crop(region);
        let srcUriObject = new fileuri.FileUri(iconUri);
        let dstPath: string = this.filesDir + ICONS_DIR + srcUriObject.name;
        await this.saveImage2Disk(dstPath, pixelMap);
        let dstUriObject = new fileuri.FileUri(dstPath);
        let nameIndex: number = iconUri.lastIndexOf('/');
        let pixelMapName: string = iconUri.substring(nameIndex + 1);
        PixelMapUtil.addName(pixelMap, CommonConstants.SOURCE_CLONE + '_' + pixelMapName);
        return dstUriObject.toString();
      }
    } catch (err) {
      log.error('getIconScaleUri err', err);
    } finally {
      pixelMap?.release();
    }
    return '';
  }

  /**
   * 快捷方式图标转base64
   *
   * @param iconUri 图标路径
   * @returns string base64图标资源
   */
  public async getShortcutIcon(iconUri: string): Promise<string> {
    let pixelMap: image.PixelMap | undefined = undefined;
    try {
      pixelMap = await this.loadImageFromDisk(iconUri);
      if (pixelMap) {
        return await GraphicUtils.changePixelToBase64(pixelMap);
      }
    } catch (err) {
      log.error('getIconScaleUri err', err);
    } finally {
      pixelMap?.release();
    }
    return '';
  }

  /**
   * 根据路径加载图片
   *
   * @param path 图片路径
   * @param format 格式
   * @returns 图片资源
   */
  private async loadImageFromDisk(path: string,
    format: image.PixelMapFormat = image.PixelMapFormat.RGBA_8888): Promise<image.PixelMap | undefined> {
    if (!path || !fs.access(path)) {
      log.showWarn('fail to access path');
      return undefined;
    }
    let fd: number = -1;
    try {
      fd = fs.openSync(path, fs.OpenMode.READ_ONLY).fd;
      const imageSource: image.ImageSource = image.createImageSource(fd);
      const imageItem = await imageSource.createPixelMap({
        desiredPixelFormat: format,
      });
      await imageSource.release();
      return imageItem;
    } catch (e) {
      log.error('loadImageFromDisk error', e);
    } finally {
      if (fd !== -1) {
        fs.closeSync(fd);
      }
    }
    return undefined;
  }


  /**
   * 将图标存入硬盘
   *
   * @param fullPath 图标路径
   * @param pixelMap 图标pixelMap
   */
  public async saveImage2Disk(fullPath: string, pixelMap: image.PixelMap): Promise<void> {
    let file: Nullable<fs.File> | undefined;
    try {
      const imagePacker = image.createImagePacker();
      const imageBuffer = await imagePacker.packing(pixelMap, {
        format: 'image/png',
        quality: 100,
      });
      imagePacker.release();
      const mode = fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE;
      file = await fs.open(fullPath, mode);
      await fs.truncate(file.fd);
      await fs.write(file.fd, imageBuffer);
    } catch (e) {
      log.error('Save image failed', e);
    } finally {
      if (file) {
        try {
          await fs.close(file);
        } catch (e) {
          log.error('Failed to close file', e);
        }
      }
    }
  }
}

/**
 * 兼容性类型
 *
 * @since 2025-01-09
 */
export enum CompatibilityType {
  /**
   * 未处理过兼容性
   */
  NONE = '0',
  /**
   * 已处理过兼容性
   */
  COMPLETED = '1',
}