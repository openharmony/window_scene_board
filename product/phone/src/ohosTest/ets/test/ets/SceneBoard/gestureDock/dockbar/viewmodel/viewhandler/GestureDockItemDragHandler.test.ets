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

import { RectInfo } from '@ohos/basicutils';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  Level,
  MockKit,
  when
} from '@ohos/hypium';
import {
  GestureDockUtil
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/GestureDockUtil';
import {
  GestureDockItemInfo
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import GestureDockItemDragHandler
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/viewmodel/viewhandler/GestureDockItemDragHandler';

export default function GestureDockItemDragHandlerTest() {
  describe('GestureDockItemDragHandlerTest', () => {
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

    it('GestureDockItemDragHandler_init_1', 0, async (done: Function) => {
      let gestureDockItemDragHandler = new GestureDockItemDragHandler();
      expect((gestureDockItemDragHandler as object)['init']() === undefined).assertTrue();
      done();
    });

    it('GestureDockItemDragHandler_handleDragStart_1', 0, async (done: Function) => {
      let gestureDockItemDragHandler = new GestureDockItemDragHandler();
      let appInfo: GestureDockItemInfo = {
        translateY: 0
      } as GestureDockItemInfo;
      expect(gestureDockItemDragHandler.handleDragStart(appInfo, '0') === undefined).assertTrue();
      done();
    });


    it('GestureDockItemDragHandlerTest_squeezeItem_1', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      gestureDockItemDragHandler.squeezeIndex = 1;
      (gestureDockItemDragHandler as object)['squeezeItem'](1, new GestureDockItemInfo(), 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_squeezeItem_2', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      gestureDockItemDragHandler.squeezeIndex = 1;
      (gestureDockItemDragHandler as object)['squeezeItem'](2, new GestureDockItemInfo(), 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_adjustItem_1', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let appInfo: GestureDockItemInfo = {
        translateY: 0
      } as GestureDockItemInfo;
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0,
        bundleName: 'test',
        appIndex: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', false);
      AppStorage.setOrCreate('gestureDockList', [new GestureDockItemInfo(), new GestureDockItemInfo()]);
      gestureDockItemDragHandler.handleDragEnter(4, dockApps, 0);
      (gestureDockItemDragHandler as object)['adjustItem'](appInfo, -2, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_adjustItem_2', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let appInfo: GestureDockItemInfo = {
        translateY: 0
      } as GestureDockItemInfo;
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0,
        bundleName: 'test',
        appIndex: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', false);
      AppStorage.setOrCreate('gestureDockList', [new GestureDockItemInfo(), new GestureDockItemInfo()]);
      gestureDockItemDragHandler.handleDragEnter(4, dockApps, 0);
      (gestureDockItemDragHandler as object)['adjustItem'](appInfo, 1, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_moveItem_1', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'test';
      gestureDockItemInfo.appIndex = 0;
      let gestureDockItemInfo1: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo1.bundleName = 'test_1';
      gestureDockItemInfo1.appIndex = 1;
      (gestureDockItemDragHandler as object)['copyResidentApps'] = [gestureDockItemInfo, gestureDockItemInfo1];
      (gestureDockItemDragHandler as object)['moveItem'](gestureDockItemInfo, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_moveItem_2', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'test';
      gestureDockItemInfo.appIndex = 0;
      let gestureDockItemInfo1: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo1.bundleName = 'test';
      gestureDockItemInfo1.appIndex = 1;
      (gestureDockItemDragHandler as object)['copyResidentApps'] = [gestureDockItemInfo, gestureDockItemInfo1];
      (gestureDockItemDragHandler as object)['moveItem'](gestureDockItemInfo, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_moveItem_3', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'test';
      gestureDockItemInfo.appIndex = 0;
      let gestureDockItemInfo1: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo1.bundleName = 'test_1';
      gestureDockItemInfo1.appIndex = 0;
      (gestureDockItemDragHandler as object)['copyResidentApps'] = [gestureDockItemInfo, gestureDockItemInfo1];
      (gestureDockItemDragHandler as object)['moveItem'](gestureDockItemInfo, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_findNearestArea_1', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      (gestureDockItemDragHandler as object)['copyResidentApps'] = [];
      (gestureDockItemDragHandler as object)['findNearestArea'](100, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_findNearestArea_2', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let gestureDockItemInfo1: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo1.bundleName = 'test';
      gestureDockItemInfo1.appIndex = 0;
      let gestureDockItemInfo2: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo2.bundleName = '';
      gestureDockItemInfo2.appIndex = 1;
      (gestureDockItemDragHandler as object)['copyResidentApps'] = [gestureDockItemInfo1, gestureDockItemInfo2];
      (gestureDockItemDragHandler as object)['findNearestArea'](100, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
    })

    it('GestureDockItemDragHandlerTest_findNearestArea_3', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let gestureDockItemInfo1: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo1.bundleName = 'test';
      gestureDockItemInfo1.appIndex = 0;
      let gestureDockItemInfo2: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo2.bundleName = '';
      gestureDockItemInfo2.appIndex = 1;
      (gestureDockItemDragHandler as object)['copyResidentApps'] = [gestureDockItemInfo1, gestureDockItemInfo2];
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(gestureDockItemDragHandler, gestureDockItemDragHandler.getGestureDockItemCenter);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(100);
      (gestureDockItemDragHandler as object)['findNearestArea'](-100, 1);
      expect(gestureDockItemDragHandler).not().assertUndefined();
      mocker.ignoreMock(gestureDockItemDragHandler, gestureDockItemDragHandler.getGestureDockItemCenter);
    })

    it('GestureDockItemDragHandlerTest_getGestureDockItemCenter', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      expect(gestureDockItemDragHandler.getGestureDockItemCenter(0, 0) !== undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragMove_1', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let rectangle: Rectangle = {
        x: 1,
        y: 1,
        width: 1,
        height: 1
      }
      const event: DragEvent = {
        getWindowX: (() => {
          return 100;
        }),
        getWindowY: (() => {
          return 600;
        }),
        getPreviewRect: (() => {
          return rectangle;
        }),
      } as DragEvent;
      expect(gestureDockItemDragHandler.handleDragMove(event, undefined) === undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragMove_2', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let rectangle: Rectangle = {
        x: 1,
        y: 1,
        width: 1,
        height: 1
      }
      const event: DragEvent = {
        getWindowX: (() => {
          return 100;
        }),
        getWindowY: (() => {
          return 600;
        }),
        getPreviewRect: (() => {
          return rectangle
        }),
      } as DragEvent;
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'test';
      gestureDockItemInfo.appIndex = 0;
      AppStorage.setOrCreate('gestureDockDragItemInfo', gestureDockItemInfo);
      expect(gestureDockItemDragHandler.handleDragMove(event, 1) === undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_getGestureDockItemCenter_1', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      const event: DragEvent = {
        getWindowX: (() => {
          return 100;
        }),
        getWindowY: (() => {
          return 600;
        }),
      } as DragEvent;
      gestureDockItemDragHandler.handleDragDrop(event);
      expect(gestureDockItemDragHandler.getGestureDockItemCenter(0, 0) !== undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_getGestureDockItemCenter_2', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      (gestureDockItemDragHandler as object)['dockRectInfo'] = new RectInfo();
      expect(gestureDockItemDragHandler.getGestureDockItemCenter(0, 0) !== undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_getGestureDockItemCenter_3', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      (gestureDockItemDragHandler as object)['dockRectInfo'] = new RectInfo();
      (gestureDockItemDragHandler as object)['recentAppLength'] = 4;
      expect(gestureDockItemDragHandler.getGestureDockItemCenter(0, 0) !== undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragEnter', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0
      }] as GestureDockItemInfo[];
      expect(gestureDockItemDragHandler.handleDragEnter(0, dockApps, 0) === undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragEnter_1', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', true);
      expect(gestureDockItemDragHandler.handleDragEnter(0, dockApps, 0) === undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragEnter_2', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', false);
      AppStorage.setOrCreate('gestureDockList', undefined);
      expect(gestureDockItemDragHandler.handleDragEnter(0, dockApps, 0) === undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragEnter_3', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', false);
      AppStorage.setOrCreate('gestureDockList', [new GestureDockItemInfo(), new GestureDockItemInfo]);
      expect(gestureDockItemDragHandler.handleDragEnter(4, dockApps, 0) === undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragEnter_4', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0,
        bundleName: 'test',
        appIndex: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', false);
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'test';
      gestureDockItemInfo.appIndex = 0;
      AppStorage.setOrCreate('gestureDockList', [gestureDockItemInfo, new GestureDockItemInfo()]);
      AppStorage.setOrCreate('gestureDockDragItemInfo', gestureDockItemInfo);
      expect(gestureDockItemDragHandler.handleDragEnter(4, dockApps, 0) === undefined).assertTrue();
    })

    it('GestureDockItemDragHandlerTest_handleDragEnter_5', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0,
        bundleName: 'test',
        appIndex: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', false);
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'test';
      gestureDockItemInfo.appIndex = 0;
      AppStorage.setOrCreate('gestureDockList', [gestureDockItemInfo, new GestureDockItemInfo()]);
      AppStorage.setOrCreate('gestureDockDragItemInfo', gestureDockItemInfo);
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect(gestureDockItemDragHandler.handleDragEnter(4, dockApps, 0) === undefined).assertTrue();
      mocker.ignoreMock(GestureDockUtil, GestureDockUtil.areTwoAppItemsSame);
    })

    it('GestureDockItemDragHandlerTest_handleDragEnter_6', Level.LEVEL0, (): void => {
      let gestureDockItemDragHandler: GestureDockItemDragHandler = new GestureDockItemDragHandler();
      let dockApps: GestureDockItemInfo[] = [{
        translateY: 0,
        bundleName: 'test',
        appIndex: 0
      }] as GestureDockItemInfo[];
      AppStorage.setOrCreate('isGestureDockDrag', false);
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'test';
      gestureDockItemInfo.appIndex = 0;
      AppStorage.setOrCreate('gestureDockList', [gestureDockItemInfo, new GestureDockItemInfo()]);
      AppStorage.setOrCreate('gestureDockDragItemInfo', gestureDockItemInfo);
      expect(gestureDockItemDragHandler.handleDragEnter(1, dockApps, 0) === undefined).assertTrue();
    })
  })
}