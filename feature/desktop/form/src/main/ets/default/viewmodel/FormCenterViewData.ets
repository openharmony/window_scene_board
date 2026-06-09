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

import systemParameter from '@ohos.systemparameter';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import {
  CardItemInfo,
  CommonConstants,
  FormModel,
  GridLayoutUtil,
} from '@ohos/launchercommon';
import { FormStyleConfig } from '../common/FormStyleConfig';
import { ViewData } from './FormCenterObservedData';
import { FormCenterViewModel } from '../../formcenter/viewmodel/FormCenterViewModel';
import FormStyleConstants from '../common/constants/FormStyleConstants';
import GridRowManager from '../manager/GridRowManager';
import { FormUtil } from '../../default/util/FormUtil';

const TAG: string = 'FormCenterViewData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);

export class FormCenterViewData {
  private static mInstance: FormCenterViewData;
  private mViewData: ViewData = new ViewData();
  public mCurrentHeight: number = 0;
  private mFormDimensionScale: Map<number, number> = new Map();
  private mViewManager: GridRowManager = new GridRowManager(0, 0, 0);
  private isSmallPad: boolean = false;

  constructor() {
    log.showInfo('formCenterInit');
  }

  public static getInstance(): FormCenterViewData {
    if (FormCenterViewData.mInstance == null) {
      FormCenterViewData.mInstance = new FormCenterViewData();
    }
    return FormCenterViewData.mInstance;
  }

  public getFormDimensionScale(cardDimension: number): number {
    return Number(this.mFormDimensionScale.get(cardDimension));
  }

  public getViewData(isPortrait?: boolean, isManager = false, isScreenLock = false): ViewData {
    this.updateViewDate(isPortrait, isManager, isScreenLock);
    return this.mViewData;
  }

  public getViewGridRowManager(): GridRowManager {
    return this.mViewManager;
  }

  public setCurrentViewHeight(height: number): void {
    this.mCurrentHeight = height;
  }

  public getAppFormsCenterPosition(): Position {
    let screenHeight: number = AppStorage.get('screenHeight') as number;
    let screenWidth: number = AppStorage.get('screenWidth') as number;
    let position: Position = { x: 0, y: 0 };
    position.x =
      GridLayoutUtil.getFloorVp(this.mViewData.navDestinationViewData.viewWidth / 2);
    if (FormModel.getInstance().isSupportFormCenterSplit()) {
      let margin: number = GridLayoutUtil.getFloorVp((screenWidth - this.mViewData.bindSheetWidth) / 2);
      // 分栏有1vp的分割线
      if (RTLUtil.isRTL()) {
        position.x += margin;
      } else {
        position.x += GridLayoutUtil.getFloorVp(margin + this.mViewData.appListWidth + 1);
      }
    }
    let formSwiperFormsBottomHeight = launcherStatusUtil.getShowOutLauncherStatus()
      ? FormStyleConstants.OUTER_FORM_SWIPER_FORMS_BOTTOM_HEIGHT
      : FormStyleConstants.FORM_SWIPER_FORMS_BOTTOM_HEIGHT;

    position.y = GridLayoutUtil.getFloorVp(screenHeight -
      (this.mViewData.navDestinationViewData.formViewHeight / 2 + formSwiperFormsBottomHeight));

    return position;
  }

