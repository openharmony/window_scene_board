/**
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import { AppItemInfo } from '../bean/AppItemInfo';
import {
  CheckEmptyUtils,
  CommonUtils,
  FileUtils,
  LogDomain,
  Logger,
} from '@ohos/basicutils';
import {
  GlobalContext,
  HiSysEventUtil,
  IconCacheInterface,
  memoryCache,
  AccountConstants,
  AccountMgr,
} from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { CardItemInfo } from '../bean/CardItemInfo';
import { AppStatus, CardCloneStatus, CommonConstants, LegacyInfo, SceneType } from '../constants/CommonConstants';
import { FormListInfoCacheManager } from '../cache/FormListInfoCacheManager';
import { launcherAbilityManager } from '../abilitymanager/LauncherAbilityManager';
import { BackupItemType } from '../model/BackupFavoriteInfo';
import SystemApplication from '../configs/SystemApplication';
import { CloneItemInfoManager } from './manager/CloneItemInfoManager';
import { BaseTransformItem } from './transfromitem/BaseTransformItem';
import type ctx from '@ohos.app.ability.common';
import type { CloneItemInfo } from '../constants/CommonConstants';
import bundleResourceManager from '@ohos.bundle.bundleResourceManager';
import {
  IconResourceManager
} from '@ohos/frameworkwrapper';
import { List } from '@kit.ArkTS';
import { DeliverUtil } from '../utils/DeliverUtil';
import { LogBatchPrint } from './dfx/LogBatchPrint';
import {
  AppReserveType,
  FormCommonUtil,
  FormModel,
  LauncherLayoutCacheUtil,
  NotHarmonyUtil,
  RdbStoreManager,
  UpdateRdbManager,
  ShortcutInfo,
  OhosSuperAdditionRelationManager,
  AppInstallUtils,
  GetHideAppsFromConfig,
  AutoMigrateType,
} from '../TsIndex';
import { FormRelationManager } from './FormRelationManager';
import { AddCardToNewPageManager } from './manager/AddCardToNewPageManager';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { ShortcutViewModel } from '../launchericon/viewmodel/ShortcutViewModel';
import { ShortcutTransformItem } from './transfromitem/ShortcutTransformItem';
import { IntentParseUtil } from '../utils/IntentParseUtil';
import { AbroadPackageInfo } from './PackageInfo';
import { ILegacyInfo } from './transfromitem/AppTransformItem';
import { RestoreLauncherDataManager } from '../manager/RestoreLauncherDataManager';
import { TransformAppInfoManager } from './TransformAppInfoManager';

/**
 * 应用包名白名单
 */
enum BundleName {
  HARMONY_V720_BUNDLENAME = 'com.naxclow.hw.v720',
  HARMONY_SDHOS_BUNDLENAME = 'com.citicsf.sdhos',
  HARMONY_YUEMIAO_BUNDLENAME = 'com.sinosoft.yuemiao',
}

/**
 * 应用设备包名白名单
 */
enum KeyName {
  WAIT_FOR_HARMONY_V720_KEYNAME = 'com.naxclow.v720',
  WAIT_FOR_HARMONY_SDHOS_KEYNAME = 'com.citicsf.sd',
  WAIT_FOR_HARMONY_YUEMIAO_KEYNAME = 'plus.H5A84F959',
}

const WHITELIST_MAP: Map<string, string> = new Map([
  [BundleName.HARMONY_V720_BUNDLENAME, KeyName.WAIT_FOR_HARMONY_V720_KEYNAME],
  [BundleName.HARMONY_SDHOS_BUNDLENAME, KeyName.WAIT_FOR_HARMONY_SDHOS_KEYNAME],
  [BundleName.HARMONY_YUEMIAO_BUNDLENAME, KeyName.WAIT_FOR_HARMONY_YUEMIAO_KEYNAME],
]);

const TAG = 'DataConvert';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const DEFAULT_USER_ID = 100;
const LAUNCHER_PHONE_MODULE = 'phone_sceneboard';
const LAUNCHER_FORM_ABILITY = 'SceneBoardFormAbility';
const EXCEPTION_ID_ZERO = '0';
const EXCEPTION_ID_NEGATIVE_ONE = '-1';
const UNICODE_NUMBER = 97;
const BMP = '.bmp';
const PNG = '.png';
const FILE_PRE = 'file://';
const PRINT_BATCH_NUMBER: number = 50;
const INTENT_COMPONENT_KEY: string = 'component';
const APP_AREA = [1, 1];
const ICONS_DIR: string = '/RestoreIconData/';
const TOTEMWEATHER_BUNDLENAME: string = 'com.ohos.totemweather';
const ONEMULFOUR_WEATHERCARD_NAME: string = 'OneMulFourClockCard';
const CLOCK_WEATHERCARD_NAME: string = 'ClockWeatherCard';

class DataConvert {
  private stubAppList: string[] = ['com.ohos.books'];
  // 当前UserId
  private curUserId: number = 0;
  // 新机应用列表
  private appItemInfoList: AppItemInfo[] = [];
  // 用于生成占位卡的时间戳
  private currentTime: number = new Date().getTime();
  // 旧机图标资源路径
  private oldIconPath: string = '';
  // 未找到图标的包名集合
  private notHaveIconPackageNames: string[] = [];
  // 克隆勾选的应用信息
  private restoreInfo: CloneItemInfo[] = [];
  // 去重后最终保留的卡片id
  private reservedCardIdList: string[] = [];
  // 新机已有的文件夹列表
  private folderListBeforeConvert: GridLayoutItemInfo[] = [];
  // 新机已有的应用列表
  private appListBeforeConvert: GridLayoutItemInfo[] = [];
  // 存放已有应用
  private existAppSet: Set<string> = new Set();
  // 克隆类型
  private backUpType: number = -1;
  // 未鸿蒙化多对一映射源应用（收入相应文件夹）
  private notHarmonyManyToOneAppList: string[] = [];
  // 用于上报打点事件
  private misAppNameArr: string[] = [];
  private lostAppNameArr: string[] = [];
  private appCount: number = 0;
  private misCardArr: string[] = [];
  private cardCount: number = 0;
  private misWidgetArr: string[] = [];
  private widgetCount: number = 0;
  private misShortCutArr: string[] = [];
  private shortcutList: ShortcutInfo[] = [];
  private defaultShortcut: string = '';
  private filesDir: string = '';

  /**
   * 系统迁移/系统迁移数据转换
   *
   * @param backupTransformItemList 旧机待恢复转换的元素列表
   * @param type 区别调用流程是系统迁移，还是系统迁移
   * @returns 数据转换后的元素列表
   */
  public async convertData(backupTransformItemList: BaseTransformItem [], type: string): Promise<GridLayoutItemInfo[]> {
    await this.preloadBeforeConvert(type);
    this.currentTime = new Date().getTime();
    let result: GridLayoutItemInfo[] = [];
    for (let transformItem of backupTransformItemList) {
      if (!transformItem.isSupportInohos()) {
        continue;
      }
      let gridLayoutItemInfo: GridLayoutItemInfo[];
      this.backUpType = SceneType.HWLAUNCHER_MIGRATE_ohos;
      gridLayoutItemInfo = await transformItem.transformBackupInfoToGridInfo(backupTransformItemList, type);
      if ((transformItem instanceof ShortcutTransformItem) && CheckEmptyUtils.isEmptyArr(gridLayoutItemInfo)) {
        let map: Map<string, string> = IntentParseUtil.parseIntent(transformItem.backupInfo.intent);
        if (map.has(INTENT_COMPONENT_KEY)) {
          this.saveMisShortCutArr(map.get(INTENT_COMPONENT_KEY) ?? '');
        }
        continue;
      }
      if (gridLayoutItemInfo && gridLayoutItemInfo.length > 0) {
        if (transformItem.backupInfo.itemType !== BackupItemType.BACKUP_ITEM_TYPE_APP) {
          result.push(...gridLayoutItemInfo);
          continue;
        }
        let bundleName: string = gridLayoutItemInfo[0].bundleName;
        let keyName: string = bundleName + (gridLayoutItemInfo[0].appIndex ?? 0);
        this.existAppSet.add(keyName);
        result.push(gridLayoutItemInfo[0]);
      }
    }
    await UpdateRdbManager.getInstance()
      .generateIconByBundleNamesAndUserId(this.notHaveIconPackageNames, this.curUserId);
    // deal with single-framework Unique application
    await this.dealWithSingleUniqueApp(result, this.existAppSet, this.appItemInfoList);
    this.addAppApp(result);
    // 处理追加卡片
    await AddCardToNewPageManager.getInstance().dealWithAddCard(result);
    this.reportHiSysEventAndClearCache();
    await FormRelationManager.getInstance().dealWithFormRelationInfo();
    await this.dealOhosSuperAdditionApps(result);
    return result;
  }

