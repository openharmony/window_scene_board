/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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

import systemparameter from '@ohos.systemparameter';
import {
  ArrayUtils,
  CheckEmptyUtils,
  LogDomain,
  Logger,
  CommonUtils
} from '@ohos/basicutils';
import {
  GlobalContext,
  ResourceManager,
  GraphicUtils, SettingsUtil
} from '@ohos/frameworkwrapper';
import {
  SCBSceneContainerSession,
  SCBSceneSessionManager,
  StartAbilityUtil
} from '@ohos/windowscene';
import { AppModel } from '../model/AppModel';
import { AppStatus, CommonConstants } from '../constants/CommonConstants';
import {
  AppItemInfo,
  AppInstallUtils,
  DisappearLastAppData,
  DockItemInfo,
  FolderItemInfo,
  FolderLayoutCacheManager,
  FolderLayoutStruct,
  FolderModel,
  FolderViewModel,
  GridLayoutItemInfo,
  GridLayoutUtil,
  LayoutViewModel,
  RdbStoreManager,
  LegacyInfo,
  EditModeState,
  editModeManager,
  LaunchLayoutCacheManager,
  AppGalleryDownloadManager,
  AppReserveType,
  ResidentLayoutCacheMgr,
  FoldersData,
  FolderManager,
  InstalledDialogType,
} from '../TsIndex';
import { PreInstallUtils } from './PreInstallUtils';
import systemParameterEnhance from '@ohos.systemParameterEnhance';
import bundleManager from '@ohos.bundle.bundleManager';
import { preferences } from '@kit.ArkData';
import { NotHarmonyUtil } from './NotHarmonyUtil';
import { BaseDeliverUtil } from './BaseDeliverUtil';
import type ctx from '@ohos.app.ability.common';
import { FolderEventConstants } from '../constants/FolderEventConstants';
import { Want } from '@kit.AbilityKit';
import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import { ObjectCopyUtil } from '@ohos/componenthelper';
// import abilityFrameworkBroker from '@ohos.virtService.abilityFrameworkBroker';

const TAG = 'DeliverUtil';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);
const HEXADECIMAL_VALUE = 36;
const KEY_NOT_FOUND_ERROR_CODE = 14700101;
const KEY_INSTALL_SOURCE = 'installSource';
const KEY_NAME = 'name';
const MAX_DELIVERY_SIZE = 50 * 1024;
const DELIVER_NO_EXIST_EASY_NO_EXIST = '0';
const DELIVER_EXIST_EASY_NO_EXIST = '1';
const DELIVER_NO_EXIST_EASY_EXIST = '2';
const DELIVER_EXIST_EASY_EXIST = '3';
export const DELIVER_FOLDERNAME = '${app_others}';
export const ABROAD_APP_FOLDERNAME = '应用';

export class DeliverUtil {
  public static ohos_APPLICATION = '1';
  public static LINUX_APPLICATION = '2';
  public static DELIVER_START_FINISHED_CODE = '1000';
  public static DELIVER_APP_BUNDLE_NAME = 'com.deliver.iapps'; // 克隆应用临时包名
  public static DELIVER_APP_BUNDLE_NAME_REAL = 'com.deliver.tong'; // 克隆应用正式包名
  public static APPMARKET_BUNDLE_NAME = 'com.openharmony.appmarket'; // 应用市场包名
  public static DELIVER_APP_MODULE_NAME = 'entry';
  public static DELIVER_APP_ABILITY_NAME = 'EntryAbility';
  public static ABROAD_APP_APP_BUNDLE_NAME = 'com.ohos.abroadHarmony.temp'; // 应用临时包名
  public static ABROAD_APP_APP_BUNDLE_NAME_REAL = 'com.ohos.abroad'; // 应用正式包名
  public static ABROAD_APP_APP_ABILITY_NAME = 'EntryAbility';
  public static ABROAD_APP_PKG = 'com.ohos.abroad'; // 应用应用市场包名
  public static DELIVER_APPSTORE_PKG = 'com.deliver.appstore.lite'; // 应用市场包名
  public static DELIVER_APPSTORE_CLASS = 'com.deliver.appstore.lite.main.MainActivity';
  public static WAIT_FOR_HARMONY_PREFIX = '__WAIT_FOR_HARMONY_BUNDLENAME__';
  public static CONTAINER_INSTALL_STATUS = 'container_app_installed_status';
  public static DELIVER_APP_MAP = new Map([
    [DeliverUtil.DELIVER_APP_BUNDLE_NAME, DeliverUtil.DELIVER_APPSTORE_PKG],
    [DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL, DeliverUtil.DELIVER_APPSTORE_PKG],
    [DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME, DeliverUtil.ABROAD_APP_PKG],
    [DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL, DeliverUtil.ABROAD_APP_PKG]
  ]);

  public static FOLDER_TYPE_COMMON = 0; //普通文件夾
  public static FOLDER_TYPE_NOTHARMONY = 1; //非鸿蒙化文件夹
  public static FOLDER_TYPE_DELIVER = 2; //文件夹
  public static FOLDER_TYPE_EASY = 3; //文件夹
  public static FOLDER_TYPE_NOTFOLDER = -1; //非文件夹
  public static APPTYPE_COMMON = 0; //正常应用，可直接打开,
  public static APPTYPE_TYPE_NOTHARMONY = 1; //未鸿蒙化应用（未安装）
  public static APPTYPE_TYPE_DELIVER = 2; //
  public static APPTYPE_TYPE_EASY = 3; //
  public static APPTYPE_TYPE_GRAY = 4; //置灰的预装应用
  public static APPTYPE_TYPE_NONE = -1; //均不是
  public static CLICK_KNOW: string = 'Click Know'; //点击'知道了'按钮
  public static CLICK_BLANK_AREA: string = 'Click Blank Area'; //点击空白区域
  public static CLICK_CANCEL: string = 'Click Cancel'; //点击取消
  public static CLICK_UNINSTALL: string = 'Click Uninstall'; //点击卸载
  public static CLICK_CONFIRM: string = 'Click Confirm'; //点击确认
  public static CLICK_IGNORE: string = 'Click Ignore'; //点击忽略
  public static CLICK_UPDATE: string = 'Click Update'; //点击立即更新
  public static CLICK_OPEN_NEXT: string = 'Click Open Next Version'; //点击立即更新
  public static DIALOG_TYPE_NEW_VERSION: number = 0; //弹窗类型：下载新版本
  public static DIALOG_TYPE_UNINSTALL: number = 1; //弹窗类型：已，卸载版本
  public static DIALOG_TYPE_UNAVAILABLE: number = 2; //弹窗类型：应用暂不可用，下载环境
  public static DIALOG_TYPE_WAIT_DOWNLOAD: number = 3; //弹窗类型：等待下载中，是否优先下载
  public static DIALOG_TYPE_PAUSE_DOWNLOAD: number = 4; //弹窗类型：下载暂停，是否继续下载
  public static DIALOG_TYPE_INSTALLING: number = 5; //弹窗类型：下载中，请稍后
  public static DIALOG_TYPE_NEXT_VERSION: number = 6; //弹窗类型：已，打开鸿蒙版本
  public static CANCEL_DELIVER_FOLDER: boolean =
    systemparameter.getSync('const.deliver.cancel_deliver_folder', 'true') === 'true';

  static containerFolderMap = BaseDeliverUtil.getContainerFolderMap();
  private static isFolderCreating: boolean = false;
  private static isShowToastRepeat: boolean = true;
  private static isDragLeave: boolean = false;
  private static disableOperationsOnFolder: string = systemparameter.getSync('const.deliver.operations_on_folder', 'true');
  private static addIconGeometryId: string = '';
  private static appBundleNameFoundInDock: string = '';
  private static ABROAD_APP_CLASS: string = 'com.ohos.abroad.activities.MainActivity';
  private static APP_IDENTIFIER_MAP = new Map([
    [DeliverUtil.DELIVER_APP_BUNDLE_NAME, '5765880207854232697'],
    [DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL, '5765880207855132255'],
    [DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME, '5765880207854567265'],
    [DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL, '5765880207855325039']
  ]);
  private static editModeState: EditModeState = editModeManager.getEditModeState();
  private static DELIVER_TRANSFER_BUNDLE_NAME: string = 'com.deliver.appstore.transfer'; // 克隆应用预置应用：文件共享
  private static DELIVER_BROWSER_BUNDLE_NAME: string = 'com.deliver.browser'; // 克隆应用预置应用：搜应用
  private static ABROAD_APP_TRANSFER_BUNDLE_NAME: string = 'com.ohos.transfer.abroad'; // 应用预置应用：文件共享
  private static ABROAD_APP_FEEDBACK_BUNDLE_NAME: string = 'com.ohos.feedback.abroad'; // 应用预置应用：小易客服
  public static PREINSTALLED_APP_SET = new Set([
    DeliverUtil.DELIVER_TRANSFER_BUNDLE_NAME,
    DeliverUtil.DELIVER_BROWSER_BUNDLE_NAME,
    DeliverUtil.ABROAD_APP_TRANSFER_BUNDLE_NAME,
    DeliverUtil.ABROAD_APP_FEEDBACK_BUNDLE_NAME
  ]);
  public static DELIVER_PREINSTALLED_APP_SET = new Set([
    DeliverUtil.DELIVER_TRANSFER_BUNDLE_NAME,
    DeliverUtil.DELIVER_BROWSER_BUNDLE_NAME
  ]);
  public static ABROAD_APP_PREINSTALLED_APP_SET = new Set([
    DeliverUtil.ABROAD_APP_TRANSFER_BUNDLE_NAME,
    DeliverUtil.ABROAD_APP_FEEDBACK_BUNDLE_NAME
  ]);

  public static DEFAULT_DELIVER_APP_SORT = DeliverUtil.createDeliverAppMap();

  static isSupportDeliver(): boolean {
    let oldParam: string = systemparameter.getSync('const.app_eco.support_ohos', 'default');
    let newParam: string = systemparameter.getSync('persist.ohos_fusion_mgr.ctl.support_ohos', 'default');
    log.showDebug(TAG, 'get default const.app_eco.support_ohos: ' + oldParam +
      ' get default persist.ohos_fusion_mgr.ctl.support_ohos: ' + newParam);

    return oldParam === 'true' || newParam === 'true';
  }

  static isSupportAppType(bundleName: string): boolean {
    let res: string = AppModel.getInstance().getAppInfoByBundleName(bundleName)?.codePath ?? '';
    return res === DeliverUtil.ohos_APPLICATION || res === DeliverUtil.LINUX_APPLICATION;
  }

