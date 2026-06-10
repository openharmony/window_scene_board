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
import { AppGridStyleConfig, FullScreenCardUtil, layoutConfigManager, ThemeStyleInfo } from '@ohos/launchercommon';
import { ThemeStyleManager } from '@ohos/launchercommon';
import { ThemeStylePreviewManager } from '@ohos/launchercommon';
import { RadiusUtil } from '@ohos/launchercommon';
import { IconCommonUtil } from '@ohos/launchercommon';
import { StyleConstants } from '@ohos/launchercommon';

import type { CalculateFormRst } from '@ohos/launchercommon';
import { CommonConstants } from '@ohos/launchercommon';
import {
  CheckEmptyUtils,
  LogDomain,
  LogHelper
} from '@ohos/basicutils';
import { launcherStatusUtil, ResUtils } from '@ohos/windowscene';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LayoutViewModel } from '@ohos/launchercommon';
import { AppListStyleConfig } from '@ohos/launchercommon';
import FeatureConstants from './constants/FeatureConstants';
import FormStyleConstants from './constants/FormStyleConstants';

const ICON_SIZE_SCALE_MIN: number = -6;
const ICON_SIZE_SCALE_MAX: number = 8;

const TAG = 'FormStyleConfig';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
const BORDER_G2 = 3.5;
// vde外屏图标大小
const SMALL_FOLD_OUTER_ICON_SIZE = 52;
// vde外屏图标间距
const SMALL_FOLD_OUTER_ICON_SPACE = 18;
/**
 * Form style config
 */
export class FormStyleConfig extends AppListStyleConfig {
  private static instance: FormStyleConfig;

  public mFormWidth: Map<string, number> = new Map<string, number>();

  public mFormHeight: Map<string, number> = new Map<string, number>();

  public mOuterFormWidth: Map<string, number> = new Map<string, number>();

  public mOuterFormHeight: Map<string, number> = new Map<string, number>();

  /**
   * Form border radius
   */
  public mFormBorderRadius: Map<string, number> = new Map<string, number>();

  /**
   * Form preview border width
   */
  public mFormPreviewWidth: Map<string, number> = new Map<string, number>();

  /**
   * Form preview border height
   */
  public mFormPreviewHeight: Map<string, number> = new Map<string, number>();

  /**
   * Form preview border radius
   */
  public mFormPreviewBorderRadius: Map<string, number> = new Map<string, number>();

  protected constructor() {
    super();
  }

  /**
   * Get form style configuration instance.
   *
   * @return {object} FormStyleConfig singleton
   */
  static getInstance(): FormStyleConfig {
    if (FormStyleConfig.instance == null) {
      FormStyleConfig.instance = new FormStyleConfig();
    }
    FormStyleConfig.instance.initConfig();
    return FormStyleConfig.instance;
  }

