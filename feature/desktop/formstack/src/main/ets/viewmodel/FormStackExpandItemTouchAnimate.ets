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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackExpandLayoutModel } from '../common/FormStackExpandLayoutModel';
import { StyleConstants } from '@ohos/launchercommon';

const TAG: string = 'FormStackExpandItemTouchAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandItemTouchAnimate {
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

  /**
   * 展开卡片触摸反馈
   * @param idx 目标卡片的索引
   * @param zoomOut 放大/缩小
   * @param isNeedAnimate 是否需要动效过渡
   */
  public onItemTouchFeedback(idx: number, zoomOut: boolean, isNeedAnimate: boolean = true): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError('mViewData is invalid, touch feedback failed!');
      return;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate() || !isNeedAnimate) {
      log.showWarn('need not to play touch feedback animate, animate switch is closed.');
      this.itemTouchStatusChange(itemList, idx, zoomOut);
      return;
    }

    log.showInfo(`start playing animate: touch feedback zoomOut[${zoomOut}].`);
    animateTo({
      curve: curves.springMotion(0.35, 1),
    }, () => {
      this.itemTouchStatusChange(itemList, idx, zoomOut);
    });
  }

  /**
   * 长按卡片反馈
   * @param idx
   * @param isPress
   */
  public onItemPressFeedback(idx: number, isPress: boolean): void {
    let itemList: FormStackExpandItem[] = this.mViewData?.mItemInfoList as FormStackExpandItem[];
    if (FormStackUtil.isInvalidFormStackList(itemList)) {
      log.showError('mViewData is invalid, card long press feedback failed!');
      return;
    }

    if (isPress) {
      this.longPressGetIn(itemList, idx);
    } else {
      this.longPressGetOut(itemList, idx);
    }
  }

  private itemTouchStatusChange(itemList: FormStackExpandItem[], idx: number, zoomOut: boolean): void {
    if (zoomOut) {
      itemList[idx].scaleX = itemList[idx]._scaleX * FormStackConstants.EDIT_TOUCH_FEEDBACK_SCALE;
      itemList[idx].translateY += FormStackConstants.EDIT_TOUCH_FEEDBACK_TRANSLATE_Y;
    } else {
      itemList[idx].scaleX = itemList[idx]._scaleX * StyleConstants.DEFAULT_1;
      itemList[idx].translateY -= FormStackConstants.EDIT_TOUCH_FEEDBACK_TRANSLATE_Y;
    }
    itemList[idx].scaleY = itemList[idx].scaleX;
  }

  private longPressGetIn(itemList: FormStackExpandItem[], idx: number): void {
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to play card long press feedback animate, animate switch is closed.');
      this.itemPressStatusChange(itemList, idx);
      this.longPressAvoid(itemList, idx, true);
      return;
    }

    log.showInfo(`start playing animate: card darkness isPress[true].`);
    animateTo({
      curve: curves.springMotion(0.35, 0.8),
    }, () => {
      this.itemPressStatusChange(itemList, idx);
      this.longPressAvoid(itemList, idx, true);
    });
  }

  private longPressGetOut(itemList: FormStackExpandItem[], idx: number): void {
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to play card long press feedback animate, animate switch is closed.');
      this.recoverItemPress(itemList, idx);
      this.longPressAvoid(itemList, idx, false);
      return;
    }
    log.showInfo(`start playing animate: card darkness isPress[false].`);
    animateTo({
      curve: curves.springMotion(0.35, 0.8),
    }, () => {
      this.recoverItemPress(itemList, idx);
    });
    this.longPressAvoidRestore(itemList, idx);
  }

  private itemPressStatusChange(itemList: FormStackExpandItem[], idx: number): void {
    for (let i: number = 0; i < itemList.length; i++) {
      if (idx !== i) {
        itemList[i].bgBrightness = FormStackConstants.EDIT_OTHER_CARD_BRIGHTNESS_AFTER_LONG_PRESS;
      }
      // else {
      //   itemList[i].scaleX = itemList[i]._scaleX * StyleConstants.EDIT_MODE_LONG_PRESS_SCALE;
      //   itemList[i].scaleY = itemList[i].scaleX;
      // }
    }
  }

  private recoverItemPress(itemList: FormStackExpandItem[], idx: number) {
    for (let i: number = 0; i < itemList.length; i++) {
      if (idx !== i) {
        itemList[i].bgBrightness = 1;
      }
    }
  }

  /**
   * 被长按卡片的下方卡片复原
   * @param item
   * @param isPress
   * @param isNeedAvoid
   */
  private longPressAvoidRestore(itemList: FormStackExpandItem[], idx: number): void {
    if (!this.mLayoutModel) {
      log.showError('mLayoutModel is undefined, long press avoid failed!');
      return;
    }

    if (idx >= this.mLayoutModel.mLastShowItemIndex) {
      log.showInfo('long press item is last show, need not avoid.');
      return;
    }

    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      log.showWarn('need not to play card long press feedback animate, animate switch is closed.');
      this.longPressAvoid(itemList, idx, false);
      return;
    }

    log.showInfo(`start playing animate: card darkness isPress[true].`);
    animateTo({
      delay: FormStackConstants.LONG_PRESS_CARD_AVOID_RESTORE_DELAY,
      curve: curves.springMotion(0.35, 0.8),
      onFinish: ()=> {
        this.onItemTouchFeedback(idx, false)
      }
    }, () => {
      this.longPressAvoid(itemList, idx, false);
    });
  }

  private longPressAvoid(itemList: FormStackExpandItem[], idx: number, isPress: boolean): void {
    if (!this.mLayoutModel) {
      return;
    }
    for (let i: number = 0; i < itemList.length; i++) {
      itemList[i].longPressAvoidY = 0;
    }
    if (isPress) {
      for (let i: number = idx + 1; i < Math.min(this.mLayoutModel.mLastShowItemIndex + 1, itemList.length); i++) {
        itemList[i].longPressAvoidY = this.mLayoutModel.mLongPressAvoidDistance;
      }
    }
  }
}