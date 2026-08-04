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

import { CommonUtils, LogDomain, LogHelper, RectInfo } from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ClockComFamily, ClockLayout, ClockWidgetId } from '../../../common/WidgetParam';
import { BatteryPosition, DateWeekLunarStyle } from '../../common/ClockConstants';
import { ClockLayoutHelper, clockLayoutHelper } from '../../common/ClockLayoutHelper';
import {
  ClockGridParam,
  clockLayoutParam,
  ElementConf,
} from '../../common/ClockLayoutParam';
import {
  clockWidgetConfigManager,
} from '../../common/ClockWidgetConfigManager';
import { VisibleKeyWrapper } from '../../common/SignFormKey';
import { DynamicRegion } from '../../common/DynamicRegion';
import { slClockOneShotToDesktopService } from '@ohos/screenlockcommon';
import { DisplayStateManager } from '@ohos/screenlockcommon/Index';
import { AlignKeyWrapper, HVAlign } from '../../common/HorizontalVerticalAlign';
import { PageDesktopOneShotManager } from '@ohos/launchercommon/Index';
import HashMap from '@ohos.util.HashMap';
import { slStateHelper } from '../../../common/utils/SlStateHelper';
import { UDFontAdapterUtil } from '../../common/UDFontAdapterUtil';
import { FontSizeKeyHelper } from '../../common/ClockFontSize';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ClockStaticStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

const TAG = 'ClockStaticData';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const N2_CLOCK_WIDTH: number = 2;
const COLLAPSE_CLOCK_WIDTH: number = 4;
const BASE_CLOCK_LAYOUT_GRID_SIZE: number = 78;
const DESKTOP_PADDING_PERCENT: number = 0.02; // 桌面天气时钟内部padding
const FOLD_DESKTOP_CLOCK_PERCENT: number = 0.8; // 折叠机的桌面天气时钟，时间高度占比
const OTHER_DESKTOP_CLOCK_PERCENT: number = 0.74; // 其他设备的桌面天气时钟，时间高度占比
const DEFAULT_EXPAND_TIME_FONT_SIZE: number = 120; // 展开态时间字体默认大小
const TIME_FONT_WEIGHT: Map<string, FontWeight> = new Map([ // 时间文本字重
  [ClockComFamily.HARMONY_CLOCK_01, FontWeight.Bolder],
  [ClockComFamily.HARMONY_CLOCK_02, FontWeight.Bolder],
  [ClockComFamily.HARMONY_CLOCK_03, FontWeight.Bolder],
  [ClockComFamily.HARMONY_CLOCK_04, FontWeight.Bolder],
  [ClockComFamily.HARMONY_CLOCK_05, FontWeight.Bolder],
  [ClockComFamily.HARMONY_CLOCK_06, FontWeight.Bolder],
  [ClockComFamily.HARMONY_CLOCK_07, FontWeight.Bold],
  [ClockComFamily.HARMONY_CLOCK_08, FontWeight.Bolder]
]);
const FONT_WEIGHT_TO_STR: Map<FontWeight, string> = new Map([
  [FontWeight.Lighter, 'FontWeight.Lighter'],
  [FontWeight.Normal, 'FontWeight.Normal'],
  [FontWeight.Regular, 'FontWeight.Regular'],
  [FontWeight.Medium, 'FontWeight.Medium'],
  [FontWeight.Bold, 'FontWeight.Bold'],
  [FontWeight.Bolder, 'FontWeight.Bolder']
]);

/**
 * 时钟组件静态状态管理
 */
export class ClockStaticData {
  // 天气时钟的布局参数
  private desktopPaddingPercent: number = DESKTOP_PADDING_PERCENT;
  private desktopClockPercent: number = DeviceHelper.isFold() ? FOLD_DESKTOP_CLOCK_PERCENT :
    OTHER_DESKTOP_CLOCK_PERCENT;
  private clockHelper: ClockLayoutHelper = clockLayoutHelper;

