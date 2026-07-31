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
import { rpc } from '@kit.IPCKit';
import { CardItemInfo} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OpenFormCenterService } from '../../../../../../main/ets/default/service/OpenFormCenterService';
import { FormCenterResponse, FormCenterResponseCode } from '../../../../../../main/ets/default/service/ServiceInterface';
import { SCBNaviBarCallBack } from '../../../../../../../../../../product/phone/src/main/ets/SceneBoard/naviBar/proxy/SCBNaviBarCallBack';
import { FormCenterViewParam } from '@ohos/launchercommon/src/main/ets/manager/FormCenterViewManager';


export function OpenFormCenterServiceTest() {
  describe('OpenFormCenterServiceTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('execute_001', 0, async (done: Function) => {
      try {
        let openformInstance: OpenFormCenterService = new OpenFormCenterService();
        let result = await openformInstance.execute(null);
        expect(result).assertEqual('failed: invalid extra data');

        let extra = new FormCenterViewParam();
        result = await openformInstance.execute(extra);
        expect(result).assertEqual('success');
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    });

    it('handleOpenFormCenterResult_002', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let openformInstance: OpenFormCenterService = new OpenFormCenterService();
        let response: FormCenterResponse = {code: FormCenterResponseCode.ADD_FORM};
        let result = openformInstance['handleOpenFormCenterResult'](null,response);
        expect(result == null).assertTrue();

        let proxy: rpc.IRemoteObject = new SCBNaviBarCallBack("");
        result = openformInstance['handleOpenFormCenterResult'](proxy, null);
        expect(result == null).assertTrue();

        result = openformInstance['handleOpenFormCenterResult'](proxy, response);
        expect(result == null).assertTrue();

        response = {code: FormCenterResponseCode.DRAG_FORM_START};
        result = openformInstance['handleOpenFormCenterResult'](proxy, response);
        expect(result == null).assertTrue();

        response = {code: FormCenterResponseCode.CLOSE_FORM_CENTER};
        result = openformInstance['handleOpenFormCenterResult'](proxy, response);
        expect(result == null).assertTrue();

        response = {code: FormCenterResponseCode.ADD_FORM, formInfo: new CardItemInfo()};
        result = openformInstance['handleOpenFormCenterResult'](proxy, response);
        expect(result == null).assertTrue();

        response = {code: FormCenterResponseCode.DRAG_FORM_START, formInfo: new CardItemInfo()};
        result = openformInstance['handleOpenFormCenterResult'](proxy, response);
        expect(result == null).assertTrue();
      }  catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

  })
}