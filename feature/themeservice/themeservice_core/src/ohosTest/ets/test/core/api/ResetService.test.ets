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
import { FileUtil, StringUtils } from '@ohos/themeservicebase/Index';
import { RemoteCode } from '@ohos/themeservicebase/src/main/ets/remote/RemoteCode';
import { ActivatedThemeUtil } from '../../../../../main/ets/util/ActivatedThemeUtil';
import { TSOhosTestManger } from '../../../core/TSOhosTestManger';
import { AssertUtils } from '../../../core/util/AssertUtils';

const TAG: string = 'ResetService.test';

export default function ResetServiceTest() {
  describe('resetServiceTest_Illegal_caller', () => {
    it('factoryReset', TestType.SAFETY, async () => {
      await AssertUtils.expectErrorCode(() => TSOhosTestManger.getTsCoreRemoteApi().factoryReset(),
        RemoteCode.ERR_ILLEGAL_CALLER);
    })
  })
  describe('resetServiceTest', () => {
    it('test02_success', 0, async () => {
      await TSOhosTestManger.retailAppCallApi(api => api.factoryReset());
      let activatedDescription: string = ActivatedThemeUtil.getActivatedThemePath() + 'system/description.json';
      let content: string = await FileUtil.readFileContent(activatedDescription);
      let hasThemeId: boolean = !StringUtils.isEmpty(content);
      expect(hasThemeId).assertTrue();
    })
  })
}


