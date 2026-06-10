/**
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

import { CommonConstants } from '../constants/CommonConstants';
import { image } from '@kit.ImageKit';

/**
 * Item info of long press menu.
 */
export class MenuInfo {
  /**
   * Item type. see CommonConstants.MENU_TYPE_FIXED and CommonConstants.MENU_TYPE_DYNAMIC.
   */
  public menuType: number = CommonConstants.MENU_TYPE_FIXED;

  /**
   * Image source for this item.
   */
  public menuImgSrc: string | image.PixelMap | Resource = '';

  /**
   * Menu text for this item.
   */
  public menuText: string | Resource | null = null;

  hoverTips?: string;

  /**
   * 标注menu唯一key.
   */
  public menuKeyString?: string;

  /**
   * True if this item is enabled.
   */
  public menuEnabled = true;

  /**
   * Callback when item is clicked.
   */
  public onMenuClick: Function | undefined | null;

  /**
   * shortcut icon Id
   */
  public shortcutIconId = CommonConstants.INVALID_VALUE;

  /**
   * shortcut label Id
   */
  public shortcutLabelId = CommonConstants.INVALID_VALUE;

  /**
   * bundleName
   */
  public bundleName: string | undefined;

  /**
   * moduleName
   */
  public moduleName: string | undefined;

  /**
   * subMenuList
   */
  public subMenuList: MenuInfo[] = [];

  /**
   * ID of shortcut
   */
  public shortcutId?: string;

  /**
   * Shortcut key prompt
   */
  public shortcutKeyTips?: string;

  /**
   * menuAbility
   */
  public menuAbility?: string;
}
