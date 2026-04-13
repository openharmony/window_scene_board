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
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import DialogServiceExtAbility from '../main/ets/ServiceExtAbility/ExtAbility';
import rpc from '@ohos.rpc';

const COMMAND_START_DIALOG = 1;

export function ExtAbilityTest () {
  describe('ExtAbilityTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })
    it('onRemoteRequest', 0, (): void => {
      let data = rpc.MessageSequence.create()
      let reply = rpc.MessageSequence.create()
      let option = new rpc.MessageOption()
      data.writeInt(3)
      data.writeString("bundleName");
      data.writeString("com.ohos.powerdialog");
      data.writeString("`abilityName");
      data.writeString("PowerUiExtensionAbility");
      data.writeString("parameters");
      data.writeString("{\"ability.want.params.uiExtensionType\":\"sysDialog/power\",\"sysDialogZOrder\":2}");
      let ability: DialogServiceExtAbility = new DialogServiceExtAbility();
      let sub = ability.onConnect();
      sub.onRemoteRequest(COMMAND_START_DIALOG, data, reply, option);
    })
  })
}
