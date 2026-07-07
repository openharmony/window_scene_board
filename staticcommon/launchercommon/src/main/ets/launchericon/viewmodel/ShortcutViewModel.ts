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

import launcherBundleManager from '@ohos.bundle.launcherBundleManager';
import { BusinessError } from '@ohos.base';
import shortcutManager from '@ohos.bundle.shortcutManager';
import image from '@ohos.multimedia.image';
// import { hdsDrawable } from '@kit.UIDesignKit';
import { DrawableDescriptor } from '@ohos.arkui.drawableDescriptor';
import resourceManager from '@ohos.resourceManager';
import bundleManager from '@ohos.bundle.bundleManager';
import Prompt from '@ohos.promptAction';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';
import {
  bundleManagerFwk,
  DeviceHelper,
  GlobalContext,
  GraphicUtils,
  localEventManager,
  ResourceManager,
} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SCBSceneMode, StartAbilityUtil } from '@ohos/windowscene';
import {
  CheckEmptyUtils, LogDomain, LogHelper, StartType
} from '@ohos/basicutils';
import { SCBConstants, } from '@ohos/commonconstants';
import { ShortcutInfo, ShortcutWant } from '../../bean/ReceiveEventInfo';
import { AppStatus, BusinessType, CommonConstants, ItemParameter } from '../../constants/CommonConstants';
import DockLayoutCacheManager from '../../cache/layout/DockLayoutCacheManager';
import { LaunchLayoutCacheManager } from '../../cache/layout/LaunchLayoutCacheManager';
import { AppModel } from '../../model/AppModel';
import { ResourceChangeListener } from '../../model/AppModel';
import EventConstants from '../../constants/EventConstants';
import { MenuInfo } from '../../bean/MenuInfo';
import { CloseAppManager } from '../../manager/CloseAppManager';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { StyleConstants } from '../../constants/StyleConstants';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import LayoutDescription from '../../bean/LayoutDescription';
import { DockItemInfo } from '../../bean/DockItemInfo';
import { ResidentLayoutCacheMgr } from '../../dock/cache/ResidentLayoutCacheMgr';
import { Cache2RdbHelper } from '../../cache/CacheRdbHelper';

const TAG = 'ShortcutViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.ICON, TAG);
// 系统应用快捷方式加桌上限
const SYSTEM_SHORTCUTS_LIMIT = 100;
// 三方应用快捷方式加桌上限
const NON_SYSTEM_SHORTCUTS_LIMIT = 2;
// PC上三方应用快捷方式加桌上限
const PC_NON_SYSTEM_SHORTCUTS_LIMIT = 10;
// 联系人应用包名
const CONTACTS_BUNDLE_NAME = 'com.ohos.contacts';
// 联系人快捷方式id
const CONTACT_SHORTCUT_ID = 'shortcut_id_01';
const KEY_ICON = 'icon';
const ADAPTIVE_ICON = 'adaptiveicon';

export class ShortcutViewModel {
  static mInstance: ShortcutViewModel;
  private mAppModel: AppModel;
  private desktopContext: ServiceExtensionContext = GlobalContext.getContext();
  private backgroundImage?: image.PixelMap;
  private readonly mLauncherLayoutCacheManager: LaunchLayoutCacheManager;
  private resourceChangeListener: ResourceChangeListener = {
    id: TAG,
    clearCache: () => this.clearBackgroundImage(),
  };

  private constructor() {
    this.mAppModel = AppModel.getInstance();
    this.subscribeColorChangeEvent();
    this.mLauncherLayoutCacheManager = LaunchLayoutCacheManager.getInstance();
    this.mAppModel.registerResourceChangeListener(this.resourceChangeListener);
  }

  public static getInstance(): ShortcutViewModel {
    if (!ShortcutViewModel.mInstance) {
      ShortcutViewModel.mInstance = new ShortcutViewModel();
    }
    return ShortcutViewModel.mInstance;
  }

  private subscribeColorChangeEvent(): void {
    this.desktopContext.eventHub.on('onColorModeChange', (currColorMode: number) => {
      log.showInfo(`onColorModeChange currColorMode: ${currColorMode}`);
      this.clearBackgroundImage();
      this.updateBackgroundImage();
      ResourceManager.getInstance().clearAppResourceCache();
      // 触发快捷图标appIcon和appIconRelative刷新
      // 触发小文件夹中快捷图标刷新，小文件夹截图刷新
      localEventManager.sendLocalEvent(EventConstants.EVENT_REFRESH_SHORTCUT_IMAGE);
    });
  }

  private updateBackgroundImage(): void {
    log.showInfo('updateBackgroundImage');
    let pixelMap: image.PixelMap | undefined;
    let oldBackgroundImage: image.PixelMap | undefined = this.backgroundImage;
    try {
      let resManager: resourceManager.ResourceManager = GlobalContext.getContext()?.resourceManager;
      let imageDrawableDescriptor: DrawableDescriptor =
        (resManager?.getDrawableDescriptor($r('app.media.shortcut_background').id)) as DrawableDescriptor;
      pixelMap = imageDrawableDescriptor?.getPixelMap();
      this.backgroundImage = this.convertToHdsIcon(pixelMap, 'shortcutBg');
    } catch (err) {
      log.showError(`updateBackgroundImage error, code:${err?.code}, message:${err?.message}`);
    } finally {
      pixelMap?.release();
      oldBackgroundImage?.release();
    }
  }

