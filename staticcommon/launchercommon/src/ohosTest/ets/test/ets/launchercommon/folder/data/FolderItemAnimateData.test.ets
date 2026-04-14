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

import { CheckEmptyUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers} from '@ohos/hypium';
import FolderDataModel from '../../../../../../../main/ets/folder/data/FolderDataModel';
import {
  FolderItemAnimateData
} from '../../../../../../../main/ets/folder/data/FolderItemAnimateData';
import {
  FolderDataModelManager
} from '../../../../../../../main/ets/folder/model/FolderDataModelManager';
import { FolderLayoutCacheManager, GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';

export default function FolderItemAnimateDataTest() {
  describe('FolderItemAnimateDataTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {

    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {

    })

    it('test_initFoldAnimate_01', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let folderId: string = '';
      instance.initFoldAnimate(folderId);
      let ret: boolean = CheckEmptyUtils.isEmpty(folderId)
      expect(ret).assertTrue();
    });

    it('test_initFoldAnimate_02', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let folderId: string = 'lkqkw4s76q0592qwa4g';
      instance.initFoldAnimate(folderId);
      let ret: boolean = CheckEmptyUtils.isEmpty(folderId)
      expect(ret).assertFalse();
    });

    it('test_showFolderBackplaneAnimate_01', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderBackplaneOpen: boolean = true;
      instance.showFolderBackplaneAnimate(isFolderBackplaneOpen);
      expect(isFolderBackplaneOpen).assertTrue();
    });

    it('test_showFolderBackplaneAnimate_02', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderBackplaneOpen: boolean = false;
      instance.showFolderBackplaneAnimate(isFolderBackplaneOpen);
      expect(isFolderBackplaneOpen).assertFalse();
    });

    it('test_playLongPressAnimation_01', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderComponentZoomOut: boolean = false;
      let isPlayResponseAnimation: boolean = false;
      let isGeometryTransiting: boolean = false;
      instance.playLongPressAnimation(isFolderComponentZoomOut);
      expect(instance).not().assertNull();
    });

    it('test_playLongPressAnimation_02', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderComponentZoomOut: boolean = false;
      let isPlayResponseAnimation: boolean = true;
      let isGeometryTransiting: boolean = true;
      instance.playLongPressAnimation(isFolderComponentZoomOut);
      expect(instance).not().assertNull();
    });

    it('test_playLongPressAnimation_03', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderComponentZoomOut: boolean = true;
      let isPlayResponseAnimation: boolean = true;
      let isGeometryTransiting: boolean = false;
      instance.playLongPressAnimation(isFolderComponentZoomOut);
      expect(instance).not().assertNull();
    });

    it('test_playLongPressAnimation_04', 0, () => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderComponentZoomOut: boolean = false;
      let isPlayResponseAnimation: boolean = true;
      let isGeometryTransiting: boolean = false;
      instance.playLongPressAnimation(isFolderComponentZoomOut);
      expect(instance).not().assertNull();
    });

    it("isSmallFolder", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let folderDataModelManagerInstance:FolderDataModelManager = FolderDataModelManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(folderDataModelManagerInstance, folderDataModelManagerInstance.getFolderDataModelById);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(null);
      let result:boolean = (instance as object)['isSmallFolder']()!;
      expect(result).assertEqual(false);
      mocker.clear(folderDataModelManagerInstance);
      mocker.clearAll();
      done();
    })

    it("showFolderBackplaneAnimate1", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderBackplaneOpen: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, (instance as object)['isSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      instance.showFolderBackplaneAnimate(isFolderBackplaneOpen);
      expect((instance as object)['folderBackgroundScaleX']).assertEqual(1.1);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("showFolderBackplaneAnimate2", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderBackplaneOpen: boolean = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, (instance as object)['isSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('error');
      instance.showFolderBackplaneAnimate(isFolderBackplaneOpen);
      expect((instance as object)['folderBackgroundScaleX']).assertEqual(1);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("getCurve", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, (instance as object)['isSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      expect((instance as object)['getCurve']()).not().assertEqual(null);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("breakLongPressAnimation", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, (instance as object)['getLongPressAnimationName']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('folderId');
      let mockFunction1: Function =
        mocker.mockFunc(instance, (instance as object)['getRestoreLongPressAnimationName']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn('folderId');
      instance.breakLongPressAnimation();
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it('playLongPressAnimation', 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let isFolderComponentZoomOut: boolean = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, (instance as object)['isSmallFolder']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      instance.playLongPressAnimation(isFolderComponentZoomOut);
      (instance as object)['desktopContext']?.eventHub?.emit?.('appIconLongPressEffectCancel');
      expect(instance).not().assertNull();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it("getBigFolderLongPressScale1", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      let folderDataModelManagerInstance:FolderDataModelManager = FolderDataModelManager.getInstance();
      let grid = new GridLayoutItemInfo();
      grid.area = [4,2];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(folderDataModelManagerInstance, folderDataModelManagerInstance.getFolderDataModelById);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(grid);
      expect((instance as object)['getBigFolderLongPressScale']).not().assertUndefined();
      mocker.clear(folderDataModelManagerInstance);
      mocker.clearAll();
      done();
    })

    it("restoreLongPressAnimation1", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      (instance as object)['folderComponentScale'] = {x:2,y:2};
      (instance as object)['folderId'] = 'folderId';
      (instance as object)['restoreLongPressAnimation']();
      expect((instance as object)['folderComponentScale']).not().assertUndefined();
      done();
    })

    it("restoreLongPressAnimation2", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      (instance as object)['folderComponentScale'] = {x:2,y:2};
      (instance as object)['folderId'] = 'folderId';
      (instance as object)['restoreLongPressAnimation']();
      (instance as object)['desktopContext']?.eventHub?.on?.('appIconLongPressEffectCancel',()=>{});
      expect((instance as object)['folderComponentScale']).not().assertUndefined();
      done();
    })

    it("cancelLongPressAnimation", 0, async(done:Function) => {
      const instance: FolderItemAnimateData = new FolderItemAnimateData();
      instance.cancelLongPressAnimation(()=>{});
      expect(instance).not().assertNull();
      done();
    })

    it("test_isSmallFolder_10", 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const folderDataModel:FolderDataModel = new FolderDataModel(gridLayoutItemInfo);
      const folderItemAnimateData: FolderItemAnimateData = new FolderItemAnimateData();
      const folderDataModelManager:FolderDataModelManager = FolderDataModelManager.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(folderDataModelManager, folderDataModelManager.getFolderDataModelById);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(folderDataModel);
        let mockFunc1: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
        expect((folderItemAnimateData as object)['isSmallFolder']()).assertInstanceOf('Boolean');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(folderDataModelManager);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it("test_getCurve_10", 0, () => {
      const folderItemAnimateData: FolderItemAnimateData = new FolderItemAnimateData();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderItemAnimateData, (folderItemAnimateData as object)['isSmallFolder']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      expect((folderItemAnimateData as object)['getCurve']()).not().assertNull();
      mocker.clear(folderItemAnimateData);
      mocker.clearAll();
    })

    it("test_getBigFolderLongPressScale_10", 0, () => {
      const gridLayoutItemInfo:GridLayoutItemInfo = new GridLayoutItemInfo();
      const gridLayoutItemInfoOther:GridLayoutItemInfo = new GridLayoutItemInfo();
      gridLayoutItemInfo.area = [4,2];
      gridLayoutItemInfoOther.area = [4,1];
      const folderItemAnimateData: FolderItemAnimateData = new FolderItemAnimateData();
      const folderLayoutCacheManager: FolderLayoutCacheManager = FolderLayoutCacheManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(folderLayoutCacheManager, folderLayoutCacheManager.selectGridLayoutItemByFolderId);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfo);
      expect((folderItemAnimateData as object)['getBigFolderLongPressScale']()).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(gridLayoutItemInfoOther);
      expect((folderItemAnimateData as object)['getBigFolderLongPressScale']()).not().assertNull();
      mocker.clear(folderLayoutCacheManager);
      mocker.clearAll();
    })
  })
}
