/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import type { ThemeStyleInfo } from '../bean/ThemeStyleInfo';
import { CommonConstants, DesktopMode } from '../constants/CommonConstants';
import { ThemeStyleManager } from '../manager/ThemeStyleManager';
import { ThemeStylePreviewManager } from '../manager/ThemeStylePreviewManager';
import { LayoutViewModel } from '../viewmodel/LayoutViewModel';
import { FolderModel } from '../folder/FolderModel';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { NumberConstants } from '@ohos/commonconstants';
import { IconCommonUtil } from './IconCommonUtil';

const TAG = 'RadiusUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MIN_RADIUS = CommonConstants.DEFAULT_ICON_RADIUS;

/**
 * Radius util.
 */
export class RadiusUtil {
  /**
   * Calculate icon radius.
   *
   * @param iconSize icon size.
   * @returns iconRadius.
   */
  public static calculateRadius(iconSize: number, desktopMode?: DesktopMode): number {
    try {
      // 如果主题包中设置了radius，则使用主题包资源
      let themeRadius = ResUtils.getConvertNumber($r('app.float.icon_radius'));
      if (themeRadius >= 0) {
        log.showInfo(`get theme radius: ${themeRadius}`);
        return themeRadius;
      }
    } catch (e) {
      log.showError(`getConvertNumber error: ${e?.message}`);
    }

    if (iconSize <= 0) {
      return CommonConstants.DEFAULT_ICON_RADIUS;
    }
    let themeStyle: ThemeStyleInfo;
    if (desktopMode && desktopMode === DesktopMode.PREVIEW_MODE) {
      themeStyle = ThemeStylePreviewManager.getInstance().getThemeStyle();
    } else {
      themeStyle = ThemeStyleManager.getInstance().getThemeStyle();
    }
    // 图标默认大小：54，默认圆角：14，图标大小变化时，圆角需要根据实际图标大小等比缩放
    let iconScale: number = iconSize / CommonConstants.DEFAULT_ICON_SIZE;
    if (desktopMode === DesktopMode.PREVIEW_MODE && themeStyle.iconSizeScale !== undefined) {
      let defaultIconSize: number = iconSize - themeStyle.iconSizeScale;
      if (defaultIconSize !== 0) {
        iconScale = iconSize / defaultIconSize;
      }
    }

    let iconRadius: number = CommonConstants.DEFAULT_ICON_RADIUS * iconScale;
    if (themeStyle.radiusSizeScale !== undefined) {
      iconRadius = MIN_RADIUS + themeStyle.radiusSizeScale * (iconSize / NumberConstants.CONSTANT_NUMBER_TWO - MIN_RADIUS);
    }
    return iconRadius;
  }

  /**
   * Calculate small form (1*2 or 2*1) radius.
   *
   * @param isInPreviewMode is in PreviewMode
   * @returns form radius
   */
  public static calculateSmallFormRadius(isInPreviewMode: boolean): number {
    const folderResult = LayoutViewModel.getInstance()
      .calculateFolder(FolderModel.getInstance().getBigFolderLayout(), isInPreviewMode);
    if (!folderResult) {
      log.showWarn('calculateFormRadius fail, folderResult is invalid.');
      return CommonConstants.INVALID_VALUE;
    }
    let radius: number = ((folderResult.mFolderRadius ?? 0) + (folderResult.mSmallFolderRadius ?? 0)) / NumberConstants.CONSTANT_NUMBER_TWO;
    return radius;
  }

  /**
   * Calculate big form radius.
   *
   * @param isInPreviewMode is in PreviewMode
   * @returns form radius
   */
  public static calculateBigFormRadius(isInPreviewMode: boolean): number {
    const bigFolderResult = LayoutViewModel.getInstance()
      .calculateFolder(FolderModel.getInstance().getBigFolderLayout(), isInPreviewMode);
    if (!bigFolderResult) {
      log.showWarn('calculateFormRadius fail, folderResult is invalid.');
      return CommonConstants.INVALID_VALUE;
    }
    return bigFolderResult.mFolderRadius ?? CommonConstants.INVALID_VALUE;
  }
}