  public clearBackgroundImage(): void {
    if (!CheckEmptyUtils.isEmpty(this.backgroundImage)) {
      let oldBackgroundImage: image.PixelMap | undefined = this.backgroundImage;
      this.backgroundImage = undefined;
      oldBackgroundImage?.release();
    }
  }

  /**
   * check shortcut info and build shortcut menu
   */
  public checkShortCutInfo(appInfo: AppItemInfo, menuInfoList: MenuInfo[], screenId?: number): void {
    if (CheckEmptyUtils.isEmpty(appInfo) || CheckEmptyUtils.isEmpty(menuInfoList)) {
      log.showError('appInfo or menuInfoList is empty');
      return;
    }
    // 联系人应用定制不支持快捷菜单
    if (this.isContactsApp(appInfo.bundleName)) {
      log.showWarn('not support shortcuts');
      return;
    }
    let shortcutInfoList: ShortcutInfo[] | undefined = this.mAppModel.getShortcutInfo(appInfo.bundleName);
    if (!shortcutInfoList) {
      shortcutInfoList = this.mAppModel.getShortcutInfoFromManagerSync(appInfo.bundleName);
    }

    shortcutInfoList && shortcutInfoList.forEach((shortcutInfoItem) => {
      let menu: MenuInfo = new MenuInfo();
      menu.menuType = CommonConstants.MENU_TYPE_DYNAMIC;
      menu.menuImgSrc = shortcutInfoItem.icon ?? '';
      menu.menuText = shortcutInfoItem.label ?? '';
      menu.shortcutIconId = shortcutInfoItem.iconId ?? 0;
      menu.shortcutLabelId = shortcutInfoItem.labelId ?? 0;
      menu.shortcutId = shortcutInfoItem.id;
      menu.bundleName = shortcutInfoItem.bundleName;
      menu.moduleName = shortcutInfoItem.moduleName;
      shortcutInfoItem.appIndex = appInfo.appIndex ?? 0;
      menu.onMenuClick = (): void => {
        this.onShortcutMenuClick(appInfo.bundleName, shortcutInfoItem, screenId);
      };
      // 如果visible是null或者undefined，说明桌面版本与BMS版本不匹配，此时当成正常快捷方式显示
      if (shortcutInfoItem.bundleName === appInfo.bundleName && shortcutInfoItem.moduleName === appInfo.moduleName &&
        shortcutInfoItem.visible !== false) {
        menuInfoList.push(menu);
      }
    });
  }

  private onShortcutMenuClick(targetBundleName: string, shortcutInfoItem: ShortcutInfo, screenId?: number): void {
    log.showInfo('onShortcutMenuClick');
    if (targetBundleName !== shortcutInfoItem.wants?.[0].targetBundle) {
      return;
    }

    this.desktopContext.eventHub.on(CommonConstants.EVENTHUB_MENU_DISAPPEAR, () => {
      this.desktopContext.eventHub.off(CommonConstants.EVENTHUB_MENU_DISAPPEAR);
      CloseAppManager.getInstance().setStartAppType(StartType.SHORTCUT_MENU, undefined, undefined, shortcutInfoItem.id);
      let appItem = new AppItemInfo();
      appItem.bundleName = shortcutInfoItem.bundleName;
      appItem.shortcutId = shortcutInfoItem.id;
      appItem.appIndex = shortcutInfoItem.appIndex;
      this.onShortcutAppClick(appItem, screenId);
    });
  }

  /**
   * 启动快捷方式
   */
  public async onShortcutAppClickWithWindowMode(mode: SCBSceneMode, appItem: AppItemInfo, screenId?: number,
    startReason?: string,): Promise<void> {
    if (!appItem) {
      log.showError('appItem is empty');
      return;
    }

    let shortcutInfo: ShortcutInfo | undefined = await this.getShortcutInfo(appItem);
    if (!shortcutInfo) {
      CloseAppManager.getInstance().resetIsStartShortcut();
      log.showError(`get shortcut info empty, reset start type, bundleName: ${appItem.bundleName}`);
      return;
    }

    log.showWarn('startShortcut');
    try {
      if (DeviceHelper.isPC() && shortcutInfo) {
        const parameters: Record<string, Object> = {};
        parameters[SCBConstants.START_FROM_SHORTCUT_ID] = shortcutInfo.id;
        if (!shortcutInfo.wants) {
          log.showWarn(`Start shortcut[${appItem.shortcutId}] failed. for invalid shortcut.wants`);
          return;
        }
        shortcutInfo.wants[0]?.parameters?.forEach((item) => {
          parameters[item.key] = item.value;
        });
        StartAbilityUtil.startLauncherAbilityWithModeByWant({
          bundleName: shortcutInfo.wants[0].targetBundle,
          moduleName: shortcutInfo.wants[0].targetModule,
          abilityName: shortcutInfo.wants[0].targetAbility,
          parameters: parameters,
        }, mode, screenId);
        return;
      }
      launcherBundleManager.startShortcutWithReason(shortcutInfo, startReason ?? '');
    } catch (err) {
      log.showError(`startShortcut error, code: ${err?.code}  message: ${err?.message}`);
    }
  }

