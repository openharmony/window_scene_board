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

import type image from '@ohos.multimedia.image';
import { CardItemInfo, FormCommonUtil } from '@ohos/launchercommon';
import { CardNodeController } from '@ohos/launchercommon/src/main/ets/buildernode/CardNodeController';
import { CardNodeOption, FormOccupyParams } from '@ohos/launchercommon/src/main/ets/manager/CardNodeControllerManager';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandItem } from './FormStackExpandItem';

const TAG: string = 'FormStackExpandViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

@Observed
export class FormStackExpandViewData {
  public mItemInfoList: FormStackExpandItem[] = [];
  public mStackHotAreaMarinLeft: number = 0;
  public mStackHotAreaMarginTop: number = 0;
  public mStackHotAreaWidth: number = 0;
  public mStackHotAreaHeight: number = 0;
  public mVisible: boolean = false;
  public mBlurScale: number = 0;
  public mBlurStyle: BlurStyle = BlurStyle.BACKGROUND_THIN;
  public mHotAreaVisible: boolean = false;

  public mDragSnapshot?: image.PixelMap = undefined;
  public mIsDropItem: boolean = false;
  public mDropX: number = 0;
  public mDropY: number = 0;
  public mDropScaleX: number = 0;
  public mDropScaleY: number = 0;
  public mDropAngle: number = 0;

  public initData(itemList: CardItemInfo[]): boolean {
    log.showInfo(`init data, formItemList len: ${this.mItemInfoList.length}.`);
    if (!CheckEmptyUtils.isEmptyArr(this.mItemInfoList)) {
      this.mItemInfoList.splice(0, this.mItemInfoList.length);
    }

    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showInfo('init viewData failed, itemList len is invalid!');
      return false;
    }

    this.initFormStackExpandList(itemList);
    return true;
  }

  public resetData(): void {
    log.showInfo('expand view data reset.');
    this.mVisible = false;
    this.mHotAreaVisible = false;
    if (!CheckEmptyUtils.isEmptyArr(this.mItemInfoList)) {
      for (let i = 0; i < this.mItemInfoList.length; i++) { // 堆叠展开关闭, 还原节点
        this.mItemInfoList[i].cardNode = null;
      }
      this.mItemInfoList.splice(0, this.mItemInfoList.length);
    }
    this.mStackHotAreaMarinLeft = 0;
    this.mStackHotAreaMarginTop = 0;
    this.mStackHotAreaWidth = 0;
    this.mStackHotAreaHeight = 0;
    this.mDragSnapshot = undefined;
    this.mIsDropItem = false;
  }

  public initFormStackHotArea(): void {
    if (FormStackUtil.isInvalidFormStackList(this.mItemInfoList)) {
      log.showError('init form stack hot area failed, item info is invalid!');
      return;
    }

    const config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    const layoutOffsetX: number = config.mFormStackOffsetX;
    let isSupportExpandFormGrid: boolean = FormStackExpandConfig.isSupportExpandFromGrid();
    let offsetX: number = isSupportExpandFormGrid ? layoutOffsetX : (config.mDisplayWidth - config.mFormShowWidth) / 2;
    let availableWidth: number = Math.min(offsetX, config.mDisplayWidth - config.mFormShowWidth - offsetX);
    const hotAreaMargin: number = FormStackConstants.FORM_STACK_HOT_AREA_MAX_MARGIN;
    if (availableWidth > hotAreaMargin) {
      this.mStackHotAreaMarinLeft = offsetX - hotAreaMargin;
      this.mStackHotAreaWidth = config.mFormShowWidth + hotAreaMargin * 2;
    } else {
      this.mStackHotAreaMarinLeft = offsetX - availableWidth / 2;
      this.mStackHotAreaWidth = config.mFormShowWidth + availableWidth;
    }
    this.mHotAreaVisible = true;
    this.calculateHotAreaHeight();
    log.showWarn('expand view hot area params: width=%{public}d, height=%{public}d, left=%{public}d, top=%{public}d',
      this.mStackHotAreaWidth, this.mStackHotAreaHeight, this.mStackHotAreaMarinLeft, this.mStackHotAreaMarginTop);
  }

  public isTopItemOfFormStack(id: string): boolean {
    if (FormStackUtil.isInvalidFormStackList(this.mItemInfoList)) {
      return false;
    }

    let itemList: FormStackExpandItem[] = this.mItemInfoList;
    for (let i: number = itemList.length - 1; i >= 0; i--) {
      if (!itemList[i]?.isVisible) {
        continue;
      }

      return itemList[i].idStr === id;
    }

    return false;
  }

  public calculateHotAreaHeight(lastShowItemIndex: number = -1): void {
    if (!this.mHotAreaVisible) {
      log.showWarn('expand view closed, do not deal hot area calculation!');
      return;
    }

    log.showInfo(`calculate hot area height, lastShowItemIndex: ${lastShowItemIndex}`);
    const config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    const hotAreaMargin: number = FormStackConstants.FORM_STACK_HOT_AREA_MAX_MARGIN;
    let len = this.mItemInfoList.length - 1;
    if (config.mChildCount <= config.mMaxShowCount) {
      // 不存在折叠卡片
      this.mStackHotAreaMarginTop = this.mItemInfoList[0].translateY > hotAreaMargin * 2 ?
        this.mItemInfoList[0].translateY - hotAreaMargin : hotAreaMargin;
      this.mStackHotAreaHeight = config.mFormShowHeight +
      this.mItemInfoList[len].translateY - this.mItemInfoList[0].translateY + hotAreaMargin * 2;
    } else if (lastShowItemIndex < 0) {
      // 卡片超过展示上限，展开时默认顶部折叠
      this.mStackHotAreaMarginTop = 0;
      this.mStackHotAreaHeight = config.mFormShowHeight + this.mItemInfoList[len].translateY + hotAreaMargin;
    } else {
      if (lastShowItemIndex >= config.mMaxShowCount) {
        // 顶部有折叠
        this.mStackHotAreaMarginTop = 0;
      } else {
        this.mStackHotAreaMarginTop = this.mItemInfoList[0].translateY > hotAreaMargin * 2 ?
          this.mItemInfoList[0].translateY - hotAreaMargin : hotAreaMargin;
      }

      if (lastShowItemIndex < config.mChildCount - 1) {
        // 底部有折叠
        this.mStackHotAreaHeight = config.mFullDisplayHeight - this.mStackHotAreaMarginTop;
      } else {
        this.mStackHotAreaHeight = config.mFormShowHeight + this.mItemInfoList[len].translateY + hotAreaMargin;
      }
    }

    log.showInfo(`hot area marginTop: ${this.mStackHotAreaMarginTop}, height: ${this.mStackHotAreaHeight}`);
  }

  private initFormStackExpandList(itemList: CardItemInfo[]): void {
    itemList.forEach((cardItem, index) => {
      if (!FormStackUtil.isValidCard(cardItem)) {
        log.showError('init form stack expand info failed, cardInfo is invalid!');
        return;
      }
      let expandItem: FormStackExpandItem = new FormStackExpandItem();
      expandItem.idStr = `${FormStackConstants.FORM_STACK_EXPAND_ID_PREFIX}_${cardItem.cardId}`;
      expandItem.zIndex = index;
      expandItem.enableBlurBackground = FormCommonUtil.getEnableBlurBackground(cardItem); // 模糊背板
      expandItem.cardNode = new CardNodeController(new FormOccupyParams(
        cardItem.cardId
      ), TAG, new CardNodeOption(true));
      this.mItemInfoList.push(expandItem);
    });
  }
}