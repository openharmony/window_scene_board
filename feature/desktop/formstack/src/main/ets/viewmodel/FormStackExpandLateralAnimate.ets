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

import curves from '@ohos.curves';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';
import { FormStackUtil } from '../common/FormStackUtil';
import { EditLateralEndResult, FormStackConstants } from '../common/FormStackConstants';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackExpandLayoutModel } from '../common/FormStackExpandLayoutModel';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';

const TAG: string = 'FormStackExpandLateralAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export interface FormStackDelLastCardAnimateCallback {
  onLastCardFillingFinish?: () => void;
}

export class FormStackExpandLateralAnimate {
  private mViewData?: FormStackExpandViewData;
  private mLayoutModel?: FormStackExpandLayoutModel;

  public initData(viewData: FormStackExpandViewData, layoutModel: FormStackExpandLayoutModel): void {
    this.mViewData = viewData;
    this.mLayoutModel = layoutModel;
  }

  public resetData(): void {
    this.mViewData = undefined;
    this.mLayoutModel = undefined;
  }

  public onTrashImgAngleChange(idx: number, ratio: number): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError('mViewData is invalid, change trash img angle failed!');
      return;
    }

    itemList[idx].trashHeadAngle = ratio * FormStackConstants.TRASH_HEAD_ANGLE_MAX;
    itemList[idx].trashBodyAngle = ratio * FormStackConstants.TRASH_BODY_ANGLE_MAX;
  }

  public restoreTrashImgAngle(idx: number, eventFunc: () => void): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError('mViewData is invalid, restore trash img angle failed!');
      return;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to trash img angle restore animate, animate switch is closed.');
      this.onTrashImgAngleChange(idx, 0);
      eventFunc();
      return;
    }

    log.showInfo('start playing animate: restore trash img angle.');
    animateTo({
      curve: curves.springMotion(0.5, 0.9),
    }, () => {
      this.onTrashImgAngleChange(idx, 0);
      eventFunc();
    });
  }

  public execCardAvoid(zIndex: number, avoidDistance: number, result?: number): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList) || !this.mLayoutModel) {
      log.showError('mViewData or layoutModel is invalid, card avoid failed!');
      return;
    }

    if (result === undefined) {
      animateTo({
        curve: curves.springMotion(0.4, 0.75),
      }, () => {
        for (let i: number = 0; i < itemList.length; i++) {
          if (itemList[i].zIndex < zIndex) {
            itemList[i].slideAvoidY = -avoidDistance;
          } else if (itemList[i].zIndex > zIndex) {
            itemList[i].slideAvoidY = avoidDistance;
          }
        }
      })
      return;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to exec card avoid back animate, animate switch is closed.');
      this.execCardAvoidBack(itemList, zIndex, avoidDistance, result);
      return;
    }

    log.showInfo('start playing animate: card avoid back.');
    animateTo({
      curve: curves.springMotion(0.4, 0.75),
    }, () => {
      this.execCardAvoidBack(itemList, zIndex, avoidDistance, result);
    })
  }

  public execCardLateralEnd(idx: number, distance: number): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError('mViewData is invalid, exec card lateral end action failed!');
      return;
    }
    if (idx < 0 || idx >= itemList.length) {
      log.showError('array index out of bounds !');
      return;
    }

    const innerExecCardLateralEnd = () => {
      itemList[idx].translateX = distance;
      if (distance === 0) {
        // 清空slideAvoidY
        for (let i = 0; i < itemList.length; i++) {
          itemList[i].slideAvoidY = 0;
        }
      }
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to exec card lateral end animate, animate switch is closed.');
      innerExecCardLateralEnd();
      return;
    }

    log.showInfo('start playing animate: card lateral move.');
    animateTo({
      curve: curves.springMotion(0.4, 0.75),
    }, innerExecCardLateralEnd);
  }

  public execCardFillingRestore(startIndex: number, endIndex: number): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError('mViewData is invalid, exec card filling restore failed!');
      return;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to exec card filling restore animate, animate switch is closed.');
      this.restoreCardFilling(itemList, startIndex, endIndex);
      return;
    }

    log.showInfo('start playing animate: card filling restore.');
    animateTo({
      curve: curves.springMotion(0.4, 0.75),
    }, () => {
      this.restoreCardFilling(itemList, startIndex, endIndex);
    })
  }

  public execLastCardFilling(callback: FormStackDelLastCardAnimateCallback): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (CheckEmptyUtils.isEmptyArr(itemList) || !this.mLayoutModel) {
      log.showError('item list empty or mLayoutModel undefined!');
      return;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to exec last card filling animate, animate switch is closed.');
      itemList[0].translateY = this.getLastCardEndTranslateY();
      callback?.onLastCardFillingFinish?.();
      return;
    }

    log.showInfo('start playing animate: last card filling.');
    animateTo({
      duration: FormStackConstants.DELETE_LEFT_ONE_CARD_START_DROP_DELAY,
      curve: Curve.Sharp,
      onFinish: () => {
        callback?.onLastCardFillingFinish?.();
      }
    }, () => {
      itemList[0].translateY = this.getLastCardEndTranslateY();
    })
  }

  private execCardAvoidBack(itemList: FormStackExpandItem[],
                            zIndex: number, avoidDistance: number, result: number): void {
    if (!this.mLayoutModel) {
      log.showError('invalid layoutModel, need not exec card avoid back');
      return;
    }

    for (let i: number = 0; i < itemList.length; i++) {
      if (itemList[i].zIndex === zIndex) {
        continue;
      }

      if (result === EditLateralEndResult.RESTORE) {
        itemList[i].slideAvoidY = 0;
      } else {
        itemList[i].slideAvoidY = itemList[i].zIndex < zIndex ? -avoidDistance : avoidDistance;
      }
    }
  }

  private restoreCardFilling(itemList: FormStackExpandItem[], startIndex: number, endIndex: number): void {
    if (!this.mLayoutModel) {
      log.showError('invalid layoutModel, can not restore card filling');
      return;
    }

    for (let i: number = startIndex; i <= endIndex; i++) {
      itemList[i].translateY = this.mLayoutModel.mChildRestoreTransYList[i];
      itemList[i].rotateX = this.mLayoutModel.mChildRestoreRotateList[i];
      itemList[i].scaleX = itemList[i]._scaleX;
      itemList[i].scaleY = itemList[i]._scaleX;
      itemList[i].isVisible = this.mLayoutModel.mChildRestoreVisibilityList[i];
    }
  }

  private getLastCardEndTranslateY(): number {
    if (!this.mLayoutModel) {
      return 0;
    }

    return (FormStackExpandConfig.getInstance().mFullDisplayHeight - this.mLayoutModel.mFormHeight) / 2;
  }
}