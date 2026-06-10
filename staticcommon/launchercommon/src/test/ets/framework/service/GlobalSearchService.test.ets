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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level, MockKit, when } from '@ohos/hypium'
import { GlobalSearchService } from '../../../../../../main/ets/framework/service/GlobalSearchService'
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo'


export function GlobalSearchServiceTest(){
  describe('GlobalSearchServiceTest',()=>{
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    it('GlobalSearchServiceTest_getInstance',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      expect(GlobalSearchService.getInstance()).not().assertFail();
      expect(GlobalSearchService.getInstance()).not().assertNull();
    })

    it('setAppList', Level.LEVEL0, async () => {
      let res = await GlobalSearchService.getInstance().setAppList();
      expect(res).assertUndefined();
    })

    it('publishSearchEvent',TestType.USER | Size.SMALLTEST | Level.LEVEL0, async (done: Function) => {
      let mOperationItemInfo:AppItemInfo = {
        bundleName:'',
        abilityName:'',
        appName:'',
        appIconId:0,
      };
      let event = '';
      let res = await GlobalSearchService.getInstance().publishSearchEvent(event, mOperationItemInfo);
      expect(res).assertUndefined();
      done()
    })

    it('GlobalSearchServiceTest_destroy',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let res = GlobalSearchService.getInstance().destroy();
      expect(res).assertUndefined();
    })
  })
}