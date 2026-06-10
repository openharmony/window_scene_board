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
import TestConst from '../constants/TestConst';
import ScreenLockFormViewModel from '@ohos/screenlockwidget/src/main/ets/form/vm/ScreenLockFormViewModel';

function getResult(callBack:Function){};

export default function FormTest() {
  const SCREEN_LOCK:number = 6;
  const FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';

  let mScreenLockFormViewModel = new ScreenLockFormViewModel();

  describe('FormTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getFormWant_should_return_6', TestConst.TEST_LEVEL, (): void => {
      let want = ScreenLockFormViewModel.getFromWant();
      expect(want.parameters?.[FORM_LOCATION_KEY]).assertEqual(SCREEN_LOCK);
    })

    it('test_hasAddedCard_should_return_false', TestConst.TEST_LEVEL, (): void => {
      expect(mScreenLockFormViewModel.hasAddedCard()).assertEqual(false);
    })

    it('test_mScreenLockFormViewModel_should_return_ture', TestConst.TEST_LEVEL, (): void => {
      let result:boolean = false;
      getResult(()=>{
        mScreenLockFormViewModel.getPanelPositionY()
        mScreenLockFormViewModel.getRealPositionY();
        mScreenLockFormViewModel.getDownToClockView();
        mScreenLockFormViewModel.getSupportPositionEntryDelay();
        mScreenLockFormViewModel.getFormPanelScene();
        mScreenLockFormViewModel.getIsAddingForm();
        mScreenLockFormViewModel.getClockLayout();
        mScreenLockFormViewModel.getIsDeletingForm();
        mScreenLockFormViewModel.getFormConfigInfo();
        mScreenLockFormViewModel.getFormPanelHeight();
        mScreenLockFormViewModel.registerRouterProxy('335619');
        mScreenLockFormViewModel.clearAbilityQueue();
        result = true;
      })
      expect(result).assertEqual(false);
    })
  })

}