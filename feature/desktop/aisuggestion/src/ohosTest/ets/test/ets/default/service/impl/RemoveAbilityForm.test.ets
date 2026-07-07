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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium';
import { RemoveAbilityForm } from '../../../../../../../main/ets/default/service/impl/RemoveAbilityForm';
import { FormModel } from '@ohos/launchercommon';
import { RemoveFormInfo } from '../../../../../../../main/ets/default/service/entity/RemoveFormInfo';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';

export function RemoveAbilityFormTest() {
  describe('RemoveAbilityFormTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    // 验证删除卡片接口返回值
    it('testRemoveForm_CheckReturn', 0, async (done: Function) => {
      let rfi = new RemoveFormInfo('123');
      rfi.formId = '56789';

      let mocker: MockKit = new MockKit();
      let formModel: FormModel = FormModel.getInstance();
      let func: Function = mocker.mockFunc(formModel, formModel.deleteFormByIdAsync);
      when(func)(rfi.formId).afterReturnNothing();

      await new RemoveAbilityForm().execute(rfi).then(res => {
        expect(res).assertEqual(Response.SUCCESS_OK);
      });
      mocker.clear(formModel);
      mocker.clearAll();
      done();
    })
  })
}