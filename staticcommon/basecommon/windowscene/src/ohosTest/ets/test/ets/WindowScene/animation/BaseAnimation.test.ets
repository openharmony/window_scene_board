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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, } from '@ohos/hypium';

import {
  BaseAnimation,
  AnimBuilder,
  AnimEasing,
  AnimFill,
  AnimDirection
} from '../../../../../../main/ets/animation/BaseAnimation';

let baseAnimation: BaseAnimation = new BaseAnimation();

export default function BaseAnimationTest() {
  describe('BaseAnimationTest', () => {
    BeforeCreate();
    AfterCreate();
    AnimBuilderBuild();
    AnimBuilderBuildWitParam();
  });
}

function BeforeCreate() {
  it('beforeCreate', 0, () => {
    baseAnimation.play();
    baseAnimation.setCubicEasing(1, 2, 3, 4);
    baseAnimation.bindOnFrame();
    baseAnimation.updateAnim();
    baseAnimation.play();
    baseAnimation.finish();
    baseAnimation.pause();
    baseAnimation.cancel();
    baseAnimation.reverse();
    expect(true).assertTrue()
  });
}

function AfterCreate() {
  it('afterCreate', 0, () => {
    baseAnimation.createAnim();
    baseAnimation.play();
    baseAnimation.setCubicEasing(1, 2, 3, 4);
    baseAnimation.bindOnFrame();
    baseAnimation.updateAnim();
    baseAnimation.play();
    baseAnimation.finish();
    baseAnimation.pause();
    baseAnimation.cancel();
    baseAnimation.reverse();
    expect(true).assertTrue()
  });
}

function AnimBuilderBuild() {
  it('AnimBuilder_build', 0, () => {
    let animBuilder: AnimBuilder = new AnimBuilder();
    let ani: BaseAnimation = animBuilder.build();
    expect(true).assertTrue()
  });
}

function AnimBuilderBuildWitParam() {
  it('AnimBuilder_buildWitParam', 0, () => {
    let animBuilder: AnimBuilder = new AnimBuilder();
    animBuilder.fDuration(1);
    animBuilder.fEasing(AnimEasing.EASING_LINEAR);
    animBuilder.fDelay(1);
    animBuilder.fFill(AnimFill.FILL_NONE)
    animBuilder.fDirection(AnimDirection.DIRECTION_NORMAL)
    animBuilder.fIterations(1);
    animBuilder.fBegin(1);
    animBuilder.fEnd(1);
    animBuilder.fOnFrame((progress) => {
    });
    animBuilder.fOnFinish(() => {
    });
    animBuilder.fOnCancel(() => {
    });
    animBuilder.fOnRepeat(() => {
    });
    let ani: BaseAnimation = animBuilder.build();
    expect(true).assertTrue()
  });
}
