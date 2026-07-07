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

import { StyleConstants } from '@ohos/launchercommon';
import type {
  BaseConfig,
} from '@ohos/launchercommon';
import { Log, SingleContext, singleManager } from '@ohos/basicutils';
import { FoldPhoneLayoutRulesController } from './FoldPhoneLayoutRulesController';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

const ICON_SIZE_50 = 50;
const ABOVE_PADDING_OFFSET = 5;
const TAG = 'HorizontalFoldPhoneLayoutRulesController';

/**
 * 二折屏开态横屏，三折M态横屏布局器
 */
export class HorizontalFoldPhoneLayoutRulesController extends FoldPhoneLayoutRulesController {
  public static singleName: string = 'HorizontalFoldPhoneLayoutRulesController';

  public constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(baseConfig: BaseConfig, ctx?: SingleContext): HorizontalFoldPhoneLayoutRulesController {
    let instance =
      singleManager.get<HorizontalFoldPhoneLayoutRulesController>(HorizontalFoldPhoneLayoutRulesController, ctx);
    instance.initBaseConfig(baseConfig);
    return instance;
  }

  protected initBaseConfig(baseConfig: BaseConfig): void {
    if (this.mBaseConfig) {
      return;
    }
    Log.showInfo(TAG, `${HorizontalFoldPhoneLayoutRulesController.singleName} initBaseConfig start`);
    super.initBaseConfig(baseConfig);
    this.calculateProductConfig();
  }

  /**
   * 列间距计算规则：X = (ScreenWidth + 8vp * 2 - iconSize * cellXNum) / (cellXNum + 1)
   * 行间距计算规则：X + offset
   * 比例为：[19.5:9 , 19.9:9 ] offset = 8  其他  offset = 4
   * 行间距 offset修正 offset +2
   */
  calculateProductConfig(): void {
    this.initGridIconSize();
    this.mScreenWidth = this.mBaseConfig.getScreenWidth();

    Log.showInfo(TAG, `calculateProductConfig ${this.mScreenWidth} gap ${this.columnSpaceGapOfSide} size: ${this.iconSizeOfGrid}
                 columnNumOfGrid  ${this.columnNumOfGrid}`);
    this.initRowAndColumnGap();
    this.initSpaceSideOfColumnAndScreen(StyleConstants.DEFAULT_2);
    Log.showInfo(TAG, `spaceOfColumn: ${this.spaceOfColumn}, spaceOfRow: ${this.spaceOfRow}, spaceOfColumnSide: ${this.spaceOfColumnSide}
    offsetOfRowAndColumn:${this.offsetOfRowAndColumn}`);
  }

  initGridIconSize(): void {
    // 图标大小
    if (DeviceHelper.isThreeFoldProduct()) {
      this.iconSizeOfGrid = ICON_SIZE_50;
    } else {
      this.iconSizeOfGrid = StyleConstants.DEFAULT_48;
      // 图标大小优先从配置中读取，解决X5 横屏状态下滑动桌面时堆叠卡片顶部截断问题
      if (this.landIconSizeOfGrid) {
        this.iconSizeOfGrid = this.landIconSizeOfGrid;
      }
    }
  }

  initRowAndColumnGap(): void {
    // 列, 行间距设置
    if (DeviceHelper.isThreeFoldProduct()) {
      this.spaceOfColumn = StyleConstants.DEFAULT_32;
      this.spaceOfRow = StyleConstants.DEFAULT_36;
    } else {
      this.spaceOfColumn = StyleConstants.DEFAULT_FOLD_PHONE_EXPANDED_LANDSCAPE_COLUMN_GAP;
      this.spaceOfRow = StyleConstants.DEFAULT_FOLD_PHONE_EXPANDED_LANDSCAPE_ROW_GAP;
      // configSpaceOfRow不为空则行间距取配置文件中值，解决X5 7行布局横屏状态下滑动桌面时顶部截断问题
      if (this.configSpaceOfRow) {
        this.spaceOfRow = this.configSpaceOfRow;
      }
    }
  }

  initSpaceSideOfColumnAndScreen(offset: number): void {
    let scrWidth = this.mBaseConfig.getScreenWidth();
    let allIconWidth = this.iconSizeOfGrid * this.columnNumOfGrid * StyleConstants.DEFAULT_2;
    // spaceX: 图标到屏幕侧边的空白距离
    let paddingOffset = StyleConstants.DEFAULT_32;
    if (DeviceHelper.isThreeFoldProduct()) { // 如果是三折屏的M态， 设置其两屏的间距为60
      paddingOffset = offset; //offset由父类传入，固定值 2
    }
    let spaceX: number = (scrWidth * StyleConstants.DEFAULT_2 - allIconWidth - StyleConstants.DEFAULT_6 *
    this.spaceOfColumn - paddingOffset * StyleConstants.DEFAULT_2) / StyleConstants.DEFAULT_3;
    this.spaceOfScreenSide = spaceX - this.spaceOfColumn;
    this.spaceOfColumnSide = spaceX + paddingOffset - this.spaceOfColumn / StyleConstants.DEFAULT_2;
  }

  getAboveSpace(realSpace: number, fixedPaddinOfStatus: number): number {
    // above + below = real
    // above + fixpad : below = 1 : 2
    let space = (realSpace - fixedPaddinOfStatus * StyleConstants.DEFAULT_2) / StyleConstants.DEFAULT_3;
    if (DeviceHelper.isThreeFoldProduct()) {
      space = space + ABOVE_PADDING_OFFSET;
    }
    return space;
  }

  getMarginBottomOfIndicator(belowSpace: number): number {
    let indicatorHeight = this.mBaseConfig.getIndicatorHeight();
    if (DeviceHelper.isThreeFoldProduct()) {
      return (belowSpace - indicatorHeight - ABOVE_PADDING_OFFSET) / StyleConstants.DEFAULT_2;
    }
    return (belowSpace - indicatorHeight) / StyleConstants.DEFAULT_2;
  }


  toString(): String {
    return TAG;
  }
}
