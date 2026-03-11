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

    let PcMainAbility = new MainAbility()
    let want = new Want()

    it('onCreate',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      expect( PcMainAbility.onCreate(want)).not().assertFail()
    })

    it('MainAbilityTest_initSceneBoard',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      expect( PcMainAbility.initSceneBoard(want)).not().assertFail()
    })

    it('onDestroy',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      expect( PcMainAbility.onDestroy()).not().assertFail()
    })

    it('onRequest',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      expect( PcMainAbility.onRequest(want,0)).not().assertFail()
    })

    it('onConnect',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      expect( PcMainAbility.onConnect(want)).not().assertFail()
    })

    it('onDisconnect',TestType.USER | Size.SMALLTEST | Level.LEVEL0, ():void=>{
      expect( PcMainAbility.onDisconnect(want)).not().assertFail()
    })

  })
}







