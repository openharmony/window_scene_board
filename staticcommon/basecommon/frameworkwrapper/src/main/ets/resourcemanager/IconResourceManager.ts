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
  DomainName,
  LogDomain,
  LogHelper,
  PixelMapUtil
} from '@ohos/basicutils';
import { EventConstants} from '../utils/EventManager';
import { localEventManager } from '../manager/LocalEventManager';
import { CheckEmptyUtils } from '@ohos/basicutils';
import IconInfo, { IconDatabaseColumn, IconPicType } from './IconInfo';
import bundleManager from '@ohos.bundle.bundleManager';
import commonBundleManager from '../manager/CommonBundleManager';
import { rdbStoreHelper } from '../service/db/RdbStoreHelper';
import rdb from '@ohos.data.relationalStore';
import RdbStoreConfig from '../service/db/RdbStoreConfig';
import { memoryCache } from './cache/MemoryCache';
import { dbCache } from './cache/DbCache';
import { CalendarCache } from './cache/CalendarCache';
import { IconCacheInterface } from './IconCacheInterface';
import { HashSet, List } from '@kit.ArkTS';
import { IconCacheFwkInterface } from './IconCacheFwkInterface';
import { image } from '@kit.ImageKit';
import { AppIconIdLoader } from './AppIconIdLoader';
import { TraceUtil } from '@ohos/basicutils';
import { bundleManagerFwk, BundleManagerFwk } from './fwk/BundleManagerFwk';
import HashMap from '@ohos.util.HashMap';
import { StartType, CompanionIconInfo } from '@ohos/basicutils';
import { SCBConstants, UpdateType } from '@ohos/commonconstants';
import { onLineThemeUtil } from '../utils/OnLineThemeUtil';
import { GraphicUtils } from '../resourcemanager/GraphicsUtils';
import { ResourceManager } from '../manager/ResourceManager';
import { IconExtendParam } from './IconExtendParam';
import { TaskInfo } from './TaskInfo';
import { IconTaskManager } from './IconTaskManager';
import { iconBorderCropper } from './TransparentBorderIconCropper';
import { ResourceManagerFwk } from './fwk/ResourceManagerFwk';

const TAG = 'IconResourceManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);
const DEFAULT_MAX_SIZE = 100;
// 三级缓存图片名称前缀
const DFX_PREFIX: string = 'IRM';
const MAX_DFX_BUNDLE_LEN = 10;

export class IconResourceManager {
  private static sInstance: IconResourceManager;
  private cacheFactory: List<IconCacheInterface> = new List();
  private fwkFactory: IconCacheFwkInterface;
  private iconIdLoaderCache: AppIconIdLoader;
  private calendarCache: CalendarCache;
  private checkAppVersionMap: HashMap<string, string>;
  private deletingIcons: HashSet<string>;
  //需要获取ability icon的iconInfo列表
  private requiresIconAbilities: HashSet<string>;
  private lastClearAppResourceCacheTag: string = 'None';

  constructor() {
    this.checkAppVersionMap = new HashMap();
    this.requiresIconAbilities = new HashSet();
    this.deletingIcons = new HashSet();
    iconBorderCropper.loadTransparentBorderIconAppCfg();
  }

  static getInstance(): IconResourceManager {
    if (!IconResourceManager.sInstance) {
      IconResourceManager.sInstance = new IconResourceManager();
    }
    return IconResourceManager.sInstance;
  }

  public setAppIconIdLoader(appIconIdLoader: AppIconIdLoader): void {
    if (this.fwkFactory) {
      this.fwkFactory.setAppIconIdLoader(appIconIdLoader);
    } else {
      log.showWarn(`setAppIconIdLoader fwkFactory is null`);
      this.iconIdLoaderCache = appIconIdLoader;
    }
  }

  public initCacheList(cacheFactory: List<IconCacheInterface>, fwkFactory: IconCacheFwkInterface): void {
    TraceUtil.startTrace(DomainName.SCB, 'IconResourceManager');
    this.cacheFactory = cacheFactory;
    this.fwkFactory = fwkFactory;
    if (this.fwkFactory) {
      this.fwkFactory.refreshMaskImage();
      if (this.iconIdLoaderCache) {
        this.fwkFactory.setAppIconIdLoader(this.iconIdLoaderCache);
      }
    }
    TraceUtil.endTrace(DomainName.SCB, 'IconResourceManager');
  }

