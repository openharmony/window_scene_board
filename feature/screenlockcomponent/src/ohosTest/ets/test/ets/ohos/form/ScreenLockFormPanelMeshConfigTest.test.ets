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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import {
  ScreenLockFormPanelMeshConfig
} from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelMeshConfig';
import panelMeshY from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelMeshConfig';
import type {
  OnPanelMeshYChange
} from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelMeshConfig';
import meshYListener from '@ohos/screenlockwidget/src/main/ets/form/ScreenLockFormPanelMeshConfig';

export default function ScreenLockFormPanelMeshConfigTest() {

  describe('ScreenLockFormPanelMeshConfigTest', (): void => {
    let mScreenLockFormPanelMeshConfig: ScreenLockFormPanelMeshConfig = new ScreenLockFormPanelMeshConfig();
    let listener: OnPanelMeshYChange;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_setPanelBeginMesh_return', 0, (): void => {
      let panelBeginMesh: number = 2;
      mScreenLockFormPanelMeshConfig.setPanelBeginMesh(panelBeginMesh)
      expect(mScreenLockFormPanelMeshConfig.panelBeginMeshY).assertEqual(2);
    })

    it('test_setPanelHeight_return_0', 0, (): void => {
      let panelHeight: number = 1;
      mScreenLockFormPanelMeshConfig.setPanelHeight(panelHeight)
      expect(mScreenLockFormPanelMeshConfig.panelBeginMeshX).assertEqual(0);
    })

    it('test_setPanelHeight_return_1', 0, (): void => {
      let panelHeight: number = 2;
      mScreenLockFormPanelMeshConfig.setPanelHeight(panelHeight)
      expect(mScreenLockFormPanelMeshConfig.panelBeginMeshX).assertEqual(1);
    })

    it('test_setPanelHeight_return_2', 0, (): void => {
      let panelHeight: number = 3;
      let result = panelMeshY;
      mScreenLockFormPanelMeshConfig.setPanelHeight(panelHeight);
      expect(result).not().assertNull();
    })

    it('test_setPanelMeshYChangeListener_return', 0, (): void => {
      let result = meshYListener;
      mScreenLockFormPanelMeshConfig.setPanelMeshYChangeListener(listener)
      expect(result).not().assertNull();
    })
  })
}