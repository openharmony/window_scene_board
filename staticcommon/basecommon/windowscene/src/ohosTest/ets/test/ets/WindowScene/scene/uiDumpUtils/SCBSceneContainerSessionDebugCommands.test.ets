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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
SCBSceneContainerSession,
SCBSceneContainerSessionArray
} from '../../../../../../../main/ets/scene/session/SCBSceneContainerSession';
import { SCBSceneInfo, } from '../../../../../../../main/ets/scene/session/SCBSceneInfo';
import { SCBSceneSession } from '../../../../../../../main/ets/scene/session/SCBSceneSession';
import { SCBScreenProperty } from '../../../../../../../main/ets/screen/session/SCBScreenSession';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  SCBSceneContainerSessionDebugCommands
} from '../../../../../../../main/ets/scene/dump/SCBSceneContainerSessionDebugCommands';

export default function SCBSceneContainerSessionDebugCommandsTest() {
  let scbSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundleName', 'moduleName', 'abilityName');
  let scbSceneSession: SCBSceneSession =
    new SCBSceneSession(sceneSessionManager.requestSceneSession(scbSceneInfo), scbSceneInfo);
  let container: SCBSceneContainerSession = new SCBSceneContainerSession(scbSceneSession, new SCBScreenProperty());
  let containerId: string = container.containerId.toString();
  let containerSessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
  describe('SCBSceneContainerSessionDebugCommandsTest', () => {
    beforeAll(() => {
      containerSessionList.add(container)
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    // dealContainerSessionList
    it('dealContainerSessionList_emptyList', 0, () => {
      let arg: string[] = [];
      let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionList(containerSessionList, arg);
      expect(result).assertEqual("Available modules:-n -all -i");
    })
    it('dealContainerSessionList_other', 0, () => {
      let arg: string[] = [""];
      let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionList(containerSessionList, arg);
      expect(result).assertEqual("Available modules:-n -all -i");
    })
    // dealContainerSessionCommands
    dealContainerSessionCommands(containerSessionList, containerId);
  })
}

function dealContainerSessionCommands(containerSessionList: SCBSceneContainerSessionArray, containerId: string) {
  it('dealContainerSessionCommands_emptyList', 0, () => {
    let arg: string[] = [];
    let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(containerSessionList, arg);
    expect(result).assertEqual("Available modules:-id");
  });
  it('dealContainerSessionCommands_id', 0, () => {
    let arg: string[] = ["-id"];
    let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(containerSessionList, arg);
    expect(result).assertContain(containerId);
  });
  it('dealContainerSessionCommands_pri', 0, () => {
    let arg: string[] = ["-id", containerId, "-pri"];
    let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(containerSessionList, arg);
    expect(result).assertContain('"bundleName":"bundleName","moduleName":"moduleName","abilityName":"abilityName"');
  });
  it('dealContainerSessionCommands_sec', 0, () => {
    let arg: string[] = ["-id", containerId, "-sec"];
    let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(containerSessionList, arg);
    expect(result).assertEqual("[]");
  });
  it('dealContainerSessionCommands_other', 0, () => {
    let arg: string[] = ["-id", containerId, ""];
    let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(containerSessionList, arg);
    expect(result).assertContain("Available modules:-i -all divider -pri -sec");
  });
  it('dealContainerSessionCommands_not_id', 0, () => {
    let arg: string[] = ["-ids", containerId, ""];
    let result = SCBSceneContainerSessionDebugCommands.dealContainerSessionCommands(containerSessionList, arg);
    expect(result).assertContain("Available modules:-id");
  });
}
