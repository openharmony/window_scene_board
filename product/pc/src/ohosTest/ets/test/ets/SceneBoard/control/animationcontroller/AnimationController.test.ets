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

import { hilog } from '@kit.PerformanceAnalysisKit';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  Size,
  TestType,
} from '@ohos/hypium';
import {
  CallbackParameter,
  AnimationController
} from '@ohos/pcbase/src/main/ets/SceneBoard/control/animationcontroller/AnimationController';

const TAG: string = 'AnimationControllerTest';

export default function AnimationControllerTest() {
  let animationController: AnimationController = new AnimationController()
  let callbackParameter: CallbackParameter;
  let mockCallback: () => void = () => {
  };
  describe('AnimationControllerTest', () => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterEach((): void => {
    });
    afterAll((): void => {
      hilog.info(0x0000, TAG, 'afterAll all it pass');
    });

    it('initRequiredParamsTest', 0, async (done: Function) => {
      callbackParameter = new CallbackParameter(mockCallback);
      expect(callbackParameter.callback).assertEqual(mockCallback);
      expect(callbackParameter.curve).assertUndefined();
      expect(callbackParameter.duration).assertUndefined();
      expect(callbackParameter.delay).assertUndefined();
      expect(callbackParameter.finish).assertUndefined();
      done();
    });

    it('initAllParamsTest', 0, async (done: Function) => {
      let curve: ESObject = {};
      let duration: ESObject = 1000;
      let delay: ESObject = 500;
      let finish: () => void = () => {
      };
      callbackParameter = new CallbackParameter(mockCallback, curve, duration, delay, finish);
      expect(callbackParameter.callback).assertEqual(mockCallback);
      expect(callbackParameter.curve).assertEqual(curve);
      expect(callbackParameter.duration).assertEqual(duration);
      expect(callbackParameter.delay).assertEqual(delay);
      expect(callbackParameter.finish).assertEqual(finish);
      done();
    });

    it('initUndefinedParamsTest', 0, async (done: Function) => {
      callbackParameter = new CallbackParameter(mockCallback, undefined, undefined, undefined, undefined);
      expect(callbackParameter.callback).assertEqual(mockCallback);
      expect(callbackParameter.curve).assertUndefined();
      expect(callbackParameter.duration).assertUndefined();
      expect(callbackParameter.delay).assertUndefined();
      expect(callbackParameter.finish).assertUndefined();
      done();
    });

    it('doCallbacksTest', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        animationController.doCallbacks();
        animationController.doCallbacks();
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'startService error' + e);
      }
    });
    it('registerCallbackTest', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let name: string = 'name';
        let callback: () => void = () => {
        };
        animationController.registerCallback(name, callback);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'registerNameIsEmpty error' + e);
      }
    });
    it('registerNameIsEmptyTest', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let name: string = '';
        let callback: () => void = () => {
        };
        animationController.registerCallback(name, callback);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'registerNameIsEmpty error' + e);
      }
    });
    it('registerCallbackIsNullTest', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let name: string = 'name';
        let callback: () => void = () => null;
        animationController.registerCallback(name, callback);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'registerNameIsEmpty error' + e);
      }
    });

    it('unregisterCallbackTest', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let name: string = 'name';
        animationController.unregisterCallback(name);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'unregisterCallback error' + e);
      }
    });

    it('unregisterCallbackParamsIsNullTest', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      try {
        let name: string = '';
        animationController.unregisterCallback(name);
      } catch (e) {
        expect(false).assertFail();
        hilog.info(0x0000, TAG, 'unregisterCallback error' + e);
      }
    });

    it('runAnimationDirectlyTest', 0, () => {
      callbackParameter = new CallbackParameter(mockCallback);
      animationController.runAnimationDirectly(callbackParameter);
    });
  });
}
