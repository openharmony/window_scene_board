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
import { InstanceProducer } from './Singleton';

const TAG: string = 'ServiceRegister';

/**
 * ServiceRegister类，用于注册和获取服务实例
 */
export class ServiceRegister {
  // 存储服务实例的Map，键为服务名，值为服务实例生产函数
  private readonly service: Map<string, InstanceProducer<object>> = new Map();

  /**
   * 根据服务名获取服务实例
   * @param serviceName 服务名
   * @return 返回服务实例，如果没有找到则返回undefined
   */
  public get<T extends object>(serviceName: string): T | undefined {
    let serviceProducer: InstanceProducer<object> | undefined = this.service.get(serviceName);
    if (serviceProducer) {
      return serviceProducer(serviceName) as T;
    }
    return undefined;
  }

  /**
   * 注册服务实例
   * @param serviceName 服务名
   * @param producer 服务实例生产函数
   * @return 返回当前ServiceRegister实例
   */
  public register<T>(serviceName: string, producer: InstanceProducer<T>): ServiceRegister {
    if (this.service.has(serviceName)) {
      TsLog.warning(TAG, `duplicated register service name: ${serviceName}.`);
    }
    this.service.set(serviceName, producer as InstanceProducer<object>);
    return this;
  }
}

export const serviceRegister: ServiceRegister = new ServiceRegister();

