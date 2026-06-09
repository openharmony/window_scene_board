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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium'
import  MainAbility  from '../../../main/ets/MainAbility/MainAbility'
import Want from '@ohos.app.ability.Want';


export function MainAbilityTest(){
  describe('MainAbilityTest',()=>{
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('onCreate',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let PhoneMainAbility = new MainAbility()
      let want = new Want()
      expect( PhoneMainAbility.onCreate(want)).not().assertFail()
    })

    it('MainAbilityTest_init_SceneBoard',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let PhoneMainAbility = new MainAbility()
      let want = new Want()
      expect( PhoneMainAbility.initSceneBoard(want)).not().assertFail()
    })

    it('init_SceneBoard',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let PhoneMainAbility = new MainAbility()
      let want = new Want()
      expect( PhoneMainAbility.initSceneBoard(want)).not().assertFail()
    })

    it('onDestroy',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let PhoneMainAbility = new MainAbility()
      expect( PhoneMainAbility.onDestroy()).not().assertFail()
    })

    it('onRequest',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let PhoneMainAbility = new MainAbility()
      let want = new Want()
      expect( PhoneMainAbility.onRequest(want,0)).not().assertFail()
    })

    it('onConnect',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let PhoneMainAbility = new MainAbility()
      let want = new Want()
      expect( PhoneMainAbility.onConnect(want)).not().assertFail()
    })

    it('onDisconnect',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      let PhoneMainAbility = new MainAbility()
      let want = new Want()
      expect(PhoneMainAbility.onDisconnect(want)).not().assertFail()
    })
  })
}







