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
import { SCBScreenSessionManager } from '@ohos/basiccommon/src/main/ets/TsIndex';
import { FormHostService, VisibleChangeListener } from '../../../../../../main/ets/default/service/FormHostService';
import { DefaultDesktopLayoutInfo, FormLayoutCacheManager,
  GridLayoutItemInfo, CommonConstants,
  LaunchLayoutCacheManager } from '@ohos/launchercommon/src/main/ets/TsIndex';

export function FormHostServiceBackupTest() {
  describe('FormHostServiceBackupTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getFormListByPageIndex_onlyCard', TestType.FUNCTION | Level.LEVEL0, () => {
      let formLayoutManager: FormLayoutCacheManager = FormLayoutCacheManager.getInstance();
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(formLayoutManager, formLayoutManager.selectAllFormsAndFormStack);
      let layout: GridLayoutItemInfo[] = [];
      let formItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      formItem.cardId = '123';
      formItem.typeId = CommonConstants.TYPE_CARD;
      formItem.page = 0;
      layout.push(formItem);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(layout);
      let formHostService: FormHostService = FormHostService.getInstance();
      expect(formHostService.getFormListByPageIndex(0).length).assertEqual(1);
      mocker.clear(formLayoutManager);
      mocker.clearAll();
    });

    it('registerFormVisibleListener', TestType.FUNCTION | Level.LEVEL0, () => {
      let formHostService: FormHostService = FormHostService.getInstance();
      let calledTimes: number = 0;
      let visibleListener: VisibleChangeListener = {
        onVisibleChange: (visible: boolean): void => {
          calledTimes = calledTimes + 1;
        }
      };

      formHostService.registerFormVisibleListener('123', visibleListener);
      formHostService.formHostNotifyVisible(['123']);
      formHostService.unRegisterFormVisibleListener('123', visibleListener);
      expect(calledTimes).assertEqual(1);
    });
  })
}