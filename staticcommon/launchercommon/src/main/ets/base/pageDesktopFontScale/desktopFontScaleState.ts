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

import { LogHelper, LogDomain, LanguageUtils } from '@ohos/basicutils';
import { DesktopLayoutState } from '../../constants/CommonConstants';
import { EmergencyEventManager } from '../../desktopmode/eventmanager/EmergencyEventManager';
import { LayoutViewModel, PresetStyleConstants } from '../../TsIndex';

const TAG = 'desktopFontScaleState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Observed
export class DesktopFontScaleState {
  /**
   * 系统fp字体扩大倍数
   */
  fontSizeScale: number = 1;

  private realFontSizeScale: number = 1;

  private fontMarginTop: number = PresetStyleConstants.DEFAULT_ICON_NAME_GAP;

  /**
   * 设置MarginTop
   */
  public setFontMarginTop(val: number): void {
    this.fontMarginTop = val;
  }

  /**
   * 获取MarginTop
   */
  public getFontMarginTop(marginTop: number): number {
    let isUg: boolean = LanguageUtils.isUgLanguage();
    let tempMarginTop = marginTop;
    let isEmergency: boolean = AppStorage.get<boolean>(EmergencyEventManager.EMC_FLAG_NAME) ?? false;
    if (isUg && !isEmergency) {
      tempMarginTop = marginTop - PresetStyleConstants.DEFAULT_ICON_NAME_GAP_UG_DIFF;
    }
    log.info(`getFontMarginTop marginTop:${marginTop},  tempMarginTop:${tempMarginTop}`);
    return tempMarginTop;
  }

  /**
   * 获取字体、行高使用大小（vp）
   */
  public getScaleSize(font: number): string {
    return font * this.getFontScale() + 'vp';
  }

  /**
   * 设置真实缩放比例,考虑折叠屏展开态特殊场景和系统设置
   */
  public setRealFontSizeScale(scale: number): void {
    this.realFontSizeScale = Math.min(scale, this.fontSizeScale);
  }

  /**
   * 获取字体放大倍数（systemUI限制在2倍）
   */
  public getFontScale(): number {
    if (LayoutViewModel.getInstance().getDesktopModel() === DesktopLayoutState.SIMPLE_LAUNCHER_MODEL) {
      return 1;
    }
    return this.realFontSizeScale;
  }
}