  /**
   * 启动快捷方式
   */
  public async onShortcutAppClick(appItem: AppItemInfo, screenId?: number, startReason?: string,): Promise<void> {
    this.onShortcutAppClickWithWindowMode(SCBSceneMode.FULLSCREEN, appItem, screenId, startReason);
  }

  /**
   * 根据AppItemInfo，从BMS获取已加桌快捷方式信息
   */
  public async getShortcutInfo(appItem: AppItemInfo): Promise<ShortcutInfo | undefined> {
    if (!appItem) {
      log.showError('appItem is empty');
      return undefined;
    }

    log.showWarn(`getShortcutInfo, bundleName:${appItem.bundleName}, appIndex:${appItem.appIndex}, id:${appItem.shortcutId}`);
    //添加兜底方案，解决联系人快捷方式shortcutId丢失的问题
    if (this.isContactsApp(appItem.bundleName) && CheckEmptyUtils.isEmpty(appItem.shortcutId)) {
      log.showWarn('reset shortcutId for contact');
      appItem.shortcutId = CONTACT_SHORTCUT_ID;
    }
    let shortcutInfoList: ShortcutInfo[] = await this.getAllDesktopShortcutFromBMS();
    let shortcutInfo: ShortcutInfo | undefined = shortcutInfoList.find(item => item.id === appItem.shortcutId &&
      item.bundleName === appItem.bundleName && (item.appIndex ?? 0) === (appItem.appIndex ?? 0));

    if (!shortcutInfo) {
      log.showWarn('Can not find shortcutInfo from BMS database');
      // BMS数据库无法查到，再从应用包中查找
      shortcutInfoList = this.getShortcutByBundleName(appItem.bundleName);
      shortcutInfo = shortcutInfoList.find(item => item.id === appItem.shortcutId);
      if (!shortcutInfo) {
        log.showError('Can not find shortcutInfo at all');
        return undefined;
      }
    }
    shortcutInfo.appIndex = appItem.appIndex ?? 0;

    return shortcutInfo;
  }

  /**
   * 获取快捷方式最新的资源ID
   * 针对sourceType为1的快捷方式
   * @param appItem
   * @returns
   */
  public getShortcutIconId(appItem: AppItemInfo): number | undefined {
    if (appItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      let allShortcutInfoList: ShortcutInfo[] | undefined = this.mAppModel.getAllShortcutInfo(appItem.bundleName);
      if (allShortcutInfoList) {
        let shortcutItem: ShortcutInfo | undefined = allShortcutInfoList.find(item => item.id === appItem.shortcutId);
        let cacheKey = `${shortcutItem?.iconId}${appItem.bundleName}${appItem.moduleName}`;
        ResourceManager.getInstance().deleteAppResourceCache(cacheKey, KEY_ICON);
        ResourceManager.getInstance().deleteAppResourceCache(cacheKey, ADAPTIVE_ICON);
        return shortcutItem?.iconId;
      }
    }
    return undefined;
  }

  public getShortcutBackgroundImage(item: BaseShortCutInfo | AppItemInfo): string | image.PixelMap {
    if (item?.typeId !== CommonConstants.TYPE_SHORTCUT_ICON &&
      (item as BaseShortCutInfo)?.startType !== StartType.SHORTCUT_APP) {
      return '';
    }

    // 联系人快捷图标，不加背景图
    if (this.isContactsApp(item.bundleName)) {
      return '';
    }

    if (CheckEmptyUtils.isEmpty(this.backgroundImage)) {
      this.updateBackgroundImage();
    }
    return this.backgroundImage ?? '';
  }

