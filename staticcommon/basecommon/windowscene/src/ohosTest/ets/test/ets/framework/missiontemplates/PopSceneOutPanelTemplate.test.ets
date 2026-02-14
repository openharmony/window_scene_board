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
import { SCBScenePanelMissionHandler } from '../../../../../../main/ets/scene/framework/missions/SCBScenePanelMissionHandler';
import { describe, it, expect, MockKit, when, ArgumentMatchers, beforeAll, afterAll, Level } from '@ohos/hypium';
import { SCBScreenMissionHandler } from '../../../../../../main/ets/scene/framework/missions/SCBScreenMissionHandler';

export default function PopSceneOutPanelTemplate() {
  beforeAll(()=> {

  });

  afterAll(() => {

  });

  describe('PopSceneOutPanelTemplate_test', () => {

    it('test_when_PanelAttachAndDetach_then_PanelCount_should_right', Level.LEVEL0, () => {
      let screenHandler = new SCBScreenMissionHandler(0);
      let panelHandler = new SCBScenePanelMissionHandler();

      expect(screenHandler.panelCount === 0).assertTrue();
      screenHandler.onPanelAttach(panelHandler);
      expect(screenHandler.panelCount === 1).assertTrue();
      screenHandler.onPanelDetach(panelHandler);
      expect(screenHandler.panelCount === 0).assertTrue();
    })
  });
}
