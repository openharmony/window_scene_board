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
import { GlobalContext, sSettingsUtil } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, FileUtils, LogDomain, Logger } from '@ohos/basicutils';
import { settings } from '@kit.BasicServicesKit';
import {
  AppItemInfo,
  CommonConstants,
  ConfigParseUtil,
  DefaultDesktopLayoutInfo,
  DesktopLayoutState,
  GridLayoutItemInfo,
} from '../TsIndex';

const TAG = 'MatchCardDataManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class MatchCardDataManager {
  public static readonly PRELOAD_TOPAPPS_FOLDER_NAME = '${folder_name_preload}';
  private static readonly PRELOAD_TOPAPPS_FOLDER_ID: string = 'preload0top9apps123';
  private static readonly MATCH_CARD_APP_LIST: string = 'pre_install_with_card_bundle_list';
  private static readonly SCB_MATCH_CARD_FINISH: string = 'scb_match_card_finish';
  private static readonly PRE_INSTALLED: string = 'pre-installed';
  private static mMatchCardAppList: string[] = [];
  private static mWaitAddFolderApps: AppItemInfo[] = [];
  private static isRegisterObserver: boolean = false;
  private static mScbMatchCardFinish: string = '';

  /**
   * 初始化随卡应用数据
   */
  public static init(): void {
    MatchCardDataManager.initScbMatchCardStatus();
    if (MatchCardDataManager.isMatchCardFinished()) {
      log.showInfo(TAG, 'init return, matchCard is finished.');
      return;
    }
    MatchCardDataManager.initAppList();
  }

  /**
   * 初始化随卡状态
   */
  private static initScbMatchCardStatus(): void {
    MatchCardDataManager.mScbMatchCardFinish =
      sSettingsUtil.getValueEx(settings.domainName.DEVICE_SHARED, MatchCardDataManager.SCB_MATCH_CARD_FINISH);
  }

  /**
   * 判断桌面随卡定制是否已结束
   *
   * @returns 已结束返回true, 否则返回false
   */
  public static isMatchCardFinished(): boolean {
    return MatchCardDataManager.mScbMatchCardFinish === 'true';
  }

  /**
   *  初始化当前是否是标准桌面模式
   *
   * @returns 标准桌面返回true，否则返回false
   */
  private static isStandardDesktopLayoutModel(): boolean {
    let launcherModel: string = settings.getValueSync(GlobalContext.getContext(), CommonConstants.SIMPLE_MODE_KEY, '0');
    return launcherModel === String(DesktopLayoutState.HOME_LAUNCHER_MODE) ? true : false;
  }

  /**
   * BMS监听随卡广播并生成随卡安装appList，如果识别到是无效卡，appList写入invalid_card
   * @param appList BMS随卡应用列表
   *
   * @returns 无效卡则返回true, 否则返回false
   */
  private static isInvalidCard(appList: string): boolean {
    return appList === 'invalid_card';
  }

  /**
   * 初始化BMS随卡应用列表
   */
  private static initAppList(): void {
    let appList: string =
      sSettingsUtil.getValueEx(settings.domainName.DEVICE_SHARED, MatchCardDataManager.MATCH_CARD_APP_LIST);
    if (CheckEmptyUtils.checkStrIsEmpty(appList)) {
      //桌面进程冷启动时如果BMS未随卡预装，需要注册监听bms后续随卡动作
      MatchCardDataManager.registerBmsAppListChangeListener();
    } else {
      MatchCardDataManager.getMatchCardAppList(appList);
    }
  }

  /**
   * 监听Settings数据库随卡预装应用appList变化, 注册监听
   */
  private static registerBmsAppListChangeListener(): void {
    try {
      settings.registerKeyObserver(GlobalContext.getContext(), MatchCardDataManager.MATCH_CARD_APP_LIST,
        settings.domainName.DEVICE_SHARED, async () => {
          let appList: string =
            sSettingsUtil.getValueEx(settings.domainName.DEVICE_SHARED, MatchCardDataManager.MATCH_CARD_APP_LIST);
          if (CheckEmptyUtils.isEmpty(appList) || MatchCardDataManager.mMatchCardAppList.length > 0) {
            return;
          }
          //监听到BMS更新applist后桌面更新缓存
          MatchCardDataManager.getMatchCardAppList(appList);
          MatchCardDataManager.isRegisterObserver = true;
        });
    } catch (err) {
      log.showError(TAG, 'registerBmsAppListChangeListener error, with code %{public}d, msg %{public}s', err?.code,
        err?.message);
    }
  }

  /**
   * 监听Settings数据库随卡预装应用appList变化, 注销监听
   *
   * @returns 若未注册监听，则返回
   */
  public static unRegisterBmsAppListChangeListener(): void {
    if (!MatchCardDataManager.isRegisterObserver) {
      return;
    }
    try {
      settings.unregisterKeyObserver(GlobalContext.getContext(), MatchCardDataManager.MATCH_CARD_APP_LIST,
        settings.domainName.DEVICE_SHARED);
      MatchCardDataManager.isRegisterObserver = false;
    } catch (err) {
      log.showError(TAG, 'unRegisterBmsAppListChangeListener error, with code %{public}d, msg %{public}s', err?.code,
        err?.message);
    }
  }

  /**
   * 获取需加入精品文件夹的应用列表（appList和autoInstallConfigPath的交集）
   *
   * @param appList BMS随卡应用列表
   */
  private static getMatchCardAppList(appList: string): void {
    if (this.isInvalidCard(appList) || !this.isStandardDesktopLayoutModel()) {
      this.setMatchCardIsFinished();
      return;
    }
    //BMS随卡安装应用和桌面随卡定制布局应用取交集
    MatchCardDataManager.parseMatchCardLayoutJson().then((layoutJsonAppList) => {
      let appListArr: string[] = appList.split(',');
      let intersectionList: string[] = appListArr.filter(item => layoutJsonAppList.includes(item));
      MatchCardDataManager.mMatchCardAppList = intersectionList;
      log.showInfo(TAG, `getMatchCardAppList: ${MatchCardDataManager.mMatchCardAppList}`);
      MatchCardDataManager.updateSettings();
    });
  }

  /**
   * 获取桌面随卡定制布局列表
   *
   * @returns 若解析Json文件为空则返回
   */
  private static async parseMatchCardLayoutJson(): Promise<string[]> {
    let autoInstallCfgFile: string = '';
    let autoInstallConfigPath: string = 'etc/openharmony_launcher_cloud_workspace_autoinstall.json';
    try {
      autoInstallCfgFile = ConfigParseUtil.getConfigSync(autoInstallConfigPath);
      let autoInstallLayout: DefaultDesktopLayoutInfo = FileUtils.readJsonFile(autoInstallCfgFile);
      if (CheckEmptyUtils.isEmpty(autoInstallLayout) || CheckEmptyUtils.isEmptyArr(autoInstallLayout.layoutInfo)) {
        return [];
      }
      return MatchCardDataManager.getAutoInstallAppList(autoInstallLayout);
    } catch (error) {
      log.error(`parseMatchCardLayoutJson ${error}`);
    }
    return [];
  }

  /**
   * 获取桌面随卡定制布局应用列表
   *
   * @param autoInstallLayoutInfo 随卡定制Json文件包含的布局信息
   * @returns 解析完成的列表
   */
  private static getAutoInstallAppList(autoInstallLayoutInfo: DefaultDesktopLayoutInfo): string[] {
    let layoutJsonAppList: string[] = [];
    for (let item of autoInstallLayoutInfo.layoutInfo) {
      if (!item || !item.layoutInfo || CheckEmptyUtils.isEmptyArr(item.layoutInfo) ||
        item.typeId !== CommonConstants.TYPE_FOLDER ||
        item.folderId !== MatchCardDataManager.PRELOAD_TOPAPPS_FOLDER_ID) {
        continue;
      }
      let tempArr: GridLayoutItemInfo[] = item.layoutInfo.flat();
      tempArr.forEach((appItem) => {
        if (appItem.typeId === CommonConstants.TYPE_APP) {
          layoutJsonAppList.push(appItem.bundleName);
        }
      });
    }
    log.showInfo(TAG, `parseMatchCardLayoutJson: ${layoutJsonAppList}`);
    return layoutJsonAppList;
  }

  /**
   * 设置随卡状态为已完成
   */
  private static setMatchCardIsFinished(): void {
    log.showWarn(TAG, 'setMatchCardIsFinished');
    MatchCardDataManager.mScbMatchCardFinish = 'true';
    sSettingsUtil.setValueEx(settings.domainName.DEVICE_SHARED, MatchCardDataManager.SCB_MATCH_CARD_FINISH,
      MatchCardDataManager.mScbMatchCardFinish);
    sSettingsUtil.setValueEx(settings.domainName.DEVICE_SHARED, MatchCardDataManager.MATCH_CARD_APP_LIST, '');
    MatchCardDataManager.clearWaitAddFolderApps();
    MatchCardDataManager.unRegisterBmsAppListChangeListener();
  }

  /**
   * 判断随卡应用列表是否为空
   *
   * @returns 应用列表为空返回true, 否则返回false
   */
  public static isEmptyAppList(): boolean {
    return MatchCardDataManager.mMatchCardAppList.length === 0;
  }

  /**
   * 获取随卡应用索引
   * @param bundleName 应用包名
   * @returns 返回索引
   */
  private static getMatchCardAppIndex(bundleName: string): number {
    return MatchCardDataManager.mMatchCardAppList.indexOf(bundleName);
  }

  /**
   * 判断是否是随卡预装app
   *
   * @param appInfo 识别到的随卡应用
   * @param callFunc 调用函数名，用于DFX定位
   *
   * @returns 识别成功返回true, 否则返回false
   */
  public static isMatchCardApp(appInfo: AppItemInfo, callFunc?: string): boolean {
    // 判断桌面是否已随卡定制结束
    if (MatchCardDataManager.isMatchCardFinished()) {
      return false;
    }
    // BMS未随卡预装时appList为empty
    if (MatchCardDataManager.isEmptyAppList()) {
      return false;
    }
    // 校验随卡应用
    if (CheckEmptyUtils.isEmpty(appInfo) || CheckEmptyUtils.checkStrIsEmpty(appInfo.bundleName)) {
      return false;
    }
    const index = MatchCardDataManager.getMatchCardAppIndex(appInfo.bundleName);
    if (index === CommonConstants.INVALID_VALUE) {
      return false;
    }

    // 分身应用不处理
    if (appInfo.appIndex !== 0) {
      return false;
    }

    // 判断随卡应用安装来源，如果识别到非预置的随卡应用，则从appList中删除，不走随卡流程
    if (appInfo.installSource !== MatchCardDataManager.PRE_INSTALLED) {
      MatchCardDataManager.deleteAppFromMatchCardAppList(appInfo.bundleName);
      return false;
    }
    log.showInfo(TAG, `isMatchCardApp: ${appInfo.bundleName} ${callFunc}`);
    return true;
  }

  /**
   * 更新单个随卡app缓存
   *
   * @param bundleName 随卡应用包名
   */
  public static deleteAppFromMatchCardAppList(bundleName: string): void {
    const index = MatchCardDataManager.getMatchCardAppIndex(bundleName);
    if (index === CommonConstants.INVALID_VALUE) {
      return;
    }
    MatchCardDataManager.mMatchCardAppList.splice(index, 1);
    MatchCardDataManager.updateSettings();
    log.showWarn(TAG, `deleteAppFromMatchCardAppList: ${bundleName}`);
  }

  /**
   * 更新多个随卡app缓存
   *
   * @param apps 随卡应用列表
   */
  public static deleteAppsFromMatchCardAppList(apps: AppItemInfo[]): void {
    if (CheckEmptyUtils.isEmpty(apps)) {
      return;
    }
    let length: number = MatchCardDataManager.mMatchCardAppList.length;
    apps.forEach((item: AppItemInfo) => {
      const index = MatchCardDataManager.getMatchCardAppIndex(item.bundleName);
      if (index === CommonConstants.INVALID_VALUE) {
        return;
      }
      MatchCardDataManager.mMatchCardAppList.splice(index, 1);
      log.showWarn(TAG, `deleteAppsFromMatchCardAppList: ${item.bundleName}`);
    });
    if (length > MatchCardDataManager.mMatchCardAppList.length) {
      MatchCardDataManager.updateSettings();
    }
  }

  /**
   * 更新settings数据库
   */
  public static updateSettings(): void {
    if (MatchCardDataManager.mMatchCardAppList.length === 0) {
      MatchCardDataManager.setMatchCardIsFinished();
    } else {
      sSettingsUtil.setValueEx(settings.domainName.DEVICE_SHARED, MatchCardDataManager.MATCH_CARD_APP_LIST,
        MatchCardDataManager.mMatchCardAppList.join(','));
    }
  }

  /**
   * 桌面获取已安装应用列表时，缓存待添加到精品应用文件夹的随卡应用
   *
   * @param appItem 随卡应用
   */
  public static updateWaitAddFolderApps(appItem: AppItemInfo): void {
    let appIndex = MatchCardDataManager.mWaitAddFolderApps.findIndex((item) => {
      return item.bundleName === appItem.bundleName;
    });
    if (appIndex === CommonConstants.INVALID_VALUE) {
      MatchCardDataManager.mWaitAddFolderApps.push(appItem);
    }
  }

  /**
   * 获取待添加到精品应用文件夹的随卡应用
   *
   * @returns 待添加到精品应用文件夹的随卡应用
   */
  public static getWaitAddFolderApps(): AppItemInfo[] {
    return MatchCardDataManager.mWaitAddFolderApps;
  }

  /**
   * 清空待添加到精品应用文件夹的随卡应用列表
   */
  private static clearWaitAddFolderApps(): void {
    MatchCardDataManager.mWaitAddFolderApps = [];
  }

  /**
   * 判断应用是否有效，如果在mWaitAddFolderApps数组中不存在则有效，否则无效
   *
   * @param 有效则返回true, 否则返回false
   */
  public static checkIsWaitingAddFolderApp(appInfo: AppItemInfo): boolean {
    return MatchCardDataManager.mWaitAddFolderApps.findIndex(item => item.bundleName === appInfo.bundleName) >= 0;
  }
}