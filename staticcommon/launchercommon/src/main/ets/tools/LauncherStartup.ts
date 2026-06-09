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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HiDfxEventUtil } from '@ohos/frameworkwrapper';
import { SceneMsgEnum } from '../TsIndex';

const TAG = 'LauncherStartup';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const TIMEOUT_DURATION: number = 60 * 1000;

/**
 * 桌面启动流程debug
 */
export class LauncherStartup {
  private static instance: LauncherStartup;
  private launcherStartupArray: string[] = [];
  private timeoutId: number | undefined = undefined;

  public static getInstance(): LauncherStartup {
    if (!LauncherStartup.instance) {
      LauncherStartup.instance = new LauncherStartup();
    }
    return LauncherStartup.instance;
  }

  private constructor() {
  }

  public passStep(step: string, valueInfo?: string): void {
    if (step === StartupStep.INIT_SCENE_BOARD) {
      this.launcherStartupArray = [];
      this.clearTimeout();
      this.timeoutId = setTimeout(() => {
        this.checkAndReportDfx();
      }, TIMEOUT_DURATION);
    }

    let currentTime: number = new Date().getTime();
    log.showInfo(`passStep ${step} when ${currentTime} and valueInfo:${valueInfo}`);
    let stepStr: string = CheckEmptyUtils.isEmpty(valueInfo) ? '' : `_${valueInfo}`;
    this.launcherStartupArray.push(`${currentTime}_${step}${stepStr}`);
  }

  private clearTimeout(): void {
    if (!CheckEmptyUtils.isEmpty(this.timeoutId)) {
      clearTimeout(this.timeoutId);
    }
  }

  public checkAndReportDfx(): void {
    if (!CheckEmptyUtils.isEmptyArr(this.launcherStartupArray)) {
      let startUpStr: string = this.launcherStartupArray.map((element, index) => {
        return `${index + 1}.${element}`
      }).join(',');
      HiDfxEventUtil.reportLauncherLayoutAbnormal(SceneMsgEnum.SCENE_MSG_STARTUP_ABNORMAL, startUpStr);
      log.showInfo(`checkAndReportDfx startUpStr:${startUpStr}`);
    }
    this.launcherStartupArray = [];
  }
}

export enum StartupStep {
  INIT_SCENE_BOARD = 'INIT_SCENE_BOARD',
  INIT_RDB_BEGIN = 'INIT_RDB_BEGIN',
  INIT_RDB_END = 'INIT_RDB_END',
  LOAD_UI_CONTENT = 'LOAD_UI_CONTENT',
  ENTRY_VIEW = 'ENTRY_VIEW',
  SCB_SCREEN = 'SCB_SCREEN',
  PHONE_STAGE = 'PHONE_STAGE',
  SCB_DESKTOP = 'SCB_DESKTOP',
  DESKTOP_VM = 'DESKTOP_VM',
  PERSIST_CONFIG = 'PERSIST_CONFIG',
  PERSIST_CONFIG_PAGE = 'PERSIST_CONFIG_PAGE',
  PERSIST_CONFIG_DB = 'PERSIST_CONFIG_DB',
  LOAD_DB = 'LOAD_DB',
  LOAD_BMS = 'LOAD_BMS',
  CORRECTOR = 'CORRECTOR',
  FILTER_BY_BMS = 'FILTER_BY_BMS',
  INIT_CACHE = 'INIT_CACHE',
  INIT_LOCK = 'INIT_LOCK',
  DOCK_INIT = 'DOCK_INIT',
  GRID_INIT = 'GRID_INIT',
  LOAD_GRID = 'LOAD_GRID',
  PAGING_FILTERING = 'PAGING_FILTERING',
  LOAD_CONFIG = 'LOAD_CONFIG',
  CONFIG_INTO_DB = 'CONFIG_INTO_DB',
  PRELOAD_FINISHED = 'PRELOAD_FINISHED',
  VOTE_FINISHED = 'VOTE_FINISHED',
}
