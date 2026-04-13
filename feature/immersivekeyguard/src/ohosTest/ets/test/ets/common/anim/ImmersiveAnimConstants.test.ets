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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import {
  ImmersiveAnimKey,
  ImmersiveAnimScene,
  ImmersivePfmConstant,
  ImmersiveNtfScene
} from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';

export function ImmersiveAnimConstantsTest() {
  describe('ImmersiveAnimConstantsTest', (): void => {
    beforeAll((): void => {

    });

    beforeEach((): void => {

    });

    afterAll((): void => {

    });

    afterEach((): void => {

    });

    it('ImmersiveAnimKey_IMMERSIVE_LIST_ROOT', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT).not().assertNull();
    });

    it('ImmersiveAnimKey_IMMERSIVE_CAPSULE_ROOT', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT).not().assertNull();
    });

    it('ImmersiveAnimKey_IMMERSIVE_CARD_ROOT', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_LIST_FIX', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_LIST_TOUCH', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_LIST_TOUCH_BACK', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CAPSULE_FIX', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CAPSULE_TOUCH', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CAPSULE_TOUCH_BACK', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CARD', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CARD).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_TO_LIST', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_TO_LIST).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_TO_LIST', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_TO_LIST).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_ROOT_SHOW', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_ROOT_HIDE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_STACK_SHOW', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_STACK_SHOW).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_STACK_REMOVE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_STACK_REMOVE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_SHADOW_REMOVE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_SHADOW_REMOVE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TOP_UPDATE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TOP_UPDATE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_REMIND', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_REMIND).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_REMIND_EXIT', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_REMIND_EXIT).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_UPDATE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_UPDATE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_CARD', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_TO_CAPSULE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_DELETE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_DELETE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_ALIGN_CHANGE', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_ALIGN_CHANGE).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_CAP_TO_LIST_ANIM', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_CAP_TO_LIST_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_LIST_TO_CAP_ANIM', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_LIST_TO_CAP_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_CAP_TO_CARD_ANIM', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_CAP_TO_CARD_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_CARD_TO_CAP_ANIM', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_CARD_TO_CAP_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_LIST_SWIPE_ANIM', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_LIST_SWIPE_ANIM).not().assertNull();
    });

    it('ImmersiveNtfScene_SCENE_NTF_ADD', Level.LEVEL1, (): void => {
      expect(ImmersiveNtfScene.SCENE_NTF_ADD).not().assertNull();
    });

    it('ImmersiveNtfScene_SCENE_NTF_UPDATE', Level.LEVEL1, (): void => {
      expect(ImmersiveNtfScene.SCENE_NTF_UPDATE).not().assertNull();
    });

    it('ImmersiveNtfScene_SCENE_NTF_REMOVE', Level.LEVEL1, (): void => {
      expect(ImmersiveNtfScene.SCENE_NTF_REMOVE).not().assertNull();
    });

    it('ImmersiveAnimKey_IMMERSIVE_LIST_ROOT02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimKey.IMMERSIVE_LIST_ROOT).not().assertNull();
    });

    it('ImmersiveAnimKey_IMMERSIVE_CAPSULE_ROOT02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimKey.IMMERSIVE_CAPSULE_ROOT).not().assertNull();
    });

    it('ImmersiveAnimKey_IMMERSIVE_CARD_ROOT02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimKey.IMMERSIVE_CARD_ROOT).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_LIST_FIX02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_LIST_TOUCH02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_LIST_TOUCH_BACK02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CAPSULE_FIX02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_FIX).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CAPSULE_TOUCH02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CAPSULE_TOUCH_BACK02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_TO_CARD02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_TO_CARD).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_TO_LIST02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_TO_LIST).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_TO_LIST02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_TO_LIST).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_ROOT_SHOW02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_ROOT_HIDE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_HIDE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_STACK_SHOW02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_STACK_SHOW).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_STACK_REMOVE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_STACK_REMOVE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_SHADOW_REMOVE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_SHADOW_REMOVE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TOP_UPDATE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TOP_UPDATE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_REMIND02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_REMIND).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_REMIND_EXIT02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_REMIND_EXIT).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_UPDATE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_UPDATE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CAPSULE_TO_CARD02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CAPSULE_TO_CARD).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_TO_CAPSULE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_CARD_DELETE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_CARD_DELETE).not().assertNull();
    });

    it('ImmersiveAnimScene_SCENE_LIST_ALIGN_CHANGE02', Level.LEVEL1, (): void => {
      expect(ImmersiveAnimScene.SCENE_LIST_ALIGN_CHANGE).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_CAP_TO_LIST_ANIM02', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_CAP_TO_LIST_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_LIST_TO_CAP_ANIM02', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_LIST_TO_CAP_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_CAP_TO_CARD_ANIM02', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_CAP_TO_CARD_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_CARD_TO_CAP_ANIM02', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_CARD_TO_CAP_ANIM).not().assertNull();
    });

    it('ImmersivePfmConstant_SCENE_LIST_SWIPE_ANIM02', Level.LEVEL1, (): void => {
      expect(ImmersivePfmConstant.SCENE_LIST_SWIPE_ANIM).not().assertNull();
    });

    it('ImmersiveNtfScene_SCENE_NTF_ADD02', Level.LEVEL1, (): void => {
      expect(ImmersiveNtfScene.SCENE_NTF_ADD).not().assertNull();
    });

    it('ImmersiveNtfScene_SCENE_NTF_UPDATE02', Level.LEVEL1, (): void => {
      expect(ImmersiveNtfScene.SCENE_NTF_UPDATE).not().assertNull();
    });

    it('ImmersiveNtfScene_SCENE_NTF_REMOVE02', Level.LEVEL1, (): void => {
      expect(ImmersiveNtfScene.SCENE_NTF_REMOVE).not().assertNull();
    });
  });
}