  public static sIsClockWidgetExpand: boolean = true; // 当前时钟组件展开状态
  public isClockToCollapseOnDesktop: boolean = false; // 当前时钟组件要进入桌面折叠态
  public isSignVisible: boolean = false; // 个性签名是否可见
  public isEnterpriseSignVisible: boolean = false; // 企业签名是否可见
  public clockLayout?: ClockLayout; // 时钟组件布局样式
  public isScreenPortrait: boolean = true; // 当前是否竖屏
  public isFoldExpanded: boolean = false; // 当前是否折叠屏展开状态
  public layoutGridWidth: number = 0; // 布局网格宽度，与缩放倍数同步更新; 受竖屏状态、折叠屏展开状态、屏幕宽度影响
  public displayScale: number = 1.0; // 当前设备下，时钟布局缩放倍数
  public expandElementConf?: ElementConf[]; // 展开态，时钟元素配置
  public collapseElementConf?: ElementConf[]; // 收起态，时钟元素配置
  public expandAodElementConf?: ElementConf[]; // 局部AOD状态锁屏时钟配置
  public expandGrid?: ClockGridParam; // 展开态，时钟组件网格
  public collapseGrid?: ClockGridParam; // 收起态，时钟组件网格
  public clockMarginLeft: number = 0; // 时钟组件左侧外间距
  public clockMarginTop: number = 0; // 时钟组件顶部外间距
  public dateWeekStyle: DateWeekLunarStyle = DateWeekLunarStyle.STYLE_MULTILINE; // 日期显示样式，默认多行
  public isShowLargeDate: boolean = false; // 当前是否显示日期大样式
  public isMergeWeekLunar: boolean = false; // 当前是否星期、农历合并行显示; 动态个性签名显示场景下
  public isLunarVisible: boolean = false; // 农历是否可见
  public isDateVisible: boolean = false; // 日期是否可见
  public expandDynamicRegion: DynamicRegion = DynamicRegion.wrapper(); // 时钟展开态动态区域
  public collapseDynamicRegion: DynamicRegion = DynamicRegion.wrapper(); // 时钟收起态动态区域
  public collapseShowRegion?: Rectangle; // 时钟收起态显示区域
  public noSignShowRegion?: Rectangle; // 时钟收起态无签名显示区域
  public clockPosition?: Position; // 时钟组件宫格位置
  public horizontalAlign?: HVAlign; // 时钟组件在屏幕的水平位置
  public verticalAlign?: HVAlign; // 时钟组件在屏幕的垂直位置
  public isSubScreen: boolean = false; // 当显示外屏clock时，通过clockWidget传值置为true
  public subScreenGridWidth: number = 0; // 仅当isSubScreen为true时，才应用此GridWidth

  public oneShotCollapseGrid?: ClockGridParam;
  public clockOffsetX: number = 0;
  public clockOffsetY: number = 0;
  private clockRectInfo?: RectInfo;
  private pageDesktopClockRectInfo?: RectInfo;
  public noTimeViewOpacity: number = 1;
  public timeViewOpacity: number = 1;
  public clockViewId?: string;
  public textColor: string = '#FFFFFFFF';
  public textColorOfScreenLockClock: string = '#FFFFFFFF';
  public textColorOfDesktopClock: string = '#FFFFFFFF';
  public textOffSets: HashMap<string, Position> = new HashMap();
  public fontFamily: string = ClockComFamily.HARMONY_CLOCK_01;
  public scaleOptions: ScaleOptions | undefined = undefined;
  public fontSizeAfterSlideUp: number | undefined = undefined;
  public needUpdateDateWeekLunar: boolean = true;
  public batteryPosition?: BatteryPosition;
  private isAodExpand: boolean = false;

  /**
   * 更新时钟组件展开状态
   *
   * @param isExpand true展开
   * @returns true存在变更
   */
  public static updateClockWidgetExpand(isExpand: boolean): boolean {
    if (ClockStaticData.sIsClockWidgetExpand !== isExpand) {
      ClockStaticData.sIsClockWidgetExpand = isExpand;
      log.showInfo(`updateClockWidgetExpand isExpand:${isExpand}`);
      slUiStateMgr.getSlState(SlMainStateType.SL_CLOCK_WG_STATIC_STATE)?.setSlState(
        ClockStaticStateType.IS_CLOCK_EXPAND_STATE, isExpand);
      return true;
    }
    return false;
  }

  public updateClockToCollapseOnDesktop(isClockToCollapseOnDesktop: boolean): boolean {
    if (this.isClockToCollapseOnDesktop !== isClockToCollapseOnDesktop) {
      log.showInfo(`updateClockToCollapseOnDesktop ${isClockToCollapseOnDesktop}`);
      this.isClockToCollapseOnDesktop = isClockToCollapseOnDesktop;
      return true;
    }
    return false;
  }

  /**
   * 时间文本字重
   *
   * @param fontFamily 字体文件
   * @returns 字重
   */
  public getTimeFontWeight(fontFamily: string): FontWeight {
    let result = TIME_FONT_WEIGHT.get(fontFamily);
    if (result) {
      return result;
    }

    return FontWeight.Bolder;
  }

