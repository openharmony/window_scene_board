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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import  IDHelperUtil  from '@ohos/screenlockcommon/src/main/ets/utils/IDHelperUtil';

export default function IDHelperUtilTest() {

  describe('IDHelperUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getTextId_should_return', 0, (): void => {
      let tag: string = 'res1';
      let subId: string = 'res2';
      let result = IDHelperUtil.getTextId(tag,subId);
      expect(result).assertEqual('res1_Text_res2');
    })
    it('test_getColumnId_should_return', 0, (): void => {
      let tag: string = 'res1';
      let subId: string = 'res2';
      let result = IDHelperUtil.getColumnId(tag,subId);
      expect(result).assertEqual('res1_Column_res2');
    })
    it('test_getStackId_should_return', 0, (): void => {
      let tag: string = 'res1';
      let subId: string = 'res2';
      let result = IDHelperUtil.getStackId(tag,subId);
      expect(result).assertEqual('res1_Stack_res2');
    })
    it('test_getImageId_should_return', 0, (): void => {
      let tag: string = 'res1';
      let subId: string = 'res2';
      let result = IDHelperUtil.getImageId(tag,subId);
      expect(result).assertEqual('res1_Image_res2');
    })
  })
}