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
import { ScbState } from '../ThemeConstant';
import { TsLruCache } from './TsLruCache';
import { TsProxyHandler } from './TsProxyHandler';

const LRU_CACHE_SIZE: number = 3;

const LOG: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'TsAnimationHandler');

export class TsAnimationHandler {
  private proxyHandler?: TsProxyHandler;

  private animationFinishCallback?: () => void;

  private finishCallbackMap: TsLruCache = new TsLruCache(LRU_CACHE_SIZE);

  private isAllowNotifyFinish: boolean = true;

  public constructor(proxyHandler: TsProxyHandler) {
    this.setProxyHandler(proxyHandler);
  }

  public setProxyHandler(proxyHandler: TsProxyHandler): void {
    if (proxyHandler instanceof TsProxyHandler) {
      this.proxyHandler = proxyHandler;
      LOG.info('setProxyHandler finish');
    }
  }

  public playAnimationWithScbState(scbSrc: number, scbDst: number, isPlayAnimation: boolean,
    timestamp: number, onFinish: (() => void) | undefined): void {
    this.finishCallbackMap.put(timestamp, onFinish);
    this.proxyHandler?.sendDynamicAnimationUpdate(scbSrc, scbDst, isPlayAnimation, timestamp);
  }

  public playEngineAnimation(animationState: number): void {
    this.proxyHandler?.sendAnimationUpdate(animationState);
  }

  public setAnimationFinishCallback(callback: (() => void) | undefined): void {
    this.isAllowNotifyFinish = true;
    this.animationFinishCallback = callback;
  }

  public onAnimationFinish(taskId?: number): void {
    // Execute the latest task if LRU cache is not needed
    if (!taskId || taskId === -1) {
      if (this.isAllowNotifyFinish) {
        LOG.info('Sending animation finish');
        this.animationFinishCallback?.();
        this.isAllowNotifyFinish = false;
      }
      return;
    }

    // Fetch callback task via TE provided ID and execute it
    const finishCallback: (() => void) | undefined = this.finishCallbackMap.get(taskId);
    finishCallback?.();
    this.finishCallbackMap.delete(taskId);
  }

  private obtainAnimation(srcState: ScbState, dstState: ScbState): number {
    if (srcState === ScbState.LOCKSCREEN && dstState === ScbState.DESKTOP) {
      return AnimationType.LOCK_HOME;
    } else if (srcState === ScbState.DESKTOP && dstState === ScbState.LOCKSCREEN) {
      return AnimationType.HOME_LOCK;
    } else if (dstState === ScbState.SLEEP) {
      // Dynamic animation needs to be put into LOCK state, AOD_LOCK is the only reachable path.
      return AnimationType.LOCK_STILL;
    } else {
      return AnimationType.NIL;
    }
  }
}

enum AnimationType {
  AOD_HOME = 0,
  HOME_AOD = 1,
  LOCK_HOME = 2,
  LOCK_AOD = 3,
  AOD_LOCK = 4,
  AOD_STILL = 5,
  LOCK_STILL = 6,
  HOME_STILL = 7,
  HOME_LOCK = 8,
  NIL = 9,
}