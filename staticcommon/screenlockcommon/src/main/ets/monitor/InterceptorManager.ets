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

import HashSet from '@ohos.util.HashSet';
import { LogDomain, LogHelper } from '@ohos/basicutils';

import { CommonUtil } from '../utils/CommonUtil';

export type FilterChainCallback = () => boolean;

export enum ScreenLockChain {
  REQUEST_UNLOCK_CHAIN = 'REQUEST_UNLOCK_CHAIN',
}

const TAG = 'InterceptorManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

export class InterceptorManager {
  private static instance: InterceptorManager;
  private chains: Map<string, HashSet<FilterChainCallback>> = new Map();

  private constructor() {
  }

  public static getInstance(): InterceptorManager {
    if (!InterceptorManager.instance) {
      InterceptorManager.instance = new InterceptorManager();
    }
    return InterceptorManager.instance;
  }

  public addToChain(chain: string, interceptor: FilterChainCallback) {
    log.showInfo(`add to chain [${chain}]`);
    if (!this.chains.has(chain)) {
      this.chains.set(chain, new HashSet());
    }
    const chainProcessors: HashSet<FilterChainCallback> | undefined = this.chains.get(chain);
    if (!chainProcessors?.has(interceptor)) {
      chainProcessors?.add(interceptor);
    }
    log.showInfo(`add end,chain=[${chain}] size=${chainProcessors?.length}`);
  }

  public doProcess(chain: string): boolean {
    log.showInfo(`start to process at chain ${chain}`);
    const chainProcessors: HashSet<FilterChainCallback> | undefined = this.chains.get(chain);
    if (!chainProcessors) {
      log.showInfo(`chain [${chain}] empty,no need process`);
      return true;
    }
    for (let processor of chainProcessors) {
      if (!processor()) {
        log.showInfo(`chain [${chain}] process failed`);
        return false;
      }
    }
    log.showInfo(`end to process at chain ${chain}`);
    return true;
  }
}

