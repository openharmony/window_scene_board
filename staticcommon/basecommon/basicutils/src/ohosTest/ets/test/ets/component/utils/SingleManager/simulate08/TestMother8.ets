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
import { simulateNotInitialedSingleInstance } from '../SimulateNotInitialedSingleInstance';
import { TestChild8 } from './TestChild8';

export class TestMother8 extends SingleBase {
  public static singleName: string = 'TestMother8';
  public child: TestChild8;
  private static self: TestMother8;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.child = simulateNotInitialedSingleInstance.get<TestChild8>(TestChild8, this.singleContext);
  }

  public static getInstance(): TestMother8 {
    if (!TestMother8.self) {
      TestMother8.self = new TestMother8();
      simulateNotInitialedSingleInstance.register(TestMother8, TestMother8.self);
    }
    return TestMother8.self;
  }
}

export let testMother8 = TestMother8.getInstance();