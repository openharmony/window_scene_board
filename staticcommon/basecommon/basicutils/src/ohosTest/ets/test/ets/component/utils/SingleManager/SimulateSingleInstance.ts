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
import { SingleContext, SingleManager } from '../../../../../../../main/ets/utils/SingleManager';

/**
 * 专门为了测试DT继承的一个SingleManager，避免影响SCB主进程
 */
export class SimulateSingleManager extends SingleManager {
  private static instance: SimulateSingleManager;

  public static getInstance(): SimulateSingleManager {
    if (!SimulateSingleManager.instance) {
      SimulateSingleManager.instance = new SimulateSingleManager();
    }

    return SimulateSingleManager.instance;
  }
}

export let simulateSingleManager = SimulateSingleManager.getInstance();
simulateSingleManager.initial(2, (ctx: SingleContext) => {},
  (ctx: SingleContext) => { return ctx.extendScreenId ?? 0; });