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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import { ThemeRemoteManager }
  from '@ohos/screenlockwidget/src/main/ets/common/theme/ThemeRemoteManager';
import { LockscreenConfig } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';

export default function ThemeRemoteManagerTest() {
  const mThemeRemoteManager = new ThemeRemoteManager()

  describe('ThemeRemoteManagerTest', (): void => {

    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {

    });

    afterAll((): void => {

    });

    it('test_setCurrentThemeCfg', TestConst.TEST_LEVEL, (): void => {
      mThemeRemoteManager.setCurrentThemeCfg({} as LockscreenConfig);
      expect(true).assertTrue();
    });

    it('test_setMultiSceneThemeCfg', TestConst.TEST_LEVEL, (): void => {
      const lockscreenConfigs = new Map<string, LockscreenConfig>([
        ['1', {} as LockscreenConfig],
        ['2', {} as LockscreenConfig],
      ]);
      mThemeRemoteManager.setMultiSceneThemeCfg(lockscreenConfigs);
      expect(true).assertTrue();
    });
  });
}