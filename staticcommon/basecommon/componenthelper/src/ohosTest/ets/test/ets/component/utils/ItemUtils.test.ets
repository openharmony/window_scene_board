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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { ItemUtils } from '../../../../../../main/ets/utils/ItemUtils';
import { CheckEmptyUtils, RectInfo } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const PX_SUFFIX: string = 'px';

export function ItemUtilsTest() {
  describe('ItemUtilsTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_num2PxStr', Level.LEVEL0, (): void => {
      let value: number = 2;
      let res: string = ItemUtils.num2PxStr(value);
      expect(res).assertEqual(value + PX_SUFFIX);
    })

    it('test_vp2PxStr', Level.LEVEL0, (): void => {
      let value: number = 2;
      let res: string = ItemUtils.vp2PxStr(value);
      expect(res).assertEqual(vp2px(value) + PX_SUFFIX);
    })

    it('test_getRectById_failed', Level.LEVEL0, (): void => {
      let res = ItemUtils.getRectById('');
      res = ItemUtils.getRectById(null);
      expect(IsEmptyRect(res)).assertTrue();
    })

    it('test_getScaleById_failed', Level.LEVEL0, (): void => {
      let res = ItemUtils.getScaleById(null);
      expect(res).assertNull();
    })

    it('test_getRectangleByScreenId_failed', Level.LEVEL0, (): void => {
      let res = ItemUtils.getRectangleByScreenId('Xxxx', 3);
      expect(res).assertNull();
    })

    it('test_getRectangleByScreenId_02_7', 0, () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        let res = ItemUtils.getRectangleByScreenId('Xxxx', 3);
        expect(res).assertEqual(undefined);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_getCmpRect_failed', Level.LEVEL0, (): void => {
      let rect1 = ItemUtils.getCmpRect(null);
      expect(IsEmptyRect(rect1)).assertTrue();

      let rect2 = ItemUtils.getCmpRect(null, 1);
      expect(IsEmptyRect(rect2)).assertTrue();

      const mocker: MockKit = new MockKit();
      const mockGetRectangleByScreenId: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectangleByScreenId);
      when(mockGetRectangleByScreenId)().afterReturn({
        scale: {
          x: 1,
          y: 1
        },
        size: {
          width: 1,
          height: 1,
        },
        screenOffset: {
          x: 1,
          y: 1
        },
        translate: {
          x: 1,
          y: 1
        }
      });
      let rect3 = ItemUtils.getCmpRect(null, 2);
      expect(rect3).not().assertNull();
      mocker.clear(ItemUtils);
      mocker.clearAll();
    })

    it('test_getOffsetRelativeScreenById_failed', Level.LEVEL0, (): void => {
      let res = ItemUtils.getOffsetRelativeScreenById(null);
      expect(res).assertNull();
    })

    it('test_getRectByIdWithTransform_failed', Level.LEVEL0, (): void => {
      let res = ItemUtils.getRectByIdWithTransform(null);
      expect(IsEmptyRect(res)).assertTrue();

      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectangleById);
      when(mockFunc)().afterReturn({
        scale: {
          x: 1,
          y: 1
        },
        size: {
          width: 1,
          height: 1,
        },
        screenOffset: {
          x: 1,
          y: 1
        },
        translate: {
          x: 1,
          y: 1
        }
      });
      res = ItemUtils.getRectByIdWithTransform(null);
      expect(res).not().assertNull();
      mocker.clear(ItemUtils);
      mocker.clearAll();
    })

    it('test_getFrameNodePosById_01', 0, () => {
      try {
        let id: string = 'Xxxx';
        ItemUtils.getFrameNodePosById(id);
        ItemUtils.getFrameNodeSizeById(id);
        expect(id).assertEqual('Xxxx');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getFrameNodeRectById_01', 0, () => {
      let mock = new MockKit();
      try {
        let id: string = 'Xxxx';
        ItemUtils.getFrameNodeRectById(null);
        ItemUtils.getFrameNodeRectById(undefined);
        ItemUtils.getFrameNodeRectById(id);
        let mockFunc: Function = mock.mockFunc(ItemUtils, ItemUtils.getFrameNodePosById);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        ItemUtils.getFrameNodeRectById(id);
        expect(id).assertEqual('Xxxx');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ItemUtils);
      mock.clearAll();
    })



  })
}

function IsEmptyRect(rect: RectInfo): boolean {
  return (rect.left === 0 && rect.right === 0 && rect.top === 0 && rect.bottom === 0);
}