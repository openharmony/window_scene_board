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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
HiSysEventUtil,
ReportParams,
DockAppCntParams,
StartAppFromDockParams,
StartAppFromPopupParams,
OperationMenuParams
} from '@ohos/frameworkwrapper';
import hiSysEvent from '@ohos.hiSysEvent';
import { CommonConstants, MenuInfo } from '@ohos/launchercommon';

/**
 * PC Dock 大数据用户行为相关打点工具类
 */

const TAG = 'PcDockHiSysEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

export class PcDockHiSysEventMgr {
  private static SCENE_BOARD_UE_DOMAIN: string = 'SCENE_BOARD_UE';

  // dock固定区应用图标数量
  private static readonly DOCK_APP_CNT = 'DOCK_APP_CNT';

  // dock点击图标打开应用
  private static readonly START_APP_FROM_DOCK = 'START_APP_FROM_DOCK';

  // dock点击预览器打开应用
  private static readonly START_APP_FROM_POPUP = 'START_APP_FROM_POPUP';

  // 应用添加分组
  private static readonly APP_ADD_CATEGORY = 'APP_ADD_CATEGORY';

  // 应用删除分组
  private static readonly APP_DEL_CATEGORY = 'APP_DEL_CATEGORY';

  // 应用添加任务
  private static readonly APP_ADD_TASK = 'APP_ADD_TASK';

  // 应用删除任务
  private static readonly APP_DEL_TASK = 'APP_DEL_TASK';

  // 屏幕类型： 0 主屏
  public static readonly PRIMARY_SCREEN = 0;

  // 屏幕类型： 1 副屏
  public static readonly SECONDARY_SCREEN = 1;

  /**
   * 上报dock固定应用图标数量
   *
   * @param params dock固定应用图标数量
   */
  static reportDockAppCountData(cnt: number, shortcutCnt: number): void {
    const params: DockAppCntParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      APP_CNT: cnt,
      SHORTCUT_CNT: shortcutCnt
    };
    HiSysEventUtil.report(PcDockHiSysEventMgr.SCENE_BOARD_UE_DOMAIN, PcDockHiSysEventMgr.DOCK_APP_CNT,
      hiSysEvent.EventType.STATISTIC, params);
  }

  /**
   * 主屏，Dock点击图标，打开应用
   *
   * @param params dock固定应用图标数量
   */
  static reportStartAppFromDockData(keyName: string, dType: number = PcDockHiSysEventMgr.PRIMARY_SCREEN): void {
    const params: StartAppFromDockParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DTYPE: dType,
      KEYNAME: keyName
    };
    HiSysEventUtil.report(PcDockHiSysEventMgr.SCENE_BOARD_UE_DOMAIN, PcDockHiSysEventMgr.START_APP_FROM_DOCK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  static reportAppCenterMenu(): void {
    const suggestMenuInfo: MenuInfo[] = AppStorage.get('suggestAppMenuList') as MenuInfo[];

    if (!suggestMenuInfo) {
      log.showInfo('suggestMenuInfo is null');
      return;
    }

    let bundleNames = '';
    for (let menuInfo of suggestMenuInfo) {
      if (menuInfo.menuType !== CommonConstants.MENU_TYPE_FIXED) {
        bundleNames = bundleNames + '&' + menuInfo.bundleName;
      }
    }
    log.showInfo(`SuggestAppMenu bundle: ${bundleNames}`);
    HiSysEventUtil.reportDockMenuBundles(bundleNames.length > 0 ? bundleNames.substr(1) : '');
  }

  /**
   * 主屏，Dock点击预览图，打开应用
   *
   * @param params 应用bundle
   */
  static reportStartAppFromPopup(keyName: string): void {
    const params: StartAppFromPopupParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DTYPE: PcDockHiSysEventMgr.PRIMARY_SCREEN,
      KEYNAME: keyName
    };
    log.showInfo(`reportStartAppFromPopup, keyName ${keyName}`);
    HiSysEventUtil.reportEvent(PcDockHiSysEventMgr.START_APP_FROM_POPUP, params, hiSysEvent.EventType.BEHAVIOR);
  }

  /**
   * 应用添加或者删除分组
   *
   * @param bundleName 应用包名
   * @param action 应用行为
   */
  static reportOperationCategory(bundleName: string, action: string): void {
    const params: OperationMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DTYPE: PcDockHiSysEventMgr.PRIMARY_SCREEN,
      BUNDLENAME: bundleName
    };
    if (action === 'addMenu') {
      log.showInfo(`reportAddCategory, bundleName ${bundleName}`);
      HiSysEventUtil.reportEvent(PcDockHiSysEventMgr.APP_ADD_CATEGORY, params, hiSysEvent.EventType.BEHAVIOR);
    } else {
      log.showInfo(`reportDelCategory, bundleName ${bundleName}`);
      HiSysEventUtil.reportEvent(PcDockHiSysEventMgr.APP_DEL_CATEGORY, params, hiSysEvent.EventType.BEHAVIOR);
    }
  }

  /**
   * 应用添加或者删除任务
   *
   * @param bundleName 应用包名
   * @param action 应用行为
   */
  static reportOperationTask(bundleName: string, action: string): void {
    const params: OperationMenuParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DTYPE: PcDockHiSysEventMgr.PRIMARY_SCREEN,
      BUNDLENAME: bundleName
    };
    if (action === 'addMenu') {
      log.showInfo(`reportAddTask, bundleName ${bundleName}`);
      HiSysEventUtil.reportEvent(PcDockHiSysEventMgr.APP_ADD_TASK, params, hiSysEvent.EventType.BEHAVIOR);
    } else {
      log.showInfo(`reportDelTask, bundleName ${bundleName}`);
      HiSysEventUtil.reportEvent(PcDockHiSysEventMgr.APP_DEL_TASK, params, hiSysEvent.EventType.BEHAVIOR);
    }
  }
}