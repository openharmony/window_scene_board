/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, CheckEmptyUtils } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import MeasureText from '@ohos.measure';
import ArrayList from '@ohos.util.ArrayList';
import { RdbStoreManager } from '../db/RdbStoreManager';
import { launcherAbilityManager, ListenerFuncType } from '../abilitymanager/LauncherAbilityManager';
import BadgeItemInfo from '../bean/BadgeItemInfo';
import { EventConstants } from '../constants/EventConstants';
import { StyleConstants } from '../constants/StyleConstants';
import { CustomBadgeManager } from '../model/CustomBadgeManager';
import { BaseBundleInfo } from '../bean/BaseBundleInfo';
import { GridLayoutItemInfo } from '../TsIndex';

const TAG = 'BadgeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const CACHE_INIT = 0;
const CACHE_LOADING = 1;
const CACHE_LOADED = 2;

export interface BadgeListener {
  onUpdate: (badgeInfo: BadgeItemInfo) => void;
}

export class DefineBadgePostion {
  x:number = 0;
  y:number = 0;
}

/**
 * badge manager
 */
export class BadgeManager {
  private static mInstance: BadgeManager;

  private readonly mDbStoreManager: RdbStoreManager;

  private mBadgeCache: Map<String, BadgeItemInfo> = new Map();

  // 主要是针对PC多实例多实例场景，通知开发进行修改之后，实例级别角标消息通知处理（针对PC多实例场景，对不同实例的角标做处理）
  private mAppInstanceKeyBadgeCache: Map<String, ArrayList<string>> = new Map();

  private mBadgeListeners: Map<String, ArrayList<BadgeListener>> = new Map();

  // 已修复的应用列表 key: bundleName+appIndex  value: 修复类型 1：PUSH 2：NMS broker
  private fixedBundleMap: Map<string, number> = new Map();

  static UPDATE_BADGE = 'updateBadge';

  private readonly listener: ListenerFuncType;

  private mCacheState: number = CACHE_INIT;

  private constructor() {
    this.mDbStoreManager = RdbStoreManager.getInstance();
    this.listener = this.appRemovedCallBack.bind(this);
    this.registerAppListEvent();
  }

  /**
   * badge manager instance
   *
   * @return badgeManager instance
   */
  static getInstance(): BadgeManager {
    if (BadgeManager.mInstance == null) {
      BadgeManager.mInstance = new BadgeManager();
    }
    return BadgeManager.mInstance;
  }

  private async initFixedBundleMap(): Promise<void> {
    this.fixedBundleMap = await this.mDbStoreManager.getFixedBundles();
  }

  dataFixedType(bundleName: string, appIndex: number): number | undefined {
    return this.fixedBundleMap.get(this.getFixedBundleKey(bundleName, appIndex));
  }

  updateFixedBundles(bundleName: string, appIndex: number, fixedType: number): void {
    this.fixedBundleMap.set(this.getFixedBundleKey(bundleName, appIndex), fixedType);
    this.mDbStoreManager.updateFixedTypeByBundle(bundleName, appIndex, fixedType);
  }

  private getFixedBundleKey(bundleName: string, appIndex: number): string {
    return `${bundleName}${appIndex ?? 0}`;
  }

  private getCacheKey(bundleInfo: BaseBundleInfo): string {
    return `${bundleInfo.bundleName}${bundleInfo.appIndex ?? 0}${bundleInfo.appInstanceKey ?? ''}`;
  }

  async getAllBadge(): Promise<BadgeItemInfo[]> {
    this.mCacheState = CACHE_LOADING;
    const badgeList = await this.mDbStoreManager.getAllBadge();
    this.mBadgeCache.clear();
    this.mAppInstanceKeyBadgeCache.clear();
    badgeList?.forEach((badgeItem) => {
      if (badgeItem) {
        this.mBadgeCache.set(this.getCacheKey({
          bundleName: badgeItem.bundleName ?? '',
          appIndex: badgeItem.appIndex
        }), badgeItem);
      }
    });
    this.mCacheState = CACHE_LOADED;
    return badgeList;
  }

