/**
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { BaseCloseAppHandler } from '../base/BaseCloseAppHandler';
import {
  CheckEmptyUtils,
  LogDomain,
  Logger,
  PixelMapUtil,
  StartType,
  Trace,
} from '@ohos/basicutils';
import { IconResourceManager, GraphicUtils, onLineThemeUtil, DeviceHelper } from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import type { RectInfo } from '@ohos/basicutils';
import type { AppItemInfo } from '../bean/AppItemInfo';
import { CommonConstants } from '../constants/CommonConstants';
import { image } from '@kit.ImageKit';
import { AppModel, IconChangeListener } from '../model/AppModel';
import { FolderManager } from '../TsIndex';
import { SCBTransitionManager } from '@ohos/windowscene';
import { NumberConstants } from '@ohos/commonconstants';
import { ArrayList } from '@kit.ArkTS';

const TAG = 'CloseAppManager';
const log: Logger = Logger.getLogHelper(LogDomain.ICON);
// 侧滑退出时宽度或高度发生改变的卡片前缀列表，包含负一屏的服务、卡片、咨询、桌面上的卡片
const widthChangeCardPrefixList: string[] = ['Intelligent_', 'CardsView_CardFrame_', 'Browser_Feed_Default', 'Form'];
// 启动退出图标缓存最大数量
const MAX_COUNT: number = 8;

export interface ClosePosition {
  appIconSize: number,
  appIconHeight: number,
  appIconPositionX: number,
  appIconPositionY: number,
};

export interface AppInfo {
  iconInfo?: ClosePosition,
  appItemInfo?: AppItemInfo,
};

class ReleaseSnapshot {
  private releaseSnapshot: number;
  private releaseFunction?: () => void;
  constructor(releaseFunction:() => void, timeout: number) {
    this.releaseFunction = releaseFunction;
    this.releaseSnapshot = setTimeout(() => {
      this.releaseFunction
    }, timeout);
  }

  public executeImmediately(): void {
    this.executeOrCancel(true);
  }

  private executeOrCancel(isExecute: boolean): void {
    if (this.releaseSnapshot === CommonConstants.INVALID_VALUE) {
      return;
    }
    try {
      clearTimeout(this.releaseSnapshot);
      this.releaseSnapshot = CommonConstants.INVALID_VALUE;
      if (isExecute && this.releaseFunction) {
        this.releaseFunction();
      }
      this.releaseFunction = undefined;
    } catch (e) {
      log.showError(TAG, `executeImmediately errork, ${e}`);
    }
  }

  public cancelTimeout(): void {
    this.executeOrCancel(false);
  }
}

/**
 * close app manager
 */
export class CloseAppManager {
  private static mInstance: CloseAppManager;
  private mBaseCloseAppHandlerList: Array<BaseCloseAppHandler> = new Array<BaseCloseAppHandler>();
  private mPagedesktopCloseItemInfo?: AppItemInfo;
  private mPagedesktopClosePosition: ClosePosition = { appIconSize: 0,
    appIconHeight: 0,
    appIconPositionX: 0,
    appIconPositionY: 0 };
  private mSmartdockCloseItemInfo?: AppItemInfo;
  private mSmartdockClosePosition: ClosePosition = { appIconSize: 0,
    appIconHeight: 0,
    appIconPositionX: 0,
    appIconPositionY: 0 };
  private mOpenFolderClosePosition: ClosePosition = { appIconSize: 0,
    appIconHeight: 0,
    appIconPositionX: 0,
    appIconPositionY: 0 };
  private mStartSubtype: StartSubtype = StartSubtype.NONE;
  private mIsStartCard: boolean = false;
  private mIsStartShortCut: boolean = false;

  private adaptiveIcon: image.PixelMap[] = [];
  private cardStartSnapshot?: image.PixelMap;
  private releaseSnapshot: ReleaseSnapshot | null = null;
  private touchedCardId?: string;
  private touchedIconId: number = 0;
  private touchedBundleName: string = '';
  private touchedModuleName: string = '';
  private touchedAbilityName: string = '';
  private isUpdatingAdaptiveIcon: boolean = false;
  private readonly iconChangeListener: IconChangeListener = { onIconResourceChange: () => this.onIconResourceChange() };
  private isMinimizeAllScene: boolean = false;
  private isMinimizeAllSceneClosingFolder: boolean = false;

