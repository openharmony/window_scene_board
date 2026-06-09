/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper, CommonUtils, CheckEmptyUtils, } from '@ohos/basicutils';
import { GlobalContext, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import {
  LegacyInfo,
  AppStatus,
  GridLayoutItemInfo,
  CommonConstants,
  RdbStoreManager,
} from '@ohos/launchercommon';
import { IExecutor, NotHarmonyUtil } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { QueryAppResponse } from '../QueryDesktopAppService';
import preferences from '@ohos.data.preferences';
import type ctx from '@ohos.app.ability.common';
import { uriPermissionManager, wantConstant } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { bundleManager } from '@kit.AbilityKit';

const TAG: string = 'QueryDesktopApp';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DAY_IN_MILLIS = 1000 * 60 * 60 * 24;
const TARGET_BUNDLE_NAME: string = 'com.ohos.dataclone';

/**
 * 查询所有待安装、下载中、安装中的任务清单
 *
 * @since 2024-07-01
 */
export class QueryDesktopApp implements IExecutor {
  private isAllowedIconUri: boolean = false;

  async execute(extra?: object): Promise<string> {
    const queryScope: number = (extra as ExtraQueryScope)?.queryScope;
    log.showInfo(`recv QueryDesktopApp from QueryDesktopAppService, queryScope is ${queryScope}`);
    if (CheckEmptyUtils.isEmpty(queryScope)) {
      return QueryAppResponse.fail;
    }
    let tempGridLayoutItemInfoList: GridLayoutItemInfo[] = await RdbStoreManager.getInstance()
      .queryGridLayoutByType(CommonConstants.TYPE_APP);
    if (CheckEmptyUtils.isEmptyArr(tempGridLayoutItemInfoList)) {
      return QueryAppResponse.fail;
    }
    if (queryScope === QueryScopeType.ALL_WAIT_FOR_HARMONY) {
      tempGridLayoutItemInfoList = tempGridLayoutItemInfoList
        .filter(item => item.typeId === CommonConstants.TYPE_APP && item.appStatus === AppStatus.WAIT_FOR_HARMONY);
    } else if (queryScope === QueryScopeType.ALL_UNINSTALL) {
      tempGridLayoutItemInfoList = tempGridLayoutItemInfoList
        .filter(item => item.typeId === CommonConstants.TYPE_APP && (item.appStatus ?? 0) > AppStatus.INSTALLED);
    }
    log.showInfo(`gridLayoutItemInfoList length is ${tempGridLayoutItemInfoList.length}`);
    if (CheckEmptyUtils.isEmptyArr(tempGridLayoutItemInfoList)) {
      return '';
    }
    // 未OpenHarmony化应用打点未上报，补充一次未OpenHarmony化应用打点信息
    this.reportNotHarmonyAppInfo(tempGridLayoutItemInfoList);
    // 查询未点亮的可入湖应用点亮可入湖应用
    NotHarmonyUtil.queryAndLightDeliverApp(tempGridLayoutItemInfoList);
    await this.initAllowedIconUri();
    let outAppInfoList: OutAppInfo[] = [];
    for (let element of tempGridLayoutItemInfoList) {
      outAppInfoList.push(await this.getOutAppInfo(element));
    }
    log.showInfo(`outAppInfoList length is ${outAppInfoList.length}`);
    return JSON.stringify(outAppInfoList);
  }

  private async initAllowedIconUri(): Promise<void> {
    try {
      const callerUid = rpc.IPCSkeleton.getCallingUid();
      const callerBundleName = await bundleManager.getBundleNameByUid(callerUid);
      // 克隆和AG调用此接口，只给克隆授权URI
      this.isAllowedIconUri = callerBundleName === TARGET_BUNDLE_NAME;
      log.showWarn(`init allowed icon uri bundleName：${callerBundleName}, ${this.isAllowedIconUri}`);
    } catch (err) {
      log.showError(`init allowed icon uri error: ${err.code} : ${err.message}`);
      this.isAllowedIconUri = false;
    }
  }

  /**
   * 上报未OpenHarmony化打点任务,一周上报一次未OpenHarmony化应用
   *
   * @param gridLayoutItemInfoList 未安装应用信息info
   */
  private async reportNotHarmonyAppInfo(gridLayoutItemInfoList: GridLayoutItemInfo[]): Promise<void> {
    try {
      let reportNameArr: string[] = [];
      gridLayoutItemInfoList.forEach(appItemInfo => {
        if (appItemInfo.appStatus === AppStatus.WAIT_FOR_HARMONY) {
          reportNameArr.push(appItemInfo.bundleName);
        }
      });
      if (CheckEmptyUtils.isEmptyArr(reportNameArr)) {
        log.showInfo('query desktop app not harmony app not exists');
        return;
      }
      let date: Date = new Date();
      let preference = await preferences.getPreferences(
        GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext, 'DESKTOP_LAYOUT_INFO');
      let reportNotHarmonyAppTime: number = preference.getSync('reportNotHarmonyAppTime', 0) as number;
      if (reportNotHarmonyAppTime !== 0 &&
        reportNotHarmonyAppTime > this.minusDays(date, NumberConstants.CONSTANT_NUMBER_SEVEN)) {
        log.showInfo(`not need report NotHarmonyAppInfo, reportNotHarmonyAppTime ${reportNotHarmonyAppTime}`);
        return;
      }
      HiSysEventUtil.reportBackUpMismatchAppEventInfo(reportNameArr.join(','), '', reportNameArr.length,
        reportNameArr.length);
      preference.putSync('reportNotHarmonyAppTime', date.getTime());
      await preference.flush().then(() => {
        log.showInfo('save reportNotHarmonyAppTime to sp success');
      }).catch((reject: Error) => {
        log.showInfo('save reportNotHarmonyAppTime to sp fail: %{public}s', reject?.message);
      });
      log.showInfo('report NotHarmonyAppInfo end, reportNotHarmonyAppTime %{public}s', date.toString());
    } catch (err) {
      log.showError(`Failed to get preferences error: ${err.code} : ${err.message}`);
    }
  }

  /**
   * 在date基础减去上days天数
   *
   * @param date 基础日期
   * @param days 减去天数
   * @return 减去后的毫秒值
   */
  private minusDays(date: Date, days: number): number {
    let curTime: number = date.getTime();
    return curTime - (days * DAY_IN_MILLIS);
  }

  private async getOutAppInfo(element: GridLayoutItemInfo): Promise<OutAppInfo> {
    let outAppInfo = new OutAppInfo();
    outAppInfo.appStatus = element.appStatus;
    outAppInfo.appIndex = element.appIndex;
    outAppInfo.callerName = element.callerName;
    if (outAppInfo.appStatus === AppStatus.WAIT_FOR_HARMONY) {
      let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(element.intent);
      let legacyInfo: LegacyInfo = extendInfo.get('legacyInfo') as LegacyInfo;
      legacyInfo.maskState = extendInfo.get(NotHarmonyUtil.NOT_HARMONY_APP_MASK_STATE) as number || 0;
      outAppInfo.legacyInfo = legacyInfo;
      outAppInfo.bundleName = extendInfo.get('requestBundleName') as string;
      outAppInfo.appType = extendInfo.get(NotHarmonyUtil.APP_TYPE) as number;
    }
    if (!outAppInfo.bundleName) {
      outAppInfo.bundleName = element.bundleName;
    }
    let ownerInfo: OwnerInfo;
    switch (element.callerName) {
      case 'com.ohos.clouddrive':
        ownerInfo = {
          'bundleName': element.callerName,
          'moduleName': 'phone',
          'abilityName': 'BackupServiceAbility',
        };
        break;
      case 'com.ohos.dataclone':
        ownerInfo = {
          'bundleName': element.callerName,
          'moduleName': 'phone',
          'abilityName': 'SilentInstallServiceExtAbility',
        };
        break;
      case 'com.ohos.databackup':
      case 'com.ohos.hisuite':
        ownerInfo = {
          'bundleName': element.callerName,
          'moduleName': 'phone',
          'abilityName': 'InstallServiceExtensionAbility',
        };
        break;
      case 'migrate_server':
        ownerInfo = {
          'bundleName': element.callerName,
          'moduleName': '',
          'abilityName': '',
        };
        break;
      default:
        ownerInfo = {
          'bundleName': '',
          'moduleName': '',
          'abilityName': '',
        };
        break;
    }
    outAppInfo.ownerInfo = ownerInfo;
    outAppInfo.iconUri = await this.getIconUri(element);
    return outAppInfo;
  }

  private async getIconUri(element: GridLayoutItemInfo): Promise<string> {
    if (!this.isAllowedIconUri) {
      return '';
    }
    if (CheckEmptyUtils.checkStrIsEmpty(element.iconResource)) {
      log.showWarn(`${element.bundleName} getIconUri iconResource is empty`);
      return '';
    }
    try {
      await uriPermissionManager.grantUriPermission(element.iconResource,
        wantConstant.Flags.FLAG_AUTH_READ_URI_PERMISSION, TARGET_BUNDLE_NAME);
      return element.iconResource ?? '';
    } catch (error) {
      log.error(`${element.bundleName} grantUriPermission fail`, error);
    }
    return '';
  }
}

interface ExtraQueryScope {
  queryScope: number;
}

/**
 * 查询桌面图标范围类型
 */
export enum QueryScopeType {
  /**
   * 桌面所有未OpenHarmony化的应用列表
   */
  ALL_WAIT_FOR_HARMONY = 0,

  /**
   * 表示查询桌面所有未安装，在桌面置灰显示的应用列表信息；（包括：未OpenHarmony化应用、以及各类下载过程中的应用）
   */
  ALL_UNINSTALL = 1,
}

/**
 * 应用信息
 *
 * @since 2024-07-01
 */
export class OutAppInfo {
  public bundleName: string = '';

  public callerName?: string;

  public ownerInfo: OwnerInfo = new OwnerInfo();

  public appStatus?: number;

  public appType?: number;

  public appIndex?: number;

  public legacyInfo?: LegacyInfo;

  public iconUri?: string;
}

/**
 * 任务拥有者信息
 *
 * @since 2024-07-01
 */
export class OwnerInfo {
  public bundleName: string = '';

  public moduleName: string = '';

  public abilityName: string = '';
}
