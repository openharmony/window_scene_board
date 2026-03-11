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
import ItemConfiguration from '../../../../../../../main/ets/service/reorder/ItemConfiguration';
import CellAndSpan from '../../../../../../../main/ets/service/reorder/CellAndSpan';
import List from '@ohos.util.List';
import { RectItem } from '@ohos/basicutils';
import { DragGridItem } from '../../../../../../../main/ets/service/compomentdrag/common/type/CommonTypes';

/**
 * ItemConfiguration DT测试套
 */
export function ItemConfigurationTest() {
  describe('ItemConfigurationTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    const itemConfig: ItemConfiguration = new ItemConfiguration(0, 0, 0, 0);
    const SqueezeItem1: DragGridItem = {
      row: 1,
      column: 1,
      area: [],
    };
    const SqueezeItem2: DragGridItem = {
      row: 1,
      column: 1,
      area: [],
    };
    const SqueezeItem3: DragGridItem = {
      row: 1,
      column: 1,
      area: [],
    };
    const CellAndSpan1: CellAndSpan = new CellAndSpan(101, 2, 3, 4);
    const CellAndSpan2: CellAndSpan = new CellAndSpan(102, 3, 4, 5);
    const list: List<DragGridItem> = new List();
    const list2: List<DragGridItem> = new List();
    const outRect: RectItem = new RectItem(0, 0, 0, 0);

    it('ItemConfiguration_create', Level.LEVEL0, (): void => {
      itemConfig.setIsSolutionValid(true);
      expect(itemConfig.getIsSolutionValid()).assertTrue();
      // 添加两个元素
      itemConfig.add(SqueezeItem1, CellAndSpan1);
      itemConfig.add(SqueezeItem2, CellAndSpan2);
      const sortedViews = itemConfig.getSortedViews();
      expect(sortedViews.length).assertEqual(2);
    })

    it('ItemConfiguration_getIntersectingViewsTranslate', Level.LEVEL0, (): void => {
      let mTranslateViews = itemConfig.getIntersectingViewsTranslate();
      expect(mTranslateViews.size).assertEqual(0);
      itemConfig.setIntersectingViews(list);
      expect(itemConfig.getIntersectingGridLayout().size).assertEqual(0);
      list.add(SqueezeItem1);
      itemConfig.setIntersectingViews(list);
      expect(itemConfig.getIntersectingGridLayout().size).assertEqual(1);
      mTranslateViews = itemConfig.getIntersectingViewsTranslate();
      expect(mTranslateViews.size).assertEqual(1);
      expect(itemConfig.getCellAndSpan(SqueezeItem1).getCellX()).assertEqual(101);
      expect(itemConfig.getIntersectingViews().length).assertEqual(1);
    })

    it('ItemConfiguration_getBoundingRectForViews', Level.LEVEL0, (): void => {
      list2.add(SqueezeItem1);
      itemConfig.getBoundingRectForViews(list2, outRect);
      expect(outRect.left).assertEqual(101);
      list2.add(SqueezeItem2);
      itemConfig.getBoundingRectForViews(list2, outRect);
      expect(outRect.left).assertEqual(101);
      expect(outRect.top).assertEqual(2);
      list2.add(SqueezeItem3);
      itemConfig.getBoundingRectForViews(list2, outRect);
      expect(outRect.left).assertEqual(101);
      expect(outRect.top).assertEqual(2);
    })

    it('ItemConfiguration_save_restore', Level.LEVEL0, (): void => {
      itemConfig.restore();
      expect(CellAndSpan1.getCellX()).assertEqual(0);
      CellAndSpan1.setCellX(1001);
      itemConfig.save();
      itemConfig.restore();
      expect(CellAndSpan1.getCellX()).assertEqual(1001);
    })
  })
}