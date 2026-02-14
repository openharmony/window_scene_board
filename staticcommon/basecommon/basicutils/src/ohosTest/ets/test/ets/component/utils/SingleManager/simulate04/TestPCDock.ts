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
import { SingleContext } from '../../../../../../../../main/ets/utils/SingleManager';
import { simulateSingleManager } from '../SimulateSingleInstance';
import { TestData4 } from './TestData4';
import { TestDock4 } from './TestDock';

// 适配点1：需要继承SingleBase
export class TestPCDock4 extends TestDock4 {
  // 适配点2： 定义在单例管理模块中的类型名称，为了让TestPCDock4和TestDock4注册为同一个实例，这里不能修改keyName
  // public static singleName: string = 'TestDock';
  private static instance: TestPCDock4;
  public name: string = '';

  // 适配点3： constructor需要传入SingleContext，并且传给父类。
  public static getInstance(ctx?: SingleContext): TestPCDock4 {
    if (!TestPCDock4.instance) {
      TestPCDock4.instance = new TestPCDock4(ctx);
    }
    return TestPCDock4.instance;
  }
  // 适配点3： constructor需要传入SingleContext，并且传给父类。
  constructor(ctx?: SingleContext) {
    super(ctx);
    this.data = simulateSingleManager.get<TestData4>(TestData4, ctx);
  }
}

export let globalTestPCDock4 = TestPCDock4.getInstance({ extendScreenId: 1 });
// 适配点4：对于有上一行export创建的单例的场景，给定SingleContext，把PC单例实例注册到类型的第二个实例位置上
simulateSingleManager.register(TestDock4, globalTestPCDock4, { extendScreenId: 1 });