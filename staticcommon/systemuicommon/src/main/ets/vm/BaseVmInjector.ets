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

import { LogDomain, Logger } from '@ohos/basicutils';
import { SystemUIUseScene } from '../constants/SystemuiConstants';
import { BaseVm } from './BaseVm';
import { IBaseVmInjector } from './IBaseVmInjector';
import { SystemUIColorVm } from './SystemUIColorVm';

const TAG = 'BaseVmInjector';
const log = Logger.getLogHelper(LogDomain.SYS_UI);
const VM_LEAK_CHECK_INTERVAL = 1000;
const VM_DELETE_TIMEOUT = 3000;

export abstract class BaseVmInjector implements IBaseVmInjector {
  protected vmMap: Map<string, Object> = new Map();

  /**
   * 是否启用VM延迟删除，延迟删除会给VM一段缓存时间，等时间结束后再删除，解决VM在删除后被异步场景（如动画过程）获取的问题
   */
  protected enableDelayDeleteVm = false;
  private deleteVmRecord: Map<string, number> = new Map();

  /**
   * 使用场景
   */
  public abstract readonly scene: SystemUIUseScene;

  constructor() {
    Promise.resolve().then(() => {
      if (this.enableDelayDeleteVm) {
        this.delayDeleteVm();
      }
    });
  }

  /**
   * 获取颜色相关的VM
   * @returns
   */
  public getColorVm(): SystemUIColorVm {
    return SystemUIColorVm.instance;
  }

  /**
   * 获取VM实例，如果VM实例不存在则创建
   * @param key VM实例的唯一标识
   * @param createVm
   * @returns
   */
  protected getVm<T>(key: string, createVm: () => T): T {
    let vm = this.vmMap.get(key);
    if (!vm) {
      vm = createVm() as Object;
      this.onCreateVm(vm);
      this.vmMap.set(key, vm);
    }
    return vm as T;
  }

  /**
   * 获取缓存的VM实例
   * @param key
   * @returns
   */
  protected getCacheVm<T>(key: string): T | undefined {
    return this.vmMap.get(key) as T;
  }

  /**
   * 遍历VM
   * @param callback
   */
  protected foreachVm(callback: (vm: Object, key: string) => void): void {
    this.vmMap.forEach(callback);
  }

  /**
   * 判断当前map中是否存在某个vm
   * @param key VM实例的唯一标识
   * @returns boolean
   */
  protected hasVm(key: string): boolean {
    return this.vmMap.has(key);
  }

  /**
   * 保存vm实例
   * @param key VM实例的唯一标识
   * @param key 更新的VM实例
   */
  protected setVm(key: string, vm: Object): void {
    this.vmMap.set(key, vm);
  }

  /**
   * 标记删除VM实例
   * @param key
   */
  protected deleteVm(key: string): void {
    const vm = this.vmMap.get(key);
    if (!vm) {
      return;
    }
    this.vmMap.delete(key);
    if (this.enableDelayDeleteVm) {
      this.deleteVmRecord.set(key, Date.now());
    }
  }

  /**
   * 清空VM实例
   */
  public clearVm(): void {
    this.vmMap.clear();
    this.deleteVmRecord.clear();
  }

  /**
   * 给一个字符串id拼接场景前缀
   * @param id
   * @returns
   */
  public getId(id: string): string {
    return `[${this.scene}]${id}`;
  }

  /**
   * 判断ID是否为当前VmInjector场景
   * @param id
   * @returns
   */
  protected isIdInScene(id: string): boolean {
    return id.startsWith(`[${this.scene}]`);
  }

  /**
   * 删除标记的VM
   */
  protected delayDeleteVm(): void {
    setTimeout(() => {
      const now = Date.now();
      this.vmMap.forEach((vm, key) => {
        if (!(vm instanceof BaseVm)) {
          return;
        }
        const isPossibleLeak = this.isVmPossibleLeak(vm);
        const time = this.deleteVmRecord.get(key);
        if (time && now - time >= VM_DELETE_TIMEOUT && isPossibleLeak) {
          log.showInfo(TAG, `Delete delay vm: [${this.scene}]${key}`);
          this.deleteLeakVm(key, vm);
        } else if (!time && isPossibleLeak) {
          // VM在删除后可能存在短暂泄漏的情况，累计多次才算真正的泄漏
          if (++vm.possibleLeakCount * VM_LEAK_CHECK_INTERVAL > VM_DELETE_TIMEOUT) {
            log.showWarn(TAG, `Vm is possible leak: [${this.scene}]${key}`);
            this.deleteLeakVm(key, vm);
          }
        }
      });

      // 删除过期的数据
      this.deleteVmRecord.forEach((time, key) => {
        if (now - time >= VM_DELETE_TIMEOUT && !this.vmMap.has(key)) {
          this.deleteVmRecord.delete(key);
        }
      });

      this.delayDeleteVm();
    }, VM_LEAK_CHECK_INTERVAL);
  }

  private deleteLeakVm(key: string, vm: BaseVm<Object>): void {
    try {
      this.vmMap.delete(key);
      vm.destroy();
    } catch (e) {
      log.showWarn(TAG, `Delete leak vm for [${this.scene}]${key} error:`, e);
    }
  }

  /**
   * VM是否可能泄漏
   * @param vm
   * @returns
   */
  protected isVmPossibleLeak(vm: Object): boolean {
    return false;
  }

  /**
   * VM首次创建回调
   * @param vm
   * @returns
   */
  protected onCreateVm(vm: Object): void {  }
}