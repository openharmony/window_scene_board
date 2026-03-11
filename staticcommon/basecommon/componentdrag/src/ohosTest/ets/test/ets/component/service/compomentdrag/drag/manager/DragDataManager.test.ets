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
import { ShareDragStatus } from '../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDragStatus';
import { DragGridInfo, DragType } from '../../../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';
import { dragDataManager } from '../../../../../../../../../main/ets/service/compomentdrag/drag/manager/DragDataManager';

/**
 * DragDataManager DT测试套
 */
export function DragDataManagerTest() {
  describe('DragDataManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_DragDataManager', Level.LEVEL0, (): void => {
      let shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
      let shareDragStatus: ShareDragStatus = ShareDataManager.getInstance(ShareDragStatus, 'ShareDragStatus');
      let dragInfo: DragGridInfo = {
        dragItem: {
          row: 1,
          column: 1,
          area: [1, 1],
        },
        dragType: DragType.DRAG_FROM_DESKTOP,
      };

      shareDragInfo.setDragInfo(dragInfo);
      shareDragStatus.startDrag();
      expect(dragDataManager.isDragging()).assertEqual(shareDragStatus.isDragging());
      expect(dragDataManager.getDragItem()).assertEqual(dragInfo.dragItem);
      expect(dragDataManager.getDragType()).assertEqual(dragInfo.dragType);
    })
  })
}