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
import { desktopUtil } from '@ohos/componenthelper';
import { ResUtils } from '@ohos/windowscene';
import {
  AppListStyleConfig,
  CommonConstants,
  ContractedFolderCommonViewModel,
  DesktopManager,
  DesktopParam,
  FolderCommonConstants,
  FolderCommonUtil,
  GridLayoutConfig,
  layoutConfigManager,
  SettingsModel,
  StyleConstants,
  ThemeStyleManager
} from '../../../TsIndex';
import { AreaSpan } from '../../../utils/GridLayoutUtil';
import { BigFolderStyleConfig } from '../contractedfolder/viewmodel/layout/style/BigFolderStyleConfig';
import { SmallFolderStyleConfig } from '../contractedfolder/viewmodel/layout/style/SmallFolderStyleConfig';
import {
  ContractedFolderLayoutStyle
} from '../contractedfolder/viewmodel/layout/style/ContractedFolderLayoutStyleFactory';
import { ItemsCount } from '../../../utils/GridLayoutUtil';
import { PageDesktopGridStyleConfig } from '../../../layoutconfig/PageDesktopGridStyleConfig';
import { FormStyleConfig } from '../../../configs/FormStyleConfig';

const HALF: number = 0.5;
const TAG = 'FolderStyleManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 文件夹布局样式统一管理器
 */
export class FolderStyleManager {
  private static sInstance: FolderStyleManager;
  // 小文件夹
  private mSmallFolderStyle: SmallFolderStyleConfig;
  // 大文件夹
  private mBigFolderStyle: BigFolderStyleConfig;
  // 桌面布局
  private mDesktopStyle: PageDesktopGridStyleConfig;

  private mFolderWidthMap: Map<string, number> = new Map<string, number>();

  private mFolderHeightMap: Map<string, number> = new Map<string, number>();

  private mFolderNameStyle: ContractedFolderNameStyle = {};

  private mBackgroundBrightness: number = ResUtils.getNumber($r('app.float.ohos_id_blur_style_thin_brightness'));

  private map: Map<string, ContractedFolderLayoutStyle> = new Map<string, ContractedFolderLayoutStyle>();

  private dockZoomScale: number = 1;

  private constructor() {
    this.mSmallFolderStyle = layoutConfigManager.getStyleConfig(SmallFolderStyleConfig.APP_LIST_STYLE_CONFIG,
      FolderCommonConstants.FEATURE_NAME_SMALL_FOLDER) as SmallFolderStyleConfig;
    this.mBigFolderStyle = layoutConfigManager.getStyleConfig(AppListStyleConfig.APP_LIST_STYLE_CONFIG,
      FolderCommonConstants.FEATURE_NAME_BIG_FOLDER) as BigFolderStyleConfig;
    this.mDesktopStyle = layoutConfigManager.getStyleConfig(PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG,
      FolderCommonConstants.FEATURE_NAME_DESKTOP) as PageDesktopGridStyleConfig;
  }

  public static getInstance(): FolderStyleManager {
    if (CheckEmptyUtils.isEmpty(FolderStyleManager.sInstance)) {
      FolderStyleManager.sInstance = new FolderStyleManager();
    }
    return FolderStyleManager.sInstance;
  }

  /**
   * 根据文件夹大小size获取文件夹布局样式style
   *
   * @param area 文件夹大小
   * @returns 文件夹布局样式style
   */
  public getFolderStyleByArea(area: number[], isInDock: boolean = false): ContractedFolderLayoutStyle {
    let folderStyle: ContractedFolderLayoutStyle | undefined = this.map.get(this.generateStyleKey(area, isInDock));
    if (folderStyle) {
      return folderStyle;
    }
    let folderConfig: ContractedFolderLayoutStyle = new ContractedFolderLayoutStyle();
    /* 初始化文件夹网格参数 */
    folderConfig.area = area;
    folderConfig.backgroundWidth = this.getWidthByArea(area);
    folderConfig.backgroundHeight = this.getHeightByArea(area);
    folderConfig.backgroundRadius = this.getFolderRadiusByArea(area);
    folderConfig.countInRow = this.getCountPerRowInFolder(area);
    folderConfig.countInColumn = this.getCountPerColumnInFolder(area);
    folderConfig.mGridGap = this.getFolderGridGap(area);
    folderConfig.mGridMargin = this.getFolderGridMargin(area);
    folderConfig.mFolderAppSize = this.getFolderAppSize(area);
    folderConfig.itemIconRadius = this.getFolderIconRadius(area);
    /* 初始化文件夹名字参数 */
    folderConfig.iconNameMargin = this.mFolderNameStyle.mIconNameMargin as number;
    folderConfig.mNameHeight = this.mFolderNameStyle.mNameHeight as number;
    folderConfig.mNameWidth = this.mFolderNameStyle.mNameWidth as number;
    folderConfig.mNameSize = this.mFolderNameStyle.mNameSize as number;
    folderConfig.mNameLines = this.mFolderNameStyle.mNameLines as number;
    folderConfig.mThemeStyle = ThemeStyleManager.getInstance().getThemeStyle();
    folderConfig.mDesktopIconSize = this.getDesktopIconSize();
    if (isInDock) {
      folderConfig = this.handleDockFolderConfig(folderConfig);
    }
    this.map.set(this.generateStyleKey(area, isInDock), folderConfig);
    if (!FolderCommonUtil.isLayout1X1(area)) {
      ContractedFolderCommonViewModel.getInstance().execQuitAppStyleListener(folderConfig);
    }
    return folderConfig;
  }

