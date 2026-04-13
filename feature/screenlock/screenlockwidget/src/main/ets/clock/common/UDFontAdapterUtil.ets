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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BitStatesUtil } from '@ohos/screenlockcommon';
import { ClockComFamily, ClockLayout } from '../../common/WidgetParam';
import { CCMParamUtil } from './CCMParamUtil';

const TAG = 'UDFontAdapterUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export enum UDSelectEnum {
  // 没选
  DEFAULT = 0,
  // 布局和字体都选
  LAYOUT_FONT = 1 << 0,
  // 选了布局
  LAYOUT = 1 << 1,
  // 选了字体
  FONT = 1 << 2,
}

const DESKTOP_CLOCK_FONT_SIZE_4UD: number = 50;
const DESKTOP_CLOCK_FONT_TOP_PADDING: number = 20;

export class UDFontAdapterUtil {
  private static supportLayouts: ClockLayout[] =
    [ClockLayout.DEFAULT_CLOCK_LAYOUT, ClockLayout.NORMAL_CLOCK_LAYOUT, ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT,
      ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL];
  private static supportFonts: string[] = [ClockComFamily.HARMONY_CLOCK_ULT_01, ClockComFamily.HARMONY_CLOCK_ULT_2_4];
  private static scene: UDSelectEnum = UDSelectEnum.DEFAULT;
  private static isInit: boolean = false;

  public static isUD(): boolean {
    return CCMParamUtil.isUD();
  }

  public static getRealFontFamily(selectFont: string): string {
    if (!UDFontAdapterUtil.isUDLayout()) {
      return selectFont;
    }
    return ClockComFamily.HARMONY_CLOCK_ULT_2_4 === selectFont ? ClockComFamily.HARMONY_CLOCK_ULT_01 : selectFont;
  }

  public static setSceneSelected(selected: UDSelectEnum): void {
    UDFontAdapterUtil.scene = BitStatesUtil.addState(UDFontAdapterUtil.scene, selected);
  }

  public static handleFontChange(fontFamily: string): void {
    if (UDFontAdapterUtil.isSupportByFont(fontFamily)) {
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.FONT);
    } else {
      UDFontAdapterUtil.removeSceneSelected(UDSelectEnum.FONT);
    }
  }

  /**
   * 升级场景 如果是第一种布局及默认字体则替换为UD字体
   * @param clockLayout
   * @param font
   * @returns
   */
  public static getDefaultFont4UD(clockLayout: ClockLayout, font: string): string {
    if (!UDFontAdapterUtil.isUD()) {
      return font;
    }
    // UD字体新机场景，将标志位至于true
    if (!UDFontAdapterUtil.isInit && font === ClockComFamily.HARMONY_CLOCK_ULT_01) {
      log.showInfo('init default font for ud new device scene');
      UDFontAdapterUtil.isInit = true;
    }
    if (!UDFontAdapterUtil.isInit && clockLayout === ClockLayout.DEFAULT_CLOCK_LAYOUT && font ===
      ClockComFamily.HARMONY_CLOCK_01) {
      log.showInfo('init default font for ud upgrade scene');
      UDFontAdapterUtil.isInit = true;
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.FONT);
      return ClockComFamily.HARMONY_CLOCK_ULT_01;
    }
    return font;
  }

  public static getDesktopClockFontSize(fontSize: number): number {
    if (UDFontAdapterUtil.isUDLayout() && UDFontAdapterUtil.isUDFont()) {
      return DESKTOP_CLOCK_FONT_SIZE_4UD;
    }
    return fontSize;
  }

  public static getDesktopClockFontTopPadding(fontFamily: string): number {
    if (fontFamily === ClockComFamily.HARMONY_CLOCK_ULT_01) {
      return DESKTOP_CLOCK_FONT_TOP_PADDING;
    }
    return 0;
  }

  public static removeSceneSelected(selected: UDSelectEnum): void {
    UDFontAdapterUtil.scene = BitStatesUtil.removeState(UDFontAdapterUtil.scene, selected);
  }

  /**
   * 处理布局变化，标识UD布局、UD字体
   * @param clockLayout 时钟布局
   * @param handleFont 标识UD布局的时候，是否同时标识UD字体
   */
  public static handleLayoutChange(clockLayout: ClockLayout, handleFont: boolean = false): void {
    if (UDFontAdapterUtil.isUD() && clockLayout === ClockLayout.DEFAULT_CLOCK_LAYOUT) {
      UDFontAdapterUtil.setSceneSelected(UDSelectEnum.LAYOUT);
      if (handleFont) {
        UDFontAdapterUtil.setSceneSelected(UDSelectEnum.FONT);
      }
    } else {
      UDFontAdapterUtil.removeSceneSelected(UDSelectEnum.LAYOUT);
      if (handleFont) {
        UDFontAdapterUtil.removeSceneSelected(UDSelectEnum.FONT);
      }
    }
  }

  public static isUDLayout(): boolean {
    return BitStatesUtil.hasState(UDFontAdapterUtil.scene, UDSelectEnum.LAYOUT);
  }

  public static isUDFont(): boolean {
    return BitStatesUtil.hasState(UDFontAdapterUtil.scene, UDSelectEnum.FONT);
  }

  public static isSupportByLayout(layout: ClockLayout): boolean {
    return UDFontAdapterUtil.supportLayouts.includes(layout);
  }

  public static isSupportByFont(font: string): boolean {
    return UDFontAdapterUtil.supportFonts.includes(font);
  }

  public static getLayout4UD(old: ClockLayout): ClockLayout {
    return ClockLayout.CLOCK_LAYOUT_UD_FLAG + old;
  }

  public static transferLayout4UD(old: ClockLayout): ClockLayout {
    if (UDFontAdapterUtil.isUDFont()) {
      log.showInfo(`final layout: ${ClockLayout.CLOCK_LAYOUT_UD_FLAG + old}`);
      return ClockLayout.CLOCK_LAYOUT_UD_FLAG + old;
    }
    log.showDebug(`transferLayout4UD layout: ${old}`);
    return old;
  }
}