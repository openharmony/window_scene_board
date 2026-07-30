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

import { CommonConstants, DesktopMode } from '../constants/CommonConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { NumberConstants } from '@ohos/commonconstants';

const TAG = 'RadiusUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/** 卡片默认圆角（与 app.float.form_corner_radius 一致），避免跟圆形图标半径联动 */
const DEFAULT_FORM_CORNER_RADIUS = 16;

/**
 * Radius util.
 */
export class RadiusUtil {
  /**
   * Calculate icon radius.
   * 桌面图标统一圆形：圆角取图标边长一半。
   *
   * @param iconSize icon size.
   * @returns iconRadius.
   */
  public static calculateRadius(iconSize: number, desktopMode?: DesktopMode): number {
    if (iconSize <= 0) {
      return CommonConstants.DEFAULT_ICON_RADIUS;
    }
    // 圆形背景：radius = size / 2（忽略主题圆角配置，统一圆形）
    return iconSize / NumberConstants.CONSTANT_NUMBER_TWO;
  }

  /**
   * Calculate small form (1*2 or 2*1) radius.
   * 卡片保持原规格，不随圆形图标/文件夹半径变化。
   *
   * @param isInPreviewMode is in PreviewMode
   * @returns form radius
   */
  public static calculateSmallFormRadius(isInPreviewMode: boolean): number {
    return RadiusUtil.getFormCornerRadius();
  }

  /**
   * Calculate big form radius.
   * 卡片保持原规格，不随圆形图标/文件夹半径变化。
   *
   * @param isInPreviewMode is in PreviewMode
   * @returns form radius
   */
  public static calculateBigFormRadius(isInPreviewMode: boolean): number {
    return RadiusUtil.getFormCornerRadius();
  }

  private static getFormCornerRadius(): number {
    try {
      let themeRadius = ResUtils.getConvertNumber($r('app.float.form_corner_radius'));
      if (themeRadius > 0) {
        return themeRadius;
      }
    } catch (e) {
      log.showError(`get form_corner_radius error: ${e?.message}`);
    }
    return DEFAULT_FORM_CORNER_RADIUS;
  }
}
