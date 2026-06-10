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

import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { NtfListVm } from './NtfListVm'

const TAG: string = 'NtfListVmFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 维护通知列表VM，用于vm共享
 */
class NtfListVmHolder {
  private ntfVmMap: Map<number, NtfListVm> = new Map();

  private callbacks: Set<NtfListVmCallback> = new Set();

  /**
   * 获取实例
   *
   * @param type 通知面板类型
   */
  getNtfListVmInstance(type: number): NtfListVm {
    log.showInfo('getNtfListVmInstance, type=' + type);
    return this.ntfVmMap.get(type) as NtfListVm;
  }

  /**
   * 添加或更新实例
   *
   * @param type 通知面板类型
   * @param ntfListVm vm实例
   */
  setNtfListVm(type: number, ntfListVm: NtfListVm) : void {
    log.showInfo('setNtfListVm, type=' + type);
    this.ntfVmMap.set(type, ntfListVm);
    this.callbacks.forEach((callback) => callback?.onNtfListVmChange(type, ntfListVm));
  }

  /**
   * 删除指定面板类型的实例
   *
   * @param type 面板类型
   */
  deleteNtfListVm(type:number) :void {
    this.ntfVmMap.delete(type);
  }

  registerNtfListVmCallback(callback: NtfListVmCallback): void {
    this.callbacks.add(callback);
  }

  unregisterNtfListVmCallback(callback: NtfListVmCallback): void {
    this.callbacks.delete(callback);
  }
}

let NTF_LIST_VM_HOLDER: NtfListVmHolder = SingletonHelper.getInstance(NtfListVmHolder, TAG);
export default NTF_LIST_VM_HOLDER as NtfListVmHolder;

/**
 * ntfListVm交互接口
 */
export interface NtfListVmCallback {
  /**
   * update when vm changed
   *
   * @param ntfListVm
   */
  onNtfListVmChange(type: number, ntfListVm: NtfListVm): void;
}