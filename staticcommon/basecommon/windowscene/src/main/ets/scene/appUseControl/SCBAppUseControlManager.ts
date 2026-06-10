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

import { SCBSceneMode } from '../session/SCBSceneInfo';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'SCBAppUseControlManager';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

// 管控控件构造参数定义
export interface ComponentBuilderParam {
  loadBundleName: string;
  loadAbilityName: string;
  useControlMainMaskBuilder: () => void;
  useControlRecentMaskBuilder: () => void;
  isNeedShowUseControlComponent: Function;
}

// 管控类型定义
export enum ControlType {
  APP_LOCK = 1,
  PARENT_CONTROL,
  DLP, // 防窥保护
  PRIVACY_WINDOW,
  APP_PROJECTION,
}

// 管控应用信息定义
export interface ControlAppInfo {
  bundleName: string;
  appIndex: number;
  isNeedControl: boolean;
  isControlRecentOnly: boolean;
}

export class SCBAppUseControlManager {
  private componentBuilderParamMap: Map<ControlType, ComponentBuilderParam> = new Map();
  private controlTypeMap: Map<string, ControlType[]> = new Map(); // key is bundleName#appIndex
  private appControlRecentMap: Map<string, Map<ControlType, boolean>> = new Map(); // key is bundleName#appIndex
  private appUseControlWindowModeCallBackMap: Map<number, Function> = new Map();

  public static getInstance(): SCBAppUseControlManager {
    if (!globalThis.SCBAppUseControlManagerInstance) {
      globalThis.SCBAppUseControlManagerInstance = new SCBAppUseControlManager();
    }
    return globalThis.SCBAppUseControlManagerInstance;
  }

  public registerComponentBuilderParam(type: ControlType, builderParam: ComponentBuilderParam): void {
    log.showInfo(`[UseControl]Register builder param, ${type} ${builderParam?.loadBundleName} ${builderParam?.loadAbilityName}`);
    this.componentBuilderParamMap.set(type, builderParam);
  }

  public getComponentBuilderParamByControlType(type: ControlType): ComponentBuilderParam | undefined {
    return this.componentBuilderParamMap.get(type);
  }

  public updateControlAppInfo(controlType: ControlType, controlAppInfos: ControlAppInfo[]): void {
    for (let controlAppInfo of controlAppInfos) {
      let key = `${controlAppInfo.bundleName}#${controlAppInfo.appIndex}`;
      let controlTypeList = this.controlTypeMap.get(key) ?? [];
      let index = controlTypeList.indexOf(controlType);
      if (controlAppInfo.isNeedControl && index < 0) {
        controlTypeList.push(controlType);
        controlTypeList.sort();
        this.controlTypeMap.set(key, controlTypeList);
        log.showInfo(`[UseControl]Add use control, app:${key} type:${controlType}`);
      } else if (!controlAppInfo.isNeedControl && index >= 0) {
        controlTypeList.splice(index, 1);
        log.showInfo(`[UseControl]Remove use control, app:${key} type:${controlType}`);
      }
      this.updateControlRecent(controlType, controlAppInfo);
    }
    log.showDebug(`[UseControl]updateControlAppInfo, controlTypeMap:${[...this.controlTypeMap]}`);
  }

  public getControlType(bundleName: string, appIndex: number): ReadonlyArray<ControlType> {
    return this.controlTypeMap.get(`${bundleName}#${appIndex}`) ?? [];
  }

  public getControlTypeToControlRecentMap(bundleName: string, appIndex: number): ReadonlyMap<ControlType, boolean> {
    return this.appControlRecentMap.get(`${bundleName}#${appIndex}`) ?? new Map();
  }

  private updateControlRecent(controlType: ControlType, controlAppInfo: ControlAppInfo): void {
    let key = `${controlAppInfo.bundleName}#${controlAppInfo.appIndex}`;
    let controlTypeToControlRecentMap = this.appControlRecentMap.get(key) ?? new Map();
    if (controlAppInfo.isNeedControl) {
      controlTypeToControlRecentMap.set(controlType, controlAppInfo.isControlRecentOnly);
      this.appControlRecentMap.set(key, controlTypeToControlRecentMap);
      log.showInfo(`[UseControl]Add or update controlFlag, app:${key} type:${controlType} isControlRecentOnly: ${controlAppInfo.isControlRecentOnly}`);
    } else {
      controlTypeToControlRecentMap.delete(controlType);
      if (controlTypeToControlRecentMap.size === 0) {
        this.appControlRecentMap.delete(key);
      }
      log.showInfo(`[UseControl]Remove controlFlag, app:${key} type:${controlType} isControlRecentOnly: ${controlAppInfo.isControlRecentOnly}`);
    }
  }

  /**
   * notify session manager that window mode has updated
   * @param windowMode the windowMode of corresponding SceneSession
   * @param persistentId the persistentId of the session which windowMode changed
   */
  public notifyUpdateWindowMode(persistentId: number, windowMode: SCBSceneMode): void {
    this.appUseControlWindowModeCallBackMap.get(persistentId)?.(windowMode);
  }

  public registerAppUseControlWindowModeCallBack(persistentId: number, callback: (type: SCBSceneMode) => void): void {
    this.appUseControlWindowModeCallBackMap.set(persistentId, callback);
  }

  public unRegisterAppUseControlWindowModeCallBack(persistentId: number): void {
    this.appUseControlWindowModeCallBackMap.delete(persistentId);
  }
}