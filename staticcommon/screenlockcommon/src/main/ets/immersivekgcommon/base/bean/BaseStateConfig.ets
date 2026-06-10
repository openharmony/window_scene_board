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
import { SizeBpSplice } from '../utils/ScreenBreakPoint';
import { IBaseState } from '../interface/IBaseState';
import { LimitMap } from '../utils/LimitMap';

const TAG = 'BaseStateConfig';
const MAX_SIZE = 100;

/**
 * 状态配置基类
 */
export class BaseStateConfig<T extends IBaseState> {
  // 断点配置集
  private readonly bpConfig: LimitMap<SizeBpSplice, T> = new LimitMap(TAG, MAX_SIZE);

  // 配置标示名
  protected readonly configName: string;

  protected constructor(name: string) {
    this.configName = name;
  }

  /**
   * 配置名
   *
   * @returns 配置名
   */
  public getConfigName(): string {
    return this.configName;
  }

  /**
   * 清空配置
   *
   * @returns 链式
   */
  public clearConfig(): BaseStateConfig<T> {
    this.bpConfig.clear();
    return this;
  }

  /**
   * 绑定断点映射状态配置
   *
   * @param bp 断点拼接
   * @param config 状态配置
   * @returns 链式
   */
  public bindBpConfig(bp: SizeBpSplice, config: T): BaseStateConfig<T> {
    this.bpConfig.set(bp, config);
    return this;
  }

  /**
   * 绑定默认状态配置
   *
   * @param config 状态配置
   * @returns 链式
   */
  public bindConfig(config: T): BaseStateConfig<T> {
    return this.bindBpConfig(SizeBpSplice.DEFAULT, config);
  }

  /**
   * 获取断点映射状态配置
   *
   * @param bp 断点拼接
   * @returns 目标状态配置
   */
  public getBpConfig(bp: SizeBpSplice): T | undefined {
    return this.bpConfig.get(bp) ?? this.bpConfig.get(SizeBpSplice.DEFAULT);
  }

  /**
   * 获取默认状态配置
   *
   * @returns 默认配置
   */
  public getConfig(): T | undefined {
    return this.getBpConfig(SizeBpSplice.DEFAULT);
  }
}