  async getCacheBundleBadge(bundleInfo: BaseBundleInfo): Promise<number> {
    let cacheKey: string = this.getCacheKey(bundleInfo);
    if (!this.mBadgeCache.has(cacheKey) && CheckEmptyUtils.checkStrIsEmpty(bundleInfo?.appInstanceKey)) {
      return await this.getBadgeByBundleSync(bundleInfo);
    }
    let badgeItem = this.mBadgeCache.get(cacheKey);
    return badgeItem?.badgeNumber ?? 0;
  }

  getBadgeUpdateTask(bundleInfo: BaseBundleInfo): boolean {
    let cacheKey: string = this.getCacheKey(bundleInfo);
    if (!this.mBadgeCache.has(cacheKey)) {
      return false;
    }
    let badgeItem = this.mBadgeCache.get(cacheKey);
    return badgeItem?.badgeUpdateTaskStatus ?? false;
  }

  setCacheBundleBadge(bundleInfo: BaseBundleInfo, badgeNumber: number, badgeUpdateTask: boolean): void {
    let cacheKey: string = this.getCacheKey(bundleInfo);
    if (!this.mBadgeCache.has(cacheKey)) {
      const badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      // 首次开关状态设置为undefined，数据库更新完成之后再更新状态
      badgeInfo.isShow = undefined;
      badgeInfo.bundleName = bundleInfo.bundleName;
      badgeInfo.appIndex = bundleInfo.appIndex;
      badgeInfo.badgeNumber = badgeNumber;
      badgeInfo.badgeUpdateTaskStatus = badgeUpdateTask;
      badgeInfo.appInstanceKey = bundleInfo?.appInstanceKey;
      this.mBadgeCache.set(cacheKey, badgeInfo);
      this.setAppInstanceKeyCacheKeys(bundleInfo.bundleName, bundleInfo?.appInstanceKey ?? '', cacheKey);
    }
    let badgeItem = this.mBadgeCache.get(cacheKey);
    if (badgeItem) {
      badgeItem.badgeNumber = badgeNumber;
      this.mBadgeCache.set(cacheKey, badgeItem);
    }
    this.setAppInstanceKeyCacheKeys(bundleInfo.bundleName, bundleInfo?.appInstanceKey ?? '', cacheKey);
  }

  async setBadgeUpdateTask(bundleInfo: BaseBundleInfo, badgeUpdateTask: boolean): Promise<void> {
    let cacheKey: string = this.getCacheKey(bundleInfo);
    let badgeItem = this.mBadgeCache.get(cacheKey);
    if (badgeItem) {
      badgeItem.badgeUpdateTaskStatus = badgeUpdateTask;
      this.mBadgeCache.set(cacheKey, badgeItem);
    }
    this.setAppInstanceKeyCacheKeys(bundleInfo.bundleName, bundleInfo?.appInstanceKey ?? '', cacheKey);
  }

  async getBadgeByBundle(bundleInfo: BaseBundleInfo, callback: ((badgeNumber: number) => void)): Promise<void> {
    const badgeList = await this.mDbStoreManager.getBadgeByBundle(bundleInfo);
    if (badgeList.length > 0) {
      callback(badgeList[0].badgeNumber ?? 0);
    } else {
      callback(0);
    }
  }

  public getAppBadgeValue(bundleInfo: BaseBundleInfo): number {
    // 防止为空导致报错
    if (!bundleInfo) {
      log.showWarn(`getAppBadgeValue bundleInfo is null(undefined)`);
      return 0;
    }
    let cacheKey = this.getCacheKey(bundleInfo);
    if (!this.mBadgeCache.has(cacheKey)) {
      return 0;
    }
    let badgeItem = this.mBadgeCache.get(cacheKey);
    return badgeItem?.isShow ? (badgeItem.badgeNumber ?? 0) : 0;
  }

