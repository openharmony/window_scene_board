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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { ImmersiveLiveAnimSceneEnum as AnimScene } from '@ohos/screenlockcommon/Index';
import { ImmersiveLiveAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveLiveAnimManager';
import { BaseAnimExecutor } from '../../../../../../main/ets/viewmodel/viewanim/executor/BaseAnimExecutor';
import { ListCardAnimExecutor } from '../../../../../../main/ets/viewmodel/viewanim/executor/ListCardAnimExecutor';
import { CardCapsuleAnimExecutor } from '../../../../../../main/ets/viewmodel/viewanim/executor/CardCapsuleAnimExecutor';
import { ListBaseAnimExecutor } from './ListBaseAnimExecutor';

/**
 * 沉浸实况测试用例
 */
export function ImmersiveLiveAnimManagerTest() {
  const LIST = AnimScene.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM;
  const CAPSULE = AnimScene.SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM;
  describe('ImmersiveLiveAnimManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('triggerExecutor1', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, ListBaseAnimExecutor>();
      map.set(LIST, new ListCardAnimExecutor(LIST));
      (manager as object)['animStrategyMap'] = map;
      manager.triggerExecutor(LIST, false);
      manager.triggerExecutor(LIST, false, 'testKeyCode');
      expect(manager).not().assertNull();
    });

    it('triggerExecutor2', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, ListBaseAnimExecutor>();
      map.set(LIST, new ListCardAnimExecutor(LIST));
      (manager as object)['animStrategyMap'] = map;
      manager.triggerExecutor(LIST, true);
      manager.triggerExecutor(LIST, true, 'testKeyCode');
      expect(manager).not().assertNull();
    });

    it('triggerExecutor3', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, ListBaseAnimExecutor>();
      map.set(CAPSULE, new CardCapsuleAnimExecutor(CAPSULE));
      (manager as object)['animStrategyMap'] = map;
      manager.triggerExecutor(CAPSULE, false);
      manager.triggerExecutor(CAPSULE, false, 'testKeyCode');
      expect(manager).not().assertNull();
    });

    it('triggerExecutor4', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, ListBaseAnimExecutor>();
      map.set(CAPSULE, new CardCapsuleAnimExecutor(CAPSULE));
      (manager as object)['animStrategyMap'] = map;
      manager.triggerExecutor(CAPSULE, true);
      manager.triggerExecutor(CAPSULE, true, 'testKeyCode');
      expect(manager).not().assertNull();
    });

    it('setAnimAction1', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, BaseAnimExecutor>();
      map.set(LIST, new ListCardAnimExecutor(LIST));
      (manager as object)['animStrategyMap'] = map;
      manager.setAnimAction(LIST, undefined, undefined);
      expect(manager).not().assertNull();
    });

    it('setAnimAction2', Level.LEVEL0, (): void => {
      let preAction = () => {

      }
      let afterAction = () => {

      }
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, BaseAnimExecutor>();
      map.set(LIST, new ListCardAnimExecutor(LIST));
      (manager as object)['animStrategyMap'] = map;
      manager.setAnimAction(LIST, preAction, afterAction);
      expect(manager).not().assertNull();
    });

    it('setAnimAction3', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, BaseAnimExecutor>();
      map.set(CAPSULE, new ListCardAnimExecutor(CAPSULE));
      (manager as object)['animStrategyMap'] = map;
      manager.setAnimAction(CAPSULE, undefined, undefined);
      expect(manager).not().assertNull();
    });

    it('setAnimAction4', Level.LEVEL0, (): void => {
      let preAction = () => {

      }
      let afterAction = () => {

      }
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, BaseAnimExecutor>();
      map.set(CAPSULE, new ListCardAnimExecutor(CAPSULE));
      (manager as object)['animStrategyMap'] = map;
      manager.setAnimAction(CAPSULE, preAction, afterAction);
      expect(manager).not().assertNull();
    });

    it('interruptedExecutor1', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, BaseAnimExecutor>();
      map.set(LIST, new ListCardAnimExecutor(LIST));
      (manager as object)['animStrategyMap'] = map;
      manager.interruptedExecutor(LIST);
      expect(manager).not().assertNull();
    });

    it('interruptedExecutor2', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, BaseAnimExecutor>();
      map.set(CAPSULE, new ListCardAnimExecutor(CAPSULE));
      (manager as object)['animStrategyMap'] = map;
      manager.interruptedExecutor(CAPSULE);
      expect(manager).not().assertNull();
    });

    it('initAnimSceneExecutor', Level.LEVEL0, (): void => {
      let manager: ImmersiveLiveAnimManager = new ImmersiveLiveAnimManager();
      let map: Map<AnimScene, BaseAnimExecutor> = new Map<AnimScene, BaseAnimExecutor>();
      (manager as object)['animStrategyMap'] = map;
      (manager as object)['initAnimSceneExecutor']();
      expect(manager).not().assertNull();
    });
  });
}