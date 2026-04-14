/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { StyleConstants } from '../../TsIndex';
import { AppIconModel } from '../common/AppIconModel';

export enum AppBadgeStyleType {
  DEFAULT,
  SMALLER_ICON,
  FUSION_ICON,
  SMALLER_FUSION_ICON
}

export interface CloneBadgeStyle {
  width: number;
  height: number;
  offsetX: number;
  offsetY: number;
}

const ICON_SHADOW_OPTIONS: ShadowOptions = {
  radius: StyleConstants.APP_ICON_SHADOW_RADIUS,
  color: StyleConstants.APP_ICON_SHADOW_COLOR,
  offsetY: StyleConstants.APP_ICON_SHADOW_OFFSETY
};

export class AppIconStyleConfig {
  private static readonly cloneBadgeStyle: Map<AppBadgeStyleType, CloneBadgeStyle> =
    new Map<AppBadgeStyleType, CloneBadgeStyle>([
    [AppBadgeStyleType.DEFAULT, { width: 18, height: 18, offsetX: 6, offsetY: 2 }],
    [AppBadgeStyleType.SMALLER_ICON, { width: 14, height: 14, offsetX: 3, offsetY: 1 }],
    [AppBadgeStyleType.FUSION_ICON, { width: 32, height: 18, offsetX: 6, offsetY: 2 }],
    [AppBadgeStyleType.SMALLER_FUSION_ICON, { width: 25, height: 14, offsetX: 3, offsetY: 1 }],
  ]);

  public static getCloneBadgeStyle(iconType: AppBadgeStyleType): CloneBadgeStyle {
    return AppIconStyleConfig.cloneBadgeStyle.get(iconType) as CloneBadgeStyle;
  }

  public static getIconBadgeInvisible(bundleName: string): boolean {
    return AppIconModel.getInstance().isIconBadgeInvisible(bundleName);
  }

  public static getIconShadowOptions(extraLimits: boolean = true): ShadowOptions | null {
    if (AppIconModel.getInstance().isEnableIconShadow(extraLimits)) {
      return ICON_SHADOW_OPTIONS;
    }
    return null;
  }
}