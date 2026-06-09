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
import measure from '@ohos.measure'
import { ToggleState } from '@ohos/systemuicommon/src/main/ets/template/ToggleState';
import { ToggleBaseComponentStyle } from '@ohos/systemuicommon/src/main/ets/template/common/StyleConfiguration';
import { FontViewData } from './LabelViewData';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { ConfigurationEvent, DeviceHelper } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { AccessibilityUtilExt } from '../../accessibility/AccessibilityUtilExt';
import { ToggleViewData } from './ToggleViewData';

const TAG = 'LabelViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const SMALL_FONT_PC: number = 11;
const MID_FONT_PC: number = 12;
const SMALL_LINE_PC: number = 13;

const MID_FONT_PH: number = 11;
const SMALL_FONT_PH: number = 10.65;
const BO_SMALL_FONT_PH: number = 9;
const SMALL_LINE_PH: number = 11;
const BO_SMALL_LINE_PH: number = 12;
const BO_MID_LINE_PH: number = 14;
const ENGLISH_PREFIX: string = 'en-Latn-'

export class LabelViewModel {
  private viewData: FontViewData;
  public toggleViewData: ToggleViewData;
  private style: ToggleBaseComponentStyle;
  private systemLanguage: string = '';
  // 配置文件暂无法修改，通过代码设置文字大小
  private defaultFontSize = ResUtils.getNumber($r('app.float.Control_center_button_font_size'));
  private midFontSize = MID_FONT_PH;
  private smallFontSize = SMALL_FONT_PH;
  private defaultLineHeight = ResUtils.getConvertNumber($r('app.float.Control_center_button_font_lineheight'));
  private smallerLineHeight = SMALL_LINE_PH;
  private lastLabel: string = '';
  private isPC: boolean = DeviceHelper.isPC();
  private isReset: boolean = false;
  private boSmallFontSize = BO_SMALL_FONT_PH;
  private boSmallLineHeight = BO_SMALL_LINE_PH;
  private boMidLineHeight = BO_MID_LINE_PH;
  private isBusinessStyle: boolean = false;

  constructor(viewData: FontViewData, toggleViewData: ToggleViewData,
      style: ToggleBaseComponentStyle, isBusinessStyle: boolean) {
    this.viewData = viewData;
    this.toggleViewData = toggleViewData;
    this.style = style;
    this.isBusinessStyle = isBusinessStyle;
    this.initData();
  }

  private initData() {
    this.midFontSize = DeviceHelper.isPC() ? MID_FONT_PC : MID_FONT_PH;
    this.smallFontSize = DeviceHelper.isPC() ? SMALL_FONT_PC : SMALL_FONT_PH;
    this.smallerLineHeight = DeviceHelper.isPC() ? SMALL_LINE_PC : SMALL_LINE_PH;
  }

  public languageChangeListener = (event: ConfigurationEvent): void => {
    let newLanguage: string = event?.config?.language ?? this.systemLanguage;
    if (newLanguage !== this.systemLanguage || !this.isReset) {
      this.systemLanguage = newLanguage;
      log.showInfo(`language changed to: ${this.systemLanguage}`);
      this.resetFontSize();
      this.resetHoverFontSize();
    }
  }

  public resetFontAndHoverSize() {
    this.resetFontSize();
    this.resetHoverFontSize();
  }

  /**
   * 重新设置字体大小
   */
  resetFontSize(): void {
    log.showInfo(`FontSize: ${this.viewData.fontSize}`);
    if (this.toggleViewData.label === undefined) {
      return;
    }
    this.isReset = true;
    let newLabel = typeof (this.toggleViewData.label) === 'string' ? this.toggleViewData.label :
      AccessibilityUtilExt.getResourceStr(this.toggleViewData.label);
    log.showInfo(`now systemLanguage is ${this.systemLanguage}`)
    this.viewData.isUyghurMode = false;
    this.viewData.isEnglishMode = false;
    this.viewData.isTibetanMode = false;
    this.viewData.isChineseMode = false;
    this.viewData.isRTL = RTLUtil.isRTL();
    if (this.systemLanguage === 'ug-CN' || this.systemLanguage === 'ug') {
      this.viewData.isUyghurMode = true;
    }
    if (this.systemLanguage.startsWith(ENGLISH_PREFIX)) {
      this.viewData.fontSize = this.smallFontSize;
      this.viewData.lineHeight = this.smallerLineHeight;
      this.viewData.isEnglishMode = true;
      return
    }
    if (this.systemLanguage === 'bo-CN' || this.systemLanguage === 'bo') {
      this.viewData.isTibetanMode = true;
      this.resetBoLine(newLabel);
      return;
    }
    if (this.isBusinessStyle && this.systemLanguage === 'zh-Hans-CN') {
      this.viewData.isChineseMode = true;
    }
    if (newLabel === this.lastLabel) {
      return;
    }
    this.lastLabel = newLabel;
    this.viewData.fontWeight = this.isPC ? FontWeight.Medium : FontWeight.Regular;
    if (this.isMatchTextWidth(newLabel, this.defaultFontSize)) {
      return;
    }
    if (this.isMatchTextWidth(newLabel, this.midFontSize)) {
      return;
    }
    if (this.isMatchTextWidth(newLabel, this.smallFontSize)) {
      return;
    }
    this.viewData.fontSize = this.smallFontSize;
    this.viewData.lineHeight = this.smallerLineHeight;
  }

