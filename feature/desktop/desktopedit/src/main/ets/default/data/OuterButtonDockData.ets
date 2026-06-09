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

import i18n from '@ohos.i18n';
import { EditModeDockConstants } from '../common/constants/EditModeStyleConstants';
import { SmallFoldStyleUtil } from '@ohos/launchercommon/src/main/ets/utils/SmallFoldStyleUtil';

// 定义语言常量
const SIMPLIFIED_CHINESE: string = 'zh-Hans';
const ENGLISH: string = 'en-Latn';

/**
 * 设置编辑模式按钮字体尺寸
 */
@Observed
export class OuterButtonDockData {
  private static instance: OuterButtonDockData;
  /**
   * 设置按钮文字的最大放大倍率：
   * 简体中文1.3倍，英文1倍，其他语言1.15倍
   *
   * @returns maxFontScale 按钮字体最大倍率
   */
  public getMaxFontScale(): number {
    let lang = i18n.System.getSystemLanguage() || '';
    if (lang.indexOf(SIMPLIFIED_CHINESE) >= 0) {
      // 简体中文的倍率
      return SmallFoldStyleUtil.LEVEL_BIG_2_FONT_SIZE_SCALE;
    } else if (lang.indexOf(ENGLISH) >= 0) {
      // 英文的倍率
      return SmallFoldStyleUtil.NORMAL_FONT_SIZE_SCALE;
    }
    // 默认倍率
    return SmallFoldStyleUtil.LEVEL_BIG_1_FONT_SIZE_SCALE;
  }

  /**
   * 设置按钮文字的标准尺寸：
   * 英文13，其他14
   *
   * @returns stdFontSize 按钮字体标准尺寸
   */
  public getStdFontSize(): number {
    let lang = i18n.System.getSystemLanguage() || '';
    if (lang.indexOf(ENGLISH) >= 0) {
      // 英文尺寸
      return EditModeDockConstants.OUTER_EDIT_MODE_EN_FONT_SIZE;
    }
    // 默认尺寸
    return EditModeDockConstants.OUTER_EDIT_MODE_FONT_SIZE;
  }

  static getInstance(): OuterButtonDockData {
    if (!OuterButtonDockData.instance) {
      OuterButtonDockData.instance = new OuterButtonDockData();
    }
    return OuterButtonDockData.instance;
  }
}
