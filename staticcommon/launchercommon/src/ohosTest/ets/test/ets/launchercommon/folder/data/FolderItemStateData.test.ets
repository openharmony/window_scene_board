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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { FolderItemStateData } from '../../../../../../../main/ets/folder/data/FolderItemStateData'
import { BaseFolderState } from '../../../../../../../main/ets/folder/state/BaseFolderState'
import { SmallCloseState } from '../../../../../../../main/ets/folder/state/SmallCloseState'
import { FolderState, GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function FolderItemStateDataTest() {
  describe('FolderItemStateDataTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_getFolderState_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);
      let ret: FolderState = instance.getFolderState();
      expect(ret).not().assertNull();
    });

    it('test_getOpenFolderPageIndex_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);
      let ret: number = instance.getOpenFolderPageIndex();
      expect(instance).not().assertNull();
    });

    it('test_setOpenFolderPageIndex_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);
      let index: number = 1;
      instance.setOpenFolderPageIndex(1);
      expect(instance).not().assertNull();
    });

    it('test_getFolderStateContextByState_01', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.SMALL_FOLDER_CLOSE;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_02', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.SMALL_FOLDER_CLOSE_ENDING_PAGE;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_03', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.BIG_FOLDER_CLOSE;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_04', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.SMALL_FOLDER_OPENING;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_05', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.BIG_FOLDER_OPENING;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_06', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.SMALL_FOLDER_CLOSING;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_07', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.BIG_FOLDER_CLOSING;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_08', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.FOLDER_OPEN_STATIC;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_09', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.CONVERTING_SMALL_TO_BIG;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_10', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.CONVERTING_BIG_TO_SMALL;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_11', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = FolderState.FOLDER_OPEN_SWITCHING;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_getFolderStateContextByState_12', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      let instance: FolderItemStateData = new FolderItemStateData(item);

      let folderState: FolderState = {} as FolderState;
      let ret: BaseFolderState = instance['getFolderStateContextByState'](folderState);
      expect(ret).not().assertNull();
    });

    it('test_setTransitionFinish1', 0, () => {
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      const instance: FolderItemStateData = new FolderItemStateData(item);
      instance['mFolderState'] = FolderState.CONVERTING_SMALL_TO_BIG;
      expect(instance.setTransitionFinish()).assertTrue();
    });

    it('test_setTransitionFinish2', 0, () => {
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      const instance: FolderItemStateData = new FolderItemStateData(item);
      instance['mFolderState'] = -1;
      expect(instance.setTransitionFinish()).assertFalse();
    });

    it('test_isFolderOpenSwiping', 0, () => {
      const item: GridLayoutItemInfo = new GridLayoutItemInfo();
      const instance: FolderItemStateData = new FolderItemStateData(item);
      expect(instance.isFolderOpenSwiping()).assertInstanceOf('Boolean')
    });

  })
}
