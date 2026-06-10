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
import { DragGridInfo } from '../../../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';
import { DragListener } from '../../../../../../../../../main/ets/service/compomentdrag/common/type/DragTypes';
import { dragListenerManager } from '../../../../../../../../../main/ets/service/compomentdrag/drag/manager/DragListenerManager';

/**
 * DragListenerManager DT测试套
 */
export function DragListenerManagerTest() {
  describe('DragListenerManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let res: number = 0;
    let listener1: DragListener = {
      dragStart: (dragInfo: DragGridInfo) => res++,
      dragEnd: (dragInfo: DragGridInfo) => res--,
    } as DragListener;
    let listener2: DragListener = {} as DragListener;
    let key: string = 'dt';

    it('test_DragListenerManager_notify1', Level.LEVEL0, (): void => {
      dragListenerManager.notifyDragStart(null, null);
      expect(res).assertEqual(0);
      dragListenerManager.notifyDragEnd(null, null);
      expect(res).assertEqual(0);
    })

    it('test_DragListenerManager_register', Level.LEVEL0, (): void => {
      expect(dragListenerManager.registerDragListener(null)).assertFalse();
      expect(dragListenerManager.registerDragListener(listener1)).assertTrue();
      expect(dragListenerManager.registerDragListener(listener1)).assertFalse();
      expect(dragListenerManager.registerDragListener(listener2)).assertTrue();
      expect(dragListenerManager.registerDragListener(listener1, key)).assertTrue();
      expect(dragListenerManager.registerDragListener(listener2, key)).assertTrue();
    })

    it('test_DragListenerManager_notify2', Level.LEVEL0, (): void => {
      dragListenerManager.notifyDragStart(null, key);
      expect(res).assertEqual(2);
      dragListenerManager.notifyDragEnd(null, key);
      expect(res).assertEqual(0);
    })

    it('test_DragListenerManager_unRegister', Level.LEVEL0, (): void => {
      expect(dragListenerManager.unregisterDragListener(null)).assertFalse();
      expect(dragListenerManager.unregisterDragListener(listener1)).assertTrue();
      expect(dragListenerManager.unregisterDragListener(listener2)).assertTrue();
      expect(dragListenerManager.unregisterDragListener(listener1)).assertFalse();
      expect(dragListenerManager.unregisterDragListener(listener1, key)).assertTrue();
    })
  })
}