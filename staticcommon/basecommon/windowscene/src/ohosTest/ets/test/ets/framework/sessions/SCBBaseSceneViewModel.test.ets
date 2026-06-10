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

import { describe, it, expect, MockKit, when, ArgumentMatchers, beforeAll, afterAll, Level } from '@ohos/hypium';
import { SCBBaseSceneViewModel } from '../../../../../../main/ets/scene/framework/SceneFrameworkIndex';
import {
  SCBScreenProperty,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBSceneInfo
} from '../../../../../../main/ets/TsIndex';

export default function SCBBaseSceneViewModelTest() {
  let sceneInfo = new SCBSceneInfo('com.test', 'entry', 'MainAbility');
  sceneInfo.screenId = 0;
  let sceneSession = SCBSceneSessionManager.getInstance().requestSceneSession(sceneInfo);

  beforeAll(() => {

  });

  afterAll(() => {

  });

  describe('SCBBaseSceneViewModel_init_test', () => {

    it('should_initialize_screenProperty_and_sceneSession_correctly', 0, () => {
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(sceneSession, sceneInfo);
      let baseSceneViewModel = new SCBBaseSceneViewModel(screenProperty, scbSceneSession);

      expect(baseSceneViewModel.screenProperty).assertEqual(screenProperty);
      expect(baseSceneViewModel.sceneSession).assertEqual(sceneSession);
    });
  });

}