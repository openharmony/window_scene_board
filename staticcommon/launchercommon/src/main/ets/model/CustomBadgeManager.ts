/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved. 2024-2025. All rights reserved.
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
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseBundleInfo } from '../bean/BaseBundleInfo';

const TAG = 'CustomBadgeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class CustomBadgeManager {
  private static instance: CustomBadgeManager;
  private badgeInfo: Map<string, number> = new Map<string, number>();
  private superposeBadgeList: Map<string, SuperposeBadge> = new Map<string, SuperposeBadge>();

  static getInstance(): CustomBadgeManager {
    if (CustomBadgeManager.instance == null) {
      CustomBadgeManager.instance = new CustomBadgeManager();
    }
    return CustomBadgeManager.instance;
  }

  private getCacheKey(bundleInfo: BaseBundleInfo): string {
    return `${bundleInfo.bundleName}${bundleInfo.appIndex ?? 0}`;
  }

  public getAppBadgeValue(bundleInfo: BaseBundleInfo): number {
    let cacheKey = this.getCacheKey(bundleInfo);
    if (!this.badgeInfo || !this.badgeInfo.has(cacheKey)) {
      return 0;
    }
    return this.badgeInfo.get(cacheKey) ?? 0;
  }

  public setAppBadgeValue(bundleInfo: BaseBundleInfo, badgeValue: number): void {
    if (!this.badgeInfo) {
      this.badgeInfo = new Map<string, number>();
    }
    this.badgeInfo.set(this.getCacheKey(bundleInfo), badgeValue);
  }

  public setSuperposeBadge(keyName: string, superposeBadge: SuperposeBadge): void {
    if (CheckEmptyUtils.checkStrIsEmpty(keyName)) {
      log.showError('Input keyName is invalid, failed to update superpose badge.');
      return;
    }

    if (CheckEmptyUtils.isEmpty(this.superposeBadgeList)) {
      this.superposeBadgeList = new Map<string, SuperposeBadge>();
    }
    this.superposeBadgeList.set(keyName, superposeBadge);
  }

  public getSuperposeBadge(keyName: string): SuperposeBadge | undefined {
    if (CheckEmptyUtils.isEmpty(this.superposeBadgeList) || !this.superposeBadgeList.has(keyName)) {
      return undefined;
    }
    return this.superposeBadgeList.get(keyName);
  }

  public clearSuperposeBadge(keyName: string): void {
    if (CheckEmptyUtils.isEmpty(this.superposeBadgeList) || !this.superposeBadgeList.has(keyName)) {
      return;
    }

    this.superposeBadgeList.delete(keyName);
  }

  public clearAppStarBadge(bundleInfo: BaseBundleInfo): void {
    let cacheKey = this.getCacheKey(bundleInfo);
    if (CheckEmptyUtils.isEmpty(this.badgeInfo) || !this.badgeInfo.has(cacheKey)) {
      log.showDebug('Input badgeInfo is null or not including bundleName');
      return;
    }

    this.badgeInfo.delete(cacheKey);
  }
}

export class SuperposeBadge {
  public badgeNumber: number = 0;
  public iconSize: number = 0;
}
