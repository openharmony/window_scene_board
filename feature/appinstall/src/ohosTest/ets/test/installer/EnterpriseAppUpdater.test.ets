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


import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  it,
} from '@ohos/hypium';
import { BaseAppInstaller } from '../../../../main/ets/default/installer/BaseAppInstaller';
import { EnterpriseAppUpdater } from '../../../../main/ets/default/installer/EnterpriseAppUpdater';

export default function EnterpriseAppUpdaterTest() {
  describe('EnterpriseAppUpdaterTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('code501', 0, () => {
      let installer: BaseAppInstaller = new EnterpriseAppUpdater();
      installer.getInstallType();
    })

  })
}