  private handleDockFolderConfig(folderConfig: ContractedFolderLayoutStyle): ContractedFolderLayoutStyle{
    const dockIconSize: number = AppStorage.get('dockIconSize') as number ?? this.getDesktopIconSize();
    const dockScale: number  = this.dockZoomScale * dockIconSize/ this.getDesktopIconSize();
    folderConfig.backgroundRadius *= dockScale;
    folderConfig.backgroundWidth *= dockScale;
    folderConfig.backgroundHeight *= dockScale;
    folderConfig.mGridGap *= dockScale;
    folderConfig.mGridMargin *= dockScale;
    folderConfig.mFolderAppSize *= dockScale;
    folderConfig.itemIconRadius *= dockScale;
    folderConfig.mDesktopIconSize *= dockScale;
    return folderConfig;
  }

  private generateStyleKey(area: number[], isInDock: boolean = false): string {
    return `${area[0]}_${area[1]}_${isInDock}`;
  }

  /**
   * 初始化文件夹样式的配置
   */
  public initConfig(): void {
    this.map.clear();
    this.mBigFolderStyle = BigFolderStyleConfig.getInstance();
    this.mSmallFolderStyle = SmallFolderStyleConfig.getInstance();
    this.mFolderWidthMap = this.calculateFolderWidthMap();
    this.mFolderHeightMap = this.calculateFolderHeightMap();
    this.mFolderNameStyle = this.calculateFolderNameStyle();
    this.initDesktopPreviewConfig();
  }

  private initDesktopPreviewConfig(): void {
    let desktopParam: DesktopParam = DesktopManager.getInstance().getDesktopParam();
    desktopParam.bigFolderRadius = this.mBigFolderStyle.mFolderRadius ?? 1;
    desktopParam.smallFolderRadius = this.mSmallFolderStyle.mSmallFolderRadius ?? 1;
  }

  private getFolderWidthX1(): number {
    return this.mFolderWidthMap.get(CommonConstants.CARD_DIMENSION_1x1.toString()) ?? 0;
  }

  private getFolderWidthX2(): number {
    return this.mFolderWidthMap.get(CommonConstants.CARD_DIMENSION_2x2.toString()) ?? 0;
  }

  private getFolderWidthX4(): number {
    return this.mFolderWidthMap.get(CommonConstants.CARD_DIMENSION_2x4.toString()) ?? 0;
  }

  /**
   * 获取 x1 大小
   * @returns 跨度1高度大小
   */
  private getFolderHeightX1(): number {
    return this.mFolderHeightMap.get(CommonConstants.CARD_DIMENSION_1x2.toString()) ?? 0;
  }

  /**
   * 获取 x2 大小
   *
   * @returns 宽度2大小
   */
  private getFolderHeightX2(): number {
    return this.mFolderHeightMap.get(CommonConstants.CARD_DIMENSION_2x2.toString()) ?? 0;
  }

  /**
   * 获取 x4 大小
   * @returns 跨度4高度大小
   */
  private getFolderHeightX4(): number {
    return this.mFolderHeightMap.get(CommonConstants.CARD_DIMENSION_4x4.toString()) ?? 0;
  }

  /**
   * 获取 x6 大小
   * @returns 跨度6高度大小
   */
  private getFolderHeightX6(): number {
    return this.mFolderHeightMap.get(CommonConstants.CARD_DIMENSION_6x4.toString()) ?? 0;
  }