  /**
   * 获取快捷方式图片资源
   * 注：该接口获取的PixelMap地址指向资源包，不可release。释放会直接删除资源包里面的资源，无法恢复
   *
   * @param appItem 快捷方式图片信息
   * @returns 资源中的快捷方式图片
   */
  public async getShortcutImageAsync(appItem: AppItemInfo): Promise<string | image.PixelMap> {
    if (!appItem) {
      log.showError('Fail to getShortcutImageAsync, appItem is empty!');
      return '';
    }

    log.showWarn(`getShortcutImageAsync iconResource is empty:${CheckEmptyUtils.checkStrIsEmpty(appItem.iconResource)}, appIconId:${appItem.appIconId}`);

    if (appItem.appIconId) {
      return await ResourceManager.getInstance().getAppIconWithCacheAsync(appItem.appIconId, appItem.bundleName,
        appItem.moduleName, StyleConstants.DEFAULT_ICON, 0) as string;
    }

    if (appItem.iconResource) {
      return this.convertToHdsIcon(appItem.iconResource, appItem.bundleName) ?? '';
    }

    // 根据bundleName, appIndex, shortcutId获取快捷图标布局信息
    log.showWarn('maybe customized shortcut in starting and exiting');
    let sameAppItemInfoList: GridLayoutItemInfo[] = this.selectAllSameApp(appItem.bundleName, appItem.appIndex ?? 0);
    let gridLayoutItem: GridLayoutItemInfo | undefined =
      sameAppItemInfoList.find(item => item.shortcutId === appItem.shortcutId);
    if (gridLayoutItem?.iconResource) {
      log.showWarn('get customized shortcut icon resource');
      return this.convertToHdsIcon(gridLayoutItem.iconResource, gridLayoutItem.bundleName) ?? '';
    }

    // 快捷方式没有图标来源的时候，使用快捷方式专属默认图标
    let defaultShortcutImage: image.PixelMap | string | undefined = this.getDefaultShortcutImage();
    if (typeof defaultShortcutImage !== 'string') {
      return defaultShortcutImage ?? '';
    }

    log.showError('Fail to getShortcutImageAsync, appIconId or iconResource is empty!');
    return '';
  }

  private getDefaultShortcutImage(): image.PixelMap | string | undefined {
    log.showInfo('getDefaultShortcutImage');
    let pixelMap: image.PixelMap | undefined;
    try {
      let resManager: resourceManager.ResourceManager = GlobalContext.getContext()?.resourceManager;
      let imageDrawableDescriptor: DrawableDescriptor =
        (resManager?.getDrawableDescriptor($r('app.media.default_shortcut').id)) as DrawableDescriptor;
      pixelMap = imageDrawableDescriptor?.getPixelMap();
      return this.convertToHdsIcon(pixelMap, 'defaultShortcutBgImage');
    } catch (err) {
      log.showError(`getDefaultShortcutImage error, code:${err?.code}, message:${err?.message}`);
    } finally {
      pixelMap?.release();
    }
    return '';
  }

  public getShortcutImageSync(appItem: AppItemInfo, isNeedDefaultShortcut: boolean = false): string | image.PixelMap {
    if (!appItem) {
      log.showError('Fail to getShortcutImageSync, appItem is empty!');
      return '';
    }

    log.showWarn(`getShortcutImageSync iconResource:${!CheckEmptyUtils.checkStrIsEmpty(appItem.iconResource)}, ` +
      `appIconId:${appItem.appIconId}`);
    let icon: string | image.PixelMap = '';
    if (appItem.appIconId) {
      icon = ResourceManager.getInstance().getCachedAppIcon(appItem.appIconId, appItem.bundleName, appItem.moduleName);
    } else if (appItem.iconResource) {
      icon = this.convertToHdsIcon(appItem.iconResource, appItem.bundleName) ?? '';
    } else {
      log.showError('Fail to getShortcutImageSync, appIconId or iconResource is empty!');
    }

    if (isNeedDefaultShortcut && CheckEmptyUtils.isEmptyStringOrPixelMap(icon)) {
      icon = this.getDefaultShortcutImage() ?? '';
    }
    return icon;
  }

  /**
   * 将快捷图标转换成Hds图标
   * @param icon 快捷图标资源
   * @param bundleName 快捷图标应用的bundleName
   * @returns
   */
  public convertToHdsIcon(icon: string | image.PixelMap, bundleName: string): image.PixelMap | undefined {
    if (CheckEmptyUtils.isEmptyStringOrPixelMap(icon)) {
      log.showError(`can not convert empty icon`);
      return undefined;
    }
    log.showWarn(`start to convert icon, bundleName: ` + bundleName);
    let pixelMap: image.PixelMap;
    if (typeof icon === 'string') {
      log.showInfo('change string to PixelMap');
      pixelMap = GraphicUtils.changeBase64ToPixelSync(icon, { desiredPixelFormat: image.PixelMapFormat.BGRA_8888 });
    } else {
      pixelMap = icon;
    }
    return GraphicUtils.getHdsIcon(bundleName + '_shortcut', bundleManagerFwk.getIconSizeOfGrid(),
      pixelMap, bundleManagerFwk.getMaskImage());
  }

