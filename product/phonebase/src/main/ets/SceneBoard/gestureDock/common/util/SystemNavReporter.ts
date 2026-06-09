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

import { SCBSceneSessionManager } from '@ohos/windowscene';
import { HiSysDockEditType } from '@ohos/frameworkwrapper';
import { HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper';
import {
  AddAppToDockParams,
  DeleteAppFromDockParams,
  DockDisappearParams,
  EnterDockEditParams,
  ExitDockEditParams,
  GestureDockShowParams,
  ReportParams,
  SwapAppInDockParams
} from '@ohos/frameworkwrapper';

/**
 * 桌面导航相关打点工具类
 */
export class SystemNavReporter {
  // 侧边滑动呼出Dock
  private static readonly GESTURE_DOCK_SHOW: string = 'GESTURE_DOCK_SHOW';
  // 侧边Dock退出
  private static readonly DOCK_DISAPPEAR: string = 'DOCK_DISAPPEAR';
  // 进入Dock编辑界面
  private static readonly ENTER_DOCK_EDIT: string = 'ENTER_DOCK_EDIT';
  // 侧边dock增加应用
  private static readonly ADD_APP_TO_DOCK: string = 'ADD_APP_TO_DOCK';
  // 侧边dock删除应用
  private static readonly DELETE_APP_FROM_DOCK: string = 'DELETE_APP_FROM_DOCK';
  // 侧边dock换位
  private static readonly SWAP_APP_IN_DOCK: string = 'SWAP_APP_IN_DOCK';
  // 退出Dock编辑界面
  private static readonly EXIT_DOCK_EDIT: string = 'EXIT_DOCK_EDIT';

  private static mSystemNavReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(ReportDomain
    .SYSTEM_NAV_UE);

  /**
   * 侧边滑动呼出Dock
   *
   * @param side dock方向(0:左边 1:右边)
   */
  static reportGestureDockShow(side: number): void {
    let apps = this.getForegroundSessionList();
    let params: GestureDockShowParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      APPS: apps,
      SIDE: side
    };
    this.mSystemNavReportEvent.reportBehavior(SystemNavReporter.GESTURE_DOCK_SHOW, params);
  }

  /**
   * 侧边Dock退出
   *
   * @param side dock方向(0:左边 1:右边)
   * @params timeGap dock展示持续时长
   * @param mode 触发Dock消失的方式（0:点击空白消失、1:back消失、2:左边手势划出dock右边dock消失、3:右边手势划出dock左边dock消失）
   */
  static reportDockDisappear(side: number, timeGap: number, mode: number): void {
    let apps = this.getForegroundSessionList();
    let params: DockDisappearParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      APPS: apps,
      SIDE: side,
      TIMEGAP: timeGap,
      MODE: mode
    };
    this.mSystemNavReportEvent.reportBehavior(SystemNavReporter.DOCK_DISAPPEAR, params);
  }

  /**
   * 进入Dock编辑界面
   */
  static reportEnterDockEdit(type: HiSysDockEditType): void {
    let params: EnterDockEditParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      TIME: this.getTime(),
      TYPE: type
    };
    this.mSystemNavReportEvent.reportBehavior(SystemNavReporter.ENTER_DOCK_EDIT, params);
  }

  /**
   * 侧边dock增加应用
   *
   * @param bundleName 应用的包名
   * @param source 应用来源
   */
  static reportAddAppToDock(bundleName: string, source: number): void {
    let params: AddAppToDockParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName,
      SOURCE: source

    };
    this.mSystemNavReportEvent.reportBehavior(SystemNavReporter.ADD_APP_TO_DOCK, params);
  }

  /**
   * 侧边dock删除应用
   *
   * @param bundleName 应用的包名
   */
  static reportDeleteAppFromDock(bundleName: string): void {
    let params: DeleteAppFromDockParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName
    };
    this.mSystemNavReportEvent.reportBehavior(SystemNavReporter.DELETE_APP_FROM_DOCK, params);
  }

  /**
   * 侧边dock换位
   * @param bundleName 应用的包名
   * @param oldIndex 应用原来在Dock中的位置
   * @param newIndex 应用新的在Dock中的位置
   */
  static reportSwapAppInDock(bundleName: string, oldIndex: number, newIndex: number): void {
    let params: SwapAppInDockParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      BUNDLENAME: bundleName,
      OLDINDEX: oldIndex,
      NEWINDEX: newIndex
    };
    this.mSystemNavReportEvent.reportBehavior(SystemNavReporter.SWAP_APP_IN_DOCK, params);
  }

  /**
   * 退出Dock编辑界面
   */
  static reportExitDockEdit(type: HiSysDockEditType): void {
    let params: ExitDockEditParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      TIME: this.getTime(),
      TYPE: type
    };
    this.mSystemNavReportEvent.reportBehavior(SystemNavReporter.EXIT_DOCK_EDIT, params);
  }

  /**
   * 获取当前前台显示所有应用的信息(pkg：包名;state：展示状态（全屏、悬浮窗、分屏）)
   */
  static getForegroundSessionList(): string[] {
    let foregroundSessionList: string[] = [];
    let containerSessionList = SCBSceneSessionManager.getInstance().getContainerSessionList();
    let activeContainerSession = containerSessionList.getTopActiveSession();
    if (activeContainerSession) {
      foregroundSessionList.push(`pkg:${activeContainerSession.getBundleName()};state:${activeContainerSession.isSplit ?
        'SPLIT' : 'FULLSCREEN'}`);
    }
    let floatContainerSessionList = SCBSceneSessionManager.getInstance().getFloatingSessionList();
    floatContainerSessionList.forEach((floatContainerSession) => {
      if (floatContainerSession.isActive && !floatContainerSession.floatingParam.isFloatingSceneClosed()) {
        foregroundSessionList.push(`pkg:${floatContainerSession.getBundleName()};state:FLOATING`);
      }
    });
    if (foregroundSessionList.length === 0) {
      foregroundSessionList.push('desktop');
    }
    return foregroundSessionList;
  }

  /**
   * 获取当前时间的字符串格式，格式为：年月日时分秒
   */
  static getTime(): string {
    let date = new Date();
    let time = String(date.getFullYear()) +
    String(date.getMonth() + 1).padStart(2, '0') +
    String(date.getDate()).padStart(2, '0') +
    String(date.getHours()).padStart(2, '0') +
    String(date.getMinutes()).padStart(2, '0') +
    String(date.getSeconds()).padStart(2, '0');
    return time;
  }
}