  // 点击卡片不启动场景不设置启动类型，比如一键锁屏卡片
  private readonly cardBundleBlocklist: string[] = ['com.ohos.sceneboard'];

  constructor() {
    AppModel.getInstance().registerIconChangeListener(this.iconChangeListener);
    // 图标缓存删除时会release图片，若保存的adaptiveIcon与删除图标的包名一致，则清空touchedBundleName，下次获取图标时默认重新获取
    AdaptiveIconManager.getInstance().setDeleteIconCallback((bundleName: string) => {
      if (this.touchedBundleName === bundleName) {
        this.clearAdaptiveIconCache();
      }
    });
  }

  private async onIconResourceChange(): Promise<void> {
    this.clearAdaptiveIconCache();
  }


  static getInstance(): CloseAppManager {
    if (!CloseAppManager.mInstance) {
      CloseAppManager.mInstance = new CloseAppManager();
    }
    return CloseAppManager.mInstance;
  }

  /**
   * register baseCloseAppHandler to manager
   *
   * @param baseCloseAppHandler the instance of close app handler
   */
  public registerCloseAppHandler(baseCloseAppHandler: BaseCloseAppHandler): void {
    if (CheckEmptyUtils.isEmpty(baseCloseAppHandler)) {
      log.showError(TAG, 'registerCloseAppHandler with invalid baseCloseAppHandler');
      return;
    }

    this.mBaseCloseAppHandlerList.push(baseCloseAppHandler);
    log.showInfo(TAG, `registerCloseAppHandler mBaseCloseAppHandlerList is ${this.mBaseCloseAppHandlerList.length}} `);
  }

  /**
   * unregister baseCloseAppHandler to manager
   *
   * @param baseCloseAppHandler the instance of close app handler
   */
  public unregisterCloseAppHandler(baseCloseAppHandler: BaseCloseAppHandler): void {
    if (CheckEmptyUtils.isEmpty(baseCloseAppHandler)) {
      log.showError(TAG, 'unregisterCloseAppHandler with invalid baseCloseAppHandler');
      return;
    }

    let index: number = 0;
    for (let i = 0; i < this.mBaseCloseAppHandlerList.length; i++) {
      if (this.mBaseCloseAppHandlerList[i] === baseCloseAppHandler) {
        index = i;
        break;
      }
    }

    this.mBaseCloseAppHandlerList.splice(index, 1);
    log.showInfo(TAG, `unregisterCloseAppHandler mBaseCloseAppHandlerList is ${this.mBaseCloseAppHandlerList.length}`);
  }

  /**
   * get app icon info
   *
   * @param windowTarget windowTarget close window target
   */
  public getAppIconInfo(windowTarget: AppItemInfo): void {
    if (CheckEmptyUtils.isEmptyArr(this.mBaseCloseAppHandlerList)) {
      log.showError(TAG, 'getAppIconInfo with invalid mBaseCloseAppHandlerList');
      return;
    }

    for (let i = 0; i < this.mBaseCloseAppHandlerList.length; i++) {
      this.mBaseCloseAppHandlerList[i].getAppIconInfo(windowTarget);
    }
  }

  /**
   * get app icon info
   *
   * @param windowTarget windowTarget close window target
   */
  public getAppInfo(windowTarget: AppItemInfo): AppInfo {
    if (CheckEmptyUtils.isEmptyArr(this.mBaseCloseAppHandlerList)) {
      log.showError(TAG, 'getAppIconInfo with invalid mBaseCloseAppHandlerList');
      return {};
    }

    for (let i = 0; i < this.mBaseCloseAppHandlerList.length; i++) {
      this.mBaseCloseAppHandlerList[i].getAppIconInfo(windowTarget);
    }

    return {iconInfo: this.getAppCloseIconInfo(), appItemInfo: this.getAppCloseItemInfo()};
  }

