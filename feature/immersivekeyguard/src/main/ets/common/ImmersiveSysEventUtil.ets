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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { CurrentCpuScene, CurrentMemScene, PerformanceReporter } from '@ohos/frameworkcommon';
import { HiSysReportEvent, ReportDomain, ReportParams } from '@ohos/frameworkwrapper';
import { LiveType, LiveViewData } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveNtfData } from '../viewmodel/viewdata/ImmersiveNtfData';

const TAG = 'ImmersiveSysEventUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸锁屏打点上报工具类
 */
export class ImmersiveSysEventUtil {
  private static readonly SCREENLOCK_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.SCREENLOCK_UE);
  // 字段间隔符号
  public static readonly ITEM_SEPARATOR: string = ',';
  // 锁屏通知生命周期
  public static readonly IMMERSIVE_LIFECYCLE: string = 'IMMERSIVE_LIFECYCLE';
  // 收纳态、列表态、沉浸态切换
  public static readonly TOGGLE_STATUS: string = 'TOGGLE_STATUS';
  // 列表触底解锁
  public static readonly SLIDE_TO_UNLOCK: string = 'SLIDE_TO_UNLOCK';
  // 默认显示沉浸态
  public static readonly SHOW_IMMERSIVE_CARD: string = 'SHOW_IMMERSIVECARD';

  /**
   * 打点
   *
   * @param name 事件名称
   * @param params 事件参数
   */
  static reportImmersiveEvent(name: string, params: ImmersiveReportParams): void {
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    ImmersiveSysEventUtil.SCREENLOCK_UE.reportBehavior(name, params);
  }

  /**
   * 沉浸锁屏 为实况通知时的生命周期打点
   *
   * @param liveEntry 打点数据
   * @param lifeCycle 生命周期
   */
  public static reportImmersiveCycleEvent(liveEntry?: LiveViewData, lifeCycle?: number): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.IMMERSIVE_LIFECYCLE, {
      USER_PACKAGE_NAME: liveEntry?.creatorBundleName ?? '0',
      NOTIFICATION_ID: String(liveEntry?.id ?? 0),
      OPERATION: lifeCycle,
      LIVE_TEMPLATE_TYPE: liveEntry?.template?.getLiveType()
    });
  }

  /**
   * 沉浸锁屏 为普通通知时的生命周期打点
   *
   * @param liveEntry 打点数据
   * @param lifeCycle 生命周期
   */
  public static reportNotifyLifeCycleEvent(immersiveEntry?: ImmersiveNtfData, lifeCycle?: number): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.IMMERSIVE_LIFECYCLE, {
      USER_PACKAGE_NAME: immersiveEntry?.creatorBundleName ?? '0',
      NOTIFICATION_ID: String(immersiveEntry?.id ?? 0),
      OPERATION: lifeCycle,
      LIVE_TEMPLATE_TYPE: -1
    });
  }

  /**
   * 收纳态、列表态、沉浸态 切换时打点
   *
   * @param immersiveEntry 打点数据
   * @param oldStatus 切换前的状态
   * @param newStatus 切换后的状态
   * @param way 切换的方式
   */
  public static reportToggleStatusEvent(immersiveEntry?: ImmersiveNtfData, oldStatus?: number, newStatus?: number,
                                        way?: number): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.TOGGLE_STATUS, {
      USER_PACKAGE_NAME: immersiveEntry?.creatorBundleName ?? '0',
      NOTIFICATION_ID: String(immersiveEntry?.id ?? 0),
      LIVE_TEMPLATE_TYPE: immersiveEntry?.capsuleData?.liveView?.template?.getLiveType(),
      OLD_STATUS: oldStatus,
      NEW_STATUS: newStatus,
      HANDOVER_TYPE: way
    });
  }

  public static reportListToCapEvent(oldStatus?: number, newStatus?: number, way?: number): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.TOGGLE_STATUS, {
      USER_PACKAGE_NAME: '0',
      NOTIFICATION_ID: '0',
      LIVE_TEMPLATE_TYPE: -1,
      OLD_STATUS: oldStatus,
      NEW_STATUS: newStatus,
      HANDOVER_TYPE: way
    });
  }

  // back手势 普通列表退出到胶囊
  public static reportListToCapsuleEvent(immersiveEntry?: ImmersiveNtfData): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.TOGGLE_STATUS, {
      USER_PACKAGE_NAME: immersiveEntry?.creatorBundleName ?? '0',
      NOTIFICATION_ID: String(immersiveEntry?.id ?? 0),
      LIVE_TEMPLATE_TYPE: immersiveEntry?.capsuleData?.liveView?.template?.getLiveType(),
      OLD_STATUS: StatusParams.LIST,
      NEW_STATUS: StatusParams.CAPSULE,
      HANDOVER_TYPE: ToggleWay.BACK
    });
  }

  // back手势 沉浸态退出到胶囊
  public static reportExitToCapsuleEvent(immersiveEntry?: ImmersiveNtfData): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.TOGGLE_STATUS, {
      USER_PACKAGE_NAME: immersiveEntry?.creatorBundleName ?? '0',
      NOTIFICATION_ID: String(immersiveEntry?.id ?? 0),
      LIVE_TEMPLATE_TYPE: immersiveEntry?.capsuleData?.liveView?.template?.getLiveType(),
      OLD_STATUS: StatusParams.IMMERSIVE,
      NEW_STATUS: StatusParams.CAPSULE,
      HANDOVER_TYPE: ToggleWay.BACK
    });
  }

  // back手势 沉浸态退出到列表
  public static reportExitToListEvent(immersiveEntry?: ImmersiveNtfData): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.TOGGLE_STATUS, {
      NOTIFICATION_ID: String(immersiveEntry?.id ?? 0),
      USER_PACKAGE_NAME: immersiveEntry?.creatorBundleName ?? '0',
      LIVE_TEMPLATE_TYPE: immersiveEntry?.capsuleData?.liveView?.template?.getLiveType(),
      OLD_STATUS: StatusParams.IMMERSIVE,
      NEW_STATUS: StatusParams.LIST,
      HANDOVER_TYPE: ToggleWay.BACK
    });
  }

  // 列表上滑触底解锁
  public static reportListAtEndUnlockEvent(way?: number): void {
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.SLIDE_TO_UNLOCK, {
      HANDOVER_TYPE: way
    });
  }

  // 进入沉浸态内存打点
  public static reportEnterCpuMemEvent(): void {
    PerformanceReporter.getInstance().reportEnterCpuScene(CurrentCpuScene.START_IMMERSIVE);
    PerformanceReporter.getInstance().reportEnterMemScene(CurrentMemScene.START_IMMERSIVE);
  }

  // 退出沉浸态内存打点
  public static reportExitCpuMemEvent(): void {
    PerformanceReporter.getInstance().reportExitCpuScene(CurrentCpuScene.START_IMMERSIVE);
    PerformanceReporter.getInstance().reportExitMemScene(CurrentMemScene.START_IMMERSIVE);
  }

  // 默认进入沉浸态打点
  public static reportShowImmCardEvent(immersiveEntry: ImmersiveNtfData): void {
    if (!immersiveEntry) {
      log.showWarn('reportShowImmCardEvent ImmersiveNtfData is invalid');
      return;
    }
    ImmersiveSysEventUtil.reportImmersiveEvent(ImmersiveSysEventUtil.SHOW_IMMERSIVE_CARD, {
      NOTIFICATION_ID: String(immersiveEntry.id ?? 0),
      USER_PACKAGE_NAME: immersiveEntry.creatorBundleName ?? '',
      LIVE_TEMPLATE_TYPE: immersiveEntry.capsuleData?.liveView?.template?.getLiveType()
    });
  }
}

export class ImmersiveReportParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public USER_PACKAGE_NAME?: string;
  public NOTIFICATION_ID?: string;
  public LIVE_TEMPLATE_TYPE?: LiveType;

  public CURRENT_STATUS?: number;
  public OLD_STATUS?: number;
  public NEW_STATUS?: number;
  public HANDOVER_TYPE?: number;

  public OPERATION?: number;
  public REASON?: number;
}

export enum StatusParams {
  CAPSULE = 1,
  LIST = 2,
  IMMERSIVE = 3,
}

export enum ToggleWay {
  CLICK = 1,
  LONG_CLICK = 2,
  DOWN = 3,
  UP = 4,
  BACK = 5,
  BLANK = 6
}

export enum Lifecycle {
  CREATE = 0,
  UPDATE = 1,
  DELETE = 2
}