  /**
   * 快捷方式加桌前校验
   */
  public checkShortcut(shortcutInfo: BaseShortcutInfo, isOuter?: boolean): CheckResult {
    let checkResult: CheckResult = new CheckResult();

    // 入参检查
    if (!shortcutInfo || !shortcutInfo.bundleName || !shortcutInfo.id) {
      log.showError('shortcutInfo is invalid parameters');
      checkResult.code = ResultCode.FAILED_INVALID_PARAMETERS;
      return checkResult;
    }
    if (!shortcutInfo.appIndex) {
      shortcutInfo.appIndex = 0;
    }
    log.showWarn(`checkShortcut shortcutInfo bundleName:${shortcutInfo.bundleName}, id:${shortcutInfo.id}, ` +
      `appIndex:${shortcutInfo.appIndex}`);

    // ID重复检查
    let sameAppItemInfoList: GridLayoutItemInfo[] = this.selectAllSameApp(shortcutInfo.bundleName,
      shortcutInfo.appIndex, isOuter);
    let isExist: boolean = sameAppItemInfoList.some(item => item.shortcutId === shortcutInfo.id);
    if (isExist) {
      checkResult.code = ResultCode.FAILED_DUPLICATE_ID;
      return checkResult;
    }

    // 包安装检查
    let bundleInfo: bundleManager.BundleInfo | undefined;
    try {
      const bundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION;
      // 尝试从desk缓存获取
      let shortcutLimitNum = LaunchLayoutCacheManager.getInstance()
        .getShortCountLimitByBundleName(shortcutInfo.bundleName);
      if (shortcutLimitNum === undefined) {
        // 尝试从dock缓存获取
        shortcutLimitNum = DockLayoutCacheManager.getInstance().getShortCountLimitByBundleName(shortcutInfo.bundleName);
      }
      if (shortcutLimitNum === undefined) {
        const shortcutsLimit: number = DeviceHelper.isPC() ? PC_NON_SYSTEM_SHORTCUTS_LIMIT : NON_SYSTEM_SHORTCUTS_LIMIT;
        bundleInfo = bundleManager.getBundleInfoSync(shortcutInfo.bundleName, bundleFlag, this.mAppModel.getUserId());
        checkResult.limit = bundleInfo.appInfo.systemApp ? SYSTEM_SHORTCUTS_LIMIT : shortcutsLimit;
      } else {
        checkResult.limit = shortcutLimitNum;
      }
    } catch (err) {
      log.showError(`getBundleInfoSync error, code: ${err?.code}, message: ${err?.message}`);
      checkResult.code = ResultCode.FAILED_INVALID_PARAMETERS;
      return checkResult;
    }

    // 数量上限检查
    let shortcutCount = sameAppItemInfoList.filter(item => item.typeId === CommonConstants.TYPE_SHORTCUT_ICON).length;
    if (shortcutCount + 1 > checkResult.limit) {
      checkResult.code = ResultCode.FAILED_QUANTITY_LIMIT;
      return checkResult;
    }
    //pc桌面满时不能继续添加
    if (DeviceHelper.isPC() && !this.isCanCreateShortcut()) {
      checkResult.code = ResultCode.FAILED_OTHER;
      return checkResult;
    }
    checkResult.code = ResultCode.SUCCESS;
    return checkResult;
  }

  private isCanCreateShortcut(pageId?: number): boolean {
    const layoutDescription: LayoutDescription = this.mLauncherLayoutCacheManager.selectLayoutDescription();
    const first = layoutDescription.row;
    const second = layoutDescription.column;
    const pageCount = layoutDescription.pageCount;
    const item: ItemParameter = { area: [1, 1] };
    for (let i = 0; i < pageCount; i++) {
      if (this.checkAllPositions(item, pageId ?? 0, first, second)) {
        return true;
      }
    }
    return false;
  }

  private checkAllPositions(item: ItemParameter, pageId: number, first: number, second: number): boolean {
    for (let y = 0; y < first; y++) {
      for (let x = 0; x < second; x++) {
        if (this.mLauncherLayoutCacheManager.isPositionValid(item, pageId, x, y)) {
          return true;
        }
      }
    }
    return false;
  }

  public selectAllSameApp(bundleName: string, appIndex: number, isOuter?: boolean): GridLayoutItemInfo[] {
    let layoutInfoList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP, isOuter);
    let findItemInfoList: GridLayoutItemInfo[] = this.selectSameApp(layoutInfoList, bundleName, appIndex);

    if (!isOuter) {
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      findItemInfoList = findItemInfoList.concat(this.selectSameApp(residentList, bundleName, appIndex));
    }