  /**
   * Init form style configuration.
   */
  initConfig(): void {
    let themeInfo: ThemeStyleInfo = ThemeStyleManager.getInstance().getThemeStyle();
    let formItemSizeOffset: number = this.getFormSizeOffset(themeInfo, 0);
    let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 0;
    formItemSizeOffset = this.getFormSizeOffsetSecure(desktopIconChangeSize, 0);
    const result: CalculateFormRst = LayoutViewModel.getInstance().calculateForm();
    this.mFormWidth.set(CommonConstants.CARD_DIMENSION_1x1.toString(),
      result.widthDimension0 as number + formItemSizeOffset);
    this.mFormHeight.set(CommonConstants.CARD_DIMENSION_1x1.toString(),
      result.heightDimension0 as number + formItemSizeOffset);
    this.mFormWidth.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
      result.widthDimension1 as number + formItemSizeOffset);
    this.mFormHeight.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
      result.heightDimension1 as number + formItemSizeOffset);
    this.mFormWidth.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
      result.widthDimension2 as number + formItemSizeOffset);
    this.mFormHeight.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
      result.heightDimension2 as number + formItemSizeOffset);
    this.mFormWidth.set(CommonConstants.CARD_DIMENSION_2x4.toString(),
      result.widthDimension3 as number + formItemSizeOffset);
    this.mFormHeight.set(CommonConstants.CARD_DIMENSION_2x4.toString(),
      result.heightDimension3 as number + formItemSizeOffset);
    this.mFormWidth.set(CommonConstants.CARD_DIMENSION_4x4.toString(),
      result.widthDimension4 as number + formItemSizeOffset);
    this.mFormHeight.set(CommonConstants.CARD_DIMENSION_4x4.toString(),
      result.heightDimension4 as number + formItemSizeOffset);
    this.mFormWidth.set(CommonConstants.CARD_DIMENSION_6x4.toString(),
      result.widthDimension5 as number + formItemSizeOffset);
    this.mFormHeight.set(CommonConstants.CARD_DIMENSION_6x4.toString(),
      result.heightDimension5 as number + formItemSizeOffset);
    this.mFormWidth.set(CommonConstants.CARD_DIMENSION_2x3.toString(),
      result.widthDimension6 as number + formItemSizeOffset);
    this.mFormHeight.set(CommonConstants.CARD_DIMENSION_2x3.toString(),
      result.heightDimension6 as number + formItemSizeOffset);
    this.mIconNameMargin = result.mIconNameMargin as number;
    this.mIconNameMarginTop = result.mIconNameMarginTop as number;
    this.refreshFormBorderRadius();
    this.updateFormPreviewConfig(result, formItemSizeOffset);
  }

  private initOuterFormInfo() {
    //  1x1
    this.mOuterFormWidth.set(CommonConstants.CARD_DIMENSION_1x1.toString(), SMALL_FOLD_OUTER_ICON_SIZE);
    this.mOuterFormHeight.set(CommonConstants.CARD_DIMENSION_1x1.toString(), SMALL_FOLD_OUTER_ICON_SIZE);
    //  1x2
    this.mOuterFormWidth.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
      SMALL_FOLD_OUTER_ICON_SIZE * StyleConstants.DEFAULT_2 + SMALL_FOLD_OUTER_ICON_SPACE);
    this.mOuterFormHeight.set(CommonConstants.CARD_DIMENSION_1x2.toString(), SMALL_FOLD_OUTER_ICON_SIZE);
    //  2x2
    this.mOuterFormWidth.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
      SMALL_FOLD_OUTER_ICON_SIZE * StyleConstants.DEFAULT_2 + SMALL_FOLD_OUTER_ICON_SPACE);
    this.mOuterFormHeight.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
      SMALL_FOLD_OUTER_ICON_SIZE * StyleConstants.DEFAULT_2 + SMALL_FOLD_OUTER_ICON_SPACE);
    //  2x4
    this.mOuterFormWidth.set(CommonConstants.CARD_DIMENSION_2x4.toString(),
      SMALL_FOLD_OUTER_ICON_SIZE * StyleConstants.DEFAULT_4 + SMALL_FOLD_OUTER_ICON_SPACE * StyleConstants.DEFAULT_3);
    this.mOuterFormHeight.set(CommonConstants.CARD_DIMENSION_2x4.toString(),
      SMALL_FOLD_OUTER_ICON_SIZE * StyleConstants.DEFAULT_2 + SMALL_FOLD_OUTER_ICON_SPACE);
    //  4x4
    this.mOuterFormWidth.set(CommonConstants.CARD_DIMENSION_4x4.toString(),
      SMALL_FOLD_OUTER_ICON_SIZE * StyleConstants.DEFAULT_4 + SMALL_FOLD_OUTER_ICON_SPACE * StyleConstants.DEFAULT_3);
    this.mOuterFormHeight.set(CommonConstants.CARD_DIMENSION_4x4.toString(),
      SMALL_FOLD_OUTER_ICON_SIZE * StyleConstants.DEFAULT_4 + SMALL_FOLD_OUTER_ICON_SPACE * StyleConstants.DEFAULT_3);
  }

  /**
   * Get form style configuration level.
   *
   * @return {string} feature-level layout configuration
   */
  getConfigLevel(): string {
    return CommonConstants.LAYOUT_CONFIG_LEVEL_FEATURE;
  }

  /**
   * Get form style feature name.
   *
   * @return {string} feature name
   */
  getFeatureName(): string {
    return FeatureConstants.FEATURE_NAME;
  }

  /**
   * 获取 x1 大小
   * @returns 跨度1大小
   */
  public getSizeX1(): number {
    return this.mFormHeight.get(CommonConstants.CARD_DIMENSION_1x2.toString()) ?? 0;
  }

  /**
   * 获取 x2 大小
   * @returns 跨度2大小
   */
  public getSizeX2(): number {
    return this.mFormHeight.get(CommonConstants.CARD_DIMENSION_2x2.toString()) ?? 0;
  }

  /**
   * 获取 x3 大小
   * @returns 跨度3大小
   */
  public getSizeX3(): number {
    return this.mFormWidth.get(CommonConstants.CARD_DIMENSION_2x3.toString()) ?? 0;
  }

  /**
   * 获取 x4 大小
   * @returns 跨度4大小
   */
  public getSizeX4(): number {
    return this.mFormWidth.get(CommonConstants.CARD_DIMENSION_2x4.toString()) ?? 0;
  }

  /**
   * 获取 x1 宽度
   * @returns 跨度1宽度
   */
  public getWidthX1(): number {
    return this.mFormWidth.get(CommonConstants.CARD_DIMENSION_1x1.toString()) ?? 0;
  }


  /**
   * 获取 x2 宽度
   * @returns 跨度2宽度
   */
  public getWidthX2(): number {
    return this.mFormWidth.get(CommonConstants.CARD_DIMENSION_2x2.toString()) ?? 0;
  }

  /**
   * 获取 x4 宽度
   * @returns 跨度4宽度
   */
  public getWidthX4(): number {
    return this.mFormWidth.get(CommonConstants.CARD_DIMENSION_2x4.toString()) ?? 0;
  }

  /**
   * 获取 x6 大小
   * @returns 跨度6大小
   */
  public getSizeX6(): number {
    return this.mFormHeight.get(CommonConstants.CARD_DIMENSION_6x4.toString()) ?? 0;
  }

  /**
   * 获取 x4 大小
   * @returns 跨度4 高度大小
   */
  public getHeightX4(): number {
    return this.mFormHeight.get(CommonConstants.CARD_DIMENSION_4x4.toString()) ?? 0;
  }

  /**
   * 获取 x6 大小
   * @returns 跨度6 高度大小
   */
  public getHeightX6(): number {
    return this.mFormHeight.get(CommonConstants.CARD_DIMENSION_6x4.toString()) ?? 0;
  }

  /**
   * 获取占位大小获取尺寸
   * @param span 占位大小
   * @returns 尺寸
   */
  public getSize(span: number): number {
    if (span === CommonConstants.GRID_SPAN_1) {
      return this.getSizeX1();
    }
    if (span === CommonConstants.GRID_SPAN_2) {
      return this.getSizeX2();
    }
    if (span === CommonConstants.GRID_SPAN_3) {
      return this.getSizeX3();
    }
    if (span === CommonConstants.GRID_SPAN_4) {
      return this.getSizeX4();
    }
    if (span === FullScreenCardUtil.getInstance().getRow()) {
      return this.getSizeX6();
    }
    return 0;
  }

  /**
   * 根据宫格列数和行数计算大文件夹拖拽落位区域尺寸
   * @param area 文件夹尺寸：[宽，高]
   * @returns size 落位区域尺寸：[宽，高]
   */
  public getRegionFolderDropSize(area?: number[]): [number, number] {
    let size: [number, number] = [0, 0];
    if (!area || area.length < 2 || area[0] === 0 || area[1] === 0) {
      log.showError(`calculateRegionFolderSize fail, invalid area: ${area}`);
      return size;
    }
    const styleConfig: AppGridStyleConfig = layoutConfigManager.getStyleConfig(AppGridStyleConfig.APP_GRID_STYLE_CONFIG,
      CommonConstants.PAGE_DESKTOP_FEATURE_NAME);
    const itemSize: number = styleConfig.mAppItemSize;
    // 落位区域宽高统一减去50保持和收纳夹框体大小保持一致
    const width = itemSize * area[0] - 50;
    const height = itemSize * area[1] - 50;
    if (width <= 0 || height <= 0) {
      log.showError(`calculateRegionFolderSize fail, invalid result: (${width}, ${height}).`);
      return size;
    }
    size = [width, height];
    return size;
  }

  updateFormBorderRadiusToG2(radius: number, dimension?: number): number {
    if (CheckEmptyUtils.isEmpty(dimension) || (dimension as number) === CommonConstants.CARD_DIMENSION_1x1) {
      return radius;
    }
    try {
      // 如果主题包中设置了radius，则使用主题包资源，此时不需要做G2圆角规避
      let themeRadius = -1;
      themeRadius = ResUtils.getConvertNumber($r('app.float.icon_radius'));
      if (themeRadius >= 0) {
        log.showInfo(`get theme radius: ${themeRadius}`);
        return radius;
      }
    } catch (e) {
      log.showError(`getConvertNumber error: ${e?.message}`);
    }

    // 底座要求G2圆角的边长半径比要大于3.5，不满足时画不了G2圆角会有截断，当前根据ux诉求短期内在不满足G2时调小圆角大小规避截断
    let formItemWidth: number = this.mFormWidth.get(String(dimension)) as number;
    let formItemHeight: number = this.mFormHeight.get(String(dimension)) as number;
    let minHeight: number = Math.min(formItemWidth, formItemHeight);
    return minHeight / BORDER_G2 > radius ? radius : minHeight / BORDER_G2;
  }

  /**
   * Get form radius
   *
   * @param cardDimension card dimension
   * @returns form radius
   */
  getFormBorderRadius(cardDimension?: number, isShortcutForm?: boolean): number {
    let radius: number = this.getRadius(false, cardDimension, isShortcutForm);
    radius = this.updateFormBorderRadiusToG2(radius, cardDimension);
    return radius;
  }

  getBlurRatio(cardDimension?: number): number {
    let dimension: number = cardDimension as number;
    if (dimension === CommonConstants.CARD_DIMENSION_1x2 || dimension === CommonConstants.CARD_DIMENSION_2x2) {
      return 2;
    } else if (dimension === CommonConstants.CARD_DIMENSION_2x4 || dimension === CommonConstants.CARD_DIMENSION_4x4 ||
      dimension === CommonConstants.CARD_DIMENSION_6x4) {
      return 4;
    } else {
      return 1;
    }
  }

  /**
   * Get form radius in preview page
   *
   * @param cardDimension card dimension
   * @returns form radius in preview page
   */
  getFormPreviewBorderRadius(cardDimension?: number): number {
    return this.getRadius(true, cardDimension);
  }

  getRadius(isPreview: boolean, cardDimension?: number, isShortcutForm?: boolean): number {
    if (isShortcutForm) {
      return CommonConstants.DEFAULT_ICON_RADIUS;
    }
    let result: number = CommonConstants.INVALID_VALUE;
    if (CheckEmptyUtils.isEmpty(cardDimension) || (cardDimension as number) === CommonConstants.CARD_DIMENSION_1x1) {
      return result;
    }

    // small form: 1*2 and 2*1
    if ((cardDimension as number) === CommonConstants.CARD_DIMENSION_1x2) {
      result =
        isPreview ? (this.mFormPreviewBorderRadius.get(CommonConstants.CARD_DIMENSION_1x2.toString()) as number) :
          (this.mFormBorderRadius.get(CommonConstants.CARD_DIMENSION_1x2.toString()) as number);
    } else {
      // big form: 2*2 and bigger
      result =
        isPreview ? (this.mFormPreviewBorderRadius.get(CommonConstants.CARD_DIMENSION_2x2.toString()) as number) :
          (this.mFormBorderRadius.get(CommonConstants.CARD_DIMENSION_2x2.toString()) as number);
    }

    if (CheckEmptyUtils.isEmpty(result)) {
      result = CommonConstants.INVALID_VALUE;
    }
    return result;
  }

  getFormSizeOffset(themeInfo: ThemeStyleInfo, defaultOffset: number): number {
    if (CheckEmptyUtils.isEmpty(themeInfo.iconSizeScale)) {
      return defaultOffset;
    }
    return this.getIconSizeScaleValidValue(themeInfo.iconSizeScale as number);
  }

  getFormSizeOffsetSecure(desktopIconChangeSize: number, defaultOffset: number): number {
    if (launcherStatusUtil.getShowOutLauncherStatus()) {
      return defaultOffset;
    }
    if (IconCommonUtil.isValidIconSizeChange(desktopIconChangeSize)) {
      return this.getIconSizeScaleValidValue(desktopIconChangeSize);
    }
    return defaultOffset;
  }

  updateFormPreviewConfig(formBaseConfig: CalculateFormRst, formItemSizeOffset: number): void {
    let themeInfo: ThemeStyleInfo = ThemeStylePreviewManager.getInstance().getThemeStyle();
    if (!CheckEmptyUtils.isEmpty(themeInfo.radiusSizeScale)) {
      this.mFormPreviewBorderRadius.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
        RadiusUtil.calculateSmallFormRadius(true));
      this.mFormPreviewBorderRadius.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
        RadiusUtil.calculateBigFormRadius(true));
    } else {
      this.mFormPreviewBorderRadius.set(CommonConstants.CARD_DIMENSION_1x2.toString(), CommonConstants.INVALID_VALUE);
      this.mFormPreviewBorderRadius.set(CommonConstants.CARD_DIMENSION_2x2.toString(), CommonConstants.INVALID_VALUE);
    }
    let sizePreviewOffset: number = this.getFormSizeOffset(themeInfo, formItemSizeOffset);
    this.mFormPreviewWidth.set(CommonConstants.CARD_DIMENSION_1x1.toString(),
      formBaseConfig.widthDimension0 as number + sizePreviewOffset);
    this.mFormPreviewHeight.set(CommonConstants.CARD_DIMENSION_1x1.toString(),
      formBaseConfig.heightDimension0 as number + sizePreviewOffset);
    this.mFormPreviewWidth.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
      formBaseConfig.widthDimension1 as number + sizePreviewOffset);
    this.mFormPreviewHeight.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
      formBaseConfig.heightDimension1 as number + sizePreviewOffset);
    this.mFormPreviewWidth.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
      formBaseConfig.widthDimension2 as number + sizePreviewOffset);
    this.mFormPreviewHeight.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
      formBaseConfig.heightDimension2 as number + sizePreviewOffset);
    this.mFormPreviewWidth.set(CommonConstants.CARD_DIMENSION_2x4.toString(),
      formBaseConfig.widthDimension3 as number + sizePreviewOffset);
    this.mFormPreviewHeight.set(CommonConstants.CARD_DIMENSION_2x4.toString(),
      formBaseConfig.heightDimension3 as number + sizePreviewOffset);
    this.mFormPreviewWidth.set(CommonConstants.CARD_DIMENSION_4x4.toString(),
      formBaseConfig.widthDimension4 as number + sizePreviewOffset);
    this.mFormPreviewHeight.set(CommonConstants.CARD_DIMENSION_4x4.toString(),
      formBaseConfig.heightDimension4 as number + sizePreviewOffset);
    this.mFormPreviewWidth.set(CommonConstants.CARD_DIMENSION_6x4.toString(),
      formBaseConfig.widthDimension5 as number + sizePreviewOffset);
    this.mFormPreviewHeight.set(CommonConstants.CARD_DIMENSION_6x4.toString(),
      formBaseConfig.heightDimension5 as number + sizePreviewOffset);
  }

  getIconSizeScaleValidValue(iconSizeScale: number): number {
    // only support [-6, 8] for iconSizeScale
    if (iconSizeScale < ICON_SIZE_SCALE_MIN) {
      return ICON_SIZE_SCALE_MIN;
    }
    if (iconSizeScale > ICON_SIZE_SCALE_MAX) {
      return ICON_SIZE_SCALE_MAX;
    }
    return iconSizeScale;
  }

  private refreshFormBorderRadius(): void {
    if (DeviceHelper.isPC()) {
      this.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
        FormStyleConstants.FORM_BORDER_RADIUS_PC);
      this.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
        FormStyleConstants.FORM_BORDER_RADIUS_PC);
      return;
    }
    this.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_1x2.toString(),
      RadiusUtil.calculateSmallFormRadius(false));
    this.mFormBorderRadius.set(CommonConstants.CARD_DIMENSION_2x2.toString(),
      RadiusUtil.calculateBigFormRadius(false));
  }
}
