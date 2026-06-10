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

import { ImmComAnimScene } from '../../../common/constants/ImmComConst';
import { ImmBaseAnimConfig } from './ImmBaseAnimConfig';
import { ImmComPtConfig } from './ImmComPtConfig';

/**
 * 沉浸模块混合动效配置
 */
export class ImmComAnimConfig extends ImmBaseAnimConfig<ImmComPtConfig, ImmComAnimConfig> {
  protected getThis(): ImmComAnimConfig {
    return this;
  }

  /**
   * 混合动效配置实例
   *
   * @param animScene 动效场景
   * @returns 实例
   */
  public static wrap(animScene: ImmComAnimScene): ImmComAnimConfig {
    return new ImmComAnimConfig(animScene);
  }
}