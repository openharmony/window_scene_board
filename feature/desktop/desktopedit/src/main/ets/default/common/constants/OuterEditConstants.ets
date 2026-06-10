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

import { EditModeUtils } from '@ohos/launchercommon';

/**
 * 常量类
 */
export default class OuterEditConstants {

  // 背板相对于导航条偏移量
  public static readonly BG_TRANSLATE_Y: number = -10;

  /**
   * 新形态小折叠编辑模式右侧addPage按钮尺寸
   */
  public static readonly PAGE_EDIT_BUTTON_SIZE: number = 32;

  /**
   * 新形态小折叠编辑模式右侧addPage按钮内图标尺寸
   */
  public static readonly PAGE_EDIT_BUTTON_ICON_SIZE: number = 16;

  /**
   * 背板弧度
   */
  public static readonly BORDER_RADIUS: number = 18;

  /**
   * 背板至导航条距离
   */
  public static readonly TRANSLATE_Y: number = -10;

  /**
   * 拖动提示语顶部距离
   */
  public static readonly DRAG_TIPS_TOP_MARGIN: number = 11;

  /**
   * 外屏新增页Y轴距离
   */
  public static readonly ADD_BLANK_PAGE_TRANSLATE_Y: number = -4;

  /**
   * 获取外屏编辑模式背板弧度
   *
   * @param screenWidth 屏幕宽度
   * @returns 背板弧度
   */
  public static getBgBorderRadius(screenWidth?: number): number {
    if (!screenWidth) {
      screenWidth = AppStorage.get<number>('screenWidth') as number;
    }
    return OuterEditConstants.BORDER_RADIUS / EditModeUtils.calEditModeScale(screenWidth);
  }
}