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
import { CapsulePositionType } from '../../common/ImmersiveConstants';
import { ImmersiveCapsuleData } from './ImmersiveCapsuleData';
import { ImmersiveNtfData } from './ImmersiveNtfData';

/**
 * ntf数据后缀
 */
const SUFFIX_NTF = 'NtfData';

/**
 * cap数据后缀
 */
const SUFFIX_CAP = 'CapData';

/**
 * 默认胶囊类型列表
 */
const DEFAULT_TYPE_LIST: CapsulePositionType[] = [
  CapsulePositionType.TYPE_CONTENT,
  CapsulePositionType.TYPE_SHADOW,
  CapsulePositionType.TYPE_REMIND
];

/**
 * 胶囊数据切换监听
 */
type OnCapDataChangeListener = (type: CapsulePositionType, data?: ImmersiveNtfData) => void;

/**
 * 锁屏胶囊列表
 */
@Observed
export class ImmersiveCapsuleList {
  /**
   * 数据切换监听器
   */
  private dataListeners: Set<OnCapDataChangeListener> = new Set();

  /**
   * 添加数据切换监听器
   *
   * @param listener 监听器
   * @returns 快速移除监听
   */
  addDataChangeListener(listener: OnCapDataChangeListener): () => void {
    this.dataListeners.add(listener);
    return () => {
      this.removeDataChangeListener(listener);
    };
  }

  /**
   * 移除数据切换监听器
   *
   * @param listener 监听器
   */
  removeDataChangeListener(listener: OnCapDataChangeListener): void {
    this.dataListeners.delete(listener);
  }

  /**
   * 设置胶囊数据
   *
   * @param type 胶囊类型
   * @param data 对应类型数据
   */
  setCapsuleData(type: CapsulePositionType, data?: ImmersiveNtfData): void {
    Reflect.set(this, this.getNtfKey(type), data);
    Reflect.set(this, this.getCapKey(type), data?.capsuleData);
    // 回调数据切换
    this.dataListeners.forEach((listener) => {
      listener?.(type, data);
    });
  }

  /**
   * 获取胶囊ntf数据
   *
   * @param type 胶囊类型
   * @returns 胶囊ntf数据
   */
  getNtfData(type: CapsulePositionType): ImmersiveNtfData {
    return Reflect.get(this, this.getNtfKey(type)) as ImmersiveNtfData;
  }

  /**
   * 获取胶囊cap数据
   *
   * @param type 胶囊类型
   * @returns 胶囊cap数据
   */
  getCapData(type: CapsulePositionType): ImmersiveCapsuleData {
    return Reflect.get(this, this.getCapKey(type)) as ImmersiveCapsuleData;
  }

  /**
   * 更新胶囊列表
   *
   * @param newData 列表数据
   */
  update(newData: ImmersiveCapsuleList): void {
    if (!newData) {
      return;
    }
    DEFAULT_TYPE_LIST.forEach((type) => {
      this.setCapsuleData(type, newData.getNtfData(type));
    });
  }

  /**
   * 清空胶囊数据
   */
  clear(): void {
    DEFAULT_TYPE_LIST.forEach((type) => {
      this.setCapsuleData(type);
    });
  }

  /**
   * ntf数据键值
   *
   * @param type 胶囊类型
   * @returns 键值
   */
  private getNtfKey(type: CapsulePositionType): string {
    return `${type}${SUFFIX_NTF}`;
  }

  /**
   * cap数据键值
   *
   * @param type 胶囊类型
   * @returns 键值
   */
  private getCapKey(type: CapsulePositionType): string {
    return `${type}${SUFFIX_CAP}`;
  }
}