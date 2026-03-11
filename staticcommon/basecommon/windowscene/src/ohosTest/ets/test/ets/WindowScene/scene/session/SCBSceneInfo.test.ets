/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect
} from '@ohos/hypium'
import { SCBSceneInfo } from '../../../../../../../..';

export function SCBSceneInfoTest() {
  describe('SCBSceneInfoTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('equalToTest', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('TestBundle', 'TestMoudle', 'TestAbility');
        let musicSceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility');
        let flag: boolean = sceneInfo.equalTo(musicSceneInfo);
        expect(flag).assertFalse();

        flag = sceneInfo.equalTo(sceneInfo);
        expect(flag).assertTrue();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('isSameAbilityTest', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility');
        let musicSceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility');
        let flag: boolean = sceneInfo.isSameAbility(musicSceneInfo);
        expect(flag).assertTrue();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('isSameAbilityAndAppIndexTest001', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility');
        let musicSceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility');
        let flag: boolean = sceneInfo.isSameAbilityAndAppIndex(musicSceneInfo);
        expect(flag).assertTrue();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('isSameAbilityAndAppIndexTest002', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility', 0);
        let musicSceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility', 1);
        let flag: boolean = sceneInfo.isSameAbilityAndAppIndex(musicSceneInfo);
        expect(flag).assertFalse();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('isSameBundleTest', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('TestBundle', 'TestMoudle', 'TestAbility');
        let musicSceneInfo: SCBSceneInfo = new SCBSceneInfo('musicBundle', 'musicMoudle', 'musicAbility');
        let flag: boolean = sceneInfo.isSameBundle(musicSceneInfo);
        expect(flag).assertFalse();
        flag = sceneInfo.isSameBundle(sceneInfo);
        expect(flag).assertTrue();
      } catch (e) {
        expect(false).assertFail();
      }
    })

    it('initWIndowLimitTest', 0, () => {
      try {
        let sceneInfo: SCBSceneInfo = new SCBSceneInfo('TestBundle', 'TestMoudle', 'TestAbility');
        sceneInfo.initWindowLimit(500, 600, 700, 800);
        expect(sceneInfo.maxWindowWidth).assertEqual(500);
        expect(sceneInfo.minWindowWidth).assertEqual(600);
        expect(sceneInfo.maxWindowHeight).assertEqual(700);
        expect(sceneInfo.minWindowHeight).assertEqual(800);
        expect(sceneInfo.getWindowLimitString()).assertEqual('maxWindowWidth: 500 minWindowWidth: 600 maxWindowHeight: 700 minWindowHeight: 800');
      } catch (e) {
        expect(false).assertFail();
      }
    })
  })
}