  /**
   * 时间文本字重
   *
   * @param fontFamily 字体文件
   * @returns 字重
   */
  public static getTimeFontWeightStr(fontFamily: string): string {
    let fontWeight = TIME_FONT_WEIGHT.get(fontFamily);
    if (!fontWeight) {
      return 'FontWeight.Bolder';
    }

    return FONT_WEIGHT_TO_STR.get(fontWeight) ?? 'FontWeight.Bolder';
  }

  /**
   * 更新时钟布局样式
   *
   * @param layout 新样式
   * @returns true存在变更
   */
  public updateClockLayout(layout: ClockLayout): boolean {
    if (this.clockLayout !== layout) {
      this.clockLayout = layout;
      log.showWarn(`updateClockLayout current: ${layout}`);
      return true;
    }
    return false;
  }

  /**
   * 获取时钟组件布局样式
   *
   * @returns 布局样式
   */
  public getClockLayoutWithDefault(): ClockLayout {
    return this.clockLayout ?? ClockLayout.DIMENSION_4_4;
  }

  /**
   * 更新竖屏状态
   *
   * @returns true存在变更
   */
  public updateScreenPortrait(): boolean {
    let newPortrait = DisplayStateManager.getInstance().isPortrait();
    if (this.isScreenPortrait !== newPortrait) {
      this.isScreenPortrait = newPortrait;
      return true;
    }
    return false;
  }

  /**
   * 更新折叠屏展开状态
   *
   * @returns true存在变更
   */
  public updateFoldExpand(): boolean {
    let newExpand = DisplayStateManager.getInstance().isFoldExpanded();
    if (this.isFoldExpanded !== newExpand) {
      this.isFoldExpanded = newExpand;
      return true;
    }
    return false;
  }

  /**
   * 更新缩放倍数
   *
   * @returns true存在变更
   */
  public updateDisplayScale(): boolean {
    if (this.isSubScreen) {
      this.layoutGridWidth = this.subScreenGridWidth;
    } else {
      this.layoutGridWidth = this.clockHelper.getLayoutGridWidth(this.isScreenPortrait);
    }
    let newScale = this.layoutGridWidth / BASE_CLOCK_LAYOUT_GRID_SIZE;
    if (!CommonUtils.equals(this.displayScale, newScale)) {
      this.displayScale = newScale;
      log.showInfo(`updateDisplayScale current: ${newScale}`);
      return true;
    }
    return false;
  }

  /**
   * 更新网格参数及元素配置
   */
  public updateGridAndElementConf(): void {
    let layout = this.getClockLayoutWithDefault();
    this.expandElementConf = clockWidgetConfigManager.getExpandClockStyleByType(layout);
    this.updateDynamicElement(this.expandElementConf);
    this.collapseElementConf = clockWidgetConfigManager.getCollapseClockStyleByType(layout);
    this.updateDynamicElement(this.collapseElementConf);
    this.expandGrid = clockWidgetConfigManager.getExpandClockGridType(layout);
    this.collapseGrid = clockWidgetConfigManager.getCollapseClockGridType(layout);
    this.updateDynamicRegion();
    this.oneShotCollapseGrid = clockWidgetConfigManager.getOneShotAniCollapseClockGridType(layout);
    this.expandAodElementConf = clockWidgetConfigManager.getAodClockStyleByType(layout);
    this.updateDynamicElement(this.expandAodElementConf);
  }

  private updateDynamicElement(conf?: ElementConf[]): void { // 刷新动态元素值
    conf?.forEach((item: ElementConf) => {
      let fontSizeKey = FontSizeKeyHelper.getFontSizeKey();
      item.fontSize = item.dynamicFontSizeMap?.getProperty(fontSizeKey) ?? item.fontSize;
      let vKey = AlignKeyWrapper.getVKey({ verticalAlign: this.verticalAlign, eleConf: item });
      let dOffsetY = item.dynamicOffsetYMap?.getProperty(vKey);
      let hKey = AlignKeyWrapper.getHKey({ horizontalAlign: this.horizontalAlign, eleConf: item });
      let dOffsetX = item.dynamicOffsetXMap?.getProperty(hKey);
      if (!CommonUtils.isInvalid(dOffsetY) || !CommonUtils.isInvalid(dOffsetX)) { // 存在动态偏移量
        item.dynamicOffset = { x: dOffsetX ?? item.offset.x, y: dOffsetY ?? item.offset.y };
      } else { // 清空动态偏移量
        item.dynamicOffset = undefined;
      }
      let dAnchorX = item.dynamicAnchorXMap?.getProperty(hKey);
      if (!CommonUtils.isInvalid(dAnchorX)) { // 存在动态锚点
        item.dynamicAnchor = { x: dAnchorX, y: item.anchor.y };
      } else {
        item.dynamicAnchor = undefined;
      }
      let dTextAlign = item.dynamicTextAlignMap?.getProperty(hKey);
      if (!CommonUtils.isInvalid(dTextAlign)) { // 存在动态文本对齐方式
        item.dynamicTextAlign = dTextAlign;
      } else {
        item.dynamicTextAlign = undefined;
      }
      // 竖向动态相对偏移
      item.dynamicDyMap = item.dynamicAlignDyMap?.getProperty(vKey);
    });
  }

