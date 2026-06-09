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

import {
  FileUtils,
  LogDomain,
  Logger,
  CheckEmptyUtils,
  PixelMapUtil,
} from '@ohos/basicutils';
import {
  GlobalContext,
  DeviceHelper,
  ContextModifyUtils,
  GraphicUtils,
  ResourceManager
} from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { NumberConstants } from '@ohos/commonconstants';
import relationalStore from '@ohos.data.relationalStore';
import { BackupFavoriteInfo, BackupItemType } from '../model/BackupFavoriteInfo';
import preferences from '@ohos.data.preferences';
import convertXml from '@ohos.convertxml';
import { AppStatus, CommonConstants, DesktopSettingConstants } from '../constants/CommonConstants';
import type { AppItemInfo } from '../bean/AppItemInfo';
import type ctx from '@ohos.app.ability.common';
import fileIo from '@ohos.file.fs';
import type GridLayoutItemInfo from '../bean/GridLayoutItemInfo';
import data_rdb from '@ohos.data.relationalStore';
import GridLayoutItemDbBuilder from '../entity/GridLayoutItemDbBuilder';
import settings from '@ohos.settings';
import BackupExtensionContext from '@ohos.file.BackupExtensionContext';
import { common, Context, contextConstant } from '@kit.AbilityKit';
import { CloneCloudRequestMethod } from '../constants/DesktopServiceConstant';
import {
  Extend1Data,
  PageInfoManager,
  ShortcutInfo,
  ShortcutViewModel
} from '../TsIndex';
import { image } from '@kit.ImageKit';
import { IntentParseUtil } from '../utils/IntentParseUtil';

const TAG = 'UpdateRdbManager';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);
const LAUNCHERDB = 'launcher.db';
const LAUNCHERDB_BACK = 'launcher_back.db';
const BACK_DATABASE_PATH = 'restore/com.ohos.sceneboard/de/databases';
const BACK_SP_PATH = 'restore/com.ohos.sceneboard/de/shared_prefs';
const SHORTCUT_PATH = 'restore/com.ohos.sceneboard/shortcuts';
const ABROAD_VIRTUALICON_PATH = 'restore/com.ohos.sceneboard/icon_backup';
const MAX_KEY_LENGTH = 80;
const ICONDB = 'app_icons.db';
const ICONDB_BACK = 'app_icons_back.db';
const OUC_ICON_DB = 'app_icon.db';
const OUC_ICON_DB_BACK = 'app_icon_back.db';
const OLD_ICON_FOLDER_NAME = '/oldIcons';
const DB_SUFFIX_JOURNAL = '-journal';
const FORM_MAPPING_RELATION_TABLE = 'form_mapping_relation_table.json';
const BACK_FORM_RELATION_PATH = 'restore/' + FORM_MAPPING_RELATION_TABLE;
const FORM_TRANSPARENT: string = '1';
const HI_BOARD_SP_KEY: string = 'PIFLOW_NEWS_SWITCH';
const HI_BOARD_DATABASE_KEY: string = 'piflow_mine_state';
const INTENT_INFO_MAP_INDEX = 4;
const EXCEPTION_ID_ZERO = '0';
const EXCEPTION_ID_NEGATIVE_ONE = '-1';
const USER_ID_ADAPTER_GAP: number = 91;
const DEFAULT_USER_ID: number = 100;
const CLONEDPROFILE_USER_ID_MIN = 128;
const CLONEDPROFILE_USER_ID_MAX = 148;
const CONTACT_BUNDLE_NAME: string = 'com.ohos.contacts';

interface AttributesObject {
  name: string,
  value: string
}

interface CovertObject {
  _name: string,
  _text: string,
  _type: string,
  _attributes: AttributesObject,
  _declaration: Object,
  _elements: CovertObject[]
}

class UpdateRdbManager {
  // /data/storage/el1/database/phone_sceneboard
  private databaseDir: string = '';
  // /data/storage/el1/base/haps/phone_sceneboard/files
  private filesDir: string = '';
  // /data/storage/el1/backup/ => /data/storage/el1/base/haps/phone_sceneboard/files
  private backupDir: string = '';
  private backupDatabaseDir: string = '';
  private backupSPDir: string = '';
  private mLauncherRdbStore: relationalStore.RdbStore | null = null;
  private mNotificationRdbStore: relationalStore.RdbStore | null = null;
  private mIconRdbStore: relationalStore.RdbStore | null = null;
  private shortcutSupportClone: boolean = false;

  private constructor() {
    let serviceExtensionContext: ctx.ServiceExtensionContext = GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext;
    let callback: Function = (context : common.Context) => {
      this.databaseDir = context.databaseDir;
      log.showInfo(TAG, `databaseDir is --- ${this.databaseDir}`);
      this.filesDir = context.filesDir;
      log.showInfo(TAG, `filesDir is --- ${this.filesDir}`);

      let backupExtensionContext: BackupExtensionContext = GlobalContext.getInstance().getObject('desktopContext') as BackupExtensionContext;
      this.backupDir = backupExtensionContext.backupDir;
      log.showInfo(TAG, `backupDir is --- ${this.backupDir}`);

      this.backupDatabaseDir = this.backupDir + BACK_DATABASE_PATH;
      this.backupSPDir = this.backupDir + BACK_SP_PATH;
    };
    ContextModifyUtils.modifyTargetContext(serviceExtensionContext, contextConstant.AreaMode.EL1, callback,
      `${TAG}-constructor`, false);
  }

  static getInstance(): UpdateRdbManager {
    if (globalThis.UpdateRdbManagerInstance == null) {
      globalThis.UpdateRdbManagerInstance = new UpdateRdbManager();
    }
    return globalThis.UpdateRdbManagerInstance;
  }

  /**
   * 开启迁移
   */
  public async startRdbMigrate(): Promise<void> {
    await this.startCopyIcon();
    this.copyOUCIconDb();
    this.copyShortcutIcon();
    this.mLauncherRdbStore = await this.copyLauncherDb();
    await this.cloneAllSP();
    await this.copyFormMappingRelation();
    await this.saveDesktopSettings();
  }

  private copyOUCIconDb(): void {
    log.showInfo(TAG, `copyOUCIconDb : ${this.backupDir + '/restore/' + OUC_ICON_DB}`);
    if (FileUtils.isExist(this.backupDir + '/restore/' + OUC_ICON_DB)) {
      FileUtils.copyFile(this.backupDir + '/restore/' + OUC_ICON_DB, this.databaseDir + '/rdb/' + OUC_ICON_DB_BACK);
      log.showInfo(TAG, `copyOUCIconDb dest path : ${this.databaseDir + '/rdb/' + OUC_ICON_DB_BACK}`);
    }
  }

