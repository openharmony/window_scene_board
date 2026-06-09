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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  DropAnimationDestination,
} from '../../../../../../../../../main/ets/service/animator/drop/config/DropAnimationConfig';
import {
  DropAnimationListener,
  dropAnimationObserver,
  DropAnimationParam,
} from '../../../../../../../../../main/ets/TsIndex';

/**
 * 落位动效观察者测试套
 */
export function DropAnimationObserverTest() {
  describe('DropAnimationObserverTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_onAnimationStart_without_key', Level.LEVEL0, (): void => {
      let animTarget: number = 0;
      let animParam: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      let animIsMultiDrop: boolean = false;
      let listener: DropAnimationListener = {
        onDropAnimationStart: (target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean) => {
          animTarget = target;
          animParam = param;
          animIsMultiDrop = isMultiDrop;
        },
      };
      dropAnimationObserver.registerDropAnimationListener(listener);
      dropAnimationObserver.triggerAnimationStart(DropAnimationDestination.DESKTOP,
        new DropAnimationParam('1', 0, 0, 0, 0), true);
      expect(animTarget).assertEqual(DropAnimationDestination.DESKTOP);
      expect(animParam.key).assertEqual('1');
      expect(animIsMultiDrop).assertEqual(true);
      dropAnimationObserver.triggerAnimationEnd(DropAnimationDestination.DOCK,
        new DropAnimationParam('2', 0, 0, 0, 0), false, false);
      expect(animTarget).assertEqual(DropAnimationDestination.DESKTOP);
      expect(animParam.key).assertEqual('1');
      expect(animIsMultiDrop).assertEqual(true);
      dropAnimationObserver.unregisterDropAnimationListener(listener);
    })

    it('test_onAnimationStart_with_key', Level.LEVEL0, (): void => {
      let animTarget: number = 0;
      let animParam: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      let animIsMultiDrop: boolean = false;
      let listener: DropAnimationListener = {
        onDropAnimationStart: (target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean) => {
          animTarget = target;
          animParam = param;
          animIsMultiDrop = isMultiDrop;
        },
      };
      dropAnimationObserver.registerDropAnimationListener(listener, '1');
      dropAnimationObserver.triggerAnimationStart(DropAnimationDestination.DESKTOP,
        new DropAnimationParam('1', 0, 0, 0, 0), true);
      expect(animTarget).assertEqual(DropAnimationDestination.DESKTOP);
      expect(animParam.key).assertEqual('1');
      expect(animIsMultiDrop).assertEqual(true);
      dropAnimationObserver.triggerAnimationEnd(DropAnimationDestination.DOCK,
        new DropAnimationParam('2', 0, 0, 0, 0), false, false);
      expect(animTarget).assertEqual(DropAnimationDestination.DESKTOP);
      expect(animParam.key).assertEqual('1');
      expect(animIsMultiDrop).assertEqual(true);
      dropAnimationObserver.unregisterDropAnimationListener(listener, '1');
    })

    it('test_onAnimationEnd_without_key', Level.LEVEL0, (): void => {
      let animTarget: number = 0;
      let animParam: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      let animIsMultiDrop: boolean = false;
      let animIsCancel: boolean = false;
      let listener: DropAnimationListener = {
        onDropAnimationEnd: (target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean,
          isCancel: boolean) => {
          animTarget = target;
          animParam = param;
          animIsMultiDrop = isMultiDrop;
          animIsCancel = isCancel;
        },
      };
      dropAnimationObserver.registerDropAnimationListener(listener);
      dropAnimationObserver.triggerAnimationStart(DropAnimationDestination.DESKTOP,
        new DropAnimationParam('1', 0, 0, 0, 0), true);
      expect(animTarget).assertEqual(0);
      expect(animParam.key).assertEqual('');
      expect(animIsMultiDrop).assertEqual(false);
      expect(animIsCancel).assertEqual(false);
      dropAnimationObserver.triggerAnimationEnd(DropAnimationDestination.DOCK,
        new DropAnimationParam('2', 0, 0, 0, 0), true, true);
      expect(animTarget).assertEqual(DropAnimationDestination.DOCK);
      expect(animParam.key).assertEqual('2');
      expect(animIsMultiDrop).assertEqual(true);
      expect(animIsCancel).assertEqual(true);
      dropAnimationObserver.unregisterDropAnimationListener(listener);
    })

    it('test_onAnimationEnd_with_key', Level.LEVEL0, (): void => {
      let animTarget: number = 0;
      let animParam: DropAnimationParam = new DropAnimationParam('', 0, 0, 0, 0);
      let animIsMultiDrop: boolean = false;
      let animIsCancel: boolean = false;
      let listener: DropAnimationListener = {
        onDropAnimationEnd: (target: DropAnimationDestination, param: DropAnimationParam, isMultiDrop: boolean,
          isCancel: boolean) => {
          animTarget = target;
          animParam = param;
          animIsMultiDrop = isMultiDrop;
          animIsCancel = isCancel;
        },
      };
      dropAnimationObserver.registerDropAnimationListener(listener, '2');
      dropAnimationObserver.triggerAnimationStart(DropAnimationDestination.DESKTOP,
        new DropAnimationParam('1', 0, 0, 0, 0), true);
      expect(animTarget).assertEqual(0);
      expect(animParam.key).assertEqual('');
      expect(animIsMultiDrop).assertEqual(false);
      expect(animIsCancel).assertEqual(false);
      dropAnimationObserver.triggerAnimationEnd(DropAnimationDestination.DOCK,
        new DropAnimationParam('2', 0, 0, 0, 0), true, true);
      expect(animTarget).assertEqual(DropAnimationDestination.DOCK);
      expect(animParam.key).assertEqual('2');
      expect(animIsMultiDrop).assertEqual(true);
      expect(animIsCancel).assertEqual(true);
      dropAnimationObserver.unregisterDropAnimationListener(listener, '2');
    })

    it('test_getListenerCount', Level.LEVEL0, (): void => {
      let listener1: DropAnimationListener = {};
      let listener2: DropAnimationListener = {};
      let count = dropAnimationObserver.getListenerCount();
      dropAnimationObserver.registerDropAnimationListener(listener1);
      expect(dropAnimationObserver.getListenerCount()).assertEqual(count + 1);
      dropAnimationObserver.unregisterDropAnimationListener(listener1);
      dropAnimationObserver.registerDropAnimationListener(listener1, '1');
      dropAnimationObserver.registerDropAnimationListener(listener2, '1');
      expect(dropAnimationObserver.getListenerCount('1')).assertEqual(2);
      dropAnimationObserver.unregisterDropAnimationListener(listener1, '2');
      expect(dropAnimationObserver.getListenerCount('1')).assertEqual(2);
      dropAnimationObserver.unregisterDropAnimationListener(listener1, '1');
      expect(dropAnimationObserver.getListenerCount('1')).assertEqual(1);
      dropAnimationObserver.unregisterDropAnimationListener(listener2, '1');
      expect(dropAnimationObserver.getListenerCount('1')).assertEqual(0);
    })
  })
}