    log.showInfo(`selectAllSameApp bundleName:${bundleName}, appIndex:${appIndex}, findItemInfoList:${findItemInfoList.length}`);
    return findItemInfoList;
  }

  private selectSameApp(itemInfoList: GridLayoutItemInfo[] | DockItemInfo[], bundleName: string,
    appIndex: number): GridLayoutItemInfo[] {
    let findItemInfoList: GridLayoutItemInfo[] = [];
    if (!itemInfoList) {
      log.showWarn('itemInfoList is empty');
      return findItemInfoList;
    }

    itemInfoList.forEach((item: GridLayoutItemInfo | DockItemInfo) => {
      if (item.typeId === CommonConstants.TYPE_APP || item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.isSameApp(item, bundleName, appIndex, findItemInfoList);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        item.layoutInfo?.flat().forEach(itemInFolder => {
          this.isSameApp(itemInFolder, bundleName, appIndex, findItemInfoList);
        });
      }
    });
    return findItemInfoList;
  }

  private selectSameShortcut(itemInfoList: GridLayoutItemInfo[] | DockItemInfo[], bundleName: string,
    shortcutId: string, appIndex: number): GridLayoutItemInfo[] {
    let findItemInfoList: GridLayoutItemInfo[] = [];
    if (!itemInfoList) {
      log.showWarn('itemInfoList is empty');
      return findItemInfoList;
    }

    itemInfoList.forEach((item: GridLayoutItemInfo | DockItemInfo) => {
      if (item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.isSameShortcut(item, bundleName, appIndex, shortcutId, findItemInfoList);
      } else if (item.typeId === CommonConstants.TYPE_FOLDER) {
        item.layoutInfo?.flat().forEach(itemInFolder => {
          this.isSameShortcut(itemInFolder, bundleName, appIndex, shortcutId, findItemInfoList);
        });
      }
    });
    return findItemInfoList;
  }

  private isSameShortcut(item: GridLayoutItemInfo | DockItemInfo, bundleName: string, appIndex: number,
    shortcutId: string, findItemInfoList: GridLayoutItemInfo[]): void {
    if (item.bundleName === bundleName && item.appIndex === appIndex && item.shortcutId === shortcutId) {
      findItemInfoList.push(item as Object as GridLayoutItemInfo);
    }
  }

  private isSameApp(item: GridLayoutItemInfo | DockItemInfo, bundleName: string, appIndex: number,
    findItemInfoList: GridLayoutItemInfo[]): void {
    if (item.bundleName === bundleName && item.appIndex === appIndex) {
      findItemInfoList.push(item as Object as GridLayoutItemInfo);
    }
  }

  /**
   * 快捷方式添加同步到BMS
   */
  public async addShortcutToBMS(shortcutInfo: ShortcutInfo): Promise<ResultCode> {
    if (!shortcutInfo) {
      log.showError('addDesktopShortcutInfo fail, shortcutInfo is empty');
      return ResultCode.FAILED_OTHER;
    }

    log.showWarn(`addShortcutToBMS bundleName:${shortcutInfo.bundleName}, appIndex:${shortcutInfo.appIndex}, ` +
      `shortcutId:${shortcutInfo.id}, sourceType:${shortcutInfo.sourceType}`);
    try {
      await shortcutManager.addDesktopShortcutInfo(shortcutInfo, this.mAppModel.getUserId());
    } catch (err) {
      log.showError(`addDesktopShortcutInfo error, code: ${err?.code}, message: ${err?.message}`);
      return ResultCode.FAILED_OTHER;
    }

    log.showInfo('addShortcutToBMS success');
    return ResultCode.SUCCESS;
  }

  /**
   * 快捷方式删除同步到BMS
   */
  public async deleteShortcutFromBMS(baseShortcutInfo: BaseShortcutInfo): Promise<ResultCode> {
    if (!baseShortcutInfo) {
      log.showError('deleteDesktopShortcutInfo fail, baseShortcutInfo is empty');
      return ResultCode.FAILED_OTHER;
    }

    log.showWarn(`deleteShortcutFromBMS bundleName:${baseShortcutInfo.bundleName}, ` +
      `appIndex:${baseShortcutInfo.appIndex}, shortcutId:${baseShortcutInfo.id}`);
    // BMS数据库未使用字段sourceType，可任意值
    let shortcutInfo: ShortcutInfo = {
      id: baseShortcutInfo.id,
      bundleName: baseShortcutInfo.bundleName,
      appIndex: baseShortcutInfo.appIndex ?? 0,
      sourceType: 0
    };

    // 缓存中依然有其对应快捷方式, 不删除bms数据库
    if (this.isShortcutInLauncherAndDock(shortcutInfo)) {
      log.showError(`${shortcutInfo.bundleName}_${shortcutInfo.id}_${shortcutInfo.appIndex}` +
        `is exist in launcher and dock, not need to delete from BMS`);
      return ResultCode.FAILED_OTHER;
    }
    try {
      await shortcutManager.deleteDesktopShortcutInfo(shortcutInfo, this.mAppModel.getUserId());
    } catch (err) {
      log.showError(`deleteDesktopShortcutInfo error, code: ${err?.code}, message: ${err?.message}`);
      return ResultCode.FAILED_OTHER;
    }

    log.showInfo(`deleteShortcutFromBMS success`);
    return ResultCode.SUCCESS;
  }

  /**
   * 快捷方式删除同步到BMS
   *
   * @param item
   */
  public deleteShortcutFromBMSByAppItem(item: AppItemInfo): void {
    let baseShortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
    baseShortcutInfo.id = item.shortcutId ?? '';
    baseShortcutInfo.bundleName = item.bundleName;
    baseShortcutInfo.appIndex = item.appIndex;
    this.deleteShortcutFromBMS(baseShortcutInfo);
  }

  /**
   * 快捷方式更新同步到BMS
   */
  public async updateShortcutToBMS(shortcutInfo: ShortcutInfo): Promise<void> {
    log.showWarn(`updateShortcutToBMS bundleName:${shortcutInfo.bundleName}, appIndex:${shortcutInfo.appIndex}, ` +
      `shortcutId:${shortcutInfo.id}, sourceType:${shortcutInfo.sourceType}`);
    await this.deleteShortcutFromBMS(shortcutInfo as BaseShortcutInfo);
    this.addShortcutToBMS(shortcutInfo);
  }

  /**
   * 从BMS获取所有加桌的快捷方式信息
   */
  public async getAllDesktopShortcutFromBMS(): Promise<ShortcutInfo[]> {
    let shortcutInfoList: ShortcutInfo[] = [];
    try {
      shortcutInfoList = await shortcutManager.getAllDesktopShortcutInfo(this.mAppModel.getUserId());
    } catch (err) {
      log.showError(`getAllDesktopShortcutInfo error, code: ${err?.code}, message: ${err?.message}`);
    }
    return shortcutInfoList;
  }

  /**
   * 从BMS获取包名下所有静态快捷方式信息
   */
  public getShortcutByBundleName(bundleName: string): ShortcutInfo[] {
    let shortcutInfoList: ShortcutInfo[] | undefined = [];
    if (!bundleName) {
      log.showError('bundleName is empty');
      return shortcutInfoList;
    }

    shortcutInfoList = this.mAppModel.getAllShortcutInfo(bundleName);
    if (CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
      try {
        shortcutInfoList = launcherBundleManager.getShortcutInfoSync(bundleName);
      } catch (err) {
        log.showError(`getShortcutInfoSync error, code: ${err?.code}, message: ${err?.message}`);
      }
    }
    return shortcutInfoList ?? [];
  }

  /**
   * 从快捷菜单拖出快捷方式时调用，对快捷方式信息进行处理，使用extend3保存快捷方式校验结果
   * 若该快捷方式已存在则修改其keyName，图标采用keyName作为唯一标识符，修改之后可避免新拖出的快捷方式影响之前已存在的快捷方式
   *
   * @param shortcutItem 快捷方式信息
   */
  public processShortcut(shortcutItem: GridLayoutItemInfo): void {
    let result: CheckResult = this.checkShortcut({
      id: shortcutItem.shortcutId ?? '',
      bundleName: shortcutItem.bundleName,
      appIndex: shortcutItem.appIndex,
    });
    if (result.code === ResultCode.SUCCESS) {
      return;
    }
    shortcutItem.extend3 = result.code;
    if (result.code === ResultCode.FAILED_DUPLICATE_ID) {
      shortcutItem.keyName = CommonConstants.EXIST_SHORTCUT_PREFIX + shortcutItem.keyName;
    }
  }

  /**
   * 在快捷方式从菜单中拖出到桌面上时调用，检查快捷方式是否可以加桌，若不能加桌则提示用户
   *
   * @param shortcutItem 快捷方式信息
   * @returns 是否能够拖拽快捷方式加桌
   */
  public canAddShortcutByDrag(shortcutItem: GridLayoutItemInfo): boolean {
    if (shortcutItem.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
      return false;
    }
    let result: number | undefined = shortcutItem.extend3;
    if (result === ResultCode.FAILED_INVALID_PARAMETERS || result === ResultCode.FAILED_OTHER) {
      return false;
    }
    if (result === ResultCode.FAILED_DUPLICATE_ID) {
      Prompt.showToast({
        message: $r('app.string.add_exist_shortcut'),
      });
      return false;
    }
    if (result === ResultCode.FAILED_QUANTITY_LIMIT) {
      Prompt.showToast({
        message: $r('app.string.shortcuts_limit_tips'),
      });
      return false;
    }
    return true;
  }

  /**
   * 拖拽添加快捷方式时，同步添加到BMS
   *
   * @param dragItemType 拖拽类型
   * @param shortcutItem 快捷方式信息
   * @returns 添加到BMS的结果
   */
  public async addShortcutToBMSByDrag(dragItemType: number, shortcutItem: GridLayoutItemInfo): Promise<ResultCode> {
    if (dragItemType !== CommonConstants.DRAG_FROM_SHORTCUT) {
      return ResultCode.FAILED_OTHER;
    }
    if (shortcutItem.typeId !== CommonConstants.TYPE_SHORTCUT_ICON) {
      return ResultCode.FAILED_OTHER;
    }
    let shortcutList = this.getShortcutByBundleName(shortcutItem.bundleName);
    let shortcut = shortcutList.find(item => item.id === shortcutItem.shortcutId);
    if (!shortcut) {
      log.showWarn('shortcut info is not static');
      return ResultCode.FAILED_OTHER;
    }
    shortcut.appIndex = shortcutItem.appIndex ?? 0;
    return this.addShortcutToBMS(shortcut);
  }

  /**
   * 拖拽加桌的快捷方式图标写库
   *
   * @param shortcutItem 快捷方式信息
   */
  public updateShortcutIcon(shortcutItem: GridLayoutItemInfo): void {
    if (shortcutItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON && shortcutItem.appIconId &&
      shortcutItem.appStatus === AppStatus.INSTALLED) {
      const releaseLock = Cache2RdbHelper.getInstance().addLock(CommonConstants.DRAG_RDB_EVENT, 'updateShortcutIcon');
      ShortcutViewModel.getInstance().updateShortcutIconResource(shortcutItem, releaseLock);
    }
  }

  /*
  * 判断是否为联系人包名
  *
  * @param bundleName 应用包名
  * @returns 是否是联系人包名
   */
  public isContactsApp(bundleName: string): boolean {
    return bundleName === CONTACTS_BUNDLE_NAME;
  }

  /**
   * 从BMS数据库判断是否已经添加过快捷方式
   *
   * @param shortcut 待检查的快捷方式信息
   * @returns 检查结果
   */
  public async isShortcutInBMS(shortcut: ShortcutInfo): Promise<boolean> {
    let shortcutList: ShortcutInfo[] = await this.getAllDesktopShortcutFromBMS();
    let result: boolean = shortcutList.some(item => item.bundleName === shortcut.bundleName &&
      item.id === shortcut.id && item.appIndex === shortcut.appIndex);
    log.showInfo(`isShortcutInBMS ${shortcut.id} result: ${result}`);
    return result;
  }

  /**
   * 从缓存中判断是否快捷方式存在
   *
   * @param shortcut 待检查的快捷方式信息
   * @returns 检查结果
   */
  private isShortcutInLauncherAndDock(shortcut: ShortcutInfo): boolean {
    let bundleName: string = shortcut.bundleName;
    let appIndex: number = shortcut.appIndex;
    let shortcutId: string = shortcut.id;

    let layoutInfoList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP, false);

    let outerLayoutInfoList: GridLayoutItemInfo[] =
      LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(BusinessType.BUSINESS_BASIC_DESKTOP, true);
    let findItemInfoList: GridLayoutItemInfo[] =
      this.selectSameShortcut(layoutInfoList.concat(outerLayoutInfoList), bundleName, shortcutId, appIndex);

    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    findItemInfoList = findItemInfoList.concat(this.selectSameShortcut(residentList, bundleName, shortcutId, appIndex));

    log.showInfo(`selectSameShortcut bundleName:${bundleName}, appIndex:${appIndex},
      shortcutId:${shortcutId}, ` + ` findItemInfoList:${findItemInfoList.length}`);
    return findItemInfoList.length > 0;
  }

  /**
   * 获取快捷方式原始图标
   *
   * @param item 快捷方式信息
   * @returns string 快捷方式原始图标base64
   */
  public async getShortcutOriginImage(item: AppItemInfo): Promise<string> {
    return await ResourceManager.getInstance().getBase64Image(item.appIconId, item.bundleName, item.moduleName);
  }

  /**
   * 将快捷方式图标资源写库
   *
   * @param item 待写库的快捷方式信息
   */
  public updateShortcutIconResource(item: GridLayoutItemInfo, releaseLock: () => void | undefined): void {
    this.getShortcutOriginImage(item as AppItemInfo)
      .then((image: string) => {
        if (!CheckEmptyUtils.checkStrIsEmpty(image)) {
          item.iconResource = image;
        }
      })
      .catch((error: Error) => {
        log.showWarn(`getShortcutImageAsync error:${error?.message}`);
      })
      .finally(() => {
        releaseLock?.();
      });
  }
}