  private copyShortcutIcon(): void {
    let srcShortcutsDir: string = this.backupDir + SHORTCUT_PATH;
    if (!FileUtils.isExist(srcShortcutsDir)) {
      log.showWarn(TAG, `copyShortcutIcon, srcShortcutsDir: ${srcShortcutsDir} not exist.`);
      return;
    }
    let files: string[] = FileUtils.getFileList(srcShortcutsDir);
    if (CheckEmptyUtils.isEmptyArr(files)) {
      log.showWarn(TAG, `copyShortcutIcon, srcShortcutsDir: ${srcShortcutsDir} has no files.`);
      return;
    }
    let targetShortcutsDir: string = this.filesDir + OLD_ICON_FOLDER_NAME;
    FileUtils.createFolder(targetShortcutsDir);
    files.forEach(fileName => FileUtils.copyFile(`${srcShortcutsDir}/${fileName}`, `${targetShortcutsDir}/${fileName}`));
    log.showInfo(TAG, `copyShortcutIcon end, files length: ${files.length}`);
  }

  public async generateIconByBundleNamesAndUserId(packageNames: string [], userId: number): Promise<void> {
    let resultSet: relationalStore.ResultSet | null = null;
    try {
      if (CheckEmptyUtils.isEmptyArr(packageNames)) {
        log.showInfo(TAG, 'generateIconByBundleNamesAndUserId getEmpty packageNames');
        return;
      }
      let adaptUserId: number = this.getAdaptUserId(userId);
      log.showInfo(TAG, 'generateIcon start userId = %{public}d, adaptUserId = %{public}d', userId, adaptUserId);
      const iconStoreConfig: relationalStore.StoreConfig = {
        name: OUC_ICON_DB_BACK,
        securityLevel: relationalStore.SecurityLevel.S1
      };
      let rdRdbStore: relationalStore.RdbStore =
        await relationalStore.getRdbStore(GlobalContext.getContext(), iconStoreConfig);
      if (!rdRdbStore) {
        log.showError(TAG, 'generateIcon get rdRdbStore is null or undefined');
        return;
      }
      const predicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(`app_icon_${adaptUserId}`);
      predicates.in('package', packageNames);
      resultSet = await rdRdbStore.query(predicates);
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let iconBase64: string = this.getImageRes(resultSet.getString(resultSet.getColumnIndex('app_icon')));
        const packageName: string = resultSet.getString(resultSet.getColumnIndex('package'));
        await this.writeBase64ToLocal(iconBase64, packageName);
        isLast = resultSet.goToNextRow();
      }
    } catch (error) {
      log.showError(TAG, 'generateIcon error: %{public}s', error?.message);
    } finally {
      resultSet?.close();
      relationalStore.deleteRdbStore(GlobalContext.getContext(), OUC_ICON_DB_BACK);
      log.showInfo(TAG, 'generateIcon delete dbName %{public}s', OUC_ICON_DB_BACK);
    }
  }

  private async writeBase64ToLocal(iconBase64: string, packageName: string): Promise<void> {
    log.showInfo(TAG, 'writeBase64ToLocal length :%{public}d, packageName: %{public}s', iconBase64?.length, packageName);
    let imagePackerApi: image.ImagePacker | null = null;
    try {
      let pixelMap: image.PixelMap = await GraphicUtils.changeBase64ToPixel(iconBase64);
      PixelMapUtil.addName(pixelMap, 'UpdateRdbMgr_generateIcon');
      imagePackerApi = image.createImagePacker();
      imagePackerApi.packing(pixelMap, { format: 'image/png', quality: 100 }).then(buffer => {
        this.saveLocalIcon(packageName, buffer);
      }).catch((e: Error) => {
        log.showError(TAG, 'writeBase64ToLocal packing error: %{public}s', e?.message);
      });
    } catch (error) {
      log.showError(TAG, 'writeBase64ToLocal error: %{public}s', error?.message);
    } finally {
      imagePackerApi?.release();
    }
  }

  private getImageRes(base64Res: string): string {
    if (CheckEmptyUtils.isEmpty(base64Res)) {
      return '';
    }
    let imageHeader: string = 'data:image/png;base64,';
    return imageHeader + base64Res;
  }

  private getAdaptUserId(userId: number): number {
    return userId === DEFAULT_USER_ID ? 0 : (userId - USER_ID_ADAPTER_GAP);
  }

  /**
   * 保存桌面下拉搜索开关选项、负一屏下拉、自动对齐开关、锁定布局开关
   * @returns
   */
  public async saveDesktopSettings(): Promise<void> {
    let applicationContext: ctx.ApplicationContext =
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext).getApplicationContext();
    if (!applicationContext) {
      log.showError(TAG, 'saveDesktopSettings applicationContext is null or undefined');
      return;
    }

    let callback: Function = async (contextCallback: Context) => {
      try {
        let sp = await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext), 'LAUNCHER_SETTINGS');
        let lockLayoutStatus: boolean = false;
        let desktopSettingPreferences = await preferences.getPreferences(contextCallback, DesktopSettingConstants.PREFERENCES_NAME);
        desktopSettingPreferences.putSync(DesktopSettingConstants.LOCK_LAYOUT_STATE, lockLayoutStatus);
        let hiBoardOpenStatus: boolean = sp.getSync(HI_BOARD_SP_KEY, true) as boolean;
        try {
          let saveResult: boolean = settings.setValueSync(GlobalContext.getContext(), HI_BOARD_DATABASE_KEY,
            String(hiBoardOpenStatus), settings.domainName.USER_SECURITY);
          log.showInfo(TAG, 'save launcher hiBoardStatus:%{public}s, saveResult:%{public}s', hiBoardOpenStatus, saveResult);
        } catch (err) {
          log.showError(TAG, 'saveDesktopSettings err : %{public}s', err?.message);
        }
        let settingSp = await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as
        ctx.ServiceExtensionContext), CloneCloudRequestMethod.RESTORE_LAUNCHER_LAYOUT + '_preferences');
        let autoAlignStatus: boolean = false;
        desktopSettingPreferences.putSync(DesktopSettingConstants.AUTOMATIC_FILLING_STATE, autoAlignStatus);
        await desktopSettingPreferences.flush().then(() => {
          log.showInfo(TAG, 'save searchStatus:%{public}s,autoAlignStatus:%{public}s,lockLayoutStatus:%{public}s success',
             autoAlignStatus, lockLayoutStatus);
        }).catch((error: Error) => {
          log.showError(TAG, 'save searchStatus:%{public}s,autoAlignStatus:%{public}s fail,result = %{public}', autoAlignStatus, error?.message);
        });
      } catch (error) {
        log.showError(TAG, 'saveDesktopSettings error, %{public}s', error?.message);
      }
    };
    await ContextModifyUtils.modifyTargetContextAsync(applicationContext, contextConstant.AreaMode.EL1, callback,
      `${TAG}-saveDesktopSettings`);
  }

  public async startCopyIcon(): Promise<void> {
    this.mIconRdbStore = await this.copyIconDb();
    if (this.mIconRdbStore !== null) {
      await this.queryIconDbDesktopInfo(false);
    }
  }

  private async copyIconDb(): Promise<relationalStore.RdbStore | null> {
    if (FileUtils.isExist(this.backupDatabaseDir + '/' + ICONDB)) {
      FileUtils.copyFile(this.backupDatabaseDir + '/' + ICONDB, this.databaseDir + '/rdb/' + ICONDB_BACK);
      if (FileUtils.isExist(this.backupDatabaseDir + '/' + ICONDB + DB_SUFFIX_JOURNAL)) {
        FileUtils.copyFile(this.backupDatabaseDir + '/' + ICONDB + DB_SUFFIX_JOURNAL,
          this.databaseDir + '/rdb/' + ICONDB_BACK + DB_SUFFIX_JOURNAL);
      }
      try {
        const iconStoreConfig: relationalStore.StoreConfig = {
          name: ICONDB_BACK,
          securityLevel: relationalStore.SecurityLevel.S1
        };
        return relationalStore.getRdbStore(globalThis.desktopContext, iconStoreConfig);
      } catch (e) {
        log.showError(TAG, 'copyIconDb error: %{public}s', e?.message);
        return null;
      }
    }
    return null;
  }

  /**
   * set the iconRdbStore
   *
   * @param iconRdbStore iconRdbStore
   */
  public setIconRdbStore(iconRdbStore: relationalStore.RdbStore): void {
    log.showInfo(TAG, 'set the iconRdbStore');
    this.mIconRdbStore = iconRdbStore;
  }

  /**
   * 查询 app_icons.db的icons表
   *
   * @param isFromClone
   * @returns void
   */
  public async queryIconDbDesktopInfo(isFromClone: boolean): Promise<void> {
    try {
      const TABLE_NAME = isFromClone ? 'comopenharmonylaunchersettingsapp_icons_tb' : 'icons';
      log.showInfo(TAG, `queryIconDbDesktopInfo start from table ${TABLE_NAME}, isFromClone: ${isFromClone}`);
      const iconPredicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      let resultSet: relationalStore.ResultSet | undefined = await this.mIconRdbStore?.query(iconPredicates);
      if (!resultSet) {
        return;
      }
      let isLast: boolean = resultSet.goToFirstRow();
      if (!FileUtils.isExist(this.filesDir + OLD_ICON_FOLDER_NAME)) {
        FileUtils.createFolder(this.filesDir + OLD_ICON_FOLDER_NAME);
      }
      while (isLast) {
        let bmpBuffer: ArrayBufferLike = resultSet.getBlob(resultSet.getColumnIndex('icon')).buffer;
        const componentNameArray: string[] = resultSet.getString(resultSet.getColumnIndex('componentName')).split('/');
        // const fileName: string = componentNameArray.join('');
        // 目前接口只提供packageName，暂时先用componentNameArray[0],后续恢复上面的文件名
        const fileName: string = componentNameArray[0];
        const profileId: number = resultSet.getLong(resultSet.getColumnIndex('profileId'));
        // 剔除分身图标
        if (profileId < CLONEDPROFILE_USER_ID_MIN || profileId >= CLONEDPROFILE_USER_ID_MAX) {
          let scaleBmpBuffer: ArrayBufferLike = await this.scaleBmpBuffer(bmpBuffer);
          this.saveLocalIcon(fileName, scaleBmpBuffer);
        }
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError(TAG, 'queryIconDbDesktopInfo error: %{public}s', e?.message);
    }
    log.showInfo(TAG, 'queryIconDbDesktopInfo end');
  }

  private async scaleBmpBuffer(buff: ArrayBufferLike): Promise<ArrayBufferLike> {
    let source: image.ImageSource | null = null;
    let pixelMap: image.PixelMap | null = null;
    let imagePacker: image.ImagePacker | null = null;
    try {
      source = image.createImageSource(buff);
      let format: image.PixelMapFormat = image.PixelMapFormat.RGBA_8888;
      pixelMap = await source.createPixelMap({
        desiredPixelFormat: format
      });
      if (pixelMap) {
        const sizeBeforeScale = pixelMap.getImageInfoSync().size;
        // 将图标放大1.12倍
        await pixelMap.scale(CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE, CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE);
        let region: image.Region = {
          x: (CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE - 1) * sizeBeforeScale.width / 2,
          y: (CommonConstants.MIGRATE_PLACEHOLDER_ICON_SCALE - 1) * sizeBeforeScale.height / 2,
          size: { height: sizeBeforeScale.height, width: sizeBeforeScale.width }
        };
        // 裁剪多余部分
        await pixelMap.crop(region);
        imagePacker = image.createImagePacker();
        let scaleBuffer: ArrayBufferLike = await imagePacker.packing(pixelMap, {
          format: 'image/png',
          quality: 100,
        });
        return scaleBuffer;
      }
    } catch (e) {
      log.showError(TAG, `scaleBmpBuffer error: ${e?.message} ${e.stack}`);
    } finally {
      source?.release();
      pixelMap?.release();
      imagePacker?.release();
    }
    return buff;
  }

  private saveLocalIcon(fileName: string, bmpBuffer: ArrayBufferLike): void {
    try {
      if (!FileUtils.isExist(this.filesDir + OLD_ICON_FOLDER_NAME)) {
        FileUtils.createFolder(this.filesDir + OLD_ICON_FOLDER_NAME);
      }
      const fileNameWithoutPoint: string = fileName.split('.').join('');
      let filesPath: string = this.filesDir + OLD_ICON_FOLDER_NAME + '/' + fileNameWithoutPoint + '.bmp';
      if (FileUtils.isExist(filesPath)) {
        return;
      }
      let bmpFile: fileIo.File = FileUtils.openFile(filesPath, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
      FileUtils.writeBufferToFile(bmpFile, bmpBuffer);
      FileUtils.closeFile(bmpFile);
    } catch (error) {
      log.showError(TAG, 'saveLocalIcon to local error: %{public}s', error?.message);
    }
  }

  private async copyLauncherDb(): Promise<relationalStore.RdbStore | null> {
    log.showInfo(TAG, `copyLauncherDb ${this.backupDatabaseDir + '/' + LAUNCHERDB}`);
    if (FileUtils.isExist(this.backupDatabaseDir + '/' + LAUNCHERDB)) {
      log.showInfo(TAG, `copy file ${this.backupDatabaseDir + '/' + LAUNCHERDB}`);
      FileUtils.copyFile(this.backupDatabaseDir + '/' + LAUNCHERDB, this.databaseDir + '/rdb/' + LAUNCHERDB_BACK);
      if (FileUtils.isExist(this.backupDatabaseDir + '/' + LAUNCHERDB + DB_SUFFIX_JOURNAL)) {
        FileUtils.copyFile(this.backupDatabaseDir + '/' + LAUNCHERDB + DB_SUFFIX_JOURNAL,
          this.databaseDir + '/rdb/' + LAUNCHERDB_BACK + DB_SUFFIX_JOURNAL);
      }
      const launcherStoreConfig: relationalStore.StoreConfig = {
        name: LAUNCHERDB_BACK,
        securityLevel: relationalStore.SecurityLevel.S1
      };
      return relationalStore.getRdbStore((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), launcherStoreConfig);
    }
    return null;
  }

  /**
   * set the launcherRdbStore
   *
   * @param launcherRdbStore launcherRdbStore
   */
  public async setLauncherRdbStore(launcherRdbStore: relationalStore.RdbStore): Promise<void> {
    log.showInfo(TAG, 'set the launcherRdbStore');
    this.mLauncherRdbStore = launcherRdbStore;
  }

  /**
   * get the launcherRdbStore
   *
   * @returns launcherRdbStore
   */
  public getLauncherRdbStore(): relationalStore.RdbStore | null {
    return this.mLauncherRdbStore;
  }

  /**
   * set the notificationRdbStore
   *
   * @param notificationRdbStore notificationRdbStore
   */
  public async setNotificationRdbStore(notificationRdbStore: relationalStore.RdbStore): Promise<void> {
    log.showInfo(TAG, 'set the notificationRdbStore');
    this.mNotificationRdbStore = notificationRdbStore;
  }

  public async queryNotificationSetting(): Promise<BackupNotificationSettingsInfo[]> {
    const SETTING_TABLE = 'comhuaweisystemmanagerCommonPrefBackupProviderCommonPreferences_tb';
    log.showInfo(TAG, 'queryNotificationSettingByKey start');
    let backupSettingsInfoList: BackupNotificationSettingsInfo[] = [];
    try {
      let resultSet: relationalStore.ResultSet | undefined =
        await this.mNotificationRdbStore?.querySql(`SELECT preference_key, preference_value FROM ${SETTING_TABLE}`);
      if (!resultSet) {
        return backupSettingsInfoList;
      }
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let settingsInfo: BackupNotificationSettingsInfo = {
          preferenceKey: resultSet.getString(resultSet.getColumnIndex('preference_key')),
          preferenceValue: resultSet.getString(resultSet.getColumnIndex('preference_value'))
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError(TAG, 'queryNotificationSettingByKey error:' + e);
    }
    log.showInfo(TAG, `queryNotificationSettingByKey backupInfoList length = ${backupSettingsInfoList.length}`);
    return backupSettingsInfoList;
  }

  public async queryNotificationAppSetting(): Promise<BackupNotificationAppSettingsInfo[]> {
    const APP_SETTING_TABLE = 'appNotificationTable';
    log.showInfo(TAG, 'queryNotificationAppSetting start');
    let backupSettingsInfoList: BackupNotificationAppSettingsInfo[] = [];
    try {
      let resultSet: relationalStore.ResultSet | undefined =
        await this.mNotificationRdbStore?.querySql(`SELECT appBundle, uid, key, pinTopEnable FROM ${APP_SETTING_TABLE}`);
      if (!resultSet) {
        return backupSettingsInfoList;
      }
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let settingsInfo: BackupNotificationAppSettingsInfo = {
          appBundle: resultSet.getString(resultSet.getColumnIndex('appBundle')),
          uid: resultSet.getString(resultSet.getColumnIndex('uid')),
          key: resultSet.getString(resultSet.getColumnIndex('key')),
          pinTopEnable: resultSet.getString(resultSet.getColumnIndex('pinTopEnable'))
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError(TAG, 'queryNotificationSettingByKey error:' + e);
    }
    log.showInfo(TAG, `queryNotificationSettingByKey backupInfoList length = ${backupSettingsInfoList.length}`);
    return backupSettingsInfoList;
  }

  /**
   * select current layout size
   *
   * @returns CurrentLayout
   */
  public async queryCurrentLayout(isOuter: boolean): Promise<number[]> {
    let curLayoutRow = 0;
    let curLayoutCol = 0;
    let curLayoutName = isOuter ? 'OUTER_DESKTOP_LAYOUT_INFO' : 'DESKTOP_LAYOUT_INFO';
    try {
      await preferences.getPreferences((GlobalContext.getInstance()
        .getObject('desktopContext') as ctx.ServiceExtensionContext), curLayoutName)
        .then((preference) => {
          curLayoutCol = preference.getSync('column', CommonConstants.DEFAULT_COL) as number;
          curLayoutRow = preference.getSync('row', CommonConstants.DEFAULT_ROW) as number;
        }).catch((reason: Error) => {
          log.showError(TAG, `getPreferences error ${reason}`);
        });
    } catch (e) {
      log.showError(TAG, `getPreferences error ${e.message}`);
    }
    return [curLayoutCol, curLayoutRow];
  }

  private async copyFormMappingRelation(): Promise<void> {
    if (FileUtils.isExist(this.backupDir + BACK_FORM_RELATION_PATH)) {
      FileUtils.copyFile(this.backupDir + BACK_FORM_RELATION_PATH, this.filesDir + '/' + FORM_MAPPING_RELATION_TABLE);
    }
  }

  /**
   * 保存克隆端旧的布局大小
   *
   * @returns void
   */
  private async saveOldLayoutToContextOnClone(settingsInfoList: BackupSettingsInfo[]): Promise<void> {
    let layoutSetting: String[] = [];
    let defaultLayoutIndexSetting: number = -1;
    settingsInfoList.forEach(settingsInfo => {
      if (settingsInfo.filename === 'LAUNCHER_SETTINGS' && settingsInfo.name === 'DESKTOP_LAYOUT_CELLS') {
        log.showInfo(TAG, `the layout setting: ${settingsInfo.value}`);
        layoutSetting = settingsInfo.value?.split(',');
      }
      if (settingsInfo.filename === 'LAUNCHER_SETTINGS' && settingsInfo.name === 'DEFAULT_DESKTOP_LAYOUT_INDEX') {
        log.showInfo(TAG, `the default layout index setting: ${settingsInfo.value}`);
        defaultLayoutIndexSetting = parseInt(settingsInfo.value);
      }
    });
    let oldLayoutCol = CommonConstants.DEFAULT_COL;
    let oldLayoutRow = CommonConstants.DEFAULT_ROW;
    if (layoutSetting.length !== 0 && layoutSetting.length > defaultLayoutIndexSetting) {
      let curLayoutArr: string[] = layoutSetting[defaultLayoutIndexSetting].split('x');
      if (curLayoutArr.length === NumberConstants.CONSTANT_NUMBER_TWO) {
        oldLayoutCol = parseInt(curLayoutArr[0]);
        oldLayoutRow = parseInt(curLayoutArr[1]);
      }
    }
    GlobalContext.getInstance().setObject('oldLayoutGrid', [oldLayoutCol, oldLayoutRow]);
  }

  /**
   * 获取克隆数据库，处理桌面设置数据
   *
   * @returns void
   */
  public async preprocessLauncherSettingData(): Promise<void> {
    let settingsInfoList: BackupSettingsInfo[] = await this.queryLauncherDbSettingInfo();
    await this.saveOldLayoutToContextOnClone(settingsInfoList);
    await this.transLauncherSetting(settingsInfoList);
  }

  /**
   * 写入克隆桌面设置
   *
   * @returns void
   */
  private async transLauncherSetting(settingsInfoList: BackupSettingsInfo[]): Promise<void> {
    let applicationContext: ctx.ApplicationContext = (GlobalContext.getInstance().getObject('desktopContext') as
    ctx.ServiceExtensionContext).getApplicationContext();
    if (!applicationContext) {
      log.showError(TAG, 'putSettingInPreferencesArr applicationContext is null or undefined');
      return;
    }
    let callback: Function = async (contextCallback: Context) => {
      let desktopSettingPreferences: preferences.Preferences | undefined = undefined;
      try {
        desktopSettingPreferences =
          await preferences.getPreferences(contextCallback, DesktopSettingConstants.PREFERENCES_NAME);
      } catch (e) {
        log.showError(TAG, 'transLauncherSetting getPreferences error : %{public}s', e?.message);
      }
      if (!desktopSettingPreferences) {
        log.showError(TAG, 'desktopSettingPreferences is undefined');
        return;
      }
      settingsInfoList.forEach(settingsInfo => {
        if (!desktopSettingPreferences) {
          return;
        }
      });
      desktopSettingPreferences.flush();
    };
    await ContextModifyUtils.modifyTargetContextAsync(applicationContext, contextConstant.AreaMode.EL1, callback,
      `${TAG}-transLauncherSetting`);
  }


  private async queryLauncherDbSettingInfo(): Promise<BackupSettingsInfo[]> {
    const FAVORITE_NAME = 'comopenharmonylaunchersettingssettings_tb';
    log.showInfo(TAG, 'queryLauncherDbSettingInfo start from table settings_tb');
    let backupSettingsInfoList: BackupSettingsInfo[] = [];
    try {
      let resultSet: relationalStore.ResultSet | undefined =
        await this.mLauncherRdbStore?.querySql(`SELECT filename, _id, name, type, value FROM ${FAVORITE_NAME}`);
      if (!resultSet) {
        return backupSettingsInfoList;
      }
      let isLast: boolean = resultSet.goToFirstRow();
      while (isLast) {
        let settingsInfo: BackupSettingsInfo = {
          filename: resultSet.getString(resultSet.getColumnIndex('filename')),
          id: resultSet.getLong(resultSet.getColumnIndex('_id')),
          name: resultSet.getString(resultSet.getColumnIndex('name')),
          type: resultSet.getString(resultSet.getColumnIndex('type')),
          value: resultSet.getString(resultSet.getColumnIndex('value'))
        };
        backupSettingsInfoList.push(settingsInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
    } catch (e) {
      log.showError(TAG, 'queryLauncherDbSettingInfo error:' + e);
    }
    log.showWarn(TAG, `queryLauncherDbSettingInfo backupInfoList length = ${backupSettingsInfoList.length}`);
    return backupSettingsInfoList;
  }

  private async dealBackupInfo(backupInfoList: GridLayoutItemInfo[], item: GridLayoutItemInfo, isInstalled: boolean,
    restoreInfoMap: Map<string, Array<string>>, backupFromPc: boolean): Promise<void> {
    if (item?.typeId === CommonConstants.TYPE_APP) {
      this.dealBackupApp(backupInfoList, item, isInstalled, restoreInfoMap, backupFromPc);
    } else if (item?.typeId === CommonConstants.TYPE_CARD) {
      this.dealBackupCard(backupInfoList, item);
    } else if (item?.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
      await this.dealBackupShortCut(backupInfoList, item, isInstalled, restoreInfoMap);
    } else {
      backupInfoList.push(item);
    }
  }

  public async queryCloneSourceHMLayoutInfo(restoreInfoMap: Map<string, Array<string>>, appList: AppItemInfo[],
    isOuter: boolean, backupFromPc: boolean = false): Promise<GridLayoutItemInfo[]> {
    log.showInfo(TAG, 'queryCloneSourceHMLayoutInfo start, isOuter=%{public}s', isOuter);
    let backupInfoList: GridLayoutItemInfo[] = [];
    const GRID_LAYOUT_TABLE_NAME = isOuter ? 'outer_gridlayout_info' : 'gridlayout_info';
    let predicates = new data_rdb.RdbPredicates(GRID_LAYOUT_TABLE_NAME);
    predicates.isNotNull('_id');
    predicates.isNotNull('type_id');
    let resultSet: relationalStore.ResultSet | undefined = await this.mLauncherRdbStore?.query(predicates);
    if (!resultSet) {
      return backupInfoList;
    }
    let isPageBlankRecord: Map<number, boolean> = new Map();
    // 行数最小为5,列数最小为4
    let maxOldLayoutRow: number = NumberConstants.CONSTANT_NUMBER_FIVE;
    let maxOldLayoutColumn: number = NumberConstants.CONSTANT_NUMBER_FOUR;
    let count = resultSet.rowCount;
    if (count === 0 || typeof count === 'string') {
      log.showInfo(TAG, `${TAG}` + 'Query no results!');
    } else {
      resultSet.goToFirstRow();
      this.shortcutSupportClone = GlobalContext.getInstance().getObject(CommonConstants.SHORTCUT_CLONE) as string === 'true';
      for (let i = 0; i < count; i++) {
        let item = GridLayoutItemDbBuilder.fromResultSet(resultSet).buildGridLayoutItemDB().toGridLayoutItemInfo();
        if (item.page !== undefined && item.container === -100) {
          isPageBlankRecord.set(item.page, true);
        }
        // 需要恢复的应用且已经安装的不设置预下载状态
        let isInstalled: boolean = this.isInstalled(appList, item.bundleName, item.appIndex ?? 0);
        isInstalled = isInstalled && (item.appStatus !== AppStatus.WAIT_FOR_HARMONY);
        await this.dealBackupInfo(backupInfoList, item, isInstalled, restoreInfoMap, backupFromPc);
        if (item.container === CommonConstants.CONTAINER_DESKTOP && item.row !== undefined &&
          item.column !== undefined && item.area) {
          maxOldLayoutRow = Math.max(maxOldLayoutRow, item.row + item.area[1]);
          maxOldLayoutColumn = Math.max(maxOldLayoutColumn, item.column + item.area[0]);
        }
        log.showWarn(TAG,
          'item =%{public}s,typeId:%{public}d,isInstalled:%{public}s,infoid:%{public}s,page:%{public}d,row:%{public}d,cloumn:%{public}d,container:%{public}d,callerName:%{public}s,intent:%{public}s',
          item.bundleName, item.typeId, isInstalled, item.infoId, item.page, item.row, item.column, item.container,
          item.callerName, item.intent);
        resultSet.goToNextRow();
      }
    }
    GlobalContext.getInstance().setObject(CommonConstants.SHORTCUT_CLONE, '');
    GlobalContext.getInstance().setObject('maxOldLayoutSize', [maxOldLayoutColumn, maxOldLayoutRow]);
    log.showInfo(TAG, `backupInfoList size ${backupInfoList.length},maxOldLayoutColumn:${maxOldLayoutColumn},maxOldLayoutRow:${maxOldLayoutRow}`);
    resultSet.close();
    return backupInfoList;
  }

  private dealBackupApp(backupInfoList: GridLayoutItemInfo[], appInfo: GridLayoutItemInfo, isInstalled: boolean,
    restoreInfoMap: Map<string, Array<string>>, backupFromPc: boolean = false): void {
    if (isInstalled) {
      backupInfoList.push(appInfo);
      return;
    }
    let keyName = appInfo?.bundleName + (appInfo?.appIndex ?? 0);
    if (!restoreInfoMap.has(keyName)) {
      log.showWarn(TAG, `dealBackupApp error as the app is not installed and not placeHolder keyName:${keyName}`);
      return;
    }
    // 针对RestoreLauncherData透传的图标进行资源补充，默认数据库uri
    let itemInfoList: string[] = [];
    itemInfoList = restoreInfoMap.get(keyName) ?? [];
    appInfo.appStatus = AppStatus.PENDING;
    appInfo.iconResource = itemInfoList[0];
    appInfo.appName = itemInfoList[1];
    appInfo.callerName = itemInfoList[2];
    this.dealContainerAppCloneData(restoreInfoMap, appInfo, keyName);
    if (itemInfoList.length > INTENT_INFO_MAP_INDEX && !CheckEmptyUtils.isEmpty(itemInfoList[INTENT_INFO_MAP_INDEX])) {
      appInfo.intent = itemInfoList[INTENT_INFO_MAP_INDEX];
    }
    if (!backupFromPc) {
      appInfo.moduleName = '';
      appInfo.abilityName = '';
    }
    appInfo.appIconId = 0;
    appInfo.appLabelId = 0;
    backupInfoList.push(appInfo);
  }

  private dealBackupCard(backupInfoList: GridLayoutItemInfo[], formInfo: GridLayoutItemInfo): void {
    if (CheckEmptyUtils.checkStrIsEmpty(formInfo?.cardId) || formInfo.cardId === EXCEPTION_ID_ZERO ||
      formInfo.cardId === EXCEPTION_ID_NEGATIVE_ONE) {
      log.showWarn(TAG, 'dealBackupCard error as the cardId in old is error bundleName %{public}s cardId %{public}d',
        formInfo.bundleName, formInfo.cardId);
      return;
    }
    formInfo.extend1 = Extend1Data.setMigrateForm(formInfo.extend1 ?? '');
    formInfo.isTransparent = (formInfo.extend2 === FORM_TRANSPARENT);
    backupInfoList.push(formInfo);
  }

  private async dealBackupShortCut(backupInfoList: GridLayoutItemInfo[], appInfo: GridLayoutItemInfo, isInstalled: boolean,
    restoreInfoMap: Map<string, Array<string>>): Promise<void> {
    // pad不克隆联系人快捷方式
    if (DeviceHelper.isPad() && appInfo.bundleName === CONTACT_BUNDLE_NAME) {
      log.showWarn(TAG, `shortcut ${appInfo.bundleName}  is not supported in pad`);
      return;
    }

    // 判斷应用內加桌的快捷方式是否支持克隆，不支持直接返回
    if (!this.shortcutSupportClone && !appInfo.appIconId) {
      log.showWarn(TAG, `shortcut ${appInfo.bundleName}_${appInfo.shortcutId} is not supported clone`);
      ShortcutViewModel.getInstance().deleteShortcutFromBMSByAppItem(appInfo as AppItemInfo);
      return;
    }

    // 通过BMS查询应用是否支持该快捷方式，支持则直接保留(兼容无图标应用的快捷方式)
    let shortcutInfoList: ShortcutInfo[] =
      ShortcutViewModel.getInstance().getShortcutByBundleName(appInfo.bundleName);

    if (!CheckEmptyUtils.isEmptyArr(shortcutInfoList)) {
      let shortcut: ShortcutInfo | undefined =
        shortcutInfoList.find(item => item.id === appInfo.shortcutId);

      if (shortcut) {
        // 向BMS添加快捷方式信息
        let addShortcut: ShortcutInfo = ObjectCopyUtil.simpleClone(shortcut);
        addShortcut.appIndex = appInfo.appIndex ?? CommonConstants.MAIN_APP_INDEX;
        await ShortcutViewModel.getInstance().addShortcutToBMS(addShortcut);

        appInfo.appIconId = shortcut.iconId ?? 0;
        appInfo.appLabelId = shortcut.labelId;
        appInfo.appName = await ResourceManager.getInstance().getBundleStringByIdSync(shortcut.labelId,
          shortcut.bundleName, shortcut.moduleName, shortcut.appIndex);
        backupInfoList.push(appInfo);
        return;
      }
    }

    // 已安装情况
    if (isInstalled) {
      if (!appInfo.appIconId) {
        log.showWarn(TAG, `shortcut ${appInfo.bundleName}_${appInfo.shortcutId} is not found in shortcutInfoList`);
        backupInfoList.push(appInfo);
        return;
      }
    }

    // 未安装情况
    let keyName = appInfo.bundleName + (appInfo.appIndex ?? 0);
    if (!restoreInfoMap.has(keyName)) {
      log.showWarn(TAG, `dealBackupApp error as the app is not installed and not placeHolder keyName:${keyName}`);
      ShortcutViewModel.getInstance().deleteShortcutFromBMSByAppItem(appInfo as AppItemInfo);
      return;
    }
    appInfo.appStatus = AppStatus.PENDING;
    appInfo.downloadProgress = 0;
    appInfo.appIconId = 0;
    appInfo.appLabelId = 0;
    backupInfoList.push(appInfo);
  }

  private dealContainerAppCloneData(restoreInfoMap: Map<string, string[]>, item: GridLayoutItemInfo, keyName: string): void {
    let appValue = restoreInfoMap.get(keyName);
    if (appValue && appValue.length > 4 && appValue[3] === 'true') {
      item.appStatus = AppStatus.WAIT_FOR_HARMONY;
    }
  }

  private isInstalled(appList: AppItemInfo[], bundleName: string, buckupAppIndex: number): boolean {
    let appIndex = appList.findIndex(app => app.bundleName === bundleName && app.appIndex === buckupAppIndex);
    return appIndex !== CommonConstants.INVALID_VALUE;
  }

  private updateOldBlankPageRecord(screen: number, isPageBlankRecord: Map<number, boolean>): void {
    if (!isPageBlankRecord.get(screen)) {
      isPageBlankRecord.set(screen, true);
    }
  }

  /**
   * select DesktopInfo
   *
   * @param isFromClone
   * @returns BackupFavoriteInfo
   */
  public async queryLauncherDbDesktopInfo(isFromClone: boolean): Promise<BackupFavoriteInfo[]> {
    let oldLayoutGrid: number[] = GlobalContext.getInstance().getObject('oldLayoutGrid') as number[];
    let oldLayoutCol: number = CommonConstants.DEFAULT_COL;
    let oldLayoutRow: number = CommonConstants.DEFAULT_ROW;
    if (!CheckEmptyUtils.isEmptyArr(oldLayoutGrid) && oldLayoutGrid.length === 2) {
      oldLayoutCol = oldLayoutGrid[0];
      oldLayoutRow = oldLayoutGrid[1];
    }
    const FAVORITE_NAME = isFromClone ? `comopenharmonylaunchersettingsfavorites${oldLayoutCol}x${oldLayoutRow}_tb` : `favorites${oldLayoutCol}x${oldLayoutRow}`;
    log.showInfo(TAG, `queryLauncherDbDesktopInfo start from table favorites${oldLayoutCol}x${oldLayoutRow}, isFromClone: ${isFromClone}`);
    let backupInfoList: BackupFavoriteInfo[] = [];
    let twoRowWidgetList: number[] = [];
    // 行数最小为5,列数最小为4
    let maxOldLayoutRow: number = NumberConstants.CONSTANT_NUMBER_FIVE;
    let maxOldLayoutColumn: number = NumberConstants.CONSTANT_NUMBER_FOUR;
    try {
      let querySql: string = this.generateQueryDesktopInfoSql(FAVORITE_NAME, isFromClone);
      let resultSet: relationalStore.ResultSet | undefined = await this.mLauncherRdbStore?.querySql(querySql);
      if (!resultSet) {
        return backupInfoList;
      }
      let isLast: boolean = resultSet.goToFirstRow();
      let isPageBlankRecord: Map<number, boolean> = new Map();
      while (isLast) {
        let backupInfo: BackupFavoriteInfo = {
          id: resultSet.getLong(resultSet.getColumnIndex('_id')),
          title: resultSet.getString(resultSet.getColumnIndex('title')),
          intent: resultSet.getString(resultSet.getColumnIndex('intent')),
          container: resultSet.getLong(resultSet.getColumnIndex('container')),
          screen: resultSet.getLong(resultSet.getColumnIndex('screen')),
          cellX: resultSet.getLong(resultSet.getColumnIndex('cellX')),
          cellY: resultSet.getLong(resultSet.getColumnIndex('cellY')),
          spanX: resultSet.getLong(resultSet.getColumnIndex('spanX')),
          spanY: resultSet.getLong(resultSet.getColumnIndex('spanY')),
          itemType: resultSet.getLong(resultSet.getColumnIndex('itemType')),
          appWidgetId: resultSet.getString(resultSet.getColumnIndex('appWidgetId')),
          isNewInstalled: resultSet.getLong(resultSet.getColumnIndex('isNewInstalled')),
          profileId: resultSet.getLong(resultSet.getColumnIndex('profileId'))
        };
        if (backupInfo.screen !== undefined && backupInfo.container === CommonConstants.CONTAINER_DESKTOP) {
          isPageBlankRecord.set(backupInfo.screen, true);
          maxOldLayoutRow = Math.max(maxOldLayoutRow, backupInfo.cellY + backupInfo.spanY);
          maxOldLayoutColumn = Math.max(maxOldLayoutColumn, backupInfo.cellX + backupInfo.spanX);
        }
        if (backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_SPECIAL_SHORTCUT &&
          IntentParseUtil.isRetainedShortcut(backupInfo.intent)) {
          let bmpBuffer: ArrayBufferLike = resultSet.getBlob(resultSet.getColumnIndex('icon'))?.buffer;
          this.saveLocalIcon(IntentParseUtil.queryShortcutToAppMappingPackageName(backupInfo.intent), bmpBuffer);
        }
        this.printBackupCardLog(backupInfo);
        let downloadAppId: string = resultSet.getString(resultSet.getColumnIndex('downloadAppId'));
        let bmpBuffer: ArrayBufferLike = resultSet.getBlob(resultSet.getColumnIndex('downloadIcon'))?.buffer;
        if (!CheckEmptyUtils.isEmpty(downloadAppId) && bmpBuffer?.byteLength > 0) {
          this.saveLocalIcon(downloadAppId, bmpBuffer);
        }
        // 收集卡片行数为2的透明天气卡片
        if (backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_WIDGET &&
          backupInfo.spanY === NumberConstants.CONSTANT_NUMBER_TWO) {
          twoRowWidgetList.push(backupInfo.id);
        }
        backupInfoList.push(backupInfo);
        isLast = resultSet.goToNextRow();
      }
      resultSet.close();
      GlobalContext.getInstance().setObject('maxOldLayoutSize', [maxOldLayoutColumn, maxOldLayoutRow]);
      GlobalContext.getInstance().setObject('twoRowWidgetList', twoRowWidgetList);
    } catch (e) {
      log.showError(TAG, 'queryLauncherDbDesktopInfo error:' + e);
    }
    log.showWarn(TAG, `queryLauncherDbDesktopInfo backupInfoList length = ${backupInfoList.length}, maxOldLayoutColumn: ` +
      `${maxOldLayoutColumn}, maxOldLayoutRow: ${maxOldLayoutRow}`);
    return backupInfoList;
  }

  private printBackupCardLog(backupInfo: BackupFavoriteInfo): void {
    if (backupInfo && backupInfo.itemType === BackupItemType.BACKUP_ITEM_TYPE_CARD) {
      log.showInfo(TAG, 'backup card info  intent = %{public}s  appWidgetId = %{public}s', backupInfo.intent,
        backupInfo.appWidgetId);
    }
  }

  private generateQueryDesktopInfoSql(favoriteName: string, isFromClone: boolean): string {
    let querySql: string;
    if (isFromClone) {
      querySql = `SELECT ${favoriteName}._id as _id,` +
        'title,intent,container,screen,cellX,cellY,spanX,spanY,itemType,appWidgetId,' +
        'iconType,iconPackage,iconResource,icon,uri,displayMode,appId,isNewInstalled,sdAppStatus,profileId,downloadAppId,' +
        'downloadProgress,downloadStatus,downloadIcon,downloadLastModified,downloadAppType ' +
        `FROM ${favoriteName} WHERE ${favoriteName}.container=-100 UNION ALL SELECT _id,title,intent,` +
        'container,screen,cellX,cellY,spanX,spanY,itemType,appWidgetId,iconType,iconPackage,iconResource,icon,uri,' +
        'displayMode,appId,isNewInstalled,sdAppStatus,profileId,downloadAppId,downloadProgress,downloadStatus,' +
        `downloadIcon,downloadLastModified,downloadAppType FROM ${favoriteName} ` +
        'WHERE container <>-100';
    } else {
      querySql = `SELECT ${favoriteName}._id as _id,` +
        `title,intent,container,IFNULL(workspace_screens.screenRank, ${favoriteName}.screen) as screen,cellX,cellY,spanX,spanY,itemType,appWidgetId,` +
        'iconType,iconPackage,iconResource,icon,uri,displayMode,appId,isNewInstalled,sdAppStatus,profileId,downloadAppId,' +
        'downloadProgress,downloadStatus,downloadIcon,downloadLastModified,downloadAppType,extendInfo_1,extendInfo_2,' +
        `extendInfo_3 FROM ${favoriteName} LEFT JOIN workspace_screens ON ${favoriteName}.screen=workspace_screens._id and ` +
        `workspace_screens.launcherType=1 WHERE ${favoriteName}.container= -100 UNION ALL SELECT _id,title,intent,` +
        'container,screen,cellX,cellY,spanX,spanY,itemType,appWidgetId,iconType,iconPackage,iconResource,icon,uri,' +
        'displayMode,appId,isNewInstalled,sdAppStatus,profileId,downloadAppId,downloadProgress,downloadStatus,' +
        `downloadIcon,downloadLastModified,downloadAppType,extendInfo_1,extendInfo_2,extendInfo_3 FROM ${favoriteName} ` +
        `WHERE ${favoriteName}.container != -100 ORDER BY screen ASC, cellY ASC, cellX ASC`;
    }
    return querySql;
  }

  public async cloneAllSP(): Promise<void> {
    let convertOptions: convertXml.ConvertOptions = {
      trim: false,
      declarationKey: '_declaration',
      instructionKey: '_instruction',
      attributesKey: '_attributes',
      textKey: '_text',
      cdataKey: '_cdata',
      doctypeKey: '_doctype',
      commentKey: '_comment',
      parentKey: '_parent',
      typeKey: '_type',
      nameKey: '_name',
      elementsKey: '_elements'
    };
    if (FileUtils.isExist(this.backupSPDir)) {
      let fileList: string[] = FileUtils.getFileList(this.backupSPDir);
      for (const fileName of fileList) {
        try {
          const spName: string = fileName.split('.xml')[0];
          let dp = await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), spName);
          let fileString: string = FileUtils.readStringFromFile(this.backupSPDir + '/' + fileName);
          let convertXmlObj = new convertXml.ConvertXML();

          let resObj: CovertObject = convertXmlObj.convertToJSObject(fileString, convertOptions) as CovertObject;
          resObj._elements.forEach((item) => {
            if (item._name === 'map') {
              if (item._elements) {
                item._elements.forEach((mapItem, index) => {
                  if (mapItem._attributes.name.length > MAX_KEY_LENGTH) {
                    log.showInfo(TAG, `invalid key length ,key name ${mapItem._attributes.name}`);
                    return;
                  }
                  switch (mapItem._name) {
                    case 'boolean':
                      dp.putSync(mapItem._attributes.name, JSON.parse(mapItem._attributes.value));
                      break;
                    case 'string':
                      if (mapItem?._elements && mapItem?._elements[0]._type === 'text') {
                        dp.putSync(mapItem._attributes.name, mapItem?._elements[0]._text);
                      } else {
                        dp.putSync(mapItem._attributes.name, '');
                      }
                      break;
                    case 'float':
                    case 'long':
                    case 'int':
                      dp.putSync(mapItem._attributes.name, Number(mapItem._attributes.value));
                      break;
                    default:
                      break;
                  }
                });
              }
            }
          });
          dp.flush((err) => {
            if (err) {
              log.showError(TAG, `${spName}  Failed to flush. code = ${err.code} , message =${err.message}`);
              return;
            }
            log.showInfo(TAG, `${spName} Succeeded in flushing.`);
          });
        } catch (err) {
          log.showError(TAG, `failed to parse ${fileName} . code = ${err.code}, message =${err.message}`);
        }
      }
    }
  }

  async saveOldLayoutToContext(): Promise<void> {
    log.showInfo(TAG, 'saveOldLayoutToContext start');
    let sp: preferences.Preferences | undefined = undefined;
    try {
      sp = await preferences.getPreferences((GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext), 'LAUNCHER_SETTINGS');
    } catch (error) {
      log.error(TAG, 'saveOldLayoutToContext error', error);
    }
    if (!sp) {
      return;
    }
    let layoutArr: string[] = sp.getSync('DESKTOP_LAYOUT_CELLS', '').toString().split(',');
    let defaultIndex: number = sp.getSync('DEFAULT_DESKTOP_LAYOUT_INDEX', 0) as number;
    log.showInfo(TAG, `layoutArr  => ${JSON.stringify(layoutArr)},defaultIndex => ${defaultIndex}`);
    let oldLayoutCol = CommonConstants.DEFAULT_COL;
    let oldLayoutRow = CommonConstants.DEFAULT_ROW;
    if (layoutArr.length !== 0 && layoutArr.length > defaultIndex) {
      let curLayoutArr: string[] = layoutArr[defaultIndex].split('x');
      if (curLayoutArr.length === NumberConstants.CONSTANT_NUMBER_TWO) {
        oldLayoutCol = parseInt(curLayoutArr[0]);
        oldLayoutRow = parseInt(curLayoutArr[1]);
      }
    }
    GlobalContext.getInstance().setObject('oldLayoutGrid', [oldLayoutCol, oldLayoutRow]);
    // 复制主屏设置
    let desktopDefault: number = sp.getSync('DESKTOP_DEFAULT', 0) as number;
    log.showInfo(TAG, `desktopDefault  => ${desktopDefault}`);
    PageInfoManager.getInstance().setHomePageIndex(desktopDefault, false);
  }

  public async restoreFloatingBallDb(floatingBallDb: relationalStore.RdbStore): Promise<void> {
    // 克隆，恢复悬浮球手势开关
    let resultSet: relationalStore.ResultSet | undefined;
    try {
      const TABLE_NAME = 'comopenharmonyFloatTasksproviderBackupProvidershared_prefs_tb'
      log.showInfo(TAG, `restoreFloatingBallDb start from table`);
      const iconPredicates: relationalStore.RdbPredicates = new relationalStore.RdbPredicates(TABLE_NAME);
      resultSet = await floatingBallDb.query(iconPredicates);
      let isLast: boolean = resultSet.goToFirstRow();
      let context = GlobalContext.getContext();
      if (!context) {
        log.showError(TAG, 'context is null');
        return;
      }
      while (isLast) {
        let floatTaskState: string = resultSet.getString(resultSet.getColumnIndex('float_task_state'));
        log.showInfo(TAG, `floatTaskState is: ${floatTaskState}`);
        if (floatTaskState) {
          // 双上悬浮球开关打开
          settings.setValue(context, 'floating_navigation_ball', floatTaskState,
            settings.domainName.USER_PROPERTY);
          break;
        }
        isLast = resultSet.goToNextRow();
      }
    } catch (e) {
      log.showError(TAG, 'restoreFloatingBallDb error: %{public}s', e?.message);
    } finally {
      if (resultSet) {
        resultSet.close();
      }
    }
  }
}

export { UpdateRdbManager };

export class BackupSettingsInfo {
  public filename: string = '';

  public id: number = 0;

  public name: string = '';

  public type: string = '';

  public value: string = '';
}

export class BackupNotificationSettingsInfo {
  public preferenceKey: string = '';

  public preferenceValue: string = '';
}

export class BackupNotificationAppSettingsInfo {
  public appBundle: string = '';

  public uid: string = '';

  public key: string = '';

  public pinTopEnable: string = '';
}