  private createCardViewManager() {
    let formStyleConfig: FormStyleConfig = FormStyleConfig.getInstance();
    let form2x4Width: number = formStyleConfig.mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x4)) as number;
    let form2x2Width: number = formStyleConfig.mFormWidth.get(String(CommonConstants.CARD_DIMENSION_2x2)) as number;
    let rate: number = 1;
    let gutterX: number = form2x4Width - 2 * form2x2Width;
    let showWidth: number = this.mViewData.navDestinationViewData.viewWidth;
    log.showInfo(`gutterX: ${gutterX} form2x4Width: ${form2x4Width} form2x2Width:${form2x2Width}`);
    showWidth -= this.mViewData.navDestinationViewData.cardViewMargin * 2;
    if (this.mViewData.navDestinationViewData.column === 8) {
      rate = showWidth / (form2x4Width * 2 + gutterX);
      gutterX = gutterX * rate;
    } else if (this.mViewData.navDestinationViewData.column === 6) {
      rate = showWidth / (form2x4Width + gutterX + form2x2Width);
      gutterX = gutterX * rate;
    } else {
      rate = showWidth / form2x4Width;
      gutterX = gutterX * rate;
    }
    this.mViewData.navDestinationViewData.formRate = rate;
    log.showInfo(`showWidth: ${showWidth}`);
    this.mViewManager =
      new GridRowManager(this.mViewData.navDestinationViewData.column, gutterX, showWidth);
  }

  private dimensionScaleMapInit(): void {
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x2, 1.2);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x2, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 0.85);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.8);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_6x4, 0.55);
  }

  private dimensionOuterScaleMapInit(): void {
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x2, 1.2);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x2, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 0.85);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.55);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_6x4, 0.55);
  }

  private getViewManager(screenWidth: number): GridRowManager {
    let columns: number = 4;
    let gutter: number = 16;
    if (screenWidth > FormStyleConstants.GRID_LARGE_SIZE) {
      columns = 12;
      this.mViewData.margin = 40;
      this.mViewData.bindSheetColumns = 8;
      this.mViewData.navDestinationViewData.cardViewMargin = 48;
      this.mViewData.navDestinationViewData.column = 8;
    } else if (screenWidth > FormStyleConstants.GRID_MEDIUM_SIZE) {
      columns = 12;
      this.mViewData.margin = 32;
      this.mViewData.bindSheetColumns = 8;
      this.mViewData.navDestinationViewData.cardViewMargin = 24;
    } else if (screenWidth > FormStyleConstants.GRID_SMALL_SIZE) {
      columns = 8;
      this.mViewData.margin = 24;
      this.mViewData.bindSheetColumns = 8;
    } else {
      this.mViewData.navDestinationViewData.column = 4;
    }
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 0.8);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.65);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_6x4, 0.55);
    return new GridRowManager(columns, gutter, screenWidth - 2 * this.mViewData.margin);
  }

  private getViewPortraitManager(screenWidth: number): GridRowManager {
    let columns: number = 4;
    let gutter: number = 16;
    if (screenWidth > FormStyleConstants.GRID_LARGE_SIZE) {
      columns = 12;
      this.mViewData.margin = 40;
      this.mViewData.bindSheetColumns = 10;
      this.mViewData.navDestinationViewData.cardViewMargin = 24;
      this.mViewData.navDestinationViewData.column = 8;
    } else if (screenWidth > FormStyleConstants.GRID_MEDIUM_SIZE) {
      columns = 12;
      this.mViewData.margin = 32;
      this.mViewData.bindSheetColumns = 10;
      this.mViewData.navDestinationViewData.cardViewMargin = 24;
    } else if (screenWidth > FormStyleConstants.GRID_SMALL_SIZE) {
      columns = 8;
      this.mViewData.margin = 24;
      this.mViewData.bindSheetColumns = 8;
    }
    return new GridRowManager(columns, gutter, screenWidth - 2 * this.mViewData.margin);
  }

  private initSplitStyle(screenWidth: number, screenHeight: number, isPortrait?: boolean): void {
    log.showInfo(`splitStyleInit ${isPortrait}`);
    let gridRowUtil: GridRowManager;
    if (isPortrait) {
      this.mViewData.bindSheetHeight = screenHeight * 0.6;
      gridRowUtil = this.getViewPortraitManager(screenWidth);
    } else {
      this.mViewData.bindSheetHeight = screenHeight * 0.8;
      gridRowUtil = this.getViewManager(screenWidth);
    }
    if (DeviceHelper.isFoldExpandedOrHalfButNotSmallFoldProduct()) {
      this.mViewData.bindSheetColumns = 8;
    }
    this.mViewData.bindSheetWidth =
      DeviceHelper.isPC() ? 900 : gridRowUtil.getSpanWidth(this.mViewData.bindSheetColumns);
    // UX规定半模态宽度小于600时的展示规格
    if ((DeviceHelper.isPad() || (DeviceHelper.isUltraScreenProduct() && DeviceHelper.isGState())) &&
      this.mViewData.bindSheetWidth < 600) {
      this.mViewData.navDestinationViewData.column = 4;
      this.mViewData.appListWidth = this.mViewData.bindSheetWidth * 0.4;
    } else if (!DeviceHelper.isPC() && DeviceHelper.isFoldExpandedOrHalfButNotSmallFoldProduct()) {
      this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 1);
      this.mViewData.bindSheetHeight = screenHeight * 0.8;
      this.mViewData.appListWidth = 180;
    }
    log.showInfo(`isSmallPad = ${this.isSmallPad}, isPortrait = ${isPortrait}`);
    if (this.isSmallPad && isPortrait) {
      this.initPortraitDimensionScaleMapForSmallPad();
    }
    this.mViewData.navDestinationViewData.viewWidth = this.mViewData.bindSheetWidth - this.mViewData.appListWidth;
    // title bar height 56 top margin 8 距离bindSheet页8margin
    this.mViewData.navDestinationViewData.viewHeight = this.mViewData.bindSheetHeight - 72;
    // 卡片距展示页面顶部距离24+32+2+20+24,距离底部12+32+16+40+28
    this.mViewData.navDestinationViewData.formViewHeight = this.mViewData.navDestinationViewData.viewHeight -
    FormStyleConstants.FORM_SWIPER_FORMS_TOP_HEIGHT - FormStyleConstants.FORM_SWIPER_FORMS_BOTTOM_HEIGHT;
  }

  public setIsSmallPad(isSmallPad: boolean): void {
    this.isSmallPad = isSmallPad;
  }

  private initFoldDimensionScaleMap(): void {
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x2, 1.2);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x2, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 0.8);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.75);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_6x4, 0.55);
  }

  private initPadDimensionScaleMap(): void {
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x2, 1.2);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x2, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.8);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_6x4, 0.55);
  }

  private initPortraitDimensionScaleMapForSmallPad(): void {
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x2, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x2, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 0.7);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.7);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_6x4, 0.55);
  }

  private initTvDimensionScaleMap(): void {
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x2, 1.25);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x2, 0.92);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 0.86);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.54);
  }

  private portraitDimensionScaleMapInit(): void {
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x1, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_1x2, 1);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x2, 0.8);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_2x4, 0.8);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_4x4, 0.55);
    this.mFormDimensionScale.set(CommonConstants.CARD_DIMENSION_6x4, 0.35);
  }

  private initInsideAppManagerStyle(isLandscape?: boolean): void {
    log.showInfo(`initInsideAppManagerStyle isLandscape = ${isLandscape}`);
    if (DeviceHelper.isPhone()) {
      this.initFoldDimensionScaleMap();
    } else if (this.isSmallPad && isLandscape === false) {
      this.initPortraitDimensionScaleMapForSmallPad();
    } else {
      this.initPadDimensionScaleMap();
    }
    this.mViewData.appListWidth = 0;
    this.mViewData.navDestinationViewData.bindSheetWidth = 480;
    this.mViewData.navDestinationViewData.bindSheetHeight = 607;
    this.mViewData.navDestinationViewData.viewWidth = 480;
    this.mViewData.navDestinationViewData.column = 4;
    this.mViewData.navDestinationViewData.viewHeight = this.mViewData.navDestinationViewData.bindSheetHeight - 64;
    if (FormCenterViewModel.getInstance().isShowButtonByAsdeForNegativeScreen()) {
      // 卡片距展示页面顶部距离12*2+32+2+20 = 78,距离底部12+32+16+40+28 = 128
      this.mViewData.navDestinationViewData.formViewHeight = this.mViewData.navDestinationViewData.viewHeight -
      FormStyleConstants.FORM_SWIPER_FORMS_TOP_HEIGHT_BY_ASDE -
      FormStyleConstants.FORM_SWIPER_TWO_BUTTON_AREA_HEIGHT_INSIDE_APP -
      FormStyleConstants.FORM_SWIPER_INDICATOR_AREA_HEIGHT_BY_ASDE -
        FormStyleConstants.FORM_CONTENT_EMPTY_AREA_BY_ASDE * 2;
    } else {
      this.mViewData.navDestinationViewData.formViewHeight = this.mViewData.navDestinationViewData.viewHeight -
        FormStyleConstants.FORM_SWIPER_FORMS_TOP_HEIGHT -
        FormStyleConstants.FORM_SWIPER_FORMS_BOTTOM_HEIGHT_INSIDE_APP;
    }
  }

  public updateViewDate(isPortrait?: boolean, isManager = false, isScreenLock = false) {
    // 横屏应用
    const isLandscape: boolean = FormUtil.isPlateLandscape();
    // 半模态宽度为横屏8栅格
    let screenWidth: number = AppStorage.get('screenWidth') as number;
    let screenHeight: number = AppStorage.get('screenHeight') as number;
    this.mViewData.bindSheetColumns = 4;
    this.mViewData.appListWidth = 240;
    this.mViewData.margin = 16;
    this.mViewData.navDestinationViewData.cardViewMargin = 16;
    this.mViewData.navDestinationViewData.column = 6;
    this.dimensionScaleMapInit();
    log.showInfo(`updateViewDate isPortrait: ${isPortrait}, screenWidth: ${screenWidth}, screenHeight: ${screenHeight}`);
    if (FormModel.getInstance().isSupportFormCenterSplit()) {
      if (isManager) {
        this.initInsideAppManagerStyle(isLandscape);
      } else {
        this.initSplitStyle(screenWidth, screenHeight, isPortrait);
      }
    } else {
      this.mViewData.appListWidth = 0;
      this.mViewData.bindSheetWidth = isLandscape ? FormStyleConstants.FORM_MANAGER_VIEW_WIDTH_LAND : screenWidth;
      this.mViewData.bindSheetHeight = screenHeight - FormStyleConstants.FORM_CENTER_VIEW_TOP_HEIGHT;
      this.mViewData.navDestinationViewData.bindSheetWidth =
        isLandscape ? FormStyleConstants.FORM_MANAGER_VIEW_WIDTH_LAND : screenWidth;
      this.mViewData.navDestinationViewData.bindSheetHeight =
        isLandscape ? FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT_LAND : FormStyleConstants.FORM_MANAGER_VIEW_HEIGHT;
      if (launcherStatusUtil.getShowOutLauncherStatus()) {
        this.mViewData.bindSheetHeight = screenHeight - FormStyleConstants.OUTER_FORM_CENTER_VIEW_TOP_HEIGHT;
        this.dimensionOuterScaleMapInit();
        this.mViewData.navDestinationViewData.bindSheetHeight =
          screenHeight - FormStyleConstants.OUTER_FORM_CENTER_VIEW_TOP_HEIGHT;
        log.showInfo(`bindSheetHeight: ${this.mViewData.navDestinationViewData.bindSheetHeight}`);
      }
      this.mViewData.navDestinationViewData.viewWidth =
        isLandscape ? FormStyleConstants.FORM_MANAGER_VIEW_WIDTH_LAND : screenWidth;
      this.mViewData.navDestinationViewData.column = 4;

      // title bar height 56 top margin 8
      this.mViewData.navDestinationViewData.viewHeight = this.mViewData.navDestinationViewData.bindSheetHeight - 64;
      log.showInfo(`viewHeight: ${this.mViewData.navDestinationViewData.viewHeight}`);
      if (FormCenterViewModel.getInstance().isShowButtonByAsdeForNegativeScreen()) {
        this.mViewData.navDestinationViewData.formViewHeight = this.mViewData.navDestinationViewData.viewHeight -
        FormStyleConstants.FORM_SWIPER_FORMS_TOP_HEIGHT_BY_ASDE -
        FormStyleConstants.FORM_SWIPER_TWO_BUTTON_AREA_HEIGHT -
        FormStyleConstants.FORM_SWIPER_INDICATOR_AREA_HEIGHT_BY_ASDE -
          FormStyleConstants.FORM_CONTENT_EMPTY_AREA_BY_ASDE * 2;
      } else {
        // 卡片距展示页面顶部距离24+32+2+20+24,距离底部12+32+16+40+28
        this.mViewData.navDestinationViewData.formViewHeight = this.mViewData.navDestinationViewData.viewHeight -
        FormStyleConstants.FORM_SWIPER_FORMS_TOP_HEIGHT - FormStyleConstants.FORM_SWIPER_FORMS_BOTTOM_HEIGHT;
      }
      // 横屏应用
      if (isLandscape) {
        this.portraitDimensionScaleMapInit();
        this.mViewData.navDestinationViewData.formViewHeight = this.mViewData.navDestinationViewData.viewHeight -
          FormStyleConstants.FORM_SWIPER_FORMS_BOTTOM_HEIGHT + FormStyleConstants.FORM_ADD_BUTTON_HEIGHT;
      }
      log.showInfo(`formViewHeight: ${this.mViewData.navDestinationViewData.formViewHeight}`);
    }
    this.mViewData.navDestinationViewData.addFormButtonWidth = this.mViewData.navDestinationViewData.viewWidth -
      FormStyleConstants.FORM_MANAGER_BUTTON_MARGIN * 2;
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      this.mViewData.navDestinationViewData.formViewHeight = this.mViewData.navDestinationViewData.viewHeight -
      FormStyleConstants.OUTER_FORM_SWIPER_FORMS_BOTTOM_HEIGHT;
      this.mViewData.navDestinationViewData.addFormButtonWidth = this.mViewData.navDestinationViewData.viewWidth -
        FormStyleConstants.OUTER_FORM_MANAGER_BUTTON_MARGIN * 2;
      log.showInfo(`formViewHeight: ${this.mViewData.navDestinationViewData.formViewHeight}`);
    }
    if (this.mViewData.navDestinationViewData.addFormButtonWidth > FormStyleConstants.BUTTON_MAX_WIDTH) {
      this.mViewData.navDestinationViewData.addFormButtonWidth = FormStyleConstants.BUTTON_MAX_WIDTH;
    }
    log.showInfo(`addFormButtonWidth: ${this.mViewData.navDestinationViewData.addFormButtonWidth}`);
    this.createCardViewManager();
  }
}