  public getAppInfoByBundleName(bundleName: string, abilityName?: string, iconId?: number): AppInfo {
    if (CheckEmptyUtils.isEmptyArr(this.mBaseCloseAppHandlerList)) {
      log.showError(TAG, 'getAppInfoByBundleName with invalid mBaseCloseAppHandlerList');
      return {};
    }

    for (let i = 0; i < this.mBaseCloseAppHandlerList.length; i++) {
      this.mBaseCloseAppHandlerList[i].getAppIconInfoByName(bundleName, abilityName, iconId);
    }

    return {iconInfo: this.getAppCloseIconInfo(), appItemInfo: this.getAppCloseItemInfo()};
  }

  public addPagedesktopClosePosition(pagedesktopCloseIconInfo: ClosePosition, pagedesktopCloseItemInfo?: AppItemInfo): void {
    log.showDebug(TAG, `addPagedesktopClosePosition pagedesktopCloasIconInfo is ${JSON.stringify(pagedesktopCloseIconInfo)}`);
    this.mPagedesktopClosePosition = pagedesktopCloseIconInfo;
    this.mPagedesktopCloseItemInfo = pagedesktopCloseItemInfo;
  }

  public addSmartDockClosePosition(smartdockCloseIconInfo: ClosePosition, smartdockCloseItemInfo: AppItemInfo): void {
    log.showDebug(TAG, `addSmartDockClosePosition smartdockCloasIconInfo is ${JSON.stringify(smartdockCloseIconInfo)}`);
    this.mSmartdockClosePosition = smartdockCloseIconInfo;
    this.mSmartdockCloseItemInfo = smartdockCloseItemInfo;
  }

  public getAppCloseIconInfo(): ClosePosition {
    if (CheckEmptyUtils.isEmpty(this.mPagedesktopClosePosition)) {
      log.showDebug(TAG, `getAppCloseIconInfo return mSmartdockClosePosition is ${JSON.stringify(this.mSmartdockClosePosition)}`);
      return this.mSmartdockClosePosition;
    } else {
      log.showDebug(TAG, `getAppCloseIconInfo return mPagedesktopClosePosition is ${JSON.stringify(this.mPagedesktopClosePosition)}`);
      return this.mPagedesktopClosePosition;
    }
  }

  public getAppCloseItemInfo(): AppItemInfo | undefined {
    if (CheckEmptyUtils.isEmpty(this.mPagedesktopCloseItemInfo)) {
      log.showDebug(TAG, `getAppCloseIconInfo return mSmartdockClosePosition is ${JSON.stringify(this.mSmartdockClosePosition)}`);
      return this.mSmartdockCloseItemInfo;
    } else {
      log.showDebug(TAG, `getAppCloseIconInfo return mPagedesktopClosePosition is ${JSON.stringify(this.mPagedesktopClosePosition)}`);
      return this.mPagedesktopCloseItemInfo;
    }
  }

  public setOpenFolderAppIconInfo(rectInfo: RectInfo): void {
    if (rectInfo === null || rectInfo === undefined) {
      log.showWarn(TAG, 'setOpenFolderAppIconInfo rectInfo is empty');
      return;
    }
    if (this.getStartAppType() !== StartType.FOLDER) {
      log.showWarn(TAG, 'setOpenFolderAppIconInfo StartType is not FOLDER');
      return;
    }
    this.mOpenFolderClosePosition.appIconSize = rectInfo.right - rectInfo.left;
    this.mOpenFolderClosePosition.appIconHeight = rectInfo.bottom - rectInfo.top;
    this.mOpenFolderClosePosition.appIconPositionX = rectInfo.left;
    this.mOpenFolderClosePosition.appIconPositionY = rectInfo.top;
  }

  public getOpenFolderAppIconInfo(): ClosePosition | null {
    if (this.getStartAppType() !== StartType.FOLDER) {
      log.showWarn(TAG, 'getOpenFolderAppIconInfo StartType is not FOLDER');
      return null;
    }
    return this.mOpenFolderClosePosition;
  }

