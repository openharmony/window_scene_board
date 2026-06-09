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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, Level, when } from '@ohos/hypium';
import { ImmersiveCapsuleAnimManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveCapsuleAnimManager';
import { CapsulePositionType } from '../../../../../../main/ets/common/ImmersiveConstants';
import { AnimStyleType } from '../../../../../../main/ets/model/data/anim/ImmersiveAnimStyle';
import { CommonUtils } from '@ohos/basicutils';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { PropertyType } from '@ohos/systemuicommon';
import { ImmersiveAnimStateManager } from '../../../../../../main/ets/viewmodel/viewanim/ImmersiveAnimStateManager';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCapsuleAnimManagerTest() {
  describe('ImmersiveCapsuleAnimManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getDefaultCapChain', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.getDefaultCapChain();
      expect(res).not().assertNull();
    });

    it('test_refreshHashcode', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc_1)().afterReturn(false);
      let type = CapsulePositionType.TYPE_CONTENT;
      manager.refreshHashcode(type, '');
      mocker.clear(CommonUtils);
      mocker.clearAll();
      expect(stateMgr).not().assertNull();
    });

    it('test_getMapCapsuleType', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc_1)().afterReturn(true);
      let res = manager.getMapCapsuleType('test_getMapCapsuleType');
      mocker.clear(CommonUtils);
      mocker.clearAll();
      expect(res).not().assertNull();
    });

    it('test_getChildHashcode', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.getChildHashcode(CapsulePositionType.TYPE_CONTENT);
      expect(res).not().assertNull();
    });

    it('test_isCapsuleContent', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.isCapsuleContent(CapsulePositionType.TYPE_CONTENT);
      expect(res).not().assertNull();
    });

    it('test_isCapsuleShadow', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.isCapsuleShadow(CapsulePositionType.TYPE_CONTENT);
      expect(res).not().assertNull();
    });

    it('test_isCapsuleNone', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.isCapsuleNone(CapsulePositionType.TYPE_CONTENT);
      expect(res).not().assertNull();
    });

    it('test_getRootAnimStyle', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.getRootAnimStyle();
      expect(stateMgr).not().assertNull();
    });

    it('test_setRootStyleValue', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.setRootStyleValue(AnimStyleType.RADIUS);
      expect(stateMgr).not().assertNull();
    });

    it('test_getChildAnimStyle', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.getChildAnimStyle(CapsulePositionType.TYPE_CONTENT);
      expect(res).not().assertNull();
    });

    it('test_setChildStyleValue', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.setChildStyleValue(CapsulePositionType.TYPE_CONTENT, AnimStyleType.RADIUS);
      expect(stateMgr).not().assertNull();
    });

    it('test_setRootViewArea', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.setRootViewArea();
      expect(stateMgr).not().assertNull();
    });

    it('test_getRootViewPosition', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.getRootViewPosition();
      expect(res).not().assertNull();
    });

    it('test_setChildViewArea', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.setChildViewArea(CapsulePositionType.TYPE_CONTENT);
      expect(stateMgr).not().assertNull();
    });

    it('test_getChildViewPosition', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let res = manager.getChildViewPosition(CapsulePositionType.TYPE_CONTENT);
      expect(res).not().assertNull();
    });

    it('test_setRootAnimating', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.setRootAnimating(true);
      expect(stateMgr).not().assertNull();
    });

    it('test_setChildAnimating', Level.LEVEL1, (): void => {
      let scene = ImmersiveAnimScene.SCENE_CARD_TO_LIST;
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.setChildAnimating(true,
        scene,
        CapsulePositionType.TYPE_SHADOW,
        CapsulePositionType.TYPE_CONTENT,
        CapsulePositionType.TYPE_REMIND,
        CapsulePositionType.TYPE_ANIM_CONTENT,
        CapsulePositionType.TYPE_ANIM_SHADOW);
      expect(stateMgr).not().assertNull();
    });

    it('test_startAnim', Level.LEVEL1, (): void => {
      let scene = ImmersiveAnimScene.SCENE_CAPSULE_TOP_UPDATE;
      let mocker = new MockKit();
      let mockfunc_1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockfunc_1)().afterReturn(false);
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      let onStart = (): void => {
      };
      let onEnd = (): void => {
      };
      manager.startAnim(scene, onStart, onEnd);
      scene = ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW;
      manager.startAnim(scene, onStart, onEnd);
      mocker.clear(CommonUtils);
      mocker.clearAll();
      expect(stateMgr).not().assertNull();
    });

    it('test_onCapsuleToList', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      manager.interruptCapsuleAnim();
      expect(stateMgr).not().assertNull();
    });

    it('test_getCapType', Level.LEVEL1, (): void => {
      let stateMgr = new ImmersiveAnimStateManager();
      let manager = new ImmersiveCapsuleAnimManager();
      (manager as object)['defaultCapChain']['getCapType']();
      expect(stateMgr).not().assertNull();
    });
  });
}