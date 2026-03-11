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
import { TestChild2 } from './TestChild2';

// 适配点1：需要继承SingleBase
export class TestFather2 extends SingleBase {
  // 适配点2： 定义在单例管理模块中的类型名称，即M的行号。
  public static singleName: string = 'TestFather2';
  public name: string = '';
  public id: number = 0;
  public child: TestChild2;
  private static self: TestFather2;

  // 适配点3： constructor需要传入SingleContext，并且传给父类。
  constructor(ctx?: SingleContext) {
    super(ctx);
    this.child = simulateSingleManager.get<TestChild2>(TestChild2, this.singleContext);
  }

  public static getInstance(): TestFather2 {
    if (!TestFather2.self) {
      // 适配点4：对于没有export创建的单例的场景:
      // 为了兼容Watch等未整改的产品继续使用getInstance方法和SingleManager.get方法获取到相同实例
      // 需要在此处将自身实例注册到SingleManager中
      TestFather2.self = simulateSingleManager.get<TestFather2>(TestFather2);
    }
    return TestFather2.self;
  }
}