  resetBoLine(newLabel: string): void {
    if (this.isMatchTextWidth(newLabel, this.defaultFontSize)) {
      return;
    }
    if (this.isMatchTextWidth(newLabel, this.midFontSize)) {
      return;
    }
    if (this.isMatchTextWidth(newLabel, this.smallFontSize)) {
      return;
    }
    if (this.isMatchTextWidth(newLabel, this.boSmallFontSize)) {
      return;
    }
    if (this.isBoMatchTextWidth(newLabel, this.smallFontSize)) {
      return;
    }
    this.viewData.fontSize = this.boSmallFontSize;
  }

  isBoMatchTextWidth(textContent: string, fontSize: number): boolean {
    let textWidth = px2vp(measure.measureText({
      textContent: textContent,
      fontSize: fontSize + 'vp'
    }))
    if (textWidth <= this.style.buttonLabelWidth * 2) {
      this.viewData.fontSize = fontSize;
      return true;
    }
    return false;
  }


  /**
   * 重新设置hover字体大小
   */
  resetHoverFontSize(): void {
    log.showInfo(`hoverFontSize: ${this.viewData.hoverFontSize}`);
    if (this.toggleViewData.label === undefined) {
      return;
    }
    let newLabel = typeof (this.toggleViewData.label) == 'string' ? this.toggleViewData.label : ResUtils.getInnerString(this.toggleViewData.label);
    this.lastLabel = newLabel;
    this.viewData.fontWeight = this.isPC ? FontWeight.Medium : FontWeight.Regular;
    if (this.isMatchHoverTextWidth(newLabel, this.defaultFontSize)) {
      return;
    }
    if (this.isMatchHoverTextWidth(newLabel, this.midFontSize)) {
      return;
    }
    if (this.isMatchHoverTextWidth(newLabel, this.smallFontSize)) {
      return;
    }
    this.viewData.hoverFontSize = this.smallFontSize;
    this.viewData.lineHeight = this.isBusinessStyle && this.viewData.isChineseMode ?
      this.defaultLineHeight : this.smallerLineHeight;
    this.viewData.labelWidth = this.style.buttonLabelHoverWidth
  }

  isMatchTextWidth(textContent: string, fontSize: number): boolean {
    let textWidth = measure.measureText({
      textContent: textContent,
      fontSize: fontSize + 'vp'
    });
    // measureText 返回值为px+向上取整，此处也需要做一次同样处理，保证对比结果准确
    let buttonLabelWidth : number = Math.ceil(vp2px(this.style.buttonLabelWidth));
    if (textWidth <= buttonLabelWidth) {
      this.viewData.fontSize = fontSize;
      this.viewData.lineHeight = this.defaultLineHeight;
      return true;
    }
    return false;
  }

  isMatchHoverTextWidth(textContent: string, fontSize: number): boolean {
    let textWidth = measure.measureText({
      textContent: textContent,
      fontSize: fontSize + 'vp'
    });
    // measureText 返回值为px+向上取整，此处也需要做一次同样处理，保证对比结果准确
    let buttonLabelHoverWidth : number = Math.ceil(vp2px(this.style.buttonLabelHoverWidth));
    if (textWidth <= buttonLabelHoverWidth) {
      this.viewData.hoverFontSize = fontSize;
      this.viewData.lineHeight = this.defaultLineHeight;
      this.viewData.labelWidth = textWidth
      return true;
    }
    return false;
  }
}