  /**
   * 三级缓存获取融合图标资源
   *
   * @param bundleName 包名
   * @param moduleName 模块名
   * @param abilityName ability名
   * @param param 扩展参数
   *
   * @returns 融合图标资源
   */
  public async getCombineIcon(bundleName: string, moduleName: string, abilityName: string,
    param: IconExtendParam): Promise<image.PixelMap> {
    log.showInfo(`getCombIcon, bundleName: ${bundleName}, ${moduleName}, ` +
      `${abilityName}, ${param.appIndex}, ${param.iconName}, ${param.hasBorder}`);
    let combIcon: image.PixelMap = undefined;
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return combIcon;
    }
    // SystemUI 图标带描边，日历图标不取动态图标
    if (!param.hasBorder && this.calendarCache?.checkIsDynamicCalendarIcon(bundleName)) {
      let image = this.calendarCache?.getCalendarImageSyncWithoutCheck();
      if (CheckEmptyUtils.isEmptyPixelMap(image)) {
        image = await this.calendarCache?.getCalendarImage(bundleName);
      }
      log.showInfo(`get calendar image. image is empty: ${CheckEmptyUtils.isEmptyPixelMap(image)}`);
      PixelMapUtil.addName(image, this.dfxPixelMapName(bundleName, param.iconName ?? 'CombIcon_calender'));
      return image;
    }
    // 对于删除中的应用，图标直接从包管理获取
    if (this.deletingIcons.has(bundleName)) {
      log.showWarn(`deleting icon, bundleName: ${bundleName}`);
      let result = await this.getAppIconDirectly(param, bundleName, moduleName, abilityName, true);
      PixelMapUtil.addName(result, this.dfxPixelMapName(bundleName, param.iconName ?? 'getCombIcon_delete'));
      return result;
    }

    // 从memory和DB中获取缓存图标
    for (let index = 0; index < this.cacheFactory.length; index++) {
      let iconInfoCache: IconInfo = await this.cacheFactory[index].getCombIcon(bundleName, moduleName, abilityName,
        param);
      if (!CheckEmptyUtils.isEmptyPixelMap(iconInfoCache?.combinePicSrc)) {
        let needWait = this.needWaitCheckAppVersion(iconInfoCache?.appVersion, this.checkAppVersionMap.get(bundleName));
        if (needWait) {
          log.showWarn(`getCombIcon need wait, bundleName: ${bundleName}, ${moduleName}, ${abilityName}, index: ${index}`);
          continue;
        }
        for (let j = 0; j < index; j++) {
          this.cacheFactory[j].setIconResource(bundleName, moduleName, abilityName, iconInfoCache, param.appIndex,
            param.hasBorder);
        }
        log.showWarn(`combIcon is empty: ${CheckEmptyUtils.isEmptyPixelMap(iconInfoCache.combinePicSrc)}, bundleName: ${bundleName}`);
        let result = iconInfoCache.combinePicSrc;
        PixelMapUtil.addName(result, this.dfxPixelMapName(bundleName, param.iconName ?? 'getCombIcon_memCache'));
        return result;
      }
    }