  public setOpenFolderIconPosition(iconId: string, iconRect: RectInfo): void {
    if (this.isAppIconInOpenFolder(iconId)) {
      log.showDebug(TAG, 'setOpenFolderIconPosition');
      CloseAppManager.getInstance().setOpenFolderAppIconInfo(iconRect);
    }
  }

  public isAppIconInOpenFolder(iconId: string): boolean {
    const isOpenFolder: boolean = FolderManager.getInstance().isFolderOpen();
    let isStartFromOpenFolder = iconId?.startsWith(CommonConstants.APP_ITEM_APP_BUBBLE_ICON_TAG);
    log.showInfo(TAG, `isAppIconInFolderOpen isOpenFolder: ${isOpenFolder} isStartFromOpenFolder: ${isStartFromOpenFolder}`);
    return isStartFromOpenFolder && isOpenFolder;
  }

  public setStartAppType(startAppType: StartType, cardId?: string, extraId?: string, shortcutId?: string,
    bundleName?: string): void {
    if (startAppType === StartType.CARD && !this.cardBundleBlocklist.includes(bundleName)) {
      this.setIsStartCard();
    } else if (startAppType === StartType.SHORTCUT_MENU || startAppType === StartType.SHORTCUT_APP) {
      this.setIsStartShortcut();
    } else {
      this.resetIsStartCard();
      this.resetIsStartShortcut();
    }
    this.mBaseCloseAppHandlerList.forEach(handler => {
      handler?.setStartAppType(startAppType, cardId, extraId, shortcutId);
    });
  }

  public getIsMinimizeAllScene(): boolean {
    return this.isMinimizeAllScene;
  }

  public setIsMinimizeAllScene(value: boolean): void {
    this.isMinimizeAllScene = value;
  }

  public getIsMinimizeAllSceneClosingFolder(): boolean {
    return this.isMinimizeAllSceneClosingFolder;
  }

  public resetIsMinimizeAllSceneClosingFolder(): void {
    this.isMinimizeAllSceneClosingFolder = false;
  }

  public setIsMinimizeAllSceneClosingFolder(): void {
    this.isMinimizeAllSceneClosingFolder = true;
  }

  public getStartAppType(): StartType {
    return this.mBaseCloseAppHandlerList[0]?.mStartAppType;
  }

  public getStartCardId(): string {
    return this.mBaseCloseAppHandlerList[0]?.mCardId;
  }

  public getExtraId(): string {
    return this.mBaseCloseAppHandlerList[0]?.mExtraId;
  }

  public getShortcutId(): string {
    return this.mBaseCloseAppHandlerList[0]?.mShortcutId;
  }

  public setStartAppSubtype(type: StartSubtype): void {
    log.showInfo(TAG, `set start app subtype, type=${type}`);
    this.mStartSubtype = type;
  }

  public getStartAppSubtype(): number {
    return this.mStartSubtype;
  }

  public resetStartAppSubtype(): void {
    log.showInfo(TAG, 'reset start app subtype');
    this.mStartSubtype = StartSubtype.NONE;
  }

  public setIsStartCard(): void {
    this.mIsStartCard = true;
  }

  public getAndResetIsStartCard(): boolean {
    let tempIsStartCard: boolean = this.mIsStartCard;
    this.resetIsStartCard();
    return tempIsStartCard;
  }

  public resetIsStartCard(): void {
    this.mIsStartCard = false;
  }

  public setIsStartShortcut(): void {
    this.mIsStartShortCut = true;
  }

  public resetIsStartShortcut(): void {
    this.mIsStartShortCut = false;
  }

  public getAndResetIsStartShortcut(): boolean {
    let tempIsStartShortCut: boolean = this.mIsStartShortCut;
    this.resetIsStartShortcut();
    return tempIsStartShortCut;
  }

