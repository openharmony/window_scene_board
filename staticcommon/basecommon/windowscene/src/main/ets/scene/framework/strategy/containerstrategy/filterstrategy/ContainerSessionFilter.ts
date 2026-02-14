/*
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

import { FoldPhoneTypeValue } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { SCBSceneContainerSessionArray } from '../../../../session/SCBSceneContainerSession';
import { SinglePocketFilterStrategy } from './SinglePocketFilterStrategy';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';

/**
 * 定义策略接口
 */
export interface IFilterStrategy {
  doFilter(containerSessionList: SCBSceneContainerSessionArray): SCBSceneContainerSessionArray;
}

/**
 * 窗口容器过滤器
 */
export class ContainerSessionFilter {
  private strategyMap: Map<FoldPhoneTypeValue, IFilterStrategy> = new Map();

  public static getInstance(): ContainerSessionFilter {
    if (!globalThis.ContainerSessionFilter) {
      globalThis.ContainerSessionFilter = new ContainerSessionFilter();
    }
    return globalThis.ContainerSessionFilter;
  }

  constructor() {
  }

  public doFilter(deviceType: FoldPhoneTypeValue,
    containerSessionList: SCBSceneContainerSessionArray): SCBSceneContainerSessionArray {
    let filterStrategy = this.strategyMap.get(deviceType);
    if (filterStrategy) {
      return filterStrategy.doFilter(containerSessionList);
    } else {
      return containerSessionList;
    }
  }
}
