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

import dataShare from '@ohos.data.dataShare';
import type ctx from '@ohos.app.ability.common';
import { CheckEmptyUtils, CompanionIconInfo, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext,
  localEventManager,
  sSettingsUtil,
  AccountMgr,
  SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { CommonConstants,
    SettingsKeyConstants,
    SCBConstants } from '@ohos/commonconstants';
import { SCBSceneSessionManager } from '@ohos/windowscene';
// import parentControl from '@hms.utilityApplication.parentControl';

import { EventConstants } from '../constants/EventConstants';
import { BaseBundleInfo } from '../bean/BaseBundleInfo';
import { GridLayoutItemInfo } from '../TsIndex';

const TAG = 'GrayAppListManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MAX_RETRY_TIMES = 3; // dataShare最大重试次数
const RETRY_INTERVAL_MS = 1000; // 重试间隔

export class GrayAppListManager {
  private static instance: GrayAppListManager;
  private grayAppList: BaseBundleInfo[] = [];
  private delGrayAppList: BaseBundleInfo[] = [];
  private datashareHelper?: dataShare.DataShareHelper;
  private uri: string = CommonConstants.getUriSync(SettingsKeyConstants.PARENT_CONTROL_SWITCH);
  private grayIconSwitch: boolean = false;
  private context: ctx.ServiceExtensionContext = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);

  public static getInstance(): GrayAppListManager {
    if (!GrayAppListManager.instance) {
      GrayAppListManager.instance = new GrayAppListManager();
    }
    return GrayAppListManager.instance;
  }

  public init(): void {
    this.retryRegisterAppGrayDataChange(MAX_RETRY_TIMES);
    SCBSceneSessionManager.getInstance().registerGrayAppListManagerCallback(
      (bundleName: string | undefined, appIndex?: number | 0): boolean => {
      let itemInfo: BaseBundleInfo = {
        bundleName: bundleName ?? '',
        appIndex: appIndex,
      };
      return this.isGrayAppIcon(itemInfo);
    });
  }

  async retryRegisterAppGrayDataChange(retryTimes: number): Promise<void> {
    if (retryTimes <= 0) {
      log.error('no retry times');
      return;
    }
    try {
      this.datashareHelper = await dataShare.createDataShareHelper(this.context, this.uri);
      log.showInfo('registerAppGrayDataChange success');
      this.registerGaryApp();
    } catch (error) {
      log.error('createDataShareHelper error', error);
      setTimeout(() => {
        this.retryRegisterAppGrayDataChange(retryTimes - 1);
      }, RETRY_INTERVAL_MS);
    }
  }

  async registerGaryApp(): Promise<void> {
    if (!this.datashareHelper) {
      log.showError('datashareHelper: is null');
      return;
    }
    let userId: number = await AccountMgr.getCurrentAccountId();
    if (this.getGrayIconSwitch()) {
      this.grayIconSwitch = true;
      this.grayAppList = await this.getGrayList() as BaseBundleInfo[];
      log.info('registerAppGrayInfoChangedCallback');
      try {
        // parentControl.registerDisabledAppListener('launcher' + userId, () => {
        //   this.onAppGrayInfoChangedCallback();
        // });
      } catch (err) {
        log.error('registerAppGrayInfoChangedCallback error:', err);
        return;
      }
    }

    try {
      this.datashareHelper.on('dataChange', this.uri, () => this.grayIconSwitchCallback(userId));
    } catch (err) {
      log.showError(`datashare on change err ${err}`);
      return;
    }
  }

  /**
   * 获取健康使用设备开关是否开启
   *
   * @returns true:开启  false:关闭
   */
  public getGrayIconSwitch(): boolean {
    // pc存在多用户场景, 使用user表查询
    const isPc: boolean = SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PC;
    let value: string = isPc ? sSettingsUtil.getSystemValue(SettingsKeyConstants.PARENT_CONTROL_SWITCH, '0', this.context) :
      sSettingsUtil.getValue(SettingsKeyConstants.PARENT_CONTROL_SWITCH, '0', this.context);
    log.showInfo(`getGrayIconSwitch: ${value}`);
    if (value === 'true' || value === '1') {
      return true;
    } else {
      return false;
    }
  }

  public isGrayAppIcon(bundleInfo?: BaseBundleInfo | GridLayoutItemInfo | CompanionIconInfo): boolean {
    if (!this.grayIconSwitch || CheckEmptyUtils.isEmptyArr(this.grayAppList) || !bundleInfo) {
      return false;
    }

    for (let i = 0; i < this.grayAppList.length; i++) {
      if (this.grayAppList[i].bundleName === bundleInfo.bundleName &&
        this.grayAppList[i].appIndex === bundleInfo.appIndex) {
        return true;
      }
    }

    return false;
  }

  public isStartParentControl(bundleName: string): boolean {
    return bundleName === 'com.ohos.parentcontrol';
  }

  /**
   * 获取健康使用设备禁用应用列表
   *
   * @returns 健康使用设备禁用应用列表
   */
  public async getGrayList(): Promise<BaseBundleInfo[]> {
    let grayList: BaseBundleInfo[] = [];
    try {
      // let objList = await parentControl.queryDisabledAppInfos();
      // for (let i = 0; i < objList.length; i++) {
      //   log.debug(`getGrayList pkgName:${objList[i].pkgName}${objList[i].appCloneIndex}`);
      //   let grayAppItem: BaseBundleInfo = {
      //     bundleName: objList[i].pkgName,
      //     appIndex: objList[i].appCloneIndex,
      //   };
      //   grayList.push(grayAppItem);
      // }
    } catch (err) {
      log.error('getGrayList error:', err);
    }
    log.info(`queryDisabledAppInfos length:${grayList.length}`);
    return grayList;
  }

  private async grayIconSwitchCallback(userId: number): Promise<void> {
    log.info('grayIconSwitchCallback');
    let switchVal: boolean = this.getGrayIconSwitch();

    // 开关打开
    if (switchVal && !this.grayIconSwitch) {
      this.grayIconSwitch = true;
      this.grayAppList = await this.getGrayList() as BaseBundleInfo[];
      this.grayAppList.forEach((item) => {
        let eventKey: string = this.getGrayAppIconEventKey(item);
        localEventManager.sendLocalEventSticky(eventKey, true);
      });
      log.info('registerAppGrayInfoChangedCallback');
      try {
        // parentControl.registerDisabledAppListener('launcher' + userId, () => {
        //   this.onAppGrayInfoChangedCallback();
        // });
      } catch (err) {
        log.error('registerAppGrayInfoChangedCallback error:', err);
      }
    }

    // 开关关闭
    if (!switchVal && this.grayIconSwitch) {
      this.grayIconSwitch = false;
      this.grayAppList.forEach((item) => {
        let eventKey: string = this.getGrayAppIconEventKey(item);
        localEventManager.sendLocalEventSticky(eventKey, false);
      });
      // 通知小文件夹刷新
      this.grayAppList = [];
      localEventManager.sendLocalEventSticky(EventConstants.EVENT_GRAY_PACKAGE_CHANGED, this.grayAppList);
      log.info('unregisterAppGrayInfoChangedCallback');
      try {
        // parentControl.unregisterDisabledAppListener('launcher' + userId);
      } catch (err) {
        log.error('unregisterAppGrayInfoChangedCallback error:', err);
      }
    }
  }

  private async onAppGrayInfoChangedCallback(): Promise<void> {
    log.error('onAppGrayInfoChangedCallback');
    let newGrayAppList: BaseBundleInfo[] = await this.getGrayList() as BaseBundleInfo[];
    if (CheckEmptyUtils.isEmpty(this.grayAppList) || CheckEmptyUtils.isEmpty(newGrayAppList)) {
      log.showError('applist is null');
      return;
    }

    // 过滤新增的需要置灰的app，发送置灰事件
    let grayAddList: BaseBundleInfo[] = newGrayAppList.filter((item) => {
      return this.queryGrayAppListIndex(item, this.grayAppList) === -1 ||
        this.queryGrayAppListIndex(item, this.delGrayAppList) > -1;
    });

    if (!CheckEmptyUtils.isEmptyArr(grayAddList)) {
      grayAddList.forEach((item) => {
        log.info(`add pkgName:${item.bundleName}${item.appIndex}`);
        let eventKey: string = this.getGrayAppIconEventKey(item);
        localEventManager.sendLocalEventSticky(eventKey, true);
      });
    }
    // 过滤减少的需要取消置灰的app，发送取消置灰事件
    let grayDelList: BaseBundleInfo[] = this.grayAppList.filter((item) => {
      return this.queryGrayAppListIndex(item, newGrayAppList) === -1;
    });

    this.delGrayAppList = this.grayAppList.filter((item) => {
      return this.queryGrayAppListIndex(item, newGrayAppList) === -1;
    });

    if (!CheckEmptyUtils.isEmptyArr(grayDelList)) {
      grayDelList.forEach((item) => {
        log.info(`del pkgName:${item.bundleName}${item.appIndex}`);
        let eventKey: string = this.getGrayAppIconEventKey(item);
        localEventManager.sendLocalEventSticky(eventKey, false);
      });
    }

    // 通知小文件刷新
    localEventManager.sendLocalEventSticky(EventConstants.EVENT_GRAY_PACKAGE_CHANGED, newGrayAppList);

    this.grayAppList = newGrayAppList;
  }

  private queryGrayAppListIndex(item: BaseBundleInfo, grayAppList: BaseBundleInfo[]): number {
    let findIndex: number = grayAppList.findIndex(i => i.bundleName === item.bundleName &&
      i.appIndex === item.appIndex);
    return findIndex;
  }

  public getGrayAppIconEventKey(item: BaseBundleInfo | undefined): string {
    return `grayAppIcon${item?.bundleName}${item?.appIndex ?? 0}`;
  }
}
