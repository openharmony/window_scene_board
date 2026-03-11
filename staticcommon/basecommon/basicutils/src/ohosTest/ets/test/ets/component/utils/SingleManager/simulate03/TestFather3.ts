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
import { TestChild3 } from './TestChild3';

export class TestFather3 extends SingleBase {
  public static singleName: string = 'TestFather3';
  public name: string = '';
  public id: number = 0;
  public child: TestChild3;
  private static self: TestFather3;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.child = simulateSingleManager.get<TestChild3>(TestChild3, this.singleContext);
  }

  public static getInstance(): TestFather3 {
    if (!TestFather3.self) {
      TestFather3.self = simulateSingleManager.get<TestFather3>(TestFather3);
    }
    return TestFather3.self;
  }
}