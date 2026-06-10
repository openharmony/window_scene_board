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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import {
  ScreenLockShortcutLayoutConfig
} from '../../../../../../main/ets/shortcut/ScreenLockShortcutLayoutConfig';
import { CommonConstants } from '@ohos/launchercommon';
import type {
  ScreenLockShortcutItemInfo
} from '../../../../../../main/ets/shortcut/ScreenLockShortcutItemInfo';
import { GlobalContext } from '@ohos/frameworkwrapper';

export default function ScreenLockShortcutLayoutConfigTest() {

  describe('ScreenLockShortcutLayoutConfigTest', (): void => {
    let shortcutLayoutInfo: Array<ScreenLockShortcutItemInfo>;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_setScreenLockAuthState_return', 0, (): void => {
      let result = ScreenLockShortcutLayoutConfig.getInstance();
      expect(result).assertEqual(
        GlobalContext.getInstance().getObject('ScreenLockShortcutLayoutConfig') as ScreenLockShortcutLayoutConfig);
    })

    it('test_initConfig_return', 0, (): void => {
      ScreenLockShortcutLayoutConfig.getInstance().initConfig();
      let result = ScreenLockShortcutLayoutConfig.getInstance().getConfigLevel();
      expect(result).assertEqual(CommonConstants.LAYOUT_CONFIG_LEVEL_COMMON);
    })

    it('test_getConfigType_return', 0, (): void => {
      let result = ScreenLockShortcutLayoutConfig.getInstance().getConfigType();
      expect(result).assertEqual(CommonConstants.LAYOUT_CONFIG_TYPE_FUNCTION);
    })

    it('test_getConfigName_return', 0, (): void => {
      let result = ScreenLockShortcutLayoutConfig.getInstance().getConfigName();
      ScreenLockShortcutLayoutConfig.getInstance().updateShortcutLayoutInfo(shortcutLayoutInfo);
      ScreenLockShortcutLayoutConfig.getInstance().getShortcutLayoutInfo();
      expect(result).assertEqual(ScreenLockShortcutLayoutConfig.SCREEN_LOCK_SHORTCUT_LAYOUT_INFO);
    })

  })
}