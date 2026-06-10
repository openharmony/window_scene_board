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
import { describe, expect, it, Level } from '@ohos/hypium';
import { ThemeResource } from '@ohos/themeservice_inner_api/Index';
import { TsLog } from '@ohos/themeservicebase/Index';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const TAG: string = 'DeleteOnlineTheme.test';

export default function DeleteOnlineThemeTest() {
  describe('DeleteOnlineThemeTest', () => {
    it('test00_Illegal_caller', Level.LEVEL0, async () => {
      await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi().deleteTheme([]),
        RemoteCode.ERR_ILLEGAL_CALLER);
    })

    // 测试入参为空
    it('deleteOnlineTheme_null', 0, async () => {
      let result: boolean = await TSOhosTestManger.hwAppCallApi(api => api.deleteTheme([]));
      TsLog.debug(TAG, `deleteOnlineTheme_null result: ${result}`);
      expect(result).assertFalse();
    });

    // 测试删除theme类型资源
    it('deleteOnlineTheme_theme', 0, async () => {
      let themeResource: ThemeResource = new ThemeResource('0', 'theme');
      let aodResource: ThemeResource = new ThemeResource('0', 'aod');
      let result: boolean = await TSOhosTestManger.hwAppCallApi(api => api.deleteTheme([themeResource, aodResource]));
      TsLog.debug(TAG, `deleteOnlineTheme_theme result: ${result}`);
      expect(result).assertTrue();
    });
  })
}