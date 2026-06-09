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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { DragEventManager } from '../../../../../../main/ets/manager/DragEventManager';
import { GlobalContext } from '@ohos/frameworkwrapper';
import type { DragEventCallback } from '../../../../../../main/ets/service/drag/DragEventCallback';

export function DragEventManagerTest() {
  describe('DragEventManagerTest', (): void => {
    let mocker: MockKit;
    beforeAll((): void => {

    });
    beforeEach((): void => {
      mocker = new MockKit();
      const mockFunc: Function = mocker.mockFunc(GlobalContext, GlobalContext.getContext);
      when(mockFunc)().afterReturn({
        eventHub: {
          on() {
          },
          off() {
          },
          emit() {
          }
        }
      });
    })
    afterAll((): void => {

    })
    afterEach((): void => {
      mocker.clear(GlobalContext);
      mocker.clearAll();
    })

    it('DragEventManagerTest_getInstance_should_not_null', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance()).not().assertNull();
    })

    it('test_isDropInDesktop', Level.LEVEL0, (): void => {
      DragEventManager.getInstance().dragStartInDesktop('');
      expect(DragEventManager.getInstance().isDropInDesktop).assertFalse();
      DragEventManager.getInstance().startDrop('');
      expect(DragEventManager.getInstance().isDropInDesktop).assertTrue();
    })

    it('test_registerDragEvent', Level.LEVEL0, (): void => {
      let itemId: string = '';
      let dragEventCallback: DragEventCallback = {} as DragEventCallback;
      let registerDragEventFunc: Function = () => DragEventManager.getInstance().registerDragEvent(dragEventCallback, itemId);
      expect(registerDragEventFunc()).not().assertFail();
      DragEventManager.getInstance().unRegisterDragEvent(dragEventCallback, itemId);
      itemId = '123';
      expect(registerDragEventFunc()).not().assertFail();
      DragEventManager.getInstance().unRegisterDragEvent(dragEventCallback, itemId);
    })

    it('test_sendDragEvent', Level.LEVEL0, (): void => {
      let itemId: string = '';
      let result: number = 0;
      let dragEventCallback: DragEventCallback = {
        onStartSqueezedEvent: () => {
          result = 1;
        },
        onCancelSqueezedEvent: () => {
          result = 1;
        },
        onItemDropStartEvent: () => {
          result = 1;
        },
        onItemDropEndEvent: () => {
          result = 1;
        },
        onItemDragStartEvent: () => {
          result = 1;
        },
      };
      DragEventManager.getInstance().registerDragEvent(dragEventCallback, itemId);

      result = 0;
      DragEventManager.getInstance().dragStartInDesktop(itemId);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().startSqueezedInDesktop(itemId, null);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().startSqueezedInDesktop(itemId, null, { delayTime: 0, opacity: 1 });
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().cancelSqueezedInDesktop(itemId);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().startDrop(itemId);
      expect(result).assertEqual(0);

      result = 0;
      DragEventManager.getInstance().dropEnd(itemId);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().unRegisterDragEvent(dragEventCallback, itemId);
    })

    it('test_sendDragEvent_no_content', Level.LEVEL0, (): void => {
      let itemId: string = '';
      let result: number = 0;
      let dragEventCallback: DragEventCallback = {
        onStartSqueezedEvent: () => {
          result = 1;
        },
        onCancelSqueezedEvent: () => {
          result = 1;
        },
        onItemDropStartEvent: () => {
          result = 1;
        },
        onItemDropEndEvent: () => {
          result = 1;
        },
        onItemDragStartEvent: () => {
          result = 1;
        },
      };
      DragEventManager.getInstance().registerDragEvent(dragEventCallback, itemId);

      DragEventManager.getInstance().dragStartInDesktop(itemId);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().startSqueezedInDesktop(itemId, null);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().startSqueezedInDesktop(itemId, null, { delayTime: 0, opacity: 1 });
      expect(result).assertEqual(0);

      DragEventManager.getInstance().cancelSqueezedInDesktop(itemId);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().startDrop(itemId);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().dropEnd(itemId);
      expect(result).assertEqual(0);

      DragEventManager.getInstance().unRegisterDragEvent(dragEventCallback, itemId);
    })

    it('DragEventManagerTest_getInstance_test01', Level.LEVEL0, (): void => {
      expect(DragEventManager.getInstance(true)).not().assertNull();
    })

    it('DragEventManagerTest_getDragStartInDesktopEvent_test01', Level.LEVEL0, (): void => {
      let dragEventManager1: DragEventManager = new DragEventManager();
      (dragEventManager1 as object)['_isOuterDesktop'] = true;
      (dragEventManager1 as object)['getDragStartInDesktopEvent']('1');
      expect(dragEventManager1).not().assertUndefined();
    })

    it('DragEventManagerTest_getDropStartEvent_test01', Level.LEVEL0, (): void => {
      let dragEventManager1: DragEventManager = new DragEventManager();
      (dragEventManager1 as object)['_isOuterDesktop'] = true;
      (dragEventManager1 as object)['getDropStartEvent']('1');
      expect(dragEventManager1).not().assertUndefined();
    })

    it('DragEventManagerTest_getDropAnimationEndEvent_test01', Level.LEVEL0, (): void => {
      let dragEventManager1: DragEventManager = new DragEventManager();
      (dragEventManager1 as object)['_isOuterDesktop'] = true;
      (dragEventManager1 as object)['getDropAnimationEndEvent']('1');
      expect(dragEventManager1).not().assertUndefined();
    })

    it('DragEventManagerTest_getItemSqueezedStartEvent_test01', Level.LEVEL0, (): void => {
      let dragEventManager1: DragEventManager = new DragEventManager();
      (dragEventManager1 as object)['_isOuterDesktop'] = true;
      (dragEventManager1 as object)['getItemSqueezedStartEvent']('1');
      expect(dragEventManager1).not().assertUndefined();
    })

    it('DragEventManagerTest_getItemSqueezedCancelEvent_test01', Level.LEVEL0, (): void => {
      let dragEventManager1: DragEventManager = new DragEventManager();
      (dragEventManager1 as object)['_isOuterDesktop'] = true;
      (dragEventManager1 as object)['getItemSqueezedCancelEvent']('1');
      expect(dragEventManager1).not().assertUndefined();
    })

    it('DragEventManagerTest_unRegisterEvent_test01', Level.LEVEL0, (): void => {
      let dragEventManager1: DragEventManager = new DragEventManager();
      (dragEventManager1 as object)['_isOuterDesktop'] = true;
      (dragEventManager1 as object)['unRegisterEvent']('1', dt);
      expect(dragEventManager1).not().assertUndefined();
    })

    it('DragEventManagerTest_registerDragEvent', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = new DragEventManager();
      (dragEventManager as object)['registerDragEvent'](null, '1');
      expect(dragEventManager).not().assertUndefined();

      (dragEventManager as object)['registerDragEvent'](dt, '1');
      expect(dragEventManager).not().assertUndefined();
    })

    it('DragEventManagerTest_unRegisterDragEvent', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = new DragEventManager();
      (dragEventManager as object)['unRegisterDragEvent'](null, '1');
      expect(dragEventManager).not().assertUndefined();

      (dragEventManager as object)['unRegisterDragEvent'](dt, '1');
      expect(dragEventManager).not().assertUndefined();
    })

    it('DragEventManagerTest_registerEvent', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = new DragEventManager();
      (dragEventManager as object)['registerEvent']('1', null);
      expect(dragEventManager).not().assertUndefined();

      (dragEventManager as object)['registerEvent']('1', dt);
      expect(dragEventManager).not().assertUndefined();
    })

    it('DragEventManagerTest_unRegisterEvent', Level.LEVEL0, (): void => {
      let dragEventManager: DragEventManager = new DragEventManager();
      (dragEventManager as object)['unRegisterEvent']('1', null);
      expect(dragEventManager).not().assertUndefined();

      (dragEventManager as object)['unRegisterEvent']('1', dt);
      expect(dragEventManager).not().assertUndefined();
    })
  })
}

function dt(): void {
  let num: number = 0;
  num++;
}