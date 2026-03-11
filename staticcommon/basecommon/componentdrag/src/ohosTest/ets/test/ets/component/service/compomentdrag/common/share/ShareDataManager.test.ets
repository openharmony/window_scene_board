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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ShareDataManager } from '../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDataManager';
import { ShareDragInfo } from '../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDragInfo';
import { ShareDragLayout } from '../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDragLayout';
import { ShareDragStatus } from '../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDragStatus';
import { DragGridItem, DragGridInfo, DragGridLayout, DragType } from '../../../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';

/**
 * ShareDataManager DT测试套
 */
export function ShareDataManagerTest() {
  describe('ShareDataManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_ShareDataManager_ShareDragInfo', Level.LEVEL0, (): void => {
      let instance1: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
      let instance2: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
      expect(instance1).assertEqual(instance2);
      expect(instance1.getDragInfo()).assertUndefined();
      expect(instance1.getDragItem()).assertUndefined();
      expect(instance1.getDragType()).assertEqual(DragType.NOT_IN_DRAG);

      let dragInfo: DragGridInfo = {
        dragItem: {
          row: 1,
          column: 1,
          area: [1, 1],
        },
        dragType: DragType.DRAG_FROM_DESKTOP,
      }
      instance1.setDragInfo(dragInfo);
      expect(instance2.getDragItem()).assertEqual(dragInfo.dragItem);
      expect(instance2.getDragType()).assertEqual(dragInfo.dragType);
    })

    it('test_ShareDataManager_ShareDragLayout', Level.LEVEL0, (): void => {
      let instance1: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');
      let instance2: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');
      expect(instance1).assertEqual(instance2);
      expect(instance1.getGridLayout()).assertUndefined();
      expect(instance1.getGridParam()).assertUndefined();
      expect(instance1.getLayout()).assertUndefined();
      expect(instance1.equal({}, {})).assertUndefined();

      let dragItem: DragGridItem = {
        row: 1,
        column: 1,
        area: [1, 1],
      };
      let gridLayout: DragGridLayout = {
        gridParam: {
          paddingLeft: 1,
          paddingTop: 2,
          row: 3,
          column: 4,
          rowGap: 5,
          columnGap: 6,
          itemWidth: 7,
          itemHeight: 8,
          gridWidth: 9,
          gridHeight: 10,
        },
        layout: [dragItem],
        equal: (origin: DragGridItem, target: DragGridItem) => {
          return origin.row === target.row && origin.column === target.column &&
                  origin.area?.[0] === target.area?.[0] && origin.area?.[1] === target.area?.[1];
        },
      };
      instance1.setGridLayout(gridLayout);
      expect(instance2.getGridLayout()).assertEqual(gridLayout);
      expect(instance2.getGridParam()).assertEqual(gridLayout.gridParam);
      expect(instance2.getLayout()).assertEqual(gridLayout.layout);
      expect(instance2.equal(dragItem, dragItem)).assertTrue();
    })

    it('test_ShareDataManager_ShareDragStatus', Level.LEVEL0, (): void => {
      let instance1: ShareDragStatus = ShareDataManager.getInstance(ShareDragStatus, 'ShareDragStatus');
      let instance2: ShareDragStatus = ShareDataManager.getInstance(ShareDragStatus, 'ShareDragStatus');
      expect(instance1).assertEqual(instance2);
      instance1.startDrag();
      expect(instance2.isDragging()).assertTrue();
      instance1.stopDrag();
      expect(instance2.isDragging()).assertFalse();
    })
  })
}