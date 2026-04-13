/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { display } from '@kit.ArkUI';
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DisplayUtils, GlobalStatusCache, StatusCacheConst } from '@ohos/screenlockcommon';
import { DisplayStateManager } from '@ohos/screenlockcommon/Index';
import { ClockComFamily, ClockLayout } from '../../common/WidgetParam';
import { clockLayoutParam } from './ClockLayoutParam';
import { SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { AnyClock, DIMENSION_4_2_GRID_AMOUNT_X } from '../../editsheet/models/AnyClock';
import { ScreenBp, SizeBp } from '@ohos/screenlockcommon';
import { UIContext } from '@ohos.arkui.UIContext';
import { slStateHelper } from '../../common/utils/SlStateHelper';

export const LETTER_SPACING: number = -2;

export const N4_CLOCK_LAYOUT_WIDTH_AMOUNT: number = 4;
export const DEFAULT_CLOCK_LAYOUT_WIDTH_AMOUNT: number = 2;

const IS_DEVICE_PAD = DeviceHelper.isPadOr2in1PcType();
const IS_ULTRA_SCREEN = DeviceHelper.isUltraScreenProduct();
const IS_SMALL_FOLD: boolean = DeviceHelper.isSmallFoldProduct();
const IS_FOLD_DEVICE: boolean = DeviceHelper.isFold();

// Layout margin in horizontal
const NORMAL_GRID_MARGIN: number = 24;
const ULTRA_SCREEN_M_GRID_MARGIN = 54;
const PAD_GRID_MARGIN: number = 99;
const SMALL_FOLD_GRID_MARGIN: number = 20;

// Layout margin in vertical
const NORMAL_VERTICAL_GRID_MARGIN: number = 104;
const FOLD_GRID_MARGIN_BOTTOM: number = 111;
const FOLD_GRID_WIDTH: number = 78;
const SMALL_FOLD_GRID_WIDTH: number = 48;
const PAD_GRID_MARGIN_BOTTOM: number = 112;

// Layout grid amount
const NORMAL_GRID_AMOUNT_X: number = 4; // CLOCK+LUNAR TOTAL POS
const NORMAL_GRID_AMOUNT_Y: number = 7;
const SINGLE_POCKET_GRID_AMOUNT_X: number = 6;
const SINGLE_POCKET_GRID_AMOUNT_Y: number = 4;
const SINGLE_POCKET_EXPAND_GRID_AMOUNT_Y: number = 7;
const PAD_GRID_INSIDE_AMOUNT_X: number = 10;
const PAD_GRID_INSIDE_AMOUNT_Y: number = 6;
const FOLDER_GRID_INSIDE_AMOUNT_X: number = 8;
const FOLDER_GRID_INSIDE_AMOUNT_Y: number = 7;
const GRID_AMOUNT_4: number = 4;

// Three-fold layout grid with valid range
const FOLD_GRID_WIDTH_MIN: number = 70;
const FOLD_GRID_WIDTH_MAX: number = 90;

const TAG = 'ClockLayoutHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 网格数量信息
 */
export interface GridAmount {
  x: number;
  y: number;
}

export interface WidgetSize {
  width: number;
  height: number;
}

/**
 * 时钟布局参数辅助类
 */
export class ClockLayoutHelper {
  private isFoldExpand: boolean = DeviceHelper.isFullDisplayMode();

  /**
   * 锁屏页面是否可旋转，默认不可旋转
   */
  protected isScreenSessionRotatable: boolean = false;

  /**
   * 设置锁屏页面可旋转状态
   *
   * @param isRotatable 是否可旋转
   */
  public setScreenSessionRotatable(isRotatable?: boolean): void {
    this.isScreenSessionRotatable = isRotatable ?? false;
  }

  /**
   * 获取当前设备宽度.
   *
   * @returns 当前设备的宽
   */
  public getScreenWidth(): number {
    let screenWidth: number = GlobalStatusCache.getInstance()
      .getStatus(StatusCacheConst.SCREEN_WIDTH_KEY, 0) as number;
    if (screenWidth === 0) {
      let screenDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
      if (screenDisplay === undefined) {
        return 0;
      }
      screenWidth = screenDisplay.width;
    }
    return this.px2vpWithUiContext(screenWidth);
  }

  /**
   * 获取当前设备高度.
   *
   * @returns 当前设备的高
   */
  public getScreenHeight(): number {
    let screenHeight: number = GlobalStatusCache.getInstance()
      .getStatus(StatusCacheConst.SCREEN_HEIGHT_KEY, 0) as number;
    if (screenHeight === 0) {
      let screenDisplay: display.Display | undefined = DisplayUtils.getDefaultDisplaySync();
      if (screenDisplay === undefined) {
        return 0;
      }
      screenHeight = screenDisplay.height;
    }
    return this.px2vpWithUiContext(screenHeight);
  }

  /**
   * 是否为折叠屏展开态
   *
   * @returns true是，false不是
   */
  public isFoldExpanded(): boolean {
    return DisplayStateManager.getInstance().isFoldExpanded();
  }

  /**
   * 当前显示屏幕是否为展开屏
   *
   * @returns boolean
   */
  public isFullDisplayMode(): boolean {
    if (!DeviceHelper.isFoldButNotSmallFoldProduct()) {
      return false;
    }
    if (IS_ULTRA_SCREEN) {
      return false;
    }
    let screenBp = slStateHelper.getSlStaticState()?.getSlState(SlStaticStateType.SCREEN_BP) as ScreenBp;
    // 屏幕高度断点为md，则表示大屏幕机展开状态
    let isFoldExpanded = screenBp?.heightBp === SizeBp.MD;
    return isFoldExpanded;
  }

  /**
   * 获取当前设备横向网格的左右边距.
   *
   * @returns 当前设备左右边距
   */
  public getHorizontalGridMargin(isPortrait: boolean): number {
    if (IS_DEVICE_PAD || (this.isFoldExpanded() && !IS_SMALL_FOLD) ||
      (IS_ULTRA_SCREEN && !DisplayUtils.isUltraScreenFStatus())) {
      return this.calculateGridMargin(isPortrait, this.getScreenWidth());
    }
    // 折叠屏未展开场景，锁屏时钟保持竖屏
    if (IS_FOLD_DEVICE && !this.isFoldExpanded() && !IS_SMALL_FOLD ||
      (IS_ULTRA_SCREEN && DisplayUtils.isUltraScreenFStatus())) {
      return this.calculateGridMargin(isPortrait, Math.min(this.getScreenHeight(), this.getScreenWidth()));
    }
    return NORMAL_GRID_MARGIN;
  }

  private calculateGridMargin(isPortrait: boolean, screenWidth: number): number {
    let gridAmount: GridAmount = this.getLayoutGridAmount(isPortrait);
    let gridWidth: number = this.getLayoutGridWidth(isPortrait);
    return (screenWidth - gridWidth * gridAmount.x) / 2;
  }

  /**
   * 获取当前设备锁头横向的左右边距.
   *
   * @returns 当前设备锁头左右边距
   */
  public getHorizontalLockIconMargin(): number {
    if (IS_DEVICE_PAD) {
      return PAD_GRID_MARGIN;
    }
    return NORMAL_GRID_MARGIN;
  }

  /**
   * 获取当前设备的横向网格数.
   *
   * @param isPortrait 当前是否竖屏
   * @returns 横向网格数
   */
  public getLayoutGridAmount(isPortrait: boolean, isSubScreen?: boolean): GridAmount {
    // PAD或超大屏G态，区分横竖屏
    if (this.isUseLargeLayoutAmount()) {
      if (isPortrait) {
        return { x: PAD_GRID_INSIDE_AMOUNT_Y, y: PAD_GRID_INSIDE_AMOUNT_X };
      }
      return { x: PAD_GRID_INSIDE_AMOUNT_X, y: PAD_GRID_INSIDE_AMOUNT_Y };
    }

    // 折叠展开或超大屏M态
    if (this.isUseMediumLayoutAmount(this.isFullDisplayMode())) {
      return { x: FOLDER_GRID_INSIDE_AMOUNT_X, y: FOLDER_GRID_INSIDE_AMOUNT_Y };
    }
    return { x: NORMAL_GRID_AMOUNT_X, y: NORMAL_GRID_AMOUNT_Y };
  }

  private isUseLargeLayoutAmount(): boolean {
    return IS_DEVICE_PAD || (IS_ULTRA_SCREEN && DisplayUtils.isUltraScreenGStatus());
  }

  private isUseMediumLayoutAmount(isFoldExpanded: boolean): boolean {
    return isFoldExpanded && !IS_SMALL_FOLD || (IS_ULTRA_SCREEN && DisplayUtils.isUltraScreenMStatus());
  }

  /**
   * 获取当前设备的横向网格数.
   *
   * @param isPortrait 当前是否竖屏
   * @returns 横向网格数
   */
  public getLayoutAmount(isPortrait: boolean, isFoldExpanded: boolean, isSubScreen?: boolean): GridAmount {
    // PAD
    if (this.isUseLargeLayoutAmount()) {
      if (isPortrait) {
        return { x: PAD_GRID_INSIDE_AMOUNT_Y, y: PAD_GRID_INSIDE_AMOUNT_X };
      }
      return { x: PAD_GRID_INSIDE_AMOUNT_X, y: PAD_GRID_INSIDE_AMOUNT_Y };
    }

    if (this.isUseMediumLayoutAmount(isFoldExpanded)) {
      return { x: FOLDER_GRID_INSIDE_AMOUNT_X, y: FOLDER_GRID_INSIDE_AMOUNT_Y };
    }
    return { x: NORMAL_GRID_AMOUNT_X, y: NORMAL_GRID_AMOUNT_Y };
  }

  /**
   * 获取当前设备的网格宽度
   *
   * @param isPortrait 当前是否竖屏
   * @returns 单个网格的宽度
   */
  public getLayoutGridWidth(isPortrait: boolean): number {
    try {
      let isFold:boolean = DeviceHelper.isFold();
      let isLandscape:boolean = DeviceHelper.isLandscape();
      if (this.isFoldFixedGrid(isFold, isLandscape)) {
        return FOLD_GRID_WIDTH;
      }

      let layoutGridAmount: GridAmount = this.getLayoutGridAmount(isPortrait);
      if (IS_DEVICE_PAD) {
        return this.getLayoutGridWidthPad(PAD_GRID_MARGIN, layoutGridAmount);
      }
      const screenDisplay: display.Display = display?.getDefaultDisplaySync();
      let screenWidth = this.px2vpWithUiContext(screenDisplay.width);
      let screenHeight = this.px2vpWithUiContext(screenDisplay.height);
      let calcWidth = screenWidth;
      let calcHeight = screenHeight;
      if (!this.isScreenSessionRotatable) { // 当锁屏页面不可旋转时，保持竖屏宽高
        calcWidth = Math.min(screenWidth, screenHeight);
        calcHeight = Math.max(screenWidth, screenHeight);
      }
      if (IS_ULTRA_SCREEN) {
        return this.getLayoutGridWidthUltraScreen(layoutGridAmount, calcWidth, calcHeight, isLandscape);
      }
      let singleWidth = (calcWidth - (NORMAL_GRID_MARGIN) * 2) / layoutGridAmount.x;
      let singleHeight =
        (calcHeight - NORMAL_VERTICAL_GRID_MARGIN * 2) / layoutGridAmount.y;
      if (isFold && isLandscape && layoutGridAmount.y !== 0) {
        singleHeight = (calcHeight - NORMAL_VERTICAL_GRID_MARGIN - FOLD_GRID_MARGIN_BOTTOM) / layoutGridAmount.y;
      }
      let singleGridWidth: number = Math.min(singleWidth, singleHeight);
      return singleGridWidth;
    } catch {
      log.showError('getLayoutGridWidth failed');
      return 0;
    }
  }

  private getLayoutGridWidthUltraScreen(layoutGridAmount: GridAmount, screenWidth: number, screenHeight: number,
    isLandscape:boolean): number {
    if (!layoutGridAmount || !layoutGridAmount.x || !layoutGridAmount.y) {
      log.showWarn('layoutGridAmount invalid');
      return FOLD_GRID_WIDTH;
    }
    let singleWidth = (screenWidth - NORMAL_GRID_MARGIN * 2) / layoutGridAmount.x;
    let singleHeight = (screenHeight - NORMAL_VERTICAL_GRID_MARGIN * 2) / layoutGridAmount.y;
    if (DisplayUtils.isUltraScreenMStatus() && !isLandscape) {
      singleWidth = (screenWidth - ULTRA_SCREEN_M_GRID_MARGIN * 2) / layoutGridAmount.x;
    }
    if (DisplayUtils.isUltraScreenMStatus() && isLandscape) {
      singleHeight = (screenHeight - NORMAL_VERTICAL_GRID_MARGIN - FOLD_GRID_MARGIN_BOTTOM) / layoutGridAmount.y;
    }
    if (DisplayUtils.isUltraScreenGStatus()) {
      singleWidth = (Math.min(screenWidth, screenHeight) - PAD_GRID_MARGIN - PAD_GRID_MARGIN_BOTTOM) /
      Math.min(layoutGridAmount.x, layoutGridAmount.y);
      singleHeight = (Math.max(screenWidth, screenHeight) - PAD_GRID_MARGIN - PAD_GRID_MARGIN_BOTTOM) /
      Math.max(layoutGridAmount.x, layoutGridAmount.y);
    }
    let singleGridWidth: number = Math.min(singleWidth, singleHeight);
    if (FOLD_GRID_WIDTH_MIN > singleGridWidth || FOLD_GRID_WIDTH_MAX < singleGridWidth) {
      log.showWarn(`caught invalid grid width for three-fold: ${singleGridWidth} with screen width ${screenWidth}` +
        ` height ${screenHeight} and grid amount x:${layoutGridAmount.x} y:${layoutGridAmount.y}`);
      return FOLD_GRID_WIDTH;
    }
    log.showInfo(`getLayoutGridWidthUltraScreen singleGridWidth : ${singleGridWidth}, ${screenWidth}, ${screenHeight}`);
    return singleGridWidth;
  }

  private px2vpWithUiContext(length: number): number {
    let uiContext: UIContext =
      slStateHelper.getSlStaticState()?.getSlState(SlStaticStateType.SL_UI_CONTEXT) as UIContext;
    if (uiContext) {
      return uiContext.px2vp(length);
    } else {
      return px2vp(length);
    }
  }

  private isFoldFixedGrid(isFold: boolean, isLandscape: boolean): boolean {
    // 折叠屏竖屏场景或非展开场景
    return isFold && (!isLandscape || !this.isFoldExpanded()) && !IS_ULTRA_SCREEN;
  }

  /**
   * 获取Pad设备的网格宽度
   *
   * @param horizontalGridMargin 左右边距
   * @param layoutGridAmount 网格数量
   * @returns 单个网格的宽度
   */
  private getLayoutGridWidthPad(horizontalGridMargin: number, layoutGridAmount: GridAmount): number {
    if (layoutGridAmount.x <= 0 || layoutGridAmount.y <= 0) {
      log.showWarn(`clock layout grid x: ${layoutGridAmount.x}, y: ${layoutGridAmount.y}`);
      return 0;
    }
    let singleGridWidth: number;
    let width: number = this.getScreenWidth();
    let height: number = this.getScreenHeight();
    let singleWidth = (Math.min(width, height) - horizontalGridMargin - this.getGridMarginBottom()) /
      Math.min(layoutGridAmount.x, layoutGridAmount.y);
    let singleHeight = (Math.max(width, height) - horizontalGridMargin - this.getGridMarginBottom()) /
      Math.max(layoutGridAmount.x, layoutGridAmount.y);
    singleGridWidth = Math.min(singleWidth, singleHeight);
    return singleGridWidth;
  }

  private getGridMarginBottom(): number {
    return PAD_GRID_MARGIN_BOTTOM;
  }

  /**
   * 获取布局大小
   *
   * @returns 时钟布局的大小
   */
  public getLayoutSize(gridWidth: number, gridAmount: GridAmount): WidgetSize {
    return {
      width: gridAmount.x * gridWidth,
      height: gridAmount.y * gridWidth
    };
  }

  /**
   * 获取时钟的网格布局
   *
   * @returns Widget size
   */
  public getWidgetSize(): WidgetSize {
    return {
      width: clockLayoutParam.gridParam.gridWidthSize,
      height: clockLayoutParam.gridParam.gridHeightSize
    };
  }

  /**
   * 当用户设置默认字体时，锁屏、AOD 合一编辑器预览界面时钟不能跟随主题APP设置的样式
   *
   * @param fontFamily 当前字体
   * @returns 如果为默认字体，返回 HarmonyOS-Sans,否则不做改变
   */
  public adapterTimeViewFontFamily(fontFamily: string): string {
    if ('HarmonyHeiTi' === fontFamily ||
      'HarmonyOS_Serif' === fontFamily ||
      'HarmonyOS_Sans' === fontFamily ||
      'HarmonyOS-Sans' === fontFamily ||
      'HarmonyOS_Round' === fontFamily) {
      return ClockComFamily.HARMONY_CLOCK_01;
    }
    return fontFamily;
  }

  /**
   * 转换当前时钟的位置
   *
   * @param positionX 当前的X坐标
   * @param timeSize 时间大小
   * @param originGridAmount 原始的网格情况
   * @param targetGridAmount 当前的网格情况
   * @returns 转换后的时钟位置
   */
  public adapterTimeViewPositionX(positionX: number, timeSize: number,
                                  originGridAmount: GridAmount, targetGridAmount: GridAmount): number {
    let finalX: number = positionX;
    // 原始网格中心点
    let originCenterX: number = originGridAmount.x / 2;
    // 目标网格中心点
    let targetCenterX: number = targetGridAmount.x / 2;
    log.showInfo(`originCenterX: ${originCenterX}, targetCenterX: ${targetCenterX}`);
    if (originGridAmount.x < targetGridAmount.x) {// 从小往大变，直接从中间为基准线映射
      let offsetX: number = originCenterX - positionX;
      finalX = targetCenterX - offsetX;
    } else if (originGridAmount.x > targetGridAmount.x) {// 从大往小变
      // 时间在屏幕居左的位置
      if (positionX + timeSize / 2 < originCenterX) {
        // 中间往外映射，超出屏幕则固定为屏幕起点
        finalX = Math.max(targetCenterX - (originCenterX - positionX), 0);
      } else {
        // 中间往外映射，超出屏幕则固定为屏幕末尾
        finalX = targetCenterX + positionX - originCenterX;
        if (finalX + timeSize > originGridAmount.x) {
          finalX = originGridAmount.x - timeSize;
        }
      }
    }
    log.showInfo(`positionX: ${positionX}, finalX: ${finalX}`);
    return finalX;
  }

  public isN4Layout(clockLayout: ClockLayout): boolean {
    switch (clockLayout) {
      case ClockLayout.DIMENSION_2_4:
      case ClockLayout.NORMAL_CLOCK_LAYOUT:
      case ClockLayout.NORMAL_CLOCK_REVERSE_LAYOUT:
      case ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT:
      case ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL:
      case ClockLayout.MOUNTAIN_CLOCK_LAYOUT:
      case ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT:
      case ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL:
      case ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR:
      case ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR:
        return true;
      default:
        // 大于等于ART_SIGN_LARGE_SIZE_TOP为艺术签名样式，该样式均为N4Layout
        return clockLayout >= 200;
    }
  }

  /**
   * 适配大小来适配AOD要求（要求为4的倍数）
   *
   * @param px 像素值
   * @returns 适配后的像素值
   */
  public alignSizeForAod(px: number): number {
    px = Math.floor(px);
    const ALIGN_IMAGE_HEIGHT: number = 4;
    if (px % ALIGN_IMAGE_HEIGHT !== 0) {
      px += (ALIGN_IMAGE_HEIGHT - (px % ALIGN_IMAGE_HEIGHT));
    }
    return px;
  }

  /**
   * AOD动效资源（要求为8的倍数）
   *
   * @param px 像素值
   * @returns 适配后的像素值
   */
  public align8ByteForAod(px: number): number {
    px = Math.floor(px);
    const ALIGN_IMAGE_HEIGHT: number = 8;
    if (px % ALIGN_IMAGE_HEIGHT !== 0) {
      px += (ALIGN_IMAGE_HEIGHT - (px % ALIGN_IMAGE_HEIGHT));
    }
    return px;
  }

  public updateClockPosition(clockLayout: ClockLayout, clockObject: AnyClock, gridAmount: GridAmount,
    formHeight: number, panelHeight: number) {
    let maxColumns = gridAmount.x;
    let maxRows = gridAmount.y;
    switch (clockLayout) {
      case ClockLayout.DEFAULT_CLOCK_LAYOUT:
      case ClockLayout.DEFAULT_CLOCK_REVERSE_LAYOUT:
      case ClockLayout.DEFAULT_CLOCK_SPECIAL:
        if (clockObject.getGridAmountWidth() === GRID_AMOUNT_4) {
          clockObject.x = Math.min(clockObject.x + 1, maxColumns - 2);
        }
        break;
      case ClockLayout.NORMAL_CLOCK_LAYOUT:
      case ClockLayout.NORMAL_CLOCK_REVERSE_LAYOUT:
      case ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT:
      case ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL:
      case ClockLayout.MOUNTAIN_CLOCK_LAYOUT:
      case ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT:
      case ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR:
      case ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR:
      case ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL:
        this.updateClockObjectX(clockObject, maxColumns);
        break;
      default:
        break;
    }
    this.updateClockObjectY(clockLayout, clockObject, maxRows, formHeight, panelHeight);
  }

  public updateClockObjectY(clockLayout: ClockLayout, clockObject: AnyClock, maxRows: number,
    formHeight: number, panelHeight: number): void {
    if (clockObject.y === 0) {
      return;
    }
    let clockHeight = clockObject.getGridAmountHeight(clockLayout);
    // 时钟在底部时优先以下边缘基准进行样式变化
    let oldClockHeight: number = clockObject.getGridAmountHeight();
    let isBottom: boolean = oldClockHeight + panelHeight + clockObject.y === maxRows;
    if (clockObject.y + clockHeight + formHeight >= maxRows || isBottom) {
      let positionY: number = maxRows - clockHeight - formHeight;
      if (positionY < 0) {
        log.showWarn(`update clock y, maxRows=${maxRows}, formHeight=${formHeight}, panelHeight=${panelHeight}` +
          `old layout amount=${oldClockHeight}, clockHeight=${clockHeight}`);
        positionY = 0;
      }
      clockObject.y = positionY;
    }
  }

  private updateClockObjectX(clockObject: AnyClock, maxColumns: number): void {
    if (clockObject.getGridAmountWidth() === DIMENSION_4_2_GRID_AMOUNT_X) {
      let positionX: number = clockObject.x;
      // 正常坐标，可能超出屏幕
      positionX = Math.max(positionX - 1, 0);
      // 最大x值，保证不到屏幕外
      const maxPosition: number = Math.max(maxColumns - 4, 0);
      // 不超出屏幕就选正常坐标
      clockObject.x = Math.min(positionX, maxPosition);
    }
  }
}

export let clockLayoutHelper = SingletonHelper.getInstance(ClockLayoutHelper, TAG);

const AOD_TAG = 'AodClockLayoutHelper';

// AOD设置页面时钟工具
class AodClockLayoutHelper extends ClockLayoutHelper {
  protected isScreenSessionRotatable: boolean = true;

  public isFullDisplayMode(): boolean {
    return DeviceHelper.isFullDisplayMode();
  }

  public getLayoutGridWidth(isPortrait: boolean): number {
    const orientation = DeviceHelper.getOrientation();
    const portrait = orientation === display.Orientation.PORTRAIT ||
      orientation === display.Orientation.PORTRAIT_INVERTED;
    return super.getLayoutGridWidth(portrait);
  }

  public isFoldExpanded(): boolean {
    return DeviceHelper.isFoldExpandedOrHalf();
  }
}

export const aodClockHelper = SingletonHelper.getInstance(AodClockLayoutHelper, AOD_TAG);