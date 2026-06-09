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
import { SingleBase, SingleContext } from '../../../../../../../../main/ets/utils/SingleManager';
import { simulateSingleManager } from '../SimulateSingleInstance';
import { TestData4 } from './TestData4';

export class TestDock4 extends SingleBase {
  public static singleName: string = 'TestDock4';
  private static self: TestDock4;
  protected data: TestData4;
  public name: string = '';

  public static getInstance(): TestDock4 {
    if (!TestDock4.self) {
      TestDock4.self = new TestDock4();
    }
    return TestDock4.self;
  }
  constructor(ctx?: SingleContext) {
    super(ctx);
    this.data = simulateSingleManager.get<TestData4>(TestData4, ctx);
  }

  public getData(): TestData4 {
    return this.data;
  }
}

export let globalTestDock4 = TestDock4.getInstance();
simulateSingleManager.register(TestDock4, globalTestDock4);