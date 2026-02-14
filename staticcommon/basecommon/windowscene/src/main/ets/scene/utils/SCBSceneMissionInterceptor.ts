/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { SCBScreenSessionManager } from '../../TsIndex';

const TAG: string = 'SCBSceneMissionInterceptor';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class SCBSceneMissionInterceptor {
  private isFirstExpandToFold: boolean = false;
  private isNeedToIntercept: boolean = false;

  /**
   * when first expand to fold and onUnlockReceived, clear active session list if need
   *
   * @param activeSessionList
   */
  public onInterceptedFromUnlockToForeground(activeSessionList: number[]): void {
      return;
  }

  /**
   * when first expand to fold and locked, set app intercept state
   *
   * @param isNeedToIntercept
   */
  public setAppInterceptState(isNeedToIntercept: boolean): void {
      return;
  }

  /**
   * set is first expand to fold
   *
   * @param isFirstExpandToFold
   */
  public setIsFirstExpandToFold(isFirstExpandToFold: boolean): void {
      return;
  }
}

export let sceneMissionInterceptor: SCBSceneMissionInterceptor =
  SingletonHelper.getInstance(SCBSceneMissionInterceptor, TAG);