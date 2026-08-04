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
  FileUtils,
  LogDomain,
  Logger,
  CommonUtils,
  CheckEmptyUtils
} from '@ohos/basicutils';
import { AppItemInfo } from '../../bean/AppItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AppStatus, CloneItemInfo, CommonConstants, LegacyInfo } from '../../constants/CommonConstants';
import { CloneItemInfoManager } from '../manager/CloneItemInfoManager';
import { transferRelationManager } from '../../manager/TransferRelationManager';
import { BackupItemType } from '../../model/BackupFavoriteInfo';
import { TransferRelationModel } from '../../model/TransferRelationModel';
import { IntentParseUtil, PackageRelation } from '../../utils/IntentParseUtil';
import { PackageInfo } from '../PackageInfo';
import DataConvert from '../DataConvert';
import { LocalHapMigrateInfo } from '../LocalHapMigrateInfo';
import {
  AppReservePolicyType,
  AppReserveType,
  AutoMigrateType,
  RgmSupport32Type,
  TransformAppInfoManager
} from '../TransformAppInfoManager';
import { BaseTransformItem } from './BaseTransformItem';
import { DeliverUtil } from '../../utils/DeliverUtil';
import { NotHarmonyUtil } from '../../utils/NotHarmonyUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AddCardToNewPageManager } from '../manager/AddCardToNewPageManager';
import { ShortcutViewModel } from '../../launchericon/viewmodel/ShortcutViewModel';
import { ShortcutInfo } from '../../TsIndex';
import { ResourceManager } from '@ohos/frameworkwrapper/src/main/ets/manager/ResourceManager';
import { IExtendInfo } from '../../service/impl/RestoreLauncherData';

const TAG = 'AppTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const MIGRATE_SERVER_PROCESS_NAME = 'migrate_server';
const FILE_PRE = 'file://';
const DEFAULT_USER: number = 100;
const LY_INFO = 'legacyInfo';

export class AppTransformItem extends BaseTransformItem {
  private readonly transformAppManager: TransformAppInfoManager = TransformAppInfoManager.getInstance();

  // 目前部分应用（如云空间） 设备没图标，双上存在图标，这种应用不应该显示在桌面占位，增加白名单不让其显示
  private static readonly notShowDesktopAppSet =
    new Set(['com.openharmony.hidisk', 'com.openharmony.ohos.inputmethod', 'com.openharmony.ohos.hwouc',
      'com.openharmony.hilink.framework', 'com.openharmony.ohos.suggestion']);

  // 隐私空间过滤应用，不显示占位图标
  private static readonly notShowDesktopAppInOtherUserSet = TransformAppInfoManager.disallowedHapListInPrivateSpace;

  public isSupportInohos(): boolean {
    DataConvert.incAppCount();
    return true;
  }

