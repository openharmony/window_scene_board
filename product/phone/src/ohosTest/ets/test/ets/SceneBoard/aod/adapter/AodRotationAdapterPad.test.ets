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

import { describe,  it, expect } from '@ohos/hypium'
import { AodRotationAdapterPad } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/AodRotationAdapterPad';
import display from '@ohos.display';
import { IAodDisplayInfo, ComponentRect ,aodSettingsModule} from '@ohos/aod';
import { Rotation0Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation0Strategy';
import { Rotation180Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation180Strategy';
import { Rotation270Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation270Strategy';
import { Rotation90Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation90Strategy';
import { RotationStrategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/RotationStrategy';

export function AodRotationAdapterPadTest() {
  describe('AodRotationAdapterPadTest', () => {

    let componentRect: ComponentRect = {
      left: 100,
      right: 100,
      top: 200,
      bottom: 200
    }

    it('test_createMoveData1', 0, (): void => {
      let aodDisplayInfo : IAodDisplayInfo = {
        width: 2224,
        height: 2496,
        rotation: 0,
        orientation: 0,
        deviceInfo: {deviceType: 'phone', phoneType: 1, displayState: 1, foldState: 1},
      }

      const aodRotationAdapterPad = new AodRotationAdapterPad(aodDisplayInfo, createFoldRotationStrategy(aodDisplayInfo));
      aodRotationAdapterPad.createMoveData(componentRect,true);
      expect(true).assertTrue();
    });

    it('test_createMoveData2', 0, (): void => {
      let aodDisplayInfo : IAodDisplayInfo = {
        width: 2224,
        height: 2496,
        rotation: 0,
        orientation: 1,
        deviceInfo: {deviceType: 'phone', phoneType: 1, displayState: 1, foldState: 1},
      }

      const aodRotationAdapterPad = new AodRotationAdapterPad(aodDisplayInfo, createFoldRotationStrategy(aodDisplayInfo));
      aodRotationAdapterPad.createMoveData(componentRect,true);
      expect(true).assertTrue();
    });

    it('test_createMoveData3', 0, (): void => {
      let aodDisplayInfo : IAodDisplayInfo = {
        width: 2224,
        height: 2496,
        rotation: 0,
        orientation: 2,
        deviceInfo: {deviceType: 'phone', phoneType: 1, displayState: 1, foldState: 1},
      }


      const aodRotationAdapterPad = new AodRotationAdapterPad(aodDisplayInfo, createFoldRotationStrategy(aodDisplayInfo));
      aodRotationAdapterPad.createMoveData(componentRect,true);
      expect(true).assertTrue();
    });

  });
}
function createFoldRotationStrategy(displayInfo: IAodDisplayInfo): RotationStrategy {
  switch (displayInfo.rotation) {
    case display.Orientation.PORTRAIT:
      return new Rotation0Strategy();
    case display.Orientation.LANDSCAPE:
      return new Rotation90Strategy();
    case display.Orientation.PORTRAIT_INVERTED:
      return new Rotation180Strategy();
    case display.Orientation.LANDSCAPE_INVERTED:
      return new Rotation270Strategy();
    default:
      return new Rotation0Strategy();
  }
}