  /**
   * 请谨慎调用，调用后锁屏与AO时钟只会保持在展开态
   * 自定义AOD时钟保持在展开态，不能跟随锁屏宫格变化
   * @returns 更改成功否
   */
  public updateIsAodExpand(isAodExpand: boolean): boolean {
    if (this.isAodExpand !== isAodExpand) {
      log.showDebug(`updateIsAodExpand: ${this.clockViewId}, ${isAodExpand}`);
      this.isAodExpand = isAodExpand;
      return true;
    }
    return false;
  }

  /**
   * 当前网格配置
   *
   * @returns 网格配置
   */
  public getCurGrid(): ClockGridParam | undefined {
    const slClockStaticState = slStateHelper.getSlClockStaticState();
    let isClockExpandOnAod = slClockStaticState?.getClockExpandOnAod() ?? false;
    // isClockToCollapseOnDesktop 优先级高于 isClockExpandOnAod
    if (this.isClockToCollapseOnDesktop) {
      return this.oneShotCollapseGrid;
    }

    if (isClockExpandOnAod || this.isAodExpand) {
      log.showDebug(`getCurGrid use expandGrid, clockViewId:${this.clockViewId},` +
        `isClockExpandOnAod:${isClockExpandOnAod},isAodExpand:${this.isAodExpand}`);
      return this.expandGrid;
    }
    return ClockStaticData.sIsClockWidgetExpand ? this.expandGrid : this.collapseGrid;
  }

  public getPreGrid(): ClockGridParam | undefined {
    return ClockStaticData.sIsClockWidgetExpand ? this.expandGrid : this.collapseGrid;
  }

  /**
   * 当前元素布局配置
   *
   * @returns 布局配置
   */
  public getCurElementConf(): ElementConf[] | undefined {
    if (this.isClockToCollapseOnDesktop) {
      return this.collapseElementConf;
    }
    return ClockStaticData.sIsClockWidgetExpand ? this.expandElementConf : this.collapseElementConf;
  }

  /**
   * 获取局部AOD状态，锁屏展开态时钟参数
   * @returns ElementConf[]
   */
  public getExpandAodElementConf(): ElementConf[] | undefined {
    return this.expandAodElementConf;
  }

  public getPreElementConf(): ElementConf[] | undefined {
    return ClockStaticData.sIsClockWidgetExpand ? this.expandElementConf : this.collapseElementConf;
  }

  /**
   * 更新时钟组件外间距
   *
   * @returns true存在变更
   */
  public updateClockViewMargin(): boolean {
    let isClockExpand = ClockStaticData.sIsClockWidgetExpand;
    let isClockExpandOnAod = slStateHelper.getSlClockStaticState()?.getClockExpandOnAod() ?? false;
    // isClockToCollapseOnDesktop 优先级高于 isClockExpandOnAod
    if (isClockExpandOnAod || this.isAodExpand) {
      log.showDebug('updateClockViewMargin isClockExpandOnAod expand');
      isClockExpand = true;
    }
    if (this.isClockToCollapseOnDesktop) {
      isClockExpand = false;
    }
    let marginArray: number[] = this.getClockViewMargin(isClockExpand);
    let newLeftMargin: number = marginArray[0];
    let newTopMargin: number = marginArray[1];
    if (this.clockMarginLeft !== newLeftMargin || this.clockMarginTop !== newTopMargin) {
      this.clockMarginLeft = newLeftMargin;
      this.clockMarginTop = newTopMargin;
      log.showInfo(`updateClockViewMargin: ${newLeftMargin}, ${newTopMargin}`);
      return true;
    }
    return false;
  }

