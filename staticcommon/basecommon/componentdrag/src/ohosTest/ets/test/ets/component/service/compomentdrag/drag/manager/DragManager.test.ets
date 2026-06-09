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
import { DragGridInfo, DragCallbackParams, DragType } from '../../../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';
import { DragManagerMode, DragParams } from '../../../../../../../../../main/ets/service/compomentdrag/common/type/DragTypes';
import { DragManager } from '../../../../../../../../../main/ets/service/compomentdrag/drag/manager/DragManager';
import { DragEvent } from 'DragControllerParam';

/**
 * DragManager DT测试套
 */
export function DragManagerTest() {
  describe('DragManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    let res: number = 0;
    let event: DragEvent = {
      getPreviewRect: ((): Rectangle => {
        return {
          x: 0,
          y: 0,
          width: 0,
          height: 0,
        };
      })
    } as DragEvent;
    let dragInfo: DragGridInfo = {
      dragItem: {
        row: 1,
        column: 1,
        area: [1, 1],
      },
      dragType: DragType.DRAG_FROM_DESKTOP,
    };

    let itemParams: DragParams = {
      mode: DragManagerMode.ITEM,
      dragInfo: dragInfo,
      itemDragStartCallback: (params: DragCallbackParams) => res++,
      itemDragEndCallback: (params: DragCallbackParams) => res--,
    };
    let areaParams: DragParams = {
      mode: DragManagerMode.AREA,
      areaDragEnterCallback: (params: DragCallbackParams) => res += 2,
      areaDragLeaveCallback: (params: DragCallbackParams) => res -= 2,
      areaDragDropCallback: (params: DragCallbackParams) => res -= 2,
    }

    it('test_DragManager_constructor', Level.LEVEL0, (): void => {
      expect(DragManager.builder(null)).assertNull();
      expect(DragManager.builder(itemParams)).not().assertNull();
      expect(DragManager.builder(areaParams)).not().assertNull();
    })

    it('test_DragManager_without_extraParams', Level.LEVEL0, (): void => {
      res = 0;
      let itemDragManager: DragManager = DragManager.builder(itemParams);
      let areaDragManager: DragManager = DragManager.builder(areaParams);
      itemDragManager.start(event);
      expect(res).assertEqual(1);
      areaDragManager.enter(event);
      expect(res).assertEqual(3);
      areaDragManager.leave(event);
      expect(res).assertEqual(1);
      areaDragManager.drop(event);
      expect(res).assertEqual(-1);
      itemDragManager.end(event);
      expect(res).assertEqual(-2);

      let itemEnterFunc: Function = () => itemDragManager.enter(event);
      expect(itemEnterFunc()).not().assertFail();
      let itemLeaveFunc: Function = () => itemDragManager.leave(event);
      expect(itemLeaveFunc()).not().assertFail();
      let itemDropFunc: Function = () => itemDragManager.drop(event);
      expect(itemDropFunc()).not().assertFail();

      let areaStartFunc: Function = () => areaDragManager.start(event);
      expect(areaStartFunc()).not().assertFail();
      let areaEndFunc: Function = () => areaDragManager.end(event);
      expect(areaEndFunc()).not().assertFail();
    })

    it('test_DragManager_with_extraParams', Level.LEVEL0, (): void => {
      res = 0;
      let extraParams: string = 'dt';
      let itemDragManager: DragManager = DragManager.builder(itemParams);
      let areaDragManager: DragManager = DragManager.builder(areaParams);
      itemDragManager.start(event, extraParams);
      expect(res).assertEqual(1);
      areaDragManager.enter(event, extraParams);
      expect(res).assertEqual(3);
      areaDragManager.leave(event, extraParams);
      expect(res).assertEqual(1);
      areaDragManager.drop(event, extraParams);
      expect(res).assertEqual(-1);
      itemDragManager.end(event, extraParams);
      expect(res).assertEqual(-2);

      let itemEnterFunc: Function = () => itemDragManager.enter(event, extraParams);
      expect(itemEnterFunc()).not().assertFail();
      let itemLeaveFunc: Function = () => itemDragManager.leave(event, extraParams);
      expect(itemLeaveFunc()).not().assertFail();
      let itemDropFunc: Function = () => itemDragManager.drop(event, extraParams);
      expect(itemDropFunc()).not().assertFail();

      let areaStartFunc: Function = () => areaDragManager.start(event, extraParams);
      expect(areaStartFunc()).not().assertFail();
      let areaEndFunc: Function = () => areaDragManager.end(event, extraParams);
      expect(areaEndFunc()).not().assertFail();
    })
  })
}