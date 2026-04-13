/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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

import {
  AppItemInfo,
  BaseCloseAppHandler,
  CommonConstants,
  layoutConfigManager,
  LayoutViewModel,
  ResidentLayoutCacheMgr
} from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper, SingleContext, singleManager } from '@ohos/basicutils';
import { NumberConstants } from '@ohos/commonconstants';

import FeatureConstants from './constants/FeatureConstants';
import { SmartDockStyleConfig } from './SmartDockStyleConfig';
import { IconExtendParam } from '@ohos/frameworkwrapper';

const TAG = 'SmartDockCloseAppHandler';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

/**
 * smartDock close app processing class
 */
export default class SmartDockCloseAppHandler extends BaseCloseAppHandler {
  public static singleName: string = 'SmartDockCloseAppHandler';
  private mSmartDockStyleConfig: SmartDockStyleConfig;
  private mAppItemBundleName: string | undefined;


  constructor(ctx?: SingleContext) {
    super(ctx);
    this.mSmartDockStyleConfig = layoutConfigManager.getStyleConfig(SmartDockStyleConfig.APP_LIST_STYLE_CONFIG,
      FeatureConstants.FEATURE_NAME);
  }

  static getInstance(ctx?: SingleContext): SmartDockCloseAppHandler {
    return singleManager.get<SmartDockCloseAppHandler>(SmartDockCloseAppHandler, ctx);
  }

  /**
   * get app icon info
   *
   * @param windowTarget close window target
   */
  public getAppIconInfo(windowTarget: AppItemInfo): void {
    this.mAppItemBundleName = windowTarget.bundleName;
    this.mAppIconSize = this.mSmartDockStyleConfig.mListItemWidth;
    this.setAppIconInfo();
  }

  protected calculateAppIconPosition(): void {
    if (CheckEmptyUtils.isEmpty(this.mSmartDockStyleConfig)) {
      log.showError('calculateAppIconPosition with invalid config');
      return;
    }

    this.mAppIconPositionX = 0;
    this.mAppIconPositionY = 0;
    const residentList: AppItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    const recentList: AppItemInfo[] = AppStorage.get('recentList') ?? [];
    const screenWidth: number = AppStorage.get('screenWidth') ?? 0;
    const workSpaceHeight: number = LayoutViewModel.getInstance().getWorkSpaceHeight();
    this.mAppIconPositionY = workSpaceHeight + this.mSmartDockStyleConfig.mListItemGap;
    const smartDockWidth: number = this.getListWidth(residentList) +
      (recentList.length > 0 ? this.mSmartDockStyleConfig.mDockGap + this.getListWidth(recentList) : 0);
    const smartDockStartPositionX: number = (screenWidth - smartDockWidth) / NumberConstants.CONSTANT_NUMBER_TWO;
    const indexInResidentList: number = this.getIndexInList(residentList);
    if (indexInResidentList !== CommonConstants.INVALID_VALUE) {
      this.mAppIconPositionX = smartDockStartPositionX + this.mSmartDockStyleConfig.mDockPadding + indexInResidentList *
        (this.mSmartDockStyleConfig.mListItemWidth + this.mSmartDockStyleConfig.mListItemGap) -
        (recentList.length > 0 ? 0 : this.mSmartDockStyleConfig.mListItemGap / NumberConstants.CONSTANT_NUMBER_TWO);
      return;
    }

    const indexInRecentList: number = this.getIndexInList(recentList);
    if (indexInRecentList !== CommonConstants.INVALID_VALUE) {
      this.mAppIconPositionX =
        smartDockStartPositionX + this.getListWidth(residentList) + this.mSmartDockStyleConfig.mDockGap +
        this.mSmartDockStyleConfig.mDockPadding + indexInRecentList *
          (this.mSmartDockStyleConfig.mListItemWidth + this.mSmartDockStyleConfig.mListItemGap);
      return;
    }
  }

  private getIndexInList(list: AppItemInfo[]): number {
    let index: number = CommonConstants.INVALID_VALUE;
    if (CheckEmptyUtils.isEmptyArr(list)) {
      log.showError('getIndexInRecentList with invalid list');
      return index;
    }

    for (let i = 0; i < list.length; i++) {
      if (this.mAppItemBundleName === list[i].bundleName) {
        AppStorage.setOrCreate('closeAppItemInfo', list[i]);
        log.showInfo(`getIndexInList bundleName ${list[i].bundleName}, index ${index}`);
        index = i;
        break;
      }
    }

    return index;
  }

  private getListWidth(itemList: AppItemInfo[]): number {
    let width = 0;
    if (CheckEmptyUtils.isEmptyArr(itemList)) {
      return width;
    } else {
      let num = itemList.length;
      if (num > this.mSmartDockStyleConfig.mMaxDockNum) {
        num = this.mSmartDockStyleConfig.mMaxDockNum;
      }
      width = this.mSmartDockStyleConfig.mDockPadding * 2 + num * (this.mSmartDockStyleConfig.mListItemWidth) +
        (num - 1) * (this.mSmartDockStyleConfig.mListItemGap);
    }
    return width;
  }
}
