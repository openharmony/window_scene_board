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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, } from '@ohos/hypium';
import { ExtraData } from '@ohos/launchercommon/src/main/ets/aisuggestion/ExtraData';
import { LauncherCardInfo } from '../../../../../../main/ets/default/bean/LauncherCardInfo';
import { OperateFormStackDetails } from '../../../../../../main/ets/default/command/OperateFormStackDetails';
import { OperateFormStackHelper } from '../../../../../../main/ets/default/manager/OperateFormStackHelper';

export function OperateFormStackHelperTest() {
  describe('OperateFormStackHelperTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('getInstance', 0, (): void => {
      let helper: OperateFormStackHelper = OperateFormStackHelper.getInstance();
      helper.setFormStackLength('123_0', {} as OperateFormStackDetails);
      helper.onPortfolioCardAddToFormStack({} as ExtraData);
      helper.onPortfolioCardAddToFormStack({ commandId: '777' } as ExtraData);
      helper.onPortfolioCardAddToFormStack({ commandId: '123', commandType: 0 } as ExtraData);
    });

    it('getCachePortfolioCardInfo', 0, (): void => {
      let helper: OperateFormStackHelper = OperateFormStackHelper.getInstance();
      helper.setCachePortfolioCardInfo('123', { recId: '123456' } as LauncherCardInfo);
      let ret = helper.getCachePortfolioCardInfo('777');
      expect(ret).assertNull();
      ret = helper.getCachePortfolioCardInfo('123');
      expect(ret?.recId).assertEqual('123456');
    });
  });
}