  /**
   * In outDeskTop, Determine if an app is a support app.
   * @param bundleName
   * @returns True is yes, false is no.
   */
  static isSupportAppTypeInOut(bundleName: string): boolean {
    let res: string = AppModel.getInstance().getAppInfoByBundleName(bundleName)?.codePath ?? '';
    try {
      if (CheckEmptyUtils.isEmpty(res)) {
        res = bundleManager.getApplicationInfoSync(bundleName,
          bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)?.codePath;
      }
    } catch (err) {
      log.showError(TAG, `get codePath error: ${err.message}`);
      return false;
    }
    return res === DeliverUtil.ohos_APPLICATION || res === DeliverUtil.LINUX_APPLICATION;
  }

  /**
   * Specifies whether to disable some folder operations, such as renaming and dragging
   * @param folderId folderId
   * @returns True is yes, false is no.
   */
  static isDisableOperationsOnFolder(folderId: string, intent?: string, bundleName?: string): boolean {
    log.showInfo(TAG, `disableOperationsOnFolder folderId = ${folderId}, intent = ${intent}, bundleName = ${bundleName}`);
    // 克隆应用预置应用禁止支持拖入拖出
    if (DeliverUtil.DEFAULT_DELIVER_APP_SORT.has(bundleName ?? '')) {
      return true;
    }
    if (!CommonUtils.isEmpty(intent)) {
      // 克隆应用内非预置应用支持拖入拖出克隆应用文件夹, 克隆应用应用不可拖入定制文件夹，非定制应用不可拖入克隆应用文件夹
      if (DeliverUtil.isdeliverApp(intent ?? '')) {
        if (CheckEmptyUtils.isEmpty(folderId)) {
          return false;
        }
        return DeliverUtil.containerFolderMap.get(DeliverUtil.ABROAD_APP_PKG) === folderId ||
          NotHarmonyUtil.mNotHarmonyFolderId === folderId;
      }
      if (!DeliverUtil.isContainerItem(intent ?? '') && DeliverUtil.isContainerFolder(folderId)) {
        return true;
      }
      return DeliverUtil.disableOperationsOnFolder === 'true' && DeliverUtil.isContainerItem(intent ?? '');
    }
    return DeliverUtil.disableOperationsOnFolder === 'true' && DeliverUtil.isContainerFolder(folderId);
  }

  /**
   * check folder is released.
   *
   * @param folderId
   * @param appsLength
   * @returns true is released, false not.
   */
  static checkFolderIsReleased(folderId: string | undefined, appsLength: number): boolean {
    return appsLength <= 0 || (appsLength === CommonConstants.FOLDER_APP_VALUE &&
      !DeliverUtil.isContainerFolder(folderId ?? ''));
  }

  /**
   * check folder is one or greater than one.
   *
   * @param folderId
   * @param appsLength
   * @returns true is more apps, false not.
   */
  static checkFolderIsOneMoreApps(folderId: string | undefined, appsLength: number): boolean {
    return appsLength > CommonConstants.FOLDER_APP_VALUE ||
      (appsLength === CommonConstants.FOLDER_APP_VALUE && DeliverUtil.isContainerFolder(folderId ?? ''));
  }

  /**
   * check whether the container folder is being created.
   * @param folderId folder Id
   * @returns True is yes, false is no.
   */
  static isCreateFolder(folderItem: GridLayoutItemInfo): boolean {
    if (!folderItem || !folderItem.layoutInfo || folderItem.layoutInfo.length === 0) {
      return false;
    }
    if (!DeliverUtil.isContainerFolder(folderItem.folderId ?? '')) {
      return false;
    }
    return DeliverUtil.isFolderCreating && folderItem.layoutInfo[0].length === 1;
  }

  /**
   * set is creating folder
   * @param isFolderCreating is folder creating
   */
  static setIsCreateFolder(isFolderCreating: boolean): void {
    DeliverUtil.isFolderCreating = isFolderCreating;
  }

  /**
   * is show toast
   * @returns True is yes, false is no.
   */
  static isShowToast(): boolean {
    if (DeliverUtil.isShowToastRepeat) {
      DeliverUtil.isShowToastRepeat = false;
      setTimeout(() => {
        DeliverUtil.isShowToastRepeat = true;
      }, 1500);
      return true;
    }
    return DeliverUtil.isShowToastRepeat;
  }

  /**
   * add add icon for folder
   *
   * @param folderItem.
   * @param method name
   * @returns folderItem.
   */
  static addAddIcon(folderItem: GridLayoutItemInfo | DockItemInfo, method: string): GridLayoutItemInfo | DockItemInfo {
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showWarn(TAG, 'addAddIcon return for simple mode from method = %{public}', method);
      return folderItem;
    }
    if (AppStorage.get<boolean>('isAddIconHidden') ?? false) {
      log.showWarn(TAG, 'cannot add AddIcon during dragging from method = ' + method);
      return folderItem;
    }
    if (!GridLayoutUtil.isFolderItemValid(folderItem)) {
      log.showError(TAG, 'addAddIcon failed, folderItem invalid');
      return folderItem;
    }
    if (NotHarmonyUtil.isNotHarmonyFolderById((folderItem as GridLayoutItemInfo)?.folderId ?? '')) {
      log.showWarn(TAG, 'cannot add AddIcon to notHarmony folder ' + method);
      return folderItem;
    }
    if (folderItem.layoutInfo && folderItem.layoutInfo.length === 0) {
      return folderItem;
    }
    const isInContainerFolder =
      DeliverUtil.isContainerFolder((folderItem as GridLayoutItemInfo)?.folderId ?? '') ||
      DeliverUtil.isContainerFolder((folderItem as DockItemInfo)?.appId ?? '');
    if (isInContainerFolder && !DeliverUtil.isSupportDeliver()) {
      log.showWarn(TAG, 'addAddIcon failed, last icon is addIcon.');
      return folderItem;
    }
    if (isInContainerFolder && DeliverUtil.editModeState.isInEditMode()) {
      log.showWarn(TAG, 'addAddIcon failed, not allowed to add addIcon in editMode in DH.');
      return folderItem;
    }
    if (folderItem.layoutInfo) {
      const lastPageItem = folderItem.layoutInfo[folderItem.layoutInfo.length - 1];
      if (GridLayoutUtil.isAddIcon(lastPageItem[lastPageItem.length - 1])) {
        log.showWarn(TAG, 'addAddIcon failed, last icon is addIcon.');
        return folderItem;
      }
    }

