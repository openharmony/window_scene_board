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

import { image } from '@kit.ImageKit';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
} from '@ohos/hypium';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { FormStackSnapCommonData } from '../../../../../main/ets/common/FormStackSnapCommonData';
import { FormStackSnapViewData } from '../../../../../main/ets/viewmodel/FormStackSnapViewData';
import { FormStackSnapViewEvent } from '../../../../../main/ets/viewmodel/FormStackSnapViewEvent';

export function FormStackSnapViewEventTest() {
  describe('FormStackSnapViewEventTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('initData', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.initData(new FormStackSnapViewData(), new FormStackSnapCommonData());
      expect(event.mViewData == undefined).assertFalse();
    });

    it('resetData', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.initData(new FormStackSnapViewData(), new FormStackSnapCommonData());
      event.resetData();
      expect(event.mViewData).assertEqual(undefined);
      expect(event.mCommonData).assertEqual(undefined);
    });

    it('onRecvSnapShowMsg', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.onRecvSnapShowMsg(false, new FormStackSnapCommonData());

      const viewData = new FormStackSnapViewData();
      event.initData(viewData, new FormStackSnapCommonData());
      event.onRecvSnapShowMsg(true, undefined);
      expect(viewData.mIsShow).assertFalse();

      event.onRecvSnapShowMsg(false, new FormStackSnapCommonData());
      expect(viewData.mIsShow).assertFalse();

      const mocker = new MockKit();
      const mockFun = mocker.mockFunc(ResourceManager.getInstance(),
        ResourceManager.getInstance().getCachedCardSnapshot);

      when(mockFun)().afterReturn(undefined);
      event.onRecvSnapShowMsg(false, new FormStackSnapCommonData());
      expect(viewData.mIsShow).assertFalse();

      when(mockFun)().afterReturn({} as image.PixelMap);
      event.onRecvSnapShowMsg(true, new FormStackSnapCommonData());

      mocker.clear(ResourceManager.getInstance());
      mocker.clearAll();

      setTimeout(() => {
        expect(viewData.mIsShow).assertFalse();
      }, 2050);
    });

    it('resetCommonData_test01', 0, () => {
      const event: FormStackSnapViewEvent = new FormStackSnapViewEvent();
      event.mCommonData = undefined;
      (event as object)['resetCommonData']();
      expect(event).not().assertUndefined();
    });
  });
}