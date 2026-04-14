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
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RectInfo } from '@ohos/basicutils';
import { ItemUtils, desktopUtil } from '@ohos/componenthelper';
import type { CalculateDesktopRst } from '@ohos/launchercommon';
import { CardItemInfo, CommonConstants, LayoutViewModel } from '@ohos/launchercommon';
import type { FormStyleConfig } from '@ohos/form/src/main/ets/default/common/FormStyleConfig';
import { FormViewModel } from '@ohos/form/src/main/ets/default/viewmodel/FormViewModel';
import { FormStackConstants } from './FormStackConstants';
import { FormStackUtil } from './FormStackUtil';

const TAG: string = 'FormStackExpandConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const FORMSTACK_SIZE_CAPACITY = 2;

export class FormStackExpandConfig {
  public mMarginTop: number = 0;
  public mLastCardShowSize: number = 0;
  public mFullDisplayHeight: number = 0;
  public mDisplayHeight: number = 0;
  public mDisplayWidth: number = 0;
  public mUITopHeight: number = 0;
  public mFormHeight: number = 0;
  public mFormWidth: number = 0;
  public mFormShowHeight: number = 0;
  public mFormShowWidth: number = 0;
  public mFormShowScale: number = 0;
  public mChildCount: number = 0;
  public mMaxShowRatio: number = 0;
  public mMaxShowCount: number = 0;
  public mLayoutType: number = CommonConstants.CARD_DIMENSION_2x2;
  public mPreShowSize: number = FormStackConstants.PRE_SHOW_SIZE;
  public mFormRadius: number = FormStackConstants.FORM_STACK_IMAGE_RADIUS;
  public mFormStackOffsetX: number = 0;
  public mIsExpandCenter: boolean = true;
  public mLateralMaxDistance: number = 0;
  public mFormStackExpandScale: ScaleOptions = { x: 1, y: 1};
  public mOuterFormStackExpandScale: number = 1;

  public static mInstance: FormStackExpandConfig = new FormStackExpandConfig();

  public static getInstance(): FormStackExpandConfig {
    if (FormStackExpandConfig.mInstance.mDisplayHeight === 0) {
      FormStackExpandConfig.mInstance.initDisplayInfo();
    }
    return FormStackExpandConfig.mInstance;
  }

  public setOuterFormStackExpandScale(scale: number): void {
    this.mOuterFormStackExpandScale = scale;
  }

  public static isSupportFormStack(): boolean {
    return DeviceHelper.isPhoneOrPad();
  }

  public static isSupportExpandFromGrid(): boolean {
    return DeviceHelper.isPad();
  }

  public updateFormLayoutInfo(card: CardItemInfo, size: number[], isOuter?: boolean): boolean {
    if (!FormStackUtil.isValidCard(card) || !FormStackUtil.isValidCardType(card.cardDimension) ||
      !this.isValidFormStackSize(size)) {
      log.showError(`update form layout fail, type: ${card?.cardDimension}`);
      return false;
    }

    this.mLayoutType = card.cardDimension;
    let styleConfig: FormStyleConfig = FormViewModel.getInstance().getFormStyleConfig();
    let radius: number = styleConfig.getFormBorderRadius(this.mLayoutType);
    if (radius !== CommonConstants.INVALID_VALUE) {
      this.mFormRadius = radius;
    } else {
      this.mFormRadius = FormStackConstants.FORM_STACK_IMAGE_RADIUS;
    }

    this.setFormShowSize(styleConfig, size, isOuter);
    this.mMaxShowCount = FormStackConstants.expandShowMaxCount.get(this.mLayoutType) ?? 0;
    this.updateFormStackOffsetX();
    this.setFormLateralMaxDistance();
    log.showWarn('formLayoutType: %{public}d, formWidth: %{public}d, formHeight: %{public}d, formRadius: %{public}d, ' +
      'mUITopHeight: %{public}d, mDisplayWidth: %{public}d, mDisplayHeight: %{public}d, maringTop: %{public}d, ' +
      'mFormShowScale: %{public}d, mMaxShowCount: %{public}d.', this.mLayoutType, this.mFormWidth, this.mFormHeight,
      this.mFormRadius, this.mUITopHeight, this.mDisplayWidth, this.mDisplayHeight, this.mMarginTop,
      this.mFormShowScale, this.mMaxShowCount);
    return true;
  }

  public resetData(): void {
    this.mFormHeight = 0;
    this.mFormWidth = 0;
    this.mFormShowHeight = 0;
    this.mFormShowWidth = 0;
    this.mFormShowScale = 0;
    this.mChildCount = 0;
    this.mMaxShowRatio = 0;
    this.mMaxShowCount = 0;
    this.mLayoutType = CommonConstants.CARD_DIMENSION_2x2;
    this.mIsExpandCenter = true;
  }

