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
import sceneSessionManager from '@ohos.sceneSessionManager';
import process from '@ohos.process';
import { DomainName, LogDomain, LogHelper } from './LogHelper';
import { Trace } from './Trace';
import { TraceUtil } from './TraceUtil';
import { systemDateTime } from '@kit.BasicServicesKit';

const TAG = 'AnimateToScheduleUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export enum WindowPanelType {
  MINIMIZE = 0,
  MAXIMIZE = 1,
  RECOVERY = 2,
}

export enum SplitStatus {
  ENTER_SPLIT = 0,
  EXIT_SPLIT = 1,
}

export enum OptFromRecentType {
  START_APP = 0,
  CLOSE_APP = 1,
}

export enum SwipeDirectionUpType {
  SWIPE_DIRECTION_ENTER_TASK_CENTER = 0,
  SWIPE_DIRECTION_EXIT_TASK_CENTER = 1,
}

export class AnimateToScheduleUtils {
  public static readonly VALUE_START = 0;
  public static readonly VALUE_END = 1;
  public static readonly ACTION_ATTACH_START = 2;
  public static readonly ACTION_ATTACH_END = 2;
  public static readonly UNLOCK_START = 2;
  public static readonly WORKER_PRIORITY_START = 0;
  public static readonly WORKER_PRIORITY_END = 1;

  //与RSS约定，不能修改
  public static readonly RESTYPE = 33;
  public static readonly COMMON_RESTYPE = 34;
  public static readonly RECENT_BUILD = 150;
  public static readonly GC_RESTYPE = 72;
  public static readonly WORKER_RESTYPE = 503;
  public static readonly RESTYPE_ATTACH_BIGCORE = 9;
  public static readonly RESTYPE_RECLAIM = 100001;
  public static readonly PID = process.pid;
  public static readonly GC_EXTTYPE = '10000';
  public static readonly CPU_EXTTYPE = '10001';
  private static readonly COMMON_EXT_RESTYPE = 72;
  private static readonly SWIPE_UP_EXIT_APP = 1;
  private static readonly START_APP_EXT_TYPE = '10013';
  private static readonly EXIT_APP_EXT_TYPE = '10014';
  private static readonly MAX_TRY_TIMES = 25;
  private static readonly RAISE_BOOT_GC_INTERVAL = 200;
  private static readonly APP_START = 104;
  private static readonly ANIMATION_ROTATION = 105;
  private static readonly RES_TYPE_GESTURE_ANIMATION = 121;
  private static readonly RES_TYPE_REPORT_SCENE_BOARD = 38;
  private static readonly UID = process.uid;
  private static readonly SCENE_BOARD_BUNDLE_NAME = 'com.ohos.sceneboard';
  private static readonly RES_TYPE_RESIZE_WINDOW = 31;
  private static readonly RES_TYPE_APP_OPT_FROM_RECENT = 158;
  private static readonly RES_TYPE_SWIPE_DIRECTION_UP = 159;
  private static readonly RES_TYPE_WINDOW_PANEL = 160;
  private static readonly RES_TYPE_SPLIT_SCREEN = 162;
  private static readonly TWO_SECOND_MILL = 2000;
  private static intervalId: number | undefined = -1;
  private static try_times_count = 0;
  private static gc_priority_value = 0;
  private static gc_priority_timestamp = 0;