  async getBadgeByBundleSync(bundleInfo: BaseBundleInfo): Promise<number> {
    const badgeList = await this.mDbStoreManager.getBadgeByBundle(bundleInfo);
    if (badgeList.length > 0) {
      return badgeList[0].badgeNumber ?? 0;
    } else {
      return 0;
    }
  }

  async getBadgeDisplayByBundleSync(bundleInfo: BaseBundleInfo): Promise<boolean> {
    const badgeList = await this.mDbStoreManager.getBadgeByBundle(bundleInfo);
    if (badgeList.length > 0) {
      return badgeList[0].isShow ?? false;
    } else {
      return false;
    }
  }

  async getBadgeDisplayNumberByBundle(bundleInfo: BaseBundleInfo, callback: ((badgeNumber: number) => void)): Promise<void> {
    if (this.isCacheExist()) {
      const badgeItem = this.mBadgeCache.get(this.getCacheKey(bundleInfo));
      return badgeItem?.isShow ? callback(badgeItem?.badgeNumber ?? 0) : callback(0);
    }
    const badgeList = await this.mDbStoreManager.getBadgeByBundle(bundleInfo);
    if (badgeList.length > 0) {
      return badgeList[0].isShow ? callback(badgeList[0].badgeNumber ?? 0) : callback(0);
    } else {
      return callback(0);
    }
  }

  async getBadgeDisplayNumberByBundleSync(bundleInfo: BaseBundleInfo | GridLayoutItemInfo): Promise<number> {
    if (this.isCacheExist()) {
      const badgeItem = this.mBadgeCache.get(this.getCacheKey(bundleInfo as BaseBundleInfo));
      return badgeItem?.isShow ? (badgeItem?.badgeNumber ?? 0) : 0;
    }
    const badgeList = await this.mDbStoreManager.getBadgeByBundle(bundleInfo);
    if (badgeList.length > 0) {
      return badgeList[0].isShow ? (badgeList[0].badgeNumber ?? 0) : 0;
    } else {
      return 0;
    }
  }

  private isCacheExist(): boolean {
    switch (this.mCacheState) {
      case CACHE_INIT:
        this.mCacheState = CACHE_LOADING;
        this.getAllBadge().then(() => {
          this.mCacheState = CACHE_LOADED;
        });
        return false;
      case CACHE_LOADED:
        return true;
      default:
        return false;
    }
  }

  private setAppInstanceKeyCacheKeys(bundleName: string, appInstanceKey: string, cacheKey: string): void {
    if (CheckEmptyUtils.checkStrIsEmpty(appInstanceKey)) {
      return;
    }
    if (!this.mAppInstanceKeyBadgeCache.has(bundleName)) {
      this.mAppInstanceKeyBadgeCache.set(bundleName, new ArrayList());
    }
    this.mAppInstanceKeyBadgeCache.get(bundleName)?.add(cacheKey);
  }