  // 释放旧的缓存
  public clearAdaptiveIconCache(iconId?: number): void {
    if (iconId && iconId !== this.touchedIconId) {
      log.showError(TAG, `clearAdaptiveIconCache ${iconId} is not touched icon`);
      return;
    }
    this.touchedBundleName = '';
    this.touchedModuleName = '';
    this.touchedAbilityName = '';
    this.touchedIconId = 0;
    const tempArray : ArrayList<image.PixelMap> = new ArrayList();
    for (let i = 0; i < this.adaptiveIcon.length; i++) {
      const adaptiveIconItemIsEmpty: boolean = CheckEmptyUtils.isEmpty(this.adaptiveIcon[i]);
      log.showWarn(TAG, `clearAdaptiveIconCache item${i} is empty: ${adaptiveIconItemIsEmpty}`);
      if (!adaptiveIconItemIsEmpty) {
        tempArray.add(this.adaptiveIcon[i]);
      }
    }
    this.adaptiveIcon = [];
    if (tempArray.length === 0) {
      return;
    }

    if (!DeviceHelper.isPad()) {
      // pad未接入图标缓存，需要主动释放adaptiveIcon；手机由adaptiveIconManager手动释放
      return;
    }
    // 由于启动退出过程中如果产生touch事件会进行释放，所以需要判断当前如果有动效计数，需要延迟释放启动退出的截图
    if (SCBTransitionManager.getInstance().getStartExitAnimationCount() > 0) {
      this.setOrResetReleaseSnapshot(() => {
        log.showWarn(TAG, `clearAdaptiveIconCache timeout`);
        tempArray.forEach((item: image.PixelMap) => {
          item.release();
        });
      }, NumberConstants.CONSTANT_NUMBER_ONE_THOUSAND);
    } else {
      log.showWarn(TAG, `clearAdaptiveIconCache`);
      tempArray.forEach((item: image.PixelMap) => {
        item.release();
      });
    }
  }

  public async setAdaptiveIcon(bundleName: string, moduleName: string, abilityName: string, iconId: number): Promise<void> {
    if (this.isUpdatingAdaptiveIcon) {
      // 缓存更新过程中不允许再次更新缓存，避免出现时序错乱问题
      log.showWarn(TAG, `setAdaptiveIcon: ${bundleName} isUpdateAdaptiveIcon return`);
      return;
    }

    // 由于主题包对前后景做了other_mask的二次加工，可能导致直接从BMS获取的前后景不是实际显示图片
    // 在线主题当前不支持分层图标动效
    if (onLineThemeUtil.isOnlineTheme()) {
      log.showWarn(TAG, 'Adaptive icons in online themes are not supported');
      return;
    }

    Trace.start(`setAdaptiveIcon, bundleName: ${bundleName}`);
    log.showWarn(TAG, `setAdaptiveIcon, bundleName: ${bundleName} iconId: ${iconId} start`);
    this.isUpdatingAdaptiveIcon = true;

    this.clearAdaptiveIconCache();
    const iconResources: image.PixelMap[] =
      await AdaptiveIconManager.getInstance().getIconResource(bundleName, moduleName, abilityName);
    if (iconResources.length !== 0) {
      this.adaptiveIcon[0] = iconResources[0];
      this.adaptiveIcon[1] = iconResources[1];
      this.touchedBundleName = bundleName;
      this.touchedModuleName = moduleName;
      this.touchedAbilityName = abilityName;
      this.touchedIconId = iconId;
    }
    this.isUpdatingAdaptiveIcon = false;
    log.showWarn(TAG, `setAdaptiveIcon, bundleName: ${bundleName} end`);
    Trace.end(`setAdaptiveIcon, bundleName: ${bundleName}`);
  }

  public async getAdaptiveIcon(bundleName: string, moduleName: string, abilityName: string, touchedIconId: number):
    Promise<(image.PixelMap)[]> {
    // 由于主题包对前后景做了other_mask的二次加工，可能导致直接从BMS获取的前后景不是实际显示图片
    // 在线主题当前不支持分层图标动效
    if (onLineThemeUtil.isOnlineTheme()) {
      log.showInfo(TAG, `getAdaptiveIcon, Adaptive icons in online themes are not supported`);
      return [];
    }
    if (!this.isUpdatingAdaptiveIcon && this.touchedBundleName === bundleName && this.touchedModuleName === moduleName &&
      this.touchedAbilityName === abilityName && this.touchedIconId === touchedIconId) {
      return this.adaptiveIcon;
    } else if (!this.isUpdatingAdaptiveIcon) {
      await this.setAdaptiveIcon(bundleName, moduleName, abilityName, touchedIconId);
      return this.adaptiveIcon;
    }
    return [];
  }

