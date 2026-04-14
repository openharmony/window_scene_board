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
import { CheckEmptyUtils, DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackManager } from '../common/FormStackManager';
import { FormStackUtil } from '../common/FormStackUtil';
import { OpenFormStackStateInfo } from './FormStackAnimateItem';
import { FormStackExpandCriticalAnimate } from './FormStackExpandCriticalAnimate';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';

const TAG: string = 'FormStackExpandExitAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export interface FormStackExpandExitAnimateCallback {
  onCloseFormStackFinish?: () => void;
}

export class FormStackExpandExitAnimate {
  private mViewData?: FormStackExpandViewData;
  private mCriticlaParam?: FormStackExpandCriticalAnimate;
  private mPenultimateFormIndex: number = -1;

  public initData(viewData: FormStackExpandViewData, critialAnimate: FormStackExpandCriticalAnimate): void {
    this.mViewData = viewData;
    this.mCriticlaParam = critialAnimate;
  }

  public resetData(): void {
    this.mViewData = undefined;
    this.mCriticlaParam = undefined;
    this.mPenultimateFormIndex = -1;
  }

  public exitFormStackExpand(openInfo: OpenFormStackStateInfo,
                             callback: FormStackExpandExitAnimateCallback, isNeedAnimate: boolean = true): void {
    if (!this.mViewData || CheckEmptyUtils.isEmptyArr(this.mViewData.mItemInfoList)) {
      log.showError(`exit form stack expand animate play failed, list len: ${this.mViewData?.mItemInfoList?.length}.`);
      AppStorage.setOrCreate('couldSqueezeStack', false);
      return;
    }

    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXIT_ANIMATE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    if (!FormStackDebugCmd.getInstance().isNeedExpandAnimate() || !isNeedAnimate) {
      log.showWarn('need not play exit form stack animate, expand animate switch is closed.');
      this.mViewData.mBlurScale = 0;
      callback?.onCloseFormStackFinish?.();
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXIT_ANIMATE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      return;
    }

    log.showInfo('start playing animate: exit form stack expand.');
    FormStackManager.getInstance().setBreakFormStackExpandAnimation(() => {
      callback?.onCloseFormStackFinish?.();
      FormStackManager.getInstance().setBreakFormStackExpandAnimation();
    });
    this.mViewData.mHotAreaVisible = false;
    this.presetMaskWhenClosing();
    animateTo({
      curve: curves.springMotion(0.45, 0.83),
      onFinish: () => {
        callback?.onCloseFormStackFinish?.();
        FormStackManager.getInstance().setBreakFormStackExpandAnimation();
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXIT_ANIMATE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      },
    }, () => {
      // 重新回到堆叠展开前的临界状态，用缓存的临界态信息重新初始化堆叠子Item的显示参数
      this.goBackToFormStackCriticalState(openInfo, this.mViewData?.mItemInfoList as FormStackExpandItem[]);
      if (this.mViewData) {
        this.mViewData.mBlurScale = 0;
      }
    });
  }

  private goBackToFormStackCriticalState(openInfo: OpenFormStackStateInfo, itemInfoList: FormStackExpandItem[]): void {
    if (!itemInfoList || !this.mCriticlaParam?.initFormStackExpandCriticalParam(openInfo, false)) {
      return;
    }

    if (this.mPenultimateFormIndex >= 0 && this.mPenultimateFormIndex <= itemInfoList.length - 1) {
      itemInfoList[this.mPenultimateFormIndex].maskOpacity = FormStackConstants.FORM_STACK_MASK_OPACITY;
    }
  }

  /**
   * 展开卡片收起时，查找自顶而下第二张卡片，预置蒙层衔接动效
   */
  private presetMaskWhenClosing(): void {
    if (!this.mViewData || FormStackUtil.isInvalidFormStackList(this.mViewData.mItemInfoList)) {
      return;
    }

    let tempFormList: FormStackExpandItem[] = [...this.mViewData.mItemInfoList];
    tempFormList.sort((x1, x2) => {
      return x1.zIndex - x2.zIndex;
    });

    // 顶层第二张卡片，预置蒙层动效
    this.setFormStackEditMask(tempFormList[tempFormList.length - 2].idStr, this.mViewData.mItemInfoList);
    tempFormList = [];
  }

  private setFormStackEditMask(idStr: string, itemInfoList: FormStackExpandItem[]): void {
    log.showInfo(`set edit mask, idStr: ${idStr}.`);
    let idx: number = itemInfoList.findIndex(item => item.idStr === idStr);
    if (idx < 0) {
      log.showError(`can not find form of idStr: ${idStr}.`);
      return;
    }

    this.mPenultimateFormIndex = idx;
    itemInfoList[idx].maskNeedRender = true;
    itemInfoList[idx].maskOpacity = 0;
  }
}