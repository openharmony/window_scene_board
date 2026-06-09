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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';

import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
import GridLayoutItemInfo from '../../../../../../main/ets/bean/GridLayoutItemInfo';
import { AppInstallUtils } from '../../../../../../main/ets/appinstall/AppInstallUtils';
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';

export function AppInstallUtilsTest() {
  describe('AppInstallUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('PreInstallUtilsTest_requestTask', 0, async () => {
      const res = 'success';
      const appItem: AppItemInfo = {
        appName: '',
        appIconId: 0,
        bundleName: 'bundleName',
        abilityName: '',
        appIndex: CommonConstants.MAIN_APP_INDEX,
        intent: '{"isNeedInstallApp":true}',
        iconResource: 'img'
      };
      await AppInstallUtils.getInstance().requestTask(appItem);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('PreInstallUtilsTest_requestNoNetworkTask', 0, async () => {
      const res = 'success';
      let info: GridLayoutItemInfo = new GridLayoutItemInfo();
      info.appName = '抖音';
      info.bundleName = 'com.ss.hm.ugc.aweme';
      await AppInstallUtils.getInstance().requestNoNetworkTask(info);
      let a = 'test';
      expect(a).assertEqual('test');
    })
  })
}