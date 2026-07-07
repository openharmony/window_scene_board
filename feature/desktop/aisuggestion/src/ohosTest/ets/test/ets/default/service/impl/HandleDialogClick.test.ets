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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
} from '@ohos/hypium'
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';
import {
  DialogClickInfo,
  HandleDialogClick,
} from '../../../../../../../main/ets/default/service/impl/HandleDialogClick';

export default function HandleDialogClickTest() {
  describe('HandleDialogClickTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
    });

    afterAll(() => {
    });

    it('HandleDialogClickAssert', 0, async (done: Function): Promise<void> => {
      expect(await new HandleDialogClick().execute(undefined)).assertEqual(Response.SUCCESS_OK);

      let info: DialogClickInfo = new DialogClickInfo();
      info.windowName = 'REMOVE_WINDOW';
      info.formId = '123';
      expect(await new HandleDialogClick().execute(info)).assertEqual(Response.SUCCESS_OK);
      done();
    });
  });
}