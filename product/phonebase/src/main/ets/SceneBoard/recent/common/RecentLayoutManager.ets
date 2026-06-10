/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { StyleConstants, CommonConstants } from '@ohos/launchercommon';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { RecentsStyleConstants, SCBSessionShowInScreenIndex, SCBScreenProperty } from '@ohos/windowscene';
import { RecentRotationUtil } from './RecentRotationUtil';
import { recentDisplayManager, recentLayoutConfigInstance } from '@ohos/recents/src/main/ets/TsIndex';
import { recentRuntimeInstance } from '../scenepanel/recentpanel/RecentRuntimeModel';
import { gestureHelperInstance } from '../scenepanel/common/GestureHelper';
import { RecentsStyleConfig } from '@ohos/recents';

/*
  *                                 屏幕中的多任务卡片布局信息
  * |----------------------------------------------------------------------------------|
  * |                top margin                            top margin                  |
  * |            |-----card width----|              |-----card width----|              |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |              card height         |              card height         |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |left margin |                   | width space  |                   |right margin  |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |-------------------|              |-------------------|              |
  * |                                                                                  |
  * |                 height space                       height space                  |
  * |            |-----card width----|              |-----card width----|              |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |             card height          |              card height         |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |left margin |                   | width space  |                   |right margin  |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |                   |              |                   |              |
  * |            |-------------------|              |-------------------|              |
  * |                bottom margin                        bottom margin                |
  * |-------------------------------total width----------------------------------------|
 */

const SCALE_COEFFICIENT: number = 2;
const TAG = 'RecentLayoutManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.RECENT, TAG);
export class RecentLayoutManager {
  public static getSingleRowScale(screenProperty: SCBScreenProperty): number {
    let isScreenVertical = recentDisplayManager.isScreenVertical();
    let effectiveHeightRatio = RecentLayoutManager.getEffectiveHeightRatio(px2vp(screenProperty.height));
    return RecentRotationUtil.getRecentScaleByRotation(isScreenVertical) * effectiveHeightRatio;
  }

  public static getMultiRowScale(screenProperty: SCBScreenProperty): number {
    let effectiveHeightRatio = RecentLayoutManager.getEffectiveHeightRatio(px2vp(screenProperty.height));
    return RecentsStyleConstants.MULTI_RECENT_SCALE * effectiveHeightRatio;
  }