  /**
   * 计算时钟组件外间距
   *
   * @returns [newLeftMargin, newTopMargin]
   */
  public getClockViewMargin(isClockExpand: boolean): number[] {
    let offsetPositionX: number = 0;
    let offsetPositionY: number = 0;
    let layout = this.getClockLayoutWithDefault();
    if (!isClockExpand) { // 特殊布局类型
      if (layout === ClockLayout.DIMENSION_4_4 ||
        layout === ClockLayout.DIMENSION_4_2 ||
        layout === ClockLayout.DEFAULT_CLOCK_LAYOUT ||
        layout === ClockLayout.DEFAULT_CLOCK_REVERSE_LAYOUT ||
        layout === ClockLayout.DEFAULT_CLOCK_SPECIAL) {
        offsetPositionX -= this.getCollapseMargin();
      }
    }
    let gridWidth: number = this.layoutGridWidth;
    let newLeftMargin = offsetPositionX * gridWidth;
    let newTopMargin = offsetPositionY * gridWidth;
    return [newLeftMargin, newTopMargin];
  }

  private getCollapseMargin(): number {
    // 标识横排和竖排的偏置差
    let offset: number = 1;
    let realX: number = this.clockPosition?.x as number;
    let layoutWidth: number = this.clockHelper.getLayoutAmount(this.isScreenPortrait, this.isFoldExpanded,
      this.isSubScreen).x;

    if (realX - offset < 0) {
      offset = realX;
    }

    let isOutBounds: boolean = realX + COLLAPSE_CLOCK_WIDTH - offset > layoutWidth;
    if (isOutBounds) {
      offset = realX + COLLAPSE_CLOCK_WIDTH - layoutWidth;
    }
    // offset 就是时钟所应该向左偏执的距离
    offset = this.dealRtlCollapseMargin(offset);
    log.showInfo(`CollapseMargin realX:${realX} offset:${offset} LW:${layoutWidth} GW:${this.layoutGridWidth}`);
    return offset;
  }

  private dealRtlCollapseMargin(offset: number): number {
    if (!RTLUtil.isRTL()) {
      return offset;
    }
    return COLLAPSE_CLOCK_WIDTH - N2_CLOCK_WIDTH - offset;
  }

  /**
   * 更新日期、星期、农历显示样式
   *
   * @returns true存在变更
   */
  public updateDateWeekLunarStyle(): boolean {
    if (!this.needUpdateDateWeekLunar) {
      return false;
    }
    let grid = this.getCurGrid();
    let isShowLargeDate: boolean = false;
    let curDateWeekStyle = DateWeekLunarStyle.STYLE_MULTILINE;
    let curBatteryPosition: BatteryPosition | undefined = grid?.batteryPosition;
    let isMergeWeekLunar: boolean = this.getSignVisible() && (grid?.dynamicLunar ?? false) ||
      (grid?.isMergeWeekLunar ?? false); // 签名显示时，农历合并到星期行
    if (grid?.dateSeperate) { // 日期离散样式，存在大日期样式
      curDateWeekStyle = DateWeekLunarStyle.STYLE_SEPARATOR;
      isShowLargeDate = grid?.largeDate ?? false;
    } else {
      let isSingleLine = grid?.singleLineDate ?? false;
      if (isSingleLine || isMergeWeekLunar) { // 日期单行样式
        curDateWeekStyle = DateWeekLunarStyle.STYLE_SINGLE_LINE;
      }
    }
    if (this.dateWeekStyle !== curDateWeekStyle || this.isShowLargeDate !== isShowLargeDate ||
      this.isMergeWeekLunar !== isMergeWeekLunar || this.batteryPosition !== curBatteryPosition) {
      this.dateWeekStyle = curDateWeekStyle;
      this.isShowLargeDate = isShowLargeDate;
      this.isMergeWeekLunar = isMergeWeekLunar;
      this.batteryPosition = curBatteryPosition;
      log.showInfo(`updateDateWeekLunarStyle to be ${this.dateWeekStyle} with merge stauts ${this.isMergeWeekLunar},` +
        `battery position: ${this.batteryPosition}`);
      return true;
    }
    return false;
  }

  /**
   * 更新局部AOD时钟样式日期农历组件
   */
  public updatePartDateWeekLunarStyle(style: DateWeekLunarStyle): void {
    this.isMergeWeekLunar = false;
    this.dateWeekStyle = style;
  }

