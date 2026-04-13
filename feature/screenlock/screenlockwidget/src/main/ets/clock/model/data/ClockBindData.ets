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

import { BatteryPosition, DateWeekLunarStyle } from '../../common/ClockConstants';
import { slClockOneShotToDesktopService } from '@ohos/screenlockcommon';
import { NONE_EDIT_MODE } from '@ohos/screenlockcommon/Index';
import HashMap from '@ohos.util.HashMap';

const BASE_LINE_SEPARATOR_LENGTH: number = 48; // 线分隔符基础高度

/**
 * 时钟组件动态状态管理
 */
@Observed
export class ClockBindData {
  @Track public clockMarginLeft: number = 0; // 时钟组件左侧间距
  @Track public clockMarginTop: number = 0; // 时钟组件顶部间距
  @Track public lineSeparatorHeight: number = BASE_LINE_SEPARATOR_LENGTH; // 线分隔符高度
  @Track public dateWeekStyle: DateWeekLunarStyle = DateWeekLunarStyle.STYLE_MULTILINE; // 日期显示样式，默认多行
  @Track public isShowLargeDate: boolean = false; // 当前是否显示日期大样式
  @Track public isMergeWeekLunar: boolean = false; // 当前是否星期、农历合并行显示; 动态个性签名显示场景下

  @Track public isClockWidgetOnTouchMoving: boolean = false;
  @Track public clockOffsetX: number = 0;
  @Track public clockOffsetY: number = 0;
  @Track public textColor: string = '#FFFFFFFF';
  @Track public noTimeViewOpacity: number = 1;
  @Track public timeViewOpacity: number = 1;
  @Track public textOffSets: HashMap<string, Position> = new HashMap();
  @Track public scaleOptions: ScaleOptions | undefined = undefined;
  @Track public fontSizeAfterSlideUp: number | undefined = undefined;
  @Track private _timeAccessibility: string = '';
  @Track private _displayMode: number = NONE_EDIT_MODE;
  @Track public batteryPosition: BatteryPosition = BatteryPosition.SEPARATE;

  /**
   * 刷新线分隔符高度
   *
   * @param displayScale 缩放倍数
   */
  public updateLineSeparatorHeight(displayScale: number): void {
    let newHeight = BASE_LINE_SEPARATOR_LENGTH * displayScale;
    if (this.lineSeparatorHeight !== newHeight) {
      this.lineSeparatorHeight = newHeight;
    }
  }

  /**
   * 当前是否日期离散样式
   *
   * @returns true离散样式
   */
  public isDateSeparatorStyle(): boolean {
    return this.dateWeekStyle === DateWeekLunarStyle.STYLE_SEPARATOR;
  }

  /**
   * 当前是否日期单行样式
   *
   * @returns true单行样式
   */
  public isDateSingleLineStyle(): boolean {
    return this.dateWeekStyle === DateWeekLunarStyle.STYLE_SINGLE_LINE;
  }

  public updateClockOnMove(isOnMove: boolean): void {
    slClockOneShotToDesktopService.updateClockOnMove(isOnMove);
    this.isClockWidgetOnTouchMoving = isOnMove;
  }

  public setTimeAccessibility(value: string) {
    if (this._timeAccessibility !== value) {
      this._timeAccessibility = value;
    }
  }

  public getTimeAccessibility(): string {
    return this._timeAccessibility;
  }

  public setDisplayMode(value: number) {
    if (this._displayMode !== value) {
      this._displayMode = value;
    }
  }

  public getDisplayMode(): number {
    return this._displayMode;
  }

  /**
   * 更新局部AOD时钟样式日期农历组件
   */
  public updatePartDateWeekLunarStyle(style: DateWeekLunarStyle): void {
    this.isMergeWeekLunar = false;
    this.dateWeekStyle = style;
  }
}