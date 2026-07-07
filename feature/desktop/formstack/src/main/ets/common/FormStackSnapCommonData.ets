/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { RectInfo } from '@ohos/basicutils';
import {
  EditModeUtils,
  GridLayoutItemInfo,
  CommonConstants,
  FormCommonUtil,
  GridLayoutUtil,
} from '@ohos/launchercommon';
import { FormStackUtil } from './FormStackUtil';

const TAG: string = 'FormStackSnapCommonData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackSnapCommonData {
  public mWidth: number = 0;
  public mHeight: number = 0;
  public mPosX: number = 0;
  public mPosY: number = 0;
  public mBorderRadius: number = 0;
  public mImgCacheKey: string = '';

  public static createCommonData(formId: string, borderRadius: number,
                                endLayoutInfo?: GridLayoutItemInfo): FormStackSnapCommonData | undefined {
    if (CheckEmptyUtils.checkStrIsEmpty(formId) || !endLayoutInfo) {
      log.showError('create commonData failed, formId or endLayoutInfo is invalid!');
      return undefined;
    }

    // 组件不在当前页，则不需要显示截图遮罩
    if (!FormStackUtil.isTargetItemInCurPage(endLayoutInfo.page)) {
      log.showWarn('endLayoutInfo is not in cur page, no need to show snap view.');
      return undefined;
    }

    // 获取截图需要显示的位置，场景一：语音助手场景卡入场退场|堆叠卡片移除，场景二：拖拽形成堆叠
    let targetComponentId: string = endLayoutInfo.typeId === CommonConstants.TYPE_CARD ?
      FormCommonUtil.getFormComponentId(endLayoutInfo) :
      FormCommonUtil.getFormStackComponentId(endLayoutInfo.formStackId);
    const rectInfo: RectInfo = ItemUtils.getRectById(targetComponentId);
    if (!FormStackUtil.isRectExistComponent(rectInfo)) {
      log.showError(`create commonData failed, can not find rect info by targetComponentId: ${targetComponentId}!`);
      return undefined;
    }

    // 目标位置中心点坐标
    let targetPosition: number[] = GridLayoutUtil.getIconCenterPosition(endLayoutInfo.row, endLayoutInfo.column,
      endLayoutInfo.area, endLayoutInfo.page);
    let commonData: FormStackSnapCommonData = new FormStackSnapCommonData();
    commonData.mWidth = EditModeUtils.convertWithDesktopScale(rectInfo.right - rectInfo.left);
    commonData.mHeight = EditModeUtils.convertWithDesktopScale(rectInfo.bottom - rectInfo.top);
    commonData.mPosX = targetPosition[0] - commonData.mWidth / 2;
    commonData.mPosY = targetPosition[1] - commonData.mHeight / 2;
    commonData.mImgCacheKey = formId;
    commonData.mBorderRadius = borderRadius;

    return commonData;
  }

  public copy(src: FormStackSnapCommonData): void {
    if (!src) {
      return;
    }

    this.mWidth = src.mWidth;
    this.mHeight = src.mHeight;
    this.mPosX = src.mPosX;
    this.mPosY = src.mPosY;
    this.mImgCacheKey = src.mImgCacheKey;
    this.mBorderRadius = src.mBorderRadius;
  }

  public toString(): string {
    return `mWidth: ${this.mWidth}, ` +
      `mHeight: ${this.mHeight}, ` +
      `mPosX: ${this.mPosX}, ` +
      `mPosY: ${this.mPosY}, ` +
      `mBorderRadius: ${this.mBorderRadius}, ` +
      `mImgCacheKey: ${this.mImgCacheKey}`;
  }
}