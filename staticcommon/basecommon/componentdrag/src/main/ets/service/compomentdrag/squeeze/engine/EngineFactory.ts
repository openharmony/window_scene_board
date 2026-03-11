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
import { Engine } from './Engine';
import { MultiItemSqueezeEngine } from './multiitem/MultiItemSqueezeEngine';
import { AutoSingleItemSqueezeEngine } from './singleitem/AutoSingleItemSqueezeEngine';
import { BackwardSingleItemSqueezeEngine } from './singleitem/BackwardSingleItemSqueezeEngine';
import { ForwardSingleItemSqueezeEngine } from './singleitem/ForwardSingleItemSqueezeEngine';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SqueezeEngineType } from '../../common/type/SqueezeTypes';

const TAG = 'EngineFactory';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.LM, TAG);

/**
 * 引擎策略工厂
 *
 * @since 2024/04/28
 */
export class EngineFactory {
  private static strategies: Map<SqueezeEngineType, Engine> = new Map();

  /**
   * 注册挤位引擎
   *
   * @param type 挤位引擎类型
   * @param engine 挤位引擎实例
   */
  public static register(type: SqueezeEngineType, engine: Engine): void {
    log.showInfo('EngineFactory, register');
    if (this.strategies.has(type)) {
      return;
    }
    this.strategies.set(type, engine);
  }

  /**
   * 获取挤位引擎实例
   *
   * @param type 挤位引擎类型
   * @returns 挤位引擎实例
   */
  public static getEngine(type: SqueezeEngineType): Engine {
    return this.strategies.get(type);
  }
}

// 添加新的引擎时，需要在该类里注册；如果在各自的引擎类里注册，会导致注册失败
EngineFactory.register(SqueezeEngineType.MULTI_ITEM_SQUEEZE, new MultiItemSqueezeEngine());
EngineFactory.register(SqueezeEngineType.AUTO_SINGLE_ITEM_SQUEEZE, new AutoSingleItemSqueezeEngine());
EngineFactory.register(SqueezeEngineType.BACKWARD_SINGLE_ITEM_SQUEEZE, new BackwardSingleItemSqueezeEngine());
EngineFactory.register(SqueezeEngineType.FORWARD_SINGLE_ITEM_SQUEEZE, new ForwardSingleItemSqueezeEngine());