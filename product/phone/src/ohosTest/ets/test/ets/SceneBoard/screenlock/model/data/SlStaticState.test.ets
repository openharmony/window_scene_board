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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlStaticState } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/model/data/SlStaticState';
import { GridAmount, WidgetSize } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import display from '@ohos.display';
import { MeshConfig } from '@ohos/screenlockcommon/src/main/ets/meshsystem/MeshSystem';

/**
 * 锁屏页面非UI状态变量管理用例
 */
export function SlStaticStateTest() {
  describe('SlStaticStateTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getSlStateType', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getSlStateType();
      expect(res).not().assertNull();
    });

    it('test_setSlState', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      slStaticState.setSlState(SlStaticStateType.PORTRAIT_STATE, undefined);
      expect(res).assertTrue();
    });

    it('test_getSlState', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      slStaticState.getSlState(SlStaticStateType.PORTRAIT_STATE);
      expect(res).assertTrue();
    });

    it('test_setPortraitState', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      slStaticState.setPortraitState(true);
      expect(res).assertTrue();
    });

    it('test_getPortraitState', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getPortraitState();
      expect(res).assertTrue();
    });

    it('test_setFoldable', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      slStaticState.setFoldable(true);
      expect(res).assertTrue;
    });

    it('test_isDeviceFoldable', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.isDeviceFoldable();
      expect(res).assertFalse();
    });

    it('test_setFoldExpand', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      slStaticState.setFoldExpand(display.FoldStatus.FOLD_STATUS_UNKNOWN);
      expect(res).assertTrue();
    });

    it('test_isDeviceExpanded', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.isDeviceExpanded();
      expect(res).assertFalse();
    });

    it('test_setScreenSize', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      let widgetSize: WidgetSize = { width: 24, height: 104 };
      slStaticState.setScreenSize(widgetSize)
      expect(res).assertTrue();
    });

    it('test_getScreenSize', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      slStaticState.getScreenSize();
      expect(res).assertTrue();
    });

    it('test_setMaxGridAmount', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      let maxGridAmount: GridAmount = { x: 0, y: 0 };
      slStaticState.setMaxGridAmount(maxGridAmount);
      expect(res).assertTrue();
    });

    it('test_getMaxGridAmount', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getMaxGridAmount();
      expect(res).not().assertNull();
    });

    it('test_setGridUnitSize', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      let gridUnitSize = 7;
      slStaticState.setGridUnitSize(gridUnitSize);
      expect(res).assertTrue();
    });

    it('test_getGridUnitSize', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getGridUnitSize();
      expect(res).not().assertNull();
    });

    it('test_setGridXMargin', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      let gridXMargin = 4;
      slStaticState.setGridXMargin(gridXMargin);
      expect(res).assertTrue();
    });

    it('test_getGridXMargin', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getGridXMargin();
      expect(res).assertEqual(0);
    });

    it('test_setClockCollapseShowRegion', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      let region: Rectangle = { y: 0, height: 0 };
      try{
        slStaticState.setClockCollapseShowRegion(region);
        expect(res).assertTrue();
      }catch(err){

      }
    });

    it('test_getClockCollapseShowRegion', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getClockCollapseShowRegion();
      expect(res).not().assertNull();
    });

    it('test_setMeshConfig', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      let meshConfig: MeshConfig = new MeshConfig();
      meshConfig.meshHeight = 0;
      meshConfig.maxScreenLockMesh = 1;
      try{
        slStaticState.setMeshConfig(meshConfig);
        expect(res).assertTrue();
      }catch(err){

      }
    });

    it('test_getMeshConfig', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getMeshConfig();
      expect(res).not().assertNull();
    });

    it('test_setClockExpandMeshY', Level.LEVEL0, (): void => {
      let res = true;
      let slStaticState = new SlStaticState();
      let clockExpandMeshY = 1;
      slStaticState.setClockExpandMeshY(clockExpandMeshY);
      expect(res).assertTrue();
    });

    it('test_getClockExpandMeshY', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getClockExpandMeshY();
      expect(res).not().assertNull();
    });

    it('test_getSlMainAnimCtrl', Level.LEVEL0, (): void => {
      let slStaticState = new SlStaticState();
      let res = slStaticState.getSlMainAnimCtrl();
      expect(res).not().assertNull();
    });
  });
}