  /**
   * 根据area获取文件夹宽度
   *
   * @param area 文件夹大小
   * @returns 宽度
   */
  public getWidthByArea(area?: number[]): number {
    if (!area || area.length <= 1) {
      return this.getDesktopIconSize();
    }
    if (area[0] === AreaSpan.SPAN_1.valueOf() && area[1] === AreaSpan.SPAN_1.valueOf()) {
      return this.getDesktopIconSize();
    }
    if (this.mFolderWidthMap.size === 0) {
      this.mFolderWidthMap = this.calculateFolderWidthMap();
    }
    if (area[0] === AreaSpan.SPAN_1.valueOf()) {
      return this.getFolderWidthX1();
    } else if (area[0] === AreaSpan.SPAN_2.valueOf()) {
      return desktopUtil.isThreeScreenGState() ? this.getFolderWidthX2() : this.getFolderHeightX2();
    } else {
      return desktopUtil.isThreeScreenGState() ? this.getFolderWidthX4() : this.getFolderWidthX4();
    }
  }

  /**
   * 1*文件夹与其他文件夹宽度的差值，用于拖动改变大小时做动效，避免松手后跳动
   * @param area
   * @returns
   */
  public getWidthGap(area: number[]): number {
    if (area[0] === AreaSpan.SPAN_1.valueOf()) {
      let width: number = 0;
      if (area[1] === AreaSpan.SPAN_1.valueOf()) {
        width = this.getDesktopIconSize();
      } else {
        width = this.getFolderWidthX1();
      }
      return (this.getFolderHeightX2() - (this.getFolderWidthX4() - this.getFolderHeightX2()) * HALF - width) * HALF;
    }
    return 0;
  }

  /**
   * 根据area获取文件夹高度
   *
   * @param area 文件夹大小
   * @returns 高度
   */
  public getHeightByArea(area?: number[]): number {
    if (!area || area.length <= 1) {
      return this.getDesktopIconSize();
    }
    if (area[0] === AreaSpan.SPAN_1.valueOf() && area[1] === AreaSpan.SPAN_1.valueOf()) {
      return this.getDesktopIconSize();
    }
    if (this.mFolderHeightMap.size === 0) {
      this.mFolderHeightMap = this.calculateFolderHeightMap();
    }
    if (area[1] === AreaSpan.SPAN_1.valueOf()) {
      return this.getFolderHeightX1();
    } else if (area[1] === AreaSpan.SPAN_2.valueOf()) {
      return this.getFolderHeightX2();
    } else if (area[1] === AreaSpan.SPAN_4.valueOf()) {
      return this.getFolderHeightX4();
    } else {
      return this.getFolderHeightX6();
    }
  }

  /**
   * 获取每行显示图标数量
   *
   * @param area 文件夹大小
   * @returns 图标数量
   */
  public getCountPerRowInFolder(area: number[]): number {
    if (area.length <= 1) {
      return ItemsCount.SIZE_2.valueOf();
    }
    if (area[0] === AreaSpan.SPAN_1 && area[1] === AreaSpan.SPAN_1) {
      return ItemsCount.SIZE_2.valueOf();
    }
    if (area[0] === AreaSpan.SPAN_1) {
      return ItemsCount.SIZE_1.valueOf();
    } else if (area[0] === AreaSpan.SPAN_4) {
      return ItemsCount.SIZE_4.valueOf();
    } else {
      return ItemsCount.SIZE_2.valueOf();
    }
  }

  /**
   * 获取每列显示的图标数量
   *
   * @param area 文件夹大小
   * @returns 图标数量
   */
  public getCountPerColumnInFolder(area: number[]): number {
    if (area.length <= 1) {
      return ItemsCount.SIZE_2.valueOf();
    }
    if (area[0] === AreaSpan.SPAN_1 && area[1] === AreaSpan.SPAN_1) {
      return ItemsCount.SIZE_2.valueOf();
    }
    if (area[1] === AreaSpan.SPAN_1) {
      return ItemsCount.SIZE_1.valueOf();
    } else if (area[1] === AreaSpan.SPAN_4) {
      return ItemsCount.SIZE_4.valueOf();
    } else {
      return ItemsCount.SIZE_2.valueOf();
    }
  }

