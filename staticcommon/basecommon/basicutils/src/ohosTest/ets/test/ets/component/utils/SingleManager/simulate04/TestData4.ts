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

export class TestData4 extends SingleBase {
  public static singleName: string = 'TestData4';
  private static self: TestData4;

  public static getInstance(): TestData4 {
    if (!TestData4.self) {
      TestData4.self = new TestData4();
    }
    return TestData4.self;
  }
  constructor(ctx?: SingleContext) {
    super(ctx);
  }
}

export let globalTestData4 = TestData4.getInstance();
simulateSingleManager.register(TestData4, globalTestData4);