  /**
   * 处理系统特殊未鸿蒙化应用映射鸿蒙化应用
   *
   * @param backupInfoArr 待恢复列表
   * @returns
   */
  private async dealOhosSuperAdditionApps(backupInfoArr: GridLayoutItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(backupInfoArr)) {
      log.showWarn(TAG, 'dealOhosSuperAdditionApps backupInfoArr is empty');
      return;
    }
    let addInfoMap: Map<string, GridLayoutItemInfo> = new Map<string, GridLayoutItemInfo>();
    let ohosRelationManager: OhosSuperAdditionRelationManager = OhosSuperAdditionRelationManager.getInstance();
    for (let item of backupInfoArr) {
      if (item.container === CommonConstants.CONTAINER_UNIQUE_SINGLE) {
        continue;
      }
      if (item.typeId !== CommonConstants.TYPE_APP) {
        continue;
      }
      let targetName: string = ohosRelationManager.getTransInfoForPackageName(item.bundleName) ?? '';
      if (CheckEmptyUtils.isEmpty(targetName)) {
        continue;
      }
      log.showInfo(TAG, `dealOhosSuperAdditionApps bundleName ${item.bundleName}, targetName ${targetName}`);
      // 已经创建过映射的待恢复应用去比较位置，根据多对一场景排序算法将鸿蒙化应用替换在靠前的位置，并将被替换应用放入notHarmonyManyToOneAppList
      if (addInfoMap.has(targetName)) {
        if (this.checkNeedUpdateAddInfo(addInfoMap.get(targetName) as GridLayoutItemInfo, item)) {
          await this.buildHmSuperAdditionApp(item, targetName, addInfoMap);
        } else {
          this.notHarmonyManyToOneAppList.push(item.bundleName);
        }
      } else {
        let targetInfo = backupInfoArr.find(info => info.bundleName === targetName);
        if (CheckEmptyUtils.isEmpty(targetInfo)) {
          await this.buildHmSuperAdditionApp(item, targetName, addInfoMap);
        }
      }
    }
    log.showInfo(TAG, `dealOhosSuperAdditionApps addInfoMap size: ${addInfoMap.size}`);
    if (addInfoMap.size > 0) {
      addInfoMap.forEach((value, key) => backupInfoArr.push(value));
    }
    this.restoreInfo = [];
  }

  private async buildHmSuperAdditionApp(itemInfo: GridLayoutItemInfo, targetName: string,
    addInfoMap: Map<string, GridLayoutItemInfo>): Promise<void> {
    if (CheckEmptyUtils.isEmpty(itemInfo) || CheckEmptyUtils.isEmpty(targetName)) {
      log.showWarn(TAG, 'buildHmSuperAdditionApp itemInfo or targetName is empty');
      return;
    }
    let hmItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    ObjectCopyUtil.deepClone(itemInfo, hmItemInfo)
    hmItemInfo.bundleName = targetName;
    hmItemInfo.appStatus = AppStatus.WAITING;
    hmItemInfo.intent = '';
    hmItemInfo.abilityName = '';
    hmItemInfo.moduleName = '';
    if (CheckEmptyUtils.isEmpty(hmItemInfo.appName)) {
      let cloneItem: CloneItemInfo | undefined =
        this.getFindItemByRestoreData(itemInfo.bundleName, itemInfo.appIndex ?? 0)
      hmItemInfo.appName = cloneItem?.title;
      log.showWarn(TAG, `buildHmSuperAdditionApp hmItemInfo.appName ${hmItemInfo.appName}`);
    }
    if (CheckEmptyUtils.isEmpty(hmItemInfo.iconResource)) {
      hmItemInfo.iconResource =
        CommonConstants.SANDBOX_FILE_PREFIX + GlobalContext.getContext().filesDir +
          ICONS_DIR + itemInfo.bundleName + PNG;
      log.showInfo(TAG, `buildHmSuperAdditionApp targetName ${targetName}, iconResource ${hmItemInfo.iconResource}`);
    }
    let requestTaskRes: boolean;
    if (this.backUpType === SceneType.HWLAUNCHER_MIGRATE_ohos) {
      hmItemInfo.callerName = CommonConstants.SOURCE_UPGRADE;
      requestTaskRes = await AppInstallUtils.getInstance().requestTask(hmItemInfo);
    } else {
      hmItemInfo.callerName = CommonConstants.SOURCE_CLONE;
      requestTaskRes = await AppInstallUtils.getInstance().requestNoNetworkTask(hmItemInfo);
    }
    if (!requestTaskRes) {
      log.showWarn(TAG, `buildHmSuperAdditionApp broken, requestNoNetworkTask fail`);
      return;
    }
    addInfoMap.set(targetName, hmItemInfo);
    log.showInfo(TAG, `buildHmSuperAdditionApp targetName：${targetName}, hmItemInfo container: ${hmItemInfo.container},` +
      ` page: ${hmItemInfo.page}, row: ${hmItemInfo.row}, column: ${hmItemInfo.column}`);
    this.notHarmonyManyToOneAppList.push(itemInfo.bundleName);
  }

  private checkNeedUpdateAddInfo(a: GridLayoutItemInfo, b: GridLayoutItemInfo): boolean {
    //桌面平铺 > 文件夹
    if (a.container !== b.container && a.container !== undefined && b.container !== undefined) {
      // 工作区 > Dock区
      if (a.container < 0 && b.container < 0) {
        return b.container > a.container;
      }
      return a.container > b.container;
    }
    if (a.page !== b.page) {
      return (a.page ?? -1) > (b.page ?? -1);
    }
    if (a.row !== b.row) {
      return (a.row ?? 0) > (b.row ?? 0);
    }
    return (a.column ?? 0) > (b.column ?? 0);
  }

  private reportHiSysEventAndClearCache(): void {
    HiSysEventUtil.reportBackUpMismatchAppEventInfo(this.misAppNameArr.join(','),
      this.lostAppNameArr.join(','), this.appCount, (this.misAppNameArr.length + this.lostAppNameArr.length));
    HiSysEventUtil.reportBackUpMismatchCardEventInfo(this.misCardArr.join(','), this.cardCount, this.misCardArr.length,
      this.misWidgetArr.join(','), this.widgetCount, this.misWidgetArr.length);
    HiSysEventUtil.reportBackUpMismatchShortCutEventInfo(this.misShortCutArr.join(','), this.misShortCutArr.length);
    FormRelationManager.getInstance().clearFormRelationModel();
    this.appItemInfoList = [];
    this.misAppNameArr = [];
    this.lostAppNameArr = [];
    this.appCount = 0;
    this.misCardArr = [];
    this.cardCount = 0;
    this.misWidgetArr = [];
    this.widgetCount = 0;
    this.misShortCutArr = [];
    this.notHaveIconPackageNames = [];
  }

  private async preloadBeforeConvert(type: string): Promise<void> {
    this.oldIconPath =
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).filesDir + '/oldIcons/';
    this.appItemInfoList = [];
    let userId = await this.queryAndSaveCurUserId();
    this.appItemInfoList = await this.getAppListFromBMS(userId);
    FormListInfoCacheManager.getInstance().clearCache();
    await FormRelationManager.getInstance().loadFormRelation(type);
    await this.initIconNameCache();
    await this.initShortcutData();
  }

  /**
   * 克隆流程初始化快捷方式信息
   */
  public async initShortcutData(): Promise<void> {
    this.shortcutList = await ShortcutViewModel.getInstance().getAllDesktopShortcutFromBMS();
  }

  private async queryAndSaveCurUserId(): Promise<number> {
    if (!this.curUserId) {
      this.curUserId = await AccountMgr.getCurrentAccountId();
      if (this.curUserId === AccountConstants.INVALID_ID) {
        this.curUserId = DEFAULT_USER_ID;
      }
    }
    let uid: number = this.curUserId;
    log.showInfo(TAG, 'getCurrentUid %{public}d', uid);
    return this.curUserId;
  }

  /**
   * 从BMS全量查询一次已安装应用名称，初始化应用名称缓存信息
   */
  private async initIconNameCache(): Promise<void> {
    try {
      let cacheList: List<IconCacheInterface> = new List();
      cacheList.add(memoryCache);
      IconResourceManager.getInstance().initCacheList(cacheList, null);
      let abilityInfoList: bundleResourceManager.LauncherAbilityResourceInfo[] =
        await bundleResourceManager.getAllLauncherAbilityResourceInfo(bundleResourceManager.ResourceFlag.GET_RESOURCE_INFO_WITH_LABEL);
      abilityInfoList.forEach((info: bundleResourceManager.LauncherAbilityResourceInfo) => {
        if (!CheckEmptyUtils.checkStrIsEmpty(info.label)) {
          IconResourceManager.getInstance().setNameResourceCache(info.bundleName,
            info.moduleName, info.abilityName, info.label, info.appIndex);
        }
      });
      log.showInfo(TAG, `initIconNameCache abilityInfoList size ${abilityInfoList.length}`);
    } catch (err) {
      log.showError(TAG, 'initIconNameCache error ' + err);
    }
  }

  private async dealWithSingleUniqueApp(backupInfoArr: GridLayoutItemInfo[], existAppSet: Set<String>, appList: AppItemInfo[]): Promise<void> {
    let singleItemInfoList: AppItemInfo[] = [];
    this.folderListBeforeConvert = await RdbStoreManager.getInstance().queryGridLayoutByType(CommonConstants.TYPE_FOLDER);
    this.appListBeforeConvert = await RdbStoreManager.getInstance().queryGridLayoutByType(CommonConstants.TYPE_APP);
    appList.forEach(item => {
      let keyName: string = item.bundleName + (item.appIndex ?? 0);
      if (!existAppSet.has(keyName) && (item.typeId ?? 0) === CommonConstants.TYPE_APP) {
        singleItemInfoList.push(item);
        existAppSet.add(keyName);
      } else if (existAppSet.has(keyName) && (item.typeId ?? 0) === CommonConstants.TYPE_APP &&
        item.codePath === DeliverUtil.ohos_APPLICATION) {
        this.replaceTotalInstalledApp(keyName, backupInfoArr, singleItemInfoList, appList);
      }
    });
    let isSupportDeliver: boolean = DeliverUtil.isSupportDeliver();
    let singleItemObj: Object[] = [];
    singleItemInfoList.forEach(app => {
      if (isSupportDeliver && app.codePath === DeliverUtil.ohos_APPLICATION && this.isInContainerFolder(app.bundleName)) {
        let keyName: string = app.bundleName + (app.appIndex ?? 0);
        existAppSet.add(keyName);
        return;
      }
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.area = [1, 1];
      item.page = 0;
      item.column = 0;
      item.row = 0;
      item.bundleName = app.bundleName;
      item.keyName = app.keyName;
      item.abilityName = app.abilityName;
      item.moduleName = app.moduleName;
      item.typeId = CommonConstants.TYPE_APP;
      item.appIconId = app.appIconId;
      item.appLabelId = app.appLabelId;
      item.appIndex = app.appIndex;
      item.settlementPosition = this.getLocationOfUniqueItem(item);
      item.intent = this.getIntent(item);
      item.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
      backupInfoArr.push(item);
      singleItemObj.push({ keyName: item.keyName, settlementPosition: item.settlementPosition } as ISettlementInfo);
    });
    if (singleItemObj.length !== 0) {
      LogBatchPrint.printLogsInBatch(singleItemObj, PRINT_BATCH_NUMBER, 'deal with single unique app', TAG);
      singleItemObj = [];
    }
  }

  /**
   * 适配分享，克隆保留新机特有应用的intent信息
   *
   * @param item 构造的新机特有应用信息
   */
  private getIntent(item: GridLayoutItemInfo): string | undefined {
    let intent: string | undefined = item.intent;
    let itemKeyName: string = item.bundleName + (item?.appIndex ?? 0);
    for (let app of this.appListBeforeConvert) {
      if (app.appStatus !== AppStatus.INSTALLED) {
        continue;
      }
      let appKeyName: string = app.bundleName + (app?.appIndex ?? 0);
      if (appKeyName === itemKeyName) {
        intent = app.intent ?? item.intent;
        break;
      }
    }
    return intent;
  }

  /**
   * 克隆时保留设备独有的快捷方式
   *
   * @param backupInfoArr 克隆的应用列表
   * @param existShortcuts 克隆旧机的快捷方式
   */
  private async dealWithSingleUniqueShortcut(backupInfoArr: GridLayoutItemInfo[],
    existShortcuts: GridLayoutItemInfo[]): Promise<void> {
    try {
      let shortcutList: GridLayoutItemInfo[] = await RdbStoreManager.getInstance()
        .queryGridLayoutByType(CommonConstants.TYPE_SHORTCUT_ICON);
      shortcutList.forEach(shortcut => {
        if (this.isExitInShortcutList(backupInfoArr, shortcut)) {
          log.showWarn(TAG, `dealWithSingleUniqueShortcut old phone has same shortcut ${shortcut.bundleName} ${shortcut.shortcutId}`);
          return;
        }
        if (!this.isExitInShortcutList(existShortcuts, shortcut)) {
          shortcut.settlementPosition = this.getLocationOfUniqueItem(shortcut);
          shortcut.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
          shortcut.area = [1, 1];
          shortcut.page = 0;
          shortcut.column = 0;
          shortcut.row = 0;
          backupInfoArr.push(shortcut);
        }
      });
    } catch (err) {
      log.showError(TAG, 'dealWithSingleUniqueShortcut error %{public}s', err.message);
    }
  }

  private isExitInShortcutList(existShortcuts: GridLayoutItemInfo[], shortcut: GridLayoutItemInfo): boolean {
    if (!existShortcuts || existShortcuts.length === 0) {
      return false;
    }
    for (const existItem of existShortcuts) {
      if (LauncherLayoutCacheUtil.isSameShortcutApp(shortcut, existItem.bundleName, existItem.shortcutId ?? '',
        existItem.appIndex ?? 0)) {
        return true;
      }
    }
    return false;
  }

  private async dealWithInstalledCardAndStack(backupInfoArr: GridLayoutItemInfo[]): Promise<GridLayoutItemInfo[]> {
    log.showInfo(TAG, `dealWithInstalledForm start`);
    let backupItem: GridLayoutItemInfo[] = [];
    try {
      let installedAllCards: GridLayoutItemInfo[] =
        await RdbStoreManager.getInstance().queryGridLayoutByType(CommonConstants.TYPE_CARD);
      let installedCards: GridLayoutItemInfo[] = this.filterAbnormalCard(installedAllCards);
      // 如果新机无卡片直接返回
      if (CheckEmptyUtils.isEmptyArr(installedCards)) {
        log.showInfo(TAG, `installedCards is empty`);
        return backupItem;
      }
      let backupCards: GridLayoutItemInfo[] = this.getBackupCards(backupInfoArr);
      // 对所有卡片去重
      let duplicateCards: GridLayoutItemInfo[] = this.dealWithInstalledCard(installedCards, backupCards, backupItem);
      // 处理堆叠卡片
      await this.dealWithFormStack(duplicateCards, backupItem);
      // 清除缓存
      this.clearCatchOfCardFrame(installedAllCards, backupCards);
    } catch (error) {
      log.showInfo(TAG, `dealWithInstalledCardAndStack error ${error.message}`);
      this.reservedCardIdList = [];
      return [];
    }
    return backupItem;
  }

  private getBackupCards(infos: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let backupCards: GridLayoutItemInfo[] = infos.filter(item => item.typeId === CommonConstants.TYPE_CARD);
    let combineCards: GridLayoutItemInfo[] = infos.filter(item => item.typeId === CommonConstants.TYPE_FORM_COMBINE);
    // 如果旧机中含有组合卡片，则将组合卡片抽出放入备份卡片中
    if (!CheckEmptyUtils.isEmptyArr(combineCards)) {
      combineCards.forEach(combineItem => {
        if (combineItem?.layoutInfo) {
          backupCards.push(...combineItem.layoutInfo.flat());
        }
      });
    }
    return backupCards;
  }

  /**
   * 过滤并打印数据库卡片异常数据
   *
   * @param installedAllCards 新机已有卡片
   * @returns 过滤异常卡片后的卡片集合
   */
  public filterAbnormalCard(installedAllCards: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let installedCards: GridLayoutItemInfo[] = installedAllCards.filter(item => {
      if (CheckEmptyUtils.isEmpty(item?.cardId) || item.cardId === EXCEPTION_ID_ZERO ||
        item.cardId === EXCEPTION_ID_NEGATIVE_ONE) {
        log.showError(TAG, `abnormal card: cardId: ${item?.cardId}, cardId: ${item?.infoId}, page: ${item.page},` +
          ` column: ${item.column}, row: ${item.row}, cardName: ${item.cardName}`);
        return false;
      }
      return true;
    });
    return installedCards;
  }

  private async dealWithFormStack(duplicateCards: GridLayoutItemInfo[], backupItem: GridLayoutItemInfo[]): Promise<void> {
    if (CheckEmptyUtils.isEmptyArr(duplicateCards)) {
      return;
    }
    let formStack: GridLayoutItemInfo[] =
      await RdbStoreManager.getInstance().queryGridLayoutByType(CommonConstants.TYPE_FORM_STACK);
    formStack.forEach(item => {
      let cardsInStack: GridLayoutItemInfo[] = this.getCardFromStack(item, duplicateCards);
      if (CheckEmptyUtils.isEmptyArr(cardsInStack)) {
        return;
      }
      // 如果堆叠中只剩一张卡片则解散,将入已安装卡片集合中的该卡片container改为-102，插入集合中
      if (cardsInStack.length === 1) {
        cardsInStack[0].page = item.page;
        cardsInStack[0].row = item.row;
        cardsInStack[0].column = item.column;
        cardsInStack[0].container = item.container;
        cardsInStack[0].settlementPosition = this.getLocationOfUniqueItem(cardsInStack[0]);
        cardsInStack[0].container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
        backupItem.push(cardsInStack[0]);
        return;
      }
      this.initFormStackId(item);
      this.initFormStackIntent(item, cardsInStack);
      item.settlementPosition = this.getLocationOfUniqueItem(item);
      item.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
      backupItem.push(item);
    });
    log.showWarn(TAG, `dealWithFormStack backupItem length:${backupItem.length}`);
  }

  /**
   * 更新堆叠intent
   *
   * @param item 堆叠
   * @param cardsInStack 堆叠卡片子集
   */
  public initFormStackIntent(item: GridLayoutItemInfo, cardsInStack: GridLayoutItemInfo[]): void {
    if (item.intent) {
      FormCommonUtil.sortFormStack(item.intent, cardsInStack);
    }
    const intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
    intentMap.set('cardOrder', cardsInStack.map(item => item.cardId));
    const intendStr = CommonUtils.mapToJsonStr(intentMap);
    log.showWarn(TAG, `initFormStackIntent formStackId: ${item.formStackId} intendStr: ${intendStr}`);
    item.layoutInfo = [cardsInStack];
    item.intent = intendStr;
  }

  /**
   * 更新新机特有的堆叠infoid, 防止与旧机的infoid重复
   *
   * @param item 新机特有堆叠
   */
  private initFormStackId(item: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.checkStrIsEmpty(item.formStackId)) {
      return;
    }
    let splitIdex = item.formStackId?.indexOf('-') ?? -1;
    if (splitIdex !== -1) {
      item.formStackId = item.formStackId?.slice(0, splitIdex) + '-' + this.incCurrentTime();
      item.infoId = item.formStackId;
      return;
    }
    item.formStackId = item.formStackId + '-' + this.incCurrentTime();
    item.infoId = item.formStackId;
  }

  /**
   * 返回待保留堆叠卡片集合
   *
   * @param installedCards 新机当前已安装的卡片
   * @param backupCards 旧机需克隆的卡片集合
   * @param backupItem  待插入恢复列表的卡片集合
   * @returns 堆叠中的卡片集合
   */
  private dealWithInstalledCard(installedCards: GridLayoutItemInfo[],
    backupCards: GridLayoutItemInfo[], backupItem: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let duplicateInstalledStack: GridLayoutItemInfo[] = [];
    let duplicateInstalledCards = this.deleteDuplicateCards(installedCards, backupCards);
    log.showWarn(TAG, `dealWithInstalledCard installedCards length:${duplicateInstalledCards.length}`);
    if (CheckEmptyUtils.isEmptyArr(duplicateInstalledCards)) {
      log.showWarn(TAG, `duplicated installedCards is empty`);
    } else {
      duplicateInstalledCards.forEach(cardItem => {
        log.showWarn(TAG, `the card has been installed on the new phone: cardId: ${cardItem.cardId}, page: ${cardItem.page}, ` +
          `column: ${cardItem.column}, row:${cardItem.row},cardName:${cardItem.cardName}`);
        if (cardItem.cardId !== undefined) {
          this.reservedCardIdList.push(cardItem.cardId);
        }
        if (cardItem?.container === CommonConstants.CONTAINER_DESKTOP) {
          cardItem.settlementPosition = this.getLocationOfUniqueItem(cardItem);
          cardItem.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
          cardItem.page = 0;
          cardItem.column = 0;
          cardItem.row = 0;
          backupItem.push(cardItem);
        } else {
          duplicateInstalledStack.push(cardItem);
        }
      });
    }
    return duplicateInstalledStack;
  }

  /**
   * 单窗口单屏数据转换
   *
   * @param layoutItems 旧机布局数据库所有元素
   * @param restoreInfoMap 克隆勾选应用信息
   * @param appList 新机桌面应用
   * @param isOuter 是否为外屏
   * @returns 数据转换后的元素列表
   */
  public async filterAppAndCardNotInstallation(layoutItems: GridLayoutItemInfo[], restoreInfoMap: Map<string, Array<string>>,
    appList: AppItemInfo[], isOuter?: boolean, backupFromPc: boolean = false): Promise<GridLayoutItemInfo[]> {
    this.backUpType = SceneType.FROM_SCENE_BOARD;
    if (CheckEmptyUtils.isEmptyArr(layoutItems) || CheckEmptyUtils.isEmptyArr(appList) || CheckEmptyUtils.isEmpty(restoreInfoMap)) {
      log.showError(TAG, 'the restore app list is empty');
      return [];
    }
    await this.initIconNameCache();
    this.currentTime = new Date().getTime();
    let systemApplicationName: string[] = SystemApplication.systemApplicationName.split(',');
    let appKeyNameList: string[] =
      appList.filter(app => systemApplicationName.indexOf(app.bundleName) === CommonConstants.INVALID_VALUE)
        .map(app => app.bundleName + (app?.appIndex ?? 0));
    let resultItemList: GridLayoutItemInfo[] = [];
    // 用于系统克隆占位卡片获取appName
    this.restoreInfo = await CloneItemInfoManager.getInstance().queryRestoreLauncherData();
    let existAppName: Set<String> = new Set();
    let existShortcuts: GridLayoutItemInfo[] = [];
    let existBundleName: Set<String> = new Set();
    appList.forEach((app: AppItemInfo) => {existBundleName.add(app.bundleName);})
    for (let layoutItem of layoutItems) {
      let keyName: string = layoutItem.bundleName + (layoutItem?.appIndex ?? 0);
      let waitForHarmonyValue: Array<string> =
        this.getWaitForHarmonyValue(layoutItem.bundleName, layoutItem?.appIndex, restoreInfoMap);
      if (layoutItem.typeId === CommonConstants.TYPE_APP && appKeyNameList.indexOf(keyName) === CommonConstants.INVALID_VALUE &&
        !restoreInfoMap.has(keyName) && waitForHarmonyValue.length === 0) {
        log.showInfo(TAG, `the app bundlename : ${layoutItem.bundleName} is not installed`);
        continue;
      }
      if (layoutItem.typeId === CommonConstants.TYPE_CARD) {
        const status: number = await FormModel.getInstance().getCardCloneStatus(layoutItem, existBundleName);
        let cloneItem: CloneItemInfo | undefined =
          this.getFindItemByRestoreData(layoutItem.bundleName, layoutItem?.appIndex ?? 0);
        if (status === CardCloneStatus.ABNORMAL_WITHOUT_APP && cloneItem) {
          log.showWarn(TAG, `the card of bundlename : ${layoutItem.bundleName} is not installed`);
          let relationCardItems: CardItemInfo[] =
            FormRelationManager.getInstance().getSceneBoardFormRelationByBundleName(layoutItem.bundleName);
          let placeholderCard: CardItemInfo = this.convertToCardItemInfo(layoutItem, cloneItem);
          relationCardItems.push(placeholderCard);
          FormRelationManager.getInstance().setSceneBoardFormRelation(layoutItem.bundleName, relationCardItems);
          resultItemList.push(this.convertToDefaultCard(layoutItem, placeholderCard));
          continue;
        } else if (status === CardCloneStatus.ABNORMAL_WITHOUT_CARD ||
          status === CardCloneStatus.ABNORMAL_WITHOUT_APP) {
          log.showWarn(TAG, `the app ${layoutItem.bundleName} is not in restore, the card was cancelled`);
          continue;
        }
      }
      if (layoutItem.typeId === CommonConstants.TYPE_APP && (!existAppName.has(keyName) ||
        this.stubAppList.indexOf(layoutItem.bundleName) === CommonConstants.INVALID_VALUE)) {
        existAppName.add(keyName);
      }
      if (layoutItem.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        existShortcuts.push(layoutItem);
      }
      if (layoutItem.typeId === CommonConstants.TYPE_FOLDER) {
        layoutItem.folderId = String(++this.currentTime);
        layoutItem.infoId = layoutItem.folderId;
        layoutItem.bundleName = layoutItem.folderId;
      }
      resultItemList.push(layoutItem);
    }
    if (!isOuter) {
      this.filterTwinAppOfUnownedApps(resultItemList);
      await this.dealWithSingleUniqueApp(resultItemList, existAppName, appList);
      await this.dealWithSingleUniqueShortcut(resultItemList, existShortcuts);
      let backupCardItem = await this.dealWithInstalledCardAndStack(resultItemList);
      resultItemList.push(...backupCardItem);
      // 分别处理新机已有的特殊文件夹
      resultItemList = this.dealWithSpecialElement(resultItemList, SceneType.FROM_SCENE_BOARD);
      resultItemList =
        this.dealWithSpecialElement(resultItemList, SceneType.FROM_SCENE_BOARD, DeliverUtil.DELIVER_APPSTORE_PKG);
      resultItemList =
        this.dealWithSpecialElement(resultItemList, SceneType.FROM_SCENE_BOARD, DeliverUtil.APP_PKG);
      this.updateHarmonyAppNames(resultItemList);
    }
    FormRelationManager.getInstance().refreshSceneBoardFormRelationToFile();
    return resultItemList;
  }

  private convertToCardItemInfo(layoutItem: GridLayoutItemInfo, cloneItemInfo: CloneItemInfo): CardItemInfo {
    let cardItem: CardItemInfo = new CardItemInfo();
    cardItem.bundleName = layoutItem?.bundleName;
    cardItem.moduleName = layoutItem?.moduleName ?? '';
    cardItem.abilityName = layoutItem?.abilityName;
    cardItem.cardName = layoutItem?.cardName ?? '';
    cardItem.cardDimension = layoutItem?.cardDimension ?? 0;
    cardItem.thirdAppRelationCardId = layoutItem?.cardId;
    cardItem.cardId = String(++this.currentTime);
    cardItem.appName = cloneItemInfo.title;
    return cardItem;
  }

  private convertToDefaultCard(layoutItem: GridLayoutItemInfo, placeholderCard: CardItemInfo): GridLayoutItemInfo {
    layoutItem.bundleName = CommonConstants.LAUNCHER_BUNDLE;
    layoutItem.moduleName = LAUNCHER_PHONE_MODULE;
    layoutItem.abilityName = LAUNCHER_FORM_ABILITY;
    layoutItem.isTransparent = false;
    layoutItem.cardId = placeholderCard.cardId;
    layoutItem.cardName = FormRelationManager.getInstance().getDefaultCardName(layoutItem.area ?? []);
    log.showWarn(TAG, `buildSceneBoardDefaultCard : ${layoutItem.bundleName} : ${layoutItem.moduleName} : ` +
      `${layoutItem.abilityName} : ${layoutItem.cardName} : ${layoutItem.cardId}`);
    return layoutItem;
  }

  private getFindItemByRestoreData(bundleName: string, index: number): CloneItemInfo | undefined {
    let findItem: CloneItemInfo | undefined =
      this.restoreInfo.find(item => item.bundleName === bundleName && item.appIndex === index);
    return findItem;
  }

  /**
   * 对比两个集合，根据卡片名称+包名去重
   *
   * @param installedCards  待去重的集合
   * @param backupCards  去重的根据
   * @returns 去重后的卡片集合
   */
  public deleteDuplicateCards(installedCards: GridLayoutItemInfo[],
    backupCards: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let backupFormNameInStack: Set<string> = new Set();
    backupCards.forEach(item => {
      //非单窗口单屏场景下，若旧机包含1*4天气时钟卡片，需要对新机中的2*4天气时钟卡片进行去重
      if (item.cardName === ONEMULFOUR_WEATHERCARD_NAME && this.backUpType !== SceneType.FROM_SCENE_BOARD) {
        backupFormNameInStack.add(CLOCK_WEATHERCARD_NAME + TOTEMWEATHER_BUNDLENAME);
      }
      if (!CheckEmptyUtils.checkStrIsEmpty(item?.cardName)) {
        backupFormNameInStack.add(item.cardName + item.bundleName);
      } else {
        log.showInfo(TAG, `deleteduplicatecards card name is null ,bundleName:${item.bundleName},area:${item?.area}`);
      }
    });
    let deduplicatedCards: GridLayoutItemInfo[] =
      installedCards.filter(item =>!backupFormNameInStack.has(item.cardName + item.bundleName));
    return deduplicatedCards;
  }

  /**
   * 获取堆叠中卡片集合
   *
   * @param formStack  堆叠卡片
   * @param itemList  图标对象集合
   * @returns  所有堆叠中卡片集合
   */
  public getCardFromStack(formStack: GridLayoutItemInfo,
    itemList: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    let cardFromStack: GridLayoutItemInfo[] = [];
    if (CheckEmptyUtils.isEmpty(formStack.id)) {
      log.showInfo(TAG, `formStack id is null`);
      return cardFromStack;
    }
    itemList.forEach(item => {
      if (!CheckEmptyUtils.isEmpty(item.container) && item.container === formStack.id) {
        log.showWarn(TAG, `getCardFromStack,container:${item.container},cardId:${item.cardId},cardName:${item.cardName},area:${item.area}`);
        cardFromStack.push(item);
      }
    });
    return cardFromStack;
  }

  /**
   * 判断是否未鸿蒙化tx应用对应的映射
   *
   * @param bundleName  应用名称
   * @param restoreInfoMap  三方映射集合
   * @returns 返回特定未鸿蒙化应用映射值
   */
  public getWaitForHarmonyValue(bundleName: string, appIndex: number | undefined,
    restoreInfoMap: Map<string, Array<string>>): Array<string> {
    if (WHITELIST_MAP.has(bundleName)) {
      const WAIT_FOR_SYSTEM_APP_KEYNAME: string = `${WHITELIST_MAP.get(bundleName)}${appIndex ?? 0}`;
      if (restoreInfoMap.has(WAIT_FOR_SYSTEM_APP_KEYNAME)) {
        log.showInfo(TAG, `this is waiting for harmony app`);
        return restoreInfoMap.get(WAIT_FOR_SYSTEM_APP_KEYNAME) ?? [];
      }
    }
    return [];
  }

  /**
   * 查询未鸿蒙化应用设备包名对应的设备包名
   *
   * @param bundleName 设备包名
   * @returns 设备包名
   */
  public getWaitForHarmonyBundleName(bundleName: string): string {
    return WHITELIST_MAP.has(bundleName) ? (WHITELIST_MAP.get(bundleName) ?? '') : bundleName;
  }

  /**
   * 通知卡片框架删除新机克隆需要丢弃的卡片数据
   *
   * @param installedCards 新机当前已安装的卡片
   * @param backupCards 旧机需克隆的卡片集合
   */
  private clearCatchOfCardFrame(installedCards: GridLayoutItemInfo[], backupCards: GridLayoutItemInfo[]): void {
    // 存放待删除卡片
    let removedCardIdList: string[] = [];
    installedCards.forEach(installedItem => {
      let reservedIndex = this.reservedCardIdList.findIndex(reservedItem => installedItem.cardId === reservedItem);
      let sameCardIdindex = backupCards.findIndex(backupItem => installedItem.cardId === backupItem?.cardId);
      if (reservedIndex === CommonConstants.INVALID_VALUE && sameCardIdindex === CommonConstants.INVALID_VALUE &&
      installedItem.cardId) {
        removedCardIdList.push(installedItem.cardId);
      } else if (sameCardIdindex !== CommonConstants.INVALID_VALUE) {
        log.showInfo(TAG, `the old and new phone cards are the same,cardid:${installedItem.cardId},cardName:${installedItem.cardName}`);
        let sameCardIdItem = backupCards[sameCardIdindex];
        sameCardIdItem.extend1 = '';
      }
    });
    // 如果有需要删除卡片框架缓存的卡片则存放至全局遍量，待布局转换成功后删除
    if (removedCardIdList.length !== 0) {
      GlobalContext.getInstance().setObject('removedCardIdList', removedCardIdList);
    }
    this.reservedCardIdList = [];
  }

  /**
   * 获取桌面位置的排序值, container+page+row+column
   *
   * @param uniqueItem 元素信息
   * @returns 元素对应的排序字符串
   */
  public getLocationOfUniqueItem(uniqueItem: GridLayoutItemInfo): string {
    if (!uniqueItem || CheckEmptyUtils.isEmpty(uniqueItem.typeId)) {
      log.showWarn(TAG, 'the gridLayout is empty or typeid is undefined');
      return '';
    }
    // 新机已安装应用信息来自BMS无container及位置信息，新机卡片和快捷方式来自数据库包含container，container为-100，-101时则直接返回
    if (!CheckEmptyUtils.isEmpty(uniqueItem.container) &&
      (uniqueItem.container === CommonConstants.CONTAINER_SMARTDOCK ||
        uniqueItem.container === CommonConstants.CONTAINER_DESKTOP)) {
      let uniqueItemPosition: string = this.getLetterFromPage(uniqueItem) + uniqueItem.row + uniqueItem.column;
      return this.getIdFromContainer(uniqueItem.container) + uniqueItemPosition;
    }
    let appBeforeCovert: GridLayoutItemInfo;
    // 新机已安装应用信息来自BMS无位置信息,需要通过keyname从数据库获取完整位置信息
    if (uniqueItem.typeId === CommonConstants.TYPE_APP) {
      let itemIndex = this.appListBeforeConvert.findIndex(item => item.keyName === uniqueItem.keyName);
      if (itemIndex === -1) {
        log.showWarn(TAG, `the application is not found in the database,keyname:${uniqueItem.keyName},typeid:${uniqueItem.typeId}`);
        return '';
      }
      appBeforeCovert = this.appListBeforeConvert[itemIndex];
    } else {
      appBeforeCovert = uniqueItem;
    }
    let appPositionBeforeCovert: string = this.getLetterFromPage(appBeforeCovert) + appBeforeCovert.row + appBeforeCovert.column;
    if (appBeforeCovert.container === CommonConstants.CONTAINER_DESKTOP ||
      appBeforeCovert.container === CommonConstants.CONTAINER_SMARTDOCK) {
      return this.getIdFromContainer(appBeforeCovert.container) + appPositionBeforeCovert;
    }
    let folderContainer: number = NumberConstants.CONSTANT_NUMBER_ZERO;
    let folderPositionBeforeCovert: string = '';
    this.folderListBeforeConvert.some(folderItem => {
      if (folderItem.id === appBeforeCovert.container) {
        folderPositionBeforeCovert = this.getLetterFromPage(folderItem) + folderItem.row + folderItem.column;
        folderContainer = folderItem.container ?? NumberConstants.CONSTANT_NUMBER_ZERO;
        return true;
      }
      return false;
    });
    return this.getIdFromContainer(folderContainer) + folderPositionBeforeCovert + appPositionBeforeCovert;
  }

  private getIdFromContainer(containerId: number): number {
    if (CheckEmptyUtils.isEmpty(containerId)) {
      return NumberConstants.CONSTANT_NUMBER_ONE;
    }
    if (containerId === CommonConstants.CONTAINER_SMARTDOCK) {
      return NumberConstants.CONSTANT_NUMBER_ZERO;
    }
    return NumberConstants.CONSTANT_NUMBER_ONE;
  }

  /**
   * 将page值转为对应的字母, 避免出现位数超过1
   *
   * @param uniqueItem 元素信息
   * @returns 对应的字母
   */
  private getLetterFromPage(uniqueItem: GridLayoutItemInfo): string {
    // 如果是桌面应用page需进行转换,dock区page给默认值
    if (!CheckEmptyUtils.isEmpty(uniqueItem.container) &&
      uniqueItem.container !== CommonConstants.CONTAINER_SMARTDOCK && uniqueItem.page !== undefined) {
      return String.fromCharCode(UNICODE_NUMBER + uniqueItem.page);
    }
    return ' ';
  }

  /**
   * 处理新机特殊应用
   *
   * @param backupInfoArr 需要恢复的布局元素
   * @param isdeliver  是否是克隆应用应用
   */
  private dealWithSpecialElement(backupInfoArr: GridLayoutItemInfo[], cloneType: number,
    installSource?: string): GridLayoutItemInfo[] {
    // 收集新机特殊元素
    let specialAppMap: Map<string, GridLayoutItemInfo> = this.collectingSpecialElements(this.appListBeforeConvert, installSource);
    // 收集旧机的特殊元素
    let oldSpacialApp: Map<string, GridLayoutItemInfo> = this.collectingSpecialElements(backupInfoArr, installSource);
    // 防止installSource不同keyname相同，需要全量去重
    backupInfoArr.forEach(item => {
      if (item.typeId !== CommonConstants.TYPE_APP) {
        return;
      }
      let key: string = item.bundleName + (item.appIndex ?? 0);
      if (specialAppMap.has(key)) {
        specialAppMap.delete(key);
      }
    });
    if (cloneType === SceneType.FROM_HW_LAUNCHER) {
      // 系统迁移旧机已有特殊应用,则直接插入,后面统一收集到对应的特殊文件夹从第二页找位
      backupInfoArr = this.dealWithSpecialApp(backupInfoArr, specialAppMap, oldSpacialApp, installSource);
      return backupInfoArr;
    }
    // 其他场景保留新机文件夹或合并到旧机文件夹，并从待恢复列表中移除旧机应用
    backupInfoArr = this.dealWithSpecialFolder(backupInfoArr, specialAppMap, oldSpacialApp, installSource);
    return backupInfoArr;
  }

  /**
   * 系统迁移处理新机特殊应用
   *
   * @param backupInfoArr 需要恢复的布局元素
   * @param specialAppMap  新机应用map
   * @param oldSpacialAppMap  旧机应用map
   * @param installSource  安装来源
   *
   * @returns 需要恢复的布局元素
   */
  private dealWithSpecialApp(backupInfoArr: GridLayoutItemInfo[], specialAppMap: Map<string, GridLayoutItemInfo>,
    oldSpacialAppMap: Map<string, GridLayoutItemInfo>, installSource?: string): GridLayoutItemInfo[] {
    let notHarmonyFolder: GridLayoutItemInfo | undefined =
      this.folderListBeforeConvert.find(item => DeliverUtil.checkFolderbyInstallSource(item, installSource));
    if (!CheckEmptyUtils.isEmpty(installSource) || !notHarmonyFolder || !NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER) {
      specialAppMap.forEach(item => {
        item.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
        backupInfoArr.push(item);
        log.showInfo(TAG, `insert special item:${item.bundleName},installSource:${installSource}`);
      });
    } else {
      // 新机特有的未鸿蒙化应用，保留在新机屏
      let folderLayout: GridLayoutItemInfo[][] = [[]];
      specialAppMap.forEach(item => {
        let keyName: string = item.bundleName + (item?.appIndex ?? 0);
        if (oldSpacialAppMap.has(keyName) || item?.container !== notHarmonyFolder?.id) {
          item.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
          backupInfoArr.push(item);
        } else {
          folderLayout[0].push(item);
        }
        log.showInfo(TAG, `insert not harmony item:${item.bundleName},installSource:${installSource}`);
      });
      if (folderLayout[0].length > 0) {
        notHarmonyFolder.layoutInfo = folderLayout;
        notHarmonyFolder.folderId = String(++this.currentTime);
        notHarmonyFolder.infoId = notHarmonyFolder.folderId;
        notHarmonyFolder.bundleName = notHarmonyFolder.folderId;
        notHarmonyFolder.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
        backupInfoArr.push(notHarmonyFolder);
        log.showWarn(TAG,
          `add not harmony folder,folderName: ${notHarmonyFolder.folderName}, folderid: ${notHarmonyFolder.folderId}` +
            `folderlength:${notHarmonyFolder.layoutInfo[0].length}`);
      }
    }
    return backupInfoArr;
  }

  /**
   * 收集特殊元素
   *
   * @param backupInfoArr 待恢复集合
   * @param installSource 过滤条件
   * @returns
   */
  private collectingSpecialElements(backupInfoArr: GridLayoutItemInfo[],
    installSource?: string): Map<string, GridLayoutItemInfo> {
    let speciaItemMap: Map<string, GridLayoutItemInfo> = new Map();
    backupInfoArr.forEach(item => {
      if (item.typeId !== CommonConstants.TYPE_APP) {
        return;
      }
      if ((CheckEmptyUtils.isEmpty(installSource) && item.appStatus === AppStatus.WAIT_FOR_HARMONY &&
        !DeliverUtil.isContainerItem(item.intent)) ||
        (!CheckEmptyUtils.isEmpty(installSource) &&
          (DeliverUtil.getInstallSourceByIntent(item.intent ?? '', true) === installSource))) {
        let keyName: string = item.bundleName + (item?.appIndex ?? 0);
        speciaItemMap.set(keyName, ObjectCopyUtil.deepClone(item));
      }
    });
    return speciaItemMap;
  }

  /**
   * 处理新机特殊文件夹
   *
   * @param backupInfoArr 需要恢复的布局元素
   * @param isdeliver  是否是克隆应用应用
   */
  private dealWithSpecialFolder(backupInfoArr: GridLayoutItemInfo[], newSpecialAppMap: Map<string, GridLayoutItemInfo>,
    oldSpecialAppList: Map<string, GridLayoutItemInfo>, installSource?: string): GridLayoutItemInfo[] {
    // 获取旧机特殊文件夹
    let olderFolder: GridLayoutItemInfo | undefined =
      backupInfoArr.find(item => DeliverUtil.checkFolderbyInstallSource(item, installSource));
    let folderLayout: Array<GridLayoutItemInfo[]> = [[]];
    let folderItemLayout: Array<string> = [];
    oldSpecialAppList.forEach(oldItem => {
      if (olderFolder && oldItem.container === olderFolder.id) {
        folderLayout[0].push(oldItem);
        folderItemLayout.push(oldItem.keyName ?? '');
      }
    });
    // 如果涉及保留文件夹则先将元素从待恢复列表移除,或从新机中添加
    backupInfoArr = backupInfoArr.filter(item => {
      return folderItemLayout.indexOf(item.keyName ?? '') === CommonConstants.INVALID_VALUE;
    });
    if (newSpecialAppMap.size !== 0) {
      newSpecialAppMap.forEach((newItem, key) => folderLayout[0].push(newItem));
    }
    // 当旧机没有未鸿蒙化、克隆应用、应用文件夹时，保留新机特殊文件夹作为新机特有元素放入新机屏
    if (CheckEmptyUtils.isEmpty(installSource) && NotHarmonyUtil.CANCEL_NOT_HARMONY_FOLDER) {
      newSpecialAppMap.forEach(item => {
        item.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
        backupInfoArr.push(item);
        log.showInfo(TAG, `insert not harmony item:${item.bundleName},installSource:${installSource}`);
      });
      return backupInfoArr;
    } else if (CheckEmptyUtils.isEmpty(olderFolder) || oldSpecialAppList.size === 0) {
      let newSpecialFolder: GridLayoutItemInfo | undefined =
        this.folderListBeforeConvert.find(folderItem => DeliverUtil.checkFolderbyInstallSource(folderItem,installSource));
      if (newSpecialFolder) {
        newSpecialAppMap.forEach((item, key) => folderLayout[0].push(item));
        newSpecialFolder.layoutInfo = folderLayout;
        newSpecialFolder.folderId = String(++this.currentTime);
        newSpecialFolder.infoId = newSpecialFolder.folderId;
        newSpecialFolder.bundleName = newSpecialFolder.folderId;
        newSpecialFolder.container = CommonConstants.CONTAINER_UNIQUE_SINGLE;
        backupInfoArr.push(newSpecialFolder);
        log.showWarn(TAG, `add new folder,folderName: ${newSpecialFolder.folderName}, folderid: ${newSpecialFolder.folderId}` +
          `folderlength:${newSpecialFolder.layoutInfo[0].length}`);
      }
      return backupInfoArr;
    }
    if (olderFolder) {
      olderFolder.layoutInfo = folderLayout;
      log.showWarn(TAG, `update older folder, folderName: ${olderFolder.folderName}, folderid: ${olderFolder.folderId}` +
        `folderlength:${olderFolder.layoutInfo[0].length}`);
    }
    return backupInfoArr;
  }

  private updateHarmonyAppNames(resultItemList: GridLayoutItemInfo[]): void {
    resultItemList.forEach((item: GridLayoutItemInfo) => {
      this.updateHarmonyAppName(item);
    });
  }

  /**
   * 更新pending状态的鸿蒙化应用占位名称
   *
   * @param item 待恢复应用
   */
  public updateHarmonyAppName(item: GridLayoutItemInfo): void {
    if (item.typeId !== CommonConstants.TYPE_APP || item.appStatus !== AppStatus.PENDING || item.appIndex) {
      return;
    }
    let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent);
    if (extendInfo.size === 0 || !extendInfo.has(NotHarmonyUtil.APP_TYPE) ||
      extendInfo.get(NotHarmonyUtil.APP_TYPE) === AppReserveType.THIRD) {
      item.appStatus = AppStatus.WAITING;
    }
  }

  /**
   * 获取当前应用列表
   *
   * @returns 应用列表信息
   */
  public getAppItemInfoList(): AppItemInfo[] {
    return this.appItemInfoList;
  }

  /**
   * 递增时间戳生成唯一Id
   *
   * @returns 时间戳Id
   */
  public incCurrentTime(): number {
    return ++this.currentTime;
  }

  /**
   * 读取旧机图标资源路径
   *
   * @returns 旧机图标资源路径
   */
  public getOldIconPath(packageName: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(packageName)) {
      return this.oldIconPath;
    }
    return this.oldIconPath + packageName.split('.').join('') + BMP;
  }

  /**
   * 读取旧机快捷方式图标资源路径(图标资源文件名格式：packageName + '#' + shortcutId，后缀名.png)
   *
   * @param shortcutKey 快捷方式图标文件名
   * @returns 旧机快捷方式图标资源路径
   */
  public getOldIconShortcutPath(shortcutKey: string): string {
    if (CheckEmptyUtils.checkStrIsEmpty(shortcutKey)) {
      return this.oldIconPath;
    }
    return this.oldIconPath + shortcutKey + PNG;
  }

  /**
   * 获取旧机图标资源路径
   *
   * @param packageName 设备包名
   * @returns 旧机图标资源路径
   */
  public getOldIconUri(packageName: string): string {
    let iconUri: string = '';
    if (CommonUtils.isEmpty(packageName)) {
      return iconUri;
    }
    if (CommonUtils.isEmpty(this.oldIconPath)) {
      this.oldIconPath =
        (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).filesDir +
          '/oldIcons/';
    }
    let filePath = this.getOldIconPath(packageName);
    if (FileUtils.isExist(filePath)) {
      iconUri = FILE_PRE + filePath;
    } else {
      log.showInfo(TAG, `get iconResource from oldIcon fail. ${packageName}`);
    }
    return iconUri;
  }

  /**
   * 保存系统迁移/系统迁移中不匹配应用的名称
   *
   * @param appName 应用名
   */
  public saveMisAppNameArr(appName: string): void {
    this.misAppNameArr.push(appName);
  }

  /**
   * 保存系统迁移/系统迁移中丢失应用的名称
   *
   * @param appName 应用名
   */
  public saveLostAppNameArr(appName: string): void {
    this.lostAppNameArr.push(appName);
  }

  /**
   * 保存系统迁移/系统迁移中丢失卡片的信息
   *
   * @param formRelationParam 卡片信息
   */
  public saveMisCardArr(formRelationParam: string): void {
    this.misCardArr.push(formRelationParam);
  }

  /**
   * 保存系统迁移/系统迁移中丢失卡片的映射信息
   *
   * @param appName 卡片映射信息
   */
  public saveMisWidgetArr(component: string): void {
    this.misWidgetArr.push(component);
  }

  /**
   * 保存系统迁移/系统迁移中丢失快捷方式的映射信息
   *
   * @param appName 卡片映射信息
   */
  public saveMisShortCutArr(component: string): void {
    this.misShortCutArr.push(component);
  }

  /**
   * 查询新机已经添加的快捷方式
   *
   * @returns ShortcutInfo[] 新机已添加快捷方式列表
   */
  public getShortcutList(): ShortcutInfo[] {
    return this.shortcutList;
  }

  /**
   * 查询快捷方式默认图标路径
   *
   * @returns string 快捷方式默认图标路径
   */
  public getDefaultShortcut(): string {
    return this.defaultShortcut;
  }

  /**
   * 从BMS数据库判断是否已经添加过快捷方式
   *
   * @param shortcut 待检查的快捷方式信息
   * @returns 检查结果
   */
  public isShortcutInBMS(shortcut: ShortcutInfo): boolean {
    let result: boolean = this.shortcutList.some(item => item.bundleName === shortcut.bundleName &&
      item.id === shortcut.id && item.appIndex === shortcut.appIndex);
    log.showInfo(TAG, `isShortcutInBMS ${shortcut.id} result: ${result}`);
    return result;
  }

  /**
   * 累加系统迁移/系统的widget数目
   */
  public incWidgetCount(): void {
    this.widgetCount++;
  }

  /**
   * 累加系统迁移/系统的应用数目
   */
  public incAppCount(): void {
    this.appCount++;
  }

  /**
   * 累加系统迁移/系统的卡片数目
   */
  public incCardCount(): void {
    this.cardCount++;
  }

  /**
   * 获取userId
   *
   * @returns 当前userId
   */
  public getCurUserId(): number {
    return this.curUserId;
  }

  /**
   * 保存没有旧机图标的应用设备包名
   *
   * @param packageName 设备包名
   */
  public saveNotHaveIconPackageNames(packageName: string): void {
    this.notHaveIconPackageNames.push(packageName);
  }

  /**
   * 移除只有旧机分身没有旧机主应用的分身数据
   *
   * @param backupInfoArr 备份数据集合
   * @returns 过滤无主应用分身后的备份数据集合
   */
  public filterTwinAppOfUnownedApps(backupInfoArr: GridLayoutItemInfo[]): void {
    let backupTwinAppMap: Map<number, GridLayoutItemInfo> = new Map();
    backupInfoArr.forEach((item, index) => {
      if (item.typeId === CommonConstants.TYPE_APP && item.appIndex !== CommonConstants.MAIN_APP_INDEX &&
        item.container !== CommonConstants.CONTAINER_UNIQUE_SINGLE) {
        backupTwinAppMap.set(index, item);
      }
    });
    backupTwinAppMap.forEach((twinAppItem, itemIndex) => {
      let findIndex = backupInfoArr.findIndex(mainAppItem => mainAppItem.bundleName === twinAppItem.bundleName &&
        mainAppItem.container !== CommonConstants.CONTAINER_UNIQUE_SINGLE &&
        mainAppItem.typeId === CommonConstants.TYPE_APP && mainAppItem.appIndex === CommonConstants.MAIN_APP_INDEX);
      if (findIndex === -1) {
        backupInfoArr.splice(itemIndex, 1);
        log.showWarn(TAG, `the twin app has no owner,bundleName:${twinAppItem.bundleName},index:${twinAppItem.appIndex}`);
      }
    });
  }

  /**
   * 从BMS获取已安装应用，同时过滤系统应用和隐藏应用
   *
   * @param userId 用户id
   * @returns 过滤后的应用信息
   */
  public async getAppListFromBMS(userId?: number): Promise<AppItemInfo[]> {
    if (CheckEmptyUtils.isEmpty(userId)) {
      userId = DEFAULT_USER_ID;
    }
    let appList: AppItemInfo[] = await launcherAbilityManager.getLauncherAbilityList(userId);
    let systemApplicationName: string[] = SystemApplication.systemApplicationName.split(',');
    appList =
      appList.filter(appItem => systemApplicationName.indexOf(appItem.bundleName) === CommonConstants.INVALID_VALUE);
    await GetHideAppsFromConfig.getInstance().loadHideConfig();
    appList = GetHideAppsFromConfig.getInstance().filterHideApp(appList);
    let uid: number | undefined = userId;
    log.showWarn(TAG, `filtered app length from bms: ${appList.length}, uid: ${uid}`);
    return appList;
  }

  // 此接口只用于单元测试
  public setCurUserId(userId: number): void {
    this.curUserId = userId;
  }

  // 此接口只用于单元测试
  public setAppItemInfoList(value: AppItemInfo[]): void {
    this.appItemInfoList = value;
  }

  // 此接口只用于单元测试
  public setOldIconPath(path: string): void {
    this.oldIconPath = path;
  }

  public isInContainerFolder(appItemBundleName: string) : boolean {
    let existAppItem: GridLayoutItemInfo[] = this.appListBeforeConvert.filter(item => item.bundleName === appItemBundleName);
    if (CheckEmptyUtils.isEmptyArr(existAppItem)) {
      log.showError(TAG, `${appItemBundleName} is not in new machine`);
      return false;
    }
    let containerFolderArr: GridLayoutItemInfo[] =
      this.folderListBeforeConvert.filter(folder => DeliverUtil.isContainerItem(folder.intent));
    let isInContainerFolder: boolean = !CheckEmptyUtils.isEmptyArr(containerFolderArr) &&
      containerFolderArr.map(folder => folder.id).indexOf(existAppItem[0].container) !== -1;
    log.showInfo(TAG, `${appItemBundleName} isInContainerFolder: ${isInContainerFolder}`);
    return isInContainerFolder;
  }

  /**
   * 追加应用内置应用
   *
   * @param targetGridLayoutItem 目标恢复集合
   * @returns 返回待恢复集合
   */
  private getAppApp(targetGridLayoutItem: GridLayoutItemInfo[]): GridLayoutItemInfo[] {
    if (this.restoreInfo.length === 0) {
      return targetGridLayoutItem;
    }
    this.restoreInfo.forEach(cloneItem => {
      if (CheckEmptyUtils.checkStrIsEmpty(cloneItem.intent)) {
        return;
      }
      let keyName = cloneItem.bundleName + cloneItem.appIndex;
      let installSource = DeliverUtil.getInstallSourceByIntent(cloneItem.intent ?? '', true);
      // 应用应用且备份数据中不存在则追加
      if (installSource === DeliverUtil.APP_PKG && !this.existAppSet.has(keyName)) {
        let easyAbroditem: GridLayoutItemInfo = new GridLayoutItemInfo();
        easyAbroditem.bundleName = cloneItem.bundleName;
        easyAbroditem.area = APP_AREA;
        easyAbroditem.appIndex = cloneItem.appIndex;
        easyAbroditem.keyName = easyAbroditem.bundleName + easyAbroditem.appIndex;
        easyAbroditem.intent = cloneItem.intent;
        easyAbroditem.callerName = cloneItem.callerName;
        easyAbroditem.appName = cloneItem.title;
        easyAbroditem.appStatus = AppStatus.WAIT_FOR_HARMONY;
        easyAbroditem.typeId = CommonConstants.TYPE_APP;
        easyAbroditem.container = CommonConstants.CONTAINER_DESKTOP;
        easyAbroditem.iconResource = cloneItem.iconUri;
        log.showWarn(TAG, `insert easyAborad built-in app: ${easyAbroditem.bundleName}`);
        targetGridLayoutItem.push(easyAbroditem);
      }
    });
    this.existAppSet = new Set();
    return targetGridLayoutItem;
  }

  /**
   * 系统迁移场景追加应用内置应用
   *
   * @param targetGridLayoutItem 目标恢复集合
   * @returns
   */
  private addAppApp(targetGridLayoutItem: GridLayoutItemInfo[]): void {
    if (TransformAppInfoManager.getInstance().getAbroadAutoMigrateAppType() !== AutoMigrateType.MIGRATE ||
      this.getCurUserId() !== DEFAULT_USER_ID) {
      log.showWarn(TAG, 'not allowed auto enter lake');
      return;
    }
    let abroadPackageInfos: AbroadPackageInfo[] = TransformAppInfoManager.getInstance().getAbroadPackageInfo();
    if (CheckEmptyUtils.isEmptyArr(abroadPackageInfos)) {
      log.showWarn(TAG, 'no easyAborad built-in app exist');
      return;
    }
    abroadPackageInfos.forEach(abroadPackageInfo => {
      // 仅在应用安装类型installType = 1(仅虚拟机) && 用户选择 reserveType = 3（选择保留）时追加应用内置应用
      if ((Number(abroadPackageInfo.reserveType) !== NumberConstants.CONSTANT_NUMBER_THREE) ||
        (Number(abroadPackageInfo.installType) !== NumberConstants.CONSTANT_NUMBER_ONE)) {
        log.showWarn(TAG,
          `the easyAborad built-in app ${abroadPackageInfo.pkgName} is already on the desktop or not choose`);
        return;
      }
      let easyAbrodItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      easyAbrodItem.bundleName = abroadPackageInfo.pkgName;
      easyAbrodItem.area = APP_AREA;
      easyAbrodItem.appIndex = CommonConstants.MAIN_APP_INDEX;
      easyAbrodItem.keyName = abroadPackageInfo.pkgName + easyAbrodItem.appIndex;
      easyAbrodItem.appName = abroadPackageInfo.pkgLableName;
      easyAbrodItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
      easyAbrodItem.typeId = CommonConstants.TYPE_APP;
      easyAbrodItem.container = CommonConstants.CONTAINER_DESKTOP;
      easyAbrodItem.iconResource = FILE_PRE + this.oldIconPath + abroadPackageInfo.iconFile;
      RestoreLauncherDataManager.getInstance().scaleIconUri(easyAbrodItem.iconResource);
      let requestBundleName: string = `__WAIT_FOR_HARMONY_BUNDLENAME__${easyAbrodItem.bundleName}__` + (this.incCurrentTime());
      let legacyInfo: LegacyInfo = new LegacyInfo();
      legacyInfo.pkgName = abroadPackageInfo.pkgName;
      legacyInfo.pkgSignature = abroadPackageInfo.pkgSignature;
      legacyInfo.pkgLableName = abroadPackageInfo.pkgLableName;
      legacyInfo.pkgSourceDir = abroadPackageInfo.pkgPath;
      legacyInfo.versionCode = abroadPackageInfo.versionCode;
      legacyInfo.versionName = abroadPackageInfo.versionName;
      legacyInfo.primaryCpuAbi = abroadPackageInfo.primaryCpuAbi;
      legacyInfo.secondaryCpuAbi = abroadPackageInfo.secondaryCpuAbi;
      let extendInfo: ILegacyInfo = {
        'legacyInfo': legacyInfo,
        'requestBundleName': requestBundleName,
        'maskState': NumberConstants.CONSTANT_NUMBER_ONE,
        'appType': AppReserveType.THIRD,
        'installSource': DeliverUtil.APP_PKG
      };
      easyAbrodItem.intent = JSON.stringify(extendInfo);
      easyAbrodItem.callerName = CommonConstants.SOURCE_UPGRADE;
      log.showInfo(TAG, `insert easyAborad built-in app, bundleName: ${easyAbrodItem.bundleName}, ` +
        `iconResource: ${easyAbrodItem.iconResource}`);
      targetGridLayoutItem.push(easyAbrodItem);
    });
  }

  /**
   * 处理新旧机共有已安装应用，当新机为应用应用，旧机为应用真机应用时可以继承位置，其他场景直接当做新机特有应用
   *
   * @param appKeyName key值
   * @param targetGridLayoutItem 目标恢复对象集合
   * @param singleItemInfoList 新机特有应用集合
   * @param appListFromBms BMS返回集合
   */
  private replaceTotalInstalledApp(appKeyName: string, targetGridLayoutItem: GridLayoutItemInfo[],
    singleItemInfoList: AppItemInfo[], appListFromBms: AppItemInfo[]): void {
    let newAppFromDb: GridLayoutItemInfo | undefined =
      this.appListBeforeConvert.find(item => item.bundleName + (item.appIndex ?? 0) === appKeyName);
    let oldAppFromDb: GridLayoutItemInfo | undefined =
      targetGridLayoutItem.find(item => item.bundleName + (item.appIndex ?? 0) === appKeyName);
    if (!newAppFromDb || !oldAppFromDb) {
      return;
    }
    let newAppInstallSource: string = DeliverUtil.getInstallSourceByIntent(newAppFromDb.intent, true);
    let oldAppInstallSource: string = DeliverUtil.getInstallSourceByIntent(oldAppFromDb.intent, true);
    // 如果installSource相同则替换后返回
    if (newAppInstallSource === oldAppInstallSource) {
      oldAppFromDb.intent = newAppFromDb.intent;
      return;
    }
    // 其他场景直接替换为新机特有应用
    let newAppFromBms: AppItemInfo | undefined =
      appListFromBms.find(item => item.bundleName + (item.appIndex ?? 0) === appKeyName);
    let index: number = targetGridLayoutItem.findIndex(item => item.bundleName + (item.appIndex ?? 0) === appKeyName);
    if (newAppFromBms) {
      targetGridLayoutItem.splice(index, 1);
      singleItemInfoList.push(newAppFromBms);
      log.showWarn(TAG, `replace with new machine installed app, bundlname: ${newAppFromBms.bundleName}, ` +
        `newAppInstallSource: ${newAppInstallSource}, oldAppInstallSource:${oldAppInstallSource}`);
    }
  }

  /**
   * 判断是否是需要收进相应文件夹的被替换应用
   *
   * @param bundleName
   * @returns
   */
  public isNotHarmonyManyToOne(bundleName: string): boolean {
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn(TAG, 'isNotHarmonyManyToOne bundleName is empty');
      return false;
    }
    let isNotHarmonyManyToOne: boolean =
      this.notHarmonyManyToOneAppList.findIndex(name => name === bundleName) !== CommonConstants.INVALID_VALUE;
    log.showInfo(TAG, `isNotHarmonyManyToOne, bundleName: ${bundleName}, isNotHarmonyManyToOne: ${isNotHarmonyManyToOne}`);
    return isNotHarmonyManyToOne;
  }

  /**
   * 是否是多对一未鸿蒙化应用且取消zyt文件夹开关打开
   *
   * @param bundleName 应用包名
   * @returns true 多对一应用需要收纳到zyt文件夹 false 直接放在桌面
   */
  public isNotHarmonyManyToOneAndCanceldeliverFolder(bundleName: string): boolean {
    return DeliverUtil.CANCEL_DELIVER_FOLDER && this.isNotHarmonyManyToOne(bundleName);
  }
}

const dataConvert: DataConvert = new DataConvert();

export default dataConvert;

export interface ISettlementInfo {
  keyName: string,
  settlementPosition: string
}