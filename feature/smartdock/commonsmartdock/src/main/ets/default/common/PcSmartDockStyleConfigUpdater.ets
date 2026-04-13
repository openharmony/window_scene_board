/**
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
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
import { DockItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon';
import { layoutConfigManager, StyleConstants } from '@ohos/launchercommon';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import FeatureConstants from './constants/FeatureConstants';
import { SmartDockStyleConfig } from './SmartDockStyleConfig';


const TAG = 'PcSmartDockStyleConfigUpdater';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const EXPAND = 'expand';
const NARROW = 'narrow';
const maxNarrowLevel = 17;
const dockAdaptiveSwitch = false;
export default class PcSmartDockStyleConfigUpdater {

  private narrowLevel: number = 0;
  private narrowList: number[] = [];
  private actionFlag: string = ''; //  narrow or expand
  private mSmartDockStyleConfig: SmartDockStyleConfig;

  private constructor() {
    this.mSmartDockStyleConfig = layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    if (this.mSmartDockStyleConfig) {
      this.narrowList[this.narrowLevel] = this.mSmartDockStyleConfig.mMaxNum;
      log.showDebug(`SmartDockStyleConfig ${JSON.stringify(this.mSmartDockStyleConfig)}`);
    } else {
      log.showWarn(`SmartDockStyleConfig is null`);
    }
  }

  doNarrow(): void {
    if (!dockAdaptiveSwitch) {
      return;
    }
    // 16 means the smallest
    if (this.narrowLevel < maxNarrowLevel) {
      this.narrowLevel++;
      this.actionFlag = NARROW;
      this.changeDockStyleConfig();
    }
  }

  doExpand(): void {
    if (!dockAdaptiveSwitch) {
      return;
    }
    // 0 means the biggest
    if (this.narrowLevel > 0) {
      this.narrowLevel--;
      this.actionFlag = EXPAND;
      this.changeDockStyleConfig();
    }
  }



  changeDockStyleConfig(): void {
    this.mSmartDockStyleConfig = layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
    let screenWidth: number = AppStorage.get('screenWidth') as number;
    if (!CommonUtils.isNumber(screenWidth)) {
      log.showWarn(`screenWidth is null`);
      return;
    }
    let dockSpaceWidth = screenWidth - StyleConstants.DEFAULT_2 * StyleConstants.DEFAULT_SMART_DOCK_PC_SAVE_MARGIN;
    log.showDebug(` screenWidth : ${screenWidth} dockSpaceWidth: ${dockSpaceWidth}`);
    let maxDockNum = this.mSmartDockStyleConfig.mMaxDockNum;
    if (EXPAND === this.actionFlag) {
      maxDockNum--;
    } else {
      maxDockNum++;
    }
    let dockHeight = this.getDockHeightByLevel();
    //iconSize listItemWidth listItemHeight  the three value is always the same,no need to calculate again
    let iconSize = this.getListItemSizeByLevel();
    let listItemWidth = iconSize;
    let listItemHeight = iconSize;
    let dockRadius = this.getDockRadisByLevel();
    //listItemGap dockGap dockPadding  the three value has to be the same by UX
    let listItemGap = this.getValueByLevel();
    let dockGap = listItemGap;
    let dockPadding = listItemGap;
    let residentSplitLineWidth = this.getResidentSplitLineWidthByLevel();
    let residentSplitLineHeight = this.getResidentSplitLineHeightByLevel();
    let maxNum = StyleConstants.DEFAULT_23 + this.narrowLevel;
    let maxRecentNum = maxNum - maxDockNum;

    this.mSmartDockStyleConfig.mIconSize = iconSize;
    this.mSmartDockStyleConfig.mListItemWidth = listItemWidth;
    this.mSmartDockStyleConfig.mListItemHeight = listItemHeight;
    this.mSmartDockStyleConfig.mListItemGap = listItemGap;
    this.mSmartDockStyleConfig.mResidentSplitLineHeight = residentSplitLineHeight;
    this.mSmartDockStyleConfig.mDockRadius = dockRadius;
    this.mSmartDockStyleConfig.mDockHeight = dockHeight;
    this.mSmartDockStyleConfig.mResidentSplitLineWidth = residentSplitLineWidth;
    this.mSmartDockStyleConfig.mMaxNum = maxNum;
    this.mSmartDockStyleConfig.mMaxDockNum = maxDockNum;
    this.mSmartDockStyleConfig.mMaxRecentNum = maxRecentNum;
    this.mSmartDockStyleConfig.mDockGap = dockGap;
    this.mSmartDockStyleConfig.mDockPadding = dockPadding;
    this.narrowList[this.narrowLevel] = this.mSmartDockStyleConfig.mMaxNum;
    this.checkDockSpaceWidth(dockSpaceWidth);
  }


  private checkDockSpaceWidth(dockSpaceWidth: number): void {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let recentList: DockItemInfo[] = AppStorage.get('recentList') || [];
    let residentNum = residentList.length;
    let recentNum = recentList.length;
    let residentWidth = this.mSmartDockStyleConfig.mDockPadding * 2 + residentNum *
      (this.mSmartDockStyleConfig.mListItemWidth) + (residentNum - 2) * (this.mSmartDockStyleConfig.mListItemGap) +
      this.mSmartDockStyleConfig.mResidentSplitLineWidth + this.mSmartDockStyleConfig.mResidentSplitLineGap * 2;
    let recentWidth = recentNum * (this.mSmartDockStyleConfig.mListItemWidth) + (recentNum - 1) *
      (this.mSmartDockStyleConfig.mListItemGap) + this.mSmartDockStyleConfig.mDockPadding * 2;
    if (residentWidth + recentWidth < dockSpaceWidth) {
      AppStorage.setOrCreate('dockRefresh', this.narrowLevel);
      AppStorage.setOrCreate('dockSpaceWidth', dockSpaceWidth);
    } else {
      if (this.actionFlag === NARROW) {
        this.doNarrow();
      }
    }
  }

  private getResidentSplitLineHeightByLevel(): number {
    let residentSplitLineHeigh: number;
    if (EXPAND === this.actionFlag) {
      if (this.narrowLevel === StyleConstants.DEFAULT_17 || this.narrowLevel === StyleConstants.DEFAULT_14 ||
        this.narrowLevel === StyleConstants.DEFAULT_13 || this.narrowLevel === StyleConstants.DEFAULT_12 ||
        this.narrowLevel === StyleConstants.DEFAULT_11 || this.narrowLevel === StyleConstants.DEFAULT_9 ||
        this.narrowLevel === StyleConstants.DEFAULT_8 || this.narrowLevel === StyleConstants.DEFAULT_4 ||
        this.narrowLevel === StyleConstants.DEFAULT_1) {
        residentSplitLineHeigh = this.mSmartDockStyleConfig.mResidentSplitLineHeight;
      } else {
        residentSplitLineHeigh = this.mSmartDockStyleConfig.mResidentSplitLineHeight + StyleConstants.DEFAULT_2;
      }
    } else {
      if (this.narrowLevel === StyleConstants.DEFAULT_18 || this.narrowLevel === StyleConstants.DEFAULT_15 ||
        this.narrowLevel === StyleConstants.DEFAULT_14 || this.narrowLevel === StyleConstants.DEFAULT_13 ||
        this.narrowLevel === StyleConstants.DEFAULT_12 || this.narrowLevel === StyleConstants.DEFAULT_10 ||
        this.narrowLevel === StyleConstants.DEFAULT_9 || this.narrowLevel === StyleConstants.DEFAULT_5 ||
        this.narrowLevel === StyleConstants.DEFAULT_2) {
        residentSplitLineHeigh = this.mSmartDockStyleConfig.mResidentSplitLineHeight;
      } else {
        residentSplitLineHeigh = this.mSmartDockStyleConfig.mResidentSplitLineHeight - StyleConstants.DEFAULT_2;
      }
    }
    return residentSplitLineHeigh;
  }

  private getResidentSplitLineWidthByLevel(): number {
    return this.narrowLevel === StyleConstants.DEFAULT_0 ? StyleConstants.DEFAULT_3 : StyleConstants.DEFAULT_2;
  }

  private getValueByLevel(): number {
    return this.narrowLevel === StyleConstants.DEFAULT_0 ? StyleConstants.DEFAULT_12 : StyleConstants.DEFAULT_10;
  }

  private getListItemSizeByLevel(): number {
    let size: number;
    if (EXPAND === this.actionFlag) {
      if (this.narrowLevel === StyleConstants.DEFAULT_17 || this.narrowLevel === StyleConstants.DEFAULT_15 ||
        this.narrowLevel === StyleConstants.DEFAULT_12 || this.narrowLevel === StyleConstants.DEFAULT_11) {
        size = this.mSmartDockStyleConfig.mIconSize;
      } else {
        size = this.mSmartDockStyleConfig.mIconSize + StyleConstants.DEFAULT_2;
      }
    } else {
      if (this.narrowLevel === StyleConstants.DEFAULT_18 || this.narrowLevel === StyleConstants.DEFAULT_16 ||
        this.narrowLevel === StyleConstants.DEFAULT_13 || this.narrowLevel === StyleConstants.DEFAULT_12) {
        size = this.mSmartDockStyleConfig.mIconSize;
      } else {
        size = this.mSmartDockStyleConfig.mIconSize - StyleConstants.DEFAULT_2;
      }
    }
    return size;
  }

  private getDockHeightByLevel(): number {
    let dockHeight: number;
    if (EXPAND === this.actionFlag) {
      if (this.narrowLevel === StyleConstants.DEFAULT_0 ) {
        dockHeight = this.mSmartDockStyleConfig.mDockHeight + StyleConstants.DEFAULT_6;
      } else if (this.narrowLevel === StyleConstants.DEFAULT_17 || this.narrowLevel === StyleConstants.DEFAULT_15 ||
        this.narrowLevel === StyleConstants.DEFAULT_12 || this.narrowLevel === StyleConstants.DEFAULT_11) {
        dockHeight = this.mSmartDockStyleConfig.mDockHeight;
      } else {
        dockHeight = this.mSmartDockStyleConfig.mDockHeight + StyleConstants.DEFAULT_2;
      }
    } else {
      if (this.narrowLevel === StyleConstants.DEFAULT_1 ) {
        dockHeight = this.mSmartDockStyleConfig.mDockHeight - StyleConstants.DEFAULT_6;
      } else if (this.narrowLevel === StyleConstants.DEFAULT_18 || this.narrowLevel === StyleConstants.DEFAULT_16 ||
        this.narrowLevel === StyleConstants.DEFAULT_13 || this.narrowLevel === StyleConstants.DEFAULT_12) {
        dockHeight = this.mSmartDockStyleConfig.mDockHeight;
      } else {
        dockHeight = this.mSmartDockStyleConfig.mDockHeight - StyleConstants.DEFAULT_2;
      }
    }
    return dockHeight;
  }

  private getDockRadisByLevel(): number {
    let dockRadis: number;
    if (StyleConstants.DEFAULT_0 === this.narrowLevel) {
      dockRadis = StyleConstants.DEFAULT_24;
    } else if (this.narrowLevel >= StyleConstants.DEFAULT_1 && this.narrowLevel < StyleConstants.DEFAULT_6) {
      dockRadis = StyleConstants.DEFAULT_20;
    } else if (this.narrowLevel >= StyleConstants.DEFAULT_6 && this.narrowLevel < StyleConstants.DEFAULT_10) {
      dockRadis = StyleConstants.DEFAULT_18;
    } else if (this.narrowLevel >= StyleConstants.DEFAULT_10 && this.narrowLevel < StyleConstants.DEFAULT_14) {
      dockRadis = StyleConstants.DEFAULT_16;
    } else if (this.narrowLevel >= StyleConstants.DEFAULT_14 && this.narrowLevel < StyleConstants.DEFAULT_17) {
      dockRadis = StyleConstants.DEFAULT_14;
    } else {
      dockRadis = StyleConstants.DEFAULT_12;
    }
    return dockRadis;
  }

  getFrontNarrowLevelMaxCount(): number {
    if (this.narrowLevel === 0) {
      return this.narrowList[0];
    }
    let maxCount: number = this.narrowList[this.narrowLevel - 1];
    log.showDebug(`getFrontNarrowLevelMaxCount maxCount:${maxCount}`);
    return maxCount;
  }

  getNarrowLevel(): number {
    return this.narrowLevel;
  }

  checkNarrowMax(): boolean {
    return this.narrowLevel >= maxNarrowLevel;
  }

  private static instance: PcSmartDockStyleConfigUpdater;
  static getInstance(): PcSmartDockStyleConfigUpdater {
    if (!PcSmartDockStyleConfigUpdater.instance) {
      PcSmartDockStyleConfigUpdater.instance = new PcSmartDockStyleConfigUpdater();
    }
    return PcSmartDockStyleConfigUpdater.instance;
  }

}