  public async transformBackupInfoToGridInfo(): Promise<GridLayoutItemInfo[]> {
    let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(this.backupInfo.intent);
    if (!packageRelation) {
      log.showError(TAG, 'app not has package and class name remove that');
      return [];
    }
    AddCardToNewPageManager.getInstance().addCardToNewPageApp(this.backupInfo, packageRelation);
    if (AppTransformItem.notShowDesktopAppSet.has(packageRelation.packageName)) {
      log.showInfo(TAG, 'app not show in cur desktop bundleName = %{public}s', packageRelation.packageName);
      return [];
    }
    // 过滤单上不显示图标应用
    let bundleName = this.getTransferRelationModel(packageRelation)?.getTargetBundleName() ?? '';
    if (TransformAppInfoManager.sHideIconAppList.has(bundleName)) {
      log.showWarn(TAG, 'app has no icon in desktop, bundleName: %{public}s', bundleName);
      return [];
    }
    // 构建新的对象
    let item: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(this.backupInfo);

    // 从三方映射表中查找应用信息
    let localHapMigrateInfo: LocalHapMigrateInfo | undefined =
      this.transformAppManager.getMigrateByBundleAndType(packageRelation.packageName, AppReserveType.THIRD);

    // 判断是否为rom预装应用，包括系统自研应用和部分三方预装应用
    let appItemInfo: AppItemInfo | undefined = this.getAppItemInfoByIntent(packageRelation);
    if (appItemInfo) {
      await this.dealWithAppItemInfo(item, appItemInfo, packageRelation);
      // 如果为三方预装应用，则可能有多对一映射关系
      if (localHapMigrateInfo) {
        this.setMultiMappingRelationship(localHapMigrateInfo, item);
      }
      log.showInfo(TAG, `app find from icon relation, bundleName: ${item.bundleName}, appIndex: ${item.appIndex}, screen: ${item.page}, ` +
        `container: ${item.container}, point : [${item.row}, ${item.column}], appType: ${CommonUtils.jsonStrToMap(item.intent)
          .get('appType')}, multiMappingRelationship: ${CommonUtils.jsonStrToMap(item.intent)
          .get('multiMappingRelationship')}, appLabelId: ${item.appLabelId}, appName: ${item.appName}`);
      return [item];
    }

    // 如果不是三方,看看是不是企业应用
    if (!localHapMigrateInfo) {
      localHapMigrateInfo = this.transformAppManager.getMigrateByBundleAndType(packageRelation.packageName,
        AppReserveType.ENTERPRISE);
    }
    if (localHapMigrateInfo) {
      this.dealWithThirdAppItemInfo(localHapMigrateInfo, item);
      if (this.isInPrivateSpaceBlockList(item.bundleName)) {
        log.showInfo(TAG, 'app not show in private space desktop bundleName = %{public}s', item.bundleName);
        return [];
      }
      log.showInfo(TAG, `app find from third relation, bundleName: ${item.bundleName}, appIndex: ${item.appIndex}, screen: ${item.page}, ` +
        `container: ${item.container}, point : [${item.row}, ${item.column}], appType: ${CommonUtils.jsonStrToMap(item.intent)
          .get('appType')}, multiMappingRelationship: ${CommonUtils.jsonStrToMap(item.intent)
          .get('multiMappingRelationship')}, appLabelId: ${item.appLabelId}, appName: ${item.appName}`);
      return [item];
    }

    // 非rom预装应用、三方、企业应用，也不在BMS  拿到开关和日落文件 看看是否需要保留
    if (this.transformAppManager.getAppReservePolicy(false) === AppReservePolicyType.RESERVE &&
      !this.transformAppManager.getSunsetAppList(false).has(packageRelation.packageName)) {
      let packageInfo: PackageInfo | undefined;
      if (item.appIndex === CommonConstants.MAIN_APP_INDEX) {
        packageInfo = this.transformAppManager.getPackageInfoByUserIdAndBundleName(DataConvert.getCurUserId(),
          packageRelation.packageName);
      } else {
        packageInfo = this.transformAppManager.getTwinAppPackageInfoByBundleName(packageRelation.packageName);
      }
      //没在appList里找到，或者是系统应用，或者是隐私空间黑名单应用，则不占位
      if (!packageInfo || packageInfo.appScanSourceDir.startsWith('/system') ||
      this.isInPrivateSpaceBlockList(packageRelation.packageName)) {
        log.showInfo(TAG, `app not show, bundleName: ${packageRelation.packageName}, appIndex: ${item.appIndex}, screen: ${item.page}, ` +
          `container: ${item.container}, point: [${item.row}, ${item.column}]`);
        DataConvert.saveLostAppNameArr(packageRelation.packageName);
        return [];
      }
      this.buildNotHmAppInfo(item, packageRelation, packageInfo);
      DataConvert.saveMisAppNameArr(item.bundleName);
      return [item];
    }
    DataConvert.saveLostAppNameArr(packageRelation.packageName);
    return [];
  }

  private isInPrivateSpaceBlockList(bundleName: string): boolean {
    if (DataConvert.getCurUserId() === DEFAULT_USER) {
      return false;
    }
    if (!AppTransformItem.notShowDesktopAppInOtherUserSet.has(bundleName)) {
      return false;
    }
    return true;
  }

