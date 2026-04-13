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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { OuterAppManager } from '../../../../../../../../launchercommon/src/main/ets/manager/OuterAppManager';

/**
 * OuterAppManager 单元测试用例
 */
export function OuterAppManagerTest() {
  describe('OuterAppManagerTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getTopPkgNameList', Level.LEVEL0, () => {
      const instance = OuterAppManager.getInstance();
      let pkgName: string[] = instance.getTopPkgNameList();
      expect(pkgName).not().assertNull();
    })

    it('test_getExperimentalPkgNameList', Level.LEVEL0, () => {
      const instance = OuterAppManager.getInstance();
      let pkgName: string[] = instance.getExperimentalPkgNameList();
      expect(pkgName).not().assertNull();
    })

    it('test_getBlockPkgNameList', Level.LEVEL0, () => {
      const instance = OuterAppManager.getInstance();
      let pkgName: string[] = instance.getBlockPkgNameList();
      expect(pkgName).not().assertNull();
    })

    it('test_getSpecialApplicationPkgList', Level.LEVEL0, () => {
      const instance = OuterAppManager.getInstance();
      let pkgName: string[] = instance.getSpecialApplicationPkgList();
      expect(pkgName).not().assertNull();
    })
  })
}