  /**
   * 更新动态区域
   */
  public updateDynamicRegion(): void {
    this.expandDynamicRegion.initFromRegion(this.expandGrid?.dynamicRegion, this.displayScale);
    this.collapseDynamicRegion.initFromRegion(this.collapseGrid?.dynamicRegion, this.displayScale);
    this.updateShowRegion();
  }

  public getSignVisible(): boolean {
    return (this.isSignVisible || this.isEnterpriseSignVisible);
  }

  /**
   * 更新显示区域
   */
  public updateShowRegion(): void {
    let scene = VisibleKeyWrapper.getKey({
      isSignVisible: this.getSignVisible()
    });
    this.collapseShowRegion = this.collapseDynamicRegion.getRegion(scene);
    // 保持无签名
    this.noSignShowRegion = this.collapseDynamicRegion.getRegion(VisibleKeyWrapper.getKey({}));
  }

  // 该方法在一镜到底动效启动/结束的时候调用
  public updateClockOffset(useOldClockRectInfo?: boolean): boolean {
    let newClockOffset = this.getClockOffset(this.isClockToCollapseOnDesktop, useOldClockRectInfo);;
    if (this.clockOffsetX !== newClockOffset[0] || this.clockOffsetY !== newClockOffset[1]) {
      this.clockOffsetX = newClockOffset[0];
      this.clockOffsetY = newClockOffset[1];
      return true;
    }
    return false;
  }

  public updateClockRectInfo(): boolean {
    this.clockRectInfo = ItemUtils.getRectById(this.clockViewId);
    if (this.clockRectInfo.left === 0 && this.clockRectInfo.right === 0) {
      log.warn(`updateClockRectInfo rect invalid ${ClockStaticData.sIsClockWidgetExpand}`);
      const slClockStaticState = slStateHelper.getSlClockStaticState();
      this.clockRectInfo = ClockStaticData.sIsClockWidgetExpand ?
      slClockStaticState?.getExpandClockRectInfo() : slClockStaticState?.getCollapseClockRectInfo();
    }
    log.showInfo(`oneShot updateClockRectInfo rectInfo: ${this.clockRectInfo?.toString()}`);
    return this.clockRectInfo !== undefined;
  }

  public updatePageDesktopClockRectInfo(): void {
    this.pageDesktopClockRectInfo = PageDesktopOneShotManager.getInstance().getClockPosition();
    log.showInfo(`oneShot updateClockOffset pageDesktopClockRectInfo:${this.pageDesktopClockRectInfo.toString()}`);
  }

  /**
   * 计算获取时钟的偏移量，用以和天气时钟竖向顶部对齐，横向居中对齐
   *
   * @param isClockToCollapseOnDesktop 时钟是否要做一镜到底动效到桌面折叠态
   * @param useOldClockRectInfo 是否使用缓存的RectInfo信息
   * @returns 时钟的偏移量
   */
  public getClockOffset(isClockToCollapseOnDesktop: boolean, useOldClockRectInfo?: boolean): number[] {
    let newClockOffsetX = 0;
    let newClockOffsetY = 0;
    if (isClockToCollapseOnDesktop) {
      if (this.clockRectInfo === undefined || !useOldClockRectInfo) {
        this.updateClockRectInfo();
      }
      if (this.pageDesktopClockRectInfo === undefined || !useOldClockRectInfo) {
        this.updatePageDesktopClockRectInfo();
      }

      if (this.clockRectInfo === undefined || this.pageDesktopClockRectInfo === undefined) {
        return [0, 0];
      }
      // 原来的时钟配置文件margin状态
      let sourceMargins =
        this.getClockViewMargin(this.clockRectInfo?.isVertical?.() ?? ClockStaticData.sIsClockWidgetExpand);
      // 新变更的时钟要的配置文件margin状态
      let targetMargins = this.getClockViewMargin(!isClockToCollapseOnDesktop);
      // 处理时钟折叠屏left的px数值有小数时，对最终造成的偏移影响
      let maxWidthSizeAfterAnim =
        px2vp(this.clockHelper.alignSizeForAod(vp2px(clockLayoutParam.gridParam.gridWidthSize)));

      // 求经过margin偏置后,根据桌面时钟偏置差进一步校正位置
      let desktopClockMid = (this.pageDesktopClockRectInfo.left + this.pageDesktopClockRectInfo.right) / 2;
      // 已经移除移除的margin距离X坐标轴  数值始终为负数
      let marginDistance = targetMargins[0] - sourceMargins[0];
      let screenLockClockMid = RTLUtil.isRTL() ?
          (this.clockRectInfo.right - maxWidthSizeAfterAnim / 2 - marginDistance) :
          (this.clockRectInfo.left + maxWidthSizeAfterAnim / 2 + marginDistance);
      newClockOffsetX = desktopClockMid - screenLockClockMid;

      newClockOffsetY = this.pageDesktopClockRectInfo.top -
        (this.clockRectInfo.top + targetMargins[1] - sourceMargins[1]);
      log.showInfo(`getClockOffset,desktopL:${this.pageDesktopClockRectInfo.left},` +
        `desktopR:${this.pageDesktopClockRectInfo.right},screenLockL:${this.clockRectInfo.left}` +
        `screenLockR:${this.clockRectInfo.right},clockW:${maxWidthSizeAfterAnim},newClockOffsetX：${newClockOffsetX}` +
        `tMargin:${targetMargins[0]},sMargin:${sourceMargins[0]},desktopT:${this.pageDesktopClockRectInfo.top}` +
        `screenLockT:${this.clockRectInfo.top},newClockOffsetY:${newClockOffsetY}`);
    } else {
      newClockOffsetX = 0;
      newClockOffsetY = 0;
    }
    return [newClockOffsetX, newClockOffsetY];
  }

