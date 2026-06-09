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
  ShareDataManager
} from '../../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDataManager';
import {
  ShareDragInfo
} from '../../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDragInfo';
import {
  ShareDragLayout
} from '../../../../../../../../../../main/ets/service/compomentdrag/common/share/ShareDragLayout';
import {
  MultiItemSqueezeEngine
} from '../../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/multiitem/MultiItemSqueezeEngine';
import { DragGridInfo, DragGridItem, DragGridLayout, DragType } from '../../../../../../../../../../main/ets/TsIndex';

/**
 * MultiItemSqueezeEngine DT测试套
 */
export function MultiItemSqueezeEngineTest() {
  describe('MultiItemSqueezeEngineTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    // 1、单屏场景，桌面网格为2行4列，1*1图标位于【0,0】，2*2文件夹位于【0,1】，挤位成功
    it('test_MultiItemSqueezeEngine_computeSqueezeResult1', Level.LEVEL0, (): void => {
      let dragItem1: DragGridItem = {
        row: 0,
        column: 0,
        area: [1, 1],
      };
      let dragItem2: DragGridItem = {
        row: 0,
        column: 1,
        area: [2, 2],
      };
      let dragInfo: DragGridInfo = {
        dragItem: dragItem1,
        dragType: DragType.DRAG_FROM_DESKTOP,
      };
      let gridLayout: DragGridLayout = {
        gridParam: {
          paddingLeft: 0,
          paddingTop: 0,
          row: 2,
          column: 4,
          rowGap: 0,
          columnGap: 0,
          itemWidth: 1,
          itemHeight: 1,
          gridWidth: 4,
          gridHeight: 2,
        },
        layout: [dragItem1, dragItem2],
        equal: (origin: DragGridItem, target: DragGridItem) => {
          return true;
        },
      };
      let shareDragLayout: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');
      shareDragLayout.setGridLayout(gridLayout);
      let shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
      shareDragInfo.setDragInfo(dragInfo);

      let engine1 = new MultiItemSqueezeEngine();
      let itemList1 = engine1.computeSqueezeResult(1.2, 0.2, true);
      expect(itemList1.size).assertEqual(1);
    })

    // 2、1*1的元素，无法使用MultiItemSqueezeEngine算法挤位
    it('test_MultiItemSqueezeEngine_computeSqueezeResult2', Level.LEVEL0, (): void => {
      let dragItem: DragGridItem = {
        row: 0,
        column: 0,
        area: [1, 1],
      };
      let dragInfo: DragGridInfo = {
        dragItem: dragItem,
        dragType: DragType.DRAG_FROM_DESKTOP,
      };
      let gridLayout: DragGridLayout = {
        gridParam: {
          paddingLeft: 0,
          paddingTop: 0,
          row: 1,
          column: 1,
          rowGap: 0,
          columnGap: 0,
          itemWidth: 1,
          itemHeight: 1,
          gridWidth: 1,
          gridHeight: 1,
        },
        layout: [dragItem],
        equal: (origin: DragGridItem, target: DragGridItem) => {
          return true;
        },
      };
      let shareDragLayout: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');
      shareDragLayout.setGridLayout(gridLayout);
      let shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
      shareDragInfo.setDragInfo(dragInfo);

      let engine1 = new MultiItemSqueezeEngine();
      let itemList1 = engine1.computeSqueezeResult(0.2, 0.2, true);
      expect(itemList1.size).assertEqual(0);
    })
  })
}