  async refreshDesktopBadge(bundleInfo: BaseBundleInfo): Promise<void> {
    let cacheKey: string = this.getCacheKey(bundleInfo);
    let badgeInfo = this.mBadgeCache.get(cacheKey);
    if (!badgeInfo) {
      log.showError(`refreshDesktopBadge failed, ${cacheKey} badgeInfo is null`);
      return;
    }
    if (badgeInfo.isShow === undefined) {
      badgeInfo.isShow = await this.getBadgeDisplayByBundleSync(bundleInfo);
      log.showWarn(`not init display status, get badge display: ${badgeInfo.isShow}, bundleInfo: ${JSON.stringify(bundleInfo)}`);
    }

    this.mBadgeListeners.get(cacheKey)?.forEach((listener) => {
      if (badgeInfo) {
        listener.onUpdate(badgeInfo);
      }
    });
    log.showWarn(`refreshDesktopBadge, bundleInfo: ${JSON.stringify(bundleInfo)}, badgeNumber: ${badgeInfo.badgeNumber}, isShow: ${badgeInfo.isShow}`);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_BADGE_UPDATE, badgeInfo);
    if (badgeInfo.isShow) {
      CustomBadgeManager.getInstance().setAppBadgeValue(bundleInfo, badgeInfo.badgeNumber ?? 0);
    }
  }

  async updateBadgeNumber(bundleInfo: BaseBundleInfo, badgeNum: number): Promise<boolean> {
    log.showInfo(`updateBadgeNumber, bundle:${bundleInfo.bundleName} ${bundleInfo.appIndex}, badgeNum:${badgeNum}`);
    let result = false;
    if (badgeNum < 0 || this.ifStringIsNull(bundleInfo.bundleName)) {
      return result;
    }
    result = await this.mDbStoreManager.updateBadgeNumByBundle(bundleInfo, badgeNum);
    return result;
  }

  async updateBadgeDisplay(bundleInfo: BaseBundleInfo, isShow: boolean): Promise<boolean> {
    if (this.ifStringIsNull(bundleInfo.bundleName)) {
      return false;
    }
    log.showInfo(`updateBadgeDisplay, bundle:${bundleInfo.bundleName} ${bundleInfo.appIndex}, isShow:${isShow}`);
    let result = await this.mDbStoreManager.updateBadgeDisplayByBundle(bundleInfo, isShow);
    if (result) {
      const badgeInfo: BadgeItemInfo = new BadgeItemInfo();
      badgeInfo.badgeNumber = await this.getBadgeByBundleSync(bundleInfo);
      badgeInfo.bundleName = bundleInfo.bundleName;
      badgeInfo.isShow = isShow;
      badgeInfo.appIndex = bundleInfo.appIndex;

      if (this.mAppInstanceKeyBadgeCache.has(bundleInfo.bundleName)) {
        this.mAppInstanceKeyBadgeCache.get(bundleInfo.bundleName)?.forEach((cacheKey) => {
          badgeInfo.badgeNumber = this.mBadgeCache.get(cacheKey)?.badgeNumber;
          badgeInfo.appInstanceKey = this.mBadgeCache.get(cacheKey)?.appInstanceKey;
          this.mBadgeCache.set(cacheKey, badgeInfo);
          this.mBadgeListeners.get(cacheKey)?.forEach((listener) => listener.onUpdate(badgeInfo));
        });
      } else {
        let cacheKey = this.getCacheKey(bundleInfo);
        this.mBadgeCache.set(cacheKey, badgeInfo);
        this.mBadgeListeners.get(cacheKey)?.forEach((listener) => listener.onUpdate(badgeInfo));
        localEventManager.sendLocalEventSticky(EventConstants.EVENT_BADGE_UPDATE, badgeInfo);
      }
      if (badgeInfo.isShow) {
        CustomBadgeManager.getInstance().setAppBadgeValue(bundleInfo, badgeInfo.badgeNumber);
      } else {
        CustomBadgeManager.getInstance().clearAppStarBadge(bundleInfo);
      }
    }

    log.showInfo(`updateBadgeDisplay, bundle:${bundleInfo.bundleName} ${bundleInfo.appIndex} isShow change to ` +
      `${isShow} return ${result}`);
    return result;
  }

  /**
   * register app listener.
   */
  registerAppListEvent(): void {
    launcherAbilityManager.registerLauncherAbilityChangeListener(this.listener);
  }

  /**
   * unregister app listener.
   */
  unregisterAppListEvent(): void {
    launcherAbilityManager.unregisterLauncherAbilityChangeListener(this.listener);
  }

  private async appRemovedCallBack(event: string, bundleName: string, userId: number, appIndex?: number): Promise<void> {
    log.showDebug('Launcher AppModel installationSubscriberCallBack event = ' + event);
    if (event === EventConstants.EVENT_PACKAGE_REMOVED) {
      let bundleInfo: BaseBundleInfo = {
        bundleName: bundleName,
        appIndex: appIndex
      };
      this.mDbStoreManager.deleteBadgeByBundle(bundleInfo);
      this.mBadgeCache.delete(this.getCacheKey(bundleInfo));
      this.mAppInstanceKeyBadgeCache.delete(bundleName);
      CustomBadgeManager.getInstance().clearAppStarBadge(bundleInfo);
    }
  }

  private ifStringIsNull(str: string | null | undefined): boolean {
    if (CheckEmptyUtils.isEmpty(str)) {
      return true;
    }
    return false;
  }

  /**
   * register badge listener for bundleName
   *
   * @param bundleName listen bundleName
   * @param listener badge listener
   */
  registerBadgeListener(bundleInfo: BaseBundleInfo, listener: BadgeListener): void {
    log.showDebug(`registerBadgeListener bundle:${bundleInfo.bundleName} ${bundleInfo.appIndex}`);
    let cacheKey: string = this.getCacheKey(bundleInfo);
    let listeners = this.mBadgeListeners.get(cacheKey) ?? new ArrayList<BadgeListener>();
    listeners.add(listener);
    this.mBadgeListeners.set(cacheKey, listeners);
  }

  /**
   * unregister badge listener for bundleName
   *
   * @param bundleName listen bundleName
   * @param listener badge listener
   */
  unRegisterBadgeListener(bundleInfo: BaseBundleInfo, listener: BadgeListener): void {
    log.showDebug(`unRegisterBadgeListener bundle:${bundleInfo.bundleName} ${bundleInfo.appIndex}`);
    let cacheKey: string = this.getCacheKey(bundleInfo);
    let listeners = this.mBadgeListeners.get(cacheKey);
    listeners?.remove(listener);
    if (listeners?.isEmpty()) {
      this.mBadgeListeners.delete(cacheKey);
    }
  }

  getTextWidth(textContent: string, fontSize: string): number {
    return px2vp(MeasureText.measureText({
      textContent: textContent,
      fontSize: fontSize
    }));
  }

  getBadgeOffsetX(badgeNumber: number, fontSizeNum: number, iconSize: number): number {
    if (badgeNumber === StyleConstants.DEFAULT_0) {
      return 0;
    }
    if (badgeNumber > StyleConstants.DEFAULT_0 && badgeNumber < StyleConstants.DEFAULT_10) {
      return iconSize + StyleConstants.PC_BADGE_OFFSET_X_EXTENSION - StyleConstants.PC_BADGE_SIZE;
    }
    let numX: number = 0;
    let text: string = '';
    let textWidth: number = 0;
    let fontSize: string = '';
    if (badgeNumber > StyleConstants.MAX_BADGE_COUNT) {
      text = StyleConstants.MAX_BADGE_DISPLAY;
    } else {
      text = badgeNumber + '';
    }
    fontSize = fontSizeNum + 'vp';
    textWidth = this.getTextWidth(text, fontSize);
    numX = iconSize + StyleConstants.PC_BADGE_OFFSET_X_EXTENSION -
      StyleConstants.PC_BADGE_CIRCLE_WIDTH * StyleConstants.DEFAULT_2 - textWidth;
    return numX;
  }

  getBadgePostion(badgeNumber: number, fontSizeNum: number, iconSize: number): DefineBadgePostion {
    let numX: number = this.getBadgeOffsetX(badgeNumber, fontSizeNum, iconSize);
    let numY: number = StyleConstants.PC_BADGE_OFFSET_Y;
    let result: DefineBadgePostion = {
      x:numX,
      y:numY
    };
    log.showDebug(` getBadgePostion,x:${numX},y${numY}}`);
    return result;
  }
}