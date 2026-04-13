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
import { describe, expect, it, TestType } from '@ohos/hypium';
import { InstanceProducer, singleton, Singleton, TsLog } from '@ohos/themeservicebase/Index';

export class TestBean {
}

export default function SingletonTest() {
  describe('SingletonTest', () => {
    it('test01_singleton_class', TestType.FUNCTION, async () => {
      let time: number = 0;
      let testBean: TestBean = new TestBean();
      let singleton: Singleton<TestBean> = new Singleton<TestBean>(() => {
        TsLog.info("SingletonTest", "SingletonClass Create");
        time++;
        return testBean;
      });
      expect(singleton.get()).assertEqual(testBean);
      expect(singleton.get()).assertEqual(testBean);
      expect(singleton.get()).assertEqual(testBean);
      expect(singleton.get()).assertEqual(testBean);
      expect(singleton.get()).assertEqual(testBean);
      expect(time).assertEqual(1);
    })

    it('test01_singleton_func', TestType.FUNCTION, async () => {
      let time: number = 0;
      let testBean: TestBean = new TestBean();
      let producer: InstanceProducer<TestBean> = singleton<TestBean>()(() => {
        TsLog.info("SingletonTest", "SingletonFunc create");
        time++;
        return testBean;
      });
      expect(producer()).assertEqual(testBean);
      expect(producer()).assertEqual(testBean);
      expect(producer()).assertEqual(testBean);
      expect(producer()).assertEqual(testBean);
      expect(producer()).assertEqual(testBean);
      expect(time).assertEqual(1);
    })
  });
}