    DeliverUtil.delAddIcon(folderItem, 'addAddIcon');
    DeliverUtil.addAddIconToLayoutInfo(folderItem.layoutInfo ?? [], method,
      (folderItem as GridLayoutItemInfo).folderId);
    AppStorage.setOrCreate('isAddIcon', true);
    return folderItem;
  }

  /**
   * 添加 + 号到文件夹数据中
   *
   * @param layoutInfo 二维数组
   * @param method 调用此方法的方法名
   * @param folderId 文件夹Id
   */
  static addAddIconToLayoutInfo(layoutInfo: GridLayoutItemInfo[][], method: string, folderId?: string): void {
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showWarn(TAG, 'addAddIcon return for simple mode from method = %{public}', method);
      return;
    }
    // 文件夹已满则不添加 +
    if (!DeliverUtil.isContainerFolder(folderId ?? '') && FolderViewModel.isLayoutFull(layoutInfo)) {
      log.showInfo(TAG, 'addAddIconToLayoutInfo full, folderId: ' + folderId);
      return;
    }
    // 编辑模式备份文件夹内不显示加号
    if (DeliverUtil.isContainerFolder(folderId ?? '') && DeliverUtil.editModeState.isInEditMode()) {
      log.showWarn(TAG, 'addAddIcon failed, not allowed to add addIcon in editMode in DH.');
      return;
    }
    let openFolderConfig: FolderLayoutStruct = FolderModel.getInstance().getFolderOpenLayout();
    let column: number = openFolderConfig.column;
    let row: number = openFolderConfig.row;
    let addInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
    addInfo.typeId = CommonConstants.TYPE_ADD;
    addInfo.bundleName = CommonConstants.SCENEBOARD_BUNDLE;
    addInfo.keyName = FolderEventConstants.KEY_FOLDER_ADD + folderId;
    let disappearLastAppData: DisappearLastAppData =
      AppStorage.get('disappearLastAppData') as DisappearLastAppData ?? ({} as DisappearLastAppData);
    let lastPage: GridLayoutItemInfo[] = layoutInfo[layoutInfo.length - 1];
    if (lastPage.length === column * row) {
      if (lastPage[lastPage.length - 1].keyName === disappearLastAppData.hiddenAppKeyName &&
        folderId === disappearLastAppData.folderId) {
        let popItem: GridLayoutItemInfo = lastPage.pop() as GridLayoutItemInfo;
        lastPage.push(addInfo);
        layoutInfo.push([popItem]);
      } else {
        layoutInfo.push([addInfo]);
      }
    } else {
      if (lastPage[lastPage.length - 1].keyName === disappearLastAppData.hiddenAppKeyName &&
        folderId === disappearLastAppData.folderId) {
        lastPage.splice(lastPage.length - 1, 0, addInfo);
      } else {
        lastPage.push(addInfo);
      }
    }
    log.showDebug(TAG, 'addAddIconToLayoutInfo success from ' + method);
  }

  /**
   * delete add icon for folder
   *
   * @param folderItem.
   * @param method name
   * @returns folderItem.
   */
  static delAddIcon(folderItem: GridLayoutItemInfo | DockItemInfo, method: string): GridLayoutItemInfo | DockItemInfo {
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showWarn(TAG, 'delAddIcon return for simple mode from method = %{public}', method);
      return folderItem;
    }
    if (!GridLayoutUtil.isFolderItemValid(folderItem)) {
      log.showError(TAG, 'delAddIcon failed. folderItem invalid');
      return folderItem;
    }

    if (folderItem.layoutInfo && folderItem.layoutInfo.length === 0) {
      return folderItem;
    }
    folderItem.layoutInfo = DeliverUtil.delAddIconFromLayoutInfo(folderItem.layoutInfo ?? [], method);
    AppStorage.setOrCreate('isAddIcon', false);
    return folderItem;
  }

  /**
   * 从文件夹数据中删除 + 号
   *
   * @param layoutInfo 二维数组
   * @param method 调用此方法的方法名
   */
  private static delAddIconFromLayoutInfo(layoutInfo: GridLayoutItemInfo[][], method: string): GridLayoutItemInfo[][] {
    let addPageIndex: number = -1;
    outFor: for (let pageIndex = 0; pageIndex < layoutInfo.length; pageIndex++) {
      for (let i = 0; i < layoutInfo[pageIndex].length; i++) {
        if (GridLayoutUtil.isAddIcon(layoutInfo[pageIndex][i])) {
          addPageIndex = pageIndex;
          layoutInfo[pageIndex].splice(i, 1);
          log.showInfo(TAG, 'delAddIcon success from ' + method);
          break outFor;
        }
      }
    }
    if (addPageIndex >= 0 && layoutInfo[addPageIndex].length === 0) {
      layoutInfo.splice(addPageIndex, 1);
    }
    return layoutInfo;
  }

  /**
   * delete addIcon for open folder
   *
   * @param folderItem
   * @returns {any} folderItem.
   */
  static delAddIconForOpenFolderData(folderItem: GridLayoutItemInfo): GridLayoutItemInfo {
    let hasAddIcon: boolean = folderItem?.layoutInfo?.flat()
      .findIndex(item => GridLayoutUtil.isAddIcon(item)) !== CommonConstants.INVALID_VALUE;
    if (hasAddIcon) {
      folderItem = DeliverUtil.delAddIcon(folderItem, 'delAddIconForOpenFolderData') as GridLayoutItemInfo;
    }
    return folderItem;
  }

  /**
   * add addIcon for dock folder
   *
   * @param folderId
   * @param isAdd is add or delete
   */
  static addAddIconForResidentList(folderId: string): void {
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showWarn(TAG, 'addAddIconForResidentList return for simple mode');
      return;
    }
    if (NotHarmonyUtil.isNotHarmonyFolderById(folderId)) {
      log.showWarn(TAG, 'cannot add AddIcon to notHarmony folder');
      return;
    }
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let folderIndex: number = residentList.findIndex(item => {
      return item.appId === folderId;
    });
    let hasAddIcon: boolean = residentList[folderIndex]?.layoutInfo?.flat()
      .findIndex(item => GridLayoutUtil.isAddIcon(item)) !== CommonConstants.INVALID_VALUE;
    if (!hasAddIcon) {
      residentList[folderIndex] =
        DeliverUtil.addAddIcon(residentList[folderIndex], 'addAddIconForResidentList') as DockItemInfo;
      LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_add'), residentList);
    }
  }

  /**
   * delete add icon for dock folder
   *
   * @param residentList
   * @param folderIndex
   */
  static delAddIconForResidentList(residentList: DockItemInfo[], folderIndex: number): void {
    let hasAddIcon: boolean = residentList[folderIndex]?.layoutInfo?.flat()
      .findIndex(item => GridLayoutUtil.isAddIcon(item)) !== CommonConstants.INVALID_VALUE;
    if (hasAddIcon) {
      residentList[folderIndex] =
        DeliverUtil.delAddIcon(residentList[folderIndex], 'delAddIconForResidentList') as DockItemInfo;
      LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_del'), residentList);
    }
  }

  /**
   * handle click event.
   *
   */
  static handleOnClicked(folderId: string): void {
    let easyAbroadFolderId = DeliverUtil.containerFolderMap.get(DeliverUtil.ABROAD_APP_PKG);
    let abilityName = easyAbroadFolderId === folderId ? DeliverUtil.ABROAD_APP_CLASS : DeliverUtil.DELIVER_APPSTORE_CLASS;
    let bundleName = easyAbroadFolderId === folderId ? DeliverUtil.ABROAD_APP_PKG : DeliverUtil.DELIVER_APPSTORE_PKG;
    let moduleName = 'entry';
    let params: Map<string, Object> = new Map();
    let otherParams: Map<string, Object> = new Map();
    if (DeliverUtil.getDeliverStartStatus() !== DeliverUtil.DELIVER_START_FINISHED_CODE) {
      otherParams.set('realBundleName', bundleName);
      otherParams.set('realAbilityName', abilityName);
      otherParams.set('realModuleName', moduleName);
      bundleName = DeliverUtil.getTargetBundleName(easyAbroadFolderId === folderId);
      if (!DeliverUtil.verifyContainerAppIdentifier(bundleName, 'handleOnClicked')) {
        return;
      }
      abilityName = easyAbroadFolderId === folderId ? DeliverUtil.ABROAD_APP_APP_ABILITY_NAME : DeliverUtil.DELIVER_APP_ABILITY_NAME;
      moduleName = DeliverUtil.DELIVER_APP_MODULE_NAME;
    }
    StartAbilityUtil.startLauncherAbility(abilityName, bundleName, moduleName, params, undefined, otherParams);
  }

  private static getTargetBundleName(isEasyAbroadFolder: boolean): string {
    let bundleName: string = '';
    if (isEasyAbroadFolder) {
      bundleName = AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL) ?
      DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL : DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME;
    } else {
      bundleName = AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL) ?
      DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL : DeliverUtil.DELIVER_APP_BUNDLE_NAME;
    }
    log.showInfo(TAG, `getTargetBundleName, bundleName = ${bundleName}`);
    return bundleName;
  }

  /**
   * check if the last app is addicon.
   *
   * @param folderItem
   * @returns true last app is addicon, false not.
   */
  static isLastAppAddIcon(folderItem: FolderItemInfo | GridLayoutItemInfo): boolean {
    if (folderItem === undefined || folderItem?.layoutInfo === undefined || folderItem?.layoutInfo.length <= 0) {
      return false;
    }
    if (LayoutViewModel.getInstance().isSimpleLauncherMode()) {
      log.showWarn(TAG, 'isLastAppAddIcon return for simple mode');
      return false;
    }
    let firstPageAppList = folderItem?.layoutInfo[0];
    if (firstPageAppList.length <= 0) {
      return false;
    }
    const openFolderConfig = FolderModel.getInstance().getFolderOpenLayout();
    const column = openFolderConfig.column;
    const row = openFolderConfig.row;
    let isFoundSuccess: boolean;
    if (firstPageAppList.length === column * row) {
      isFoundSuccess = GridLayoutUtil.isAddIcon(firstPageAppList[firstPageAppList.length - 1] as GridLayoutItemInfo);
    } else {
      isFoundSuccess = firstPageAppList.length < column * row;
    }
    log.showDebug(TAG, 'isLastAppAddIcon isFoundSuccess = ' + isFoundSuccess);
    return isFoundSuccess;
  }

  /**
   * get addIcon geometry id
   *
   * @returns addIcon geometry id
   */
  static getAddIconGeometryId(): string {
    if (DeliverUtil.addIconGeometryId === '') {
      DeliverUtil.addIconGeometryId = DeliverUtil.getUUID();
      log.showInfo(TAG, 'getAddIconGeometryId = ' + DeliverUtil.addIconGeometryId);
    }
    return DeliverUtil.addIconGeometryId;
  }

  /**
   * generate a non duplicate ID
   *
   * @param {string} idLength
   */
  private static getUUID(): string {
    let id = Date.now().toString(HEXADECIMAL_VALUE);
    id += Math.random().toString(HEXADECIMAL_VALUE).substr(2);
    return id;
  }

  static getDeliverStartStatus(): string {
    let paramStartVirtService: string = String(CommonConstants.INVALID_VALUE);
    try {
      paramStartVirtService = systemParameterEnhance.getSync('ohos_fusion_mgr.container.start.phase', '');
    } catch (error) {
      log.showError(TAG, 'get systemParameterEnhance error%{public}d:%{public}s', error.code, error.message);
      if (error.code !== KEY_NOT_FOUND_ERROR_CODE) {
        paramStartVirtService = DeliverUtil.DELIVER_START_FINISHED_CODE;
      }
    }
    log.showInfo(TAG, 'get getDeliverStartStatus %{public}s', paramStartVirtService);
    return paramStartVirtService;
  }

  /**
   * set app package name in the dock area
   *
   * @param appBundleName
   */
  static setAppBundleNameFoundInDock(appBundleName: string): void {
    DeliverUtil.appBundleNameFoundInDock = appBundleName;
  }

  /**
   * check app is exists in the dock area.
   *
   * @param appBundleName
   * @returns true already exists, false does not exist
   */
  static isAppBundleNameFoundInDock(appBundleName: string): boolean {
    return DeliverUtil.appBundleNameFoundInDock === appBundleName;
  }

  /**
   * check DragLeave is disabled.
   *
   * @returns true is disabled, false is not.
   */
  static isDragLeaveDisabled(): boolean {
    return DeliverUtil.isDragLeave;
  }

  /**
   * set DragLeave disabled.
   *
   * @param isDragLeave DragLeave is disabled.
   */
  static setIsDragLeaveDisabled(isDragLeave: boolean): void {
    DeliverUtil.isDragLeave = isDragLeave;
  }

  static removeRecentSpecialApp(bundleName: string): void {
    if (!DeliverUtil.DELIVER_APP_MAP.has(bundleName)) {
      return;
    }
    DeliverUtil.dealdeliverEasyAppStatus();

    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    if (ArrayUtils.isEmpty(containerSessionList)) {
      return;
    }
    let index: number = CommonConstants.INVALID_VALUE;
    for (let i = 0; i < containerSessionList.length; i++) {
      if (containerSessionList[i].primarySession?.sceneInfo?.bundleName ===
      DeliverUtil.DELIVER_APP_MAP.get(bundleName)) {
        index = i;
        break;
      }
    }
    if (index !== CommonConstants.INVALID_VALUE) {
      log.showInfo(TAG, 'removeRecentSpecialApp bundleName = ' + bundleName);
      SCBSceneSessionManager.getInstance().close(SCBSceneSessionManager.getInstance().mainScreenId,
        containerSessionList[index].getPersistentId());
    }
  }

  /**
   * 处理克隆应用应用安装状态
   *
   */
  public static dealdeliverEasyAppStatus(): void {
    let dhApplicationStatus: string = DELIVER_NO_EXIST_EASY_NO_EXIST;
    if (DeliverUtil.verifyContainerAppIdentifier(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL)) {
      dhApplicationStatus = DELIVER_EXIST_EASY_NO_EXIST;
    }

    if (DeliverUtil.verifyContainerAppIdentifier(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL)) {
      dhApplicationStatus = dhApplicationStatus === DELIVER_EXIST_EASY_NO_EXIST ?
        DELIVER_EXIST_EASY_EXIST : DELIVER_NO_EXIST_EASY_EXIST;
    }
    log.showInfo(TAG, 'dealdeliverEasyAppStatus dhApplicationStatus = ' + dhApplicationStatus);
    SettingsUtil.setValue(DeliverUtil.CONTAINER_INSTALL_STATUS, dhApplicationStatus);
  }

  /**
   * 刷新定制文件夹内应用卸载状态
   *
   */
  public static refreshFolder(): void {
    if (CheckEmptyUtils.isEmpty(DeliverUtil.containerFolderMap)) {
      return;
    }
    DeliverUtil.containerFolderMap.forEach(value => {
      if (!CheckEmptyUtils.isEmpty(value)) {
        let folderInfo = FolderLayoutCacheManager.getInstance().selectGridLayoutItemByFolderId(value);
        if (!folderInfo || !folderInfo.layoutInfo || CheckEmptyUtils.isEmptyArr(folderInfo.layoutInfo)) {
          return;
        }
        let folderApps: GridLayoutItemInfo[] = folderInfo.layoutInfo.flat();
        folderApps.forEach(appItemInfo => {
          let cacheAppInfo = AppModel.getInstance().getAppInfoByBundleName(appItemInfo.bundleName);
          appItemInfo.isUninstallAble = cacheAppInfo?.isUninstallAble;
        });
        FolderManager.getInstance().updateFolderItems('refreshDeliverAppList', folderInfo, folderApps);
      }
    });
    // 刷新dock区定制文件夹内应用卸载状态
    DeliverUtil.refreshFolderAppsInDock();
  }

  /**
   * 刷新Dock区定制文件夹数据
   *
   */
  public static refreshFolderAppsInDock(): void {
    if (CheckEmptyUtils.isEmpty(DeliverUtil.containerFolderMap)) {
      return;
    }
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    DeliverUtil.containerFolderMap.forEach((value: string) => {
      if (CheckEmptyUtils.isEmpty(value)) {
        return;
      }
      let folderIndex: number = residentList.findIndex(item => value === item.appId);
      if (folderIndex === CommonConstants.INVALID_VALUE) {
        return;
      }
      let folderInfoInDock: DockItemInfo = residentList[folderIndex];
      if (!folderInfoInDock?.layoutInfo) {
        return;
      }
      let folderApps: GridLayoutItemInfo[] = folderInfoInDock.layoutInfo.flat();
      folderApps.forEach(appItemInfo => {
        let cacheAppInfo = AppModel.getInstance().getAppInfoByBundleName(appItemInfo.bundleName);
        appItemInfo.isUninstallAble = cacheAppInfo?.isUninstallAble;
      });
      residentList.splice(folderIndex, 1, folderInfoInDock);
    });
    LayoutViewModel.getInstance().updateResidentDockLayout(TAG.concat('_refresh'), residentList);
  }

  /**
   * translate appInfos to FolderLayout in folderInfo
   * appInfos是一维数组，folderInfo.layoutInfo是二维分页
   *
   * @param { GridLayoutItemInfo[] } appInfos - 文件夹appInfos.
   * @return { GridLayoutItemInfo[][] } folderInfo layout
   */
  public static translateFolderLayout(appInfos: GridLayoutItemInfo[]): GridLayoutItemInfo[][] {
    let folderLayout: GridLayoutItemInfo[][] = [];
    let folderOpenColumn: number = FolderModel.getInstance().getFolderOpenLayout()?.column;
    let folderOpenRow: number = FolderModel.getInstance().getFolderOpenLayout()?.row;
    const allCount: number = folderOpenColumn * folderOpenRow;
    if (appInfos.length > allCount && allCount > 0) {
      let integer: number = Math.floor(appInfos.length / allCount);
      let remainder: number = appInfos.length % allCount;
      for (let i = 0; i < integer; i++) {
        folderLayout.push(appInfos.slice(i * allCount, (i + 1) * allCount));
      }
      if (remainder !== 0) {
        folderLayout.push(appInfos.slice(integer * allCount, integer * allCount + remainder));
      }
    } else {
      folderLayout = [appInfos];
    }
    return folderLayout;
  }

  /**
   * 不需要展示的应用
   *
   * @param bundleName 应用的bundleName
   * @param { string } bundleName - 应用的bundleName.
   * @returns { boolean } isRemovedDeliverApp - Whether there is need deleted app.
   */
  public static isRemovedDeliverApp(bundleName: string): boolean {
    return bundleName === DeliverUtil.APPMARKET_BUNDLE_NAME;
  }

  /**
   * 判断是否为克隆应用或应用包名
   *
   * @param bundleName 包名
   * @returns true，是克隆应用或应用包名；false，不是克隆应用或应用包名
   */
  public static isContainerPkg(bundleName: string): boolean {
    return bundleName === DeliverUtil.DELIVER_APP_BUNDLE_NAME ||
      bundleName === DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL ||
      bundleName === DeliverUtil.DELIVER_APPSTORE_PKG ||
      bundleName === DeliverUtil.ABROAD_APP_PKG ||
      bundleName === DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME ||
      bundleName === DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL;
  }

  /**
   * 判断文件夹类型
   *
   * @param folderItem 文件夹实例
   * @returns 0-普通文件夾, 1-非鸿蒙化, 2-, 3-， -1-非文件夹
   */
  public static getFolderTypeByFolderId(folderId?: string): number {
    if (CheckEmptyUtils.checkStrIsEmpty(folderId)) {
      return DeliverUtil.FOLDER_TYPE_NOTFOLDER;
    }
    if (NotHarmonyUtil.isNotHarmonyFolderById(folderId)) {
      return DeliverUtil.FOLDER_TYPE_NOTHARMONY;
    }
    if (DeliverUtil.containerFolderMap.get(DeliverUtil.ABROAD_APP_PKG) === folderId) {
      return DeliverUtil.FOLDER_TYPE_EASY;
    } else if (DeliverUtil.containerFolderMap.get(DeliverUtil.DELIVER_APPSTORE_PKG) === folderId) {
      return DeliverUtil.FOLDER_TYPE_DELIVER;
    }
    return DeliverUtil.FOLDER_TYPE_COMMON;
  }

  /**
   * 判断app类型
   *
   * @param folderItem 文件夹实例
   * @returns 0-正常应用，可直接打开, 1-未鸿蒙化应用（未安装）, 2-, 3- , 4-置灰的预装应用, -1-均不是
   */
  public static getAppType(item: AppItemInfo | GridLayoutItemInfo): number {
    if (CheckEmptyUtils.isEmpty(item)) {
      return DeliverUtil.APPTYPE_TYPE_NONE;
    }
    let map: Map<string, Object> = CommonUtils.jsonStrToMap(item.intent ?? '');
    if (map.get(KEY_INSTALL_SOURCE) as string === DeliverUtil.DELIVER_APPSTORE_PKG) {
      return DeliverUtil.APPTYPE_TYPE_DELIVER;
    } else if (map.get(KEY_INSTALL_SOURCE) as string === DeliverUtil.ABROAD_APP_PKG) {
      return DeliverUtil.APPTYPE_TYPE_EASY;
    }

    if (GridLayoutUtil.isAppInstalled(item)) {
      return DeliverUtil.APPTYPE_COMMON;
    }

    // 点击的是置灰应用
    if (PreInstallUtils.checkIsNeedInstallAppByIntent(item) && item.appStatus === AppStatus.PENDING) {
      return DeliverUtil.APPTYPE_TYPE_GRAY;
    }

    if (item.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      return DeliverUtil.APPTYPE_TYPE_NOTHARMONY;
    }
    return DeliverUtil.APPTYPE_TYPE_NONE;
  }

  /**
   * 判断文件夹是否为指定的定制文件夹(克隆应用或应用)
   *
   * @param folderId 文件夹id
   * @param installSource 指定安装来源的文件夹(克隆应用或应用)
   * @returns true 是指定的定制文件夹, false 不是指定的定制文件夹
   */
  static isContainerFolder(folderId: string | undefined, installSource?: string): boolean {
    if (CheckEmptyUtils.isEmpty(folderId)) {
      log.showWarn(TAG, `isContainerFolder: false. folderId = ${folderId}`);
      return false;
    }
    if (installSource) {
      log.showInfo(TAG, `map.get(installSource) = ${DeliverUtil.containerFolderMap.get(installSource)}, folderId = ${folderId}`);
      return DeliverUtil.containerFolderMap.get(installSource) === folderId;
    }
    let result = false;
    DeliverUtil.containerFolderMap.forEach(value => {
      if (value === folderId) {
        result = true;
      }
    });
    return result;
  }

  /**
   * 判断文件夹是否为克隆应用文件夹
   *
   * @param folderId 文件夹id
   */
  static isdeliverFolder(folderId: string): boolean {
    if (CheckEmptyUtils.isEmpty(folderId)) {
      log.showWarn(TAG, `isdeliverFolder: false. folderId = ${folderId}`);
      return false;
    }
    return DeliverUtil.containerFolderMap.get(DeliverUtil.DELIVER_APPSTORE_PKG) === folderId;
  }

  /**
   * 判断文件夹是否为应用文件夹
   *
   * @param folderId 文件夹id
   */
  static isAbroadFolder(folderId: string): boolean {
    if (CheckEmptyUtils.isEmpty(folderId)) {
      log.showWarn(TAG, `isAbroadFolder: false. folderId = ${folderId}`);
      return false;
    }
    return DeliverUtil.containerFolderMap.get(DeliverUtil.ABROAD_APP_PKG) === folderId;
  }

  /**
   * 判断拖拽的元素是不是都是克隆应用文件夹应用
   *
   * @param dragItems 拖拽元素的数组
   */
  static isAlldeliverApps(dragItems: GridLayoutItemInfo[]): boolean {
    for (const dragItem of dragItems) {
      if (!DeliverUtil.isdeliverApp(dragItem.intent ?? '')) {
        return false;
      }
    }
    return true;
  }

  /**
   * 是否克隆应用安装来源的应用
   *
   * @param appIntent 应用的intent字段信息
   * @returns true为克隆应用安装应用，false为其他安装来源应用
   */
  static isdeliverApp(appIntent?: string): boolean {
    if (CheckEmptyUtils.isEmpty(appIntent)) {
      return false;
    }
    let map: Map<string, Object> = CommonUtils.jsonStrToMap(appIntent);
    return map.get(KEY_INSTALL_SOURCE) as string === DeliverUtil.DELIVER_APPSTORE_PKG;
  }

  /**
   * 判断item是否为定制文件夹内应用
   *
   * @param item 应用item
   * @returns true 是定制文件夹内应用, false 不是定制文件夹内应用
   */
  static isContainerItem(intent?: string): boolean {
    if (CheckEmptyUtils.isEmpty(intent)) {
      return false;
    }
    let map: Map<string, Object> = CommonUtils.jsonStrToMap(intent);
    return map.get(KEY_INSTALL_SOURCE) as string === DeliverUtil.DELIVER_APPSTORE_PKG ||
      map.get(KEY_INSTALL_SOURCE) as string === DeliverUtil.ABROAD_APP_PKG;
  }

  /**
   * 判断item是否为应用文件夹内应用
   *
   * @param item 应用item
   * @returns true 是应用文件夹内应用, false 不是应用文件夹内应用
   */
  static isEasyAbroadItem(intent: string): boolean {
    if (CheckEmptyUtils.isEmpty(intent)) {
      return false;
    }
    let map: Map<string, Object> = CommonUtils.jsonStrToMap(intent);
    return map.get(KEY_INSTALL_SOURCE) as string === DeliverUtil.ABROAD_APP_PKG;
  }

  /**
   * 迁移桌面旧数据(文件夹中extend1和应用的kindId)到新字段intent
   *
   * @param item 文件夹item
   */
  static copyDesktopOldDataToIntent(item: GridLayoutItemInfo): void {
    if (item.extend1 !== CommonConstants.CONTAINER_APP_KIND_ID.toString() || !item ||
      !CheckEmptyUtils.isEmpty(item.intent) || !item.layoutInfo) {
      return;
    }
    let intentMap: Map<string, string> = new Map();
    intentMap.set(KEY_INSTALL_SOURCE, DeliverUtil.DELIVER_APPSTORE_PKG);
    item.intent = CommonUtils.mapToJonStr(intentMap);
    item.layoutInfo.flat().forEach(appItem => appItem.intent = item.intent);
    log.showInfo(TAG, 'copyDesktopOldDataToIntent itemid = ' + item.id + ', infoId = ' + item.infoId);
    RdbStoreManager.getInstance().updateFolderIntentByInfoId(item.infoId ?? '', item.intent);
    RdbStoreManager.getInstance().updateAppItemIntentByInfoId(item.id ?? 0, item.intent);
  }

  /**
   * 迁移dock区旧数据(文件夹中extend1和应用的kindId)到新字段intent
   *
   * @param item 文件夹item
   */
  static copyDockOldDataToIntent(item: DockItemInfo): void {
    if (item.extend1 !== CommonConstants.CONTAINER_APP_KIND_ID.toString() || !item ||
      !CheckEmptyUtils.isEmpty(item.intent) || !item.layoutInfo) {
      return;
    }
    let intentMap: Map<string, string> = new Map();
    intentMap.set(KEY_INSTALL_SOURCE, DeliverUtil.DELIVER_APPSTORE_PKG);
    item.intent = CommonUtils.mapToJonStr(intentMap);
    item.layoutInfo.flat().forEach(appItem => appItem.intent = item.intent);
    log.showInfo(TAG, 'copyDockOldDataToIntent itemid = ' + item.id + ', infoId = ' + item.appId);
    RdbStoreManager.getInstance().updateFolderIntentByInfoId(item.appId ?? '', item.intent);
    RdbStoreManager.getInstance().updateAppItemIntentByInfoId(item.id ?? 0, item.intent);
  }

  /**
   * 设置应用的安装来源installSource和intent
   *
   * @param appItemInfo 应用信息
   * @param intent 应用的intent字段信息
   */
  static setInstallSourceAndIntent(appItemInfo: AppItemInfo, intent: string): void {
    if (CheckEmptyUtils.isEmpty(appItemInfo)) {
      return;
    }
    if (CheckEmptyUtils.isEmpty(intent)) {
      appItemInfo.installSource = DeliverUtil.getInstallSourceByBundleName(appItemInfo.bundleName);
      let intentMap: Map<string, string> = new Map();
      intentMap.set(KEY_INSTALL_SOURCE, appItemInfo.installSource);
      appItemInfo.intent = CommonUtils.mapToJonStr(intentMap);;
    } else {
      appItemInfo.installSource = DeliverUtil.getInstallSourceByIntent(intent);
      appItemInfo.intent = intent;
    }
    log.showInfo(TAG, `setInstallSourceAndIntent, bundleName = ${appItemInfo.bundleName} intent = ${appItemInfo.intent}`);
  }

  private static getInstallSourceByBundleName(bundleName: string): string {
    if (bundleName === DeliverUtil.DELIVER_APPSTORE_PKG || bundleName === DeliverUtil.ABROAD_APP_PKG) {
      return bundleName;
    }
    let appInstallSource = DeliverUtil.DELIVER_APPSTORE_PKG;
    try {
      let bundleInfo = bundleManager
        .getBundleInfoSync(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      appInstallSource = bundleInfo.appInfo?.installSource;
      log.showInfo(TAG, `getInstallSourceByBundleName, bundleInfo appInstallSource = ${appInstallSource}`);
      if (appInstallSource !== DeliverUtil.DELIVER_APPSTORE_PKG && appInstallSource !== DeliverUtil.ABROAD_APP_PKG) {
        appInstallSource = DeliverUtil.DELIVER_APPSTORE_PKG;
      }
    } catch (err) {
      log.showError(TAG, `getInstallSourceByBundleName, err = ${err}`);
    }
    return appInstallSource;
  }

  /**
   * 判断是否需要弹框引导下载克隆应用或应用
   *
   * @param gridLayoutInfo 应用信息
   * @returns 是否需要弹框
   */
  public static needOpendeliverAppAlertDialog(gridLayoutInfo: GridLayoutItemInfo): boolean {
    return DeliverUtil.isContainerItem(gridLayoutInfo?.intent ?? '') &&
      DeliverUtil.getDeliverStartStatus() !== DeliverUtil.DELIVER_START_FINISHED_CODE &&
      !DeliverUtil.isMatchContainerHapExist(gridLayoutInfo);
  }

  /**
   * 获取定制文件夹名称用于弹框显示
   *
   * @param gridLayoutInfo 应用GridLayoutInfo
   * @param folderId 文件夹ID
   * @returns 文件夹名称
   */
  public static getContainerFolderNameForDialog(gridLayoutInfo: GridLayoutItemInfo | AppItemInfo, folderId?: string): string | Resource {
    let installSource: string = DeliverUtil.getInstallSourceByGridLayoutInfoOrFolder(gridLayoutInfo, folderId);
    if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG) {
      return $r('app.string.app_others');
    }
    return ABROAD_APP_FOLDERNAME;
  }

  private static getInstallSourceByGridLayoutInfoOrFolder(gridLayoutInfo: GridLayoutItemInfo | AppItemInfo, folderId?: string): string {
    let installSource: string = '';
    if (!CheckEmptyUtils.isEmpty(folderId)) {
      let easyAbroadFolderId = DeliverUtil.containerFolderMap.get(DeliverUtil.ABROAD_APP_PKG);
      installSource = easyAbroadFolderId === folderId ? DeliverUtil.ABROAD_APP_PKG : DeliverUtil.DELIVER_APPSTORE_PKG;
    } else {
      installSource = CommonUtils.jsonStrToMap(gridLayoutInfo?.intent ?? '').get(KEY_INSTALL_SOURCE) as string;
    }
    return installSource;
  }

  /**
   * 获取定制文件夹名称
   *
   * @param appItemInfo 应用item
   * @returns 文件夹名称
   */
  static getContainerFolderName(appItemInfo: AppItemInfo): string {
    if (appItemInfo.installSource === DeliverUtil.ABROAD_APP_PKG) {
      return ABROAD_APP_FOLDERNAME;
    }
    return DELIVER_FOLDERNAME;
  }

  /**
   * 设置桌面定制文件夹缓存
   *
   * @param item 桌面文件夹item
   */
  static setContainerFolderMapInDesktop(item: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      return;
    }
    let installSource = CommonUtils.jsonStrToMap(item.intent ?? '').get(KEY_INSTALL_SOURCE) as string;
    if (CheckEmptyUtils.isEmpty(installSource)) {
      installSource = DeliverUtil.DELIVER_APPSTORE_PKG;
    }
    log.showInfo(TAG, `setContainerFolderMapInDesktop, installSource = ${installSource}, folderId = ${item.folderId}`);
    DeliverUtil.containerFolderMap.set(installSource ?? '', item.folderId ?? '');
  }

  /**
   * 设置dock区定制文件夹缓存
   *
   * @param item dock区文件夹item
   */
  static setContainerFolderMapInDock(item: DockItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item)) {
      return;
    }
    let installSource = CommonUtils.jsonStrToMap(item.intent ?? '').get(KEY_INSTALL_SOURCE) as string;
    if (CheckEmptyUtils.isEmpty(installSource)) {
      installSource = DeliverUtil.DELIVER_APPSTORE_PKG;
    }
    log.showInfo(TAG, `setContainerFolderMapInDock, installSource = ${installSource}, folderId = ${item.appId}`);
    DeliverUtil.containerFolderMap.set(installSource ?? '', item.appId ?? '');
  }

  /**
   * 通过应用的intent获取安装来源
   *
   * @param intent 应用的intent字段
   * @returns 安装来源
   */
  public static getInstallSourceByIntent(intent: string, isClone?: boolean): string {
    let installSource = CommonUtils.jsonStrToMap(intent).get(KEY_INSTALL_SOURCE) as string;
    if (CheckEmptyUtils.isEmpty(installSource) && !isClone) {
      return DeliverUtil.DELIVER_APPSTORE_PKG;
    }
    return installSource;
  }

  /**
   * 是否有备份应用
   *
   * @returns 是否有备份应用
   */
  public static isHaveDeliverApps(): boolean {
    if (!DeliverUtil.isSupportDeliver()) {
      return false;
    }
    return !CheckEmptyUtils.isEmpty(DeliverUtil.containerFolderMap) && DeliverUtil.containerFolderMap.size > 0;
  }

  /**
   * 克隆未鸿蒙化应用构造intent
   *
   * @param legacyInfo 设备应用信息
   * @param waitForSystemKey 应用市场未鸿蒙化应用标识
   * @param enterpriseLink 企业URL
   * @returns intent intent
   */
  public static getCloneGridLayoutItemIntent(legacyInfo: LegacyInfo, waitForSystemKey: string,
    enterpriseLink: string, appType?: number): string {
    let extendInfo = {
      'legacyInfo': legacyInfo,
      'targetModuleUrl': enterpriseLink,
      'requestBundleName': waitForSystemKey,
      'installSource': legacyInfo?.installSource,
      'appType': appType ?? 0,
      'maskState': appType === AppReserveType.TASTE_FRESH ? 1 : 0
    } as IBaseExtendInfo;
    if (CommonUtils.isEmpty(extendInfo.requestBundleName)) {
      let nowTime: number = new Date().getTime();
      extendInfo.requestBundleName = DeliverUtil.WAIT_FOR_HARMONY_PREFIX + nowTime;
    }
    return JSON.stringify(extendInfo);
  }

  /**
   * 校验克隆应用/应用应用的AppIdentifier
   *
   * @param bundleName 应用包名
   * @param callMethod 调用方法
   * @returns True: 校验通过， False: 校验失败
   */
  public static verifyContainerAppIdentifier(bundleName: string, callMethod?: string): boolean {
    let bundleInfo: bundleManager.BundleInfo | undefined = undefined;
    try {
      bundleInfo = bundleManager
        .getBundleInfoSync(bundleName, bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO);
    } catch (err) {
      log.showError(TAG, `verifyIdentifier, getBundleInfoSync failed, bundleName = ${bundleName}, err = ${err?.message}`);
      return false;
    }
    let appIdentifier: string = bundleInfo?.signatureInfo?.appIdentifier;
    if (CheckEmptyUtils.isEmpty(bundleName) || CheckEmptyUtils.isEmpty(appIdentifier)) {
      log.showWarn(TAG, `verifyIdentifier failed, bundleName or appIdentifier is empty. callMethod: ${callMethod}`);
      return false;
    } else if (!this.APP_IDENTIFIER_MAP.has(bundleName)) {
      log.showWarn(TAG, `verifyIdentifier failed, ${bundleName} is not in identifier map. callMethod: ${callMethod}`);
      return false;
    } else if (this.APP_IDENTIFIER_MAP.get(bundleName) !== appIdentifier) {
      log.showWarn(TAG, `verifyIdentifier failed, ${bundleName} appIdentifier is counterfect! callMethod: ${callMethod}`);
      return false;
    }
    return true;
  }

  /**
   * 重启场景下触发，缓存应用名称
   *
   * @param appItem 应用信息
   * @param intent 用于判断是否备份应用
   */
  public static setContainerAppNameCache(appItem: GridLayoutItemInfo, intent: string): void {
    if (CheckEmptyUtils.isEmpty(appItem) || !DeliverUtil.isContainerItem(intent)) {
      return;
    }
    if (!CheckEmptyUtils.isEmpty(appItem.appName)) {
      const appItemKey: string = `${appItem.appLabelId}${appItem.bundleName}${appItem.moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(appItemKey, KEY_NAME, appItem.appName);
    }
  }

  /**
   * 备份应用是否可以卸载
   *
   * @param intent 用于判断是否备份应用
   * @param isUninstallAble 应用是否可卸载
   * @returns True: 非备份应用或者备份应用可卸载， False: 备份应用不可卸载
   */
  public static isContainerAppUninstallAble(intent: string, isUninstallAble: boolean): boolean {
    if (!DeliverUtil.isContainerItem(intent)) {
      return true;
    }
    // 备份启动状态并且应用可卸载,才允许卸载
    return DeliverUtil.getDeliverStartStatus() === DeliverUtil.DELIVER_START_FINISHED_CODE && isUninstallAble;
  }

  /**
   * 获取对应安装来源的文件夹id
   *
   * @param installSource 安装来源
   */
  static getContainerFolder(installSource?: string): string {
    if (!installSource) {
      return '';
    }
    return DeliverUtil.containerFolderMap.get(installSource) ?? '';
  }

  /**
   * 判断是否未鸿蒙化应用，且克隆应用或应用已安装
   *
   * @param bundleName 应用包名
   * @returns 是未鸿蒙化应用，且克隆应用或应用已安装：true，否则false
   */
  public static isStartWaitHMContainerApp(bundleName: string): boolean {
    let info = DeliverUtil.getAppItemByBundleName(bundleName);
    let result = DeliverUtil.judgeWaitHMAndMaskStatus(info) && DeliverUtil.isContainerItem(info?.intent ?? '') &&
    DeliverUtil.isContainerHapExist(DeliverUtil.getInstallSourceByIntent(info?.intent ?? ''));
    log.showInfo(TAG, `isStartWaitHMContainerApp: ${result}, bundleName: ${bundleName}.`);
    return result;
  }

  /**
   * 判断应用对应的克隆应用/应用是否安装（应用直接返回false）
   *
   * @param gridLayoutInfo 应用包名gridLayoutInfo
   * @param folderId 文件夹ID
   * @returns 对应的克隆应用/应用已安装：true，否则false
   */
  public static isMatchContainerHapExist(gridLayoutInfo: GridLayoutItemInfo, folderId?: string): boolean {
    let installSource: string = DeliverUtil.getInstallSourceByGridLayoutInfoOrFolder(gridLayoutInfo, folderId);
    let matchContainerHapExist: boolean = false;
    if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG) {
      matchContainerHapExist = DeliverUtil.isdeliverHapExist();
    }
    if (installSource === DeliverUtil.ABROAD_APP_PKG) {
      matchContainerHapExist = DeliverUtil.isEasyAbroadExist();
    }
    log.showInfo(TAG, `isMatchContainerHapExist bundleName: ${gridLayoutInfo.bundleName}, res: ${matchContainerHapExist}.`);
    return matchContainerHapExist;
  }

  private static judgeWaitHMAndMaskStatus(info?: GridLayoutItemInfo): boolean {
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(info?.intent);
    let maskStatus: number = intentMap.get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) as number;
    // appStatus为 WAIT_FOR_HARMONY，并且 maskStatus 不为1的才是真正未鸿蒙化并且图标未点亮的应用
    return info?.appStatus === AppStatus.WAIT_FOR_HARMONY && maskStatus !== 1;
  }

  /**
   * 文件夹中的应用是否可从文件夹中拖出
   *
   * @param folderId 文件夹Id
   * @param bundleName 应用包名
   * @returns 应用是否可从文件夹中拖出
   */
  public static canFolderItemDragOut(folderId: string, bundleName?: string): boolean {
    if (DeliverUtil.DEFAULT_DELIVER_APP_SORT.has(bundleName ?? '')) {
      return false;
    }
    return !(DeliverUtil.isContainerFolder(folderId) && !DeliverUtil.isdeliverFolder(folderId)) &&
      !NotHarmonyUtil.isNotHarmonyFolderById(folderId);
  }

  /**
   * 通过应用信息获取应用的打点分类
   *
   * @param AppItemInfo 桌面应用信息
   * @returns 应用类型AppType
   */
  public static getUEClickTypeByItem(item: AppItemInfo | GridLayoutItemInfo): number {
    if (GridLayoutUtil.isAppInstalled(item)) {
      if (DeliverUtil.isSupportAppType(item.bundleName)) {
        return AppType.DELIVER_APP;
      }
      return AppType.COMMON_APP;
    }
    if (item.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      return AppType.NOT_HARMONY_APP;
    }
    return AppType.COMMON_APP;
  }

  /**
   * 判断文件夹是否为指定的定制文件夹（备份或未鸿蒙化）
   *
   * @param isDeliverApp false未鸿蒙化应用
   * @param typeId 元素类型
   * @param folderId 文件夹id
   * @param installSource 安装来源
   * @returns 该文件夹是否为指定的定制文件夹
   */
  public static isCustomizedFolder(isDeliverApp: boolean = true, typeId: number | undefined, folderId?: string,
    installSource?: string): boolean {
    if (isDeliverApp) {
      return typeId === CommonConstants.TYPE_FOLDER && DeliverUtil.isContainerFolder(folderId, installSource);
    } else {
      return typeId === CommonConstants.TYPE_FOLDER && NotHarmonyUtil.isNotHarmonyFolderById(folderId);
    }
  }

  /**
   * 根据包名获取未鸿蒙化应用信息
   *
   * @param bundleName 应用包名
   * @returns 未鸿蒙化应用信息
   */
  public static getAppItemByBundleName(bundleName: string): GridLayoutItemInfo | undefined {
    let appList: GridLayoutItemInfo[] = LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
    return appList.length > 0 ? appList[0] : undefined;
  }

  /**
   * 判断克隆应用或应用是否已安装
   *
   * @param installSoruce 克隆应用或应用
   * @returns true：已安装，false：未安装
   */
  public static isContainerHapExist(installSoruce?: string): boolean {
    if (installSoruce === DeliverUtil.DELIVER_APPSTORE_PKG) {
      return DeliverUtil.isdeliverHapExist();
    }
    if (installSoruce === DeliverUtil.ABROAD_APP_PKG) {
      return DeliverUtil.isEasyAbroadExist();
    }
    return DeliverUtil.isdeliverHapExist() || DeliverUtil.isEasyAbroadExist();
  }

  /**
   * 判断克隆应用是否已安装
   *
   * @returns true：已安装，false：未安装
   */
  public static isdeliverHapExist(): boolean {
    return AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.DELIVER_APP_BUNDLE_NAME) !== undefined ||
      AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL) !== undefined;
  }

  /**
   * 判断应用是否已安装
   *
   * @returns true：已安装，false：未安装
   */
  public static isEasyAbroadExist(): boolean {
    return AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME) !== undefined ||
      AppModel.getInstance().getAppInfoByBundleName(DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL) !== undefined;
  }

  /**
   * 移除未鸿蒙化应用在应用市场中的下载任务
   *
   * @param bundleName 克隆应用或应用包名
   */
  public static removeWaitHMDownloadTask(bundleName: string): void {
    // 删除默认应用的预制顺序缓存
    DeliverUtil.deleteCacheDefaultAppSort(bundleName);
    if (CheckEmptyUtils.isEmpty(DeliverUtil.containerFolderMap)) {
      log.showInfo(TAG, `removeWaitHMDownloadTask, containerFolderMap isEmpty.`);
      return;
    }
    let folderId: string = DeliverUtil.containerFolderMap.get(DeliverUtil.DELIVER_APP_MAP.get(bundleName) ?? '') ?? '';
    log.showInfo(TAG, `removeWaitHMDownloadTask, bundleName = ${bundleName}, folderId = ${folderId}`);
    if (CheckEmptyUtils.isEmpty(folderId)) {
      return;
    }
    let folderInfo: GridLayoutItemInfo | DockItemInfo | undefined =
      FolderLayoutCacheManager.getInstance().selectGridLayoutItemByFolderId(folderId);
    // 如果桌面没有该文件夹，就在dock区查找
    if (!folderInfo) {
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      let folderIndex: number = residentList?.findIndex(item => folderId === item.appId);
      if (folderIndex !== CommonConstants.INVALID_VALUE) {
        folderInfo = residentList[folderIndex];
      }
    }
    let folderApps: GridLayoutItemInfo[] | undefined = folderInfo?.layoutInfo?.flat();
    if (!folderApps) {
      return;
    }
    let requestBundleNameArray: string[] = [];
    for (let item of folderApps) {
      if (item.appStatus === AppStatus.WAIT_FOR_HARMONY) {
        let requestBundleName: string = CommonUtils.jsonStrToMap(item.intent)?.get('requestBundleName') as string;
        if (CheckEmptyUtils.isEmpty(requestBundleName)) {
          continue;
        }
        requestBundleNameArray.push(requestBundleName);
      }
    }
    AppInstallUtils.getInstance().cancelRestoreLauncherData(requestBundleNameArray);
  }

  private static deleteCacheDefaultAppSort(bundleName: string): void {
    log.showInfo(TAG, 'deleteDefaultCacheAppSort bundleName = %{public}s', bundleName);
    let options: preferences.Options = { name: 'rgmDefaultSortFile' };
    let preference: preferences.Preferences | undefined = undefined;
    try {
      preference = preferences.getPreferencesSync(GlobalContext.getInstance()
        .getObject('desktopContext') as ctx.ServiceExtensionContext, options);
    } catch (error) {
      log.showError(TAG, 'getPreferencesSync with error %{public}s', error.message);
    }
    if (!preference) {
      log.showWarn(TAG, 'deleteDefaultCacheAppSort get preferences error');
      return;
    }
    switch (bundleName) {
      case DeliverUtil.DELIVER_APP_BUNDLE_NAME:
      case DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL:
        preference.delete(DeliverUtil.DELIVER_TRANSFER_BUNDLE_NAME);
        preference.delete(DeliverUtil.DELIVER_BROWSER_BUNDLE_NAME);
        break;
      case DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME:
      case DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL:
        preference.delete(DeliverUtil.ABROAD_APP_TRANSFER_BUNDLE_NAME);
        break;
      default:
        log.showWarn(TAG, 'error deliver app bundle = %{public}s', bundleName);
    }
    preference.flush();
  }

  /**
   * 移除未鸿蒙化应用下载任务
   *
   * @param itemInfo 应用信息
   */
  private static cancelDownloadTask(itemInfo: GridLayoutItemInfo): void {
    if (itemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(itemInfo.intent);
      AppInstallUtils.getInstance().cancelTask(extendInfo?.get('requestBundleName') as string);
      log.showInfo(TAG, `cancelDownloadTask, bundleName: ${itemInfo.bundleName}`);
    }
  }

  /**
   * 卸载克隆应用或应用hap，需删除对应预置应用
   *
   * @param bundleName 克隆应用或应用包名
   */
  public static removeContainerFolder(bundleName: string): void {
    let delAppSet: Set<string> = DeliverUtil.isdeliverPkg(bundleName) ? DeliverUtil.DELIVER_PREINSTALLED_APP_SET :
      DeliverUtil.ABROAD_APP_PREINSTALLED_APP_SET;
    log.showInfo(TAG, `removeContainerFolder, delAppSet.size = ${delAppSet.size}.`);
    delAppSet.forEach(item => AppModel.getInstance().appItemRemove(item, 0));
  }

  private static checkRemoveContainerFolder(bundleName: string): boolean {
    return DeliverUtil.getDeliverStartStatus() !== DeliverUtil.DELIVER_START_FINISHED_CODE &&
      ((DeliverUtil.isEasyAbroadPkg(bundleName) && DeliverUtil.isdeliverHapExist()) ||
      (DeliverUtil.isdeliverPkg(bundleName) && DeliverUtil.isEasyAbroadExist()));
  }

  private static isEasyAbroadPkg(bundleName: string): boolean {
    return bundleName === DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME ||
      bundleName === DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL;
  }

  private static isdeliverPkg(bundleName: string): boolean {
    return bundleName === DeliverUtil.DELIVER_APP_BUNDLE_NAME ||
      bundleName === DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL;
  }

  /**
   *  点击未安装的应用，拉起克隆应用自动界面
   * @param bundleName 点击应用的包名
   * @param iconResource 点击应用的图标路径
   */
  public static async startdeliverAutoEnterLakeAbility(bundleName: string, iconResource: string): Promise<void> {
    log.showInfo(TAG, `start deliver auto enter lake ability`);
    let appIcon: string = await DeliverUtil.getRealIconAndScale(iconResource);
    const want: Want = {
      bundleName: DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL,
      moduleName: DeliverUtil.DELIVER_APP_MODULE_NAME,
      abilityName: DeliverUtil.DELIVER_APP_ABILITY_NAME,
      action: 'ohos.want.action.EnterLake',
      parameters: {
        'realBundleName': bundleName,
        'realAppIcon': appIcon,
      },
    };
    try {
      StartAbilityUtil.startAbility(want);
    } catch (e) {
      log.showError(TAG, `start deliver auto enter lake ability failed, code: ${e.code}, message: ${e.message}`);
    }
  }

  /**
   * 点击未安装的应用，拉起应用自动界面
   * @param bundleName 点击应用的包名
   * @param iconResource 点击应用的图标路径
   */
  public static async startEasyAbroadAutoEnterLakeAbility(bundleName: string, iconResource: string): Promise<void> {
    log.showInfo(TAG, `start easyAbroad auto enter lake ability`);
    let appIcon: string = await DeliverUtil.getRealIconAndScale(iconResource);
    const want: Want = {
      bundleName: DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL,
      moduleName: DeliverUtil.DELIVER_APP_MODULE_NAME,
      abilityName: DeliverUtil.DELIVER_APP_ABILITY_NAME,
      action: 'ohos.want.action.EnterLake',
      parameters: {
        'realBundleName': bundleName,
        'realAppIcon': appIcon,
      },
    };
    try {
      StartAbilityUtil.startAbility(want);
    } catch (e) {
      log.showError(TAG, `start easyAbroad auto enter lake ability failed, code: ${e.code}, message: ${e.message}`);
    }
  }

  /**
   * 将未安装应用的设备占位图标进行缩放，以便传输和克隆应用正常显示
   * @param path 设备占位图标
   * @returns
   */
  private static async getRealIconAndScale(path: string): Promise<string> {
    let imagePixelMap: image.PixelMap | undefined = undefined;
    try {
      imagePixelMap = await DeliverUtil.loadImageFromDisk(path);
      if (!imagePixelMap) {
        return '';
      }
      //将图标缩小，避免图标太大无法传输
      const bites = imagePixelMap?.getPixelBytesNumber();
      if (!bites) {
        log.showError(TAG, 'imagePixelMap get imageInfo error');
        return '';
      }
      if (bites > MAX_DELIVERY_SIZE) {
        let deliverScale: number = Number(Math.sqrt(MAX_DELIVERY_SIZE / bites).toFixed(2));
        await imagePixelMap.scale(deliverScale, deliverScale);
      }
      let iconStr: string = await GraphicUtils.changePixelToBase64(imagePixelMap);
      log.showWarn(TAG, 'iconStr length = %{public}d', iconStr.length);
      return iconStr;
    } catch (err) {
      log.showError(TAG, 'getIconAndScale message err  %{public}s', err?.message);
      return '';
    } finally {
      imagePixelMap?.release();
    }
  }

  /**
   * 根据路径加载图片
   *
   * @param path 图片路径
   * @returns 图片资源
   */
  public static async loadImageFromDisk(path: string,
    format: image.PixelMapFormat = image.PixelMapFormat.RGBA_8888): Promise<image.PixelMap | undefined> {
    if (!path || !fs.access(path)) {
      return undefined;
    }
    let fd: number = -1;
    try {
      fd = fs.openSync(path, fs.OpenMode.READ_ONLY).fd;
      const imageSource: image.ImageSource = image.createImageSource(fd);
      const imageItem = await imageSource.createPixelMap({
        desiredPixelFormat: format,
      });
      await imageSource.release();
      log.showInfo(TAG, `loadImageFromDisk success PixelBytes: ${imageItem?.getPixelBytesNumber()}`);
      return imageItem;
    } catch (e) {
      log.showError(TAG, 'loadImageFromDisk error');
    } finally {
      if (fd !== -1) {
        fs.closeSync(fd);
      }
    }
    return undefined;
  }

  public static removeNotInstalleddeliverApp(): void {
    let requestBundleNameArray: string[] = [];
    let layoutInfo: GridLayoutItemInfo[] = [];
    LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(TAG).forEach(desktopItem => {
      if (desktopItem.typeId === CommonConstants.TYPE_APP) {
        layoutInfo.push(ObjectCopyUtil.deepClone(desktopItem));
      } else if (desktopItem.typeId === CommonConstants.TYPE_FOLDER) {
        desktopItem.layoutInfo?.flat().forEach(item => {
          layoutInfo.push(ObjectCopyUtil.deepClone(item));
        });
      }
    });
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    residentList.forEach(dockItem => {
      if (dockItem.typeId === CommonConstants.TYPE_APP) {
        layoutInfo.push(ObjectCopyUtil.deepClone(GridLayoutUtil.dockItemToGridLayout(dockItem)));
      } else if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
        dockItem.layoutInfo?.flat().forEach(item => {
          layoutInfo.push(ObjectCopyUtil.deepClone(item));
        });
      }
    });
    layoutInfo.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_APP && !GridLayoutUtil.isAppInstalled(item) &&
      DeliverUtil.isdeliverApp(item.intent ?? '')) {
        let requestBundleName: string = CommonUtils.jsonStrToMap(item.intent)?.get('requestBundleName') as string;
        if (!CheckEmptyUtils.isEmpty(requestBundleName)) {
          requestBundleNameArray.push(requestBundleName);
        }
      }
    });
    AppInstallUtils.getInstance().cancelRestoreLauncherData(requestBundleNameArray);
  }

  /**
   * 是否应该隐藏克隆应用或应用的移出下载任务菜单
   *
   * @param bundleName 应用名称
   * @returns true 隐藏克隆应用或应用的移除任务按钮 false 不隐藏
   */
  public static isHideDhRemoveMenu(bundleName: string): boolean {
    let targetSource = '';
    if (bundleName === DeliverUtil.DELIVER_APP_BUNDLE_NAME_REAL) {
      targetSource = DeliverUtil.DELIVER_APPSTORE_PKG;
    } else if (bundleName === DeliverUtil.ABROAD_APP_APP_BUNDLE_NAME_REAL) {
      targetSource = DeliverUtil.ABROAD_APP_PKG;
    } else {
      return false;
    }
    let layoutInfo: GridLayoutItemInfo[] = [];
    LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList(TAG).forEach(desktopItem => {
      if (desktopItem.typeId === CommonConstants.TYPE_APP) {
        layoutInfo.push(desktopItem);
      }
      if (desktopItem.typeId === CommonConstants.TYPE_FOLDER) {
        let mLayoutInfo = desktopItem.layoutInfo?.flat();
        if (mLayoutInfo) {
          layoutInfo.push(...mLayoutInfo);
        }
      }
    });
    let residentList: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    residentList.forEach(dockItem => {
      if (dockItem.typeId === CommonConstants.TYPE_APP) {
        layoutInfo.push(GridLayoutUtil.dockItemToGridLayout(dockItem));
      }
      if (dockItem.typeId === CommonConstants.TYPE_FOLDER) {
        let mLayoutInfo = dockItem.layoutInfo?.flat();
        if (mLayoutInfo) {
          layoutInfo.push(...mLayoutInfo);
        }
      }
    });
    for (let i = 0; i < layoutInfo.length; i++) {
      let item: GridLayoutItemInfo = layoutInfo[i];
      if (item.typeId === CommonConstants.TYPE_APP &&
        DeliverUtil.getInstallSourceByIntent(item.intent ?? '', true) === targetSource) {
        return true;
      }
    }
    return false;
  }

  public static isStartContainerApp(bundleName: string): boolean {
    return DeliverUtil.isContainerHapExist() && DeliverUtil.isSupportAppType(bundleName) &&
    DeliverUtil.isSupportDeliver() && DeliverUtil.getDeliverStartStatus() !== DeliverUtil.DELIVER_START_FINISHED_CODE;
  }

  /**
   * 文件夹展开态，dh应用不可卸载时，以布局缓存为准刷新下卸载状态
   *
   * @param item 应用信息
   */
  public static refreshContainerAppUninstallStatus(item: GridLayoutItemInfo | AppItemInfo): void {
    if (CheckEmptyUtils.isEmpty(item) || item.isUninstallAble || !DeliverUtil.isContainerItem(item.intent ?? '')) {
      return;
    }
    let cacheAppInfo = AppModel.getInstance().getAppInfoByBundleName(item.bundleName);
    item.isUninstallAble = cacheAppInfo?.isUninstallAble;
  }

  /**
   * 合并克隆应用文件夹
   *
   * @param configFromRdb 内屏布局信息信息
   */
  public static checkAndMergeDeliveryFolder(configFromRdb: GridLayoutItemInfo[]): void {
    let deliveryFolderArr: GridLayoutItemInfo[] = [];
    configFromRdb.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === DELIVER_FOLDERNAME) {
        deliveryFolderArr.push(item);
      }
    });
    if (deliveryFolderArr.length >= 2) {
      let len = deliveryFolderArr.length - 1;
      for (let i = len - 1; i >= 0; i--) {
        let gridLayoutInfo = deliveryFolderArr[i].layoutInfo?.flat();
        log.showError(TAG, 'checkAndMergeDeliveryFolder gridLayoutInfo[%{public}d].length=%{public}d', i,
          gridLayoutInfo?.length);
        gridLayoutInfo?.forEach(item => {
          item.container = deliveryFolderArr[len].id;
        });
        let mLayout = deliveryFolderArr[len].layoutInfo;
        if (mLayout && gridLayoutInfo) {
          mLayout[0] =
            mLayout[0].concat(gridLayoutInfo);
        }
        deliveryFolderArr[i].layoutInfo = [[]];
      }
    }
  }

  /**
   * 合并应用文件夹
   *
   * @param configFromRdb 内屏布局信息信息
   */
  public static checkAndMergeAbroadFolder(configFromRdb: GridLayoutItemInfo[]): void {
    let abroadFolderArr: GridLayoutItemInfo[] = [];
    configFromRdb.forEach(item => {
      if (item.typeId === CommonConstants.TYPE_FOLDER && item.folderName === ABROAD_APP_FOLDERNAME) {
        abroadFolderArr.push(item);
      }
    });
    if (abroadFolderArr.length >= 2) {
      log.showError(TAG, 'checkAndMergeAbroadFolder length=%{public}d', abroadFolderArr.length);
      let remainIdx = 0;
      for (let i = 1; i < abroadFolderArr.length; i++) {
        let gridLayoutInfo = abroadFolderArr[i].layoutInfo?.flat();
        gridLayoutInfo?.forEach(item => {
          item.container = abroadFolderArr[remainIdx].id;
        });
        abroadFolderArr[remainIdx].layoutInfo[0] =
          abroadFolderArr[remainIdx].layoutInfo[0].concat(gridLayoutInfo);
        abroadFolderArr[i].layoutInfo = [[]];
      }
    }
  }

  static isInContainerFolder(item: AppItemInfo): boolean {
    return DeliverUtil.isIndeliverOrEasyAbroadFolder(item, DeliverUtil.containerFolderMap.get(
      DeliverUtil.DELIVER_APPSTORE_PKG) ?? '') || DeliverUtil.isIndeliverOrEasyAbroadFolder(item,
      DeliverUtil.containerFolderMap.get(DeliverUtil.ABROAD_APP_PKG) ?? '');
  }

  static isIndeliverOrEasyAbroadFolder(item: AppItemInfo, folderId: string): boolean {
    if (CheckEmptyUtils.isEmpty(folderId)) {
      log.showInfo(TAG, 'folderId is not exit');
      return false;
    }
    let folderInfo: GridLayoutItemInfo | undefined =
      FolderLayoutCacheManager.getInstance().selectGridLayoutItemByFolderId(folderId, false);
    let folderApps: GridLayoutItemInfo[] = [];
    if (!folderInfo || CheckEmptyUtils.isEmptyArr(folderInfo.layoutInfo)) {
      let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
      if (!CheckEmptyUtils.isEmpty(residentList)) {
        let dockItem: DockItemInfo | undefined =
          residentList.find(item => item.typeId === CommonConstants.TYPE_FOLDER && item.appId === folderId);
        if (!dockItem || !dockItem.layoutInfo || CheckEmptyUtils.isEmptyArr(dockItem.layoutInfo)) {
          log.showInfo(TAG, 'container folder is not exit');
          return false;
        }
        folderApps = dockItem.layoutInfo.flat();
      }
    } else {
      folderApps = folderInfo.layoutInfo?.flat() ?? [];
    }
    let index: number = folderApps.findIndex(folderItem => folderItem.bundleName === item.bundleName);
    log.showInfo(TAG, `${item.bundleName} is in container folder: ${index !== CommonConstants.INVALID_VALUE}`);
    return index !== CommonConstants.INVALID_VALUE;
  }

  /**
   * 场景，启动hap安装详情页面
   *
   * @param hapBundleName  鸿蒙应用包名
   * @param packageName  包名
   */
  public static leavingLakeStartAppGalleryDetail(hapBundleName: string, packageName: string): void {
    let taskParam: string = '{"backup":1,"scene":2,"pkgName":"' + packageName + '"}';
    let taskContext: string = '{"backup":1}';
    log.showInfo(TAG, 'start appGallery taskParam = %{public}s , hapBundleName = %{public}s', taskParam, hapBundleName);
    const want: Want = {
      uri: `id=${hapBundleName}&taskparam=${taskParam}&taskcontext=${taskContext}&scene=leavingLake`,
      action: 'action.system.home'
    };
    try {
      GlobalContext.getContext().startAbility(want);
    } catch (error) {
      log.showError(TAG, 'start appGallery failed %{public}s', error?.message);
    }
  }

  /**
   *  检查应用的安装来源，如果不存在，则重新修正安装来源
   * @param gridLayoutInfo
   * @param operateDb  是否需要落库
   */
  public static checkInstallSource(gridLayoutInfo: GridLayoutItemInfo | AppItemInfo, operateDb?: boolean): void {
    if (!DeliverUtil.isSupportDeliver() || !DeliverUtil.isSupportAppType(gridLayoutInfo.bundleName)) {
      log.showInfo(TAG, 'not support app type');
      return;
    }
    let intentMap: Map<string, Object> = CommonUtils.jsonStrToMap(gridLayoutInfo.intent);
    log.showInfo(TAG, 'checkInstallSource bundleName = %{public}s, InstallSource = %{public}s', gridLayoutInfo.bundleName,
      intentMap.get(KEY_INSTALL_SOURCE));
    if (CheckEmptyUtils.isEmpty(intentMap.get(KEY_INSTALL_SOURCE))) {
      let installSource: string = DeliverUtil.getInstallSourceByBundleName(gridLayoutInfo.bundleName);
      log.showInfo(TAG, 'checkInstallSource getInstallSource %{public}s', installSource);
      intentMap.set(KEY_INSTALL_SOURCE, installSource);
      gridLayoutInfo.intent = CommonUtils.mapToJonStr(intentMap);
      if (operateDb) {
        let infoId: string | undefined =
          gridLayoutInfo instanceof GridLayoutItemInfo ? gridLayoutInfo.infoId : gridLayoutInfo.appId;
        RdbStoreManager.getInstance().updateFolderIntentByInfoId(infoId ?? '', gridLayoutInfo.intent);
      }
    }
  }

  /**
   * 根据installsource过滤目标文件夹对象
   *
   * @param GridLayoutItemInfo 校验对象
   * @param installSource 目标来源
   * @returns 是否是目标文件夹
   */
  public static checkFolderbyInstallSource(folderItem: GridLayoutItemInfo, installSource?: string): boolean {
    if (CheckEmptyUtils.isEmpty(folderItem) || folderItem.typeId !== CommonConstants.TYPE_FOLDER) {
      return false;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(installSource)) {
      return NotHarmonyUtil.isNotHarmonyFolderByIntent(folderItem.intent ?? '');
    }
    if (installSource === DeliverUtil.DELIVER_APPSTORE_PKG) {
      return folderItem.folderName === DELIVER_FOLDERNAME ||
        DeliverUtil.getInstallSourceByIntent(folderItem.intent ?? '', true) === DeliverUtil.DELIVER_APPSTORE_PKG;
    }
    return DeliverUtil.getInstallSourceByIntent(folderItem.intent ?? '', true) === installSource;
  }

  /**
   * 根据DH弹框类型返回弹框的文本和按钮颜色
   *
   * @param installedDialogType 弹框类型
   * @returns string[] 弹框字符串数组
   */
  public static getStringByDialogType(installedDialogType: InstalledDialogType): DialogConfig {
    let dialogTypeIsOpen: boolean = installedDialogType === InstalledDialogType.OPEN;
    const dialogConfig: DialogConfig = {
      content: dialogTypeIsOpen ? 'app.string.open_harmony_app_dialog_content' :
        'app.string.uninstall_deliver_app_dialog_content',
      primaryButton: dialogTypeIsOpen ? 'app.string.deliver_app_dialog_cancel' : 'app.string.cancel',
      secondaryButton: dialogTypeIsOpen ? 'app.string.deliver_app_dialog_open' : 'app.string.uninstall',
      fontColor: dialogTypeIsOpen ? 'sys.color.ohos_id_color_text_primary_activated' :
        'sys.color.ohos_id_color_warning',
    }
    return dialogConfig;
  }

  /**
   * 手势上滑抬手以及Home和Recent按键时，调用ams接口关闭应用弹框
   */
  public static closeSystemWindows(): void {
    try {
      let curSession =
        SCBSceneSessionManager.getInstance().getTopContainerSession(SCBSceneSessionManager.getInstance().mainScreenId);
      let bundleName = curSession?.primarySession?.sceneInfo?.bundleName;
      // 识别是否是应用
      if (!bundleName || !DeliverUtil.isSupportAppType(bundleName)) {
        log.showInfo(TAG, 'bundleName is not support deliver. %{public}s', bundleName);
        return;
      }
      // 识别环境是否正常启动
      if (DeliverUtil.getDeliverStartStatus() !== DeliverUtil.DELIVER_START_FINISHED_CODE) {
        log.showInfo(TAG, 'deliver status is not start.');
        return;
      }
      // abilityFrameworkBroker.returnToHome('recentapps');
      log.showInfo(TAG, 'closeSystemWindows success');
    } catch (e) {
      log.warn('closeSystemWindows error ' + e);
    }
  }

  private static createDeliverAppMap(): Map<string, string> {
    let deliverAppMap: Map<string, string> = new Map([
      [DeliverUtil.DELIVER_TRANSFER_BUNDLE_NAME, '0'],
      [DeliverUtil.DELIVER_BROWSER_BUNDLE_NAME, '1'],
      [DeliverUtil.ABROAD_APP_TRANSFER_BUNDLE_NAME, '0'],
      [DeliverUtil.ABROAD_APP_FEEDBACK_BUNDLE_NAME, '1']
    ]);
    if(DeliverUtil.CANCEL_DELIVER_FOLDER){
      deliverAppMap.delete(DeliverUtil.DELIVER_TRANSFER_BUNDLE_NAME);
      deliverAppMap.delete(DeliverUtil.DELIVER_BROWSER_BUNDLE_NAME);
    }
    return deliverAppMap;
  }
}

export interface DialogConfig {
  content: string;
  primaryButton: string;
  secondaryButton: string;
  fontColor: string;
}

export enum AppType {
  // 普通应用
  COMMON_APP = 0,
  // deliver 应用
  DELIVER_APP = 1,
  // 未鸿蒙化应用
  NOT_HARMONY_APP = 2
}

export interface IBaseExtendInfo {
  legacyInfo: LegacyInfo;
  targetModuleUrl: string;
  requestBundleName: string;
  installSource?: string;
  appType: number;
  maskState: number;
}