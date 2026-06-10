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
import { serviceRegister, singleton } from '@ohos/themeservicebase/Index';

interface ServiceTestApi {
  getId(): number;
}

class ServiceTestApiImpl implements ServiceTestApi {
  private readonly id: number;

  constructor(id: number) {
    this.id = id;
  }

  getId(): number {
    return this.id;
  }
}

const ServiceName1: string = 'ServiceName1';
const ServiceName2: string = 'ServiceName2';
const ServiceName3: string = 'ServiceName3';

export default function ServiceRegisterTest() {
  describe('ServiceRegisterTest', () => {
    it('test01_singletonInstance', TestType.FUNCTION, () => {
      let createCount: number = 1;
      serviceRegister.register<ServiceTestApiImpl>(ServiceName1, singleton<ServiceTestApiImpl>()(() => {
        createCount++;
        return new ServiceTestApiImpl(createCount);
      }));
      expect(serviceRegister.get<ServiceTestApi>(ServiceName1)?.getId()).assertEqual(2);
      expect(serviceRegister.get<ServiceTestApi>(ServiceName1)?.getId()).assertEqual(2);
      expect(serviceRegister.get<ServiceTestApi>(ServiceName1)?.getId()).assertEqual(2);
      expect(serviceRegister.get<ServiceTestApi>(ServiceName1)?.getId()).assertEqual(2);
    })

    it('test02_MultipleInstance', TestType.FUNCTION, () => {
      let createCount: number = 1;
      serviceRegister.register(ServiceName2, (() => {
        createCount++;
        return new ServiceTestApiImpl(createCount);
      }));
      expect(serviceRegister.get<ServiceTestApi>(ServiceName2)?.getId()).assertEqual(2);
      expect(serviceRegister.get<ServiceTestApi>(ServiceName2)?.getId()).assertEqual(3);
      expect(serviceRegister.get<ServiceTestApi>(ServiceName2)?.getId()).assertEqual(4);
      expect(serviceRegister.get<ServiceTestApi>(ServiceName2)?.getId()).assertEqual(5);
    })

    it('test03_Repeat', TestType.FUNCTION, () => {
      let createCount: number = 1;
      serviceRegister.register<ServiceTestApiImpl>(ServiceName1, singleton<ServiceTestApiImpl>()(() => {
        createCount++;
        return new ServiceTestApiImpl(createCount);
      }));
      serviceRegister.register(ServiceName1, (() => {
        return new ServiceTestApiImpl(1000);
      }));
      expect(serviceRegister.get<ServiceTestApi>(ServiceName1)?.getId()).assertEqual(1000);
    })

    it('test03_undefined', TestType.FUNCTION, () => {
      expect(serviceRegister.get<ServiceTestApi>(ServiceName3)).assertUndefined();
    })
  });
}