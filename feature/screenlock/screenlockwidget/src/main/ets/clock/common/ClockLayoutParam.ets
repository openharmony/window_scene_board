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

import { CommonUtils, LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { SizeBpSplice, SlWidgetZIndex } from '@ohos/screenlockcommon';
import { UseScene } from '../../../../../Index';
import { ClockTextAlign, ClockWidgetId } from '../../common/WidgetParam';
import { BatteryPosition } from './ClockConstants';
import { ClockLayoutModifier } from './ClockLayoutModifier';
import { DynamicAlignDy } from './DynamicAlignDy';
import { DynamicLength } from './DynamicLength';
import { DynamicNumber } from './DynamicNumber';
import { DynamicRegion } from './DynamicRegion';

export const DEFAULT_MERGE_MARGIN = 8; // 日期、星期等组件合并时默认间距

export enum ElementVerAlign { // 垂直
  LEFT = 'left',
  CENTER = 'center',
  RIGHT = 'right'
}

export enum ElementHorAlign { // 水平
  TOP = 'top',
  CENTER = 'center',
  BOTTOM = 'bottom'
}

/**
 * 时钟组件构建样式管理
 */
export interface ClockBuilderStyle {
  sceneId?: string; // 使用场景下的组件ID后缀
  isMergeDate?: boolean; // 组件合并是否包含日期
  isMergeWeek?: boolean; // 组件合并是否包含星期
  isMergeLunar?: boolean; // 组件合并是否包含农历
  isMergeBattery?: boolean; // 组件合并是否包含电量
  offset?: Position; // 位置偏移
  anchor?: Position; // 锚点
  fontScale?: ScaleOptions; // 字体缩放倍率
  isBatteryVisible?: boolean;
}

/**
 * 时钟的网格信息
 */
export class ClockGridParam {
  public bp?: SizeBpSplice = SizeBpSplice.DEFAULT; // 断点标识
  public maxWidthSize: number = 400;
  public maxHeightSize: number = 546;
  public gridWidthSize: number = 400;
  public gridHeightSize: number = 546;
  public gridWidthAmount: number = 4;
  public gridHeightAmount: number = 4;
  public timeTextWidth: number = 72;
  public timeTextHeight: number = 100;
  public dateTextHeight: number = 21;
  public gridVerticalMargin: number = 0;
  public gridHorizontalMargin: number = 0;
  public clockBottomMargin?: number = 0; // 最底部元素与边框的间距
  public specialSeparator: boolean = false;
  public singleLineDate: boolean = true;
  public dateSeperate: boolean = false;
  public largeDate: boolean = false;
  public dynamicLunar: boolean = false;
  public isTimeSeparate?: boolean = false; // 时钟是否离散显示类型
  public dynamicRegion?: DynamicRegion;
  public isMergeWeekLunar?: boolean = false; // 星期、农历是否合并
  public zIndex?: SlWidgetZIndex; // 该图层的zIndex
  public batteryPosition?: BatteryPosition = BatteryPosition.SEPARATE; // 电量
  public dateWeekLunarMaxWidth?: number; // 日期、星期、农历三个元素整体的最大宽度
}

export class ClockGridParamCorrection {
  public bp?: SizeBpSplice = SizeBpSplice.DEFAULT; // 断点标识
  public singleLineDate: boolean = true;
  public dateSeperate: boolean = false;
  public dynamicLunar: boolean = false;
}

/**
 * 单个元素的布局属性
 */
export class ElementConf {
  public id: ClockWidgetId = ClockWidgetId.NONE;
  public bp?: SizeBpSplice = SizeBpSplice.DEFAULT; // 断点标识
  public fontSize: number = 20;
  public fontSizeScale?: number = 1; // 采用缩放实现字号变换动画
  public offset: Position = { x: 0, y: 0 };
  public dynamicFontSizeMap?: DynamicNumber;
  public dynamicOffset?: Position; // 动态场景偏移量
  public dynamicOffsetXMap?: DynamicLength; // 动态横向偏移量集
  public dynamicOffsetYMap?: DynamicLength; // 动态竖向偏移量集
  public dynamicAlignDyMap?: DynamicAlignDy; // 动态竖向对齐方式下竖向相对偏移值集
  public dynamicDyMap?: DynamicNumber; // 动态竖向相对偏移值集
  public anchor: Position = { x: 0, y: 0 }; // 锚点
  public dynamicAnchor?: Position; // 动态场景锚点
  public dynamicAnchorXMap?: DynamicLength; // 动态横向锚点集
  public maxWidth?: number; // 组件最大宽度
  public isShow: boolean = true;
  public textAlign: ClockTextAlign = ClockTextAlign.CENTER;
  public dynamicTextAlign?: ClockTextAlign; // 动态文本对齐方式
  public dynamicTextAlignMap?: DynamicNumber; // 动态文本对齐方式集
  public fontWeight?: FontWeight;
  public lineHeight?: number;
  public zIndex?: number;
  public child?: ElementConf[];
  public width?: number;
  public height?: number;
  public scaleFlag?: number; // 若不同元素的scaleFlag一致，则缩放时缩放系数也需保持一致
  public needModifyProperties?: boolean; // 是否需要修复字号、位置属性
  public verReMargin?: ReMargin; // 时钟组件内元素间垂直方向相对偏移
  public horReMargin?: ReMargin; // 时钟组件内元素间水平方向相对偏移
  public aodOffset?: Position; // AOD状态偏移量
  public aodAnchor?: Position; // AOD状态锚点
}

/**
 * 时钟组件内元素间相对偏移
 */
export interface ReMargin {
  // 将自己某部位（上、中、下）
  alignSelf: ElementHorAlign | ElementVerAlign;
  // 对齐到目标元素（alignTargetId）某部位（上、中、下）
  alignTarget: ElementHorAlign | ElementVerAlign;
  // 相距距离
  margin: number;
  // 需要对齐的目标元素ID
  alignTargetId?: ClockWidgetId;
}

/**
 * ClockLayoutParam的复制工具类
 */
export class ClockLayoutCopyUtil {
  public static copyGridParam(clockGridParam: ClockGridParam | undefined): ClockGridParam | undefined {
    if (!clockGridParam) {
      return undefined;
    }
    const newGridParam = new ClockGridParam();
    newGridParam.bp = clockGridParam.bp;
    newGridParam.maxWidthSize = clockGridParam.maxWidthSize;
    newGridParam.maxHeightSize = clockGridParam.maxHeightSize;
    newGridParam.gridWidthSize = clockGridParam.gridWidthSize;
    newGridParam.gridHeightSize = clockGridParam.gridHeightSize;
    newGridParam.gridWidthAmount = clockGridParam.gridWidthAmount;
    newGridParam.gridHeightAmount = clockGridParam.gridHeightAmount;
    newGridParam.timeTextWidth = clockGridParam.timeTextWidth;
    newGridParam.timeTextHeight = clockGridParam.timeTextHeight;
    newGridParam.dateTextHeight = clockGridParam.dateTextHeight;
    newGridParam.gridVerticalMargin = clockGridParam.gridVerticalMargin;
    newGridParam.gridHorizontalMargin = clockGridParam.gridHorizontalMargin;
    newGridParam.specialSeparator = clockGridParam.specialSeparator;
    newGridParam.singleLineDate = clockGridParam.singleLineDate;
    newGridParam.dateSeperate = clockGridParam.dateSeperate;
    newGridParam.largeDate = clockGridParam.largeDate;
    newGridParam.dynamicLunar = clockGridParam.dynamicLunar;
    newGridParam.isTimeSeparate = clockGridParam.isTimeSeparate;
    newGridParam.dynamicRegion = clockGridParam.dynamicRegion;
    newGridParam.isMergeWeekLunar = clockGridParam.isMergeWeekLunar;
    newGridParam.zIndex = clockGridParam.zIndex;
    newGridParam.batteryPosition = clockGridParam.batteryPosition;
    newGridParam.dateWeekLunarMaxWidth = clockGridParam.dateWeekLunarMaxWidth;

    return newGridParam;
  }

  /**
   * 复制网格信息，并注入网格断点类型与网格高度
   *
   * @param gridHeightSize 网格高度
   * @param clockGridParam 原有网格数据
   * @param bp 断点类型
   * @param gridHeightAmount 网格数量
   * @param maxHeightSize 网格高度
   * @returns 新的网格信息
   */
  public static copyGridParamWithBpAndGridSize(gridHeightSize: number, clockGridParam: ClockGridParam,
    bp: SizeBpSplice, gridHeightAmount?: number, maxHeightSize?: number): ClockGridParam | undefined {
    let newGridParam: ClockGridParam | undefined = ClockLayoutCopyUtil.copyGridParam(clockGridParam);
    if (!newGridParam) {
      return undefined;
    }
    newGridParam.bp = bp;
    newGridParam.gridHeightSize = gridHeightSize;
    if (maxHeightSize) {
      newGridParam.maxHeightSize = maxHeightSize;
    }
    if (gridHeightAmount) {
      newGridParam.gridHeightAmount = gridHeightAmount;
    }
    return newGridParam;
  }

  public static copyReMargin(reMargin?: ReMargin, scale?: number): ReMargin | undefined {
    if (!reMargin) {
      return undefined;
    }
    return {
      alignSelf: reMargin.alignSelf,
      alignTarget: reMargin.alignTarget,
      margin: reMargin.margin && scale !== undefined ? reMargin.margin * scale : reMargin.margin,
      alignTargetId: reMargin.alignTargetId
    }
  }

  /**
   * 复制新的ElementConf, 并且将其纵向位置偏移指定数值
   *
   * @param conf 原有配置
   * @param offsetY 纵向偏移
   * @returns 新的配置原色
   */
  public static copyElementWithParam(conf?: ElementConf, offsetY?: number, bp?: SizeBpSplice): ElementConf {
    let newConf: ElementConf | undefined = ClockLayoutCopyUtil.copyElement(conf);
    if (!newConf || newConf.offset.y === undefined || offsetY === undefined) {
      return newConf ?? new ElementConf();
    }
    newConf.offset = { x: newConf.offset.x, y: ( newConf.offset.y as number ?? 0) - offsetY };
    newConf.bp = bp;
    return newConf;
  }

  public static copyElement(elementConf: ElementConf | undefined): ElementConf | undefined {
    if (!elementConf) {
      return undefined;
    }
    const newElement = new ElementConf();
    newElement.id = elementConf.id;
    newElement.bp = elementConf.bp;
    newElement.fontSize = elementConf.fontSize;
    newElement.fontSizeScale = elementConf.fontSizeScale;
    newElement.offset = {x: elementConf.offset.x, y: elementConf.offset.y};
    newElement.aodOffset =
      elementConf.aodOffset ? { x: elementConf.aodOffset.x, y: elementConf.aodOffset.y } : elementConf.aodOffset;
    newElement.aodAnchor =
      elementConf.aodAnchor ? { x: elementConf.aodAnchor.x, y: elementConf.aodAnchor.y } : elementConf.aodAnchor;
    newElement.dynamicFontSizeMap = elementConf.dynamicFontSizeMap;
    newElement.dynamicOffset = elementConf.dynamicOffset ? {x: elementConf.dynamicOffset.x,
      y: elementConf.dynamicOffset.y} : elementConf.dynamicOffset;
    newElement.dynamicOffsetXMap = elementConf.dynamicOffsetXMap;
    newElement.dynamicOffsetYMap = elementConf.dynamicOffsetYMap;
    newElement.dynamicAlignDyMap = elementConf.dynamicAlignDyMap;
    newElement.dynamicDyMap = elementConf.dynamicDyMap;
    newElement.anchor = {x: elementConf.anchor.x, y: elementConf.anchor.y};
    newElement.dynamicAnchor = elementConf.dynamicAnchor ? {x: elementConf.dynamicAnchor.x,
      y: elementConf.dynamicAnchor.y} : elementConf.dynamicAnchor;
    newElement.dynamicAnchorXMap = elementConf.dynamicAnchorXMap;
    newElement.maxWidth = elementConf.maxWidth;
    newElement.isShow = elementConf.isShow;
    newElement.textAlign = elementConf.textAlign;
    newElement.dynamicTextAlign = elementConf.dynamicTextAlign;
    newElement.dynamicTextAlignMap = elementConf.dynamicTextAlignMap;
    newElement.fontWeight = elementConf.fontWeight;
    newElement.lineHeight = elementConf.lineHeight;
    newElement.zIndex = elementConf.zIndex;
    newElement.child = elementConf.child;
    newElement.width = elementConf.width;
    newElement.height = elementConf.height;
    newElement.scaleFlag = elementConf.scaleFlag;
    newElement.needModifyProperties = elementConf.needModifyProperties;
    newElement.verReMargin = ClockLayoutCopyUtil.copyReMargin(elementConf.verReMargin);
    newElement.horReMargin = ClockLayoutCopyUtil.copyReMargin(elementConf.horReMargin);

    return newElement;
  }
}

const TAG = 'ClockLayoutParam';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 单个元素的布局属性
 */
@Observed
export class ClockLayoutParam {
  public scale: number = 1.0;
  public gridParam: ClockGridParam = new ClockGridParam();
  public hourConf0: ElementConf = new ElementConf();
  public hourConf1: ElementConf = new ElementConf();
  public separatorConf: ElementConf = new ElementConf();
  public minuteConf0: ElementConf = new ElementConf();
  public minuteConf1: ElementConf = new ElementConf();
  public dateConf: ElementConf = new ElementConf();
  public weekConf: ElementConf = new ElementConf();
  public lunarConf: ElementConf = new ElementConf();
  public signConf: ElementConf = new ElementConf();
  public batteryConf: ElementConf = new ElementConf();
  constructor() {
  }

  /**
   * 初始化时钟布局参数
   *
   * @param elementConfigs 布局配置对象
   */
  public initClockLayoutParam(scale: number, gridParam?: ClockGridParam, elementConfigs?: ElementConf[],
    clockLayoutModifier?: ClockLayoutModifier): void {
    this.scale = scale;
    this.updateGridParam(gridParam);
    this.updateElementConfig(elementConfigs, false, false, clockLayoutModifier);
  }

  /**
   * 更新时钟容器参数
   *
   * @param elementConfigs 布局配置对象
   */
  public updateGridParam(gridParam?: ClockGridParam): void {
    if (!gridParam) {
      return;
    }
    let newGridParam: ClockGridParam = new ClockGridParam();
    newGridParam.singleLineDate = gridParam.singleLineDate;
    newGridParam.dateSeperate = gridParam.dateSeperate;
    newGridParam.largeDate = gridParam.largeDate;
    newGridParam.dynamicLunar = gridParam.dynamicLunar;
    newGridParam.maxWidthSize = gridParam.maxWidthSize * this.scale;
    newGridParam.maxHeightSize = gridParam.maxHeightSize * this.scale;
    newGridParam.gridWidthSize = gridParam.gridWidthSize * this.scale;
    newGridParam.gridHeightSize = gridParam.gridHeightSize * this.scale;
    newGridParam.gridWidthAmount = gridParam.gridWidthAmount;
    newGridParam.gridHeightAmount = gridParam.gridHeightAmount;
    newGridParam.timeTextWidth = gridParam.timeTextWidth * this.scale;
    newGridParam.timeTextHeight = gridParam.timeTextHeight * this.scale;
    newGridParam.dateTextHeight = gridParam.dateTextHeight * this.scale;
    newGridParam.gridVerticalMargin = gridParam.gridVerticalMargin * this.scale;
    newGridParam.gridHorizontalMargin = gridParam.gridHorizontalMargin * this.scale;
    newGridParam.specialSeparator = gridParam.specialSeparator;
    newGridParam.isTimeSeparate = gridParam.isTimeSeparate;
    newGridParam.isMergeWeekLunar = gridParam.isMergeWeekLunar;
    newGridParam.zIndex = gridParam.zIndex;
    newGridParam.batteryPosition = gridParam.batteryPosition;
    newGridParam.dateWeekLunarMaxWidth = gridParam.dateWeekLunarMaxWidth ? gridParam.dateWeekLunarMaxWidth *
      this.scale : gridParam.dateWeekLunarMaxWidth;
    this.gridParam = newGridParam;
  }

  /**
   * 根据动画进度更新时钟容器参数
   *
   * @param elementConfigs 布局配置对象
   */
  public updateGridParamWithProgress(process: number, sourceGridParam?: ClockGridParam,
                                     targetGridParam?: ClockGridParam): void {
    if (!targetGridParam || !sourceGridParam) {
      return;
    }
    let newGridParam: ClockGridParam = new ClockGridParam();
    newGridParam.singleLineDate = targetGridParam.singleLineDate;
    newGridParam.dateSeperate = targetGridParam.dateSeperate;
    newGridParam.largeDate = targetGridParam.largeDate;
    newGridParam.dynamicLunar = targetGridParam.dynamicLunar;
    newGridParam.maxWidthSize = (sourceGridParam.maxWidthSize + (targetGridParam.maxWidthSize -
    sourceGridParam.maxWidthSize) * process) * this.scale;
    newGridParam.maxHeightSize = (sourceGridParam.maxHeightSize + (targetGridParam.maxHeightSize -
    sourceGridParam.maxHeightSize) * process) * this.scale;
    newGridParam.gridWidthSize = (sourceGridParam.gridWidthSize + (targetGridParam.gridWidthSize -
    sourceGridParam.gridWidthSize) * process) * this.scale;
    newGridParam.gridHeightSize = (sourceGridParam.gridHeightSize + (targetGridParam.gridHeightSize -
    sourceGridParam.gridHeightSize) * process) * this.scale;
    newGridParam.gridWidthAmount = targetGridParam.gridWidthAmount;
    newGridParam.gridHeightAmount = targetGridParam.gridHeightAmount;
    newGridParam.timeTextWidth = (sourceGridParam.timeTextWidth + (targetGridParam.timeTextWidth -
    sourceGridParam.timeTextWidth) * process) * this.scale;
    newGridParam.timeTextHeight = (sourceGridParam.timeTextHeight + (targetGridParam.timeTextHeight -
    sourceGridParam.timeTextHeight) * process) * this.scale;
    newGridParam.dateTextHeight = (sourceGridParam.dateTextHeight + (targetGridParam.dateTextHeight -
    sourceGridParam.dateTextHeight) * process) * this.scale;
    newGridParam.gridVerticalMargin = (sourceGridParam.gridVerticalMargin + (targetGridParam.gridVerticalMargin -
    sourceGridParam.gridVerticalMargin) * process) * this.scale;
    newGridParam.gridHorizontalMargin = (sourceGridParam.gridHorizontalMargin + (targetGridParam.gridHorizontalMargin -
    sourceGridParam.gridHorizontalMargin) * process) * this.scale;
    newGridParam.specialSeparator = targetGridParam.specialSeparator;
    newGridParam.isTimeSeparate = targetGridParam.isTimeSeparate;
    newGridParam.isMergeWeekLunar = targetGridParam.isMergeWeekLunar;
    newGridParam.zIndex = targetGridParam.zIndex;
    newGridParam.batteryPosition = targetGridParam.batteryPosition;
    if (sourceGridParam.dateWeekLunarMaxWidth && targetGridParam.dateWeekLunarMaxWidth) {
      newGridParam.dateWeekLunarMaxWidth = (sourceGridParam.dateWeekLunarMaxWidth +
        (targetGridParam.dateWeekLunarMaxWidth - sourceGridParam.dateWeekLunarMaxWidth) * process) * this.scale;
    } else if (targetGridParam.dateWeekLunarMaxWidth) {
      newGridParam.dateWeekLunarMaxWidth = targetGridParam.dateWeekLunarMaxWidth * this.scale;
    }
    this.gridParam = newGridParam;
  }

  /**
   * 更新时钟布局参数
   *
   * @param elementConfigs 布局配置对象
   */
  public updateElementConfig(elementConfigs?: ElementConf[], keepFontSize?: boolean, keepTextAlign?: boolean,
    clockLayoutModifier?: ClockLayoutModifier): void {
    if (!elementConfigs) {
      return;
    }

    elementConfigs.forEach((conf) => {
      this.updateSingleElement(conf, keepFontSize, keepTextAlign);
    });
    this.calcFontSizeByFontFamily(clockLayoutModifier);
  }

  public calcFontSizeByFontFamily(clockLayoutModifier?: ClockLayoutModifier): void {
    this.modifyClockLayout(clockLayoutModifier);
  }

  private modifyClockLayout(clockLayoutModifier?: ClockLayoutModifier) {
    let timeElements: ElementConf[] = [this.hourConf0, this.hourConf1, this.separatorConf, this.minuteConf0,
      this.minuteConf1];
    let dateWeekLunarElements: ElementConf[] = [this.dateConf, this.weekConf, this.lunarConf];
    clockLayoutModifier?.modifyLayout(timeElements, dateWeekLunarElements, this.gridParam);
  }

  public updateSingleElement(conf?: ElementConf, keepFontSize?: boolean, keepTextAlign?: boolean): void { // 更新单个时钟元素参数
    if (!conf) {
      return;
    }

    if (conf.id === ClockWidgetId.ID_HOUR0) {
      this.hourConf0 = this.getNewElementConf(conf, this.hourConf0, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_HOUR1) {
      this.hourConf1 = this.getNewElementConf(conf, this.hourConf1, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_SEPARATOR) {
      this.separatorConf = this.getNewElementConf(conf, this.separatorConf, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_MINUTE0) {
      this.minuteConf0 = this.getNewElementConf(conf, this.minuteConf0, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_MINUTE1) {
      this.minuteConf1 = this.getNewElementConf(conf, this.minuteConf1, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_DATE) {
      this.dateConf = this.getNewElementConf(conf, this.dateConf, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_WEEK) {
      this.weekConf = this.getNewElementConf(conf, this.weekConf, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_LUNA) {
      this.lunarConf = this.getNewElementConf(conf, this.lunarConf, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_COM_SIGN) {
      this.signConf = this.getNewElementConf(conf, this.signConf, keepFontSize, keepTextAlign);
    } else if (conf.id === ClockWidgetId.ID_BATTERY) {
      this.batteryConf = this.getNewElementConf(conf, this.batteryConf, keepFontSize, keepTextAlign);
    }
  }

  public updateTimeFontSize(tarFontSize: number, fontScale: number): void {
    this.hourConf0.fontSize = tarFontSize;
    this.hourConf0.fontSizeScale = fontScale;
    this.hourConf1.fontSize = tarFontSize;
    this.hourConf1.fontSizeScale = fontScale;
    this.separatorConf.fontSize = tarFontSize;
    this.separatorConf.fontSizeScale = fontScale;
    this.minuteConf0.fontSize = tarFontSize;
    this.minuteConf0.fontSizeScale = fontScale;
    this.minuteConf1.fontSize = tarFontSize;
    this.minuteConf1.fontSizeScale = fontScale;
  }

  /**
   * 更新小时位字号
   *
   * @param tarFontSize 更新的目标字号
   * @param isScale 是否采用scale实现字号变换动画
   */
  public updateHourFontSize(tarFontSize: number, isScale: boolean = false): void {
    log.showInfo(`updateHourFontSize currentFontSize:${this.hourConf0.fontSize} tarFontSize:${tarFontSize}  isScale:${isScale}`);
    if (isScale && this.hourConf0.fontSize !== 0 && this.hourConf1.fontSize !== 0) {
      this.hourConf0.fontSizeScale = tarFontSize / this.hourConf0.fontSize;
      this.hourConf1.fontSizeScale = tarFontSize / this.hourConf1.fontSize;
    } else {
      this.hourConf0.fontSizeScale = 1;
      this.hourConf1.fontSizeScale = 1;
      this.hourConf0.fontSize = tarFontSize;
      this.hourConf1.fontSize = tarFontSize;
    }
  }

  /**
   * 更新非小时位字号
   *
   * @param tarFontSize 更新的目标字号
   * @param isScale 是否采用scale实现字号变换动画
   */
  public updateMinuteAndSeparatorFontSize(tarFontSize: number, isScale: boolean = false): void {
    if (isScale && this.separatorConf.fontSize !== 0 && this.minuteConf0.fontSize !== 0 &&
      this.minuteConf1.fontSize !== 0) {
      this.separatorConf.fontSizeScale = tarFontSize / this.separatorConf.fontSize;
      this.minuteConf0.fontSizeScale = tarFontSize / this.minuteConf0.fontSize;
      this.minuteConf1.fontSizeScale = tarFontSize / this.minuteConf1.fontSize;
    } else {
      this.separatorConf.fontSizeScale = 1;
      this.minuteConf0.fontSizeScale = 1;
      this.minuteConf1.fontSizeScale = 1;
      this.separatorConf.fontSize = tarFontSize;
      this.minuteConf0.fontSize = tarFontSize;
      this.minuteConf1.fontSize = tarFontSize;
    }
  }

  public updateSingleElementWithProgress(progress: number, sourceConf?: ElementConf, targetConf?: ElementConf,
                                         keepFontSize?: boolean): void {
    if (!sourceConf || !targetConf) {
      return;
    }

    if (sourceConf.id === ClockWidgetId.ID_HOUR0) {
      this.hourConf0 =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.hourConf0, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_HOUR1) {
      this.hourConf1 =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.hourConf1, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_SEPARATOR) {
      this.separatorConf =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.separatorConf, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_MINUTE0) {
      this.minuteConf0 =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.minuteConf0, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_MINUTE1) {
      this.minuteConf1 =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.minuteConf1, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_DATE) {
      this.dateConf =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.dateConf, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_WEEK) {
      this.weekConf =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.weekConf, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_LUNA) {
      this.lunarConf =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.lunarConf, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_COM_SIGN) {
      this.signConf =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.signConf, keepFontSize);
    } else if (sourceConf.id === ClockWidgetId.ID_BATTERY) {
      this.batteryConf =
        this.getNewElementConfWithProgress(progress, sourceConf, targetConf, this.batteryConf, keepFontSize);
    }
  }

  /**
   * 根据动画进度更新时钟布局参数
   *
   * @param targetElementConfigs 布局配置对象
   */
  public updateElementConfigWithProgress(progress: number, sourceElementConfigs?: ElementConf[],
                                         targetElementConfigs?: ElementConf[], keepFontSize?: boolean): void {
    if (!targetElementConfigs || !sourceElementConfigs) {
      return;
    }
    for (let i = 0; i < targetElementConfigs.length; i++) {
      let targetConf = targetElementConfigs[i];
      let sourceConf = sourceElementConfigs[i];
      this.updateSingleElementWithProgress(progress, sourceConf, targetConf, keepFontSize);
    }
  }

  private getNewElementConf(newConfig: ElementConf, oldElementConf: ElementConf, keepFontSize?: boolean,
    keepTextAlign?: boolean): ElementConf {
    let newElementConfig: ElementConf = new ElementConf();
    newElementConfig.id = newConfig.id;
    newElementConfig.offset.x = this.getValidLength(newConfig.offset.x);
    newElementConfig.offset.y = this.getValidLength(newConfig.offset.y);
    newElementConfig.anchor.x = this.getValidLength(newConfig.anchor.x);
    newElementConfig.anchor.y = this.getValidLength(newConfig.anchor.y);
    if (newConfig.aodOffset) {
      newElementConfig.aodOffset = {};
      newElementConfig.aodOffset.x = this.getValidLength(newConfig.aodOffset.x);
      newElementConfig.aodOffset.y = this.getValidLength(newConfig.aodOffset.y);
    }
    if (newConfig.aodAnchor) {
      newElementConfig.aodAnchor = {};
      newElementConfig.aodAnchor.x = this.getValidLength(newConfig.aodAnchor.x);
      newElementConfig.aodAnchor.y = this.getValidLength(newConfig.aodAnchor.y);
    }
    newElementConfig.fontSize = keepFontSize ? oldElementConf.fontSize : newConfig.fontSize * this.scale;
    if (newConfig.maxWidth) {
      newElementConfig.maxWidth = newConfig.maxWidth * this.scale;
    }
    newElementConfig.isShow = newConfig.isShow;
    newElementConfig.textAlign = keepTextAlign ? oldElementConf.textAlign : newConfig.textAlign;
    newElementConfig.dynamicTextAlign = keepTextAlign ? oldElementConf.dynamicTextAlign : newConfig.dynamicTextAlign;
    if (newConfig.dynamicDyMap) { // 动态竖向相对偏移
      newElementConfig.dynamicDyMap = DynamicNumber.wrapper();
      newConfig.dynamicDyMap.forEach((value, key) => {
        newElementConfig.dynamicDyMap?.buildProperty(key, value * this.scale);
      });
    }
    if (newConfig.dynamicOffset) { // 动态偏移量
      newElementConfig.dynamicOffset = {};
      newElementConfig.dynamicOffset.x = this.getValidLength(newConfig.dynamicOffset.x);
      newElementConfig.dynamicOffset.y = this.getValidLength(newConfig.dynamicOffset.y);
    }
    if (newConfig.dynamicAnchor) { // 动态锚点
      newElementConfig.dynamicAnchor = {};
      newElementConfig.dynamicAnchor.x = this.getValidLength(newConfig.dynamicAnchor.x);
      newElementConfig.dynamicAnchor.y = this.getValidLength(newConfig.dynamicAnchor.y);
    }

    newElementConfig.width = newConfig.width ? newConfig.width * this.scale : newConfig.width;
    newElementConfig.height = newConfig.height ? newConfig.height * this.scale : newConfig.height;
    newElementConfig.needModifyProperties = newConfig.needModifyProperties;
    newElementConfig.verReMargin = ClockLayoutCopyUtil.copyReMargin(newConfig.verReMargin, this.scale);
    newElementConfig.horReMargin = ClockLayoutCopyUtil.copyReMargin(newConfig.horReMargin, this.scale);
    if (!newConfig.fontSizeScale) {
      newElementConfig.fontSizeScale = 1;
    } else {
      newElementConfig.fontSizeScale = newConfig.fontSizeScale;
    }
    return newElementConfig;
  }

  private getNewElementConfWithProgress(progress: number, sourceConfig: ElementConf,
                                        targetConfig: ElementConf, oldElementConf: ElementConf,
                                        keepFontSize?: boolean): ElementConf {
    let newElementConfig: ElementConf = new ElementConf();
    newElementConfig.id = sourceConfig.id;
    this.setPositionWithProgress(sourceConfig.offset, targetConfig.offset, newElementConfig.offset, progress, true);
    this.setPositionWithProgress(sourceConfig.anchor, targetConfig.anchor, newElementConfig.anchor, progress, false);
    newElementConfig.fontSize = keepFontSize ? oldElementConf.fontSize :
      (sourceConfig.fontSize + (targetConfig.fontSize - sourceConfig.fontSize) * progress) * this.scale;
    if (sourceConfig.maxWidth && targetConfig.maxWidth) {
      newElementConfig.maxWidth = (sourceConfig.maxWidth +
        ((targetConfig.maxWidth - sourceConfig.maxWidth) * progress)) * this.scale;
    }
    newElementConfig.isShow = sourceConfig.isShow;
    newElementConfig.textAlign = sourceConfig.textAlign;
    // 取原来的数值，防止滑动跳变
    newElementConfig.dynamicTextAlign = sourceConfig.dynamicTextAlign;

    if (sourceConfig.dynamicDyMap || targetConfig.dynamicDyMap) { // 动态竖向相对偏移
      this.setDynamicDyMap(newElementConfig, sourceConfig, targetConfig, progress);
    }
    if (sourceConfig.dynamicOffset || targetConfig.dynamicOffset) { // 动态偏移量
      this.setDynamicOffset(newElementConfig, sourceConfig, targetConfig, progress);
    }
    if (sourceConfig.dynamicAnchor || targetConfig.dynamicAnchor) { // 动态锚点
      this.setDynamicAnchor(newElementConfig, sourceConfig, targetConfig, progress);
    }
    return newElementConfig;
  }

  private setDynamicAnchor(newElementConfig: ElementConf, sourceConfig: ElementConf, targetConfig: ElementConf,
    progress: number) {
    newElementConfig.dynamicAnchor = {};
    let finalSourceAnchor = sourceConfig.dynamicAnchor ?? sourceConfig.anchor;
    let finalTargetAnchor = targetConfig.dynamicAnchor ?? targetConfig.anchor;
    this.setPositionWithProgress(finalSourceAnchor, finalTargetAnchor,
      newElementConfig.dynamicAnchor, progress, false);
  }

  private setDynamicOffset(newElementConfig: ElementConf, sourceConfig: ElementConf, targetConfig: ElementConf,
    progress: number) {
    newElementConfig.dynamicOffset = {};
    let finalSourceOffset = sourceConfig.dynamicOffset ?? sourceConfig.offset;
    let finalTargetOffset = targetConfig.dynamicOffset ?? targetConfig.offset;
    this.setPositionWithProgress(finalSourceOffset, finalTargetOffset,
      newElementConfig.dynamicOffset, progress, true);
  }

  private setDynamicDyMap(newElementConfig: ElementConf, sourceConfig: ElementConf, targetConfig: ElementConf,
    progress: number) {
    newElementConfig.dynamicDyMap = DynamicNumber.wrapper();
    if (sourceConfig.dynamicDyMap && !targetConfig.dynamicDyMap) {
      sourceConfig.dynamicDyMap.forEach((value, key) => {
        newElementConfig.dynamicDyMap?.buildProperty(key, value * (1 - progress) * this.scale);
      });
    } else if (!sourceConfig.dynamicDyMap && targetConfig.dynamicDyMap) {
      targetConfig.dynamicDyMap.forEach((value, key) => {
        newElementConfig.dynamicDyMap?.buildProperty(key, (value * progress) * this.scale);
      });
    } else if (sourceConfig.dynamicDyMap && targetConfig.dynamicDyMap) {
      sourceConfig.dynamicDyMap.forEach((value, key) => {
        let targetValue = targetConfig.dynamicDyMap?.getProperty(key) ?? 0;
        let curValue = value + (targetValue - value) * progress;
        newElementConfig.dynamicDyMap?.buildProperty(key, curValue * this.scale);
      });
    }
  }

  private setPositionWithProgress(sourceConfigPosition: Position, targetConfigPosition: Position,
                                  newElementConfigPosition: Position, progress: number, isOffset: boolean) {
    let sourceOffsetX = this.getValidLength(sourceConfigPosition.x);
    let sourceOffsetY = this.getValidLength(sourceConfigPosition.y);
    let targetOffsetX = this.getValidLength(targetConfigPosition.x);
    let targetOffsetY = this.getValidLength(targetConfigPosition.y);

    if (sourceOffsetX !== undefined && targetOffsetX !== undefined) {
      if (isOffset) {
        newElementConfigPosition.x = this.computeCurOffset(sourceOffsetX, targetOffsetX, progress);
      } else {
        newElementConfigPosition.x = this.computeCurAnchor(sourceOffsetX, targetOffsetX, progress);
      }
    } else {
      newElementConfigPosition.x = targetOffsetX;
    }

    if (sourceOffsetY !== undefined && targetOffsetY !== undefined) {
      if (isOffset) {
        newElementConfigPosition.y = this.computeCurOffset(sourceOffsetY, targetOffsetY, progress);
      } else {
        newElementConfigPosition.y = this.computeCurAnchor(sourceOffsetY, targetOffsetY, progress);
      }
    } else {
      newElementConfigPosition.y = targetOffsetY;
    }
  }

  private computeCurAnchor(sourceOffsetX: Length, targetOffsetX: Length, progress: number) {
    let sourceOffSetXNum = CommonUtils.isString(sourceOffsetX) ?
    Number.parseFloat((sourceOffsetX as string).replace('%', '')) : (sourceOffsetX as number);
    let targetOffsetXNum = CommonUtils.isString(targetOffsetX) ?
    Number.parseFloat((targetOffsetX as string).replace('%', '')) : (targetOffsetX as number);
    return (sourceOffSetXNum + (targetOffsetXNum - sourceOffSetXNum) * progress) + '%';
  }

  private computeCurOffset(sourceOffsetX: Length, targetOffsetX: Length, progress: number) {
    let sourceOffSetXNum = CommonUtils.isString(sourceOffsetX) ?
      Number.parseFloat((sourceOffsetX as string).replace('%', '')) / 100 * this.gridParam.maxWidthSize :
      (sourceOffsetX as number);
    let targetOffsetXNum = CommonUtils.isString(targetOffsetX) ?
      Number.parseFloat((targetOffsetX as string).replace('%', '')) / 100 * this.gridParam.maxWidthSize :
      (targetOffsetX as number);
    return sourceOffSetXNum + (targetOffsetXNum - sourceOffSetXNum) * progress;
  }

  private getValidLength(value?: Length): Length | undefined {
    if (CommonUtils.isNumber(value)) { // 固定偏移值，补充缩放
      return value as number * this.scale;
    }
    return value; // 百分比直接使用
  }
}

export let clockLayoutParam: ClockLayoutParam = SingletonHelper.getInstance(ClockLayoutParam, TAG);