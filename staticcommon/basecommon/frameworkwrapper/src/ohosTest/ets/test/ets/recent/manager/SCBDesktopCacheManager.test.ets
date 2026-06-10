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
import { sOutSideWindowMgr } from '../../../../../../main/ets/TsIndex';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium';
import { SCBDesktopCacheManager } from '../../../../../../main/ets/recent/manager/SCBDesktopCacheManager';
import { screenLock } from '@kit.BasicServicesKit';


export function SCBDesktopCacheManagerTest() {
  describe('SCBDesktopCacheManagerTest', (): void => {
    let desktopCacheManager: SCBDesktopCacheManager = SCBDesktopCacheManager.getInstance();
    (desktopCacheManager as object)['instance'] = null;
    desktopCacheManager = SCBDesktopCacheManager.getInstance();
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('SCBDesktopCacheManager_test_setDesktopCacheWithDfx_01', 0, (): void => {
      let cacheFlag: boolean = true;
      let onlyValidateFolderExpand: boolean = true;
      let mocker: MockKit = new MockKit();
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(false);
      let isShowNegative: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)(ArgumentMatchers.any).afterReturn(false);
      desktopCacheManager.setDesktopCacheWithDfx(cacheFlag,'setDesktopCacheWithDfxTest', onlyValidateFolderExpand, false);
      expect(cacheFlag).assertTrue();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
    })

    it('SCBDesktopCacheManager_test_setDesktopCacheWithDfx_02', 0, (): void => {
      let cacheFlag: boolean = false;
      let onlyValidateFolderExpand: boolean = true;
      let mocker: MockKit = new MockKit();
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(false);
      let isShowNegative: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)(ArgumentMatchers.any).afterReturn(false);
      desktopCacheManager.setDesktopCacheWithDfx(cacheFlag,'setDesktopCacheWithDfxTest', onlyValidateFolderExpand, false);
      expect(cacheFlag).assertFalse();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
    })

    it('SCBDesktopCacheManager_test_setDesktopCacheWithDfx_03', 0, (): void => {
      let cacheFlag: boolean = true;
      let onlyValidateFolderExpand: boolean = false;
      let mocker: MockKit = new MockKit();
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(false);
      let isShowNegative: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)(ArgumentMatchers.any).afterReturn(false);
      desktopCacheManager.setDesktopCacheWithDfx(cacheFlag,'setDesktopCacheWithDfxTest', onlyValidateFolderExpand, false);
      expect(onlyValidateFolderExpand).assertFalse();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
    })

    it('SCBDesktopCacheManager_test_setDesktopCacheWithDfx_04', 0, (): void => {
      let cacheFlag: boolean = true;
      let onlyValidateFolderExpand: boolean = false;
      let mocker: MockKit = new MockKit();
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(true);
      let isShowNegative: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)(ArgumentMatchers.any).afterReturn(false);
      desktopCacheManager.setDesktopCacheWithDfx(cacheFlag,'setDesktopCacheWithDfxTest', onlyValidateFolderExpand, false);
      expect(onlyValidateFolderExpand).assertFalse();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
    })

    it('SCBDesktopCacheManager_test_setDesktopCacheWithDfx_05', 0, (): void => {
      let cacheFlag: boolean = true;
      let onlyValidateFolderExpand: boolean = false;
      let mocker: MockKit = new MockKit();
      let isShowGlobalSearch: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(true);
      let isShowNegative: Function = mocker.mockFunc(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
      when(isShowNegative)(ArgumentMatchers.any).afterReturn(true);
      desktopCacheManager.setDesktopCacheWithDfx(cacheFlag,'setDesktopCacheWithDfxTest', onlyValidateFolderExpand, false);
      expect(onlyValidateFolderExpand).assertFalse();
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowGlobalSearch);
      mocker.ignoreMock(sOutSideWindowMgr, sOutSideWindowMgr.isShowNegative);
    })

    it('test_setNegativeScreenFreezeStateWithDfx_01', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.setNegativeScreenFreezeStateWithDfx(false,'test', rotation);
      expect(rotation).assertEqual(1);
    })

    it('test_setNegativeScreenFreezeStateWithDfx_02', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.setNegativeScreenFreezeStateWithDfx(false,'test', rotation);
      expect(rotation).assertEqual(1);
    })

    it('test_setNegativeScreenFreezeStateWithDfx_03', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.setNegativeScreenFreezeStateWithDfx(true,'test', rotation);
      expect(rotation).assertEqual(1);
    })

    it('test_setNegativeScreenFreezeStateWithDfx_04', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.setNegativeScreenFreezeStateWithDfx(true, 'dt test', rotation);
      expect(rotation).assertEqual(1);
    })

    it('test_setDesktopFreezeStateByWindowWithDfx_01', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.setDesktopFreezeStateByWindowWithDfx(true,'test', rotation, false);
      expect(rotation).assertEqual(1);
    })

    it('test_setDesktopFreezeStateByWindowWithDfx_02', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.setDesktopFreezeStateByWindowWithDfx(true,'test', rotation, false);
      expect(rotation).assertEqual(1);
    })

    it('test_setDesktopFreezeStateByWindowWithDfx_03', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.setDesktopFreezeStateByWindowWithDfx(false,'test', rotation, false);
      expect(rotation).assertEqual(1);
    })

    it('test_setDesktopFreezeStateByWindowWithDfx_04', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.setDesktopFreezeStateByWindowWithDfx(false,'test', rotation, false);
      expect(rotation).assertEqual(1);
    })

    it('test_setDesktopFreezeStateByWindowWithDfx_05', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      let mocker: MockKit = new MockKit();
      let isShowGlobalSearch: Function =
        mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(isShowGlobalSearch)(ArgumentMatchers.any).afterReturn(true);
      desktopCacheManager.setDesktopFreezeStateByWindowWithDfx(true, 'test', rotation, true);
      expect(rotation).assertEqual(1);
      mocker.ignoreMock(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      mocker.clearAll();
    })

    it('test_setWallPaperFreezeState_01', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.setWallPaperFreezeState(false,'test', rotation);
      expect(rotation).assertEqual(1);
    })

    it('test_setWallPaperFreezeState_02', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      (desktopCacheManager as object)['wallpaperFreezeReady'] = true;
      (desktopCacheManager as object)['wallpaperScale'] = 1;
      desktopCacheManager.setWallPaperFreezeState(true,'test', rotation);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(true);
    })

    it('test_setWallPaperFreezeState_03', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      (desktopCacheManager as object)['wallpaperFreezeReady'] = true;
      (desktopCacheManager as object)['wallpaperScale'] = 0;
      desktopCacheManager.setWallPaperFreezeState(true,'test', rotation);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_setWallPaperFreezeState_04', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      (desktopCacheManager as object)['wallpaperFreezeReady'] = false;
      (desktopCacheManager as object)['wallpaperScale'] = 0;
      desktopCacheManager.setWallPaperFreezeState(true,'test', rotation);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_setWallPaperFreezeState_05', 0, (): void => {
      let rotation: number = 1;
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.setWallPaperFreezeState(false,'test', rotation);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_setWallPaperFreezeReady_01', 0, (): void => {
      desktopCacheManager.setWallPaperFreezeReady(false, 'test');
      expect((desktopCacheManager as object)['wallpaperFreezeReady']).assertEqual(false);
    })

    it('test_setWallPaperFreezeReady_02', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeReady'] = false;
      (desktopCacheManager as object)['isWallpaperChanging'] = true;
      desktopCacheManager.setWallPaperFreezeReady(true, 'test');
      expect((desktopCacheManager as object)['wallpaperFreezeReady']).assertEqual(false);
    })

    it('test_setWallPaperFreezeReady_03', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeReady'] = false;
      (desktopCacheManager as object)['isWallpaperChanging'] = false;
      desktopCacheManager.setWallPaperFreezeReady(true, 'test');
      expect(desktopCacheManager).not().assertUndefined();
    })

    it('test_resetFreezeStateByScreenChange_01', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.resetFreezeStateByScreenChange(false);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_resetFreezeStateByScreenChange_02', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.resetFreezeStateByScreenChange(false);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(true);
    })

    it('test_resetFreezeStateByScreenChange_03', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.resetFreezeStateByScreenChange(true);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_resetFreezeStateByScreenChange_04', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.resetFreezeStateByScreenChange(true);
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_resetFreezeStateOnly_01', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.resetFreezeStateOnly('test');
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_resetFreezeStateOnly_02', 0, (): void => {
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.resetFreezeStateOnly('test');
      expect((desktopCacheManager as object)['wallpaperFreezeState']).assertEqual(false);
    })

    it('test_checkRotation_01', 0, (): void => {
      AppStorage.setOrCreate('isPortrait', false);
      (desktopCacheManager as object)['rotationMode'] = 0;
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.checkRotation();
      expect((desktopCacheManager as object)['rotationMode']).assertEqual(-1);
    })

    it('test_checkRotation_02', 0, (): void => {
      AppStorage.setOrCreate('isPortrait', true);
      (desktopCacheManager as object)['rotationMode'] = 0;
      (desktopCacheManager as object)['wallpaperFreezeState'] = true;
      desktopCacheManager.checkRotation();
      expect((desktopCacheManager as object)['rotationMode']).assertEqual(0);
    })

    it('test_checkRotation_03', 0, (): void => {
      AppStorage.setOrCreate('isPortrait', true);
      (desktopCacheManager as object)['rotationMode'] = 0;
      (desktopCacheManager as object)['wallpaperFreezeState'] = false;
      desktopCacheManager.checkRotation();
      expect((desktopCacheManager as object)['rotationMode']).assertEqual(0);
    })

    it('test_setDesktopCacheState_01', 0, (): void => {
      (desktopCacheManager as object)['desktopCacheState'] = false;
      desktopCacheManager.setDesktopCacheState(true, 'test');
      expect((desktopCacheManager as object)['desktopCacheState']).assertEqual(true);
    })

    it('test_setDesktopCacheState_02', 0, (): void => {
      (desktopCacheManager as object)['desktopCacheState'] = false;
      desktopCacheManager.setDesktopCacheState(false, 'test');
      expect((desktopCacheManager as object)['desktopCacheState']).assertEqual(false);
    })

    it('test_setWallPaperScale', 0, (): void => {
      desktopCacheManager.setWallPaperScale(1, 'dt test');
      expect((desktopCacheManager as object)['wallpaperScale']).assertEqual(1);
    })

    it('test_resetFreezeStateAndReady', 0, (): void => {
      desktopCacheManager.resetFreezeStateAndReady('dt test');
      expect((desktopCacheManager as object)['wallpaperFreezeReady']).assertFalse();
    })

    it('test_wallpaperChanging', 0, (): void => {
      (desktopCacheManager as object)['isWallpaperChanging'] = false;
      desktopCacheManager.wallpaperChanging(false);

      desktopCacheManager.wallpaperChanging(true);
      expect((desktopCacheManager as object)['isWallpaperChanging']).assertTrue();

      (desktopCacheManager as object)['wallpaperType'] = 'not script';
      desktopCacheManager.wallpaperChanging(false);
      expect((desktopCacheManager as object)['isWallpaperChanging']).assertFalse();
    })
  })
}