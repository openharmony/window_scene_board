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

import { LogDomain, LogHelper, } from '@ohos/basicutils';

const TAG = 'SCBMultiRecentManager';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

/**
 * Class SCBMultiRecentManager. aim to solve the timing problem of multi-screen task centers.
 */
export class SCBMultiRecentManager {
  private static instance: SCBMultiRecentManager;
  // 用于主副屏同时显示多任务中心，按win+d场景,主屏响应win+d，改showRecent,副屏不用响应ChangeRecent,副屏响应win+d
  private changeRecentResponsive = true;

  /**
   * Obtains the single SCBMultiRecentManager object.
   *
   * @return SCBMultiRecentManager
   */
  static getInstance(): SCBMultiRecentManager {
    if (!SCBMultiRecentManager.instance) {
      SCBMultiRecentManager.instance = new SCBMultiRecentManager();
    }
    return SCBMultiRecentManager.instance;
  }

  /**
   * Initializing Variables
   */
  public init(): void {
    this.changeRecentResponsive = true;
  }

  /**
   *  Indicates disable response. which used in changeRecent Function in SCBScenePanel
   */
  public disableChangeRecentResponsive(): void {
    this.changeRecentResponsive = false;
  }

  /**
   *  Indicates enable response. which used in changeRecent Function in SCBScenePanel
   */
  public enableChangeRecentResponsive(): void {
    this.changeRecentResponsive = true;
  }

  /**
   * return whether changeRecent is Responsive
   * @returns
   */
  public checkChangeRecentResponsive(): boolean {
    log.showInfo(`checkChangeRecentResponsive, WinDResponsive: ${this.changeRecentResponsive}`);
    return this.changeRecentResponsive;
  }
}