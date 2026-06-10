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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  TestType,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { AppItemInfo, CardItemInfo, FormModel } from '@ohos/launchercommon';
import {
  FormEditViewController,
  FormEditViewParam
} from '@ohos/launchercommon/src/main/ets/manager/FormEditViewManager';
import { FormEditView } from '../../../../../../main/ets/default/view/FormEditView';

export function FormEditViewTest() {
  describe('FormEditViewTest', () => {
    it('ShowView', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let formEditView: FormEditView = new FormEditView();
        let param: FormEditViewParam = new FormEditViewParam();
        (formEditView as object)['showView'](param);
        expect((formEditView as object)['mAppInfo']).assertUndefined();

        let formModel: FormModel = FormModel.getInstance();
        let appInfo: AppItemInfo = new AppItemInfo();

        let mockGetAppInfoByBundleName: Function = mocker.mockFunc(formModel, formModel.getAppInfoByBundleName);
        when(mockGetAppInfoByBundleName)().afterReturn(appInfo);

        param.formInfo = new CardItemInfo();
        (formEditView as object)['showView'](param);
        expect((formEditView as object)['mAppInfo']).assertUndefined();

        mocker.clear(formModel);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clearAll();
    });
  })
}