  public updateNoTimeViewOpacity(): boolean {
    let newNoTimeViewOpacity = this.getNoTimeViewOpacity(this.isClockToCollapseOnDesktop);
    if (this.noTimeViewOpacity !== newNoTimeViewOpacity) {
      this.noTimeViewOpacity = newNoTimeViewOpacity;
      return true;
    }
    return false;
  }

  public getNoTimeViewOpacity(isClockToCollapseOnDesktop: boolean): number {
    return isClockToCollapseOnDesktop ? 0 : 1;
  }

  public updateTimeViewOpacity(): boolean {
    let newTimeViewOpacity = this.getTimeViewOpacity(this.isClockToCollapseOnDesktop);
    if (this.timeViewOpacity !== newTimeViewOpacity) {
      this.timeViewOpacity = newTimeViewOpacity;
      return true;
    }
    return false;
  }

  private getTimeViewOpacity(isClockToCollapseOnDesktop: boolean): number {
    return isClockToCollapseOnDesktop ? (this.textColorOfDesktopClock === '#000000' ? 0.5 : 1) : 1;
  }

  public setTextColorOnStyleChange(textColor: string): void {
    this.textColorOfScreenLockClock = textColor;
  }

  public setTextColorOfDesktopClock(textColor: string): void {
    log.showInfo(`oneShot setTextColorOfDesktopClock textColor=${textColor}`)
    this.textColorOfDesktopClock = textColor;
  }

  public updateTextColor(): boolean {
    let newTextColor: string;
    if (!this.isClockToCollapseOnDesktop) {
      newTextColor = this.textColorOfScreenLockClock;
    } else {
      newTextColor = this.textColorOfDesktopClock;
    }
    log.showInfo(`oneShot updateTextColor isClockToCollapseOnDesktop=${this.isClockToCollapseOnDesktop} newTextColor=${newTextColor} textColorOfDesktopClock=${this.textColorOfDesktopClock}`)
    if (this.textColor !== newTextColor) {
      this.textColor = newTextColor;
      return true;
    }
    return false;
  }

