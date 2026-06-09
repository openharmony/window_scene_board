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

import { DesktopFontScaleState } from './desktopFontScaleState';
import { LogHelper, LogDomain, LanguageUtils } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import systemParameter from '@ohos.systemParameterEnhance';
import { IconCommonUtil, PresetStyleConstants } from '../../TsIndex';

const TAG = 'desktopFontScaleState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const PERSIST_SYS_FONT_SIZE_SCALE: string = 'persist.sys.font_scale_for_user0';
// 默认字体最大放大倍数
const DESKTOP_MAX_FONT_SCALE = 1.15;
// 折叠屏展开态横屏字体最大放大倍数
const DESKTOP_FOLD_LANDSCAPE_MAX_FONT_SCALE = 0.85;
// 图标缩放档位维语判断阈值
const DESKTOP_ICON_SCALE_THRESHOLD_UG = 3;
// 图标缩放档位判断阈值
const DESKTOP_ICON_SCALE_THRESHOLD = 4;

class DesktopFontScaleManager {
  private mDesktopFontScaleState: DesktopFontScaleState = new DesktopFontScaleState();

  constructor(scale: number) {
    this.mDesktopFontScaleState.fontSizeScale = scale;
  }

  /**
   * 获取系统原始字体放大倍数
   */
  public getSysFontScaleState(): DesktopFontScaleState {
    return this.mDesktopFontScaleState;
  }

  public initSetFontScale(): void {
    let systemFontSize = systemParameter.getSync(PERSIST_SYS_FONT_SIZE_SCALE, '1');
    this.setSysFontScale(Number(systemFontSize) || 1);
    log.showInfo(`systemFontSize:${systemFontSize}`);
  }

  /**
   * 设置系统原始字体放大倍数
   *
   * @param scale 字体系数
   */
  public setSysFontScale(scale: number): void {
    this.mDesktopFontScaleState.fontSizeScale = scale;
    this.setRealDesktopFontScale();
  }

  /**
   * 设置字体最终真实放大倍数
   */
  public setRealDesktopFontScale(): void {
    let tempFontScale: number = DESKTOP_MAX_FONT_SCALE;
    if (DeviceHelper.isFoldExpandedOrHalfButNotSmallFoldProduct() && DeviceHelper.isLandscape()) {
      let iconScale: number = IconCommonUtil.getDesktopIconChangeSize();
      let isUg: boolean = LanguageUtils.isUgLanguage();
      // 图标文字最大缩放比例限制条件：折叠屏展开态+维语三挡或者其它语言四挡
      let fontMaxScaleCondition: boolean =
        (iconScale >= DESKTOP_ICON_SCALE_THRESHOLD) || (isUg && iconScale >= DESKTOP_ICON_SCALE_THRESHOLD_UG);
      if (fontMaxScaleCondition) {
        tempFontScale = DESKTOP_FOLD_LANDSCAPE_MAX_FONT_SCALE;
      }
      log.showInfo(`setRealDesktopFontScale tempFontScale：${tempFontScale} , isUg:${isUg}`);
    }
    this.mDesktopFontScaleState.setRealFontSizeScale(tempFontScale);
  }
}

export const desktopFontScaleManager = new DesktopFontScaleManager(AppStorage.get('fontSizeScale') || 1);