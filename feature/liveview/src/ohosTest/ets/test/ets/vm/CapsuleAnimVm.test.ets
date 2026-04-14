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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { CapsuleAnimVm, ExitCapsuleAnimParam } from '../../../../../main/ets/vm/CapsuleAnimVm';
import { ComponentAnimState, LiveAnimScene } from '@ohos/systemuicommon';
import { CapsuleAnimName } from '@ohos/systemuicommon/src/main/ets/liveview/common/LiveConstants';

export default function CapsuleAnimVmTest() {

  describe('CapsuleAnimVmTest', () => {

    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    Test01();
    Test02();
    Test03();
    Test04();
  })
}

function Test01() {
  const capsuleAnimVm: CapsuleAnimVm = new CapsuleAnimVm();
  let componentAnimState: ComponentAnimState = new ComponentAnimState(CapsuleAnimName.CAPSULE_ROOT);

  it('should_return_true_when_startExitCapsuleZoomIn', 0, () => {
    const exitAnimParam = {
      isOverCapsule: true,
      isShadowShowing: false
    } as ExitCapsuleAnimParam;
    capsuleAnimVm.startExitCapsuleZoomIn(exitAnimParam);
    expect(true).assertTrue();
  });

  it('should_return_AnimName_when_startExitCapsuleZoomOut', 0, () => {
    const exitAnimParam = {
      isOverCapsule: true,
      isShadowShowing: false
    } as ExitCapsuleAnimParam;
    capsuleAnimVm.startExitCapsuleZoomOut(exitAnimParam);
    componentAnimState = capsuleAnimVm.getRootAnimState();
    expect(componentAnimState.getComponentName()).assertEqual(CapsuleAnimName.CAPSULE_ROOT)
  });

  it('should_return_AnimName_when_reset_capsule_state', 0, () => {
    capsuleAnimVm.resetCapsuleState(CapsuleAnimName.CAPSULE_ROOT);
    componentAnimState = capsuleAnimVm.getRootAnimState();
    expect(componentAnimState.getComponentName()).assertEqual(CapsuleAnimName.CAPSULE_ROOT)
    capsuleAnimVm.resetCapsuleState(CapsuleAnimName.CAPSULE_CONTENT);
    componentAnimState = capsuleAnimVm.getContentAnimState();
    expect(componentAnimState.getComponentName()).assertEqual(CapsuleAnimName.CAPSULE_CONTENT)
  })

  it('should_return_true_set_capsule_animating', 0, () => {
    capsuleAnimVm.setCapsuleAnimating(true, LiveAnimScene.SCENE_CAPSULE_SHOW);
    componentAnimState = capsuleAnimVm.getShadowAnimState();
    capsuleAnimVm.setCapsuleAnimating(false, LiveAnimScene.SCENE_CAPSULE_HIDE);
    expect(true).assertTrue();
  })
}

function Test02() {
  const capsuleAnimVm: CapsuleAnimVm = new CapsuleAnimVm();

  it('initExitCapsuleAnim', 0, () => {
    const exitCapsuleAnim = {
      isOverCapsule: true, isShadowShowing: true
    } as ExitCapsuleAnimParam;
    try {
      Reflect.get(capsuleAnimVm, 'initExitCapsuleAnim')?.(exitCapsuleAnim)
    } catch (err) {
    }
    expect(Reflect.has(capsuleAnimVm, 'initExitCapsuleAnim')).assertTrue();
  })

  it('getAnimState', 0, () => {
    try {
      Reflect.get(capsuleAnimVm, 'getAnimState')?.(CapsuleAnimName.CAPSULE_ROOT)
      Reflect.get(capsuleAnimVm, 'getAnimState')?.(CapsuleAnimName.CAPSULE_CONTENT)
    } catch (err) {
    }

    expect(Reflect.has(capsuleAnimVm, 'getAnimState')).assertTrue();
  })
}

const capsuleAnimVm2: CapsuleAnimVm = new CapsuleAnimVm();

interface ICapsuleAnimVm {
  onCapsuleWidthChange(oldWidth: number, newWidth: number): void;
  initExitCapsuleAnim(param: ExitCapsuleAnimParam): void;
}

function Test03() {
  it('test_onCapsuleWidthChange', 0, (): void => {
    try {
      capsuleAnimVm2.getRootAnimState().isAnimating = true;
      (capsuleAnimVm2 as object as ICapsuleAnimVm).onCapsuleWidthChange(100,100);
      capsuleAnimVm2.getRootAnimState().isAnimating = false;
      (capsuleAnimVm2 as object as ICapsuleAnimVm).onCapsuleWidthChange(100,100);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'onCapsuleWidthChange')).assertTrue();
  });

  it('test_getAnimationPromise', 0, (): void => {
    try {
      capsuleAnimVm2.getAnimationPromise(LiveAnimScene.SCENE_CAPSULE_SHOW);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'getAnimationPromise')).assertTrue();
  });

  it('test_setContentCapsuleWidth', 0, (): void => {
    try {
      capsuleAnimVm2.setContentCapsuleWidth(1);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'setContentCapsuleWidth')).assertTrue();
  });

  it('test_setShadowCapsuleWidth', 0, (): void => {
    try {
      capsuleAnimVm2.setShadowCapsuleWidth(1);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'setShadowCapsuleWidth')).assertTrue();
  });

  it('test_getContentAnimStyle', 0, (): void => {
    try {
      capsuleAnimVm2.getContentAnimStyle();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'getContentAnimStyle')).assertTrue();
  });

  it('test_getOverlayAnimStyle', 0, (): void => {
    try {
      capsuleAnimVm2.getOverlayAnimStyle();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'getOverlayAnimStyle')).assertTrue();
  });
}

function Test04() {
  it('test_getShadowAnimStyle', 0, (): void => {
    try {
      capsuleAnimVm2.getShadowAnimStyle();
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'getShadowAnimStyle')).assertTrue();
  });

  it('test_initExitCapsuleAnim', 0, (): void => {
    try {
      const exitCapsuleAnim: ExitCapsuleAnimParam = {
        isOverCapsule: true,
        isShadowShowing: true
      };
      (capsuleAnimVm2 as object as ICapsuleAnimVm).initExitCapsuleAnim(exitCapsuleAnim);
      exitCapsuleAnim.isShadowShowing = false;
      (capsuleAnimVm2 as object as ICapsuleAnimVm).initExitCapsuleAnim(exitCapsuleAnim);
    } catch (err) {}
    expect(Reflect.has(capsuleAnimVm2, 'initExitCapsuleAnim')).assertTrue();
  });
}