    let result = await this.getAppIconDirectly(param, bundleName, moduleName, abilityName, false);
    PixelMapUtil.addName(result, this.dfxPixelMapName(bundleName, param.iconName ?? 'getCombIcon_direct'));
    return result;
  }

  /**
   * 三级缓存获取融合图标资源，
   * @deprecated 后续从三级缓存获取融合图标使用getCombineIcon接口
   */
  public async getCombIcon(bundleName: string, moduleName?: string, abilityName?: string,
    appIndex?: number, iconName?: string, isTemplatedIcon?: boolean): Promise<image.PixelMap> {
    let param = new IconExtendParam();
    param.appIndex = appIndex ?? 0;
    param.iconName = iconName;
    param.bundleName = isTemplatedIcon ? bundleName + SCBConstants.BUNDLENAME_APPEND_TEMPLATE : bundleName;
    param.hasBorder = false;
    param.isTransparentBorder = isTemplatedIcon && iconBorderCropper.isTransparentBorderIcon(bundleName);
    return this.getCombineIcon(bundleName, moduleName, abilityName, param);
  }

  private async getAppIconDirectly(param: IconExtendParam, bundleName: string, moduleName?: string,
    abilityName?: string, deletingIcon: boolean = false): Promise<image.PixelMap> {
    let iconInfo: IconInfo = await this.getAppIconInfo(param, bundleName, moduleName, abilityName);
    // 若是当前应用图标正在执行删除逻辑，则查询后不放入缓存
    if (!deletingIcon) {
      this.setIconResourceCache(bundleName, moduleName, abilityName, iconInfo, param);
    }
    const combinePicLength = iconInfo?.combinePic?.length;
    log.showWarn(`combinePicSrc is empty: ${CheckEmptyUtils.isEmptyPixelMap(iconInfo?.combinePicSrc)}, bundleName: ` +
      `${bundleName}, combinePicLength:${combinePicLength}, lastClearAppResourceCacheTag:${this.lastClearAppResourceCacheTag}`);
    return iconInfo?.combinePicSrc;
  }

  private async getAppIconInfo(param: IconExtendParam, bundleName: string, moduleName?: string,
    abilityName?: string): Promise<IconInfo> {
    let iconInfo: IconInfo = null;
    if (this.requiresIconAbilities.has(bundleName + moduleName + abilityName)) {
      param.isNeedAbilityIcon = true;
      iconInfo =
        await ResourceManagerFwk.getInstance().getIconResourceFromFwk(param, bundleName, moduleName, abilityName);
      iconInfo.combinePicSrc =
        await BundleManagerFwk.getInstance().getHdsIcon(bundleName + '_' + abilityName + '_requiresIconAbility',
          iconInfo.combinePicSrc);
    } else {
      iconInfo = await this.fwkFactory.getIconResourceFromFwk(param, bundleName, moduleName, abilityName);
    }
    PixelMapUtil.addName(iconInfo.combinePicSrc, this.dfxPixelMapName(bundleName, 'getAppIconInfo'));
    // 切换主题
    if (CheckEmptyUtils.isEmpty(iconInfo?.combinePic)) {
      log.showWarn(`getDeliverAppIconCache combinePic is empty bundleName = ${bundleName}`);
      return new IconInfo();
    }
  }

  private needGetPicAgain(iconInfo: IconInfo, moduleName: string, abilityName: string): boolean {
    return CheckEmptyUtils.checkStrIsEmpty(iconInfo?.combinePic) && !CheckEmptyUtils.checkStrIsEmpty(moduleName) &&
      !CheckEmptyUtils.checkStrIsEmpty(abilityName);
  }

  /**
   * 获取内存缓存中的融合图标资源，只适用与桌面图标（不带描边）
   */
  public getCachedCombIconSync(bundleName: string, moduleName: string, abilityName: string, appIndex?: number,
    iconName?: string): image.PixelMap {
    log.showInfo(`getCachedCombIconSync, bundleName: ${bundleName}, ${moduleName}, ${abilityName}, ${appIndex}, ${iconName}`);
    let combIcon: image.PixelMap = undefined;
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('getCachedCombIconSync bundleName is empty');
      return combIcon;
    }
    let image = this.calendarCache?.getCalendarImageSync(bundleName);
    if (image) {
      log.showInfo('get calendar image');
      PixelMapUtil.addName(image, 'calendar_getCachedCombIconSync');
      return image;
    }
    combIcon = memoryCache.getCombIconSync(bundleName, moduleName, abilityName, appIndex);
    log.showWarn(`getCachedCombIconSync combIcon is empty: ${CheckEmptyUtils.isEmptyPixelMap(combIcon)}, bundleName: ${bundleName}`);
    PixelMapUtil.addName(combIcon, this.dfxPixelMapName(bundleName, 'cachedCombIconSync'));
    return combIcon;
  }

  /**
   * 三级缓存获取图标资源，包括融合图标，前景图，背景图和图标类型。
   */
  public async getIconResource(bundleName: string, moduleName: string, abilityName: string): Promise<IconInfo> {
    log.showInfo(`getIconResource, bundleName: ${bundleName}, ${moduleName}, ${abilityName}`);
    let resultInfo: IconInfo = new IconInfo();
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return resultInfo;
    }
    resultInfo = await dbCache.getIconResource(bundleName, moduleName, abilityName);
    const combinePicLength = resultInfo?.combinePic?.length;
    const foregroundLength = resultInfo?.adaptivePic[1]?.length;
    const backgroundLength = resultInfo?.adaptivePic[0]?.length;
    log.showWarn(`getIconResource bundleName: ${bundleName}, resultInfo.iconType = ${resultInfo?.iconType}, ` +
      `combinePicLength:${combinePicLength}, foregroundLength:${foregroundLength}, backgroundLength:${backgroundLength}`);
    this.setCachedIconPicType(bundleName, moduleName, abilityName, resultInfo);
    if (resultInfo?.iconType !== IconPicType.NORMAL && CheckEmptyUtils.isEmpty(resultInfo?.adaptivePic[0])) {
      let param: IconExtendParam = new IconExtendParam();
      resultInfo = await this.fwkFactory.getIconResourceFromFwk(param, bundleName, moduleName, abilityName);
      this.setIconResourceCache(bundleName, moduleName, abilityName, resultInfo, param);
    }
    PixelMapUtil.addName(resultInfo.combinePicSrc, this.dfxPixelMapName(bundleName, 'getIconResource'));
    return resultInfo;
  }

  /**
   * 临时提供给pc使用,获取图标资源，包括融合图标，前景图，背景图和图标类型。
   */
  public async getIconResourceBySize(bundleName: string, moduleName: string, abilityName: string, size: number):
    Promise<IconInfo> {
    let resultInfo: IconInfo = new IconInfo();
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      return resultInfo;
    }
    resultInfo = memoryCache.getIconResourceBySize(bundleName, moduleName, abilityName, size);
    const combPicLength = resultInfo?.combinePic?.length;
    const foregroundLength = resultInfo?.adaptivePic[1]?.length;
    const backgroundLength = resultInfo?.adaptivePic[0]?.length;

    let version: string = await this.getVersionByBundleName(bundleName);

    log.showInfo(`getIconResource bundleName: ${bundleName}, ${moduleName}, ${abilityName}, ${size} iconType = ` +
      `${resultInfo?.iconType}, combPicLength:${combPicLength}, foregroundLength:${foregroundLength}, ` +
      `backgroundLength:${backgroundLength}, version:${version}, cacheVersion: ${resultInfo?.appVersion}`);

    if (resultInfo?.iconType !== IconPicType.NORMAL && CheckEmptyUtils.isEmpty(resultInfo?.adaptivePic[0]) ||
      version !== resultInfo?.appVersion) {
      let param: IconExtendParam = new IconExtendParam();
      resultInfo = await this.fwkFactory.getIconResourceFromFwk(param, bundleName, moduleName, abilityName, size);
      resultInfo.appVersion = version;
      memoryCache.setIconResourceBySize(bundleName, moduleName, abilityName, size, resultInfo);
    }

    PixelMapUtil.addName(resultInfo.combinePicSrc, this.dfxPixelMapName(bundleName, 'getIconResource'));
    return resultInfo;
  }

  /**
   * 判断ota升级是否需要等待刷新缓存版本后再写入缓存
   * @param previousVersion ota升级前版本
   * @param currentVersion ota升级后版本
   * @returns true: 需要等待， false: 不需等待
   */
  private needWaitCheckAppVersion(previousVersion: string, currentVersion: string): boolean {
    if (CheckEmptyUtils.isEmpty(previousVersion) || CheckEmptyUtils.isEmpty(currentVersion)) {
      return false;
    }
    try {
      let previousVerSegment = previousVersion.split('.').map(x => Number(x));
      let currentVerSegment = currentVersion.split('.').map(x => Number(x));
      if (previousVerSegment.length !== currentVerSegment.length) {
        return false;
      }
      for (let i = 0; i < previousVerSegment.length; ++i) {
        if (previousVerSegment[i] < currentVerSegment[i]) {
          return true;
        }
        if (previousVerSegment[i] > currentVerSegment[i]) {
          return false;
        }
        continue;
      }
      return false;
    } catch (err) {
      log.showError(`compareAppVer error: ${err}, pre: ${previousVersion}, cur: ${currentVersion}`);
      return false;
    }
  }

  /**
   * 开机校验图标数据库缓存
   */
  public async checkSystemStateAndVersion(): Promise<void> {
    log.showInfo('checkSystemStateAndVersion start');
    // 批量查询应用版本信息
    let bundleList: bundleManager.BundleInfo[] = await commonBundleManager.getAllBundleList(undefined,
      bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
    try {
      const predicates = new rdb.RdbPredicates(RdbStoreConfig.iconInfo.tableName);
      predicates.equalTo(IconDatabaseColumn.COMBINE_PIC, '');
      const changeRows = await rdbStoreHelper.delete(predicates);
      log.showWarn(`checkSystemStateAndVersion, clear empty iconInfo data, length = ${changeRows}`);
    } catch (err) {
      log.error('checkSystemStateAndVersion, clear empty iconInfo data failed, error -> ', err);
    }

    let resultset = await rdbStoreHelper.querySql(`SELECT DISTINCT ${IconDatabaseColumn.BUNDLE_NAME},
      ${IconDatabaseColumn.APP_VERSION} FROM ${RdbStoreConfig.iconInfo.tableName}`);
    log.showInfo(`checkSystemStateAndVersion, icon_info table resultset length = ${resultset.rowCount}`);
    let isLast: boolean = resultset.goToFirstRow();
    let changeList: Array<string> = [];
    while (isLast) {
      let bundleName = resultset.getString(resultset.getColumnIndex(IconDatabaseColumn.BUNDLE_NAME));
      let dbAppVer = resultset.getString(resultset.getColumnIndex(IconDatabaseColumn.APP_VERSION));
      let bmsAppVer: string = '';
      let list: bundleManager.BundleInfo[] = bundleList.filter(bundle => bundle.name === bundleName);
      if (!CheckEmptyUtils.isEmptyArr(list)) {
        bmsAppVer = list[0].versionName;
      }
      log.showInfo('checkSystemStateAndVersion bundle %{public}s, %{public}s,%{public}s', bundleName, dbAppVer, bmsAppVer);
      if (dbAppVer !== bmsAppVer) {
        log.showWarn(`dbAppVer is not same as bmsAppVer, clear iconInfo, bundleName = ${bundleName}`);
        this.checkAppVersionMap.set(bundleName, bmsAppVer);
        await this.deleteIconResource(bundleName);
        // 系统应用更新需要刷新小文件夹截图
        changeList.push(bundleName);
      }
      isLast = resultset.goToNextRow();
    }
    localEventManager.sendLocalEvent(EventConstants.EVENT_REFRESH_SMALL_FOLDER_IMAGE, changeList);
    localEventManager.sendLocalEvent(EventConstants.EVENT_REFRESH_ICON_IMAGE, changeList);
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_ICON_RESOURCE_REFRESH, {
      type: UpdateType.UPDATE,
      bundleNames: changeList
    });
    resultset.close();
    log.showInfo('checkSystemStateAndVersion end');
  }

