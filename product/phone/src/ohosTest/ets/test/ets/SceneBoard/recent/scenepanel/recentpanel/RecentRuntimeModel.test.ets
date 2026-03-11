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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import {
  RecentViewParam,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBScenePanelManager,
  SCBSceneSession,
  SCBScreenProperty
} from '@ohos/windowscene';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { recentLayoutConfigInstance } from '@ohos/recents';
import { RecentLayoutManager } from '@ohos/phonebase/src/main/ets/SceneBoard/recent/common/RecentLayoutManager';
import {
  recentRuntimeInstance,
  RecentRuntimeModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/recent/scenepanel/recentpanel/RecentRuntimeModel';
import screenSessionManager from '@ohos.screenSessionManager';

export default function RecentRuntimeModelTest() {
  describe('RecentRuntimeModelTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let screenProp: screenSessionManager.ScreenProperty = {
      rotation: 1,
      bounds: {
        left: 1,
        top: 1,
        width: 40,
        height: 200,
        radius: 1,
      },
      fakeBounds: {
        left: 0,
        top: 0,
        width: 0,
        height: 0,
        radius: 0
      },
      isFakeInUse: false,
      rsId: 0,
    };
    scbScreenProperty.update(screenProp);
    let scenePanelManager: SCBScenePanelManager = SCBScenePanelManager.getInstance(scbScreenProperty);
    let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
    let primarySession: SCBSceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
    let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    let scbSceneContainer: SCBSceneContainerSession = new SCBSceneContainerSession(primarySession, new SCBScreenProperty());
    let recentLayoutConfig = recentLayoutConfigInstance;
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));
    totalContainerSessionList.add(new SCBSceneContainerSession(primarySession, new SCBScreenProperty()));

    it('RecentRuntimeModel_test_init_01', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentRuntimeInstance.init(containerSessionList);
      expect(recentRuntimeInstance.notRemovingSessionList).not().assertUndefined();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentRuntimeModel_test_init_02', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      scbSceneContainer.sessionData.pendingRemove = false;
      totalContainerSessionList.add(scbSceneContainer);
      recentRuntimeInstance.init(totalContainerSessionList);
      expect(recentRuntimeInstance.notRemovingSessionList).not().assertUndefined();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentRuntimeModel_test_init_03', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(false);
      scbSceneContainer.sessionData.pendingRemove = true;
      totalContainerSessionList.add(scbSceneContainer);
      recentRuntimeInstance.init(totalContainerSessionList);
      expect(recentRuntimeInstance.notRemovingSessionList).not().assertUndefined();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentRuntimeModel_test_init_04', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isNeedMultiRowLayout: Function = mocker.mockFunc(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
      when(isNeedMultiRowLayout)(ArgumentMatchers.any).afterReturn(true);
      scbSceneContainer.sessionData.pendingRemove = true;
      totalContainerSessionList.add(scbSceneContainer);
      recentRuntimeInstance.init(totalContainerSessionList);
      expect(recentRuntimeInstance.notRemovingSessionList).not().assertUndefined();
      mocker.ignoreMock(recentLayoutConfig, recentLayoutConfig.isNeedMultiRowLayout);
    })

    it('RecentRuntimeModel_test_update_01', 0, (): void => {
      let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      recentRuntimeInstance.update(containerSessionList);
      expect(containerSessionList).not().assertUndefined();
    })

    it('RecentRuntimeModel_test_update_02', 0, (): void => {
      recentRuntimeInstance.update(totalContainerSessionList);
      expect(totalContainerSessionList).not().assertUndefined();
    })

    it('RecentRuntimeModel_test_initContainerCountsShowInRecent_01', 0, (): void => {
      recentRuntimeInstance.initContainerCountsShowInRecent();
      expect(totalContainerSessionList).not().assertUndefined();
    })

    it('RecentRuntimeModel_test_touchContainerSession_01', 0, (): void => {
      let containerSession = recentRuntimeInstance.touchContainerSession;
      expect(totalContainerSessionList).not().assertUndefined();
    })

    it('RecentRuntimeModel_test_autoCenterContainerSession_01', 0, (): void => {
      let containerSession = recentRuntimeInstance.autoCenterContainerSession;
      expect(totalContainerSessionList).not().assertUndefined();
    })

    it('getAbsoluteIndexByColumn_test01', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock: MockKit = new MockKit();
      let mockFun: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(false);
      recentRuntimeInstance.getAbsoluteIndexByColumn(2);
      expect(totalContainerSessionList).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.clearAll();
    })

    it('getAbsoluteIndexByColumn_test02', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock: MockKit = new MockKit();
      let mockFun: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      recentRuntimeInstance.getAbsoluteIndexByColumn(2);
      expect(totalContainerSessionList).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.clearAll();
    })

    it('getAbsoluteIndexByColumn_test03', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock: MockKit = new MockKit();
      let mockFun: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      recentRuntimeInstance.getAbsoluteIndexByColumn(3);
      expect(totalContainerSessionList).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.clearAll();
    })

    it('getAbsoluteIndexByColumn_test04', 0, (): void => {
      let totalContainerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let mock: MockKit = new MockKit();
      let mockFun: Function =
        mock.mockFunc(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      when(mockFun)().afterReturn(true);
      recentRuntimeInstance.getAbsoluteIndexByColumn(4);
      expect(totalContainerSessionList).not().assertUndefined();
      mock.ignoreMock(recentLayoutConfigInstance, recentLayoutConfigInstance.isNeedMultiRowLayout);
      mock.clearAll();
    })

    it('touchEventEqualTo_test01', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = null;
      (recentRuntimeInstance as object)['touchEventEqualTo']();
      expect(touchEvent).not().assertUndefined();
    })

    it('touchEventEqualTo_test02', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = null;
      recentRuntimeInstance.touchEventEqualTo(touchEvent);
      expect(touchEvent).not().assertUndefined();
    })

    it('touchEventEqualTo_test03', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = touchEvent;
      recentRuntimeInstance.touchEventEqualTo(touchEvent);
      expect(touchEvent).not().assertUndefined();
    })

    it('touchEventEqualTo_test04', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      let touchEvent1: TouchEvent = {
        type: TouchType.Up,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = touchEvent1;
      recentRuntimeInstance.touchEventEqualTo(touchEvent);
      expect(touchEvent).not().assertUndefined();
    })

    it('touchEventEqualTo_test05', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 5,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 2,
          displayX: 6,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      let touchEvent1: TouchEvent = {
        type: TouchType.Up,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = touchEvent1;
      recentRuntimeInstance.touchEventEqualTo(touchEvent);
      expect(touchEvent).not().assertUndefined();
    })

    it('touchEventEqualTo_test06', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 5,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 23,
          y: 54
        }, {
          type: TouchType.Down,
          id: 2,
          displayX: 6,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      let touchEvent1: TouchEvent = {
        type: TouchType.Up,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = touchEvent1;
      recentRuntimeInstance.touchEventEqualTo(touchEvent);
      expect(touchEvent).not().assertUndefined();
    })

    it('touchEventEqualTo_test07', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 5,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 2,
          displayX: 6,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      let touchEvent1: TouchEvent = {
        type: TouchType.Up,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 13,
          y: 400
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = touchEvent1;
      recentRuntimeInstance.touchEventEqualTo(touchEvent);
      expect(touchEvent).not().assertUndefined();
    })

    it('touchEventEqualTo_test08', 0, (): void => {
      let touchEvent: TouchEvent = {
        type: TouchType.Down,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 5,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 2,
          displayX: 6,
          displayY: 4,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 33,
          y: 14
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      let touchEvent1: TouchEvent = {
        type: TouchType.Up,
        touches: [{
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 3,
          y: 4
        }, {
          type: TouchType.Down,
          id: 1,
          displayX: 2,
          displayY: 3,
          windowX: 4,
          windowY: 5,
          screenX: 1,
          screenY: 2,
          x: 13,
          y: 400
        }],
        changedTouches: [],
        stopPropagation: (): void => {
          throw new Error('Function not implemented.');
        },
        getHistoricalPoints: (): HistoricalPoint[] => {
          throw new Error('Function not implemented.');
        },
        preventDefault: (): void => {
          throw new Error('Function not implemented.');
        },
        target: {
          area: {
            width: 2,
            height: 2,
            position: {
              x: 1, y: 2
            },
            globalPosition: {
              x: 1, y: 2
            },
          }
        },
        timestamp: 0,
        source: SourceType.Unknown,
        pressure: 0,
        tiltX: 0,
        tiltY: 0,
        sourceTool: SourceTool.Unknown
      };
      recentRuntimeInstance.touchEvent = touchEvent1;
      recentRuntimeInstance.touchEventEqualTo(touchEvent);
      expect(touchEvent).not().assertUndefined();
    })
  })
}