/**
 * basic shortcut info
 */
export class BaseShortcutInfo {
  // shortcut id
  public id: string = '';

  public bundleName: string = '';

  public appIndex?: number = 0;
}

/**
 * ShortcutInfo of AG
 */
export class AGShortcutInfo extends BaseShortcutInfo {
  public moduleName: string = '';

  public hostAbility: string = '';

  public foregroundIcon: string = '';

  public backgroundIcon?: string;

  public label: string = '';

  public sourceType: number = 0;

  public wants: Array<ShortcutWant> = [];
}

/**
 * ShortcutLimitInfo
 */
export class ShortcutLimitInfo {
  public bundleName: string = '';

  public maxNum: number = 0;
}

export enum ShortcutSourceType {
  CUSTOM_TYPE = 0,
  STATIC_TYPE = 1,
}

/**
 * 响应消息
 */
export class Response {
  public static readonly INVALID_METHOD_ERROR = 'invalid_method_error';

  public static readonly UNKNOWN_METHOD_ERROR = 'unknown_method_error';
}

/**
 * 快捷菜单校验结果
 */
export class CheckResult {
  // 快捷方式返回校验码
  public code: number = -1;
  // 应用快捷方式上限值
  public limit: number = SYSTEM_SHORTCUTS_LIMIT;
}

/**
 * 快捷菜单校验码
 */
export enum ResultCode {
  // 0：校验/添加成功
  SUCCESS = 0,
  // 1：校验/添加失败：入参不合法
  FAILED_INVALID_PARAMETERS = 1,
  // 2：校验/添加失败：快捷方式ID重复
  FAILED_DUPLICATE_ID = 2,
  // 3：校验/添加失败：快捷方式数量超上限
  FAILED_QUANTITY_LIMIT = 3,
  // 4: 云端2下禁止添加应用内快捷方式
  FAILED_ON_LIGHT_OUTDOOR_MODE = 4,
  // -1：校验/添加失败：其它原因，如BMS添加失败等
  FAILED_OTHER = -1,
}

export class BaseShortCutInfo {
  public typeId?: number;
  public startType?: number;
  public bundleName: string = ''
}