/*
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
import { LogDomain, LogHelper, ArrayUtils, CommonUtils, FileUtils, } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { sSettingsUtil, GlobalContext, AccountMgr, ContextModifyUtils } from '@ohos/frameworkwrapper';
import { CommonConstants, FASlotName, SettingsKeyConstants, } from '@ohos/commonconstants';
import osAccount from '@ohos.account.osAccount';
import fs from '@ohos.file.fs';
import locationManager from '@ohos.geoLocationManager';
import Notification from '@ohos.notificationManager';
import configPolicy from '@ohos.configPolicy';
import convertXml from '@ohos.convertxml';
import { transferRelationManager } from '@ohos/launchercommon';
import BackupExtensionContext from '@ohos.file.BackupExtensionContext';
import { common, contextConstant } from '@kit.AbilityKit';
import { NotificationBackupManager } from '@ohos/notificationcomponent/src/main/ets/backup/NotificationBackupManager';
import { NotificationBackupEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationBackupEntity';
import {
  QuickToggleController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/QuickToggleController';

const TAG = 'SysUI-DataRestoreController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const NOTIFICATION_POLICY_PATH = 'restore/com.openharmony.systemui';
const NOTIFICATION_POLICY_FILE = 'notification_policy.xml';
const NOTIFICATION_POLICY_FILE_DST = 'notification_policy_dst.xml';

const XML_DECRYPT_OK = 0;
const XML_DECRYPT_ERR = -1;

const CONVERT_DIVISION: number = 100000;
const MAIN_UID: number = 100;
const SUB_UID_OFFSET: number = 91;

const TOGGLES_CONFIG = 'etc/control_center_toggles_name_map_table.json';
const LOCATION_MODE_STATUS: string = 'location_switch_enable';
const TOGGLE_STATUS_OFF: string = '0';
const NTF_SAVE_POLICY_SUPPORT: string = '1';
const SYSTEM_UI_QS_TILES: string = 'sysui_qs_tiles';
const NTF_STATUS_SAVE_POLICY: string = 'ntf_status_save_policy';
const LOCK_SCREEN_ALLOW_PRIVATE_NTF_DEFAULT_OFF: string = '1';
const WAKEUP_WHEN_RECEIVE_NTF_DEFAULT_OFF: string = '0';
 
const SIMPLE_DISPLAY_DEFAULT_OFF: string = '0';
const SHOW_APP_NOTIFICATION_ICON_DEFAULT_OPEN: string = '0';
const SHOW_NETWORK_SPEED_DEFAULT_OFF: string = '0';
const MAIN_USER_ID = 100;

interface AttributesObject {
  name: string,
  importance: string
  uid: string
}

interface CovertObject {
  _name: string,
  _text: string,
  _type: string,
  _attributes: AttributesObject,
  _declaration: Object,
  _elements: CovertObject[]
}

export class DataRestoreController {
  private context: Context;
  private notificationPolicyFilePath: string = '';

  constructor(context: Context) {
    this.context = GlobalContext.getContext();
    ResUtils.init(this.context);

    let backupContext = context as BackupExtensionContext;
    let backupDir: string = '';
    let callback = (callbackContext: common.Context) => {
      backupDir = (callbackContext as BackupExtensionContext).backupDir;
    };
    ContextModifyUtils.modifyTargetContext(backupContext, contextConstant.AreaMode.EL2, callback, `${TAG}-constructor`);
    this.notificationPolicyFilePath = backupDir + NOTIFICATION_POLICY_PATH;
    log.showInfo(`this.notificationPolicyFilePath : ${this.notificationPolicyFilePath}`);
  }

  /**
   * start restore SystemUI related upgrade data
   * @returns Promise<void>
   */
  public async startDataRestore(): Promise<void> {
    await this.restoreNotificationPolicy();
    await this.restoreQuickTogglesState();
	this.restoreSettings();
  }
 
  private restoreSettings(): void {
    this.restoreNotificationSettings();
    this.restoreStatusBarSettings();
  }
 
  private restoreStatusBarSettings(): void {
    // 1.״̬��������ʾ����
    this.restorePureShow();

    // 2.״̬����ʾʵʱ���ٿ���
    this.restoreShowRealtimeNetworkSpeed();

    // 3.״̬����ʾ֪ͨͼ�꿪��
    this.restoreShowNotificationIcon();

    log.showInfo('restore status bar settings done.');
  }

  private restoreShowNotificationIcon() {
    const showIconSwitch: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_NOTIFICATION_ICON,
      SHOW_APP_NOTIFICATION_ICON_DEFAULT_OPEN, this.context);
  }

  private restoreShowRealtimeNetworkSpeed() {
    const showNetworkSpeedSwitch: string = sSettingsUtil
      .getSecureValue(SettingsKeyConstants.STATUS_BAR_SHOW_REAL_TIME_NETWORK_SPEED, SHOW_NETWORK_SPEED_DEFAULT_OFF,
        this.context);
  }

  private restorePureShow() {
    const simpleDisplaySwitch: string = sSettingsUtil
      .getSecureValue(SettingsKeyConstants.STATUS_BAR_PURE_SHOW, SIMPLE_DISPLAY_DEFAULT_OFF, this.context);
  }
 
  private restoreNotificationSettings(): void {
    // 1.����֪ͨ���ݿ���
    this.restoreNtfConfigHideContent();

    // 2.֪ͨ������ʾ����
    this.restoreNtfConfigScreenOn();

    log.showInfo('restore notification settings done.');
  }

  private restoreNtfConfigScreenOn() {
    const wakeScreenSwitch: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_SCREEN_ON,
      WAKEUP_WHEN_RECEIVE_NTF_DEFAULT_OFF, this.context);
  }

  private restoreNtfConfigHideContent() {
    const hideNtfContentSwitch: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.APP_NTF_CONFIG_HIDE_CONTENT,
      LOCK_SCREEN_ALLOW_PRIVATE_NTF_DEFAULT_OFF, this.context);
  }

  private findElementsByTag(elements: CovertObject[], findTag: String): CovertObject[] {
    if (!elements) {
      return [];
    }
    for (let i = 0; i < elements.length; i++) {
      if (elements[i]._name === findTag) {
        return elements[i]._elements;
      }
    }
    log.showInfo('Can not find it return null');
    return [];
  }

  private async restoreNotificationPolicy(): Promise<void> {
    let isNtfSavePolicy = sSettingsUtil.getValue(NTF_STATUS_SAVE_POLICY, '0', this.context);
    log.showInfo('isNtfSavePolicy:' + isNtfSavePolicy);
    if (isNtfSavePolicy !== NTF_SAVE_POLICY_SUPPORT) {
      log.showWarn('not support restore notification Policy config, isNtfSavePolicy:' + isNtfSavePolicy);
      return;
    }
    let result = XML_DECRYPT_ERR;
    let notificationPolicyFileSrc = this.notificationPolicyFilePath + '/' + NOTIFICATION_POLICY_FILE;
    log.showInfo(`notificationPolicyFileSrc: ${notificationPolicyFileSrc}`);
    if (!FileUtils.isExist(notificationPolicyFileSrc)) {
      log.showWarn('not exist notificationPolicyFile');
      return;
    }
    let notificationPolicyFileDst = this.notificationPolicyFilePath + '/' + NOTIFICATION_POLICY_FILE_DST;
    // try {
    //   result = XmlConverterSdk.abx2Xml(notificationPolicyFileSrc, notificationPolicyFileDst);
    // } catch (error) {
    //   log.showError(`abx2Xml error: ${error}`);
    // }
    // if (result !== XML_DECRYPT_OK) {
    //   log.showError('notification policy file decrypt failed');
    //   return;
    // }
    log.showInfo('notification policy file decrypt ok');
    let settingsMap: Map<string, boolean> = this.getNotificationDataMap(notificationPolicyFileDst);
    await this.syncNotificationStatus(settingsMap);
    log.showInfo('restore notification policy files done');
  }

  private getConvertUid(uid: number): number {
    let convertValue: number = Math.floor(uid / CONVERT_DIVISION);
    if (convertValue === 0) {
      return MAIN_UID;
    } else {
      return convertValue + SUB_UID_OFFSET;
    }
  }

  private getNotificationDataMap(policyFile: string): Map<string, boolean> {
    let resultMap: Map<string, boolean> = new Map();
    if (!FileUtils.isExist(policyFile)) {
      log.showWarn('decrypt file not exist');
      return resultMap;
    }
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
    try {
      let fileString: string = FileUtils.readStringFromFile(policyFile);
      let convertXmlObj = new convertXml.ConvertXML();
      let resObj: CovertObject = convertXmlObj.convertToJSObject(fileString, convertOptions) as CovertObject;
      let notificationElements = this.findElementsByTag(resObj._elements, 'notification-policy');
      let rankingElements = this.findElementsByTag(notificationElements, 'ranking');
      if (rankingElements) {
        let currentUserId: number = MAIN_UID;
        log.showInfo(`currentUserId = ${currentUserId}`);
        rankingElements.forEach((item) => {
          if (item._name === 'package') {
            let uid: number = Number.parseInt(item._attributes.uid);
            let convertUid: number = this.getConvertUid(uid);
            if (convertUid !== currentUserId) {
              log.showInfo(`convertUid: ${convertUid}, currentUserId:${currentUserId} `);
              return;
            }
            let importance = item._attributes.importance;
            if (importance === '0') {
              resultMap.set(item._attributes.name, false);
            } else {
              resultMap.set(item._attributes.name, true);
            }
          }
        });
      }
    } catch (err) {
      log.showError(`failed to parse. code = ${err.code}, message =${err.message}`);
    }
    return resultMap;
  }

  private async syncNotificationStatus(settingsMap: Map<string, boolean>): Promise<void> {
    if (ArrayUtils.isEmpty(settingsMap)) {
      log.showWarn('notification setting map is empty');
      return;
    }
    let isLoad = transferRelationManager.getIsLoaded();
    if (!isLoad) {
      await transferRelationManager.loadTransferInfos();
    }
    settingsMap.forEach((value, key) => {
      log.showInfo(`bundleName: ${key}, status: ${value}`);
      NotificationBackupManager.get().setBackup(key, {
        notificationEnable: value,
        isPkgName: true
      } as NotificationBackupEntity);
    });
  }

  private async restoreQuickTogglesState(): Promise<void> {
    await this.restoreQuickTogglesOrder();
    await this.restoreQuickTogglesStatus();
    log.showInfo('restoreQuickTogglesState done');
  }

  private async restoreQuickTogglesStatus(): Promise<void> {
    // 1. location restore
    this.restoreLocationStatus();
  }

  private async restoreLocationStatus(): Promise<void> {
    let locationStatus = sSettingsUtil.getSystemValue(LOCATION_MODE_STATUS, TOGGLE_STATUS_OFF, this.context);
    log.showInfo('restoreLocationStatus locationStatus:' + locationStatus);
    let setLocationEnable = locationStatus == TOGGLE_STATUS_OFF ? false : true;
    try {
      let isLocationEnable = locationManager.isLocationEnabled();
      log.showInfo(`setLocationEnable: ${setLocationEnable}, isLocationEnable: ${isLocationEnable}`);
      if (setLocationEnable !== isLocationEnable) {
        if (!setLocationEnable) {
          let result = locationManager.disableLocation();
          log.showInfo(`disableLocation, result: ${result}`);
        } else {
          let result = locationManager.enableLocation();
          log.showInfo(`enableLocation, result: ${result}`);
        }
      }
    } catch (error) {
      log.showError('restore location toggle status error');
    }
    log.showInfo('restoreLocationStatus done');
  }

  private async restoreQuickTogglesOrder(): Promise<void> {
    let togglesMatchMap: Map<string, string> = await this.loadTogglesMatchConfig();
    log.showInfo(`togglesMatchMap.size: ${togglesMatchMap.size}`);
    if (togglesMatchMap.size === 0) {
      return;
    }
    let restoreTiles: string = sSettingsUtil.getSecureValue(SYSTEM_UI_QS_TILES, '', this.context);
    log.showInfo('restoreTiles: ' + restoreTiles);
    if (CommonUtils.isEmpty(restoreTiles)) {
      log.showWarn(`restoreTiles is empty`);
      return;
    }
    let defaultTogglesArray: string[] = ResUtils.getInnerString($r('app.string.toggle_data_default')).split(',');
    let toggleSet: Set<string> = new Set(defaultTogglesArray);
    togglesMatchMap.forEach((value) => {
      toggleSet.delete(value);
    });

    let specialToggleArr: string[] = Array.from(toggleSet);
    let restoreTogglesArray = restoreTiles.split(',');
    let resultArray: string[] = [];
    for (let toggle of restoreTogglesArray) {
      if (togglesMatchMap.has(toggle)) {
        let addToggle: string = togglesMatchMap.get(toggle) as string;
        resultArray.push(addToggle);
      }
    }
    let newTogglesArr: string[] = resultArray.concat(specialToggleArr);
    // 过滤开关处理
    let filterToggleArr: string[] = [];
    if (canIUse('SystemCapability.Communication.FusionConnectivityExt')) {
      filterToggleArr.push(FASlotName.NEAR_LINK);
    }
    let newArr: string[] = newTogglesArr.filter(toggle => filterToggleArr.indexOf(toggle) === -1);
    // 触发过滤后，需要从备选库取N个开关添加到首页
    if (newTogglesArr.length - newArr.length > 0) {
      let toggleLibrary: string[] = ResUtils.getInnerString($r('app.string.toggle_data_all'))
        .split(',').filter(item => {
          if (newArr.indexOf(item) !== -1) {
            return false;
          }
          return QuickToggleController.getInstance().toggleData?.contain(item);
        });
      newArr = newArr.concat(toggleLibrary.slice(0, newTogglesArr.length - newArr.length));
    }
    let newTogglesStr: string = newArr.join(',');
    log.showInfo('save new quickToggleData value: ' + newTogglesStr);
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let userId: number = await accountManager.getForegroundOsAccountLocalId();
      if (AccountMgr.isInvalidAccount(userId)) {
        log.showWarn('current user id invalid');
      }
      if (userId === MAIN_USER_ID) {
        sSettingsUtil.setValue(CommonConstants.KEY_TOGGLE_DATA, newTogglesStr, this.context);
      } else {
        sSettingsUtil.setSecureValue(CommonConstants.KEY_TOGGLE_DATA, newTogglesStr, this.context);
      }
    } catch (e) {
      log.showError('get OsAccount localId failed!');
    }
    sSettingsUtil.setSecureValue(SYSTEM_UI_QS_TILES, '');
    log.showInfo('restore restoreQuickTogglesOrder done');
  }

  private async loadTogglesMatchConfig(): Promise<Map<string, string>> {
    let configMap: Map<string, string> = new Map<string, string>();
    try {
      let filePath: string = await configPolicy.getOneCfgFile(TOGGLES_CONFIG);
      let configStr: string = fs.readTextSync(filePath);
      if (configStr) {
        let jsonArray: string[] = JSON.parse(configStr);
        for (const jsonEle of jsonArray) {
          let key = Object.keys(jsonEle)[0] as string;
          let value = jsonEle[Object.keys(jsonEle)[0]] as string;
          configMap.set(key, value);
        }
      }
    } catch (error) {
      log.showError(`loadTogglesMatchConfig exception: ${error.message}`);
      return configMap;
    }
    log.showInfo('loadTogglesMatchConfig end');
    return configMap;
  }
}