export class AppFormsViewData {
  public appFormList: CardItemInfo[] = [];
  public formIdMap: Map<number, string> = new Map();
  public swipeTargetIndex: number = 0;

  public initViewData(bundleName: string, formInfo: CardItemInfo, isScreenLock: boolean): void {
    log.showInfo(`initViewData ${bundleName}`);
    let formModel: FormModel = FormModel.getInstance();
    let formList: CardItemInfo[] | undefined = [];
    if (isScreenLock) {
      formList =
        formModel.getAppItemTotalFormInfo(bundleName, (item: CardItemInfo) => formModel.isScreenLockSupportCard(item));
    } else {
      formList =
        formModel.getAppItemTotalFormInfo(bundleName, (item: CardItemInfo) => formModel.isFormCenterSupportCard(item));
    }

    log.showWarn(`get ${bundleName} formList length: ${formList?.length}`);
    if (CheckEmptyUtils.isEmpty(formList)) {
      log.showError(`${bundleName} get form info failed`);
      return;
    }
    this.appFormList.push(...formList as CardItemInfo[]);
    this.swipeTargetIndex = FormCenterViewModel.getInstance().getAppFormsIndex(formInfo, this.appFormList);
  }

  public resetViewData(): void {
    log.showInfo('resetViewData');
    this.appFormList = [];
    this.swipeTargetIndex = 0;
  }
}
