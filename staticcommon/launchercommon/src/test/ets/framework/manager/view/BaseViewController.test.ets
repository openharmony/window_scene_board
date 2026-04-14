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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
// import { BaseViewController } from '../../../../../../../main/ets/TsIndex'
// import { TrimLevel } from '../../../../../../../main/ets/framework/memory/MemoryManager'


export function BaseViewControllerTest() {
  describe('BaseViewControllerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })
    interface ViewArea {
      left: number;
      top: number;
      width: number;
      height: number;
    }

    it('onTrimMemory', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      let level:TrimLevel = 0;
      let reason:string = '';
      expect(base.onTrimMemory(level, reason)).assertUndefined();
    })

    it('updateId', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      let persistentId:number = 0;
      expect(base.updateId(persistentId)).assertUndefined();
    })

    it('getId', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.getId()).assertInstanceOf('Number');
    })

    it('show', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.show()).assertUndefined();
    })

    it('hide', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.hide()).assertUndefined();
    })

    it('BaseViewControllerTest_destroy', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.destroy()).assertUndefined();
    })

    it('updateArea_updateRect', 0, (): void => {
      let area:ViewArea = {
          left: 0,
          top: 0,
          width: 0,
          height: 0,
      }
      let base:BaseViewController = new BaseViewController('');
      expect(base.updateArea(area)).assertUndefined();
      expect(base.updateRect(area)).assertUndefined();
    })

    it('getArea', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.getArea()).assertInstanceOf('Object');
    })

    it('readableViewType', 0, (): void => {
      let viewType = '';
      let base:BaseViewController = new BaseViewController('');
      expect(base.readableViewType(viewType)).assertInstanceOf('String');
    })

    it('setTranslate', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.setTranslate(0, 0, 0)).assertUndefined();
    })

    it('setOpacity', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.setOpacity(0)).assertUndefined();
    })
    //
    it('setTouchable', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.setTouchable(true)).assertUndefined();
    })

    it('setZIndex', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.setZIndex(0)).assertUndefined();
    })

    it('updateOpacity', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      expect(base.updateOpacity(0)).assertUndefined();
    })

    it('setResponseRegion', 0, (): void => {
      let base:BaseViewController = new BaseViewController('');
      let region: Rectangle = {
        x: 0,
        y: 0,
        width: 0,
        height: 0,
      }
      expect(base.setResponseRegion([region])).assertUndefined();
    })
  })
}