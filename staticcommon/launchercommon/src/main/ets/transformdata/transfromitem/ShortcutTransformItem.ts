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
  CheckEmptyUtils
} from '@ohos/basicutils';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { NumberConstants } from '@ohos/commonconstants';
import { ResourceManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { RestoreLauncherDataManager } from '../../manager/RestoreLauncherDataManager';
import {
  AppReserveType,
  AppStatus,
  CommonConstants,
  GridLayoutItemInfo,
  LocalHapMigrateInfo,
  TransformAppInfoManager,
  ShortcutInfo
} from '../../TsIndex';
import { CloneItemInfo } from '../../constants/CommonConstants';
import { IntentParseUtil, PackageRelation } from '../../utils/IntentParseUtil';
import DataConvert from '../DataConvert';
import { BaseTransformItem } from './BaseTransformItem';
import { AppItemInfo } from '../../bean/AppItemInfo';
import { CloneItemInfoManager } from '../manager/CloneItemInfoManager';
import { TransferRelationModel } from '../../model/TransferRelationModel';
import { transferRelationManager } from '../../manager/TransferRelationManager';
import { shortcutTransferRelationManager } from '../../manager/ShortcutTransferRelationManager';
import { ShortcutViewModel } from '../../launchericon/viewmodel/ShortcutViewModel';
import fileuri from '@ohos.file.fileuri';
import { IMultiMappingInfo } from './AppTransformItem';

const FILE_PRE: string = 'file://';
const TAG = 'ShortcutTransformItem';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

export class ShortcutTransformItem extends BaseTransformItem {
  public isSupportInohos(): boolean {
    // 系统迁移、克隆支持快捷方式
    return true;
  }

  public async transformBackupInfoToGridInfo(): Promise<GridLayoutItemInfo[]> {
    // 查询快捷方式到应用的映射 (例如：一键锁屏)
    let packageName: string = IntentParseUtil.queryShortcutToAppMappingPackageName(this.backupInfo.intent);
    log.showInfo(TAG, 'retained shortcut packageName = %{public}s', packageName);
    let isShortcutToApp: boolean = Array.from(IntentParseUtil.SHORTCUT_TO_APP_MAP.values()).includes(packageName);
    if (isShortcutToApp) {
      // 从三方映射表中查找应用信息
      let localHapMigrateInfo: LocalHapMigrateInfo | undefined =
        TransformAppInfoManager.getInstance().getMigrateByBundleAndType(packageName, AppReserveType.THIRD);
      if (!localHapMigrateInfo) {
        log.showError(TAG, 'shortcut not find from third relation');
        return [];
      }
      return this.getTransAppInfo(localHapMigrateInfo, packageName);
    }

    // 查询快捷方式数据库信息，转成可用信息
    let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(this.backupInfo.intent);
    if (!packageRelation) {
      log.showWarn(TAG, `the ${this.backupInfo.title} update failure as the intent ${this.backupInfo.intent} is error.`);
      return [];
    }
    // 查询快捷方式到快捷方式的映射
    let transferRelationInfo: TransferRelationModel | undefined = this.getShortcutRelationModel(packageRelation);
    if (!transferRelationInfo) {
      let keyName: string = `${packageRelation.packageName}_${this.backupInfo.title}_${packageRelation.shortcutId}`;
      log.showWarn(TAG, `the ${keyName} update failure as no relation`);
      return [];
    }
    return this.getTransShortcutInfo(transferRelationInfo);
  }

  private async getTransAppInfo(localHapMigrateInfo: LocalHapMigrateInfo, packageName: string): Promise<GridLayoutItemInfo[]> {
    // 构建新的对象
    let item: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(this.backupInfo);
    item.typeId = CommonConstants.TYPE_APP;
    item.bundleName = localHapMigrateInfo.target;
    item.keyName = localHapMigrateInfo.target + item.appIndex;
    item.appStatus = AppStatus.PENDING;
    item.appName = this.backupInfo.title;
    item.callerName = CommonConstants.SOURCE_UPGRADE;
    if (!FileUtils.isExist(DataConvert.getOldIconPath(packageName))) {
      log.showWarn(TAG, 'shortcut has no icon in launcher db, packageName %{public}s', packageName);
      DataConvert.saveNotHaveIconPackageNames(packageName);
    }
    item.iconResource = FILE_PRE + DataConvert.getOldIconPath(packageName);

    // 有应用和(单个或多个)快捷方式 || 多个快捷方式 --> 遵循多对一映射规则，优先将最靠前的元素替换
    let extendInfo: IMultiMappingInfo = {
      'multiMappingRelationship': NumberConstants.CONSTANT_NUMBER_ONE,
      'appType': AppReserveType.THIRD
    };
    item.intent = JSON.stringify(extendInfo);
    log.showInfo(TAG, `oneKeyShortCut transform app, bundleName: ${item.bundleName}, appIndex: ${item.appIndex}, screen: ${item.page}, ` +
      `container: ${item.container}, point: [${item.row}, ${item.column}], appName: ${item.appName}, iconResource: ${item.iconResource}`);
    return [item];
  }

  private async getTransShortcutInfo(transferRelationInfo: TransferRelationModel): Promise<GridLayoutItemInfo[]> {
    // 查询快捷方式对应的应用是否已安装
    let appItemInfo: AppItemInfo | undefined = DataConvert.getAppItemInfoList()
      .find(item => item.bundleName === transferRelationInfo.getTargetBundleName());
    let item: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(this.backupInfo);
    if (appItemInfo) {
      let shortcutInfoList: ShortcutInfo[] = ShortcutViewModel.getInstance().getShortcutByBundleName(appItemInfo.bundleName);
      if (CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
        log.showWarn(TAG, `app ${appItemInfo.bundleName} have no shortcut.`);
        return [];
      }
      // 查询应用的快捷方式列表是否有该快捷方式
      let shortcutName: string =
        transferRelationInfo.getTargetBundleName() + transferRelationInfo.getTargetShortcutId();
      let shortcut: ShortcutInfo | undefined =
        shortcutInfoList.find(item => item.id === transferRelationInfo.getTargetShortcutId());
      if (!shortcut) {
        log.showWarn(TAG, `shortcut ${shortcutName} is not found in shortcutInfoList`);
        return [];
      }
      // 向BMS添加快捷方式信息
      await this.addShortcutToBMS(shortcut, appItemInfo);
      await this.dealWithInstalledAppShortcut(item, appItemInfo, shortcut);
      log.showInfo(TAG, `installed app shortcutInfo: ${item.bundleName}_${item.shortcutId}_${shortcutName}, ` +
        `appIndex: ${item.appIndex}, screen: ${item.page}, container: ${item.container}, point: [${item.row}, ${item.column}]`);
    } else {
      await this.dealWithUnInstalledAppShortcut(item, transferRelationInfo, true);
      log.showInfo(TAG, `not installed app shortcutInfo: ${item.bundleName}_${item.shortcutId}, ` +
        `appIndex: ${item.appIndex}, screen: ${item.page}, container: ${item.container}, point: [${item.row}, ${item.column}]`);
    }
    return [item];
  }

  public async transformBackupInfoToGridInfoOnClone(): Promise<GridLayoutItemInfo[]> {
    // 查询快捷方式数据库信息，转成可用信息
    let packageRelation: PackageRelation | null = IntentParseUtil.getComponentByIntent(this.backupInfo.intent);
    if (!packageRelation) {
      log.showWarn(TAG, `the ${this.backupInfo.title} clone failure as the intent ${this.backupInfo.intent} is error`);
      return [];
    }

    // 查询快捷方式的映射
    let keyName: string = packageRelation.packageName + '_' + this.backupInfo.title + '_' + packageRelation.shortcutId;
    let transferRelationInfo: TransferRelationModel | undefined = this.getShortcutRelationModel(packageRelation);
    if (!transferRelationInfo) {
      log.showWarn(TAG, `the ${keyName} clone failure as no relation`);
      return [];
    }

    // 查询快捷方式是否有对应的应用(占位信息或应用映射表)
    let shortcutItem: GridLayoutItemInfo = this.buildGridInfoByBackupInfo(this.backupInfo);
    let cloneApp: CloneItemInfo | undefined =
      this.getAppItemInfo(transferRelationInfo.getTargetBundleName(), shortcutItem.appIndex);
    if (!cloneApp) {
      log.showWarn(TAG, `the ${keyName} clone failure as no appInfo`);
      return [];
    }

    // 查询快捷方式对应的应用是否已安装
    let appItemInfo: AppItemInfo | undefined = DataConvert.getAppItemInfoList()
      .find(item => item.bundleName === cloneApp?.bundleName && (item.appIndex ?? 0) === cloneApp.appIndex);
    if (appItemInfo) {
      let shortcutInfoList: ShortcutInfo[] =
        ShortcutViewModel.getInstance().getShortcutByBundleName(appItemInfo.bundleName);
      if (CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
        log.showWarn(TAG, `app ${appItemInfo.bundleName} have no shortcut`);
        return [];
      }

      // 查询应用的快捷方式列表是否有该快捷方式
      let shortcutName: string =
        transferRelationInfo.getTargetBundleName() + transferRelationInfo.getTargetShortcutId();
      let shortcut: ShortcutInfo | undefined =
        shortcutInfoList.find(item => item.id === transferRelationInfo?.getTargetShortcutId());
      if (!shortcut) {
        log.showWarn(TAG, `shortcut ${shortcutName} is not found in shortcutInfoList`);
        return [];
      }

      // 向BMS添加快捷方式信息
      await this.addShortcutToBMS(shortcut, appItemInfo);
      await this.dealWithInstalledAppShortcut(shortcutItem, appItemInfo, shortcut);
      log.showInfo(TAG, `find the installed shortcutInfo: ${shortcutName}`);
    } else {
      await this.dealWithUnInstalledAppShortcut(shortcutItem, transferRelationInfo);
      log.showInfo(TAG, `find the not installed shortcutInfo: ${shortcutItem.bundleName}_${shortcutItem.shortcutId}`);
    }
    this.backupInfo.itemType = CommonConstants.TYPE_SHORTCUT_ICON;
    return [shortcutItem];
  }

  /**
   * 向BMS添加已安装应用的快捷方式
   * 由于布局缓存只能查出来主应用的快捷方式信息，需要修正分身快捷方式的index字段再向BMS添加
   *
   * @param shortcutInfo 布局缓存中的快捷方式信息
   * @param item 快捷方式对应的应用
   */
  private async addShortcutToBMS(shortcutInfo: ShortcutInfo, item: AppItemInfo): Promise<void> {
    let addShortcut: ShortcutInfo = ObjectCopyUtil.simpleClone(shortcutInfo);
    addShortcut.appIndex = item.appIndex ?? CommonConstants.MAIN_APP_INDEX;
    await ShortcutViewModel.getInstance().addShortcutToBMS(addShortcut);
  }

  private async dealWithInstalledAppShortcut(item: GridLayoutItemInfo, appItemInfo: AppItemInfo,
    shortcut: ShortcutInfo): Promise<void> {
    item.bundleName = shortcut.bundleName;
    item.abilityName = appItemInfo.abilityName;
    item.moduleName = appItemInfo.moduleName;
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
  }

  /**
   * 处理未安装应用的快捷方式
   *
   * @param item 快捷方式item
   * @param relation 快捷方式映射关系
   * @param isUpdate 是否升级场景
   */
  private async dealWithUnInstalledAppShortcut(item: GridLayoutItemInfo, relation: TransferRelationModel,
    isUpdate?: boolean): Promise<void> {
    item.bundleName = relation.getTargetBundleName();
    item.appName = this.backupInfo.title;
    item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
    item.appStatus = AppStatus.PENDING;
    item.shortcutId = relation.getTargetShortcutId();
    item.moduleName = relation.getTargetModuleName();
    item.abilityName = relation.getTargetAbilityName();
    item.keyName = AppItemInfo.getKeyName(item);
    item.iconResource = isUpdate ? await this.getIconFromUpdate(relation) : await this.getIconFromClone(relation);
  }

  private async getIconFromUpdate(relation: TransferRelationModel): Promise<string> {
    let iconResource: string = '';
    let shortcutKey: string = `${relation.getSourcePackageName()}#${relation.getSourceShortcutId()}`;
    let iconPath: string = DataConvert.getOldIconShortcutPath(shortcutKey);
    if (FileUtils.isExist(iconPath)) {
      // iconPath中特殊符号需要调用fileuri来转义
      let dstUriObject: fileuri.FileUri = new fileuri.FileUri(iconPath);
      log.showInfo(TAG, `getIconFromUpdate dstUriObject: ${dstUriObject.toString()}`);
      let base64Str: string = await RestoreLauncherDataManager.getInstance().getShortcutIcon(dstUriObject.toString());
      iconResource = !CheckEmptyUtils.checkStrIsEmpty(base64Str) ? base64Str : dstUriObject.toString();
    }
    return iconResource;
  }

  private async getIconFromClone(relation: TransferRelationModel): Promise<string> {
    let icon: string = '';
    let keyname = relation.getSourcePackageName() + relation.getSourceShortcutId();
    let cloneItem: CloneItemInfo | undefined =
      CloneItemInfoManager.getInstance().getCloneItemInfoByBundleName(keyname);
    if (cloneItem && !CheckEmptyUtils.checkStrIsEmpty(cloneItem.iconUri)) {
      icon = await RestoreLauncherDataManager.getInstance().getShortcutIcon(cloneItem.iconUri) ??
      cloneItem.iconUri;
    }
    return icon;
  }

  private getAppItemInfo(bundleName: string, sourceAppIndex: number = 0): CloneItemInfo | undefined {
    let cloneItem: CloneItemInfo | undefined;
    cloneItem = CloneItemInfoManager.getInstance().getCloneItemInfoByBundleName(bundleName, sourceAppIndex);
    if (cloneItem) {
      return cloneItem;
    }
    if (transferRelationManager.isRelationApp(bundleName)) {
      let appItemInfo = DataConvert.getAppItemInfoList()
        .find(item => item.bundleName === bundleName && (item.appIndex ?? 0) === sourceAppIndex);
      if (appItemInfo) {
        cloneItem = {
          bundleName: appItemInfo.bundleName,
          appIndex: appItemInfo.appIndex
        } as CloneItemInfo;
      }
    }
    return cloneItem;
  }

  private getShortcutRelationModel(packageRelation: PackageRelation): TransferRelationModel | undefined {
    let shortcutKeyName: string = packageRelation.packageName + packageRelation.className + packageRelation.shortcutId;
    return shortcutTransferRelationManager.getTransInfoForShortCut(shortcutKeyName);
  }
}