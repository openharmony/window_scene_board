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
import intl from '@ohos.intl';
import { ResUtils } from '@ohos/windowscene';
import i18n from '@ohos.i18n';
import measure from '@ohos.measure';
import systemparameter from '@ohos.systemParameterEnhance';
import display from '@ohos.display';
import settings from '@ohos.settings';
import ServiceExtensionContext from 'application/ServiceExtensionContext';
import { GlobalContext } from '@ohos/frameworkwrapper';

const TAG = 'CommonUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DEFAULT_VP2PX_SCALE: number = 1.9;
const DPI2PIXELS: number = 160;
const SETTINGS_KEY_DPI: string = 'system_default_dpi_value';

export class CommonUtils {
  private static instance: CommonUtils;

  private constructor() {
  }

  static getInstance(): CommonUtils {
    if (!CommonUtils.instance) {
      CommonUtils.instance = new CommonUtils();
    }
    return CommonUtils.instance;
  }

  /**
   * 格式化时间信息
   *
   * @param displayDate 当前日期
   * @param format 时间日期格式化对象
   * @returns 显示日期/时间
   */
  static formatDate(displayDate: Date, format: intl.DateTimeOptions): string {
    const date = new Date(displayDate);
    const locale = new intl.Locale(i18n.System.getSystemLanguage());
    const dateFormat = new intl.DateTimeFormat(locale.toString(), format);
    const dateStr: string = dateFormat.format(date);
    //存在内存泄漏，需要手动释放
    // MemoryUtils.removeNapiWrap(dateFormat, false);
    return dateStr;
  }

  /**
   * 获取text的width
   * @param text
   * @returns
   */
  static getTextSize(text: string): SizeOptions {
    let textSize = measure.measureTextSize({
      textContent: text,
      maxLines: 1,
      fontWeight: FontWeight.Medium,
      fontSize: ResUtils.getNumberFromLength($r('app.float.status_bar_font_size')),
      lineHeight: $r('app.float.status_bar_clock_line_height'),
    });
    return textSize;
  }

  /**
   * 初始化单位转换倍数，使用其他函数之前先调这个函数初始化
   * @returns 返回设备vp2px系数
   */
  static calcVp2pxScale(): number {
    log.showDebug(`start calcVp2pxScale`);
    let vp2pxScale: number = DEFAULT_VP2PX_SCALE;
    try {
      const context: ServiceExtensionContext = GlobalContext.getContext();
      let defaultDpiString: string = settings.getValueSync(context, SETTINGS_KEY_DPI, '');
      let defaultDpi = parseInt(defaultDpiString);
      if (!isNaN(defaultDpi)) {
        vp2pxScale = defaultDpi / DPI2PIXELS;
        return vp2pxScale;
      }
      let displayClass = display.getDefaultDisplaySync();
      vp2pxScale = displayClass.densityDPI / DPI2PIXELS;
    } catch (error) {
      log.showError(`calcVp2pxScale error, message: ${error?.message}`);
    } finally {
      log.showInfo(`end calcVp2pxScale: ${vp2pxScale}`);
    }
    return (vp2pxScale > 0 ? vp2pxScale : DEFAULT_VP2PX_SCALE);
  }
}