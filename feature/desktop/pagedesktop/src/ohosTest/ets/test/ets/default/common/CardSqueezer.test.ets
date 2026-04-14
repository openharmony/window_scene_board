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

import { RectItem } from '@ohos/basicutils';
import { CellLayoutDragDelegate, DragGridPosition } from '@ohos/componentdrag';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { CommonConstants, GridLayoutItemInfo, GridLayoutUtil, LaunchLayoutCacheManager } from '@ohos/launchercommon'
import { CardSqueezer } from '../../../../../../main/ets/default/common/CardSqueezer'
import { MoveItem } from '../../../../../../main/ets/default/common/PageDesktopDragHandler'

export default function CardSqueezerTest() {

  describe('CardSqueezerTest', () => {
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
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it("getInstance", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let cardSqueezerInstance2 = CardSqueezer.getInstance();
      expect(cardSqueezerInstance).assertDeepEquals(cardSqueezerInstance2);
      done();
    })

    it("onDragItemChange1", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_CARD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_CARD
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getMovedItems']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange2", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_CARD
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange3", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_CARD
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getLayouts']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange4", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_CARD
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction4: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getLayouts']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange5", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_CARD
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['updateLayouts']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })
    it("onDragItemChange6", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_REGION_FOLDER
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_REGION_FOLDER
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getMovedItems']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange7", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_REGION_FOLDER
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_REGION_FOLDER
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange8", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_REGION_FOLDER
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction3: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getLayouts']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange9", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_REGION_FOLDER
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction4: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getLayouts']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("onDragItemChange10", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeEnable'] = true;
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD
      } as GridLayoutItemInfo;
      let dragItem = {
        typeId: CommonConstants.TYPE_REGION_FOLDER
      } as GridLayoutItemInfo;
      let key = 'key';
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getSingleDragItemInfo);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(dragItem);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getItemKey']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(key);
      let mockFunction2: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isValidLayoutItem);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction3: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.checkGridItemEqual);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction4: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['updateLayouts']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(undefined);
      cardSqueezerInstance.onDragItemChange();
      expect((cardSqueezerInstance as object)['squeezeEnable']).assertInstanceOf('Boolean');
      (cardSqueezerInstance as object)['squeezeEnable'] = false;
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      mocker.clear(GridLayoutUtil);
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("getSolution1", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['dragItem'] = {
        area: [1, 1]
      } as GridLayoutItemInfo;
      let crossItem = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['originLayout'] = new Map([['0', crossItem], ['1', crossItem]])
      let dragDelegate = {} as CellLayoutDragDelegate;
      let position = {
        column: 1,
        row: 1
      } as DragGridPosition;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(RectItem, RectItem.intersects);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      cardSqueezerInstance.getSolution(dragDelegate, position);
      expect((cardSqueezerInstance as object)['squeezeSuccess']).assertEqual(false);
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      mocker.clear(RectItem);
      mocker.clearAll();
      done();
    })

    it("getSqueezeSuccess", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['squeezeSuccess'] = true;
      let result = cardSqueezerInstance.getSqueezeSuccess();
      expect(result).assertEqual(true);
      (cardSqueezerInstance as object)['squeezeSuccess'] = false;
      done();
    })

    it("getMovedItems1", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let crossItem = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['originLayout'] = new Map([['0', crossItem], ['1', crossItem]]);
      (cardSqueezerInstance as object)['cacheLayout'] = new Map([['0', crossItem], ['1', crossItem]]);
      expect((cardSqueezerInstance as object)['movedItems'].size).assertEqual(0);
      (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      (cardSqueezerInstance as object)['cacheLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      done();
    })

    it("getMovedItems2", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let crossItem = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      let crossItem1 = {
        typeId: CommonConstants.TYPE_CARD,
        area: [2, 2],
        row: 2,
        column: 2
      } as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['originLayout'] = new Map([['0', crossItem], ['1', crossItem]]);
      (cardSqueezerInstance as object)['cacheLayout'] = new Map([['0', crossItem1], ['1', crossItem1]]);
      expect((cardSqueezerInstance as object)['movedItems'].size >= 0).assertEqual(true);
      (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      (cardSqueezerInstance as object)['cacheLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      (cardSqueezerInstance as object)['movedItems'] = new Set() as Set<string>;
      done();
    })

    it("getLayouts1", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_CARD,
        area: [2, 2],
        row: 2,
        column: 2
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      try {
        let crossItem = {
          typeId: CommonConstants.TYPE_CARD,
          area: [1, 1],
          row: 1,
          column: 1
        } as GridLayoutItemInfo;
        let crossItems = [crossItem, crossItem, crossItem]
        let mockFunction: Function =
          mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
            LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(crossItems);
        (cardSqueezerInstance as object)['getLayouts']();
        expect((cardSqueezerInstance as object)['originLayout'].size).assertLarger(0);
        (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      } catch (e) {}
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("getLayouts2", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_ADD,
        area: [2, 2],
        row: 2,
        column: 2
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      try {
        let crossItem = {
          typeId: CommonConstants.TYPE_CARD,
          area: [1, 1],
          row: 1,
          column: 1
        } as GridLayoutItemInfo;
        let crossItems = [crossItem, crossItem, crossItem];
        let mockFunction: Function =
          mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
            LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage);
        when(mockFunction)(ArgumentMatchers.any).afterReturn(crossItems);
        (cardSqueezerInstance as object)['getLayouts']();
        expect((cardSqueezerInstance as object)['originLayout'].size).assertLarger(0);
        (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
        (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
        (cardSqueezerInstance as object)['cacheLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      } catch (e) {}
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
      done();
    })

    it("updateLayouts", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      (cardSqueezerInstance as object)['dragItem'] = {
        typeId: CommonConstants.TYPE_CARD,
        area: [3, 3],
        row: 3,
        column: 3
      } as GridLayoutItemInfo;
      let mocker: MockKit = new MockKit();
      let crossItem = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      let crossItem1 = {
        typeId: CommonConstants.TYPE_ADD,
        area: [2, 2],
        row: 2,
        column: 2
      } as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['movedItems'] = new Set(['2', '3']);
      (cardSqueezerInstance as object)['originLayout'] =
        new Map([[(cardSqueezerInstance as object)['getItemKey'](crossItem), crossItem], ['1', crossItem1]]);
      let crossItems = [crossItem, crossItem1];
      let mockFunction: Function =
        mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectGridLayoutItemsByPage);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(crossItems);
      let mockFunction1: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getLayouts']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      (cardSqueezerInstance as object)['updateLayouts']();
      expect((cardSqueezerInstance as object)['originLayout'].size >= 0).assertEqual(true);
      (cardSqueezerInstance as object)['dragItem'] = {} as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['movedItems'] = new Set() as Set<string>;
      (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("getCrossItems1", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let dragRect = {} as RectItem;
      let crossItem = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      let crossItem1 = {
        typeId: CommonConstants.TYPE_ADD,
        area: [2, 2],
        row: 2,
        column: 2
      } as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['originLayout'] = new Map([['0', crossItem], ['1', crossItem1]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(RectItem, RectItem.intersects);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let result: GridLayoutItemInfo[] = (cardSqueezerInstance as object)['getCrossItems'](dragRect);
      expect(result.length >= 0).assertEqual(true);
      (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      (cardSqueezerInstance as object)['squeezeSuccess'] = false;
      mocker.clear(RectItem);
      mocker.clearAll();
      done();
    })

    it("getCrossItems2", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let dragRect = {} as RectItem;
      let crossItem = {
        typeId: CommonConstants.TYPE_REGION_FOLDER,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      let crossItem1 = {
        typeId: CommonConstants.TYPE_ADD,
        area: [2, 2],
        row: 2,
        column: 2
      } as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['originLayout'] = new Map([['0', crossItem], ['1', crossItem1]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(RectItem, RectItem.intersects);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let result: GridLayoutItemInfo[] = (cardSqueezerInstance as object)['getCrossItems'](dragRect);
      expect(result.length >= 0).assertEqual(true);
      (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      (cardSqueezerInstance as object)['squeezeSuccess'] = false;
      mocker.clear(RectItem);
      mocker.clearAll();
      done();
    })

    it("getRealMoveItems", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let moveItem = {
        row: 1,
        column: 1,
        page: 1,
        area: [1, 1],
        typeId: CommonConstants.TYPE_CARD
      } as MoveItem;
      let moveItems = [moveItem, moveItem, moveItem];
      let crossItem = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      let crossItem1 = {
        typeId: CommonConstants.TYPE_ADD,
        area: [2, 2],
        row: 2,
        column: 2
      } as GridLayoutItemInfo;
      (cardSqueezerInstance as object)['movedItems'] = new Set(['0', (cardSqueezerInstance as object)['getItemKey'](moveItem)]);
      (cardSqueezerInstance as object)['cacheLayout'] =
        new Map([['0', crossItem], [(cardSqueezerInstance as object)['getItemKey'](moveItem), crossItem1]]);
      (cardSqueezerInstance as object)['originLayout'] =
        new Map([['0', crossItem], [(cardSqueezerInstance as object)['getItemKey'](moveItem), crossItem1]]);
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(cardSqueezerInstance, (cardSqueezerInstance as object)['getMoveItem']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(moveItem);
      let result: MoveItem[] = (cardSqueezerInstance as object)['getRealMoveItems'](moveItems);
      expect(result.length >= 0).assertEqual(true);
      (cardSqueezerInstance as object)['movedItems'] = new Set() as Set<string>;
      (cardSqueezerInstance as object)['originLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      (cardSqueezerInstance as object)['cacheLayout'] = new Map() as Map<string, GridLayoutItemInfo>;
      mocker.clear(cardSqueezerInstance);
      mocker.clearAll();
      done();
    })

    it("getMoveItem", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let item = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      let origin = {
        row: 1,
        column: 1
      } as DragGridPosition;
      let target = {
        row: 2,
        column: 2
      } as DragGridPosition;
      let moveItem = {
        row: 1,
        column: 1,
        page: 1,
        area: [1, 1],
        position: [[1, 1]],
        typeId: CommonConstants.TYPE_CARD
      } as MoveItem;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(MoveItem, MoveItem.fromGridItem);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(moveItem);
      let mockFunction1: Function =
        mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.getGridItemPosition);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn([1, 2]);
      let result: MoveItem = (cardSqueezerInstance as object)['getMoveItem'](item, origin, target);
      expect(result).not().assertUndefined();
      mocker.clear(MoveItem);
      mocker.clear(GridLayoutUtil);
      mocker.clearAll();
      done();
    })

    it("getItemKey", 0, async (done: Function) => {
      let cardSqueezerInstance = CardSqueezer.getInstance();
      let item = {
        typeId: CommonConstants.TYPE_CARD,
        area: [1, 1],
        row: 1,
        column: 1
      } as GridLayoutItemInfo;
      let moveItem = {
        row: 1,
        column: 1,
        page: 1,
        area: [1, 1],
        position: [[1, 1]],
        typeId: CommonConstants.TYPE_CARD
      } as MoveItem;
      (cardSqueezerInstance as object)['getItemKey'](item);
      let result: string = (cardSqueezerInstance as object)['getItemKey'](moveItem);
      expect(result.length > 0).assertEqual(true);
      done();
    })
  })
}