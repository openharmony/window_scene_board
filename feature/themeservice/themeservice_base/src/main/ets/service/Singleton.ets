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
import { TsLog } from '../log/TsLog';

const TAG: string = 'Singleton';

/**
 * 实例生产器
 */
export type InstanceProducer<T> = (name?: string | undefined) => T;

/**
 * Singleton 类，用于创建单例对象
 */
export class Singleton<T> {
  // 用于生成单例对象的生产者
  private readonly producer: InstanceProducer<T>;
  // 存储生成的单例对象
  private mInstance: T | undefined;


  constructor(producer: InstanceProducer<T>) {
    this.producer = producer;
  }

  /**
   * 获取单例对象
   * @return 返回单例对象
   */
  public get(): T {
    if (!this.mInstance) {
      this.mInstance = this.producer();
    }
    return this.mInstance;
  }
}

/**
 * 单例生产函数（注：不支持重复调用产生单例）
 */
export function singleton<T>(): (producer: InstanceProducer<T>) => InstanceProducer<T> {
  let instance: T;
  return (producer: InstanceProducer<T>): InstanceProducer<T> => {
    return (name: string | undefined) => {
      if (!instance) {
        TsLog.debug(TAG, `Creating (${name}) Instance, the first time.`);
        instance = producer(name);
      } else {
        TsLog.debug(TAG, `Creating (${name}) Instance, Not the first time`);
      }
      return instance;
    };
  };
}