/**
 * 清理所有图标缓存
 *
 * @param tag 清理图标缓存的来源(不要写一样的tag)
 */
  public async clearAppResourceCache(tag: string): Promise<void> {
    log.showWarn(`${tag}, clearAppResourceCache start`);
    if (!this.cacheFactory) {
      log.showWarn('clearAppResourceCache, cacheFactory is invalid');
      return;
    }
    // 优先清理下层缓存, 防止下层缓存污染上层缓存
    for (let index = this.cacheFactory.length - 1; index >= 0; index--) {
      await this.cacheFactory[index].deleteAllCache();
    }
    if (this.fwkFactory) {
      this.fwkFactory.refreshMaskImage();
    }
    this.lastClearAppResourceCacheTag = tag;
    log.showWarn(`${tag}, clearAppResourceCache end`);
  }

  /**
   * 清理内存中的图标缓存
   *
   * @param tag 清理图标缓存的来源(不要写一样的tag)
   */
  public async clearCachedIconFromMemoryCache(tag: string): Promise<void> {
    log.showWarn(`${tag}, clearCachedIconFromMemoryCache start`);
    await memoryCache.deleteAllCache();
    this.lastClearAppResourceCacheTag = tag;
    log.showWarn(`${tag}, clearCachedIconFromMemoryCache end`);
  }

  /**
   * 清理单个图标缓存
   */
  public async deleteIconResource(bundleName, type: UpdateType = UpdateType.NONE, appIndex?: number): Promise<void> {
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('deleteIconResourceByBundle, bundleName is empty');
      return;
    }
    if (!this.cacheFactory) {
      log.showWarn('deleteIconResourceByBundle, cacheFactory is invalid');
      return;
    }
    log.showWarn(`deleteIconResourceByBundle, bundleName:${bundleName}`);
    this.deletingIcons.add(bundleName);

    // 优先清理下层缓存, 防止下层缓存污染上层缓存
    for (let index = this.cacheFactory.length - 1; index >= 0; index--) {
      await this.cacheFactory[index].deleteCache(bundleName);
    }
    log.showWarn(`deletingIcons remove, bundleName:${bundleName}`);
    this.deletingIcons.remove(bundleName);

    if (type !== UpdateType.NONE && !appIndex) {
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_ICON_RESOURCE_REFRESH, {
        type: type,
        bundleNames: [bundleName]
      });
    }
  }

  private async getVersionByBundleName(bundleName:string): Promise<string> {
    let bundleInfo: bundleManager.BundleInfo = await commonBundleManager.getBundleInfoByBundleName(bundleName);
    return bundleInfo?.versionName;
  }

  /**
   * 存储图标资源信息到缓存
   */
  public setIconResourceCache(bundleName: string, moduleName: string, abilityName: string, iconInfo: IconInfo,
    param: IconExtendParam = new IconExtendParam()): void {
    if (iconInfo === null || iconInfo.combinePic === null || iconInfo.combinePic === undefined || iconInfo.combinePic === '') {
      log.showWarn(`setIconResourceCache, iconInfo is empty, bundleName = ${bundleName}`);
      return;
    }
    for (let cache of this.cacheFactory) {
      cache.setIconResource(bundleName, moduleName, abilityName, iconInfo, param);
    }
  }

  /**
   * 获取内存缓存中的应用名称
   *  @deprecated 6.0开始使用getAppNameByCache
   */
  public getCachedIconNameSync(bundleName: string, moduleName: string, abilityName: string, appIndex?: number): string {
    return memoryCache.getIconNameSync(bundleName, moduleName, abilityName, appIndex);
  }

  /**
   * 通过labelId、bundleName、moduleName获取appName
   */
  public async getAppName(labelId: number, bundleName: string, moduleName: string, appName: string,
    appIndex?: number): Promise<string> {
    try {
      if (!labelId) {
        log.showWarn(`getAppName labelId is invalid, labelId:${labelId}, appName:${appName}`);
        return appName;
      }
      let name = memoryCache.getAppName(labelId, bundleName, moduleName);
      if (!CheckEmptyUtils.checkStrIsEmpty(name)) {
        log.showInfo(`getAppName from cache params:${labelId},${bundleName},${moduleName},${appName},${appIndex}, cached name is ${name}`);
        return `${name}${appIndex > 0 ? appIndex : ''}`;
      }
      name = await ResourceManager.getInstance().getAppName(labelId, bundleName, moduleName);
      if (!CheckEmptyUtils.checkStrIsEmpty(name)) {
        log.showInfo(`getAppName from resourceManager params:${labelId},${bundleName},${moduleName},${appName},${appIndex}, name is ${name}`);
        memoryCache.setAppName(labelId, bundleName, moduleName, name);
        return `${name}${appIndex > 0 ? appIndex : ''}`;
      }
    } catch (e) {
      log.showError(`get appName error ${e}`);
    }
    log.showInfo(`getAppName failed. params:${labelId},${bundleName},${moduleName},${appName},${appIndex}`);
    return appName;
  }

  /**
   * 更新名称缓存
   */
  public async updateAppNameSync(labelId: number, bundleName: string, moduleName: string, defaultAppName: string,
    appIndex?: number): Promise<string> {
    if (!labelId) {
      log.showWarn(`labelId is invalid. update app name failed`);
      return defaultAppName;
    }
    // 先清空缓存，再从资源管理重新加载
    memoryCache.setAppName(labelId, bundleName, moduleName, '');
    return await this.getAppName(labelId, bundleName, moduleName, defaultAppName, appIndex);
  }

  /**
   * 获取应用名称并执行回调
   */
  public getAppNameWithCallback(labelId: number, bundleName: string, moduleName: string, appName: string, callback?,
    appIndex?: number): void {
    if (!labelId) {
      log.showWarn(`getAppNameWithCallback labelId is invalid, appName:${appName}, bundleName:${bundleName}`);
      callback(appName);
      return;
    }
    const cachedAppName = memoryCache.getAppName(labelId, bundleName, moduleName);
    if (CheckEmptyUtils.isEmpty(cachedAppName)) {
      ResourceManager.getInstance().getAppName(labelId, bundleName, moduleName).then((name) => {
        if (CheckEmptyUtils.checkStrIsEmpty(name)) {
          log.showWarn(`getAppNameWithCallback appName is empty from ResourceManager, labelId:${labelId}`);
          callback(appName);
        } else {
          memoryCache.setAppName(labelId, bundleName, moduleName, name);
          callback(`${name}${appIndex > 0 ? appIndex : ''}`);
        }
      });
    } else {
      log.showInfo(`getAppNameWithCallback success from memoryCache, cachedAppName:${cachedAppName}, params:${bundleName},${moduleName},${labelId}`);
      callback(`${cachedAppName}${appIndex > 0 ? appIndex : ''}`);
    }
  }

  /**
   * 直接从缓存中获取应用名称
   */
  public getAppNameByCache(labelId: number, bundleName: string, moduleName: string, appName: string,
    appIndex?: number): string {
    let name = memoryCache.getAppName(labelId, bundleName, moduleName);
    log.showInfo(`getAppNameByCache params:${labelId},${bundleName},${moduleName},${appName},${appIndex}, name is ${name}`);
    return CheckEmptyUtils.checkStrIsEmpty(name) ? appName : `${name}${appIndex > 0 ? appIndex : ''}`;
  }

  public getAppNameCacheKey(labelId: number, bundleName: string, moduleName: string): string {
    return memoryCache.getAppNameCacheKey(labelId, bundleName, moduleName);
  }

  public setAppNameCacheByCacheKey(cacheKey: string, appName: string): void {
    log.showWarn(`setAppNameCacheByCacheKey cacheKey: ${cacheKey}, appName ${appName}`);
    if (CheckEmptyUtils.checkStrIsEmpty(appName) || CheckEmptyUtils.checkStrIsEmpty(cacheKey)) {
      log.showWarn('cacheKey or appName is empty, set name cache fail.');
      return;
    }
    memoryCache.setAppNameCacheByCacheKey(cacheKey, appName);
  }

  public setAppNameCache(labelId: number, bundleName: string, moduleName: string, appName: string): void {
    if (!labelId || !appName) {
      log.showWarn(`setAppNameCache labelId or appName is invalid, labelId:${labelId}, appName:${appName}`);
      return;
    }
    memoryCache.setAppName(labelId, bundleName, moduleName, appName);
  }

  /**
   * 批量获取图标资源base64
   *
   * @param bundleList bundleName列表
   *
   * @returns 返回bundleName和图标base64键值对
   */
  public async getIconBase64Batch(bundleList: Array<string>):
      Promise<HashMap<string, string>> {
    if (CheckEmptyUtils.isEmptyArr(bundleList)) {
      log.showWarn(`bundleList is emptyArr`);
      return new HashMap();
    }
    if (bundleList.length > DEFAULT_MAX_SIZE) {
      log.showWarn(`bundleList is too large`);
    }
    // 先从DB获取图标
    let result: HashMap<string, string> = await dbCache.getIconByBundles(bundleList, false);
    if (result.length === bundleList.length) {
      return result;
    }

    // DB中获取不到的，从BMS获取
    let taskInfos: TaskInfo[] = [];
    bundleList.forEach(bundle => {
      if (!CheckEmptyUtils.checkStrIsEmpty(result.get(bundle))) {
        return;
      }
      let param: IconExtendParam = new IconExtendParam();
      param.hasBorder = true;
      param.bundleName = bundle;
      let taskInfo: TaskInfo = new TaskInfo(bundle, '', '', param);
      taskInfos.push(taskInfo);
    });
    let iconInfos: IconInfo[] = [];
    let tasks = IconTaskManager.spliceTask(taskInfos);
    await Promise.all(tasks.map(async task => {
      while (task.length > 0) {
        let childTask = task.splice(0, 10);
        let temp = await bundleManagerFwk.getIconResourceFromFwkBatch(childTask);
        iconInfos.push(...temp);
      }
    }));
    // 只缓存DB，不缓存内存，避免占用常驻内存
    for (let iconInfo of iconInfos) {
      result.set(iconInfo.bundleName, iconInfo.combinePic);
      // pixelMap无需缓存，及时释放
      iconInfo.combinePicSrc?.release();
    }
    dbCache.setIconResourceBatch(iconInfos);
    return result;
  }

  public async refreshIconResourceBatch(tasks: TaskInfo[]): Promise<void> {
    log.showWarn(`refreshIconResourceBatch start task length ${tasks.length}`);
    let iconInfos: IconInfo[] = await bundleManagerFwk.getIconResourceFromFwkBatch(tasks);
    await memoryCache.setIconResourceArray(iconInfos);
    dbCache.setIconResourceBatch(iconInfos);
    log.showWarn(`refreshIconResourceBatch end`);
  }

  /**
   * 根据bundleName获取内存缓存中的应用名称
   */
  public getCachedIconNameByBundleNameSync(bundleName: string): string {
    return memoryCache.getIconNameByBundleNameSync(bundleName);
  }

  /**
   * 存储应用名称信息到缓存
   */
  public setNameResourceCache(bundleName: string, moduleName: string, abilityName: string, appName: string, appIndex?: number):void {
    for (let cache of this.cacheFactory) {
      cache.setIconNameResource(bundleName, moduleName, abilityName, appName, appIndex);
    }
  }

  /**
   * 检测是否是双层图标
   *
   * @param companionIconInfo 图标信息
   * @returns true:双层图标 false:单层图标
   */
  public isAdaptiveIcon(companionIconInfo: CompanionIconInfo): boolean {
    if (!companionIconInfo) {
      log.showError('isAdaptiveIcon: companionIconInfo is empty');
      return true;
    }
    // 在线主题当前不支持分层图标动效；快捷图标当前不支持分层动效
    if (onLineThemeUtil.isOnlineTheme() || companionIconInfo.startAppType === StartType.SHORTCUT_APP) {
      log.showInfo(`isAdaptiveIcon: isOnlineTheme or shortcut app, bundleName ${companionIconInfo.bundleName}`);
      return false;
    }
    let iconPicType: IconPicType = this.getCachedIconPicTypeSync(companionIconInfo.bundleName, companionIconInfo.moduleName,
      companionIconInfo.abilityName);
    log.showInfo(`isAdaptiveIcon: bundleName ${companionIconInfo.bundleName}, isAdaptiveIcon ${iconPicType === IconPicType.ADAPTIVE}`);
    return iconPicType === IconPicType.ADAPTIVE;
  }

  /**
   * 获取内存缓存中的应用图标类型
   *
   * @param bundleName 应用包名
   * @param moduleName 模块名
   * @param abilityName Ability名称
   * @param appIndex appIndex
   * @returns 图标类型
   */
  public getCachedIconPicTypeSync(bundleName: string, moduleName: string, abilityName: string): IconPicType {
    return memoryCache.getCacheIconPicTypeSync(bundleName, moduleName, abilityName);
  }

  /**
   * 获取内存缓存中的应用图标类型
   *
   * @param bundleName 应用包名
   * @param moduleName 模块名
   * @param abilityName Ability名称
   * @param appIndex appIndex
   * @returns 图标类型
   */
  public setCachedIconPicType(bundleName: string, moduleName: string, abilityName: string,
    iconInfo: IconInfo): void {
    return memoryCache.setCacheIconPicTypeToMemory(bundleName, moduleName, abilityName, iconInfo);
  }

  /**
   * 清除所有appName缓存信息
   */
  public clearAllAppNameCache(): void {
    memoryCache.deleteAllNameCache();
  }

  /**
   * 检测应用name缓存是否为空
   * @returns
   */
  public isNameCacheEmpty(): boolean {
    return memoryCache.isNameCacheEmpty();
  }

  public initCalendarCache(cache: CalendarCache): void {
    this.calendarCache = cache;
  }

  /**
   * 添加需要获取图标的ability信息,解决预置应用默认从主题资源获取图标的问题
   *
   * @param bundleName 需要单独获取图标的bundleName
   * @param moduleName 需要单独获取图标的moduleName
   * @param abilityName 需要单独获取图标的abilityName
   * @param caller 调用方信息
   */
  public addRequiresIconAbility(bundleName: string, moduleName: string, abilityName: string, caller: string): void {
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmpty(moduleName) ||
    CheckEmptyUtils.isEmpty(abilityName)) {
      log.showWarn('addRequiresIconAbility bundleName or abilityName invalid return');
      return;
    }
    if (!this.requiresIconAbilities.has(bundleName + moduleName + abilityName)) {
      this.requiresIconAbilities.add(bundleName + moduleName + abilityName);
      log.showInfo(`addRequiresIconAbility:${bundleName}-${moduleName}-${abilityName} caller:${caller} success.`);
    }
  }

  /**
   * 拼接三级缓存图片名称: 三级缓存前缀 + 截断后的包名 + 外部调用tag
   * 包名缩减截断：A.B.C.D -> C.D, 超过10个字符上限后截断
   *
   * @param bundleName 包名
   * @param caller 外部调用方tag
   * @returns 图片名称, 总长超过31个字符后将无法打印完整, 因此包名只打印后10个字符, 剩余长度预留给外部调用tag
   */
  private dfxPixelMapName(bundleName: string, caller?: string): string {
    let bundleNameStrings: string[] = bundleName.split('.');
    let simpleBundleName: string = '';
    if (bundleNameStrings.length <= 2) {
      simpleBundleName = bundleName;
    } else {
      simpleBundleName =
        `${bundleNameStrings[bundleNameStrings.length - 2]}.${bundleNameStrings[bundleNameStrings.length - 1]}`;
    }
    return DFX_PREFIX + '_' + simpleBundleName.substring(0, MAX_DFX_BUNDLE_LEN) + '_' + caller;
  }
}