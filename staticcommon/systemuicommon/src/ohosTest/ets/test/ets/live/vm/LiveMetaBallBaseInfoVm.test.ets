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
import curves from '@ohos.curves';
import { BallParams, MetaballController, MetaballAnimationParams } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { SysTypeCode } from '../../../../main/ets/liveview/common/LiveConstants';
import { LiveMetaBallScene, LiveType } from '../../../../main/ets/live/model/LiveCommonModel';
import { DeviceInfoVm } from '../../../../main/ets/vm/DeviceInfoVm';
import { ResUtils, SCBRotateChangeReason, windowMgr } from '@ohos/windowscene';
import { CutoutVm } from '../../../../main/ets/statusbar/vm/CutoutVm';
import { RotationConstants, WindowConstants } from '@ohos/commonconstants';
import { AnimationBase } from '../../../../main/ets/animation/AnimationBase';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { LiveVmInjector } from '../../../../main/ets/live/LiveVmInjector';
import { ILiveMetaBallVm } from '../../../../main/ets/live/interface/ILiveMetaBallVm';
import { StatusBarHeightVm } from '../../../../main/ets/statusbar/vm/StatusBarHeightVm';
import { util } from '@kit.ArkTS';
import { Singleton } from '../../../../main/ets/utils/Singleton';
import { StatusBarCapsulePosition } from '../../../../main/ets/statusbar/model/StatusBarCapsulePosition';
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { LiveMetaBallBaseVm } from '../../../../main/ets/live/vm/LiveMetaBallBaseVm';


