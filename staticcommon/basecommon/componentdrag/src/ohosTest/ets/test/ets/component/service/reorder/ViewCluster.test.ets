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
import ViewCluster from '../../../../../../../main/ets/service/reorder/ViewCluster';
import ItemConfiguration from '../../../../../../../main/ets/service/reorder/ItemConfiguration';
import CellAndSpan from '../../../../../../../main/ets/service/reorder/CellAndSpan';
import List from '@ohos.util.List';
import { DragGridItem } from '../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';

/**
 * ViewCluster DT测试套
 */
export function ViewClusterTest() {
  describe('ViewClusterTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    const itemConfig = new ItemConfiguration(0, 0, 0, 0);
    const squeezeItem1: DragGridItem = {
      row: 1,
      column: 1,
      area: [],
    }
    const squeezeItem2: DragGridItem = {
      row: 1,
      column: 1,
      area: [],
    }
    const cellAndSpan1: CellAndSpan = new CellAndSpan(101, 2, 3, 4);
    const cellAndSpan2: CellAndSpan = new CellAndSpan(102, 3, 4, 5);
    const list: List<DragGridItem> = new List();
    const viewCluster = new ViewCluster(list, itemConfig, 10, 10);

    it('ViewCluster_create', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
    });

    it('ViewCluster_sort', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      let tempItem1: DragGridItem = itemConfig.getSortedViews().get(0);
      expect(itemConfig.getCellAndSpan(tempItem1).getCellX()).assertEqual(101);
      viewCluster.sortConfigurationForEdgePush(1);
      tempItem1 = itemConfig.getSortedViews().get(0);
      expect(itemConfig.getCellAndSpan(tempItem1).getCellX()).assertEqual(102);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      tempItem1 = itemConfig.getSortedViews().get(0);
      expect(itemConfig.getCellAndSpan(tempItem1).getCellX()).assertEqual(101);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      tempItem1 = itemConfig.getSortedViews().get(0);
      expect(itemConfig.getCellAndSpan(tempItem1).getCellX()).assertEqual(102);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      tempItem1 = itemConfig.getSortedViews().get(0);
      expect(itemConfig.getCellAndSpan(tempItem1).getCellX()).assertEqual(101);
    });

    it('ViewCluster_isViewTouchingEdge', Level.LEVEL0, (): void => {
      const squeezeItem3: DragGridItem = {
        row: 1,
        column: 1,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 1)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 1)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 2);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 3);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 3)).assertEqual(false);
    });

    it('ViewCluster_shift', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView', Level.LEVEL0, (): void => {
      const squeezeItem3: DragGridItem = {
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getCellAndSpan(itemConfig.getSortedViews().get(2)).getCellX()).assertEqual(1021);
    })

    it('ViewCluster_isContainView', Level.LEVEL0, (): void => {
      const squeezeItemOther: DragGridItem = {
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })
  })
}