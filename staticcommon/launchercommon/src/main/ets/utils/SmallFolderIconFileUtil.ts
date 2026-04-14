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

import { GlobalContext } from '@ohos/frameworkwrapper';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import type { BusinessError } from '@ohos.base';
import { desktopUtil, RTLUtil } from '@ohos/componenthelper';
import { FolderCommonUtil, FolderManager, GridLayoutItemInfo } from '../TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'SmallFolderIconFileUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * smallFolder icon file util
 */
export class SmallFolderIconFileUtil {
  /**
   * small folder endPage tag
   */
  public static readonly END_PAGE_IMAGE: string = '_end';

  /**
   * small folder Expand tag
   */
  public static readonly Expand_PAGE_IMAGE: string = '_expand';

  /**
   * rtl language tag
   */
  public static readonly RTL_PAGE_IMAGE: string = '_rtl';

  static getIconKey(folderId: string, isEndPage: boolean): string {
    return folderId + (isEndPage ? SmallFolderIconFileUtil.END_PAGE_IMAGE : '') +
      (isEndPage && desktopUtil.isFoldExpandStatus() ? SmallFolderIconFileUtil.Expand_PAGE_IMAGE : '') +
      (RTLUtil.isRTL() ? SmallFolderIconFileUtil.RTL_PAGE_IMAGE : '');
  }

  /**
   * Check if the file exists.
   *
   * @param folderId - folderId
   * @return boolean true(Exist)
   */
  static isIconFileExist(folderId: string): Promise<boolean> {
    let filePath = SmallFolderIconFileUtil.getFolderIconPath(folderId);
    return fs.access(filePath);
  }

  /**
   * 检查文件夹是否存在
   *
   * @param folderId 文件夹id
   * @returns true(Exist)
   */
  public static isIconFileExistSync(folderId: string): boolean {
    let filePath = SmallFolderIconFileUtil.getFolderIconPath(folderId);
    return fs.accessSync(filePath);
  }

  /**
   * load smallFolder icon from file by path
   *
   * @param folderId folderId
   * @returns smallFolder icon
   */
  static loadIconFromPath(folderId: string): Promise<image.PixelMap> {
    let filePath = SmallFolderIconFileUtil.getFolderIconPath(folderId);
    log.showDebug(TAG, `loadIconFromPath folderId = ${folderId}`);
    const imageSource = image.createImageSource(filePath);
    let decodingOptions = {
      editable: false,
      pixelFormat: 3,
    };
    return imageSource.createPixelMap(decodingOptions).then((pixelMap: image.PixelMap) => {
      imageSource.release();
      return pixelMap;
    }) ;
  }

  /**
   * get smallFolder icon file path
   *
   * @param folderId
   * @returns file path
   */
  static getFolderIconPath(folderId: string): string {
    return `${GlobalContext.getContext().cacheDir}/` + folderId + '.png';
  }

  /**
   * delete smallFolder icon file
   *
   * @param folderId folderId
   */
  static deleteIcon(folderId: string): void {
    SmallFolderIconFileUtil.isIconFileExist(folderId).then((isExist) => {
      if (isExist) {
        let filePath = SmallFolderIconFileUtil.getFolderIconPath(folderId);
        log.showDebug(TAG, `deleteFolderIcon folderId = ${folderId}`);
        fs.unlink(filePath).then(() => {
          log.showDebug(TAG, 'deleteFolderIcon unlink success');
        }).catch((err: BusinessError) => {
          log.showError(TAG, 'deleteFolderIcon unlink fail %{public}d:%{public}s', err.code, err.message);
        });
      }
    });
  }

  /**
   * delete firstPage and endPage smallFolder icon file
   *
   * @param folderId folderId
   */
  static deleteFolderIcon(folderId: string): void {
    SmallFolderIconFileUtil.deleteIcon(folderId);
    SmallFolderIconFileUtil.deleteIcon(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE);
    SmallFolderIconFileUtil.deleteIcon(folderId + SmallFolderIconFileUtil.RTL_PAGE_IMAGE);
    SmallFolderIconFileUtil.deleteIcon(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE +
      SmallFolderIconFileUtil.RTL_PAGE_IMAGE);
    SmallFolderIconFileUtil.deleteIcon(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE +
      SmallFolderIconFileUtil.Expand_PAGE_IMAGE);
    SmallFolderIconFileUtil.deleteIcon(folderId + SmallFolderIconFileUtil.END_PAGE_IMAGE +
      SmallFolderIconFileUtil.Expand_PAGE_IMAGE + SmallFolderIconFileUtil.RTL_PAGE_IMAGE);
  }

  /**
   * write smallFolder icon file
   *
   * @param folderId folderId
   * @param iconPixmap PixelMap
   */
  static async writeFolderIcon(folderId: string, iconPixmap: image.PixelMap): Promise<void> {
    let filePath = SmallFolderIconFileUtil.getFolderIconPath(folderId);
    log.showDebug(TAG, `writeFolderIcon folderId = ${folderId}`);
    let file = fs.openSync(filePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    const imagePackerApi = image.createImagePacker();
    let packOpts = { format: 'image/png', quality: 100 } as image.PackingOption;
    try {
      const data = await imagePackerApi.packing(iconPixmap, packOpts);
      let writeLen = fs.writeSync(file.fd, data);
      log.showDebug(TAG, `smallFolder icon write Len = ${writeLen}`);
      imagePackerApi.release();
    } catch (err) {
      let errInfo: BusinessError = err as BusinessError;
      log.showError(TAG, 'smallFolder icon write fail %{public}d:%{public}s', errInfo?.code, errInfo?.message);
    } finally {
      fs.closeSync(file);
    }
  }

  /**
   * 生成appListKey
   *
   * @param isEndPage 是否是最后一页
   * @param appList 应用列表
   * @param themeStyle 主题
   * @param desktopIconChange 图标样式
   * @returns key值
   */
  public static generateAppListKey(isEndPage: boolean, appList: GridLayoutItemInfo[]): string {
    let appListKey: string = RTLUtil.isRTL() +
      (isEndPage && desktopUtil.isFoldExpandStatus() ? SmallFolderIconFileUtil.Expand_PAGE_IMAGE : '');
    let themeStyle: string = FolderManager.getInstance().getThemeStyle();
    let desktopIconChange: number = FolderManager.getInstance().getDesktopIconChange();
    let sum: number = 0;
    // 获取小文件夹截图最大显示图标数量
    let maxShowNum: number = FolderCommonUtil.getContractedFolderMaxShowIconNum([1, 1]);
    for (let listItem of appList) {
      appListKey =
        `${appListKey}${listItem.appIconId}${listItem.keyName}${listItem.iconResource}_${themeStyle}${desktopIconChange}`;
      sum++;
      if (sum >= maxShowNum) {
        log.showError('the appList length is more than %{public}d', maxShowNum);
        break;
      }
    }
    return appListKey;
  }
}