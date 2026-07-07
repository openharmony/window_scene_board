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
import { describe, expect, it } from '@ohos/hypium';
import ThreeButtonUpgradeUIExtAbility
  from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/ability/ThreeButtonUpgradeUIExtAbility';
import { UIExtensionContentSession } from '@kit.AbilityKit';

export default function ThreeButtonUpgradeUIExtAbilityTest() {
  describe('ThreeButtonUpgradeUIExtAbilityTest', () => {
    it('onForeground_001', 0, () => {
      let ability: ThreeButtonUpgradeUIExtAbility = new ThreeButtonUpgradeUIExtAbility();
      ability.onForeground();
      expect(ability).not().assertUndefined();
    })
    it('onBackground_001', 0, () => {
      let ability: ThreeButtonUpgradeUIExtAbility = new ThreeButtonUpgradeUIExtAbility();
      ability.onBackground();
      expect(ability).not().assertUndefined();
    })
    it('onDestroy_001', 0, () => {
      let ability: ThreeButtonUpgradeUIExtAbility = new ThreeButtonUpgradeUIExtAbility();
      ability.onDestroy();
      expect(ability).not().assertUndefined();
    })
    it('onSessionCreate_001', 0, () => {
      let ability: ThreeButtonUpgradeUIExtAbility = new ThreeButtonUpgradeUIExtAbility();
      const want: Want = { abilityName: 'testAbility' };
      const contentSession: UIExtensionContentSession = {} as UIExtensionContentSession;
      ability.onSessionCreate(want, contentSession);
      expect(ability).not().assertUndefined();
    });
    it('onSessionDestroy_001', 0, () => {
      let ability: ThreeButtonUpgradeUIExtAbility = new ThreeButtonUpgradeUIExtAbility();
      const contentSession: UIExtensionContentSession = {} as UIExtensionContentSession;
      ability.onSessionDestroy(contentSession);
      expect(ability).not().assertUndefined();
    });
  })
}
