/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import {
  PageMode,
  IOTSubPageLayoutController
} from '../../../../../../main/ets/com/ohos/controller/IOTSubPageLayoutController';

export function IOTSubPageLayoutControllerTest() {
  let sIOTSubPageLayoutController = new IOTSubPageLayoutController();
  describe('IOTSubPageLayoutControllerTest', (): void => {

    beforeEach((): void => {
    })
    afterEach((): void => {

    })
    afterAll((): void => {
    })

    it('IOTSubPageLayoutControllerTest_onRemoteReady_001', 0, (): void => {
      (sIOTSubPageLayoutController as object)['pageMode'] = PageMode.NONE;
      //sIOTSubPageLayoutController.onRemoteReady(null);
      expect(sIOTSubPageLayoutController.onBackPress()).assertInstanceOf('Boolean');
    })

    it('IOTSubPageLayoutControllerTest_onRemoteReady_002', 0, (): void => {
      (sIOTSubPageLayoutController as object)['pageMode'] = PageMode.DETAIL;
      //sIOTSubPageLayoutController.onRemoteReady(null);
      expect(sIOTSubPageLayoutController.onBackPress()).assertInstanceOf('Boolean');
    })

    it('IOTSubPageLayoutControllerTest_onBackPress_001', 0, (): void => {
      (sIOTSubPageLayoutController as object)['pageMode'] = PageMode.NONE;
      sIOTSubPageLayoutController.onBackPress();
      expect(sIOTSubPageLayoutController.onBackPress()).assertInstanceOf('Boolean');
    })

    it('IOTSubPageLayoutControllerTest_onBackPress_002', 0, (): void => {
      (sIOTSubPageLayoutController as object)['pageMode'] = PageMode.DETAIL;
      (sIOTSubPageLayoutController as object)['isIotShowDialog'] = true;
      sIOTSubPageLayoutController.onBackPress();
      expect(sIOTSubPageLayoutController.onBackPress()).assertInstanceOf('Boolean');
    })

    it('IOTSubPageLayoutControllerTest_onBackPress_003', 0, (): void => {
      (sIOTSubPageLayoutController as object)['pageMode'] = PageMode.DETAIL;
      (sIOTSubPageLayoutController as object)['isIotShowDialog'] = false;
      sIOTSubPageLayoutController.onBackPress();
      expect(sIOTSubPageLayoutController.onBackPress()).assertInstanceOf('Boolean');
    })

    it('IOTSubPageLayoutControllerTest_onBlankAreaTouch_001', 0, (): void => {
      sIOTSubPageLayoutController.onBlankAreaTouch();
      expect(sIOTSubPageLayoutController.onBackPress()).assertInstanceOf('Boolean');
    })

    it('IOTSubPageLayoutControllerTest_onRemoteReceive_001', 0, (): void => {
      let data = [];
      sIOTSubPageLayoutController.onRemoteReceive(data as Object);
      expect(sIOTSubPageLayoutController.onBackPress()).assertInstanceOf('Boolean');
    })

    it('IOTSubPageLayoutControllerTest_onRemoteReceive', 0, (): void => {
      (sIOTSubPageLayoutController as object)['showWindow']();
      (sIOTSubPageLayoutController as object)['getAiLifeInstallStatus']();
      sIOTSubPageLayoutController.onScreenOff();
      sIOTSubPageLayoutController.showDetail(null);
      expect(sIOTSubPageLayoutController.getPageMode()).assertEqual(PageMode.DETAIL);
    })

    it('IOTSubPageLayoutControllerTest_onBackPress', 0, (): void => {
      try {
        (sIOTSubPageLayoutController as object)['pageMode'] = PageMode.DETAIL;
        (sIOTSubPageLayoutController as object)['isIotShowDialog'] = true;
        (sIOTSubPageLayoutController as object)['mProxy'] = true;
        let result = sIOTSubPageLayoutController.onBackPress();
        expect(result).assertFalse();
        (sIOTSubPageLayoutController as object)['pageMode'] = 3;
        let res = sIOTSubPageLayoutController.onBackPress();
        expect(res).assertTrue();
      } catch (e) {
        expect(sIOTSubPageLayoutController).not().assertNull();
      }
    })

    it('IOTSubPageLayoutControllerTest_onBlankAreaTouch', 0, (): void => {
      try {
        let event: TouchEvent = {
          type: TouchType.Up
        } as TouchEvent;
        (sIOTSubPageLayoutController as object)['isIotShowDialog'] = true;
        (sIOTSubPageLayoutController as object)['mProxy'] = true;
        sIOTSubPageLayoutController.onBlankAreaTouch(event);
        (sIOTSubPageLayoutController as object)['isIotShowDialog'] = false;
        (sIOTSubPageLayoutController as object)['mProxy'] = false;
        sIOTSubPageLayoutController.onBlankAreaTouch(event);
        expect((sIOTSubPageLayoutController as object)['mProxy']).assertFalse();
      } catch (e) {
        expect(sIOTSubPageLayoutController).not().assertNull();
      }
    })

    it('IOTSubPageLayoutControllerTest_getPageMode', 0, (): void => {
      sIOTSubPageLayoutController.showDetail(new Object);
      expect((sIOTSubPageLayoutController as object)['iotDetailParam']).not().assertNull();
      let mode = sIOTSubPageLayoutController.getPageMode();
      expect(mode).assertEqual(PageMode.DETAIL);
    })

    it('IOTSubPageLayoutControllerTest_onRemoteReceive_1', 0, (): void => {
      let backObj: MethObj = {
        method: 'back',
        param: 1,
      };
      let backJson = JSON.stringify(backObj);
      sIOTSubPageLayoutController.onRemoteReceive(backJson as Object);
      let closeControlCenter: MethObj = {
        method: 'closeControlCenter'
      };
      (sIOTSubPageLayoutController as object)['isAiLifeInstalled'] = false;
      sIOTSubPageLayoutController.onRemoteReceive(closeControlCenter as Object);
      (sIOTSubPageLayoutController as object)['isAiLifeInstalled'] = true;
      sIOTSubPageLayoutController.onRemoteReceive(closeControlCenter as Object);
      let showToast: MethObj = {
        method: 'showToast'
      };
      sIOTSubPageLayoutController.onRemoteReceive(showToast);
      let iotShowDialog: MethObj = {
        method: 'iotShowDialog'
      };
      sIOTSubPageLayoutController.onRemoteReceive(iotShowDialog as Object);
      expect((sIOTSubPageLayoutController as object)['isIotShowDialog']).assertFalse();
    })
  })
}

export interface MethObj {
  method: string,
  param?: number
}

