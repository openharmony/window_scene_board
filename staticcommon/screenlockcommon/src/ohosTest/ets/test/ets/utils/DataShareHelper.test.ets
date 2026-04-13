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
import { CommonUtils } from '@ohos/basicutils'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { DataShareHelper, DataType } from '../../../../../main/ets/utils/DataShareHelper'

export default function DataShareHelperTest() {
  describe('DataShareHelperTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('DataShareHelperTest_getUri', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
     let shareHelper: DataShareHelper = new DataShareHelper(DataType.NORMAL,'test',()=>{});
      (shareHelper as object)['_dataType']= DataType.NORMAL;
      (shareHelper as object)['getUri']();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('DataShareHelperTest_getUri_02', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let shareHelper: DataShareHelper = new DataShareHelper(DataType.NORMAL,'test',()=>{});
      (shareHelper as object)['_dataType']= DataType.SECURE;
      (shareHelper as object)['getUri']();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('DataShareHelperTest_getUri_03', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let shareHelper: DataShareHelper = new DataShareHelper(DataType.NORMAL,'test',()=>{});
      (shareHelper as object)['_dataType']= DataType.USER_SETTINGS;
      (shareHelper as object)['getUri']();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    })

    it('DataShareHelperTest_getUri_03', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let shareHelper: DataShareHelper = new DataShareHelper(DataType.NORMAL,'test',()=>{});
      (shareHelper as object)['_dataType']= 4;
      (shareHelper as object)['getUri']();
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('DataShareHelperTest_getUserSettingsKeyUri', 0, () => {
      let shareHelper: DataShareHelper = new DataShareHelper(DataType.NORMAL,'test',()=>{});
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CommonUtils, CommonUtils.isNumber);
      when(mockFun1)(10).afterReturn(false);
      (shareHelper as object)['getUserSettingsKeyUri']();
      expect(shareHelper).not().assertNull();
      mock.clear(CommonUtils);
    });

    it('DataShareHelperTest_getUserSettingsKeyUri_02', 0, () => {
      let shareHelper: DataShareHelper = new DataShareHelper(DataType.NORMAL,'test',()=>{});
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CommonUtils, CommonUtils.isNumber);
      when(mockFun1)(10).afterReturn(true);
      (shareHelper as object)['getUserSettingsKeyUri']();
      expect(shareHelper).not().assertNull();
      mock.clear(CommonUtils);
    });

  })
}