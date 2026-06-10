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
import { MeshRange } from '../meshsystem/MeshSystem';

const TAG = 'BaseMeshViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 组件级别
 */
export enum ComponentLevel {
  FIXED,
  UNFIXED,
}

/**
 * 组件类型
 */
export enum ComponentType {
  CLOCK = 'clock',
  FORM_PANEL = 'formPanel',
  TOP_HEAD = 'topHead',
  CENTER_CONTENT = 'centerContent',
}

/**
 * 组件网格变化回调
 */
export interface ComponentCallback {
  onVisible?: Function;
  onChange?: Function;
  onMove?: Function;
  onRangeChange?: Function;
}

/**
 * base mesh view model
 *
 * @since 2024-03-22
 */
export class BaseMeshViewModel {
  private componentCallbackMap: Map<ComponentType | string, Array<ComponentCallback>> = new Map();

  constructor() {
  }

  /**
   * 注册组件网格变化回调
   *
   * @param componentType 组件类型
   * @param callback 网格变化时的回调
   */
  public registerComponentCallback(componentType: ComponentType | string, callback: ComponentCallback): void {
    log.showInfo('registerComponentCallback');
    let componentCallbackArray: Array<ComponentCallback> | undefined = this.componentCallbackMap.get(componentType);
    if (!componentCallbackArray) {
      componentCallbackArray = [];
    } else {
      log.showInfo('component callback array is not null');
    }
    componentCallbackArray.push(callback);
    this.componentCallbackMap.set(componentType, componentCallbackArray);
  }

  /**
   * 取消注册组件网格变化回调
   *
   * @param componentType 组件类型
   * @param callback 网格变化时的回调
   */
  public unRegisterComponentCallback(componentType: ComponentType | string, callback: ComponentCallback): void {
    log.showInfo('unRegisterComponentCallback');
    let componentCallbackArray: Array<ComponentCallback> | undefined = this.componentCallbackMap.get(componentType);
    if (!componentCallbackArray) {
      return;
    }
    let index: number = componentCallbackArray.indexOf(callback);
    if (index < 0) {
      return;
    } else {
      componentCallbackArray.splice(index, 1);
    }
    this.componentCallbackMap.set(componentType, componentCallbackArray);
  }

  /**
   * 处理网格变化的回调
   *
   * @param componentType 组件类型
   * @param meshRange 网格范围
   */
  public handleComponentCallback(componentType: string, meshRange?: MeshRange): void {
    let callbackArray: Array<ComponentCallback> | undefined = this.componentCallbackMap.get(componentType);
    if (!!callbackArray && meshRange) {
      log.showInfo(`${componentType} component callbackArray ${callbackArray?.length}`);
      callbackArray.forEach((item: ComponentCallback) => {
        item?.onRangeChange?.(meshRange);
      });
    }
  }
}