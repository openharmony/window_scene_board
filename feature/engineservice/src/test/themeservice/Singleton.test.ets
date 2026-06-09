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
import { describe, expect, it, TestType } from '@ohos/hypium';
import { Singleton } from '../../main/ets/themeservice/kit/util/Singleton';

export class SingletonTest {
}

export default function singletonTest() {
  describe('singleton', () => {
    it('singleton', TestType.FUNCTION, async () => {
      let singlonTest: SingletonTest = new SingletonTest();
      let singletone: Singleton<SingletonTest> = new Singleton<SingletonTest>(() => singlonTest);
      expect(singletone.get()).assertEqual(singlonTest);
    })
  });
}