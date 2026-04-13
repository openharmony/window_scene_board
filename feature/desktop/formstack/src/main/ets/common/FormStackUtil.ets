/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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

import type image from '@ohos.multimedia.image';
import componentSnapshot from '@ohos.arkui.componentSnapshot';
import type { BusinessError } from '@ohos.base';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ResourceManager, DeviceHelper } from '@ohos/frameworkwrapper';
import { RectInfo } from '@ohos/basicutils';
import { desktopUtil } from '@ohos/componenthelper';
import {
  CardItemInfo,
  CommonConstants,
  PageDesktopModel,
  DesktopItemVibratorManager,
} from '@ohos/launchercommon';
import { FormStackManager } from './FormStackManager';
import { FormStackConstants } from './FormStackConstants';
import { FormStackItemInfo } from './FormStackItemInfo';

const TAG: string = 'FormStackUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackUtil {
  static toFixNumber(num: number, fractionSize?: number): number {
    if (!fractionSize) {
      fractionSize = 0;
    }
    let digitNumber: number =
      FormStackUtil.isPositive(fractionSize) ? fractionSize : FormStackConstants.MAX_LEN_OF_DECIMAL_POINT;
    return Number(num?.toFixed(digitNumber));
  }

  static getFormComponentId(item: CardItemInfo, isWithName: boolean = false): string {
    if (!FormStackUtil.isValidCard(item)) {
      log.showError('get form component id failed, item is invalid card!');
      return '';
    }

    const componentId: string = `${FormStackConstants.FORM_STACK_ID_PREFIX}_${item.bundleName}_${item.cardId}`;
    return isWithName ? `${componentId}_WithName` : componentId;
  }

  static getFormStackComponentId(formStackId: string | undefined): string {
    if (CheckEmptyUtils.checkStrIsEmpty(formStackId)) {
      log.showError('get form stack component id failed, formStackId empty!');
      return '';
    }

    return `${FormStackConstants.FORM_STACK_ID_PREFIX}_${formStackId}`;
  }

  static isValidCard(cardInfo: CardItemInfo): boolean {
    if (!CheckEmptyUtils.checkStrIsEmpty(cardInfo?.bundleName)) {
      return true;
    }

    log.showError(`input is invalid card, bundleName: ${cardInfo?.bundleName}, cardId: ${cardInfo?.cardId}!`);
    return false;
  }

  /**
   * 堆叠卡片当前只支持1x2、2x2、2x4、4x4
   * @param cardDimension 卡片类型
   * @returns 卡片类型是否有效
   */
  static isValidCardType(cardDimension: number): boolean {
    return cardDimension >= CommonConstants.CARD_DIMENSION_1x2 && cardDimension <= CommonConstants.CARD_DIMENSION_4x4;
  }

  static isPositive(num: number): boolean {
    return num > 0;
  }

  static snapImage(componentId: string, onRecvPixelMap: (pixmap: image.PixelMap) => void,
                   onError?: (error: BusinessError) => void): void {
    if (CheckEmptyUtils.checkStrIsEmpty(componentId)) {
      log.showError('snap image failed, componentId is invalid!');
      return;
    }

    log.showInfo(`start to snap image, componentId: ${componentId}.`);
    try {
      componentSnapshot.get(componentId)?.then((pixmap: image.PixelMap) => {
        log.showInfo(`snap image of componentId: ${componentId}, bytes: ${pixmap.getPixelBytesNumber()} successed.`);
        onRecvPixelMap?.(pixmap);
      }).catch((error: BusinessError) => {
        onError?.(error);
        log.showError(`snap image of componentId: ${componentId} failed, error: ${error?.code}!`);
      });
    } catch (error) {
      onError?.(error as BusinessError);
      log.showError(`snap image of componentId: ${componentId} failed, error: ${error?.code}!`);
    }
  }

  static isInvalidFormStackList<T>(arr: T[]): boolean {
    return !arr || arr.length < FormStackConstants.FORM_STACK_ITEM_MIN_LEN;
  }

  /**
   * number的比较，只关注小数点后三位有效数字
   * @param a 比较数
   * @param b 比较数
   * @returns 返回比较结果
   */
  static isNumberEqual(a: number, b: number): boolean {
    if (Number.isNaN(a) || Number.isNaN(b)) {
      return false;
    }

    return Math.abs(a - b) <= FormStackConstants.FLOAT_MIN_ACCURACY;
  }

  static isValidImage(pixelMap?: image.PixelMap): boolean {
    return (pixelMap?.getPixelBytesNumber() ?? 0) > 0;
  }

  static playVibration(isSideslip?: boolean): void {
    DesktopItemVibratorManager.getInstance().longPressVibrator(TAG,
      isSideslip ? CommonConstants.VIBRATION_EFFECT_UPGLIDE : undefined);
  }

  static isRectExistComponent(rect: RectInfo): boolean {
    return rect && rect.right > rect.left && rect.bottom > rect.top;
  }

  /**
   * 释放图片资源
   * @param pixelMap 待释放的图片资源
   */
  static releasePixelMap(pixelMap?: image.PixelMap): void {
    try {
      pixelMap?.release();
    } catch (error) {
      log.showError(`releasePixelMap error: ${error?.message}`);
    }
  }

  static updateName(cardInfo: CardItemInfo): string {
    let topCarName: string = '';
    ResourceManager.getInstance().getAppNameWithCache(
      cardInfo.appLabelId, cardInfo.bundleName, cardInfo.moduleName, '', (name: string): string =>
      topCarName = FormStackUtil.getAppNameWithCacheCallback(name, cardInfo));
    log.showInfo(`getAppNameWithCacheCallback, updateName topCarName = ${topCarName}`);
    return topCarName;
  }

  static isTargetItemInCurPage(targetPage?: number, isOuter?: boolean): boolean {
    if (targetPage === undefined) {
      log.showWarn('targetPage is undefined');
      return false;
    }

    let curPageIndex: number = PageDesktopModel.getInstance().getPageIndex(isOuter);
    log.showWarn(`curPage: ${curPageIndex}, targetItem page: ${targetPage}`);

    return targetPage === curPageIndex;
  }

  static isFormStackLayoutItemInvalid(formStackItem: FormStackItemInfo | undefined): boolean {
    if (!formStackItem) {
      log.showError('formstack invalid!');
      return true;
    }

    if (!formStackItem.layoutInfo || CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo)) {
      log.showError('formstack layout info empty!');
      return true;
    }

    return FormStackUtil.isInvalidFormStackList(formStackItem.layoutInfo[0]) ||
      CheckEmptyUtils.isEmpty(formStackItem.layoutInfo[0][0]);
  }

  static getFormStackMaskExtraWidth(childCardLen: number): number {
    if (childCardLen > FormStackConstants.FORM_STACK_MASK_EXTRA_WIDTH_LEVEL_NUM) {
      return DeviceHelper.isPad() ?
        FormStackConstants.FORM_STACK_PAD_MORE_MASK_EXTRA_WIDTH : FormStackConstants.FORM_STACK_MORE_MASK_EXTRA_WIDTH;
    }

    return FormStackConstants.FORM_STACK_LESS_MASK_EXTRA_WIDTH;
  }

  private static getAppNameWithCacheCallback(
    name: string, cardInfo: CardItemInfo): string {
    let topCarName: string = '';
    if (CheckEmptyUtils.checkStrIsEmpty(name)) {
      log.showInfo('getAppNameWithCacheCallback name is empty, use bundle label instead');
      ResourceManager.getInstance().getBundleLabelWithCache(
        cardInfo.appLabelId, cardInfo.bundleName, cardInfo.moduleName,
        '', (name: string): void => { topCarName = name });
    } else {
      topCarName = name;
    }
    return topCarName;
  }

  public static adaptDeleteImageMoveLongestDistance(distance: number): number {
    if (DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState() && AppStorage.get('isPortrait')) {
      // 超大屏G态竖屏，endX要缩小，防止过于贴近屏幕左侧
      distance *= FormStackConstants.FORM_END_TRANSLATE_X_ADAPT_RATIO;
    }
    return distance;
  }

  /**
   * 获取通过_截取后的formId
   *
   * @param idStr 堆叠组件ID
   * @returns 截取后的formId
   */
  public static getSplitFormId(idStr: string): string {
    if (CheckEmptyUtils.isEmpty(idStr)) {
      return '';
    }

    const idStrArray = idStr.split('_');
    if (!CheckEmptyUtils.isEmptyArr(idStrArray)) {
      return idStrArray[idStrArray.length - 1];
    }
    return '';
  }
}