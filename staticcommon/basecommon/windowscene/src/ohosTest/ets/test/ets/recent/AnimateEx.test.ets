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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import {
  animateExAddEvent,
  animateExBreak,
  animateExDelete,
  animateExGet,
  animateExNew,
  animateExStart,
  AnimateExState,
  animateExTo,
  animateExAddOnFinish,
  animateExOneShot
} from '../../../../../../Index';
import type { AnimateExArgsType } from '../../../../../../Index';
import curves from '@ohos.curves';

class AnimationTest {
  private name: string = 'defaultAnimation';

  constructor(name: string) {
    this.name = name;
    this.init();
  }

  init(): boolean {
    animateExNew(this.name, {
      curve: Curve.Linear,
      duration: 10
    },
      () => {
      }, () => {

      });
    return true;
  }

  destroy(): boolean {
    animateExDelete(this.name);
    return true;
  }

  public static builder(name: string): AnimationTest {
    return new AnimationTest(name);
  }
}

let testAnimationEventResult: boolean = false;
let testAnimationEvent = () => {
  testAnimationEventResult = true;
}

let testAnimationEventWithArgs = (...args: AnimateExArgsType[]) => {
  if (args[0] as boolean) {
    testAnimationEventResult = true;
  } else {
    testAnimationEventResult = false;
  }
}

let testAnimationOnFinishResult: boolean = false;
let testAnimationOnFinish = () => {
  testAnimationOnFinishResult = true;
};

export default function AnimateExTest() {
  describe('AnimateExTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      testAnimationOnFinishResult = false;
      testAnimationEventResult = false;
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('animateExTo_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExTo_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      let animateName = 'animateExTo1';
      animateExTo(animateName, {
        curve: curves.springMotion()
      }, () => {
      }, () => {
      });
      expect(animateExGet(animateName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExDelete(animateName)).assertTrue();
      defaultAnimation.destroy();
    });

    it('animateExGet1_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExGet1_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      let animateName = 'animateExGet1';
      expect(animateExGet(animateName)).assertEqual(undefined);
      defaultAnimation.destroy();
    });

    it('animateExNew1_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExNew1_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      let animateName = 'animateExNew1';
      animateExNew(animateName, {
        curve: curves.springMotion()
      },
        () => {
          return;
        }, () => {

        })
      expect(animateExGet(animateName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExDelete(animateName)).assertTrue();
      defaultAnimation.destroy();
    });

    it('animateExNew2_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExNew2_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      animateExNew('animateExNew21', {
        curve: curves.springMotion()
      },
        () => {
          return;
        },
        () => {

        })
      animateExNew('animateExNew22', {
        curve: curves.springMotion()
      },
        () => {
          return;
        }, () => {

        })
      expect(animateExGet('animateExNew21')?.state).assertEqual(AnimateExState.INIT);
      expect(animateExGet('animateExNew22')?.state).assertEqual(AnimateExState.INIT);
      expect(animateExDelete('animateExNew21')).assertTrue();
      expect(animateExDelete('animateExNew22')).assertTrue();
      expect(animateExDelete('animateExNew22')).assertFalse();
      defaultAnimation.destroy();
    });

    it('animateExStart1_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExStart1_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      animateExGet(defaultAnimationName)?.start();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.ANIMATING);
      defaultAnimation.destroy();
    });

    it('animateExStart2_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExStart2_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      animateExGet(defaultAnimationName)?.start();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.ANIMATING);
      animateExGet(defaultAnimationName)?.start();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.ANIMATING);
      animateExGet(defaultAnimationName)?.start();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.ANIMATING);
      animateExGet(defaultAnimationName)?.start();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.ANIMATING);
      defaultAnimation.destroy();
    });

    it('animateExStart3_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExStart3_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExStart(defaultAnimationName)).assertTrue();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExStart(defaultAnimationName)).assertTrue();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      defaultAnimation.destroy();
    });

    it('animateExDelete_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExBreak_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      let animateName = 'animateExDelete1';
      animateExNew(animateName, {
        curve: curves.springMotion()
      },
        () => {
          return;
        }, () => {
        })
      expect(animateExGet(animateName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExDelete(animateName)).assertTrue();
      expect(animateExGet(animateName)).assertEqual(undefined);
      defaultAnimation.destroy();
    });

    it('animateExAddEvent_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExAddEvent_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExAddEvent(defaultAnimationName, () => {
      })).assertTrue();
      expect(animateExAddEvent(defaultAnimationName + 'random', () => {
      })).assertFalse();
      defaultAnimation.destroy();
    });

    it('animateExAddEventWithArgs_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExAddEventWithArgs_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      let animateEventResult = false;
      expect(animateExAddEvent(defaultAnimationName, (...args: AnimateExArgsType[]) => {
        if (args[0] as boolean) {
          animateEventResult = true;
        } else {
          animateEventResult = false;
        }
      })).assertTrue();
      expect(animateExGet(defaultAnimationName)?.start(true)).assertTrue();
      expect(animateEventResult).assertTrue();
      expect(animateExGet(defaultAnimationName)?.start(false)).assertTrue();
      expect(animateEventResult).assertFalse();
      defaultAnimation.destroy();
    });

    it('animateExAddEvent2_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExAddEvent2_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExAddEvent(defaultAnimationName, testAnimationEvent)).assertTrue();
      expect(animateExStart(defaultAnimationName)).assertTrue();
      expect(testAnimationEventResult).assertTrue();
      defaultAnimation.destroy();
    });

    it('animateExAddOnFinish_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExAddOnFinish_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      testAnimationOnFinishResult = false
      expect(animateExAddOnFinish(defaultAnimationName, testAnimationOnFinish)).assertTrue();
      expect(animateExStart(defaultAnimationName)).assertTrue();
      expect(testAnimationOnFinishResult).assertFalse();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      testAnimationOnFinishResult = false;
      defaultAnimation.destroy();
    });

    it('animateExAddBreakableOnFinish_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExAddBreakableOnFinish_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      let onFinishResult: boolean = false;
      expect(animateExAddOnFinish(defaultAnimationName, () => {
        onFinishResult = true;
      }, true)).assertTrue();
      expect(animateExGet(defaultAnimationName)?.start()).assertTrue();
      expect(onFinishResult).assertFalse();
      expect(animateExGet(defaultAnimationName)?.break('will')).assertTrue();
      expect(onFinishResult).assertFalse();
      defaultAnimation.destroy();
    });

    it('animateExOneShot_test', 0, () => {
      let defaultAnimationName = 'defaultAnimation_animateExOneShot_test';
      let defaultAnimation = AnimationTest.builder(defaultAnimationName);
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExOneShot(defaultAnimationName)).assertTrue();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      expect(animateExOneShot(defaultAnimationName)).assertTrue();
      expect(animateExGet(defaultAnimationName)?.state).assertEqual(AnimateExState.INIT);
      defaultAnimation.destroy();
    });
  })
}