  /**
   * 获取多任务缩放系数
   * @param screenProperty
   * @returns 多任务缩放系数
   */
  public static getScale(screenProperty: SCBScreenProperty): number {
    let isNeedMultiRowLayout = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedMultiRowLayout) {
      return RecentLayoutManager.getMultiRowScale(screenProperty);
    }
    return RecentLayoutManager.getSingleRowScale(screenProperty);
  }

  /**
   * 获取多任务一屏布局最多显示个数
   *
   * @param isFromApp 是否从App进入
   * @returns
   */
  public static getMaxVisibleSessionCount(isFromApp: boolean): number {
    let isNeedMultiRowLayout = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedMultiRowLayout) {
      return RecentsStyleConstants.RECENT_VIEW_COUNT_MULTI;
    }
    return isFromApp ? RecentsStyleConstants.RECENT_VIEW_COUNT : RecentsStyleConstants.RECENT_VIEW_COUNT_FROM_HOME;
  }

  public static getRealBottomMargin(screenProperty: SCBScreenProperty): number {
    let realRotateAngle = recentDisplayManager.realRotateAngle;
    let isNeedMultiRowLayout = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (isNeedMultiRowLayout && realRotateAngle === RotationConstants.ROTATION_180) {
      return RecentLayoutManager.getTopMargin(screenProperty);
    }
    return RecentLayoutManager.getBottomMargin(screenProperty);
  }

  /**
   * 获取卡片顶部的间距
   * @param screenProperty 屏幕信息
   * @returns 卡片顶部间距
   */
  public static getTopMargin(screenProperty: SCBScreenProperty): number {
    let isNeedMultiRowLayout = recentLayoutConfigInstance.isNeedMultiRowLayout();
    let vpHeight = px2vp(screenProperty.height);
    if (isNeedMultiRowLayout) {
      return vpHeight - 2 * RecentLayoutManager.getCardHeight(screenProperty) -
      RecentLayoutManager.getHeightSpace(screenProperty) - RecentLayoutManager.getBottomMargin(screenProperty);
    }
    return vpHeight - RecentLayoutManager.getCardHeight(screenProperty) -
    RecentLayoutManager.getBottomMargin(screenProperty);
  }

  public static getBottomMargin(screenProperty: SCBScreenProperty): number {
    let isNeedMultiRowLayout = recentLayoutConfigInstance.isNeedMultiRowLayout();
    let ratio = 0;
    let cutoutHeight = recentDisplayManager.cutoutHeight;
    if (isNeedMultiRowLayout) {
      if (DeviceHelper.isPad()) {
        ratio = RecentLayoutManager.getPadBottomRatio();
      } else {
        ratio = RecentLayoutManager.getFoldBottomRatio();
      }
    } else {
      ratio = RecentLayoutManager.getPhoneBottomRatio();
    }
    return (px2vp(screenProperty.height) - cutoutHeight) * ratio;
  }

  /**
   * 获取居中卡片到屏幕左边缘的距离
   * @returns
   */
  public static getLeftMargin(screenProperty: SCBScreenProperty): number {
    let scale = 1 - RecentLayoutManager.getScale(screenProperty);
    return scale * px2vp(screenProperty.width) / 2;
  }

  /**
   * 获取居中卡片到屏幕右边缘的距离
   * @returns
   */
  public static getRightMargin(screenProperty: SCBScreenProperty): number {
    return RecentLayoutManager.getLeftMargin(screenProperty);
  }

  /**
   * 计算高度时获取卡片中间的间距
   * @param height
   * @returns
   */
  public static getHeightSpace(screenProperty: SCBScreenProperty): number {
    let isNeedMultiRowLayout = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (!isNeedMultiRowLayout) {
      return 0;
    }
    let vpHeight = px2vp(screenProperty.height);
    let cutoutHeight = recentDisplayManager.cutoutHeight;
    let ratio = 0;
    if (DeviceHelper.isPad() && recentDisplayManager.isScreenVertical()) {
      ratio = RecentsStyleConstants.PAD_RECENT_PORTRAIT_RATIO_MIDDLE_MARGIN;
    } else {
      ratio = RecentsStyleConstants.MULTI_RECENT_RATIO_MIDDLE_MARGIN;
    }
    return (vpHeight - cutoutHeight) * ratio;
  }

  /**
   * 获取卡片中间的间距
   * @returns
   */
  public static getWidthSpace(): number {
    let isNeedMultiRowLayout = recentLayoutConfigInstance.isNeedMultiRowLayout();
    return isNeedMultiRowLayout ? StyleConstants.RECENT_MARGIN_SPACING_MULTI : StyleConstants.RECENT_MARGIN;
  }

  /**
   * 获取多任务卡片宽度
   * @returns
   */
  public static getCardWidth(screenProperty: SCBScreenProperty): number {
    return px2vp(screenProperty.width) * RecentLayoutManager.getScale(screenProperty);
  }

  public static getWidthAndSpace(screenProperty: SCBScreenProperty): number {
    return RecentLayoutManager.getCardWidth(screenProperty) + RecentLayoutManager.getWidthSpace();
  }

  /**
   * 获取多任务卡片高度
   * @returns
   */
  public static getCardHeight(screenProperty: SCBScreenProperty): number {
    return px2vp(screenProperty.height) * RecentLayoutManager.getScale(screenProperty);
  }

  public static getMultiRowPadding(screenProperty: SCBScreenProperty): number {
    return (px2vp(screenProperty.width) - 3 * RecentLayoutManager.getCardWidth(screenProperty) -
      2 * RecentLayoutManager.getWidthSpace()) / 2;
  }

  /**
   * 获取多任务列表对应的行列信息
   * @param sessionCount 多任务列表的数量
   * @returns 行列信息
   */
  public static getMultiPositions(sessionCount: number): MultiRecentPositionArray {
    let multiPositions: MultiRecentPositionArray = new MultiRecentPositionArray();
    let tmpIndex = 0;
    let row = 0;
    let column = 0;
    for (let i = sessionCount - 1; i >= 0; i--) {
      if (tmpIndex === 0) {
        tmpIndex++;
        column = Math.ceil(sessionCount / 2);
        multiPositions.push(new MultiRecentPosition(0, column));
        continue;
      }
      if (tmpIndex % 2 === 0) {
        row = 0;
        column--;
      } else {
        row = 1;
      }
      tmpIndex++;
      multiPositions.push(new MultiRecentPosition(row, column));
    }
    return multiPositions;
  }

  public static getColumnInMultiRow(index: number, sessionCount: number): number {
    //3张卡片删除第0张的时候，前一张补位index为-1做特殊处理
    if (index === -1 && sessionCount === 2) {
      return 0;
    }
    if (sessionCount <= 2) {
      // 当卡片数量小于2时，卡片显示在最右侧，不是中间列
      return 1;
    }
    // 单数和复数的情况下，列数计算需要分开
    return sessionCount % 2 === 0 ? Math.floor(index / 2) : Math.floor((index + 1) / 2);
  }

  /**
   * 双行多任务圆角校正 双行多任务缩放比例小，按UX要求圆角做特殊处理，保证缩放后圆角与单行一致
   *
   * @param screenProperty SCBScenePanel中存储的屏幕属性
   * @param isNeedChangeToMultiRow 传递当前是否需要多行布局 用于获取对应布局的缩放值
   * @returns
   */
  public static getAdjustedBorderRadius(screenProperty: SCBScreenProperty): number {
    let singleRowScale = RecentLayoutManager.getSingleRowScale(screenProperty);
    let multiRowScale = RecentLayoutManager.getMultiRowScale(screenProperty);
    let baseRadius = CommonConstants.getDeviceRadius();
    return baseRadius * singleRowScale / multiRowScale;
  }

  /**
   * 获取多任务有效高度/屏幕高度的比例
   * @param screenProperty
   * @returns 多任务有效高度/屏幕高度的比例
   */
  public static getEffectiveHeightRatio(vpHeight: number): number {
    let cutoutHeight = recentDisplayManager.cutoutHeight;
    return (vpHeight - cutoutHeight) / vpHeight;
  }

  /**
   * 获取单行多任务初始化Y偏移量
   * @param screenProperty
   * @returns
   */
  public static getSingleRowInitTranslateY(screenProperty: SCBScreenProperty): number {
    let recentScale = RecentLayoutManager.getSingleRowScale(screenProperty);
    let recentDistanceToBottom = RecentLayoutManager.getBottomMargin(screenProperty);
    return px2vp(screenProperty.height) * (1 - recentScale) / 2 - recentDistanceToBottom;
  }

  /**
   * 获取双行多任务初始化Y偏移量
   * @param curListLen
   * @param index
   * @param multiPositions
   * @param screenProperty
   * @returns
   */
  public static getMultiRowTranslateY(curListLen: number, index: number, multiPositions: MultiRecentPositionArray,
    screenProperty: SCBScreenProperty): number {
    if (curListLen === 0) {
      return 0;
    }
    let translateY = 0;
    let multiPosition: MultiRecentPosition = multiPositions[curListLen - 1 - index];
    let rowIndex = multiPosition?.getRowIndex();
    let height = px2vp(screenProperty.height);
    if (rowIndex === 0) {
      translateY = (height - RecentLayoutManager.getCardHeight(screenProperty) * 3) / 2 -
      RecentLayoutManager.getRealBottomMargin(screenProperty) -
      RecentLayoutManager.getHeightSpace(screenProperty);
    } else if (rowIndex === 1) {
      translateY = (height - RecentLayoutManager.getCardHeight(screenProperty)) / 2 -
      RecentLayoutManager.getRealBottomMargin(screenProperty);
    }
    return translateY;
  }

  public static getPadBottomRatio(): number {
    let ratio = 0;
    if (recentDisplayManager.isScreenVertical()) {
      ratio = RecentsStyleConstants.PAD_RECENT_PORTRAIT_RATIO_BOTTOM_MARGIN;
    } else {
      ratio = RecentsStyleConstants.PAD_RECENT_LANDSCAPE_RATIO_BOTTOM_MARGIN;
    }
    return ratio;
  }

  public static getFoldBottomRatio(): number {
    let ratio = 0;
    if (recentDisplayManager.isScreenVertical()) {
      ratio = RecentsStyleConstants.MULTI_RECENT_PORTRAIT_RATIO_BOTTOM_MARGIN;
    } else {
      ratio = RecentsStyleConstants.MULTI_RECENT_LANDSCAPE_RATIO_BOTTOM_MARGIN;
    }
    return ratio;
  }

  public static getPhoneBottomRatio(): number {
    let ratio = 0;
    if (recentDisplayManager.isScreenVertical()) {
      ratio = RecentsStyleConstants.RECENT_DISTANCE_TO_BOTTOM_RATIO;
    } else {
      ratio = RecentsStyleConstants.HORIZONTAL_RECENT_DISTANCE_TO_BOTTOM_RATIO;
    }
    return ratio;
  }

  public static getPositionX(relativeRightColumn: number, relativeColumn: number, sessionCount: number,
    screenProperty: SCBScreenProperty): number {
    if (sessionCount === 0) {
      return 0;
    }
    let widthSpace = RecentLayoutManager.getWidthSpace();
    let taskWidth = RecentLayoutManager.getCardWidth(screenProperty) + widthSpace;
    let isNeedChangeToMultiRow = recentLayoutConfigInstance.isNeedMultiRowLayout();
    if (!isNeedChangeToMultiRow) {
      return relativeColumn * taskWidth;
    }
    let multiRowPadding = RecentLayoutManager.getMultiRowPadding(screenProperty);
    // 只有1列或者2列的情况，relativeRightColumn = 0为1列,relativeRightColumn = 1为1列，卡片贴右边，需要特殊计算
    if (relativeRightColumn < 2) {
      return (relativeColumn + 1 - relativeRightColumn) * taskWidth - (widthSpace - multiRowPadding) + 1;
    }
    // 大于2列以上，0列位置为 -taskWidth - multiRowPadding + widthSpace + 2,其中 + 2是为了去白边，后面卡片逐张加taskWidth
    return (relativeColumn - 1) * taskWidth - multiRowPadding + widthSpace + 2;
  }

  public static getSessionContainerRelativePos(column: number, autoCenterColumn?: number): number {
    let centerColum = autoCenterColumn ? autoCenterColumn : recentRuntimeInstance.autoCenterColumn;
    if (Math.abs(centerColum - column) > 1) {
      return SCBSessionShowInScreenIndex.INDEX_NONE;
    }
    return column === recentRuntimeInstance.autoCenterColumn ? SCBSessionShowInScreenIndex.INDEX_MIDDLE :
      SCBSessionShowInScreenIndex.INDEX_MIDDLE + column - recentRuntimeInstance.autoCenterColumn;
  }

  /**
   * 获取手势触摸点为缩放中心点时的位移
   * @param touchPosX 手势触摸点X坐标
   * @param scaleX 窗口缩放值
   * @param screenW 屏幕宽度
   * @returns 返回触摸点缩放与屏幕中心点缩放时的位移差异
   */
  public static getTranslateXByScaleAndTouchPosX(gestureEvent: GestureEvent, scaleX: number, screenW: number): number {
    if (!gestureEvent) {
      log.showWarn(`getTranslateXByScaleAndTouchPosX gestureEvent invalid return 0`);
      return 0;
    }
    let touchPosX = gestureHelperInstance.getValidFingerPosX(gestureEvent) >= 0 ?
    gestureHelperInstance.getValidFingerPosX(gestureEvent) : screenW / 2;
    //屏幕中心点缩放时，可见区域位移屏幕宽度*(1-scale)/2
    //触摸点中心缩放时，可见区域位移触摸点x坐标*(1 - scaleX)
    return touchPosX * (1 - scaleX) - (1 - scaleX) / 2 * screenW;
  }

  /**
   * 应用跟手过程中获取Y轴方向位移，修改算法需拉通UX确认
   * @param offsetY 手势Y轴方向位移
   * @param screenH 屏幕高度
   * @param scaleY 当前应用缩放值
   * @returns translateY
   */
  public static getFollowingTranslateYForApp(offsetY: number, screenH: number, scaleY: number): number {
    let distanceYPercent = Math.abs(offsetY / screenH) * 100;
    let tmpH = 0
    if (distanceYPercent < 50) {
      tmpH = offsetY;
    } else {
      tmpH = -(-10 + 1.6 * distanceYPercent - 0.008 * Math.pow(distanceYPercent, 2)) * screenH * 0.01;
    }
    return tmpH + (1 - scaleY) * screenH / 2;
  }

  /**
   * 应用跟手过程中根据offset计算缩放值，修改算法需拉通UX确认
   * @param offsetY Y轴方向位移
   * @param screenH 屏幕高度
   * @returns scale
   */
  public static getFollowingScaleForApp(offsetY: number, screenH: number): number {
    let distanceYPercent = Math.abs(offsetY / screenH) * 100;
    let currScaleY = Math.exp(-2 * distanceYPercent / 100);
    currScaleY = Math.max(currScaleY, 0.2);
    currScaleY = Math.min(currScaleY, 1);
    return currScaleY;
  }

  /**
   * 桌面上滑跟手时Y轴方向百分比，用于计算缩放值，修改算法需拉通UX确认
   * @param offsetY
   * @param screenH
   * @returns Y轴方向百分比
   */
  public static getFollowingDistanceYPercentForHome(offsetY: number, screenH: number): number {
    return Math.max(Math.abs(offsetY / screenH) * SCALE_COEFFICIENT,
      RecentsStyleConstants.RECENT_DISTANCE_LIMIT_MIN * SCALE_COEFFICIENT);
  }

  /**
   * 通过跟手offsetY计算缩放值 用于设置桌面缩放，修改算法需拉通UX确认
   * @param offsetY
   * @param screenH
   * @returns 桌面上滑跟手时的缩放值
   */
  public static getDesktopScale(offsetY: number, screenH: number): number {
    let distanceYPercent = RecentLayoutManager.getFollowingDistanceYPercentForHome(offsetY, screenH);
    let scaleValue = RecentsStyleConstants.GESTURE_NAVIGATION_HEIGHT_DISTANCE_COEFFICIENTS *
    Math.pow(distanceYPercent, RecentsStyleConstants.GESTURE_NAVIGATION_HEIGHT_DISTANCE_EXP);
    scaleValue = Math.max(scaleValue, RecentsStyleConstants.DESKTOP_SCALE_FROM_HOME_TO_RECENT);
    scaleValue = Math.min(scaleValue, RecentsStyleConstants.DESKTOP_SCALE_MAX);
    return scaleValue;
  }

  /**
   * 通过跟手offsetY计算缩放值 用于设置桌面缩放，修改算法需拉通UX确认
   * @param offsetY
   * @param screenH
   * @returns 桌面上滑跟手时的缩放值
   */
  public static getFollowingScaleForHome(offsetY: number, screenH: number): number {
    let distanceYPercent = RecentLayoutManager.getFollowingDistanceYPercentForHome(offsetY, screenH);
    let currScaleY = RecentsStyleConstants.SINGLE_LIST_SCALE_MOVE_FROM_DESKTOP_PARA1 -
      RecentsStyleConstants.SINGLE_LIST_SCALE_MOVE_FROM_DESKTOP_PARA2 * Math.log10(distanceYPercent);
    currScaleY = Math.min(currScaleY, RecentsStyleConstants.SINGLE_LIST_SCALE_MAX);
    return currScaleY;
  }

  /**
   * 获取多任务标题名称最大宽度
   * @param screenProperty
   * @returns 多任务标题名称最大宽度
   */
  public static getAppNameMaxWidth(screenProperty: SCBScreenProperty, isSplit: boolean): number {
    let titleTotalWidth = RecentLayoutManager.getTitleWidth(screenProperty);
    let widthOfIconAndAppName = titleTotalWidth;
    if (isSplit) {
      widthOfIconAndAppName = (titleTotalWidth - RecentsStyleConfig.getInstance().recentSpaceBetweenTitle) / 2;
    }
    let widthOfAppName = widthOfIconAndAppName - RecentsStyleConfig.getInstance().mAppIconSize;
    let widthOfAppNameWithoutMargin = widthOfAppName - RecentsStyleConstants.LEFT_MARGIN_BETWEEN_ICON_NAME;
    return widthOfAppNameWithoutMargin;
  }

  /**
   * 获取多任务标题外间距
   * @param screenProperty
   * @returns 多任务标题外间距
   */
  public static getTitleMargin(): Margin {
    let marginLeft = RecentsStyleConfig.getInstance().mVerticalAppInfoLeftMargin;
    let rightMargin = RecentsStyleConfig.getInstance().mVerticalAppInfoRightMargin;
    return { left: marginLeft, right: rightMargin };
  }

  /**
   * 获取多任务标题宽度
   * @param screenProperty
   * @returns 多任务标题宽度
   */
  public static getTitleWidth(screenProperty: SCBScreenProperty): number {
    let margin = RecentLayoutManager.getTitleMargin();
    let width = RecentLayoutManager.getCardWidth(screenProperty);
    width -= margin.left as number;
    width -= margin.right as number;
    return width;
  }
}

export class MultiRecentPositionArray extends Array<MultiRecentPosition> {
}

export class MultiRecentPosition {
  private rowIndex: number;
  private columnIndex: number;

  constructor(row: number, column: number) {
    this.rowIndex = row;
    this.columnIndex = column;
  }

  public setRowIndex(row: number): void {
    this.rowIndex = row;
  }

  public setColumnIndex(column: number): void {
    this.columnIndex = column;
  }

  public getRowIndex(): number {
    return this.rowIndex;
  }

  public getColumnIndex(): number {
    return this.columnIndex;
  }
}
