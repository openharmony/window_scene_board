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

import { describe, it, expect } from '@ohos/hypium';
import { FormCenterFormItem } from '../../../../../../main/ets/formcenter/view/atomicview/formitem/FormCenterFormItem';
import ScreenLockForm from '../../../../../../main/ets/formcenter/view/atomicview/formitem/ScreenLockForm';

export function ScreenLockFormTest() {
  describe('ScreenLockFormTest', () => {
    it('ScreenLockFormTest', 0, () => {
      try {
        let screenLockForm: ScreenLockForm = new ScreenLockForm();
        let formCenterFormItem: FormCenterFormItem = new FormCenterFormItem();
        formCenterFormItem.buildInterface = screenLockForm;
        formCenterFormItem.build();
        expect(formCenterFormItem.idIndex).assertEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}