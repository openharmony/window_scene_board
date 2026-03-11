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

// 适配点1：需要继承SingleBase
export class TestChild1 extends SingleBase {
  // 适配点2： 定义在单例管理模块中的类型名称，即M的行号。
  public static singleName: string = 'TestChild1';
  public name: string = '';
  public id: number = 0;
  private static self: TestChild1;
  public static getInstance(): TestChild1 {
    if (!TestChild1.self) {
      TestChild1.self = new TestChild1();
    }
    return TestChild1.self;
  }
  // 适配点3： constructor需要传入SingleContext，并且传给父类。
  constructor(ctx?: SingleContext) {
    super(ctx);
  }
}

export let globalTestChild1 = TestChild1.getInstance();
// 适配点4：对于有上一行export创建的单例的场景，这里就把单例实例注册到类型的第一个实例位置上，兼容watch、tv等产品
simulateSingleManager.register(TestChild1, globalTestChild1);
