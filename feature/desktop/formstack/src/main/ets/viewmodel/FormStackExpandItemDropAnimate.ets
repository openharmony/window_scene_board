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

import { LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';
import { FormStackConstants } from '../common/FormStackConstants';

const TAG: string = 'FormStackExpandItemDropAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandItemDropAnimate {
  private mViewData?: FormStackExpandViewData;

  public initData(viewData: FormStackExpandViewData): void {
    this.mViewData = viewData;
  }

  public resetData(): void {
    this.mViewData = undefined;
  }

  public dropForm(idx: number, dropOffsetX: number): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError(`drop form animate play failed, item list len: ${itemList?.length}.`);
      return;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to play drop form animate, expand animate switch is closed.');
      this.execDropAction(itemList[idx], dropOffsetX);
      return;
    }
    if (this.mViewData?.mItemInfoList) {
      this.mViewData.mDropAngle = this.mViewData.mItemInfoList[idx].rotateX;
    }
    log.showInfo('start playing animate: drop form.');
    animateTo({
      duration: FormStackConstants.DROP_CARD_DURATION,
      curve: Curve.Sharp,
      onFinish: () => {
        if (this.mViewData?.mItemInfoList) {
          log.showInfo('drop animation finished and clear data.');
          this.mViewData.mDragSnapshot = undefined;
          this.mViewData.mIsDropItem = false;
          this.mViewData.mItemInfoList[idx].isVisible = true;
        }
      },
    }, () => {
      this.execDropAction(itemList[idx], dropOffsetX);
    });
  }

  private execDropAction(item: FormStackExpandItem, dropOffsetX: number): void {
    if (!this.mViewData) {
      log.showError('view data is undefined!');
      return;
    }

    let rect: RectInfo = ItemUtils.getRectById(FormStackConstants.EDIT_DROP_IMAGE_ID);
    if (!rect) {
      log.showError('get drop snapshot image rect failed!');
      return;
    }
    log.showInfo(`drop snapshot image rect: ${JSON.stringify(rect)}`);
    this.mViewData.mDropX = dropOffsetX;
    this.mViewData.mDropY = item.translateY;
    this.mViewData.mDropScaleX = item.scaleX;
    this.mViewData.mDropScaleY = item.scaleY;
    log.showInfo(`exec drop action, mDropX: ${this.mViewData.mDropX}, mDropY: ${this.mViewData.mDropY},` +
      `mDropScaleX: ${this.mViewData.mDropScaleX}, translateY: ${item.translateY}.`);
  }
}
