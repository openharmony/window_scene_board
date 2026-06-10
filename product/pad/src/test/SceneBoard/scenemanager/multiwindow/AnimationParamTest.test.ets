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

import { ArgumentMatchers, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import {
  AnimationParam
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/utils/SCBAnimationUtils';

let animParam: AnimationParam;
let initAll = () => {
  animParam = new AnimationParam ();
}
export function AnimationParamTest() {
  describe('AnimationParamTest_001', () => {
    beforeEach(initAll)
    it ("test_setScale_001", Level.LEVEL0, test_setScale_01);
    it ("test_setTranslate_001", Level.LEVEL0, test_setTranslate_01);
    it ("test_setSizeNum_001", Level.LEVEL0, test_setSizeNum_01);
    it ("test_setPosNum_001", Level.LEVEL0, test_setPosNum_01);

  });
}

function test_setTranslate_01() {
  animParam.setTranslate(0, 0);
  expect(0).assertEqual(animParam.animateTranslateX);
}

function test_setScale_01() {
  animParam.setScale(0, 0);
  expect(0).assertEqual(animParam.animateScaleX);
}

function test_setSizeNum_01() {
  animParam.setSizeNum(0, 0);
  expect(0).assertEqual(animParam.width.getPx());
}

function test_setPosNum_01() {
  animParam.setPosNum(0, 0);
  expect(0).assertEqual(animParam.positionX.getPx());
}