  /**
   * 根据area获取文件夹圆角（收缩态文件夹外形；卡片圆角已与此解耦）
   *
   * @param area 文件夹大小
   * @returns 圆角值
   */
  public getFolderRadiusByArea(area?: number[]): number {
    const folderWidth: number = this.getWidthByArea(area);
    const folderHeight: number = this.getHeightByArea(area);
    const shortSide: number = Math.min(folderWidth, folderHeight);
    if (shortSide > 0) {
      // 桌面文件夹外形圆形（1x1 正圆；1x2/2x1 为短边一半的胶囊）
      return shortSide / StyleConstants.DEFAULT_2;
    }
    if (!area || area.length <= 1) {
      return this.mBigFolderStyle.mFolderRadius;
    }
    if (area[0] === AreaSpan.SPAN_1.valueOf() && area[1] === AreaSpan.SPAN_1.valueOf()) {
      return this.mSmallFolderStyle.mSmallFolderRadius;
    }
    if (area[0] === AreaSpan.SPAN_1.valueOf() || area[1] === AreaSpan.SPAN_1.valueOf()) {
      return this.getFormRadiusByDimension(CommonConstants.CARD_DIMENSION_1x2);
    }
    return this.mBigFolderStyle.mFolderRadius;
  }

  private getFormRadiusByDimension(dimension: number): number {
    let formStyle: FormStyleConfig = layoutConfigManager.getStyleConfig(FormStyleConfig.APP_LIST_STYLE_CONFIG,
      FolderCommonConstants.FEATURE_NAME_FORM) as FormStyleConfig;
    if (formStyle) {
      return formStyle.getFormBorderRadius(dimension);
    } else {
      log.showError('formStyle load fail');
      return this.mBigFolderStyle.mFolderRadius;
    }
  }

  /**
   * 获取桌面Grid宽度
   *
   * @returns
   */
  public getDesktopGridWidth(): number {
    return this.mDesktopStyle.mGridWidth / this.mDesktopStyle.mColumns;
  }

  /**
   * 获取文件夹应用图标的大小
   *
   * @param area 文件夹大小
   * @returns 应用图标大小
   */
  public getFolderAppSize(area: number[], isInDock: boolean = false): number {
    if (area[0] === ItemsCount.SIZE_1 && area[1] === ItemsCount.SIZE_1) {
      if(isInDock) {
        return this.mSmallFolderStyle.mFolderAppSize * this.dockZoomScale;
      }
      return this.mSmallFolderStyle.mFolderAppSize;
    } else {
      return this.mBigFolderStyle.mFolderAppSize;
    }
  }

  /**
   * 获取文件夹配置信息
   *
   * @returns 文件夹配置的config
   */
  public getFolderStyleConfig(): BigFolderStyleConfig {
    return this.mBigFolderStyle;
  }

  /**
   * 获取小文件夹配置信息
   *
   * @returns 文件配置的config
   */
  public getSmallFolderStyleConfig(): SmallFolderStyleConfig {
    return this.mSmallFolderStyle;
  }

  /**
   * 设置文件夹背板亮度
   *
   * @param backgroundBrightness 亮度值
   */
  public setBackgroundBrightness(backgroundBrightness: number): void {
    this.mBackgroundBrightness = backgroundBrightness;
  }

  /**
   * 获取文件夹背板亮度值
   *
   * @returns 亮度值
   */
  public getBackgroundBrightness(): number {
    return this.mBackgroundBrightness;
  }

  /**
   * 获取文件夹内图标的圆角
   *
   * @param area 文件夹大小
   * @returns 圆角值
   */
  private getFolderIconRadius(area: number[]): number {
    if (area[0] === ItemsCount.SIZE_1 && area[1] === ItemsCount.SIZE_1) {
      return this.mSmallFolderStyle.mSmallFolderIconRadius ?? 0;
    }
  }

  /**
   * 获取文件夹内应用大小
   *
   * @param area 文件夹大小
   * @returns 应用大小
   */
  private getFolderGridMargin(area: number[]): number {
    if (area[0] === ItemsCount.SIZE_1 && area[1] === ItemsCount.SIZE_1) {
      return this.mSmallFolderStyle.mGridMargin;
    } else {
      return this.mBigFolderStyle.mGridMargin;
    }
  }

  /**
   * 获取文件夹网格间隙
   *
   * @param area 文件夹大小
   * @returns 网格间隙
   */
  private getFolderGridGap(area: number[]): number {
    if (area[0] === ItemsCount.SIZE_1 && area[1] === ItemsCount.SIZE_1) {
      return this.mSmallFolderStyle.mFolderGridGap;
    } else {
      return this.mBigFolderStyle.mFolderGridGap;
    }
  }

