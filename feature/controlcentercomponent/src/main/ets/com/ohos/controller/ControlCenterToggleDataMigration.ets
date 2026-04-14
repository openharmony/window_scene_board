/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import configPolicy from '@ohos.configPolicy';
import fs from '@ohos.file.fs';
import settings from '@ohos.settings';
import {
  CheckEmptyUtils,
  CommonUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import lazy { ResUtils } from '@ohos/windowscene/src/main/ets/utils/ResourceUtils';
import { CommonConstants, FASlotName, SettingsKeyConstants } from '@ohos/commonconstants';
import { DeviceHelper, GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import { ControlCenterHiSysEventUtil } from '@ohos/controlcentercommon/src/main/ets/hiSysEvent/ControlCenterHiSysEventUtil';
import { QuickToggleController } from './QuickToggleController';
import Constants from '../common/Constants';
import { CloneStatusCallbackManager } from '@ohos/launchercommon/src/main/ets/manager/CloneStatusCallbackManager';

const TAG: string = 'Ctrl.ControlCenterToggleDataRestore';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const TOGGLES_CONFIG: string = 'etc/control_center_toggles_name_map_table.json';
const ohos_TOGGLE_SORT_SECURE_DB_KEY: string = 'sysui_qs_tiles';
const SETTING_DATA_DB_CLONE_FLAG: string = 'settingsCloneStatus';
const SETTING_CLONE_GET_VALUE_DELAY: number = 10000;
const SETTING_CLONE_WAIT_UPDATE_RETRY_LIMIT: number = 5;
const SETTING_DATA_DB_CLONE_FLAG_DEFAULT_VALUE: string = '-1';
const SETTING_DATA_DB_CLONE_FLAG_DEFAULT_CLOSE_VALUE: string = '0';
const SETTING_DATA_DB_CLONE_FLAG_DEFAULT_OPEN_VALUE: string = '1';
const SINGLE_CLONE_TO_SINGLE: number = 1;
const DOUBLE_CLONE_TO_SINGLE: number = 2;
const CLONE_BOUNDARY_VERSION: string = '1.1.0.0';
// 定义特殊克隆场景版本号列表
const SPECIAL_BACKUP_VERSION: string[] = [
  '99.99.99.999',
  '99.99.99.998',
  '99.99.99.997',
  '99.99.99.996',
  '99.99.99.995',
];

export class ControlCenterToggleDataRestore {

  /**
   * 重试次数
   */
  private retryCount: number = 0;
  /**
   * 快捷开关名称映射
   */
  private togglesMatchMap: Map<string, string> = new Map();
  /**
   * 新设备快捷开关列表
   */
  private backupToggleList: string = '';
  private backupTopToggleList: string = '';
  /**
   * 设置数据库克隆状态 1克隆中->0克隆完成
   */
  private settingsCloning: boolean = false;

  constructor() {
  }

  setBackupToggleDataSort(backupStr: string, isTopToggle?: boolean) {
    if (CommonUtils.isEmpty(backupStr)) {
      return;
    }
    if (isTopToggle) {
      this.backupTopToggleList = backupStr;
      return;
    }
    this.backupToggleList = backupStr;
  }

  /**
   * 初始化备份恢复场景
   */
  public async initRestore(): Promise<void> {
    log.showInfo('initRestore Start');
    // 重置数据库状态
    if (sSettingsUtil.getValue(SETTING_DATA_DB_CLONE_FLAG, SETTING_DATA_DB_CLONE_FLAG_DEFAULT_VALUE) ===
      SETTING_DATA_DB_CLONE_FLAG_DEFAULT_VALUE) {
      sSettingsUtil.setValue(SETTING_DATA_DB_CLONE_FLAG, SETTING_DATA_DB_CLONE_FLAG_DEFAULT_CLOSE_VALUE);
    }
    log.showInfo('init SettingData suc');
    try {
      let result: boolean = CloneStatusCallbackManager.getInstance().registerCloneStatusCallbacks(TAG, () => {
        let state = sSettingsUtil.getValue(SETTING_DATA_DB_CLONE_FLAG,
          SETTING_DATA_DB_CLONE_FLAG_DEFAULT_CLOSE_VALUE);
        const isSettingDataCloneEnd: boolean = state === SETTING_DATA_DB_CLONE_FLAG_DEFAULT_CLOSE_VALUE;
        this.settingsCloning = this.settingsCloning || (state === SETTING_DATA_DB_CLONE_FLAG_DEFAULT_OPEN_VALUE);
        log.showInfo(`onCloneToggleDataSortChange isSettingDataCloneStart:${isSettingDataCloneEnd}, settingsCloning:${this.settingsCloning}, state:${state}`);
        // 数据库clone开始，做一个5次循环处理
        if (isSettingDataCloneEnd && this.settingsCloning) {
          this.settingsCloning = false;
          this.retryRestoreWhenCloneStart();
        }
      });
      log.showInfo(`init registerKeyObserver result:${result}`);
    } catch (e) {
      log.showError(`init registerKeyObserver error:${e}`);
    }
    // 查询配置文件
    this.togglesMatchMap = await this.loadTogglesMatchConfig();
    log.showDebug(`togglesMatchMap.size: ${this.togglesMatchMap.size}`);
    if (this.togglesMatchMap.size === 0) {
      log.showWarn(`togglesMatchMap is null`);
    }
    this.backupToggleList = sSettingsUtil.getValue(CommonConstants.KEY_TOGGLE_DATA);
    this.backupTopToggleList = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA);
    // 做打点
    log.showInfo('initRestore end');
  }

  private retryRestoreWhenCloneStart(): void {
    log.showInfo(`retryRestoreWhenCloneStart start:${this.retryCount}`);

    // 添加一个延迟刷新, 10s重试一次
    if (this.retryCount >= SETTING_CLONE_WAIT_UPDATE_RETRY_LIMIT) {
      log.showWarn('retryRestoreWhenCloneStart max retry return');
      this.retryCount = 0;
      // clone旧数据，版本号置空
      sSettingsUtil.setSecureValue(CommonConstants.KEY_TOGGLE_DATA_CLONE, '');
      sSettingsUtil.setSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA_CLONE, '');
      sSettingsUtil.setSecureValue(SettingsKeyConstants.RESTORE_OLD_SCB_VERSION, '');
      // 克隆场景--兼容窗口图标刷新
      QuickToggleController.getInstance().allTogglesControllerMap.forEach((viewModel) => {
        viewModel.updateIcon();
      });
      return;
    }
    setTimeout(() => {
      try {
        this.reloadToggleDataSortSingle();
        this.reloadToggleDataSort();
        log.showInfo('restore restoreQuickTogglesOrder done');
      } catch (error) {
        this.retryCount = 0;
        log.showError(`restoreQuickTogglesOrder error: ${error}`);
      } finally {
        // 重置数据库状态
        sSettingsUtil.setSecureValue(ohos_TOGGLE_SORT_SECURE_DB_KEY, '');
        log.showInfo('init Secure SettingData QS suc');
      }
    }, SETTING_CLONE_GET_VALUE_DELAY);
  }

  private reloadToggleDataSortSingle() {
    let nowToggleList: string = this.getCloneToggleData();
    let nowTopToggleList: string = this.getCloneTopToggleData();
    log.showInfo(`reloadToggleDataSortSingle nowToggleList:${nowToggleList}, nowTopToggleList: ${nowTopToggleList}`);
    log.showInfo('now is single clone to single');
    if (!CommonUtils.isEmpty(nowToggleList)) {
      // 过滤新版本不支持开关
      nowToggleList = QuickToggleController.getInstance().filterEnableToggleData(nowToggleList.split(','));
      QuickToggleController.getInstance().saveQuickToggleData(nowToggleList.split(','));
      if (this.retryCount === SETTING_CLONE_WAIT_UPDATE_RETRY_LIMIT - 1) {
        this.reportCCDataClone(nowToggleList, this.backupToggleList);
      }
    }
    if (!CommonUtils.isEmpty(nowTopToggleList)) {
      QuickToggleController.getInstance().saveTopToggleData(nowTopToggleList.split(','));
      if (this.retryCount === SETTING_CLONE_WAIT_UPDATE_RETRY_LIMIT - 1) {
        this.reportCCDataClone(nowTopToggleList, this.backupTopToggleList);
      }
    }
    // 刷新当前按钮排序
    QuickToggleController.getInstance().onToggleDataChange();
    return;
  }

  private reportCCDataClone(oldList: string, newList: string): void {
    ControlCenterHiSysEventUtil.reportCCDataClone({
      OLDSWITCHNUMBER: oldList.split(',').length,
      OLDSWITCHLIST: oldList,
      NEWSWITCHNUMBER: newList.split(',').length,
      NEWSWITCHLIST: newList,
      TYPE: SINGLE_CLONE_TO_SINGLE,
    });
    // 克隆场景--兼容窗口图标刷新
    QuickToggleController.getInstance().allTogglesControllerMap.forEach((viewModel) => {
      viewModel.updateIcon();
    });
  }

  private getCloneToggleData(): string {
    // 校验克隆后开关数据合法性
    let curData: string = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOGGLE_DATA);
    let cloneData: string = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOGGLE_DATA_CLONE);
    log.showInfo(`getCloneToggleData check suc curData=${curData} cloneData=${cloneData}`);
    // 如果列表为空，需要处理
    if (CheckEmptyUtils.checkStrIsEmpty(curData) ||
      (curData === this.backupToggleList && CheckEmptyUtils.checkStrIsEmpty(cloneData))) {
      log.showInfo(`getCloneToggleData use default!`);
      return this.getDefaultToggleSettingsData();
    }
    let defaultQuickToggleStr: string = ResUtils.getInnerString($r('app.string.toggle_data_all'));
    let defaultQuickToggleList: string[] = defaultQuickToggleStr.split(',');
    if (curData.split(',').some(item => defaultQuickToggleList.includes(item))) {
      // 参数合法
      log.showInfo(`getCloneToggleData check suc!`);
      return curData;
    }
    // 参数非法，刷新旧版本数据到数据库
    log.showInfo(`getCloneToggleData check fail! update=${this.backupToggleList}`);
    return this.backupToggleList;
  }

  private getCloneTopToggleData(): string {
    // 校验克隆后开关数据合法性
    let curData: string = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA);
    let cloneData: string = sSettingsUtil.getSecureValue(CommonConstants.KEY_TOP_TOGGLE_DATA_CLONE);
    log.showInfo(`getCloneTopToggleData check suc curData=${curData} cloneData=${cloneData}`);
    // 如果列表为空，需要处理
    if (CheckEmptyUtils.checkStrIsEmpty(curData) ||
      (curData === this.backupTopToggleList && CheckEmptyUtils.checkStrIsEmpty(cloneData))) {
      log.showInfo(`getCloneTopToggleData use default!`);
      return this.getDefaultToggleSettingsData(true);
    }
    let defaultQuickToggleStr: string = ResUtils.getInnerString($r('app.string.top_toggle_data_all'));
    let defaultQuickToggleList: string[] = defaultQuickToggleStr.split(',');
    if (curData.split(',').some(item => defaultQuickToggleList.includes(item))) {
      // 参数合法
      log.showInfo(`getCloneTopToggleData check suc!`);
      return curData;
    }
    // 参数非法，刷新旧版本数据到数据库
    log.showInfo(`getCloneTopToggleData check fail! update=${this.backupTopToggleList}`);
    return this.backupTopToggleList;
  }

  private reloadToggleDataSort(): void {
    let restoreTiles: string = sSettingsUtil.getSecureValue(ohos_TOGGLE_SORT_SECURE_DB_KEY, '');
    log.showInfo('restoreTiles: ' + restoreTiles);
    if (CommonUtils.isEmpty(restoreTiles)) {
      log.showWarn(`restoreTiles is empty`);
      this.retryCount++;
      this.retryRestoreWhenCloneStart();
      log.showWarn(`retryRestoreWhenCloneStart end`);
      return;
    }
    let restoreTogglesArray: string[] = restoreTiles.split(',');
    let resultArray: string[] = [];
    for (let toggle of restoreTogglesArray) {
      if (this.togglesMatchMap.has(toggle)) {
        let addToggle: string = this.togglesMatchMap.get(toggle) as string;
        resultArray.push(addToggle);
      }
    }
    if (resultArray.length === 0) {
      log.showInfo('resultArray.length=0');
      this.retryCount = 0;
      // 克隆场景--兼容窗口图标刷新
      QuickToggleController.getInstance().allTogglesControllerMap.forEach((viewModel) => {
        viewModel.updateIcon();
      });
      return;
    }
    // 默认开关进行补位
    let defaultQuickToggleStr: string = ResUtils.getInnerString($r('app.string.toggle_data_default'));
    if (defaultQuickToggleStr !== null) {
      let toggleSet: Set<string> = new Set(defaultQuickToggleStr.split(','));
      this.togglesMatchMap.forEach((value) => {
        toggleSet.delete(value);
      });
      let specialToggleArr: string[] = Array.from(toggleSet);
      resultArray = resultArray.concat(specialToggleArr);
    }
    let newTogglesStr: string = QuickToggleController.getInstance().filterEnableToggleData(resultArray);
    log.showInfo(`save new quickToggleData value: ${newTogglesStr}`);
    QuickToggleController.getInstance().saveQuickToggleData(newTogglesStr.split(','));
    this.backupToggleList = newTogglesStr;
    this.retryCount = 0;
    ControlCenterHiSysEventUtil.reportCCDataClone({
      OLDSWITCHNUMBER: restoreTogglesArray.length,
      OLDSWITCHLIST: restoreTogglesArray.join(','),
      NEWSWITCHNUMBER: newTogglesStr.split(',').length,
      NEWSWITCHLIST: newTogglesStr,
      TYPE: DOUBLE_CLONE_TO_SINGLE,
    });
    // 克隆场景--兼容窗口图标刷新
    QuickToggleController.getInstance().allTogglesControllerMap.forEach((viewModel) => {
      viewModel.updateIcon();
    });
  }

  private getDefaultToggleSettingsData(isTopToggle?: boolean): string {
    if (!DeviceHelper.isPhone()) {
      return '';
    }
    if (isTopToggle) {
      return ResUtils.getInnerString($r('app.string.top_toggle_data_default'));
    }
    // 比较scb version
    let restoreOldVersion: string = sSettingsUtil.getSecureValue(SettingsKeyConstants.RESTORE_OLD_SCB_VERSION, '');
    log.showInfo(`initToggleSettingsData otaOldVersion=${restoreOldVersion}`);
    // 克隆场景
    if (CheckEmptyUtils.checkStrIsEmpty(restoreOldVersion) || SPECIAL_BACKUP_VERSION.includes(restoreOldVersion)) {
      return '';
    }
    // < 1.1.0.xxx 版本为老版本
    if (restoreOldVersion.localeCompare(CLONE_BOUNDARY_VERSION) === -1 || !Constants.LOAD_NEW_DEFAULT_TOGGLE) {
      return ResUtils.getInnerString($r('app.string.toggle_data_default_old'));
    }
    return ResUtils.getInnerString($r('app.string.toggle_data_default'));
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
let sControlCenterToggleDataRestore: ControlCenterToggleDataRestore =
  SingletonHelper.getInstance(ControlCenterToggleDataRestore, TAG);
export default sControlCenterToggleDataRestore as ControlCenterToggleDataRestore;