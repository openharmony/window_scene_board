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
import { FormStackManager } from '../common/FormStackManager';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackExpandModel } from '../common/FormStackExpandModel';
import { FormStackExpandLayoutModel } from '../common/FormStackExpandLayoutModel';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { OpenFormStackStateInfo } from './FormStackAnimateItem';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';

const TAG: string = 'FormStackExpandCriticalAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandCriticalAnimate {
  private mViewData?: FormStackExpandViewData;
  private mLayoutModel?: FormStackExpandLayoutModel;
  private mExpandModel?: FormStackExpandModel;

  public initData(viewData: FormStackExpandViewData, layoutModel: FormStackExpandLayoutModel,
                  model: FormStackExpandModel): void {
    this.mViewData = viewData;
    this.mLayoutModel = layoutModel;
    this.mExpandModel = model;
  }

  public resetData(): void {
    this.mViewData = undefined;
    this.mLayoutModel = undefined;
    this.mExpandModel = undefined;
  }

  /**
   * 用堆叠展开的临界状态数据初始化ViewData的显示参数
   * @param openInfo: 堆叠展开前的临界状态信息
   * @param isOpen: 堆叠状态:展开、关闭
   * @returns: 初始化结果
   */
  public initFormStackExpandCriticalParam(openInfo: OpenFormStackStateInfo, isOpen: boolean): boolean {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (!this.isValidOpenInfo(openInfo) || CheckEmptyUtils.isEmptyArr(itemList) || !this.mLayoutModel) {
      log.showError(`init form stack expand animate failed, item list len: ${itemList?.length}`);
      return false;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to play critical animate, init form stack expand critical param failed!');
      return false;
    }

    this.mLayoutModel.mDisplayWidth = FormStackExpandConfig.getInstance().mDisplayWidth;
    log.showInfo(`init critical param, isOpen: ${isOpen}, pos: [${openInfo.position.left}, ${openInfo.position.top}].`);
    this.initFormStackAnimateParam(openInfo, isOpen, itemList);
    return true;
  }

  private initTopFormParam(item: FormStackExpandItem, isOpen: boolean, openInfo: OpenFormStackStateInfo): void {
    item.scaleX = isOpen ? openInfo.mTopItem.mScaleX : 1;
    item.scaleY = isOpen ? openInfo.mTopItem.mScaleY : 1;
    item.rotateX = isOpen ? openInfo.mTopItem.mRotateAngle : 0;
    item.translateY = isOpen ? openInfo.mTopItem.mTranslateY : openInfo.position.top;
    item.slideAvoidY = 0;
    item.longPressAvoidY = 0;
    item.opacity = isOpen ? openInfo.mTopItem.mOpacity : 1;
  }

  private initSecondTopFormParam(item: FormStackExpandItem, isOpen: boolean, openInfo: OpenFormStackStateInfo): void {
    // 关闭堆叠和菜单打开堆叠场景，倒数第二张卡片和其他卡片保持一致
    if (!isOpen || (isOpen && openInfo.mIsOpenByMenu)) {
      this.initOtherFormParam(item, openInfo);
      return;
    }

    // 自顶向底第二张
    item.translateY = openInfo.position.top;
    item.slideAvoidY = 0;
    item.longPressAvoidY = 0;
  }

  /**
   * 堆叠卡片中除顶层第一张、第二张卡片的其他卡片
   * @param item FormStackEditItem
   * @param openInfo 堆叠展开前的临界状态
   */
  private initOtherFormParam(item: FormStackExpandItem, openInfo: OpenFormStackStateInfo): void {
    item.scaleX = openInfo.mDefaultItem.mScaleX;
    item.scaleY = openInfo.mDefaultItem.mScaleY;
    item.rotateX = openInfo.mDefaultItem.mRotateAngle;
    item.translateY = openInfo.mDefaultItem.mTranslateY;
    item.slideAvoidY = 0;
    item.longPressAvoidY = 0;
  }

  private initFormStackAnimateParam(openInfo: OpenFormStackStateInfo, isOpen: boolean,
                                    itemList: FormStackExpandItem[]): void {
    if (!this.mLayoutModel) {
      return;
    }

    const config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    let formWidthDiff: number = (config.mFormWidth - config.mFormShowWidth) / 2;
    let topIndex: number = this.getTopIndexOfFormStack(itemList);
    for (let i: number = 0; i <= itemList.length - 1; i++) {
      if (i === this.getTopIndexOfFormStack(itemList)) {
        this.initTopFormParam(itemList[i], isOpen, openInfo);
      } else if (i === topIndex - 1) {
        this.initSecondTopFormParam(itemList[i], isOpen, openInfo);
      } else {
        this.initOtherFormParam(itemList[i], openInfo);
      }
      let translateXForScreenSplit: number = AppStorage.get<number>('translateXForScreenSplit') ?? 0 as number;
      log.showInfo(`exitFormStackExpand, translateXForScreenSplit = ${translateXForScreenSplit}`);
      itemList[i].translateX = config.mIsExpandCenter ?
        (openInfo.position.left - config.mFormStackOffsetX + formWidthDiff) : formWidthDiff + translateXForScreenSplit;
      itemList[i].shadowRadius = 0;
      itemList[i].isVisible = true;
      itemList[i].delImgVisible = false;
      if (!isOpen) {
        itemList[i].opacity = 1;
        itemList[i].bgBrightness = 1;
      } else {
        itemList[i].scaleX *= config.mFormStackExpandScale.x ?? 1;
        itemList[i].scaleY *= config.mFormStackExpandScale.y ?? 1;
      }
    }
  }

  private getTopIndexOfFormStack(itemInfoList: FormStackExpandItem[]): number {
    let topCardId: string = FormStackManager.getInstance().getTopFormId();
    if (CheckEmptyUtils.checkStrIsEmpty(topCardId)) {
      return itemInfoList.length - 1;
    }

    let index: number = itemInfoList.findIndex(item => {
      return this.mExpandModel?.getCardInfo(item?.idStr)?.cardId === topCardId;
    })

    return index < 0 ? itemInfoList.length - 1 : index;
  }

  private isValidOpenInfo(openInfo: OpenFormStackStateInfo): boolean {
    if (openInfo && openInfo.mTopItem && openInfo.mDefaultItem && openInfo.position) {
      return true;
    }

    log.showError('openInfo is invalid!');
    return false;
  }
}