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
import List from '@ohos.util.List';
import { CellAndSpan, ItemConfiguration, SqueezeItem } from '@ohos/componentdrag';
import { ViewCluster } from '@ohos/componentdrag';

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
    const squeezeItem1: SqueezeItem = {
      key: 0,
      row: 1,
      column: 1,
      area: [],
    }
    const squeezeItem2: SqueezeItem = {
      key: 1,
      row: 1,
      column: 1,
      area: [],
    }
    const cellAndSpan1: CellAndSpan = new CellAndSpan(101, 2, 3, 4);
    const cellAndSpan2: CellAndSpan = new CellAndSpan(102, 3, 4, 5);
    const list: List<SqueezeItem> = new List();
    const viewCluster = new ViewCluster(list, itemConfig, 10, 10);

    it('ViewCluster_create', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem2', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create01', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort01', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge01', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift01', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView01', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition01', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView01', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added01', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem201', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input01', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input01', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input01', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input01', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input01', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input01', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input01', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create02', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort02', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge02', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift02', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView02', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition02', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView02', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added02', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem202', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input02', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input02', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input02', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input02', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input02', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input02', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input02', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create03', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort03', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge03', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift03', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView03', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition03', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView03', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added03', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem203', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input03', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input03', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input03', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input03', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input03', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input03', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input03', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create04', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort04', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge04', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift04', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView04', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition04', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView04', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added04', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem204', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input04', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input04', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input04', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input04', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input04', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input04', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input04', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create05', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort05', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge05', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift05', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView05', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition05', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView05', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added05', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem205', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input05', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input05', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input05', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input05', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input05', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input05', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input05', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create06', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort06', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge06', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift06', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView06', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition06', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView06', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added06', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem206', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input06', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input06', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input06', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input06', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input06', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input06', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input06', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create07', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort07', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge07', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift07', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView07', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition07', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView07', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added07', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem207', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input07', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input07', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input07', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input07', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input07', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input07', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input07', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });

    it('ViewCluster_create08', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem1)).assertEqual(false);
      viewCluster.addView(squeezeItem1);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem1.key);
    });

    it('ViewCluster_sort08', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 3);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge08', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
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

    it('ViewCluster_shift08', Level.LEVEL0, (): void => {
      viewCluster.shift(1);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 2);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 1);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 3);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView08', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 1,
        column: 1,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition08', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView08', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added08', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 1);
    });

    it('ViewCluster_create_by_squeezeItem208', Level.LEVEL0, (): void => {
      expect(viewCluster.isContainView(squeezeItem2)).assertEqual(true);
      viewCluster.addView(squeezeItem2);
      expect(viewCluster.getBoundingRect().left).assertEqual(0);
      expect(viewCluster.getClusterViews().length).assertEqual(1);
      expect(viewCluster.getClusterViews().get(0).key).assertEqual(squeezeItem2.key);
    });

    it('ViewCluster_sort_valid_input08', Level.LEVEL0, (): void => {
      itemConfig.add(squeezeItem1, cellAndSpan1);
      itemConfig.add(squeezeItem2, cellAndSpan2);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 5);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(1);
      viewCluster.sortConfigurationForEdgePush(1 << 6);
      expect(itemConfig.getSortedViews().get(0).key).assertEqual(0);
    });

    it('ViewCluster_isViewTouchingEdge_valid_input08', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 4,
        row: 2,
        column: 2,
        area: [],
      };
      expect(viewCluster.isViewTouchingEdge(squeezeItem3, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 5)).assertEqual(false);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 4)).assertEqual(false);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 5);
      viewCluster.isViewTouchingEdge(squeezeItem1, 1 << 6);
      expect(viewCluster.isViewTouchingEdge(squeezeItem1, 7)).assertEqual(false);
    });

    it('ViewCluster_shift_valid_input08', Level.LEVEL0, (): void => {
      viewCluster.shift(5);
      expect(cellAndSpan1.getCellX()).assertEqual(100);
      viewCluster.shift(1 << 5);
      expect(cellAndSpan1.getCellX()).assertEqual(101);
      viewCluster.shift(1 << 4);
      expect(cellAndSpan1.getCellY()).assertEqual(1);
      viewCluster.shift(1 << 6);
      expect(cellAndSpan1.getCellY()).assertEqual(2);
    })

    it('ViewCluster_addView_valid_input08', Level.LEVEL0, (): void => {
      const squeezeItem3: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      viewCluster.addView(squeezeItem3);
      viewCluster.shift(1);
      const cellAndSpan3: CellAndSpan = new CellAndSpan(1021, 6, 7, 8);
      itemConfig.add(squeezeItem3, cellAndSpan3);
      expect(itemConfig.getSortedViews().get(2).key).assertEqual(3);
    })

    it('ViewCluster_updatePosition_valid_input08', Level.LEVEL0, (): void => {
      const list: List<SqueezeItem> = new List();
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      list.add(squeezeItemOther);
      new ViewCluster(list, itemConfig, 10, 10);
      viewCluster.updatePosition(list);
      expect(viewCluster.getClusterViews().get(0).row).assertEqual(2);
      expect(viewCluster.getClusterViews().get(0).column).assertEqual(100);
      expect(squeezeItemOther.row).assertEqual(6);
      expect(squeezeItemOther.column).assertEqual(1021);
    })

    it('ViewCluster_isContainView_valid_input08', Level.LEVEL0, (): void => {
      const squeezeItemOther: SqueezeItem = {
        key: 3,
        row: 99999,
        column: 99999,
        area: [],
      }
      expect(viewCluster.isContainView(squeezeItemOther)).assertEqual(false);
    })

    it('ViewCluster_sort_added_valid_input08', Level.LEVEL0, (): void => {
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
      itemConfig.add({
        key: 3,
        row: 1230,
        column: 12340,
        area: [],
      }, null);
      viewCluster.sortConfigurationForEdgePush(1 << 4);
    });
  })
}