  /**
   * 获取桌面图标大小
   *
   * @returns 桌面图标大小
   */
  private getDesktopIconSize(): number {
    let desktopStyle: PageDesktopGridStyleConfig = layoutConfigManager.getStyleConfig(
      PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG, FolderCommonConstants.FEATURE_NAME_DESKTOP) as
      PageDesktopGridStyleConfig;
    return desktopStyle.mIconSize;
  }

  /**
   * 获取文件夹宽度大小的map
   *
   * @returns map
   */
  private calculateFolderWidthMap(): Map<string, number> {
    let formStyle: FormStyleConfig = layoutConfigManager.getStyleConfig(FormStyleConfig.APP_LIST_STYLE_CONFIG,
      FolderCommonConstants.FEATURE_NAME_FORM) as FormStyleConfig;
    let result: Map<string, number> = new Map<string, number>();
    if (formStyle) {
      result = formStyle.mFormWidth;
    }
    return result;
  }

  /**
   * 获取文件夹高度大小的map
   *
   * @returns map
   */
  private calculateFolderHeightMap(): Map<string, number> {
    let formStyle: FormStyleConfig = layoutConfigManager.getStyleConfig(FormStyleConfig.APP_LIST_STYLE_CONFIG,
      FolderCommonConstants.FEATURE_NAME_FORM) as FormStyleConfig;
    let result: Map<string, number> = new Map<string, number>();
    if (formStyle) {
      result = formStyle.mFormHeight;
    }
    return result;
  }

  /**
   * 获取文件夹名字的样式
   *
   * @returns 文件夹名字的样式
   */
  private calculateFolderNameStyle(): ContractedFolderNameStyle {
    let desktopStyle: PageDesktopGridStyleConfig = layoutConfigManager.getStyleConfig(
      PageDesktopGridStyleConfig.APP_GRID_STYLE_CONFIG, FolderCommonConstants.FEATURE_NAME_DESKTOP) as
      PageDesktopGridStyleConfig;
    return {
      mNameHeight: desktopStyle.mNameHeight,
      mNameWidth: desktopStyle.mNameWidth,
      mNameSize: desktopStyle.mNameSize,
      mNameLines: desktopStyle.mNameLines,
      mIconNameMargin: this.mBigFolderStyle.mIconNameMargin + this.mBigFolderStyle.mIconNameMarginTop
    } as ContractedFolderNameStyle;
  }

  /**
   * 获取桌面布局行数
   *
   * @returns 行数
   */
  public getDesktopRowCount(): number {
    return this.mDesktopStyle.mRows;
  }

  /**
   * 获取桌面布局列数
   *
   * @returns 列数
   */
  public getDesktopColumnCount(): number {
    return this.mDesktopStyle.mColumns;
  }

  /**
   * 获取桌面布局图标大小
   *
   * @returns 列数
   */
  public getDesktopAppSize(): number {
    return this.mDesktopStyle.mAppItemSize;
  }

  /**
   * 获取应用名字体颜色
   *
   * @returns 应用名字体颜色
   */
  public getNameFontColor(): string {
    return this.mDesktopStyle.mNameFontColor;
  }

  /**
   * 设置dock缩放系数
   *
   */
  public setDockZoomScale(scale: number): void {
    this.dockZoomScale = scale;
    this.map.delete(this.generateStyleKey([1,1], true));
  }

  /**
   * 获取文件夹背板到父布局GridItem的左间距
   * @param area 文件夹大小
   *
   * @returns 左间距
   */
  public getFolderLeft2Parent(area: number[]): number {
    const folderWidth: number = this.getWidthByArea(area);
    return (this.getDesktopGridWidth() * area[0] - folderWidth) / 2;
  }

  /**
   * 获取文件夹背板到父布局GridItem的上间距
   * @returns 上间距
   */
  public getFolderTop2Parent(): number {
    return this.mDesktopStyle.mItemPadding;
  }
}

/**
 * 文件夹名字样式
 */
export interface ContractedFolderNameStyle {
  /* 文件夹名字高度 */
  mNameHeight?: number,

  /* 文件夹名字宽度 */
  mNameWidth?: number,

  /* 文件夹名字大小 */
  mNameSize?: number,

  /* 文件夹名字行数 */
  mNameLines?: number,

  /* 文件夹名字margin边距 */
  mIconNameMargin?: number,
}