  private dealWithThirdAppItemInfo(localHapMigrateInfo: LocalHapMigrateInfo, item: GridLayoutItemInfo): void {
    let bmsAppInfo: AppItemInfo | undefined =
      DataConvert.getAppItemInfoList().find(bmsItem => bmsItem.bundleName === localHapMigrateInfo.target);
    if (bmsAppInfo && item.appIndex === CommonConstants.MAIN_APP_INDEX) {
      // rom预装的三方应用，但未配置在系统预置应用映射表
      this.appItemToGridLayoutItem(bmsAppInfo, item);
      this.setMultiMappingRelationship(localHapMigrateInfo, item);
      log.showInfo(TAG, `app find from third relation and is installed, bundleName: ${item.bundleName}, appIndex: ${item.appIndex}, screen: ${item.page}, ` +
        `container: ${item.container}, point :[${item.row}, ${item.column}]`);
    } else {
      item.typeId = CommonConstants.TYPE_APP;
      item.bundleName = localHapMigrateInfo.target;
      item.keyName = localHapMigrateInfo.target + item.appIndex;
      item.appStatus = AppStatus.PENDING;
      item.appName = this.backupInfo.title;
      item.callerName = MIGRATE_SERVER_PROCESS_NAME;
      if (localHapMigrateInfo.type === AppReserveType.ENTERPRISE) {
        let extendInfo: IExtendInfo = {
          'targetModuleUrl': localHapMigrateInfo.targetModuleUrl,
          'appType': AppReserveType.ENTERPRISE
        };
        item.intent = JSON.stringify(extendInfo);
      } else if (localHapMigrateInfo.type === AppReserveType.THIRD) {
        this.setMultiMappingRelationship(localHapMigrateInfo, item);
      }
      if (!FileUtils.isExist(DataConvert.getOldIconPath(localHapMigrateInfo.source))) {
        log.showWarn(TAG, 'not has icon in launcher db packageName %{public}s', localHapMigrateInfo.source);
        DataConvert.saveNotHaveIconPackageNames(localHapMigrateInfo.source);
      }
      item.iconResource = FILE_PRE + DataConvert.getOldIconPath(localHapMigrateInfo.source);
    }
  }

  private async dealWithAppItemInfo(item: GridLayoutItemInfo, appItemInfo: AppItemInfo, packageRelation: PackageRelation)
    : Promise<void> {
    if ((item.appIndex ?? 0) > 0) {
      item.typeId = CommonConstants.TYPE_APP;
      item.bundleName = appItemInfo.bundleName;
      item.keyName = appItemInfo.bundleName + item.appIndex;
      item.appStatus = AppStatus.PENDING;
      item.appName = this.backupInfo.title;
      item.callerName = MIGRATE_SERVER_PROCESS_NAME;
      if (FileUtils.isExist(DataConvert.getOldIconPath(packageRelation.packageName))) {
        item.iconResource = FILE_PRE + DataConvert.getOldIconPath(packageRelation.packageName);
      }
    } else {
      if (!CheckEmptyUtils.checkStrIsEmpty(appItemInfo.shortcutId)) {
        await this.dealShortCutToGridLayoutItem(appItemInfo, item);
      } else {
        this.appItemToGridLayoutItem(appItemInfo, item);
      }
    }
  }

