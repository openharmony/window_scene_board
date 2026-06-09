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
import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/TsIndex';

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { scbEventExclusiveManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  DockType,
  GestureDockMode } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import GestureDockAppItemViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockappitem/viewmodel/viewdata/GestureDockAppItemViewDataMgr';
import GestureDockAppItemViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockappitem/viewmodel/viewevent/GestureDockAppItemViewEventMgr';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';

let gestureInfo = {
  isSystemGesture: true
} as GestureInfo;

let baseGestureEvent = {
  fingerList: [
    {
      id: 0,
      globalX: 0,
      globalY: 0,
      localX: 0,
      localY: 0,
      displayX: 0,
      displayY: 0
    }
  ]
} as BaseGestureEvent;

let dragEvent = {
  getWindowX: (() => {
    return 0;
  }),
  getWindowY: (() => {
    return 0;
  }),
} as DragEvent;

const gestureEvent = {
  repeat: false,
  fingerList: [],
  offsetX: 0,
  offsetY: 0,
  angle: 0,
  speed: 0,
  scale: 0,
  pinchCenterX: 0,
  pinchCenterY: 0,
  velocityX: 0,
  velocityY: 0,
  velocity: 0,
  timestamp: 0,
  source: SourceType.Unknown,
  pressure: 0,
  tiltX: 0,
  tiltY: 0,
  sourceTool: SourceTool.Unknown,
  target: {
    area: {
      width: 0, height: 0, position: { x: 0, y: 0 }, globalPosition: { x: 0, y: 0 }
    }
  }
} as GestureEvent;

