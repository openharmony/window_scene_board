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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import {
  CustomAnimation,
  CustomAnimationItem,
  CustomAnimationParam,
  CustomAnimationStatus,
  CustomAnimationUpdateParam
} from '../../../../../../../../../main/ets/service/animator/common/utils/FrameAnimationUtil'
import { curves } from '@kit.ArkUI'

export default function FrameAnimationUtilTest() {
  describe('FrameAnimationUtilTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    let Parm: CustomAnimationParam = {
      id: '0',
      delay: 0,
      duration: 0,
      endDelay: 0,
      curves: curves.initCurve(),
      begins: [],
      targets: [1, 2],
      onRender: (currentProgress: number[]): void => {
        throw new Error('Function not implemented.')
      },
      onFinish: (isCancel: boolean): void => {
        throw new Error('Function not implemented.')
      }
    }
    let Parm2: CustomAnimationParam = {
      id: '0',
      delay: 0,
      duration: 0,
      endDelay: 0,
      curves: curves.initCurve(),
      begins: [],
      targets: [1, 2],
      onRender: (currentProgress: number[]): void => {
        throw new Error('Function not implemented.')
      },
      onFinish: (isCancel: boolean): void => {
        throw new Error('Function not implemented.')
      }
    }
    let Parm1: CustomAnimationParam = {
      id: '1',
      delay: 1,
      duration: 1,
      endDelay: 1,
      curves: curves.initCurve(),
      begins: [1, 2],
      targets: [1, 2],
      onRender: (currentProgress: number[]): void => {
        throw new Error('Function not implemented.')
      },
      onFinish: (isCancel: boolean): void => {
        throw new Error('Function not implemented.')
      }
    }
    let UpdateParam: CustomAnimationUpdateParam = {
      id: ''
    }
    it('CustomAnimation_updateAnimation_Test01', 0, () => {

      let instance: CustomAnimation = new CustomAnimation();
      let UpdateParams: CustomAnimationUpdateParam[] = [UpdateParam, UpdateParam]
      instance.updateAnimation(UpdateParams);
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimation_updateAnimation_Test02', 0, () => {
      let UpdateParam1: CustomAnimationUpdateParam = {
        id: '1'
      }
      let instance: CustomAnimation = new CustomAnimation();
      let UpdateParams: CustomAnimationUpdateParam[] = [UpdateParam1, UpdateParam1]
      instance.updateAnimation(UpdateParams);
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_render_Test01', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['getCurrentAnimationTime'])
      when(mockFunc)().afterReturn(-100)
      instance.render(1);
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_render_Test02', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(instance, (instance as object)['getCurrentAnimationTime'])
      when(mockFunc)().afterReturn(100);
      (instance as object)['status'] = CustomAnimationStatus.INIT;
      instance.render(1);
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_start_Test01', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm1);
      instance.start();
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_start_Test02', 0, (done: Function) => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm2);
      instance.start();
      expect(instance).not().assertUndefined();
      done();
    })

    it('CustomAnimationItem_updateTarget_Test01', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      let result = instance.updateTarget(Parm1);
      expect(result).assertFalse();
    })

    it('CustomAnimationItem_updateTarget_Test02', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      Parm.id = '1';
      Parm.targets = [1];
      Parm.curves = curves.stepsCurve(1, false);
      instance.updateTarget(Parm2);
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_cancel_Test01', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      (instance as object)['status'] = CustomAnimationStatus.INIT;
      instance.cancel();
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_finish_Test01', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      (instance as object)['status'] = CustomAnimationStatus.INIT;
      (instance as object)['finish'](true);
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_finish_Test02', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      (instance as object)['status'] = CustomAnimationStatus.ANIMATION;
      (instance as object)['finishResolve'] = true;
      expect(instance).not().assertUndefined();
    })

    it('CustomAnimationItem_finish_Test03', 0, () => {
      let instance: CustomAnimationItem = new CustomAnimationItem(Parm);
      (instance as object)['status'] = CustomAnimationStatus.ANIMATION;
      (instance as object)['finishResolve'] = false;
      expect(instance).not().assertUndefined();
    })
  })
}