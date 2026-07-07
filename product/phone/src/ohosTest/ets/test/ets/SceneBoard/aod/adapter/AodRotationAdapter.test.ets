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

import { describe, it, expect, when, MockKit } from '@ohos/hypium';
import { AodRotationAdapter } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/AodRotationAdapter';
import { aodSettingsModule,IAodDisplayInfo } from '@ohos/aod';
import { display } from '@kit.ArkUI';
import { Rotation0Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation0Strategy';
import { Rotation180Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation180Strategy';
import { Rotation270Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation270Strategy';
import { Rotation90Strategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/Rotation90Strategy';
import { RotationStrategy } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/adapter/rotation/RotationStrategy';


export function AodRotationAdapterTest() {
  describe('AodRotationAdapterTest', () => {
    let aodDisplayInfo : IAodDisplayInfo = {
      width: 2224,
      height: 2496,
      rotation: 0,
      orientation: 0,
      deviceInfo: {deviceType: 'phone', phoneType: 1, displayState: 1, foldState: 1},
    }

    it('test_isIntelligentMode_if', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aodSettingsModule, aodSettingsModule.isOuterScreenShow);
      when(mockFunc)().afterReturn(true);

      const aodFullFoldConfigClt = new AodRotationAdapter(aodDisplayInfo, createFoldRotationStrategy(aodDisplayInfo));
      let res = aodFullFoldConfigClt.isIntelligentMode();
      expect(res).assertEqual(true);
      mocker.clear(aodSettingsModule);
      mocker.clearAll();
    });

    it('test_isScheduledMode_if', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aodSettingsModule, aodSettingsModule.isOuterScreenShow);
      when(mockFunc)().afterReturn(true);

      const aodFullFoldConfigClt = new AodRotationAdapter(aodDisplayInfo, createFoldRotationStrategy(aodDisplayInfo));
      let res = aodFullFoldConfigClt.isScheduledMode();
      expect(res).assertEqual(false);
      mocker.clear(aodSettingsModule);
      mocker.clearAll();
    });

  })
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