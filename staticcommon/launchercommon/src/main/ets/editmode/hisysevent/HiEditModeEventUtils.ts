/**
 * Copyright (c) 2023-Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

import { ReportParams } from '@ohos/frameworkwrapper';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import type {
  AddOuterAppByClick,
  AddOuterAppByDrag,
  EditModeUninstallParams,
  EnterEditModeParams,
  ExitEditModeParams,
  ShortcutParams,
  ApplyIconEditParams,
  EditModeUninstallDialogParams,
  EditModeHomePageSettingParams,
  EnterSubPageParams,
  BaseParams,
} from './EditModeReportParams';
import { HiEditModeDataEnterType, HiEditModeDataExitType } from './HiEditModeData';
import hiSysEvent from '@ohos.hiSysEvent';
import { performanceMonitor } from '@kit.ArkUI';
import { AppItemInfo, GridLayoutItemInfo } from '../../TsIndex';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG = 'HiEditModeEventUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * 桌面编辑打点上报工具类
 */
export class HiEditModeEventUtils {
  private static readonly SCENE_BOARD_UE_DOMAIN: string = 'SCENE_BOARD_UE';
  private static readonly OUTER_HOME_UE: string = 'OUTER_HOME_UE';
  // 进入桌面编辑
  private static readonly EDITMODE_ENTER: string = 'EDITMODE_ENTER';
  // 退出桌面编辑
  private static readonly EDITMODE_EXIT: string = 'EDITMODE_EXIT';
  // 进入图标编辑
  private static readonly ENTER_ICONEDITPAGE: string = 'CUSTOM_ANIMATOR_ENTER_ICONEDITPAGE';
  // 桌面编辑模式下，拖拽触发卸载移除
  private static readonly EDITMODE_TO_UNINSTALL: string = 'EDITMODE_TO_UNINSTALL';
  // 桌面编辑模式下，确认卸载移除
  private static readonly EDITMODE_CONFIRM_UNINSTALL: string = 'EDITMODE_CONFIRM_UNINSTALL';
  // 桌面编辑模式下，取消卸载移除
  private static readonly EDITMODE_CANCEL_UNINSTALL: string = 'EDITMODE_CANCEL_UNINSTALL';
  // 桌面编辑模式下，卸载弹框
  private static readonly BATCH_UNINSTALL_DIALOG_UE: string = 'BATCH_UNINSTALL_DIALOG_UE';
  // 桌面编辑模式下，卸载弹框
  private static readonly HOME_PAGE_SETTING_UE: string = 'HOME_PAGE_SETTING_UE';
  // 点击新增图标进屏幕
  public static readonly ADD_APP_TO_DESKTOP_BY_CLICK = 'LAUNCHER_ADD_APP_BY_CLICK';
  // 拖拽新增图标进屏幕
  public static readonly ADD_APP_TO_DESKTOP_BY_DRAG = 'LAUNCHER_ADD_APP_BY_DRAG';
  // 长按应用-拖动菜单中应用快捷方式至桌面
  private static readonly DRAG_SHORTCUT_TO_DESKTOP: string = 'DRAG_SHORTCUT_TO_DESKTOP';
  // 双指捏合桌面-长按拖动应用快捷方式至右上角移除
  private static readonly EDITMODE_REMOVE_APP_SHORTCUT: string = 'EDITMODE_REMOVE_APP_SHORTCUT';
  // 桌面-双指捏合进入编辑页面-图标
  private static readonly EDITMODE_ENTER_SUBPAGE: string = 'EDITMODE_ENTER_SUBPAGE';
  // 桌面-双指捏合进入编辑页面-图标-应用图标
  private static readonly EDITMODE_ICONEDIT_APPLY: string = 'EDITMODE_ICONEDIT_APPLY';
  // 多选拖拽
  private static readonly EDITMODE_MULTISELECT_DRAG: string = 'EDITMODE_MULTISELECT_DRAG';

