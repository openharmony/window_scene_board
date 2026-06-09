/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { CommonConstants, FormModel, GridLayoutUtil, CardItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import FormStyleConstants from '../common/constants/FormStyleConstants';
import { FormStyleConfig } from '../common/FormStyleConfig';

const TAG: string = 'FormEditViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormEditViewData {
  private static mInstance: FormEditViewData;
  private static formScaleMap: Map<SheetType, Map<number, number>> = new Map([
    [SheetType.BOTTOM, new Map([
      [CommonConstants.CARD_DIMENSION_1x1, 1],
      [CommonConstants.CARD_DIMENSION_1x2, 1.2],
      [CommonConstants.CARD_DIMENSION_2x2, 1],
      [CommonConstants.CARD_DIMENSION_2x4, 0.85],
      [CommonConstants.CARD_DIMENSION_4x4, 0.8],
      [CommonConstants.CARD_DIMENSION_6x4, 0.55],
    ])],
    [SheetType.CENTER, new Map([
      [CommonConstants.CARD_DIMENSION_1x1, 1],
      [CommonConstants.CARD_DIMENSION_1x2, 1.2],
      [CommonConstants.CARD_DIMENSION_2x2, 1],
      [CommonConstants.CARD_DIMENSION_2x4, 1],
      [CommonConstants.CARD_DIMENSION_4x4, 0.8],
      [CommonConstants.CARD_DIMENSION_6x4, 0.55],
    ])],
  ]);
  private mViewData: ViewData = new ViewData();
  private mFormStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
  private mSheetType?: SheetType;
  private mFormAppEditHeight?: number;

  constructor() {
    log.showInfo('formEditInit');
  }

  public static getInstance(): FormEditViewData {
    if (FormEditViewData.mInstance == null) {
      FormEditViewData.mInstance = new FormEditViewData();
    }
    return FormEditViewData.mInstance;
  }

  public getViewData(isPortrait?: boolean): ViewData {
    this.updateViewDate(isPortrait);
    return this.mViewData;
  }

  public setSheetType(sheetType: SheetType): void {
    if (CheckEmptyUtils.isEmpty(sheetType)) {
      return;
    }
    this.mSheetType = sheetType;
  }

  public setFormAppEditHeight(formAppEditHeight?: number): void {
    if (CheckEmptyUtils.isEmpty(formAppEditHeight)) {
      return;
    }
    this.mFormAppEditHeight = formAppEditHeight;
  }

  public updateViewDate(isPortrait?: boolean) {
    let screenWidth: number = AppStorage.get('screenWidth') as number;
    let screenHeight: number = AppStorage.get('screenHeight') as number;
    log.showInfo(`updateViewDate. isPortrait: ${isPortrait}, screenWidth:${screenWidth}, screenHeight:${screenHeight}`);
    if (FormModel.getInstance().isSupportFormCenterSplit()) {
      this.mViewData.bindSheetWidth = screenWidth - FormStyleConstants.FORM_EDIT_VIEW_FOLD_MARGIN_LEFT_RIGHT * 2;
      this.mViewData.bindSheetHeight = screenHeight - FormStyleConstants.FORM_EDIT_VIEW_FOLD_MARGIN_TOP_BOTTOM * 2;
      this.mViewData.formAppEditWidth =
        this.mViewData.bindSheetWidth - FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN * 2;
      this.mViewData.formAppEditHeight =
        this.mFormAppEditHeight ? this.mFormAppEditHeight : FormStyleConstants.FORM_EDIT_VIEW_FOLD_PROVIDER_PAGE_HEIGHT;
      this.mViewData.formEditButtonWidth = this.mViewData.formAppEditWidth;
      this.mViewData.sheetType = this.mSheetType ? this.mSheetType : SheetType.CENTER;
      this.mViewData.isButtonMarginBottom = FormStyleConstants.FORM_EDIT_VIEW_FOLD_BUTTON_MARGIN_BOTTOM;
    } else {
      this.mViewData.bindSheetWidth = screenWidth;
      this.mViewData.bindSheetHeight = screenHeight - FormStyleConstants.FORM_EDIT_VIEW_MARGIN_TOP_SCREEN;
      this.mViewData.formAppEditWidth = screenWidth - FormStyleConstants.FORM_EDIT_VIEW_INNER_MARGIN * 2;
      this.mViewData.formAppEditHeight =
        this.mFormAppEditHeight ? this.mFormAppEditHeight : FormStyleConstants.FORM_EDIT_VIEW_PROVIDER_PAGE_HEIGHT;
      this.mViewData.formEditButtonWidth = this.mViewData.formAppEditWidth;
      this.mViewData.sheetType = this.mSheetType ? this.mSheetType : SheetType.BOTTOM;
      this.mViewData.isButtonMarginBottom = FormStyleConstants.FORM_EDIT_VIEW_BUTTON_MARGIN_BOTTOM;
    }
    // 二级编辑页
    this.mViewData.formSecPageViewData.bindSheetWidth = this.mViewData.bindSheetWidth;
    this.mViewData.formSecPageViewData.bindSheetHeight = this.mViewData.bindSheetHeight;
    this.mViewData.formSecPageViewData.sheetType = this.mViewData.sheetType;
  }

  public getFormDimensionScale(cardDimension: number): number {
    let mSheetType: SheetType =
      FormModel.getInstance().isSupportFormCenterSplit() ? SheetType.CENTER : SheetType.BOTTOM;
    log.showWarn(`getFormDimensionScale, cardDimension: ${cardDimension}, mSheetType: ${mSheetType}`);
    return FormEditViewData.formScaleMap.get(mSheetType)?.get(cardDimension) ?? 1;
  }

  public getEditFormSize(cardDimension: number): Size {
    const scale: number = this.getFormDimensionScale(cardDimension);
    return {
      width: Number(this.mFormStyleConfig.mFormWidth.get(String(cardDimension))) * scale,
      height: Number(this.mFormStyleConfig.mFormHeight.get(String(cardDimension))) * scale,
    };
  }

  public getEditFormDisplaySize(cardDimension: number): Size {
    return {
      width: Number(this.mFormStyleConfig.mFormWidth.get(String(cardDimension))),
      height: Number(this.mFormStyleConfig.mFormHeight.get(String(cardDimension))),
    };
  }

  public getAppFormsCenterPosition(manageFormItem: CardItemInfo): Position {
    let screenHeight: number = AppStorage.get('screenHeight') as number;
    let screenWidth: number = AppStorage.get('screenWidth') as number;
    let position: Position = { x: 0, y: 0 };
    position.x =
      GridLayoutUtil.getFloorVp(this.mViewData.bindSheetWidth / 2);
    position.y = GridLayoutUtil.getFloorVp(
      screenHeight - this.mViewData.bindSheetHeight + FormStyleConstants.FORM_EDIT_TO_TOP_DISTANCE +
      this.getEditFormSize(manageFormItem.cardDimension).height / 2 );
    if (FormModel.getInstance().isSupportFormCenterSplit()) {
      position.x = GridLayoutUtil.getFloorVp(screenWidth / 2);
      position.y = GridLayoutUtil.getFloorVp(FormStyleConstants.FORM_EDIT_TO_TOP_DISTANCE_SPLIT +
        this.getEditFormSize(manageFormItem.cardDimension).height / 2 );
    }
    return position;
  }
}

@Observed
export class ViewData {
  public bindSheetWidth: number = 0;
  public bindSheetHeight: number = 0;
  public formAppEditWidth: number = 0;
  public formAppEditHeight: number = 0;
  public formEditButtonWidth: number = 0;
  public formSecPageViewData: SecPageViewData = new SecPageViewData();
  public sheetType: SheetType = SheetType.BOTTOM;
  public isButtonMarginBottom: number = 0;
}

@Observed
export class SecPageViewData {
  public bindSheetWidth: number = 0;
  public bindSheetHeight: number = 0;
  public sheetType: SheetType = SheetType.BOTTOM;
}