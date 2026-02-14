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
import { TestFather3 } from './TestFather3';

export class TestGrandFather3 extends SingleBase {
  public static singleName: string = 'TestGrandFather3';
  public name: string = '';
  public id: number = 0;
  public father: TestFather3;
  private static self: TestGrandFather3;

  constructor(ctx?: SingleContext) {
    super(ctx);
    this.father = simulateSingleManager.get<TestFather3>(TestFather3, ctx);
  }

  public static getInstance(): TestGrandFather3 {
    if (!TestGrandFather3.self) {
      TestGrandFather3.self = new TestGrandFather3();
    }
    return TestGrandFather3.self;
  }
}

export let globalGrandFather3 = TestGrandFather3.getInstance();
simulateSingleManager.register(TestGrandFather3, globalGrandFather3);