  /**
   * 更新时钟组件中小时、分隔符、分钟文本的偏移量，用来和天气时钟的时间精确对齐
   * @param fontSizeAfterAnim 动效结束时的时间字号大小，即桌面天气时钟时间的字号大小
   */
  public updateTextOffSets(fontSizeAfterAnim: number): void {
    if (!(this.isClockToCollapseOnDesktop || slStateHelper.getSlClockBindState()?.getClockAodToDesktop())) {
      this.textOffSets.clear();
    } else {
      // 执行updateTextOffSets之前，已经更新了clockLayoutParam
      let maxWidthSizeAfterAnim =
        px2vp(this.clockHelper.alignSizeForAod(vp2px(clockLayoutParam.gridParam.maxWidthSize)));
      let adaptFamily = this.clockHelper.adapterTimeViewFontFamily(this.fontFamily);
      let textSizeConf = clockWidgetConfigManager.getTextSizeConf(adaptFamily);
      if (textSizeConf === undefined) {
        return;
      }
      let hourWidthAfterAnim = textSizeConf.numberWidth as number * fontSizeAfterAnim / textSizeConf.fontSize;
      let hourHeightAfterAnim = textSizeConf.numberHeight as number * fontSizeAfterAnim / textSizeConf.fontSize;
      let separatorWidthAfterAnim = textSizeConf.separatorWidth * fontSizeAfterAnim / textSizeConf.fontSize;

      let startX = (maxWidthSizeAfterAnim - (hourWidthAfterAnim * 4 + separatorWidthAfterAnim)) / 2;
      let offsetXs = [
        startX,
        startX + hourWidthAfterAnim,
        startX + 2 * hourWidthAfterAnim,
        startX + 2 * hourWidthAfterAnim + separatorWidthAfterAnim,
        startX + 3 * hourWidthAfterAnim + separatorWidthAfterAnim
      ]

      // 计算锁屏时钟与天气时钟的top padding的差距
      let collapseElementConf = this.getCurElementConf();
      let clockWidgetTopPadding = 0;
      collapseElementConf?.forEach((conf) => {
        if (conf.id === ClockWidgetId.ID_HOUR0) {
          clockWidgetTopPadding = conf.offset.y as number * this.displayScale;
        }
      });
      if (this.pageDesktopClockRectInfo === undefined) {
        this.updatePageDesktopClockRectInfo();
      }
      let desktopClockHeight = this.pageDesktopClockRectInfo?.height ? this.pageDesktopClockRectInfo?.height : 0;
      // padding设置为百分比时，上下左右内边距均以父容器的width为基础值
      let desktopClockWidth = this.pageDesktopClockRectInfo?.width ? this.pageDesktopClockRectInfo?.width : 0;
      let desktopClockTopPadding = this.desktopPaddingPercent * desktopClockWidth + ((desktopClockHeight -
        this.desktopPaddingPercent * 2 * desktopClockWidth) * this.desktopClockPercent - hourHeightAfterAnim) / 2;
      let offSetY = desktopClockTopPadding + UDFontAdapterUtil.getDesktopClockFontTopPadding(this.fontFamily);
      log.showInfo(`oneShot offSetY=${offSetY} desktopClockTopPadding=${desktopClockTopPadding} clockWidgetTopPadding=${clockWidgetTopPadding} desktopClockHeight=${desktopClockHeight}`);

      let textOffSetIds = [ClockWidgetId.ID_HOUR0, ClockWidgetId.ID_HOUR1, ClockWidgetId.ID_SEPARATOR,
        ClockWidgetId.ID_MINUTE0, ClockWidgetId.ID_MINUTE1];
      for (let i = 0; i < offsetXs.length && i < textOffSetIds.length; i++) {
        this.textOffSets.set(textOffSetIds[i], {x: offsetXs[i], y: offSetY})
      }
    }
  }

  /**
   * 更新时钟的缩放参数，因为横竖屏切换后，桌面天气时钟会被缩放
   */
  public updateScaleOptions(): void {
    if (this.isClockToCollapseOnDesktop) {
      let pageDesktopClock: PageDesktopOneShotManager = PageDesktopOneShotManager.getInstance();
      let itemScale: ScaleOptions = pageDesktopClock.getItemScale();
      if (itemScale.x === 1 && itemScale.y === 1) {
        this.scaleOptions = undefined;
      } else {
        this.scaleOptions = {x:itemScale.x, y:itemScale.y, centerX:itemScale.centerX, centerY:itemScale.centerY};
      }
    } else {
      this.scaleOptions = undefined;
    }
  }

  public updateFontSizeAfterSlideUp(tarFontSize?: number): void {
    if (this.isClockToCollapseOnDesktop) {
      this.fontSizeAfterSlideUp = tarFontSize;
    } else {
      this.fontSizeAfterSlideUp = undefined;
    }
  }

  public updateFontSizeAfterScreenOff(tarFontSize?: number): void {
      this.fontSizeAfterSlideUp = tarFontSize;
  }

  public getScreenLockTimeFontSize(): number {
    let screenLockTimeFontSize = DEFAULT_EXPAND_TIME_FONT_SIZE * this.displayScale;
    if (ClockStaticData.sIsClockWidgetExpand) {
      if (this.expandElementConf && this.expandElementConf[0]) {
        screenLockTimeFontSize = this.expandElementConf[0].fontSize * this.displayScale;
      }
    } else {
      if (this.collapseElementConf && this.collapseElementConf[0]) {
        screenLockTimeFontSize = this.collapseElementConf[0].fontSize * this.displayScale;
      }
    }
    return screenLockTimeFontSize;
  }

  public setClockHelper(clockHelper: ClockLayoutHelper) {
    this.clockHelper = clockHelper;
  }
}