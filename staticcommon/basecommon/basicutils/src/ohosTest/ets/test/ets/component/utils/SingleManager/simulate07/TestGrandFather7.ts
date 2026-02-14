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
import { TestFather7 } from './TestFather7';

export class TestGrandFather7 extends TestFather7 {
  public static singleName: string = 'TestFather7'; // 这里故意打桩和TestFather一样，用于测试2个不同的类同keyname

  constructor(ctx?: SingleContext) {
    super(ctx);
  }
}