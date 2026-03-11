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

import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ContainerDataCategory, SCBSceneContainerSessionArray } from '../../../../../TsIndex';
import { IFilterStrategy } from './ContainerSessionFilter';

const TAG = 'SinglePocketFilterStrategy';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

/**
 * 小折叠形态产品过滤策略
 */
export class SinglePocketFilterStrategy implements IFilterStrategy {

  public static getInstance(): SinglePocketFilterStrategy {
    if (!globalThis.SinglePocketFilterStrategy) {
      globalThis.SinglePocketFilterStrategy = new SinglePocketFilterStrategy();
    }
    return globalThis.SinglePocketFilterStrategy;
  }

  doFilter(containerSessionList: SCBSceneContainerSessionArray): SCBSceneContainerSessionArray {
    let newArray: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let deviceScene = DeviceHelper.getCurrentDeviceScene();
    log.showInfo(`SinglePocketFilterStrategy deviceScene:${deviceScene}`);
    containerSessionList.forEach((item) => {
      // 根据lastUsedPosition来决定是否显示在内/外屏
      if (item?.getData(ContainerDataCategory.BASIC)?.lastUsedPosition === deviceScene) {
        newArray.push(item);
      }
    });
    return newArray;
  }
}