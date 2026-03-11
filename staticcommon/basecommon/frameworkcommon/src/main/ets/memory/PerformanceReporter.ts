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
import { HiSysEventUtil } from '@ohos/frameworkwrapper';
import { ReportParams } from '@ohos/frameworkwrapper';

import hiSysEvent from '@ohos.hiSysEvent';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'PerformanceReporter';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export const PERFORMANCE_DOMIN: string = 'PERFORMANCE';

export const PERFORMANCE_CPU: string = 'CPU_SCENE_ENTRY';

export const PERFORMANCE_MEM: string = 'MEM_SCENE_ENTRY';

/**
 * 需要上报内存大数据打点场景定义
 * 最大值: 1 << 30
 */
export enum CurrentMemScene {
  // 空场景
  FREE = 0,

  // 冷启动
  START_SCENEBOARD = 1 << 0,

  // IMMERSIVE
  START_IMMERSIVE = 1 << 2,

  // 锁屏场景
  SCENE_SCREEN_LOCK = 1 << 3,

  // AOD场景
  SCENE_AOD = 1 << 4,

  // 应用处于前台场景
  SCENE_APP_FRONT = 1 << 5,

  // 多任务场景
  SCENE_RECENT = 1 << 6,

  // 通知中心场景
  SCENE_NOTIFICATION = 1 << 7,

  // 控制中心场景
  SCENE_CONTROL_CENTER = 1 << 8,

  // 负一屏场景
  SCENE_INTELLIGENT = 1 << 9,

  // 全局搜索场景
  SCENE_GLOBAL_SEARCH = 1 << 10,

  // 卡片中心场景
  SCENE_FORM_CENTER = 1 << 11,

  // 音量条场景
  SCENE_VOLUME = 1 << 12,

  // 文件夹场景
  SCENE_FOLDER = 1 << 13,

  // 桌面滑动
  ACTION_DESKTOP_SLIDE = 1 << 14,

  // 在桌面上拖拽元素
  ACTION_DRAG_ITEM = 1 << 15,

  // 修改语言场景
  ACTION_LANGUAGE_CHANGE = 1 << 16,

  // 声音二级页面场景
  SCENE_SOUND = 1 << 17,

  // 指纹图案显隐场景
  SCENE_FINGERPRINT = 1 << 18,

  // 播控二级页面场景
  MEDIA_CENTER = 1 << 19,

  // 主题切换场景
  SCENE_THEME_CHANGE = 1 << 20,

  // 克隆场景
  SCENE_CLONE = 1 << 21,
}

/**
 * 需要上报cpu大数据打点场景定义
 */
export enum CurrentCpuScene {
  // 空场景
  FREE = 0,

  // 冷启动
  START_SCENEBOARD = 1 << 0,

  // IMMERSIVE
  START_IMMERSIVE = 1 << 2,
}

/**
 * 性能大数据打点上报参数
 */
export class PerformanceReporterParams {
  PACKAGE_NAME: string = '';
  SCENE_ID: number = 0;
  HAPPEN_TIME: number = 0;
}

/**
 * 性能大数据打点上报工具
 *
 * @since 2024-02-22
 */
export class PerformanceReporter {
  private currentMemScene: CurrentMemScene = CurrentMemScene.FREE;
  private currentCpuScene: CurrentCpuScene = CurrentCpuScene.FREE;
  private static sInstance: PerformanceReporter | undefined = undefined;

  /**
   * 获取性能大数据上报单例
   *
   * @return 单例实例
   */
  static getInstance(): PerformanceReporter {
    if (PerformanceReporter.sInstance === undefined) {
      PerformanceReporter.sInstance = new PerformanceReporter();
    }
    return PerformanceReporter.sInstance;
  }

  /**
   * 上报cpu进入场景大数据打点
   * @param scene
   */
  public reportEnterCpuScene(scene: CurrentCpuScene): void {
    let cpuScene = this.currentCpuScene;
    this.currentCpuScene |= scene;
    this.reportCpuScene('Enter', scene, cpuScene);
  }

  /**
   * 上报cpu退出场景,将场景标识还原
   * @param scene
   */
  public reportExitCpuScene(scene: CurrentCpuScene): void {
    this.currentCpuScene &= ~scene;
  }

  private reportCpuScene(tag:string, calledScene: CurrentCpuScene, olderScene: CurrentCpuScene): void {
    if (olderScene === this.currentCpuScene) {
      if (calledScene !== CurrentCpuScene.FREE) {
        log.showInfo('%{public}s calledScene:%{public}d, currentScene is not changed.', tag, calledScene);
      }
      return;
    }
    let msg: PerformanceReporterParams = {
      'PACKAGE_NAME': ReportParams.PACKAGE_NAME,
      'SCENE_ID': this.currentCpuScene,
      'HAPPEN_TIME': new Date().getTime()
    };
    log.showInfo('%{public}s calledScene:%{public}d, currentCpuScene:%{public}d', tag, calledScene, this.currentCpuScene);
    HiSysEventUtil.reportEvent(PERFORMANCE_CPU, msg, hiSysEvent.EventType.BEHAVIOR, PERFORMANCE_DOMIN);
  }

  /**
   * 上报内存进入场景大数据打点
   * @param scene
   */
  public reportEnterMemScene(scene: CurrentMemScene): void {
    let olderScene = this.currentMemScene;
    this.currentMemScene |= scene;
    this.reportMemScene('Enter', scene, olderScene);
  }

  /**
   * 上报内存退出场景,将场景标识还原
   * @param scene
   */
  public reportExitMemScene(scene: CurrentMemScene): void {
    this.currentMemScene &= ~scene;
  }

  private reportMemScene(tag:string, calledScene: CurrentMemScene, olderScene: CurrentMemScene): void {
    if (olderScene === this.currentMemScene) {
      if (calledScene !== CurrentMemScene.FREE) {
        log.showInfo('%{public}s calledScene:%{public}d, currentScene is not changed.', tag, calledScene);
      }
      return;
    }
    let msg: PerformanceReporterParams = {
      'PACKAGE_NAME': ReportParams.PACKAGE_NAME,
      'SCENE_ID': this.currentMemScene,
      'HAPPEN_TIME': new Date().getTime()
    };
    log.showInfo('%{public}s calledScene:%{public}d, currentMemScene:%{public}d', tag, calledScene, this.currentMemScene);
    HiSysEventUtil.reportEvent(PERFORMANCE_MEM, msg, hiSysEvent.EventType.BEHAVIOR, PERFORMANCE_DOMIN);
  }
}