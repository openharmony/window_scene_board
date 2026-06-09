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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  FrameListener,
  FrameListenerCallback,
  FrameSetTimeout
} from '../../../../../../main/ets/utils/FrameUtil'
import displaySync from '@ohos.graphics.displaySync'
import { Callback } from '@ohos.base'
import { ExpectedFrameRateRange } from 'ExpectedFrameRateRange'

export default function FrameUtilTest() {
  describe('FrameUtilTest', () => {
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
    it('FrameListener_getInstance_01', 0, () => {
      let frameListener: FrameListener = FrameListener.getInstance();
      expect(frameListener).not().assertUndefined();
      let frameListener1: FrameListener = FrameListener.getInstance();
      expect(frameListener1).assertEqual(frameListener);
    })

    it('FrameListener_unregister_01', 0, () => {
      let frameListener: FrameListener = FrameListener.getInstance();
      let frameListenerCallback: FrameListenerCallback = (curTimeStamp: number, nextTimeStamp: number): void => {
        let num: number = curTimeStamp + nextTimeStamp;
      };
      let callbackMap1: Map<string, FrameListenerCallback> = new Map();
      callbackMap1.set('1', frameListenerCallback);
      (frameListener as object)['callbackMap'] = callbackMap1;
      let result: Boolean = frameListener.unregister('1');
      expect(result).assertTrue();
    })

    it('FrameListener_unregister_02', 0, () => {
      let frameListener: FrameListener = FrameListener.getInstance();
      let callbackMap1: Map<string, FrameListenerCallback> = new Map();
      (frameListener as object)['callbackMap'] = callbackMap1;
      let result: Boolean = frameListener.unregister('1');
      expect(result).assertFalse();
    })

    it('FrameListener_end_01', 0, () => {
      let frameListener: FrameListener = FrameListener.getInstance();
      (frameListener as object)['mDisplaySync'] = null;
      (frameListener as object)['end']();
      expect(frameListener).not().assertUndefined();
    })

    it('FrameListener_start_01', 0, () => {
      let frameListener: FrameListener = FrameListener.getInstance();
      (frameListener as object)['start']();
      expect(frameListener).not().assertUndefined();
    })

    it('FrameSetTimeout_start_01', 0, () => {
      let frameSetTimeout: FrameSetTimeout = new FrameSetTimeout();
      (frameSetTimeout as object)['frameListener'] = '11';
      frameSetTimeout.start(() => {
      }, 5);
      expect(frameSetTimeout).not().assertUndefined();
    })

    it('FrameSetTimeout_clear_01', 0, () => {
      let frameSetTimeout: FrameSetTimeout = new FrameSetTimeout();
      frameSetTimeout.clear('11');
      expect(frameSetTimeout).not().assertUndefined();
    })

    it('FrameSetTimeout_releaseFrameListener_01', 0, () => {
      let frameSetTimeout: FrameSetTimeout = new FrameSetTimeout();
      (frameSetTimeout as object)['releaseFrameListener']();
      expect(frameSetTimeout).not().assertUndefined();
    })

    it('FrameListener_unregister_001', 0, () => {
      let frameListener: FrameListener = FrameListener.getInstance();
      let frameListenerCallback: FrameListenerCallback = (curTimeStamp: number, nextTimeStamp: number): void => {
        let num: number = curTimeStamp + nextTimeStamp;
      };
      let callbackMap1: Map<string, FrameListenerCallback> = new Map();
      callbackMap1.set('1', frameListenerCallback);
      callbackMap1.set('2', frameListenerCallback);
      (frameListener as object)['callbackMap'] = callbackMap1;
      let result: Boolean = frameListener.unregister('1');
      expect(result).assertTrue();
    })

    it('FrameListener_start_001', 0, () => {
      let x: number = 0;
      let frameListener: FrameListener = FrameListener.getInstance();
      let instance: displaySync.DisplaySync = {
        setExpectedFrameRateRange: (rateRange: ExpectedFrameRateRange): void => {
          x = x + 1;
        },
        on: (type: 'frame', callback: Callback<displaySync.IntervalInfo>): void => {
          x = x + 1;
        },
        off: (type: 'frame', callback?: Callback<displaySync.IntervalInfo> | undefined): void => {
          x = x + 1;
        },
        start: (): void => {
          x = x + 1;
        },
        stop: (): void => {
          x = x + 1;
        }
      };
      (frameListener as object)['mDisplaySync'] = instance;
      (frameListener as object)['start']();
      expect(frameListener).not().assertUndefined();
    })

    it('FrameListener_end_001', 0, () => {
      let x: number = 0;
      let frameListener: FrameListener = FrameListener.getInstance();
      let instance: displaySync.DisplaySync = {
        setExpectedFrameRateRange: (rateRange: ExpectedFrameRateRange): void => {
          x = x + 1;
        },
        on: (type: 'frame', callback: Callback<displaySync.IntervalInfo>): void => {
          x = x + 1;
        },
        off: (type: 'frame', callback?: Callback<displaySync.IntervalInfo> | undefined): void => {
          x = x + 1;
        },
        start: (): void => {
          x = x + 1;
        },
        stop: (): void => {
          x = x + 1;
        }
      };
      (frameListener as object)['mDisplaySync'] = instance;
      (frameListener as object)['end']();
      expect(frameListener).not().assertUndefined();
    })

    it('FrameSetTimeout_start_001', 0, () => {
      let frameSetTimeout: FrameSetTimeout = new FrameSetTimeout();
      (frameSetTimeout as object)['frameListener'] = '';
      frameSetTimeout.start(() => {
      }, 5);
      expect(frameSetTimeout).not().assertUndefined();
    })

    it('FrameSetTimeout_onFrame_001', 0, () => {
      let frameSetTimeout: FrameSetTimeout = new FrameSetTimeout();
      let uuid: string = getUUID();
      frameSetTimeout.start(() => {
      }, 1000);
      (frameSetTimeout as object)['onFrame']();
      expect(frameSetTimeout).not().assertUndefined();
    })

    it('FrameSetTimeout_releaseFrameListener_001', 0, () => {
      let frameSetTimeout: FrameSetTimeout = new FrameSetTimeout();
      frameSetTimeout.start(() => {
      }, 0);
      (frameSetTimeout as object)['releaseFrameListener']();
      expect(frameSetTimeout).not().assertUndefined();
    })
  })
}

function getUUID(): string {
  let id = Date.now().toString(36);
  id += Math.random().toString(36).substring(2);
  id += Math.random().toString(36).substring(2);
  return id;
}