export default function GestureDockAppItemViewEventMgrTest() {
  describe('GestureDockAppItemViewEventMgrTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('GestureDockAppItemViewEventMgr_deleteImageClick_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(viewDataMgr.deleteImageClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    });

    it('GestureDockAppItemViewEventMgr_deleteImageClick_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(viewDataMgr.deleteImageClick() === undefined).assertTrue();
      mocker.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      done();
    });

    it('GestureDockAppItemViewEventMgr_dockItemVisible_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      expect((viewDataMgr as object)['dockItemVisible'](true) === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_dockItemVisible_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      expect((viewDataMgr as object)['dockItemVisible'](false) === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_updateItemOpacity_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.appItemParam.alpha = 1;
      expect((viewDataMgr as object)['updateItemOpacity']() === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_updateItemOpacity_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.appItemParam.alpha = 0;
      expect((viewDataMgr as object)['updateItemOpacity']() === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_deleteAppEvent_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      try{
        let item = new GestureDockItemInfo();
        AppStorage.set('gestureDockList', [item]);
        viewDataMgr.viewDataMgr.gestureDockItemInfo = item;
        expect((viewDataMgr as object)['deleteAppEvent'](10) === undefined).assertTrue();
      }catch(e){
      }
      done();
    });

    it('GestureDockAppItemViewEventMgr_deleteAppEvent_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      try{
        let item = new GestureDockItemInfo();
        item.bundleName = 'testBundle';
        item.appIndex = 1;
        AppStorage.set('gestureDockList', [item]);
        viewDataMgr.viewDataMgr.gestureDockItemInfo = item;
        expect((viewDataMgr as object)['deleteAppEvent'](0) === undefined).assertTrue();
      }catch(e){
      }
      done();
    });

    it('GestureDockAppItemViewEventMgr_onScreenOn_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.appItemParam.visible = Visibility.Visible;
      expect((viewDataMgr as object)['onScreenOn']() === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_onScreenOn_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.appItemParam.visible = Visibility.Hidden;
      expect((viewDataMgr as object)['onScreenOn']() === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_dockItemDropAnimation_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.viewDataMgr.gestureDockItemInfo.bundleName = '';
      expect((viewDataMgr as object)['dockItemDropAnimation']('test') === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_dockItemDropAnimation_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.viewDataMgr.gestureDockItemInfo.bundleName = 'test';
      expect((viewDataMgr as object)['dockItemDropAnimation']('test') === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_dockItemMoveAnimation_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      try {
        let item = new GestureDockItemInfo();
        AppStorage.set('gestureDockList', [item]);
        viewDataMgr.viewDataMgr.gestureDockItemInfo = item;
        expect((viewDataMgr as object)['dockItemMoveAnimation'](10) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    });

    it('GestureDockAppItemViewEventMgr_dockItemMoveAnimation_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      try {
        let item = new GestureDockItemInfo();
        item.bundleName = 'testBundle';
        item.appIndex = 1;
        AppStorage.set('gestureDockList', [item]);
        viewDataMgr.viewDataMgr.gestureDockItemInfo = item;
        expect((viewDataMgr as object)['dockItemMoveAnimation'](0) === undefined).assertTrue();
      } catch (e) {
      }
      done();
    });

    it('GestureDockAppItemViewEventMgr_registerEventhub_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)().afterReturn(true);
      expect((viewDataMgr as object)['registerEventhub']() === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    });

    it('GestureDockAppItemViewEventMgr_registerEventhub_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)().afterReturn(false);
      viewDataMgr.viewDataMgr.dockType = DockType.RECENT;
      expect((viewDataMgr as object)['registerEventhub']() === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    });

    it('GestureDockAppItemViewEventMgr_registerEventhub_3', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)().afterReturn(false);
      viewDataMgr.viewDataMgr.dockType = DockType.RESIDENT;
      expect((viewDataMgr as object)['registerEventhub']() === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    });

    it('GestureDockAppItemViewEventMgr_unRegisterEventhub_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)().afterReturn(true);
      expect((viewDataMgr as object)['unRegisterEventhub']() === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    });

    it('GestureDockAppItemViewEventMgr_unRegisterEventhub_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)().afterReturn(false);
      expect((viewDataMgr as object)['unRegisterEventhub']() === undefined).assertTrue();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      done();
    });

    it('GestureDockAppItemViewEventMgr_longPressGestureEvent_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc)().afterReturn(true);
      expect((viewDataMgr as object)['longPressGestureEvent'].onLongPressPreGatherActionEnd(gestureEvent) === undefined)
        .assertTrue();
      expect((viewDataMgr as object)['longPressGestureEvent'].onLongPressVibrateAction(gestureEvent) === undefined)
        .assertTrue();
      expect((viewDataMgr as object)['longPressGestureEvent'].onLongPressVibrateActionCancel(gestureEvent) ===
        undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_longPressGestureEvent_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc)().afterReturn(false);
      expect((viewDataMgr as object)['longPressGestureEvent'].onLongPressPreGatherActionEnd(gestureEvent) === undefined)
        .assertTrue();
      expect((viewDataMgr as object)['longPressGestureEvent'].onLongPressVibrateAction(gestureEvent) === undefined)
        .assertTrue();
      expect((viewDataMgr as object)['longPressGestureEvent'].onLongPressVibrateActionCancel(gestureEvent) ===
        undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconGestureJudge_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      expect((viewDataMgr as object)['appIconGestureJudge'].onGestureJudgeBegin(gestureInfo, baseGestureEvent) !==
        undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconGestureJudge_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc2: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc2)().afterReturn(true);
      viewDataMgr.viewDataMgr.dockType = DockType.RECENT;
      expect((viewDataMgr as object)['appIconGestureJudge'].onGestureJudgeBegin(gestureInfo, baseGestureEvent) !==
        undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconGestureJudge_3', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      when(mockFunc1)().afterReturn(false);
      let mockFunc2: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc2)().afterReturn(false);
      expect((viewDataMgr as object)['appIconGestureJudge'].onGestureJudgeBegin(gestureInfo, baseGestureEvent) !==
        undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconDragEvent_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc)().afterReturn(true);
      expect((viewDataMgr as object)['appIconDragEvent'].onDragStart(dragEvent) === undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconDragEvent_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc)().afterReturn(false);
      expect((viewDataMgr as object)['appIconDragEvent'].onDragStart(dragEvent) === undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconDragEvent_3', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc)().afterReturn(false);
      expect((viewDataMgr as object)['appIconDragEvent'].onDragEnd(dragEvent) === undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconDragEvent_4', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc)().afterReturn(true);
      AppStorage.set('isGestureDockDrag', true);
      expect((viewDataMgr as object)['appIconDragEvent'].onDragEnd(dragEvent) === undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_appIconDragEvent_5', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      when(mockFunc)().afterReturn(true);
      AppStorage.set('isGestureDockDrag', false);
      expect((viewDataMgr as object)['appIconDragEvent'].onDragEnd(dragEvent) === undefined).assertTrue();
      mocker.ignoreMock(viewDataMgr, (viewDataMgr as object)['isInEditMode']);
      done();
    });

    it('GestureDockAppItemViewEventMgr_initAppIconConfig_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      expect((viewDataMgr as object)['initAppIconConfig']() === undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_isInEditMode_1', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.viewDataMgr.gestureDockParam.gestureDockShowMode = GestureDockMode.EDIT;
      expect((viewDataMgr as object)['isInEditMode']() !== undefined).assertTrue();
      done();
    });

    it('GestureDockAppItemViewEventMgr_isInEditMode_2', 0, async (done: Function) => {
      let viewDataMgr = new GestureDockAppItemViewEventMgr(new GestureDockAppItemViewDataMgr());
      viewDataMgr.viewDataMgr.gestureDockParam.gestureDockShowMode = GestureDockMode.ALL_APPS;
      expect((viewDataMgr as object)['isInEditMode']() !== undefined).assertTrue();
      done();
    });
  })
}