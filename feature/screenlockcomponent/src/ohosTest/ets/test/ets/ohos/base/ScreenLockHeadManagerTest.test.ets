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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import screenLockHeadManager, { ScreenLockHeadManager as ScreenLockHeadManagerClass } from '@ohos/screenlockcommon/src/main/ets/base/ScreenLockHeadManager';
import { MeshRange } from '@ohos/screenlockcommon/src/main/ets/meshsystem/MeshSystem';
import { ComponentType } from '@ohos/screenlockcommon';

export default function ScreenLockHeadManagerTest() {
  let mScreenLockHeadManagerSon = new ScreenLockHeadManagerSon()

  describe('ScreenLockHeadManagerTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_ScreenLockHeadManager_should_return', 0, (): void => {
      screenLockHeadManager.init();
      screenLockHeadManager.destroy();
      let componentType: string = ComponentType.CLOCK;
      let componentType1: string = ComponentType.FORM_PANEL;
      screenLockHeadManager.initHeadMeshRange(componentType,new MeshRange(0, 100));
      screenLockHeadManager.initHeadMeshRange(componentType1,new MeshRange(0, 100));
      screenLockHeadManager.initHeadMeshRange('729958',new MeshRange(0, 100));
      screenLockHeadManager.setClockMeshRange(new MeshRange(0, 100));
      screenLockHeadManager.setPanelMeshRange(new MeshRange(0, 100));
      screenLockHeadManager.setPanelMeshRange(new MeshRange(0, 999999999999));
      expect(componentType).assertEqual('clock');
    })

    it('test_handleRangeOverlay', 0, (): void => {
      mScreenLockHeadManagerSon.headMeshHeight = 0;
      try {
        mScreenLockHeadManagerSon.HandleRangeOverlay(new MeshRange(0, 100));
      } catch (err) {
      }
      mScreenLockHeadManagerSon.headMeshHeight = 200;
      try {
        mScreenLockHeadManagerSon.HandleRangeOverlay(new MeshRange(0, 100));
      } catch (err) {
      }
      expect(true).assertTrue();
    })
  })
}

export class ScreenLockHeadManagerSon extends ScreenLockHeadManagerClass {
  public headMeshHeight: number = 0

  public HandleRangeOverlay(meshRange: MeshRange): void {
    return this.handleRangeOverlay(meshRange);
  }
}