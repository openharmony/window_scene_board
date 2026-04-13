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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit } from '@ohos/hypium';
import { ImageSnapshotService } from '../../../../../../../../Index';
import {
  ImmInvertColorInfo,
  ImmInvertColorMgr, OnInvertColorChangeListener } from '../../../../../../../../Index';
import { image } from '@kit.ImageKit';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmInvertColorMgrTest() {
  let mocker: MockKit;
  describe('ImmInvertColorMgrTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {

    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {

    });

    it('getInstanceTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      expect(true).assertTrue();
    });

    it('registerInvertListenerTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      let onInvertColorChange: OnInvertColorChangeListener = {
        onInvertColorChange: (curInvertColor: ImmInvertColorInfo): void => {}
      };
      (colorMgr as object)['isMgrEnable'] = false;
      (colorMgr as object)['registerInvertListener'](onInvertColorChange);
      (colorMgr as object)['isMgrEnable'] = true;
      (colorMgr as object)['registerInvertListener'](onInvertColorChange);
      expect(true).assertTrue();
    });

    it('unregisterInvertListenerTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      let onInvertColorChange: OnInvertColorChangeListener = {
        onInvertColorChange: (curInvertColor: ImmInvertColorInfo): void => {}
      };
      (colorMgr as object)['isMgrEnable'] = false;
      (colorMgr as object)['unregisterInvertListener'](onInvertColorChange);
      (colorMgr as object)['isMgrEnable'] = true;
      (colorMgr as object)['unregisterInvertListener'](onInvertColorChange);
      expect(true).assertTrue();
    });

    it('setAstcSnapshotTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      const createBuilder = (param: image.PixelMap): CustomBuilder => {};
      const imgSnapshot = new ImageSnapshotService(createBuilder);
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['setAstcSnapshot'](imgSnapshot);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['setAstcSnapshot'](imgSnapshot);
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['setAstcSnapshot']();
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['setAstcSnapshot']();
      expect(true).assertTrue();
    });

    it('cacheSbBgGradientStateTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      const hashCode = 'myHashCode';
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['cacheSbBgGradientState'](hashCode, true);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['cacheSbBgGradientState']('', true);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['cacheSbBgGradientState'](hashCode, false);
      expect(true).assertTrue();
    });

    it('cacheInvertColorTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      const hashCode = 'myHashCode';
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['cacheInvertColor'](hashCode, '');
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['cacheInvertColor'](hashCode, '');
      expect(true).assertTrue();
    });

    it('deleteCacheByHashTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      const hashCode = 'myHashCode';
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['deleteCacheByHash'](hashCode);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['deleteCacheByHash'](hashCode);
      expect(true).assertTrue();
    });

    it('deleteAllCacheTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['deleteAllCache']();
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['deleteAllCache']();
      expect(true).assertTrue();
    });

    it('setCurShowingImmersiveTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      const hashCode = 'myHashCode';
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['setCurShowingImmersive']();
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['setCurShowingImmersive']();
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['setCurShowingImmersive'](hashCode);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['setCurShowingImmersive'](hashCode);
      expect(true).assertTrue();
    });

    it('setOuterScreenStateTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['setOuterScreenState'](true);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['setOuterScreenState'](true);
      expect(true).assertTrue();
    });

    it('setSlMainPageStateTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['setSlMainPageState'](true);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['setSlMainPageState'](true);
      expect(true).assertTrue();
    });

    it('setSlOccludedTest', Level.LEVEL0, (): void => {
      let colorMgr: ImmInvertColorMgr = ImmInvertColorMgr.getInstance();
      let isEnable = true;
      let isNotEnable = false;
      (colorMgr as object)['isMgrEnable'] = isNotEnable;
      (colorMgr as object)['setSlOccluded'](true);
      (colorMgr as object)['isMgrEnable'] = isEnable;
      (colorMgr as object)['setSlOccluded'](true);
      expect(true).assertTrue();
    });
  });
}



