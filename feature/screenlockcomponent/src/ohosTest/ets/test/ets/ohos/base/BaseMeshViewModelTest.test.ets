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
import { BaseMeshViewModel }  from '@ohos/screenlockcommon/src/main/ets/base/BaseMeshViewModel';
import { ComponentType , ComponentCallback }  from '@ohos/screenlockcommon/src/main/ets/base/BaseMeshViewModel';
import { MeshRange } from '@ohos/screenlockcommon/src/main/ets/meshsystem/MeshSystem';

export default function BaseMeshViewModelTest() {

  describe('BaseMeshViewModelTest', (): void => {

    let mBaseMeshViewModel:BaseMeshViewModel = new BaseMeshViewModel();
    let componentType: ComponentType | string;
    let callback: ComponentCallback;
    let meshRange: MeshRange;
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_registerComponentCallback_return', 0, (): void => {
      mBaseMeshViewModel.registerComponentCallback(componentType,callback);
      expect(componentType).not().assertNull();
    })

    it('test_unRegisterComponentCallback_return', 0, (): void => {
      mBaseMeshViewModel.unRegisterComponentCallback(componentType,callback);
      expect(componentType).not().assertNull();
    })

    it('test_handleComponentCallback_return', 0, (): void => {
      let componentType: ComponentType | string = 'res';
      mBaseMeshViewModel.handleComponentCallback(componentType,meshRange);
      expect(componentType).not().assertNull();
    })
  })
}