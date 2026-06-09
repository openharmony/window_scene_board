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
  SqueezeEngineType
} from '../../../../../../../../../../main/ets/service/compomentdrag/common/type/SqueezeTypes';
import {
  EngineFactory
} from '../../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/EngineFactory';
import {
  AutoSingleItemSqueezeEngine
} from '../../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/singleitem/AutoSingleItemSqueezeEngine';
import {
  BackwardSingleItemSqueezeEngine
} from '../../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/singleitem/BackwardSingleItemSqueezeEngine';
import {
  ForwardSingleItemSqueezeEngine
} from '../../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/singleitem/ForwardSingleItemSqueezeEngine';
import {
  SqueezeEngineChain
} from '../../../../../../../../../../main/ets/service/compomentdrag/squeeze/engine/SqueezeEngineChain';
import { DragGridInfo, DragGridItem, DragGridLayout, DragType } from '../../../../../../../../../../main/ets/TsIndex';

/**
 * SingleItemSqueezeEngine DT测试套
 */
export function SingleItemSqueezeEngineTest() {
  describe('SingleItemSqueezeEngineTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    // 1、部分挤位参数无效，计算挤位结果
    it('test_SingleItemSqueezeEngine_computeSqueezeResult1', Level.LEVEL0, (): void => {
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
        layout: [{}],
        equal: (origin: DragGridItem, target: DragGridItem) => {
          return true;
        },
      };
      let shareDragLayout: ShareDragLayout = ShareDataManager.getInstance(ShareDragLayout, 'ShareDragLayout');
      shareDragLayout.setGridLayout(gridLayout);
      let shareDragInfo: ShareDragInfo = ShareDataManager.getInstance(ShareDragInfo, 'ShareDragInfo');
      expect(shareDragInfo.getDragItem()).assertUndefined();

      let engineType = SqueezeEngineType.AUTO_SINGLE_ITEM_SQUEEZE;
      let engine = new BackwardSingleItemSqueezeEngine();
      EngineFactory.register(engineType, engine);
      let chain = new SqueezeEngineChain(true);
      chain.addSqueezeEngineType(engineType);
      let itemList = chain.getSqueezeResult(0, 0);
      expect(itemList.size).assertEqual(0);
    })

    // 2、桌面网格为一行一列，且网格上有元素，最终挤位失败
    it('test_SingleItemSqueezeEngine_computeSqueezeResult2', Level.LEVEL0, (): void => {
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

      // 后向挤位
      let engine1 = new AutoSingleItemSqueezeEngine();
      let itemList1 = engine1.computeSqueezeResult(0.2, 0.2, true);
      expect(itemList1.size).assertEqual(0);
      let itemList2 = engine1.computeSqueezeResult(0.2, 0.2, false);
      expect(itemList2.size).assertEqual(0);
      let engine2 = new BackwardSingleItemSqueezeEngine();
      let itemList3 = engine2.computeSqueezeResult(0.2, 0.2, true);
      expect(itemList3.size).assertEqual(0);
      let itemList4 = engine2.computeSqueezeResult(0.2, 0.2, false);
      expect(itemList4.size).assertEqual(0);

      // 前向挤位
      let engine3 = new AutoSingleItemSqueezeEngine();
      let itemList5 = engine3.computeSqueezeResult(0.8, 0.8, true);
      expect(itemList5.size).assertEqual(0);
      let itemList6 = engine3.computeSqueezeResult(0.8, 0.8, false);
      expect(itemList6.size).assertEqual(0);
      let engine4 = new ForwardSingleItemSqueezeEngine();
      let itemList7 = engine4.computeSqueezeResult(0.8, 0.8, true);
      expect(itemList7.size).assertEqual(0);
      let itemList8 = engine4.computeSqueezeResult(0.8, 0.8, false);
      expect(itemList8.size).assertEqual(0);
    })

    // 3、桌面网格为两行五列，图标位于【0,1】，2*2的文件夹左上角位于【0，2】
    it('test_SingleItemSqueezeEngine_computeSqueezeResult3', Level.LEVEL0, (): void => {
      let dragItem1: DragGridItem = {
        row: 0,
        column: 1,
        area: [1, 1],
      };
      let dragItem2: DragGridItem = {
        row: 0,
        column: 2,
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
          column: 5,
          rowGap: 0,
          columnGap: 0,
          itemWidth: 1,
          itemHeight: 1,
          gridWidth: 5,
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

      // 后向挤位
      let engineType1 = SqueezeEngineType.AUTO_SINGLE_ITEM_SQUEEZE;
      let engine1 = new AutoSingleItemSqueezeEngine();
      EngineFactory.register(engineType1, engine1);
      let chain = new SqueezeEngineChain(true);
      chain.addSqueezeEngineType(engineType1);
      let itemList1 = chain.getSqueezeResult(1.2, 0.2);
      expect(itemList1.size).assertEqual(1);
      let itemList2 = engine1.computeSqueezeResult(1.2, 0.2, false);
      expect(itemList2.size).assertEqual(1);

      // 前向挤位
      let itemList3 = engine1.computeSqueezeResult(1.8, 0.8, true);
      expect(itemList3.size).assertEqual(1);
      let itemList4 = engine1.computeSqueezeResult(1.8, 0.8, false);
      expect(itemList4.size).assertEqual(1);
    })
  })
}