  private buildNotHmAppInfo(item: GridLayoutItemInfo, packageRelation: PackageRelation,
    packageInfo: PackageInfo): void {
    item.bundleName = packageRelation.packageName;
    item.keyName = packageRelation.packageName + item.appIndex;
    item.typeId = CommonConstants.TYPE_APP;
    item.appStatus = AppStatus.WAIT_FOR_HARMONY;
    item.appName = this.backupInfo.title;
    let requestBundleName = `__WAIT_FOR_HARMONY_BUNDLENAME__${item.bundleName}__` + (DataConvert.incCurrentTime());
    let legacyInfo: LegacyInfo = new LegacyInfo();
    legacyInfo.pkgName = packageRelation.packageName;
    if (packageInfo) {
      legacyInfo.pkgSignature = packageInfo.sign;
      legacyInfo.pkgLableName = item.appName;
      legacyInfo.pkgSourceDir = packageInfo.appScanSourceDir;
      legacyInfo.versionCode = packageInfo.version;
      legacyInfo.versionName = packageInfo.versionName;
      legacyInfo.primaryCpuAbi = packageInfo.primaryCpuAbi;
      legacyInfo.secondaryCpuAbi = packageInfo.secondaryCpuAbi;
    }
    let extendInfo: ILegacyInfo = {
      'legacyInfo': legacyInfo,
      'requestBundleName': requestBundleName,
      'maskState': this.transformAppManager.isTasteFreshApp(item.bundleName) ? 1 : 0,
      'appType': this.transformAppManager.isTasteFreshApp(item.bundleName) ? AppReserveType.TASTE_FRESH : AppReserveType.THIRD,
      'installSource': ''
    };
    // 开关打开且是主用户，可应用自动
    if (this.transformAppManager.getAutoMigrateAppType(false) === AutoMigrateType.MIGRATE &&
      this.isdeliverFolderApp(item.bundleName, legacyInfo)) {
      // 允许隐私空间克隆应用应用自动
      legacyInfo.installSource = DeliverUtil.DELIVER_APPSTORE_PKG;
      extendInfo.installSource = DeliverUtil.DELIVER_APPSTORE_PKG;
    } else if (this.transformAppManager.getAbroadAutoMigrateAppType() === AutoMigrateType.MIGRATE &&
      DEFAULT_USER === DataConvert.getCurUserId() && this.transformAppManager.isEasyAboardApp(item.bundleName)) {
      legacyInfo.installSource = DeliverUtil.APP_PKG;
      extendInfo.installSource = DeliverUtil.APP_PKG;
    }
    item.intent = JSON.stringify(extendInfo);
    item.callerName = MIGRATE_SERVER_PROCESS_NAME;
    if (!FileUtils.isExist(DataConvert.getOldIconPath(packageRelation.packageName))) {
      log.showWarn(TAG, 'not has icon in launcher db packageName:  %{public}s', packageRelation.packageName);
      DataConvert.saveNotHaveIconPackageNames(packageRelation.packageName);
    }
    item.iconResource = FILE_PRE + DataConvert.getOldIconPath(packageRelation.packageName);
    log.showInfo(TAG, `app reserve on desktop, bundleName: ${item.bundleName}, appIndex: ${item.appIndex}, screen: ${item.page}, ` +
      `container: ${item.container}, point: [${item.row}, ${item.column}], appType: ${extendInfo.appType}, ` +
      `appName: ${item.appName}, intent: ${item.intent}`);
  }

  public async transformBackupInfoToGridInfoOnClone(): Promise<GridLayoutItemInfo[]> {
    let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(this.backupInfo.intent);
    let packageName: string = IntentParseUtil.queryShortcutToAppMappingPackageName(this.backupInfo.intent);
    if (!CheckEmptyUtils.checkStrIsEmpty(packageName) && packageRelation) {
      packageRelation.packageName = packageName;
    }
    if (!packageRelation) {
      log.showError(TAG, 'the %{public}s clone failure as the intent %{public}s is error',
        this.backupInfo.title, this.backupInfo.intent);
      return [];
    }
    AddCardToNewPageManager.getInstance().addCardToNewPageApp(this.backupInfo, packageRelation);
    let item: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(this.backupInfo);
    let appItemInfo: AppItemInfo | CloneItemInfo | undefined =
      this.getAppItemInfoByIntent(packageRelation, item.appIndex);
    if (!appItemInfo) {
      let preOccupyInfo: CloneItemInfo | undefined =
        CloneItemInfoManager.getInstance()
          .getCloneItemInfoByPackageName(packageRelation.packageName, true, item.appIndex);
      if (!preOccupyInfo) {
        log.showError(TAG, 'the %{public}s clone failure as no preOccupy',
          this.backupInfo.title, this.backupInfo.intent);
        return [];
      }
      let bmsAppInfo: AppItemInfo | undefined =
        DataConvert.getAppItemInfoList().find(item => item.bundleName === preOccupyInfo?.bundleName &&
          (item?.appIndex ?? 0) === preOccupyInfo.appIndex);
      if (bmsAppInfo && bmsAppInfo.codePath === DeliverUtil.ohos_APPLICATION) {
        log.showInfo(TAG, `container app ${bmsAppInfo.bundleName} is available on both old and new machines`);
        DeliverUtil.setInstallSourceAndIntent(bmsAppInfo, bmsAppInfo.intent ?? '');
      }
      if (bmsAppInfo) {
        appItemInfo = bmsAppInfo;
      } else {
        appItemInfo = preOccupyInfo;
      }
    }
    if (appItemInfo instanceof AppItemInfo && !CheckEmptyUtils.checkStrIsEmpty(appItemInfo.shortcutId)) {
      await this.dealShortCutToGridLayoutItem(appItemInfo, item);
      log.showInfo(TAG, 'find the installed shortInfo bundleName: %{public}s, shortcutId: %{public}s, page: %{public}d, ' +
        'row: %{public}d, col: %{public}d, container: %{public}d', item.bundleName, item.shortcutId, item.page,
        item.row, item.column, item.container);
    } else if (appItemInfo instanceof AppItemInfo) {
      this.appItemToGridLayoutItem(appItemInfo, item);
      log.showInfo(TAG, 'find the installed appItemInfo bundleName: %{public}s, appindex: %{public}d, page: %{public}d, ' +
        'row: %{public}d, col: %{public}d, container: %{public}d', item.bundleName, item.appIndex, item.page,
        item.row, item.column, item.container);
    } else {
      this.dealWithUnInstalledAppItem(appItemInfo, item);
      log.showInfo(TAG, 'find the not installed appItemInfo bundleName: %{public}s, appindex: %{public}d, page: %{public}d, ' +
        'row: %{public}d, col: %{public}d, container: %{public}d', item.bundleName, item.appIndex, item.page,
        item.row, item.column, item.container);
    }
    return [item];
  }

