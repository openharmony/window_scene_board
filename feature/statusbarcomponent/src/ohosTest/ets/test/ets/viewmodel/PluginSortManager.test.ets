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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import pluginSortManager from '../../../../../main/ets/viewmodel/PluginSortManager'


export function PluginSortManagerTest() {
  describe('PluginSortManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getDynamicSortPlugins', Level.LEVEL1, (): void => {
      let array: Array<string> = pluginSortManager.getDynamicSortPlugins();
      expect(array !== undefined).assertTrue();
    });

    it('test_pushDynamicSortPlugin', Level.LEVEL1, (): void => {
      pluginSortManager.pushDynamicSortPlugin('testString');
      let arrayRes: Array<string> = pluginSortManager.getDynamicSortPlugins();
      expect(arrayRes !== undefined && arrayRes.indexOf('testString') >= 0).assertTrue();
    });

    it('test_deleteDynamicSortPlugin', Level.LEVEL1, (): void => {
      pluginSortManager.pushDynamicSortPlugin('testString');
      pluginSortManager.deleteDynamicSortPlugin('testString');
      let arrayRes: Array<string> = pluginSortManager.getDynamicSortPlugins();
      expect(arrayRes !== undefined && arrayRes.indexOf('testString') < 0).assertTrue();
    });
  });
}