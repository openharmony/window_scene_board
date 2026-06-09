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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from "@ohos/hypium"
import { PageDragManager } from "../../../../../../../main/ets/editmode/model/PageDragManager"
import GridLayoutUtil from '../../../../../../../main/ets/utils/GridLayoutUtil'

export function PageDragManagerTest() {
  describe('PageDragManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getInstance', 0, () => {
      const pageDragManager = PageDragManager.getInstance();
      expect(pageDragManager).not().assertNull();
      const pageDragManager2 = PageDragManager.getInstance();
      expect(pageDragManager2).not().assertNull();
    })

    it('test_onDragSqueezeEvent', 0, () => {
      const pageDragManager = new PageDragManager();
      pageDragManager.onDragSqueezeEvent(999);
      pageDragManager.initDragInfo(0);
      pageDragManager.onDragSqueezeEvent(1);
      pageDragManager.onCancelSqueezeEvent(false);
      expect(pageDragManager.getDraggingPage()).not().assertNull();
    })

    it('test_onEditSqueezeEvent', 0, () => {
      const pageDragManager = new PageDragManager();
      pageDragManager.onEditSqueezeEvent(0, true);
      pageDragManager.onEditSqueezeEvent(0, false);
      pageDragManager.initDragInfo(0);
      expect(pageDragManager.getDraggingPage()).not().assertNull();
    })

    it('test_initSqueezeInfo', 0, () => {
      const pageDragManager = new PageDragManager();
      pageDragManager.initSqueezeInfo(true);
      pageDragManager.initSqueezeInfo(false);
      pageDragManager.initDragInfo(0);
      expect(pageDragManager.getDraggingPage()).not().assertNull();
    })

    it('test_getRelativePages', 0, () => {
      const pageDragManager = new PageDragManager();
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isLargeFoldOrTrifoldExpanded);
        when(mockFunction)().afterReturn(true);
        const pages = pageDragManager.getRelativePages(0);
        expect(pages.length).assertLarger(1);
        mocker.clear(GridLayoutUtil);
        mocker.clearAll();
      } catch (err) {}
    })

    it('test_getRelativePages2', 0, () => {
      const pageDragManager = new PageDragManager();
      try {
        let mocker: MockKit = new MockKit();
        let mockFunction: Function = mocker.mockFunc(GridLayoutUtil, GridLayoutUtil.isLargeFoldOrTrifoldExpanded);
        when(mockFunction)().afterReturn(false);
        const pages = pageDragManager.getRelativePages(0);
        expect(pages.length).assertEqual(1);
        mocker.clear(GridLayoutUtil);
        mocker.clearAll();
      } catch (err) {}
    })

    it('test_getPageUniqueKey', 0, () => {
      const pageDragManager = new PageDragManager();
      pageDragManager.setOuterDeskTop(true);
      const key1 = pageDragManager.getPageUniqueKey(0);
      pageDragManager.setOuterDeskTop(false);
      const key2 = pageDragManager.getPageUniqueKey(0);
      expect(key1).not().assertEqual(key2);
    })
  })
}