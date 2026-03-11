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
import { SingleBase, SingleContext } from '../../../../../../../../main/ets/utils/SingleManager';
import { simulateSingleManager } from '../SimulateSingleInstance';

export class TestChild3 extends SingleBase {
  public static singleName: string = 'TestChild3';
  public name: string = '';
  public id: number = 0;
  private static self: TestChild3;
  public static getInstance(): TestChild3 {
    if (!TestChild3.self) {
      TestChild3.self = new TestChild3();
    }
    return TestChild3.self;
  }
  constructor(ctx?: SingleContext) {
    super(ctx);
  }
}

export let globalTestChild1 = TestChild3.getInstance();
simulateSingleManager.register(TestChild3, globalTestChild1);