  private isdeliverFolderApp(bundleName: string, legacyInfo: LegacyInfo): boolean {
    if (!this.transformAppManager.isdeliverApp(bundleName) && !this.transformAppManager.isOtherdeliverApp(bundleName)) {
      return false;
    }
    if (this.transformAppManager.getRgmSupportType(false) !== RgmSupport32Type.SUPPORT && !NotHarmonyUtil.isSupport64(legacyInfo)) {
      log.showWarn(TAG, `${bundleName} is 32bit app, not support in deliver folder`);
      return false;
    }
    return true;
  }

  private dealWithUnInstalledAppItem(appItemInfo: CloneItemInfo, item: GridLayoutItemInfo): void {
    item.typeId = CommonConstants.TYPE_APP;
    item.bundleName = appItemInfo.bundleName;
    item.keyName = appItemInfo.bundleName + item.appIndex;
    item.appStatus = AppStatus.PENDING;
    item.callerName = appItemInfo.callerName;
    if ((item.appIndex ?? 0) > 0) {
      item.appName = appItemInfo.title ?? '' + item.appIndex;
    } else {
      item.appName = appItemInfo.title;
    }
    item.downloadProgress = 0;
    item.iconResource = appItemInfo.iconUri;
    if (CommonUtils.isEmpty(item.iconResource) ||
      item.iconResource.indexOf(CommonConstants.DEFAULT_CLONE_ICON_URI) !== -1) {
      item.iconResource = DataConvert.getOldIconUri(appItemInfo.packageName);
    }
    if (appItemInfo.intent) {
      item.intent = appItemInfo.intent;
      let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(appItemInfo.intent);
      if (extendInfo.has(LY_INFO)) {
        item.appStatus = AppStatus.WAIT_FOR_HARMONY;
      }
    }
  }

  private appItemToGridLayoutItem(appItemInfo: AppItemInfo, item: GridLayoutItemInfo): void {
    item.bundleName = appItemInfo.bundleName;
    item.abilityName = appItemInfo.abilityName;
    item.moduleName = appItemInfo.moduleName;
    item.typeId = CommonConstants.TYPE_APP;
    item.badgeNumber = appItemInfo.badgeNumber;
    item.appIconId = appItemInfo.appIconId;
    item.appLabelId = appItemInfo.appLabelId;
    item.infoName = appItemInfo.appName;
    item.appStatus = AppStatus.INSTALLED;
    item.intent = appItemInfo.intent;
    item.appName = appItemInfo.appName;
  }