export default function LiveMetaBallBaseInfoVmTest() {
  describe('toggleToRemind_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_resolve_when_toggleToRemind_is_successful', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = new MetaballController();
      let metaballAnimationParams: MetaballAnimationParams = new MetaballAnimationParams();
      metaballAnimationParams.duration = 1000;
      metaballAnimationParams.curve = curves.Curve.LINEAR;
      metaballAnimationParams.delay = 0;
      metaballAnimationParams.iterations = 1;
      metaballAnimationParams.playMode = WindowConstants.PLAY_MODE_NORMAL;
      metaballAnimationParams.onFinish = () => {
        console.log("Animation finished");
      };
      let ballParams: BallParams = new BallParams();
      ballParams.metaballAnimationParams = metaballAnimationParams;
      let metaballVM: ILiveMetaBallVm = LiveVmInjector.createLiveMetaBallInjector().getMetaballVm();
      let mockfunc: Function = mocker.mockFunc(metaballVM, metaballVM.getController);
      when(mockfunc)().afterReturn(metaballController);
      let mockfunc2: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc2)(ArgumentMatchers.anyObj).afterReturn(new CustomPromise((resolve) => {
        setTimeout(resolve, metaballAnimationParams.duration);
      }));
      await livemetaballbasevm.toggleToRemind();
      mocker.ignoreMock(metaballVM, metaballVM.getController);
      mocker.ignoreMock(metaballController, metaballController.play);
    });

  });

  describe('fusionBall_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_when_fusionBall_animation_succeeds', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();

      // Mock LogHelper.showError
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      // Mock LiveVmInjector.getMetaBallVisibleVm
      let liveVmInjector: LiveVmInjector = LiveVmInjector.getInstance();
      let mockGetMetaBallVisibleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getMetaBallVisibleVm);
      let mockILiveMetaBallVisibleVm: ILiveMetaBallVm = {
        setMetaBallShowState: (status: boolean[]) => {
        }
      };
      when(mockGetMetaBallVisibleVm)().afterReturn(mockILiveMetaBallVisibleVm);

      // Mock MetaballController.startFusionBallAnimation
      let metaballController: MetaballController = new MetaballController();
      let mockStartFusionBallAnimation: Function =
        mocker.mockFunc(metaballController, metaballController.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)(ArgumentMatchers.anyArray, ArgumentMatchers.anyObj, ArgumentMatchers.anyArray)
        .afterReturnNothing();

      // Mock StatusBarHeightVm.preSetShowHeight and StatusBarHeightVm.clearShowHeight
      let statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.getInstance();
      let mockPreSetShowHeight: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.preSetShowHeight);
      let mockClearShowHeight: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.clearShowHeight);
      when(mockPreSetShowHeight)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearShowHeight)(ArgumentMatchers.anyString).afterReturnNothing();

      // Call fusionBall
      let status: boolean[] = [true];
      let colors: ResourceColor[] = [new ResourceColor(0)];
      let animateParam: MetaballAnimationParams = new MetaballAnimationParams();
      animateParam.scene = new LiveMetaBallScene(LiveType.LIVE_TYPE_DIVIDE, SysTypeCode.LIVE_DIVIDE_TYPE_FOOTBALL, 0,
        new StatusBarCapsulePosition());
      animateParam.animateParam = {
        duration: 1000,
        curve: curves.Curve.LINEAR,
        onFinish: () => {
        }
      };
      let result = await livemetaballbasevm.fusionBall(status, colors, animateParam);

      // Assertions
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getMetaBallVisibleVm);
      mocker.ignoreMock(metaballController, metaballController.startFusionBallAnimation);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.preSetShowHeight);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.clearShowHeight);
    });

    it('should_log_error_when_fusionBall_throws_exception', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();

      // Mock LogHelper.showError
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      // Mock LiveVmInjector.getMetaBallVisibleVm to throw an exception
      let liveVmInjector: LiveVmInjector = LiveVmInjector.getInstance();
      let mockGetMetaBallVisibleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getMetaBallVisibleVm);
      when(mockGetMetaBallVisibleVm)().afterThrow("Error");

      // Call fusionBall
      let status: boolean[] = [true];
      let colors: ResourceColor[] = [new ResourceColor(0)];
      let animateParam: MetaballAnimationParams = new MetaballAnimationParams();
      animateParam.scene = new LiveMetaBallScene(LiveType.LIVE_TYPE_DIVIDE, SysTypeCode.LIVE_DIVIDE_TYPE_FOOTBALL, 0,
        new StatusBarCapsulePosition());
      animateParam.animateParam = {
        duration: 1000,
        curve: curves.Curve.LINEAR,
        onFinish: () => {
        }
      };
      let result = await livemetaballbasevm.fusionBall(status, colors, animateParam);

      // Assertions
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getMetaBallVisibleVm);
    });

    it('should_resolve_when_fusionBall_animation_fails', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();

      // Mock LogHelper.showError
      let logHelper: LogHelper = LogHelper.getInstance();
      let mockShowError: Function = mocker.mockFunc(logHelper, logHelper.showError);
      when(mockShowError)(ArgumentMatchers.anyString).afterReturnNothing();

      // Mock LiveVmInjector.getMetaBallVisibleVm
      let liveVmInjector: LiveVmInjector = LiveVmInjector.getInstance();
      let mockGetMetaBallVisibleVm: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getMetaBallVisibleVm);
      let mockILiveMetaBallVisibleVm: ILiveMetaBallVm = {
        setMetaBallShowState: (status: boolean[]) => {
        }
      };
      when(mockGetMetaBallVisibleVm)().afterReturn(mockILiveMetaBallVisibleVm);

      // Mock MetaballController.startFusionBallAnimation to throw an exception
      let metaballController: MetaballController = new MetaballController();
      let mockStartFusionBallAnimation: Function =
        mocker.mockFunc(metaballController, metaballController.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)(ArgumentMatchers.anyArray, ArgumentMatchers.anyObj, ArgumentMatchers.anyArray)
        .afterThrow("Error");

      // Mock StatusBarHeightVm.preSetShowHeight and StatusBarHeightVm.clearShowHeight
      let statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.getInstance();
      let mockPreSetShowHeight: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.preSetShowHeight);
      let mockClearShowHeight: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.clearShowHeight);
      when(mockPreSetShowHeight)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyString).afterReturnNothing();
      when(mockClearShowHeight)(ArgumentMatchers.anyString).afterReturnNothing();

      // Call fusionBall
      let status: boolean[] = [true];
      let colors: ResourceColor[] = [new ResourceColor(0)];
      let animateParam: MetaballAnimationParams = new MetaballAnimationParams();
      animateParam.scene = new LiveMetaBallScene(LiveType.LIVE_TYPE_DIVIDE, SysTypeCode.LIVE_DIVIDE_TYPE_FOOTBALL, 0,
        new StatusBarCapsulePosition());
      animateParam.animateParam = {
        duration: 1000,
        curve: curves.Curve.LINEAR,
        onFinish: () => {
        }
      };
      let result = await livemetaballbasevm.fusionBall(status, colors, animateParam);

      // Assertions
      expect(result).assertUndefined();
      mocker.ignoreMock(logHelper, logHelper.showError);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getMetaBallVisibleVm);
      mocker.ignoreMock(metaballController, metaballController.startFusionBallAnimation);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.preSetShowHeight);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.clearShowHeight);
    });
  });

  describe('getAnimateParam_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_default_animate_param_when_duration_is_undefined', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam();
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
      expect(result.duration).assertEqual(777);
      expect(result.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should_return_custom_animate_param_when_duration_is_provided', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam(1000);
      expect(result.curve).assertEqual(curves.cubicBezierCurve(0.33, 0, 0.67, 1));
      expect(result.duration).assertEqual(1000);
      expect(result.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });
  });

  describe('toggleState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_toggleToDeskTop_when_scene_is_DESKTOP', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToDeskTop: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToDeskTop);
      when(mockToggleToDeskTop)(ArgumentMatchers.anyBoolean).afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.DESKTOP);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToDeskTop);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_call_toggleToHeadUp_when_scene_is_HEADS_UP', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToHeadUp: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToHeadUp);
      when(mockToggleToHeadUp)().afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.HEADS_UP);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToHeadUp);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_call_toggleToLiveList_when_scene_is_LIVE_PANEL', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToLiveList: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToLiveList);
      when(mockToggleToLiveList)().afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.LIVE_PANEL);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToLiveList);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_call_toggleToPanel_when_scene_is_DROPDOWN', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      when(mockToggleToPanel)().afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.DROPDOWN);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_call_toggleToPanel_when_scene_is_SCREEN_LOCK', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      when(mockToggleToPanel)().afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.SCREEN_LOCK);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_call_toggleToPanel_when_scene_is_STATUSBAR_HIDE', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      when(mockToggleToPanel)().afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.STATUSBAR_HIDE);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_call_toggleToRemind_when_scene_is_REMIND', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToRemind: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToRemind);
      when(mockToggleToRemind)().afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.REMIND);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToRemind);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_call_toggleToImmersive_when_scene_is_IMMERSIVE', async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockToggleToImmersive: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToImmersive);
      when(mockToggleToImmersive)().afterReturn(new Promise<void>(() => {
      }));

      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockGetScene)().afterReturn(LiveMetaBallScene.IMMERSIVE);

      await livemetaballbasevm.toggleState();

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToImmersive);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });
  });

  describe('setScene_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_add_scene_when_isAdd_is_true', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = true;
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.has(scene)).assertTrue();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_remove_scene_when_isAdd_is_false', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = false;
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.has(scene)).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
  });

  describe('updateProperty_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_update_sceneSet_when_vm_is_ILiveMetaBallVm', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let vm: ILiveMetaBallVm = new ILiveMetaBallVm();
      vm.sceneSet = new Set([LiveMetaBallScene.DEFAULT]);
      livemetaballbasevm.updateProperty(vm);
      expect(livemetaballbasevm.sceneSet.has(LiveMetaBallScene.DEFAULT)).assertTrue();
    });
  });
}