  /**
   * 保存卡片截图，用于启动退出动效
   * @param cardId 卡片id
   * @param image 截图
   */
  public setCardStartSnapshot(cardId: string, image: image.PixelMap): void {
    this.touchedCardId = cardId;
    let imageTmp = this.cardStartSnapshot;
    try {
      this.cardStartSnapshot = ObjectCopyUtil.deepCopyPixelMap(image);
    } catch (err) {
      log.showError(TAG, `deepCopyPixelMap failed: ${err?.msg}, using reference!`);
      this.cardStartSnapshot = image;
    }
    if (imageTmp) {
      // 由于启动退出过程中如果产生touch事件会进行释放，所以需要判断当前如果有动效计数，需要延迟释放启动退出的截图
      if (SCBTransitionManager.getInstance().getStartExitAnimationCount() > 0) {
        this.setOrResetReleaseSnapshot(() => {imageTmp?.release()},
          NumberConstants.CONSTANT_NUMBER_ONE_THOUSAND);
      } else {
        imageTmp.release();
      }
    }
    log.showInfo(TAG, `setCardStartSnapshot: ${cardId}`);
  }

  private setOrResetReleaseSnapshot(releaseFunction:() => void, timeout: number): void {
    if (this.releaseSnapshot) {
      this.releaseSnapshot.executeImmediately();
      this.releaseSnapshot = null;
    }
    this.releaseSnapshot = new ReleaseSnapshot(releaseFunction, timeout);
  }

  /**
   * 获取卡片截图
   * @param cardId 卡片id
   * @returns 截图pixelMap
   */
  public getCardStartSnapshot(cardId: string): image.PixelMap | undefined {
    if (cardId !== this.touchedCardId) {
      log.showError(TAG, `${cardId} is not touched card`);
      return undefined;
    }
    return this.cardStartSnapshot;
  }

  /**
   * 删除卡片缓存的截图
   */
  public deleteCardCache(cardId?: string): void {
    if (cardId && cardId !== this.touchedCardId) {
      log.showError(TAG, `deleteCardCache ${cardId} is not touched card`);
      return;
    }
    if (this.cardStartSnapshot) {
      let cacheCardShot: image.PixelMap = this.cardStartSnapshot;
      cacheCardShot.release();
      this.cardStartSnapshot = undefined;
    }
  }

  /**
   * 根据id来判断卡片或图标退出时宽度是否发生改变
   * @param id 图标id
   * @returns 图标id存在且卡片宽度发生改变则返回true,否则false
   */
  public isWidthChangeCard(id: string): boolean {
    return id ? widthChangeCardPrefixList.some((item) => id.startsWith(item)) : false;
  }
}

export enum StartSubtype {
  NONE,
  DOCK_ICON,
  DOCK_RIGHT_MENU,
  ICON_FROM_APP_CENTER,
  ICON_FROM_OTHER
}

/**
 * 应用退出动效图标缓存管理类
 */
export class AdaptiveIconManager {
  private static instance?: AdaptiveIconManager;
  private iconResources: IconResource[] = [];
  private deleteIconCallback?: (bundleName: string) => void;

  /**
   * 获取单例类
   */
  public static getInstance(): AdaptiveIconManager {
    if (!AdaptiveIconManager.instance) {
      AdaptiveIconManager.instance = new AdaptiveIconManager();
    }
    return AdaptiveIconManager.instance;
  }

