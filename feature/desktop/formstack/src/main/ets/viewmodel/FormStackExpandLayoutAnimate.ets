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
import { DomainName, LogDomain, LogHelper, TraceUtil } from '@ohos/basicutils';
import { FormStackConstants } from '../common/FormStackConstants';
import { FormStackUtil } from '../common/FormStackUtil';
import { FormStackDebugCmd } from '../common/FormStackDebugCmd';
import { FormStackExpandConfig } from '../common/FormStackExpandConfig';
import { FormStackExpandLayoutModel } from '../common/FormStackExpandLayoutModel';
import { FormStackExpandItem } from './FormStackExpandItem';
import { FormStackExpandViewData } from './FormStackExpandViewData';

const TAG: string = 'FormStackExpandLayoutAnimate';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormStackExpandLayoutAnimate {
  private mViewData?: FormStackExpandViewData;
  private mLayoutModel?: FormStackExpandLayoutModel;
  public mIsOuterDesktop: boolean = false;

  public initData(viewData: FormStackExpandViewData, layoutModel: FormStackExpandLayoutModel): void {
    this.mViewData = viewData;
    this.mLayoutModel = layoutModel;
  }

  public resetData(): void {
    this.mViewData = undefined;
    this.mLayoutModel = undefined;
  }

  public layoutFormStackExpand(): void {
    if (!this.mViewData || FormStackUtil.isInvalidFormStackList(this.mViewData.mItemInfoList)) {
      log.showError('init item layout info failed, mViewData is invalid!');
      return;
    }

    TraceUtil.startTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_ANIMATE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    if (!this.mViewData.mVisible || !FormStackDebugCmd.getInstance().isNeedExpandAnimate()) {
      this.initItemLayoutInfo(this.mViewData as FormStackExpandViewData);
      this.mViewData.mBlurStyle = BlurStyle.BACKGROUND_THIN;
      this.mViewData.mBlurScale = 1;
      TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_ANIMATE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
      FormStackExpandConfig.getInstance().setExpandScale({ x: 1, y: 1});
      return;
    }

    log.showInfo('start playing animate: layout.');
    this.mViewData.mBlurStyle = BlurStyle.BACKGROUND_THIN;
    animateTo({
      curve: curves.springMotion(0.44, 0.78),
      onFinish: () => {
        TraceUtil.endTrace(DomainName.SCB, TraceUtil.CORE_METHOD_FS_EXPAND_ANIMATE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        FormStackExpandConfig.getInstance().setExpandScale({ x: 1, y: 1});
      }
    }, () => {
      // 计算和修改每个子Item的位置、旋转角度、透明度等显示信息
      this.initItemLayoutInfo(this.mViewData as FormStackExpandViewData);
      if (this.mViewData) {
        this.mViewData.mBlurScale = 1;
      }
    });
  }

  public initItemLayoutInfo(viewData: FormStackExpandViewData): boolean {
    if (!viewData || FormStackUtil.isInvalidFormStackList(viewData.mItemInfoList) || !this.mLayoutModel) {
      log.showError('init item layout info failed, viewData or mLayoutModel is invalid!');
      return false;
    }

    let config: FormStackExpandConfig = FormStackExpandConfig.getInstance();
    config.mChildCount = viewData.mItemInfoList.length;
    this.initLayoutInfo(config, viewData.mItemInfoList);

    let layoutModel: FormStackExpandLayoutModel = this.mLayoutModel as FormStackExpandLayoutModel;
    config.mMaxShowRatio = layoutModel.mShowRatio;
    config.mMaxShowCount = layoutModel.mShowMaxCount;
    config.mLastCardShowSize = layoutModel.mFormHeight *
      (1 - Math.abs(layoutModel.mFormFirstRotationX + layoutModel.mDeltaRotation * (layoutModel.mChildCount - 1)) /
      FormStackConstants.RIGHT_ANGLE_ROTATION);
    log.showInfo(`last item show size: ${config.mLastCardShowSize}.`);

    viewData.initFormStackHotArea();
    log.showInfo(`translateY: ${layoutModel.mChildInitTranslateYList.toString()}.`);
    return true;
  }

  public initVisibility(itemInfoList: FormStackExpandItem[]): void {
    let layoutModel: FormStackExpandLayoutModel = this.mLayoutModel as FormStackExpandLayoutModel;
    if (!layoutModel || !itemInfoList || itemInfoList.length <= layoutModel.mShowMaxCount) {
      return;
    }

    for (let index: number = 0; index < itemInfoList.length; index++) {
      if (itemInfoList[index].idStr !== layoutModel.mDragItemId) {
        itemInfoList[index].isVisible = (index <= layoutModel.mLastShowItemIndex);
      }
      layoutModel.initVisibility(itemInfoList[index].isVisible);
    }
  }

  private initLayoutInfo(config: FormStackExpandConfig, itemList: FormStackExpandItem[]): void {
    if (!this.mLayoutModel) {
      return;
    }

    let layoutModel: FormStackExpandLayoutModel = this.mLayoutModel as FormStackExpandLayoutModel;
    layoutModel.initData(config);
    let childStart: number = layoutModel.getChildStart(config);
    layoutModel.mShowSizePerPage = Math.max(1.0, layoutModel.mFormHeight * layoutModel.mShowRatio);

    for (let index: number = 0; index < itemList.length; index++) {
      let item: FormStackExpandItem = itemList[index];
      if (!item) {
        continue;
      }

      this.resetFormStackEditItem(item);
      this.initTranslateY(index, item, childStart, layoutModel);
      this.initRotate(index, item, layoutModel);
      this.initScale(index, item, layoutModel);
      this.initOpacity(index, item, layoutModel);
      this.initDraggable(index, item, layoutModel);
      childStart = layoutModel.updateChildStart(index, childStart);
    }

    layoutModel.initLastChildEndTranslateY();
    this.initVisibility(itemList);
    log.showInfo(`mChildInitTranslateYList: ${layoutModel.mChildInitTranslateYList.toString()}.`);
  }

  private resetFormStackEditItem(item: FormStackExpandItem): void {
    item.translateX = 0;
    item.opacity = 1;
    item.shadowRadius = FormStackConstants.FORM_SHADOW_RADIUS;
    item.maskNeedRender = false;
    item.maskOpacity = 0;
  }

  private initTranslateY(index: number, item: FormStackExpandItem, childStart: number,
                         layoutModel: FormStackExpandLayoutModel): void {
    item.translateY = childStart;
    layoutModel.initTranslateY(index, childStart);
  }

  private initRotate(index: number, item: FormStackExpandItem, layoutModel: FormStackExpandLayoutModel): void {
    item.rotateX = layoutModel.initRotate(index);
  }

  private initOpacity(index: number, item: FormStackExpandItem, layoutModel: FormStackExpandLayoutModel): void {
    item.opacity = (index < layoutModel.mChildCount - layoutModel.mShowMaxCount) ?
      FormStackConstants.PRE_FORM_CARD_ALPHA : 1.0;
  }

  private initScale(index: number, item: FormStackExpandItem, layoutModel: FormStackExpandLayoutModel): void {
    let scale: number = (index < layoutModel.mChildCount - layoutModel.mShowMaxCount) ?
      FormStackConstants.FIRST_STACK_FORM_SCALE : 1.0;
    item.scaleX = scale * FormStackExpandConfig.getInstance().mFormShowScale;
    item._scaleX = item.scaleX;
    item.scaleY = scale * FormStackExpandConfig.getInstance().mFormShowScale;
    layoutModel.initScale(scale * FormStackExpandConfig.getInstance().mFormShowScale);
  }

  private initDraggable(index: number, item: FormStackExpandItem, layoutModel: FormStackExpandLayoutModel): void {
    item.isDraggable = layoutModel.getItemDraggable(index);
  }
}