  private async dealShortCutToGridLayoutItem(appItemInfo: AppItemInfo, item: GridLayoutItemInfo): Promise<void> {
    let shortcutInfoList: ShortcutInfo[] =
      ShortcutViewModel.getInstance().getShortcutByBundleName(appItemInfo.bundleName);
    if (CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
      log.showError(TAG, `dealShortCutToGridLayoutItem ${appItemInfo.bundleName} shortcutInfo from Bundle Manager is empty`);
      this.appItemToGridLayoutItem(appItemInfo, item);
      return;
    }
    let shortcut: ShortcutInfo | undefined = shortcutInfoList.find(item => item.id === appItemInfo.shortcutId);
    if (!shortcut) {
      log.showError(TAG, `dealShortCutToGridLayoutItem ${appItemInfo.shortcutId} is not found in shortcutInfoList`);
      this.appItemToGridLayoutItem(appItemInfo, item);
      return;
    }
    if (!DataConvert.isShortcutInBMS(shortcut)) {
    }
    item.bundleName = appItemInfo.bundleName;
    item.abilityName = appItemInfo.abilityName;
    item.moduleName = appItemInfo.moduleName;
    item.badgeNumber = appItemInfo.badgeNumber;
    item.isSelect = false;
    item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
    item.shortcutId = shortcut.id;
    item.appIconId = shortcut.iconId ?? 0;
    item.appLabelId = shortcut.labelId;
    item.intent = `{"sourceType": ${shortcut.sourceType}}`;
    item.appStatus = AppStatus.INSTALLED;
    item.appName = await ResourceManager.getInstance().getBundleStringByIdSync(shortcut.labelId, shortcut.bundleName,
      shortcut.moduleName, shortcut.appIndex);
    item.keyName = AppItemInfo.getKeyName(item);
    this.backupInfo.itemType = CommonConstants.TYPE_SHORTCUT_ICON;
  }

  private getAppItemInfoByIntent(packageRelation: PackageRelation, sourceAppIndex: number = 0):
    AppItemInfo | undefined {
    if (!packageRelation) {
      return undefined;
    }
    let transferRelationInfo: TransferRelationModel | undefined = this.getTransferRelationModel(packageRelation);
    if (!transferRelationInfo) {
      log.showDebug(TAG, `no find app mapping relation, packageName: %{public}s, className: %{public}s`,
        packageRelation.packageName, packageRelation.className);
      return undefined;
    }
    let appItemInfo = DataConvert.getAppItemInfoList().find(
      item => item.bundleName === transferRelationInfo?.getTargetBundleName() &&
      (item?.appIndex ?? 0) === sourceAppIndex);
    if (appItemInfo) {
      appItemInfo.shortcutId = transferRelationInfo.getTargetShortcutId();
    }
    return appItemInfo;
  }

  private getTransferRelationModel(packageRelation: PackageRelation): TransferRelationModel | undefined {
    let transferRelationInfo: TransferRelationModel | undefined;
    if (this.backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_APP) {
      transferRelationInfo = transferRelationManager.getTransInfoForClass(packageRelation.packageName,
        packageRelation.className);
    } else {
      let transArray: Array<TransferRelationModel> =
        transferRelationManager.getTransInfosForPackage(packageRelation.packageName);
      if (transArray && transArray.length > 0) {
        transferRelationInfo = transArray[0];
      }
    }
    return transferRelationInfo;
  }

  private setMultiMappingRelationship(localHapMigrateInfo: LocalHapMigrateInfo, item: GridLayoutItemInfo): void {
    let isSpecialShortcutApp: boolean = Array.from(IntentParseUtil.SHORTCUT_TO_APP_MAP.values()).includes(
      localHapMigrateInfo.source);
    let extendInfo: IMultiMappingInfo = {
      'multiMappingRelationship': !CheckEmptyUtils.isEmptyArr(localHapMigrateInfo.sourceModules) || isSpecialShortcutApp ? 1 : 0,
      'appType': AppReserveType.THIRD
    };
    item.intent = JSON.stringify(extendInfo);
  }
}

export interface ILegacyInfo {
  legacyInfo: LegacyInfo;
  requestBundleName: string;
  maskState: number;
  appType: number;
  installSource: string;
}

export interface IMultiMappingInfo {
  'multiMappingRelationship':  number;
  'appType': number;
}