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

import { BaseDragHandlerTest } from './ets/component/service/drag/BaseDragHandler.test';
import { CellAndSpanTest } from './ets/component/service/reorder/CellAndSpan.test';
import { ItemConfigurationTest } from './ets/component/service/reorder/ItemConfiguration.test';
import { ViewClusterTest } from './ets/component/service/reorder/ViewCluster.test';
import { GridOccupyStatusTest } from './ets/component/service/reorder/GridOccupyStatus.test';
import { CellLayoutDragDelegateTest } from './ets/component/service/reorder/CellLayoutDragDelegate.test';
import { WindowManagerTest } from './ets/component/manager/WindowManager.test';
import { DragEventManagerTest } from './ets/component/manager/DragEventManager.test';
import { DragExtraInfoTest } from './ets/component/service/drag/DragExtraInfo.test';
import { ShareDataManagerTest } from './ets/component/service/compomentdrag/common/share/ShareDataManager.test';
import { DragDataManagerTest } from './ets/component/service/compomentdrag/drag/manager/DragDataManager.test';
import { DragListenerManagerTest } from './ets/component/service/compomentdrag/drag/manager/DragListenerManager.test';
import { DragManagerTest } from './ets/component/service/compomentdrag/drag/manager/DragManager.test';
import { GridItemPositionUtilTest } from './ets/component/service/compomentdrag/utils/GridItemPositionUtil.test';
import { SqueezeEngineChainTest } from './ets/component/service/compomentdrag/squeeze/engine/SqueezeEngineChain.test';
import {
  SingleItemSqueezeEngineTest
} from './ets/component/service/compomentdrag/squeeze/engine/singleitem/SingleItemSqueezeEngine.test';
import {
  MultiItemSqueezeEngineTest
} from './ets/component/service/compomentdrag/squeeze/engine/multiitem/MultiItemSqueezeEngine.test';
import DragUtilsTest from './ets/component/service/compomentdrag/common/utils/DragUtils.test';


export default function ComponentDragTestSuite() {
  // 桌面编辑组测试用例
  ComponentsTestSuite();
}

export function ComponentsTestSuite() {
  BaseDragHandlerTest();
  CellAndSpanTest();
  ItemConfigurationTest();
  ViewClusterTest();
  GridOccupyStatusTest();
  CellLayoutDragDelegateTest();
  WindowManagerTest();
  DragEventManagerTest();
  DragExtraInfoTest();
  ShareDataManagerTest();
  DragUtilsTest();
  DragDataManagerTest();
  DragListenerManagerTest();
  DragManagerTest();
  GridItemPositionUtilTest();
  SqueezeEngineChainTest();
  SingleItemSqueezeEngineTest();
  MultiItemSqueezeEngineTest();
}