  /**
   * 获取指定标识的图标缓存
   *
   * @param key 指定图标标识
   */
  public async getIconResource(bundleName: string, moduleName: string, abilityName: string): Promise<image.PixelMap[]> {
    const index: number = this.iconResources.findIndex((value: IconResource) => {
      return value.bundleName === bundleName && value.moduleName === moduleName && value.abilityName === abilityName;
    });
    if (index >= 0) {
      const resoure: IconResource = this.iconResources[index];
      this.iconResources.splice(index, 1);
      this.iconResources.unshift(resoure);
      log.showInfo(TAG, 'get icon resource, bundleName: %{public}s', bundleName);
      return [resoure.backgroundImage, resoure.foregroundImage];
    }

    let iconInfo = await IconResourceManager.getInstance().getIconResource(bundleName, moduleName, abilityName);
    if (!CheckEmptyUtils.isEmpty(iconInfo.adaptivePic[0])) {
      let backgroundImage: image.PixelMap = await GraphicUtils.changeBase64ToPixel(iconInfo.adaptivePic[0]);
      let foregroundImage: image.PixelMap = await GraphicUtils.changeBase64ToPixel(iconInfo.adaptivePic[1]);
      PixelMapUtil.addName(backgroundImage, `Adaptive_background_${bundleName}`);
      PixelMapUtil.addName(foregroundImage, `Adaptive_foreground_${bundleName}`);
      this.putIconResource(new IconResource(bundleName, moduleName, abilityName, backgroundImage, foregroundImage));
      return [backgroundImage, foregroundImage];
    }
    return [];
  }

  /**
   * 添加图标缓存
   *
   * @param key 缓存标识
   * @param images 图标内容
   */
  public putIconResource(resoure: IconResource): void {
    if (DeviceHelper.isPad()) {
      // pad常驻未实现自动化，暂不支持添加图标缓存
      return;
    }

    if (this.iconResources.length >= MAX_COUNT) {
      const removeResource: IconResource = this.iconResources.pop();
      removeResource.release();
      log.showInfo(TAG, 'remove icon resources, bundleName: %{public}s', removeResource.bundleName);
    }

    this.iconResources.unshift(resoure);
    log.showInfo(TAG, 'put icon resource, bundleName: %{public}s, size: %{public}d', resoure.bundleName, this.iconResources.length);
  }

  /**
   * 删除指定包名的图标缓存
   *
   * @param bundleName 应用包名
   */
  public deleteIconResource(bundleName: string): void {
    this.iconResources.filter((value: IconResource) => {
      return value.bundleName === bundleName;
    }).forEach((value: IconResource) => {
      value.release();
    });
    this.iconResources = this.iconResources.filter((value: IconResource) => {
      return value.bundleName !== bundleName;
    });
    this.deleteIconCallback?.(bundleName);
    log.showInfo(TAG, 'delete icon resource, bundleName: %{public}s, size: %{public}d', bundleName, this.iconResources.length);
  }

  /**
   * 清空所有图标缓存
   *
   * @param msg 来源
   */
  public clearIconResources(msg: string): void {
    this.iconResources.forEach((resource: IconResource) => {
      resource.release();
      this.deleteIconCallback?.(resource.bundleName);
    });
    this.iconResources = [];
    log.showInfo(TAG, 'clear icon resources, by %{public}s', msg);
  }

  /**
   * 设置删除图标的回调
   *
   * @param callback 删除图标的回调
   */
  public setDeleteIconCallback(callback: (bundleName: string) => void): void {
    this.deleteIconCallback = callback;
  }
}

export class IconResource {
  public bundleName: string;
  public moduleName: string;
  public abilityName: string;
  // 后景图
  public backgroundImage: image.PixelMap;
  // 前景图
  public foregroundImage: image.PixelMap;

  constructor(bundleName: string, moduleName: string, abilityName: string,
    backgroundImage: image.PixelMap, foregroundImage: image.PixelMap) {
    this.bundleName = bundleName;
    this.moduleName = moduleName;
    this.abilityName = abilityName;
    this.backgroundImage = backgroundImage;
    this.foregroundImage = foregroundImage;
  }

  // 释放前后景图片资源
  public release(): void {
    this.backgroundImage.release();
    this.foregroundImage.release();
  }
}