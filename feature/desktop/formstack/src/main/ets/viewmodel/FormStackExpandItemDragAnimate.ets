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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';
import { FormStackExpandLayoutModel } from '../common/FormStackExpandLayoutModel';
import { FormStackConstants } from '../common/FormStackConstants';

const TAG: string = 'FormStackExpandItemDragAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export interface FormStackExpandDragAnimateCallback {
  onSwapFormFinish?: () => void;
}

export class FormStackExpandItemDragAnimate {
  private mViewData?: FormStackExpandViewData;
  private mLayoutModel?: FormStackExpandLayoutModel;

  public initData(viewData: FormStackExpandViewData, layoutModel: FormStackExpandLayoutModel): void {
    this.mViewData = viewData;
    this.mLayoutModel = layoutModel;
  }

  public resetData(): void {
    this.mViewData = undefined;
  }

  public batchMoveForm(start: number, end: number, callback: FormStackExpandDragAnimateCallback,
    delayMs: number = 0): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList) || itemList.length - 1 < Math.max(start, end)) {
      log.showError(`swap form animate play failed, item list len: ${itemList?.length}.`);
      return;
    }
    const positions: number[][] = []; // 从start开始, 记录它的应该位移的 translateY 、zIndex、 rotateX;
    const direction: number = Math.sign(end - start); // 上移/下移
    let i: number = start;
    while (i !== end) {
      positions.push([itemList[i].translateY, itemList[i].zIndex, itemList[i].rotateX]);
      i += direction;
    }
    // 执行位移动画
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to play swapping form animate, expand animate switch is closed.');
      this.moveAnimation(itemList, start, end, positions);
      return;
    }
    log.showInfo('start playing animate: swap form.');
    animateTo({
      delay: delayMs,
      duration: FormStackConstants.FORMSTACK_EXPAND_SWAP_CARD_DURATION,
      curve: Curve.Friction,
      onFinish: () => {
        callback?.onSwapFormFinish?.();
      }
    }, () => {
      this.moveAnimation(itemList, start, end, positions);
    });
  }

  private moveAnimation(itemList: FormStackExpandItem[], start: number, end: number, positions: number[][]): void {
    const direction: number = Math.sign(end - start); // 上移/下移
    const distance: number = this.mLayoutModel?.mLongPressAvoidDistance as number;
    let i: number = start;
    let j: number = 0;
    while (i !== end) {
      const pos = positions[j++];
      i += direction;
      itemList[i].translateY = pos[0];
      itemList[i].zIndex = pos[1];
      itemList[i].rotateX = pos[2];
      itemList[i].longPressAvoidY = direction > 0 ? 0 : distance;
    }
  }
}
