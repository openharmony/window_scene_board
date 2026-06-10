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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import Constants from '../common/Constants';

const TAG = 'ScreenLock-ScreenLockLayoutStyle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class ScreenLockLayoutStyle {
  /*
   * Grid Width
   */
  protected mGridWidth: number = Constants.GRID_WIDTH;
  /*
   * Clock Columns
   */
  protected mClockGridColumns: number = Constants.CLOCK_GRID_COL;
  /*
   * Clock Rows
   */
  protected mClockGridRows: number = Constants.CLOCK_GRID_ROW;
  /*
   * Time Font Scale
   */
  protected mTimeFontScale: number = Constants.TIME_SCALE_DEFAULT;
  /*
   * Gap between time and date
   */
  protected mTimeDateSpace: number = Constants.TIME_DATE_SPACE;
  /*
   * Date Text Size
   */
  protected mDateTextSize: Resource = $r('app.float.edit_clockwidget_date_text_font_size_2_4');
  /*
   * Multi-Users Width
   */
  protected mMultiUsersWidth: number = 668;
  /*
   * Multi-Users Height
   */
  protected mMultiUsersHeight: number = 424;
  /*
   * Multi-Users Column Gap
   */
  protected mMultiUsersColGap: number = 32;
  /*
   * Multi-Users Row Gap
   */
  protected mMultiUsersRowGap: number = 12;

  get gridWidth(): number {
    return this.mGridWidth;
  }

  get clockGridColumns(): number {
    return this.mClockGridColumns;
  }

  get clockGridRows(): number {
    return this.mClockGridRows;
  }

  get timeFontScale(): number {
    return this.mTimeFontScale;
  }

  get timeDateSpace(): number {
    return this.mTimeDateSpace;
  }

  get dateTextSize(): Resource {
    return this.mDateTextSize;
  }

  get multiUserWidth(): number {
    return this.mMultiUsersWidth;
  }

  get multiUserHeight(): number {
    return this.mMultiUsersHeight;
  }

  get multiUserColGap(): number {
    return this.mMultiUsersColGap;
  }

  get multiUserRowGap(): number {
    return this.mMultiUsersRowGap;
  }

  set gridWidth(width: number) {
    this.mGridWidth = width;
  }

  set clockGridColumns(col: number) {
    this.mClockGridColumns = col;
  }

  set clockGridRows(row: number) {
    this.mClockGridRows = row;
  }

  set timeFontScale(fontScale: number) {
    this.mTimeFontScale = fontScale;
  }

  set timeDateSpace(space: number) {
    this.mTimeDateSpace = space;
  }

  set dateTextSize(textSizeRes: Resource) {
    this.mDateTextSize = textSizeRes;
  }

  set multiUserWidth(multiUserWidth: number) {
    this.mMultiUsersWidth = multiUserWidth;
  }

  set multiUserHeight(multiUserHeight: number) {
    this.mMultiUsersHeight = multiUserHeight;
  }

  set multiUserColGap(colGap: number) {
    this.mMultiUsersColGap = colGap;
  }

  set multiUserRowGap(rowGap: number) {
    this.mMultiUsersRowGap = rowGap;
  }

  constructor() {
  }
}


/*
 * PC Fold Machine Screen Lock Layout Style
 */
export class ScreenLockLayoutStyleForHPR extends ScreenLockLayoutStyle {
  /*
   * Grid Width
   */
  protected mGridWidth: number = Constants.GRID_WIDTH_HPR;
  /*
   * Clock Columns
   */
  protected mClockGridColumns: number = Constants.CLOCK_GRID_COL_HPR;
  /*
   * Clock Rows
   */
  protected mClockGridRows: number = Constants.CLOCK_GRID_ROW_HPR;
  /*
   * Time Font Scale
   */
  protected mTimeFontScale: number = Constants.TIME_SCALE_HPR;
  /*
   * Gap between time and date
   */
  protected mTimeDateSpace: number = Constants.TIME_DATE_SPACE_HPR;
  /*
   * Date Text Size
   */
  protected mDateTextSize: Resource = $r('app.float.edit_clockwidget_date_text_font_size_2_4');
  /*
   * Multi-Users Width
   */
  protected mMultiUsersWidth: number = 668;
  /*
   * Multi-Users Height
   */
  protected mMultiUsersHeight: number = 330;
  /*
   * Multi-Users Column Gap
   */
  protected mMultiUsersColGap: number = 32;
  /*
   * Multi-Users Row Gap
   */
  protected mMultiUsersRowGap: number = 16;
}