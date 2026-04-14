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

import i18n from '@ohos.i18n';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { AccessibilityUtil } from '@ohos/screenlockcommon';

const TAG: string = 'AccessibilityHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class AccessibilityHelper {

  /**
   * 读取资源字符串
   *
   * @param content 资源
   */
  public static readRes(content: Resource): void {
    let readText = AccessibilityHelper.getStrByResource(content);
    AccessibilityUtil.sendAccessibility(readText);
  }

  /**
   * 读取资源字符串
   * @param res 资源
   * @returns 字符串
   */
  public static getStrByResource(res: Resource): string {
    let result: string = '';
    try {
      result = ResUtils.getInnerStringNumS(res);
      if (!result) {
        log.showWarn('res is not exist.');
        return result;
      }
      if (res.params && res.params.length === 1) {
        let systemLocale = i18n.System.getSystemLocale(); // 获取系统当前Locale
        let numberFormat: Intl.NumberFormat = new Intl.NumberFormat(systemLocale);
        let num = Number.parseInt(res.params[0]);
        let formattedNumber: string = numberFormat.format(num);
        result = result.replace('%d', num === 0 ? '' : ', ' + formattedNumber);
      }
    } catch (e) {
      log.showError('getStrByResource failed.');
    }
    return result;
  }

  /**
   * 拼接新手提醒
   *
   * @param isSelected 当前元素是否为选中状态
   * @param hasLongPress 当前元素是否存在长按事件，默认为false
   * @returns 新手提醒
   */
  public static getDescription(isSelected: boolean, hasLongPress: boolean = false): string {
    if (isSelected) {
      return ',';
    }
    let clickDescription = ResUtils.getInnerString($r('app.string.widgets_two_click_accessible'));
    let pressDescription = ResUtils.getInnerString($r('app.string.Double_click_and_hold_accessibility'));
    return hasLongPress ? (clickDescription + ',' + pressDescription) : clickDescription;
  }

  /**
   * 拼接字符串
   *
   * @param mainRes 主资源
   * @param subRes 子资源
   * @param isAppend 是否拼接
   * @returns 返回结果
   */
  public static appendAccessibilityText(mainRes: Resource, subRes: Resource, isAppend: boolean): string {
    let res = AccessibilityHelper.getStrByResource(mainRes);
    if (isAppend) {
      res += ', ' + AccessibilityHelper.getStrByResource(subRes);
    }
    return res;
  }
}