  /**
   * 进入编辑模式
   */
  public static reportEnterEditMode(enterType: number): void {
    let params: EnterEditModeParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ENTER_TYPE: enterType,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, HiEditModeEventUtils.EDITMODE_ENTER,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 退出编辑模式
   *
   * @param params 上报参数
   */
  public static reportExitEditMode(exitType: number, params: ExitEditModeParams): void {
    if (CheckEmptyUtils.isEmpty(params)) {
      log.showWarn('reportExitEditMode failed, params is invalid.');
      return;
    }

    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.EXIT_TYPE = exitType;
    params.SCREEN_TYPE = HiSysEventUtil.screenType;
    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, HiEditModeEventUtils.EDITMODE_EXIT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 编辑模式触发卸载移除
   *
   * @param params 上报参数
   */
  public static reportEditModeToUninstall(params: EditModeUninstallParams): void {
    HiEditModeEventUtils.reportUninstallEvent(params, HiEditModeEventUtils.EDITMODE_TO_UNINSTALL);
  }

  /**
   * 编辑模式卸载移除操作确认
   *
   * @param params 上报参数
   */
  public static reportEditModeConfirmUninstall(params: EditModeUninstallParams): void {
    HiEditModeEventUtils.reportUninstallEvent(params, HiEditModeEventUtils.EDITMODE_CONFIRM_UNINSTALL);
  }

  /**
   * 编辑模式卸载移除操作取消
   *
   * @param params 上报参数
   */
  public static reportEditModeCancelUninstall(params: EditModeUninstallParams): void {
    HiEditModeEventUtils.reportUninstallEvent(params, HiEditModeEventUtils.EDITMODE_CANCEL_UNINSTALL);
  }

  private static reportUninstallEvent(params: EditModeUninstallParams, eventId: string): void {
    if (CheckEmptyUtils.isEmpty(params)) {
      log.showWarn(`report ${eventId} failed, params is invalid.`);
      return;
    }
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.SCREEN_TYPE = HiSysEventUtil.screenType;

    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, eventId, hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 批量卸载弹框上报
   *
   * @param params 上报参数
   */
  public static reportEditModeUninstallDialog(params: EditModeUninstallDialogParams): void {
    if (CheckEmptyUtils.isEmpty(params)) {
      log.showWarn(`reportEditModeRemove failed, params is invalid.`);
      return;
    }
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.SCREEN_TYPE = HiSysEventUtil.screenType;

    HiSysEventUtil.report(
      HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN,
      HiEditModeEventUtils.BATCH_UNINSTALL_DIALOG_UE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 设置主屏打点
   *
   * @param params 上报参数
   */
  public static reportHomePageSetting(params: EditModeHomePageSettingParams): void {
    if (CheckEmptyUtils.isEmpty(params)) {
      log.showWarn(`reportHomePageSetting failed, params is invalid.`);
      return;
    }
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.SCREEN_TYPE = HiSysEventUtil.screenType;

    HiSysEventUtil.report(
      HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN,
      HiEditModeEventUtils.HOME_PAGE_SETTING_UE,
      hiSysEvent.EventType.BEHAVIOR,
      params
    );
  }

  /**
   * 编辑模式点击新增图标到桌面
   */
  public static reportAddAppToScreenByClick(appItem: AppItemInfo, row: number, col: number, page: number): void {
    let params: AddOuterAppByClick = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: appItem.bundleName,
      APPID: appItem.appId ?? '',
      APPNAME: appItem.appName,
      CELLX: row,
      CELLY: col,
      SCREENID: page,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiEditModeEventUtils.OUTER_HOME_UE, HiEditModeEventUtils.ADD_APP_TO_DESKTOP_BY_CLICK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 编辑模式拖拽图标新增到桌面
   */
  public static reportAddAppToScreenByDrag(appItem: GridLayoutItemInfo, row: number, col: number, page: number): void {
    let params: AddOuterAppByDrag = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PACKAGENAME: appItem.bundleName,
      APPID: appItem.appIconId,
      APPNAME: appItem.appName ?? '',
      CELLX: row,
      CELLY: col,
      SCREENID: page,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiEditModeEventUtils.OUTER_HOME_UE, HiEditModeEventUtils.ADD_APP_TO_DESKTOP_BY_DRAG,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 性能雷达 桌面编辑进入动效 开始打点
   */
  public static startEnterPerformanceTrack(): void {
    performanceMonitor.begin(HiEditModeEventUtils.EDITMODE_ENTER, performanceMonitor.ActionType.FIRST_MOVE);
  }
  /**
   * 性能雷达 桌面编辑进入动效 停止打点
   */
  public static endEnterPerformanceTrack(): void {
    performanceMonitor.end(HiEditModeEventUtils.EDITMODE_ENTER);
  }

  /**
   * 性能雷达 桌面编辑退出动效 开始打点
   */
  public static startExitPerformanceTrack(): void {
    performanceMonitor.begin(HiEditModeEventUtils.EDITMODE_EXIT, performanceMonitor.ActionType.FIRST_MOVE);
  }

  /**
   * 性能雷达 桌面编辑退出动效 停止打点
   */
  public static endExitPerformanceTrack(): void {
    performanceMonitor.end(HiEditModeEventUtils.EDITMODE_EXIT);
  }

  /**
   * 图标编辑进入动效 开始打点
   */
  public static startEnterIconEditPageTrack(): void {
    performanceMonitor.begin(HiEditModeEventUtils.ENTER_ICONEDITPAGE, performanceMonitor.ActionType.LAST_UP);
    TraceUtil.startTrace(DomainName.HOME, HiEditModeEventUtils.ENTER_ICONEDITPAGE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }
  /**
   * 图标编辑进入动效 停止打点
   */
  public static endEnterIconEditPageTrack(): void {
    performanceMonitor.end(HiEditModeEventUtils.ENTER_ICONEDITPAGE);
    TraceUtil.endTrace(DomainName.HOME, HiEditModeEventUtils.ENTER_ICONEDITPAGE, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  /**
   * 长按应用-拖动菜单中应用快捷方式至桌面
   */
  public static reportDragShortcutToDeskTop(shortcutId: string, bundleName: string, moduleName: string): void {
    let params: ShortcutParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SHORTCUTID: shortcutId,
      COMPONENT: bundleName,
      MODULENAME: moduleName,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, HiEditModeEventUtils.DRAG_SHORTCUT_TO_DESKTOP,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 移除快捷方式图标
   */
  public static reportShortcutReMove(shortcutId: string, bundleName: string, moduleName: string): void {
    let params: ShortcutParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      SHORTCUTID: shortcutId,
      COMPONENT: bundleName,
      MODULENAME: moduleName,
      SCREEN_TYPE: HiSysEventUtil.screenType,
    };
    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, HiEditModeEventUtils.EDITMODE_REMOVE_APP_SHORTCUT,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 编辑模式-点击dock图标-进入二级页
   */
  public static reportEnterSubPage(key: string): void {
    let params: EnterSubPageParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      PAGETITLE: key
    };
    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, HiEditModeEventUtils.EDITMODE_ENTER_SUBPAGE,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 图标编辑-应用图标编辑设置
   */
  public static reportApplyIconEdit(iconSize: number, isShow: boolean): void {
    let params: ApplyIconEditParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      ICONSIZE: iconSize,
      IS_NAME_SHOW: isShow
    };
    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, HiEditModeEventUtils.EDITMODE_ICONEDIT_APPLY,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * 图标编辑-应用图标编辑设置
   */
  public static reportMultiSelectDrag(): void {
    let params: BaseParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
    };
    HiSysEventUtil.report(HiEditModeEventUtils.SCENE_BOARD_UE_DOMAIN, HiEditModeEventUtils.EDITMODE_MULTISELECT_DRAG,
      hiSysEvent.EventType.BEHAVIOR, params);
  }
}

