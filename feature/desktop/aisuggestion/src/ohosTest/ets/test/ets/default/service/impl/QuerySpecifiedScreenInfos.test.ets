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
  describe,
  expect,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { DefaultDesktopLayoutInfo, SettingsModel } from '@ohos/launchercommon';
import { InputScreenInfo } from '../../../../../../../main/ets/default/bean/InputScreenInfo';
import {
  QuerySpecifiedScreenInfos,
} from '../../../../../../../main/ets/default/service/impl/QuerySpecifiedScreenInfos';

/**
 * QuerySpecifiedScreenInfos测试
 *
 * @since 2023-10-17
 */
export function QuerySpecifiedScreenInfosTest() {
  describe('QuerySpecifiedScreenInfosTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('QuerySpecifiedScreenInfosTest_execute', 0, async (done: Function): Promise<void> => {
      expect(await new QuerySpecifiedScreenInfos().execute(null)).assertEqual('');

      let info: InputScreenInfo = new InputScreenInfo();
      expect(await new QuerySpecifiedScreenInfos().execute(info)).assertEqual('');

      info.screenIndexs = [];
      expect(await new QuerySpecifiedScreenInfos().execute(info)).assertEqual('');


      info.screenIndexs = [0];
      let result: string = await new QuerySpecifiedScreenInfos().execute(info);
      expect(result.length).assertLarger(0);

      const mocker: MockKit = new MockKit();
      const mockIsFold: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFold);
      when(mockIsFold)().afterReturn(true);
      result = await new QuerySpecifiedScreenInfos().execute(info);
      expect(result.length).assertLarger(0);

      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    });
  });
}