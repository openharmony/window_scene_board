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

import { describe, it, Level, expect } from '@ohos/hypium';
import MultiWindowSettingAbility
  from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/settings/abilities/MultiWindowSettingAbility';
import { common, UIExtensionContentSession, Want } from '@kit.AbilityKit';
import { creatObject } from './ReflectionUtils';

export default function MultiWindowSettingAbilityTest() {
  describe('MultiWindowSettingAbilityTest_001', (): void => {
    onCreateTest_01();
    onSessionCreateTest_01();
  });
}

function onSessionCreateTest_01() {
  it('onSessionCreateTest_001', Level.LEVEL0, (): void => {
    let want: Want = {};
    let session = creatObject(new Array<UIExtensionContentSession>());
    let ability = new MultiWindowSettingAbility();
    ability.onSessionCreate(want,session);
    expect(true).assertEqual(true);
  });
}

function onCreateTest_01() {
  it('onCreateTest001', Level.LEVEL0, (): void => {
    let ability = new MultiWindowSettingAbility();
    ability.onCreate();
    expect(true).assertEqual(true);
  });
  it('onCreateTest002', Level.LEVEL0, (): void => {
    let ability = new MultiWindowSettingAbility();
    ability.context = getContext() as common.UIExtensionContext;
    ability.onCreate();
    expect(true).assertEqual(true);
  });
}


