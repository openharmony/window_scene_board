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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import  screenLockFormPanelModel  from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelModel';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function screenLockFormPanelModelTest() {

  describe('screenLockFormPanelModelTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_init_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormPanelModel.init()
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_destroy_return', 0, (): void => {
      let result: boolean = false;
      getResultClass.getResult1(() => {
        screenLockFormPanelModel.destroy()
        result = true;
      })
      expect(result).assertEqual(true);
    })

  })
}