  public initDisplayInfo(): void {
    let layoutModel: LayoutViewModel = LayoutViewModel.getInstance();
    if (CheckEmptyUtils.isEmpty(layoutModel)) {
      log.showInfo('layout model is invalid.');
      return;
    }

    this.mFullDisplayHeight = layoutModel.getScreenHeight();
    this.mUITopHeight = layoutModel.getSysUITopHeight();
    this.mDisplayWidth = layoutModel.getScreenWidth();
    log.showInfo(`mUITopHeight: ${this.mUITopHeight}, mDisplayWidth: ${this.mDisplayWidth}.`);
    let desktopRst: CalculateDesktopRst = layoutModel.calculateDesktop();
    this.mMarginTop = desktopRst.mDesktopMarginTop ?? 0;
    if (!CheckEmptyUtils.isEmpty(desktopRst) && desktopRst.mDesktopMarginTop) {
      this.mDisplayHeight = this.mFullDisplayHeight - FormStackConstants.COEFICIENT_DOUBLE * this.mMarginTop;
    } else {
      log.showError('desktop result is invalid!');
      this.mDisplayHeight = this.mFullDisplayHeight - FormStackConstants.COEFICIENT_DOUBLE * this.mUITopHeight -
        FormStackConstants.COEFICIENT_DOUBLE * FormStackConstants.FORM_STACK_OPEN_MARGIN_TOP;
    }
  }

  public setExpandScale(scale: ScaleOptions): void {
    if (!scale) {
      log.showError('expand formstack, but scale param is invalid!');
      return;
    }

    this.mFormStackExpandScale = scale;
    log.showInfo(`expand scale x: ${scale.x}, y: ${scale.y}`);
  }

  private updateFormStackOffsetX(): void {
    if (!FormStackExpandConfig.isSupportExpandFromGrid()) {
      this.mFormStackOffsetX = (LayoutViewModel.getInstance().getScreenWidth() - this.mFormShowWidth) / 2;
      return;
    }
    this.mIsExpandCenter = false;
    log.showWarn(`expand from grid, mFormStackOffsetX: ${this.mFormStackOffsetX}.`);
  }

  private setFormShowSize(styleConfig: FormStyleConfig, size: number[], isOuter?: boolean): void {
    this.mFormWidth = size[0] > 0 ? size[0] : (styleConfig.mFormWidth.get(this.mLayoutType.toString()) ?? 0);
    this.mFormHeight = size[1] > 0 ? size[1] : (styleConfig.mFormHeight.get(this.mLayoutType.toString()) ?? 0);
    if (this.mFormWidth <= 0 || this.mFormHeight <= 0) {
      log.showError('styleConfig get form width or form height is invalid!');
      this.mFormWidth = FormStackConstants.FORM_CARD_DEFAULT_WIDTH;
      this.mFormHeight = FormStackConstants.FORM_CARD_DEFAULT_HEIGHT;
    }

    this.mFormShowScale = (this.mLayoutType === CommonConstants.CARD_DIMENSION_4x4) ?
      FormStackConstants.FORM_CARD_DIMENSION_4x4_SCALE : 1;
    if ((this.mLayoutType === CommonConstants.CARD_DIMENSION_4x4 ||
      this.mLayoutType === CommonConstants.CARD_DIMENSION_2x4) && isOuter) {
      this.mFormShowScale = FormStackConstants.OUTER_FORM_CARD_DIMENSION_4x4_SCALE;
    }
    this.mFormShowWidth = this.mFormWidth * this.mFormShowScale;
    this.mFormShowHeight = this.mFormHeight * this.mFormShowScale;
    this.mPreShowSize = this.mLayoutType === CommonConstants.CARD_DIMENSION_4x4 ?
      FormStackConstants.PRE_SHOW_SIZE / 2 : FormStackConstants.PRE_SHOW_SIZE;
  }

  private isValidFormStackSize(size: number[]): boolean {
    return !CheckEmptyUtils.isEmptyArr(size) && size.length === FORMSTACK_SIZE_CAPACITY;
  }

  private setFormLateralMaxDistance(): void {
    let lateralMaxRatio: number = this.mLayoutType > CommonConstants.CARD_DIMENSION_2x2 ?
      FormStackConstants.EDIT_DIMENSION_LARGE_LATERAL_MOVE_MAX_THRESHOLD :
      FormStackConstants.EDIT_DIMENSION_SMALL_LATERAL_MOVE_MAX_THRESHOLD;
    this.mLateralMaxDistance = this.mFormShowWidth * lateralMaxRatio;
  }
}