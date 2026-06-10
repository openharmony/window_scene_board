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

export class TestChild8 extends SingleBase {
  public static singleName: string = 'TestChild8';
  private static self: TestChild8;

  constructor(ctx?: SingleContext) {
    super(ctx);
  }

  public static getInstance(): TestChild8 {
    if (!TestChild8.self) {
      TestChild8.self = simulateNotInitialedSingleInstance.get<TestChild8>(TestChild8);
    }
    return TestChild8.self;
  }
}