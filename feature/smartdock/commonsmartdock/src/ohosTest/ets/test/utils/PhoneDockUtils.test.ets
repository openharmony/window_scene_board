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

import { RectInfo } from '@ohos/basicutils'
import { ItemUtils } from '@ohos/componenthelper'
import { ItemAnimationParams } from '@ohos/launchercommon/Index'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import SmartDockConstants from '../../../../main/ets/default/common/constants/SmartDockConstants'
import { PhoneDockUtils } from '../../../../main/ets/default/utils/PhoneDockUtils'
import { ImageProcessUtils } from '../../../../main/ets/default/utils/ImageProcessUtils'

export default function PhoneDockUtilsTest() {
  describe('PhoneDockUtilsTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_getBackPlaneAnimation_0', 0, () => {
      let residentRect: RectInfo = ItemUtils.getRectById(SmartDockConstants.DOCK_RESIDENT_BG_ID);
      AppStorage.setOrCreate('recentDockList', []);
      let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
      const screenWidth: number = AppStorage.get<number>('screenWidth') as number;
      const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
      itemAnimation.calculateStartAppProperty(screenWidth, screenHeight, residentRect);
      let retValue = PhoneDockUtils.getBackPlaneAnimation();
      expect(retValue.delay).assertInstanceOf('Number');
    })

    it('test_getBackPlaneAnimation_16', 0, () => {
      try {
        let residentRect: RectInfo = ItemUtils.getRectById(SmartDockConstants.DOCK_RESIDENT_BG_ID);
        let recentRect: RectInfo = ItemUtils.getRectById(SmartDockConstants.DOCK_RECENT_BG_ID);
        let backPlaneRect: RectInfo = new RectInfo();
        if (recentRect.left === 0) {
          backPlaneRect = residentRect;
        } else {
          backPlaneRect.left = residentRect.left;
          backPlaneRect.right = recentRect.right;
          backPlaneRect.top = residentRect.top;
          backPlaneRect.bottom = residentRect.bottom;
          backPlaneRect.height = residentRect.height as number;
          backPlaneRect.width = (residentRect.width as number) + (recentRect.width as number);
        }
        let itemAnimation: ItemAnimationParams = new ItemAnimationParams();
        const screenWidth: number = AppStorage.get<number>('screenWidth') as number;
        const screenHeight: number = AppStorage.get<number>('screenHeight') as number;
        itemAnimation.calculateStartAppProperty(screenWidth, screenHeight, backPlaneRect);
        let retValue = PhoneDockUtils.getBackPlaneAnimation();
        expect(retValue.delay).assertInstanceOf('Number');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getBackPlaneAnimation_01', 0, () => {
      let mock = new MockKit();
      try {
        const rect: RectInfo = new RectInfo();
        rect.left = 0;
        let mockFunc: Function = mock.mockFunc(ItemUtils, ItemUtils.getRectById);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(rect);

        let retValue = PhoneDockUtils.getBackPlaneAnimation();
        expect(retValue.delay).assertInstanceOf('Number');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ItemUtils);
      mock.clearAll();
    });

    it('test_getBackPlaneAnimation_02', 0, () => {
      let mock = new MockKit();
      try {
        const rect: RectInfo = new RectInfo();
        rect.left = 1;
        let mockFunc: Function = mock.mockFunc(ItemUtils, ItemUtils.getRectById);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(rect);

        let retValue = PhoneDockUtils.getBackPlaneAnimation();
        expect(retValue.delay).assertInstanceOf('Number');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ItemUtils);
      mock.clearAll();
    });

    it('test_base64ToPixelMap_01', 0, () => {
      try {
        const instance: ImageProcessUtils = ImageProcessUtils.getInstance();
        instance.base64ToPixelMap('');
        expect(instance instanceof ImageProcessUtils).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_base64ToPixelMap_02', 0, () => {
      try {
        const instance: ImageProcessUtils = ImageProcessUtils.getInstance();
        const base64StrWithPre: string = 'data:image/jpeg;base64,test string';
        instance.base64ToPixelMap(base64StrWithPre);
        expect(instance instanceof ImageProcessUtils).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_base64ToPixelMap_03', 0, () => {
      try {
        const instance: ImageProcessUtils = ImageProcessUtils.getInstance();
        const base64StrNotWithPre: string = 'test string';
        instance.base64ToPixelMap(base64StrNotWithPre);
        expect(instance instanceof ImageProcessUtils).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

  })
}