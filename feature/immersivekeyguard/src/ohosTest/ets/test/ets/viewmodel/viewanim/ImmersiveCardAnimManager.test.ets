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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ImmersiveCardAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveCardAnimManager';
import { AnimStyleType } from '../../../../../../main/ets/model/data/anim/ImmersiveAnimStyle';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { ImmersiveCardList } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCardList';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { PropertyType } from '@ohos/systemuicommon';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCardAnimManagerTest() {
  describe('ImmersiveCardAnimManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_ImmersiveCardAnimManager', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      manager.doDeleteCardAnim();
      expect(manager).not().assertNull();
    });

    it('test_getImmersiveCardData', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      let res = manager.getImmersiveCardData();
      expect(res).not().assertNull();
    });

    it('test_fillImmersiveCardAnimData', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      let cardList = new ImmersiveCardList();
      manager.setImmersiveCardData(cardList);
      manager.fillImmersiveCardAnimData();
      cardList.setShowData(new ImmersiveNtfData());
      manager.fillImmersiveCardAnimData();
      manager.clearImmersiveCardAnimData();
      expect(manager).not().assertNull();
    });

    it('test_getRootAnimStyle', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      let res = manager.getRootAnimStyle();
      expect(res).not().assertNull();
    });

    it('test_setRootStyleValue', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      manager.setRootStyleValue(AnimStyleType.PADDING_TOP);
      expect(manager).not().assertNull();
    });

    it('test_getRootViewPosition', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      let res = manager.getRootViewPosition();
      expect(res).not().assertNull();
    });

    it('test_setRootAnimating', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      manager.setRootAnimating(true);
      manager.setRootAnimating(true, ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      manager.setRootAnimating(false);
      manager.setRootAnimating(false, ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      manager.setRootAnimating(true, ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH);
      manager.setRootAnimating(true, ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK);
      manager.setRootAnimating(true, ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH);
      manager.setRootAnimating(true, ImmersiveAnimScene.SCENE_LIST_TO_CAPSULE_TOUCH_BACK);
      expect(manager).not().assertNull();
    });

    it('test_doUpdateCardAnim', Level.LEVEL1, (): void => {
      let manager = new ImmersiveCardAnimManager();
      let beforeAnimCall = (): void => {};
      let afterUpdateFinishCall = (): void => {};
      let beforeUpdataFinishCall = (): void => {};
      manager.doUpdateCardAnim();
      manager.doUpdateCardAnim(beforeAnimCall, afterUpdateFinishCall, beforeUpdataFinishCall);
      expect(manager).not().assertNull();
    });
  });
}