  /**
   * 提升动效调度效率(GC避让同时提频)
   * @param value 0-动效开始 1-动效结束
   */
  public static raiseAnimateToSchedulePriority(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString()
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RESTYPE, value, payload);
      log.showDebug(`raiseAnimateToSchedulePriority: ${value}`);
    } catch (error) {
      log.showError(`raiseAnimateToSchedulePriority error: ${error}`);
    }
  }

  /**
   * 冷启动场景,提升GC避让效率,由于单次调用提升GC避让接口存在2s有效时间,采用在冷启动过程中定时执行确保
   */
  public static raiseBootGCPriority(): void {
    AnimateToScheduleUtils.intervalId = setInterval(() => {
      AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_START);
      AnimateToScheduleUtils.try_times_count++;
      if (AnimateToScheduleUtils.try_times_count > AnimateToScheduleUtils.MAX_TRY_TIMES) {
        AnimateToScheduleUtils.stopBootGCPriority();
      }
    }, AnimateToScheduleUtils.RAISE_BOOT_GC_INTERVAL);
  }

  /**
   * 冷启动场景结束, 关闭提升GC避让
   */
  public static stopBootGCPriority(): void {
    if (AnimateToScheduleUtils.intervalId !== undefined) {
      clearInterval(AnimateToScheduleUtils.intervalId);
      AnimateToScheduleUtils.intervalId = undefined;
    }
    AnimateToScheduleUtils.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
  }

  /**
   * DC组件的worker设置高优先级
   * @param tid worker线程id
   * @param isStart 是否启用
   */
  public static raiseWorkerThreadPriority(tid: number, isStart: boolean): void {
    try {
      const value = isStart ? AnimateToScheduleUtils.WORKER_PRIORITY_START : AnimateToScheduleUtils.WORKER_PRIORITY_END;
      const payload: Record<string, string> = {
        'scrtid': tid.toString(),
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.WORKER_RESTYPE, value, payload);
      log.showInfo(`raiseWorkerThreadPriority value ${value}, tid:${tid}`);
    } catch (error) {
      log.showError(`raiseWorkerThreadPriority error: ${error}, tid:${tid}`);
    }
  }

  /**
   * 提升GC避让效率
   * @param value 0-动效开始 1-动效结束
   */
  public static raiseAnimateToGCPriority(value: number, tid?: number): void {
    // 避免开始和结束未成对出现导致的敏感场景无法退出的问题,连续进入敏感场景如果间隔2s内则不重复下发
    if (value === AnimateToScheduleUtils.gc_priority_value && tid === undefined) {
      if (value === AnimateToScheduleUtils.VALUE_END) {
        return;
      }
      if (value === AnimateToScheduleUtils.VALUE_START &&
        (systemDateTime.getTime() - AnimateToScheduleUtils.gc_priority_timestamp) <
        AnimateToScheduleUtils.TWO_SECOND_MILL) {
        return;
      }
    }
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'extType': AnimateToScheduleUtils.GC_EXTTYPE
      };
      // 静态切分场景，传入子线程的tid
      if (tid !== undefined) {
        Reflect.set(payload, 'scrTid', tid.toString());
      } else {
        AnimateToScheduleUtils.gc_priority_value = value;
        AnimateToScheduleUtils.gc_priority_timestamp = systemDateTime.getTime();
      }
      sceneSessionManager.reportData(AnimateToScheduleUtils.GC_RESTYPE, value, payload);
      log.showInfo(`raiseAnimateToGCPriority: ${value}, tid:${tid}`);
    } catch (error) {
      log.showError(`raiseAnimateToGCPriority error: ${error}, tid:${tid}`);
    }
  }

  /**
   * 提升cpu频率
   * @param value 0-动效开始 1-动效结束
   */
  public static raiseAnimateToCPUPriority(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'extType': AnimateToScheduleUtils.CPU_EXTTYPE
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.GC_RESTYPE, value, payload);
      log.showDebug(`raiseAnimateToCPUPriority: ${value}`);
    } catch (error) {
      log.showError(`raiseAnimateToCPUPriority error: ${error}`);
    }
  }

  /**
   * 冷启动提升cpu频率
   * @param value 0-冷启动开始 1-冷启动结束
   */
  public static raiseAppStartToCPUPriority(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'extType': AnimateToScheduleUtils.CPU_EXTTYPE
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.APP_START, value, payload);
      log.showInfo(`raiseAppStartToCPUPriority: ${value}`);
    } catch (error) {
      log.showError(`raiseAppStartToCPUPriority error: ${error}`);
    }
  }

  /**
   * 旋转动效提升cpu频率
   * @param value 0-旋转动效开始 1-旋转动效结束
   */
  public static raiseAnimateRotationToCPUPriority(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'extType': AnimateToScheduleUtils.CPU_EXTTYPE
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.ANIMATION_ROTATION, value, payload);
      log.showInfo(`raiseAnimateRotationToCPUPriority: ${value}`);
    } catch (error) {
      log.showError(`raiseAnimateRotationToCPUPriority error: ${error}`);
    }
  }

  /**
   * 关键场景绑定大核和提频
   * @param value 2-动效开始 & 结束
   */
  public static attachBigCoreCPU(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString()
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RESTYPE_ATTACH_BIGCORE, value, payload);
      log.showInfo(`attachBigCoreCPU: ${value}`);
    } catch (error) {
      log.showError(`attachBigCoreCPU error: ${error}`);
    }
  }

  public static raiseResizeWindow(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString()
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_RESIZE_WINDOW, value, payload);
      log.showInfo(`raiseResizeWindow: ${value}`);
    } catch (error) {
      log.showError(`raiseResizeWindow error: ${error}`);
    }
  }

  /**
   * 提升频点 cmdId[10007]
   * @param value 0-渲染 1-渲染结束
   */
  public static raiseBuildSchedulePriority(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString()
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.COMMON_RESTYPE, value, payload);
    } catch (error) {
      log.showError(TAG, `raiseBuildSchedulePriority error: ${error}`);
    }
  }

  /**
   * 提升多任务预加载卡片频点 cmdId[10200]
   * @param value 0-渲染 1-渲染结束
   */
  public static raiseRecentBuildSchedulePriority(value: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': this.PID.toString()
      };
      sceneSessionManager.reportData(this.RECENT_BUILD, value, payload);
      log.showInfo(`raiseRecentBuildSchedulePriority: ${value}`);
    } catch (error) {
      log.showError(TAG, `raiseRecentBuildSchedulePriority error: ${error}`);
    }
  }

  /**
   * 调用c++层的reclaim接口
   */
  public static reportReclaimMem(): void {
    Trace.start(`${TAG}_doReclaim`);
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'reclaimTag' : 'true'
      };
      log.showInfo('start report rMem');
      sceneSessionManager.reportData(AnimateToScheduleUtils.RESTYPE_RECLAIM, AnimateToScheduleUtils.VALUE_START,
        payload);
      log.showInfo('report finished.');
    } catch (error) {
      log.showError(`raiseBuildSchedulePriority error: ${error}`);
    }
    Trace.end(`${TAG}_doReclaim`);
  }

  /**
   * 打开应用
   * @param bundleName 应用包名
   */
  public static reportStartAppToRss(bundleName?: string): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'extType': AnimateToScheduleUtils.START_APP_EXT_TYPE,
        'bundleName': bundleName ? bundleName : ''
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.COMMON_EXT_RESTYPE, 0, payload);
      log.showDebug(`report name: ${bundleName}`);
    } catch (error) {
      log.showError(`report error: ${error}`);
    }
  }

  /**
   * 上滑退出应用
   * @param bundleName 应用包名
   */
  public static reportSwipeUpExitApp(bundleName?: string): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'extType': AnimateToScheduleUtils.EXIT_APP_EXT_TYPE,
        'bundleName': bundleName ? bundleName : ''
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.COMMON_EXT_RESTYPE,
        AnimateToScheduleUtils.SWIPE_UP_EXIT_APP, payload);
      log.showDebug(`report name: ${bundleName}`);
    } catch (error) {
      log.showError(`report error: ${error}`);
    }
  }

  /**
   * 手势场景事件上报
   *
   * @param bundleName 应用包名，可能会存在 1-3个
   */
  public static reportGestureEvent(event: number | undefined, bundleName: string): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'bundleName': bundleName
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_GESTURE_ANIMATION, event, payload);
      log.showInfo(`report name: ${bundleName} event:${event}`);
    } catch (error) {
      log.showError(`report error: ${error}`);
    }
  }

  /**
   * 提高指定子线程优先级
   * @param tid 子线程的tid
   */
  public static raiseThreadPriority(tid: number): void {
    try {
      let payload: Record<string, string> = {
        'pid': AnimateToScheduleUtils.PID.toString(),
        'tid': tid.toString(),
        'uid': AnimateToScheduleUtils.UID.toString(),
        'bundleName': AnimateToScheduleUtils.SCENE_BOARD_BUNDLE_NAME
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_REPORT_SCENE_BOARD, 0, payload);
      log.showInfo(`raiseThreadPriority tid: ${tid}`);
    } catch (error) {
      log.showError(`raiseThreadPriority tid: ${tid}}`);
    }
  }

  /**
   * 最小化窗口
   * @param bundleName 应用包名
   */
  public static reportMinimizeToRss(bundleName?: string): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'bundleName': bundleName ? bundleName : ''
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_WINDOW_PANEL, 0, payload);
      log.showDebug(`report name: ${bundleName}`);
    } catch (error) {
      log.showError(`minimize report error: ${error}`);
    }
  }

  /**
   * 最大化/还原窗口
   * @param bundleName 应用包名
   */
  public static reportMaximizeToRss(event: number, bundleName?: string): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'bundleName': bundleName ? bundleName : ''
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_WINDOW_PANEL, event, payload);
      log.showDebug(`report name: ${bundleName}`);
    } catch (error) {
      log.showError(`maximize report error: ${error}`);
    }
  }

  /**
   * 分屏场景
   * @param bundleName 应用包名
   */
  public static reportSplitToRss(event: number, bundleName?: string): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'bundleName': bundleName ? bundleName : ''
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_SPLIT_SCREEN, event, payload);
      log.showDebug(`report name: ${bundleName}`);
    } catch (error) {
      log.showError(`split report error: ${error}`);
    }
  }

  /**
   * 任务中心点击退出、删除
   * @param bundleName 应用包名
   */
  public static reportAppOptFromRecentToRss(event: number, bundleName?: string): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'bundleName': bundleName ? bundleName : ''
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_APP_OPT_FROM_RECENT, event, payload);
      log.showDebug(`appOptFromRecent report name: ${bundleName}, event: ${event}`);
    } catch (error) {
      log.showError(`report appOptFromRecent failed. error code: ${error?.code}, message: ${error?.message}`);
    }
  }

  /**
   * 三指上滑
   */
  public static reportSwipeDirectionUpToRss(event: number): void {
    try {
      let payload: Record<string, string> = {
        'scrpid': AnimateToScheduleUtils.PID.toString(),
        'bundleName': 'com.ohos.sceneboard',
      };
      sceneSessionManager.reportData(AnimateToScheduleUtils.RES_TYPE_SWIPE_DIRECTION_UP, event, payload);
      log.showDebug(`swipeDirectionUp event: ${event}`);
    } catch (error) {
      log.showError(`report swipeDirectionUp failed. error code: ${error?.code}, message: ${error?.message}`);
    }
  }

}