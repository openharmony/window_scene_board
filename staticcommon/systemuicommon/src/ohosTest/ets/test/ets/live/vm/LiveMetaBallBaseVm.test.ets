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
import { MetaballController, MetaballAnimationParams } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveBaseVm } from './LiveBaseVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ResUtils, SCBRotateChangeReason, windowMgr } from '@ohos/windowscene';
import { RotationConstants, WindowConstants } from '@ohos/commonconstants';
import { AnimationBase } from '../../animation/AnimationBase';
import { CustomPromise } from '@ohos/frameworkwrapper';
import type { LiveVmInjector } from '../LiveVmInjector';
import { util } from '@kit.ArkTS';
import { CutoutVm } from '../../../../../../../newIndex';
import { StatusBarHeightVm } from '../../../../../../main/ets/statusbar/vm/StatusBarHeightVm';
import { LiveMetaBallBaseVm } from '../../../../../../main/ets/live/vm/LiveMetaBallBaseVm';
import { afterEach, beforeEach, describe, expect, it, when } from '@ohos/hypium';
import { LiveMetaBallScene } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { ILiveMetaBallVm } from '../../../../../../main/ets/live/interface/ILiveMetaBallVm';

const TAG = 'LiveMetaBallBaseVmTest';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// 创建一个具体的子类来实例化LiveMetaBallBaseVm
class TestLiveMetaBallVm extends LiveMetaBallBaseVm {
  public animStatusBarHeight: number = 0;

  cutoutVm: CutoutVm;

  statusBarHeightVm: StatusBarHeightVm;
}

export default function LiveMetaBallBaseVmTest() {
  describe('LiveMetaBallBaseVmTest', () => {
    // 每个it方法内部定义所需的对象
    it('should create an instance of LiveMetaBallBaseVm', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm).not.assertEqualNull();
    });

    it('should set and get animStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 50;
      vm.animStatusBarHeight = height;
      expect(vm.animStatusBarHeight).assertEqual(height);
    });

    it('should set and get STATUS_BAR_HEIGHT correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm.STATUS_BAR_HEIGHT).assertEqualDefined();
    });

    it('should updateStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 75;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    it('should fusionBall correctly', 0, async () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const status = [true, false];
      const colors: ResourceColor[] = [{ color: '#ff0000' }, { color: '#00ff00' }];
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          curve: Curve.Linear,
          duration: 950,
          finishCallbackType: FinishCallbackType.LOGICALLY
        },
        scene: MetaballAnimationScene.NORMAL
      };
      await vm.fusionBall(status, colors, animateParam);
      // 验证controller的startFusionBallAnimation被调用
      // 例如：
      expect(vm.controller.startFusionBallAnimation).toHaveBeenCalledWith(status, animateParam, colors);
    });

    it('should getAnimateParam correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const animateParam = vm.getAnimateParam();
      expect(animateParam.curve).assertEqual(Curve.Linear);
      expect(animateParam.duration).assertEqual(950);
      expect(animateParam.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should setScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const scene = LiveMetaBallScene.REMIND;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).assertEqual(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).assertEqual(false);
    });

    it('should getScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 测试不同的场景
      const scenes = [
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.IMMERSIVE
      ];
      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        const currentScene = vm.getScene();
        expect(currentScene).assertEqual(scene);
        vm.sceneSet.clear();
      }
      // 测试默认场景
      expect(vm.getScene()).assertEqual(LiveMetaBallScene.DESKTOP);
    });

    it('should updateProperty correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const newVm: ILiveMetaBallVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).assertEqual(true);
    });

    it('should getTaskNum correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 模拟不同的liveList情况
      const testCases = [
        {
          liveList: [],
          expectedCount: 0
        },
        {
          liveList: [
            { typeCode: SysTypeCode.SCREEN_RECORDING, type: LiveType.INSTANT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.PERSISTENT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: false }
          ],
          expectedCount: 1
        },
        {
          liveList: [
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true }
          ],
          expectedCount: 3
        }
      ];

      testCases.forEach(testCase => {
        const capsuleListVm = {
          liveList: testCase.liveList
        };
        vm.vmInjector.getCapsuleListVm = jest.fn().mockReturnValue(capsuleListVm);
        testCase.liveList.forEach(live => {
          const capsuleVm = {
            isShow: live.isShow
          };
          vm.vmInjector.getCapsuleVm = jest.fn().mockReturnValue(capsuleVm);
        });
        const count = vm.getTaskNum();
        expect(count).assertEqual(testCase.expectedCount);
      });
    });

    // 测试当scene为DESKTOP时
    it('should toggleState to Desktop', async () => {
      await yourClass.toggleState();
      expect(mockGetScene).toHaveBeenCalled();
      expect(mockToggleToDeskTop).toHaveBeenCalled();
    });

    // 测试当scene为HEADS_UP时
    it('should toggleState to HeadUp', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.HEADS_UP);
      await yourClass.toggleState();
      expect(mockToggleToHeadUp).toHaveBeenCalled();
    });

    // 测试当scene为LIVE_PANEL时
    it('should toggleState to LivePanel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.LIVE_PANEL);
      await yourClass.toggleState();
      expect(mockToggleToLiveList).toHaveBeenCalled();
    });

    // 测试当scene为DROPDOWN或SCREEN_LOCK时
    it('should toggleState to Panel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.DROPDOWN);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();

      mockGetScene.mockReturnValue(LiveMetaBallScene.SCREEN_LOCK);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为STATUSBAR_HIDE时
    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });

    it('should return REMIND when sceneSet has REMIND', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.REMIND);
    });

    it('should return SCREEN_LOCK when sceneSet has SCREEN_LOCK', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.SCREEN_LOCK);
    });

    it('should return STATUSBAR_HIDE when sceneSet has STATUSBAR_HIDE and cutoutVm isMiddleCutout', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.STATUSBAR_HIDE);
    });

    it('should return DROPDOWN when sceneSet has DROPDOWN', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DROPDOWN);
    });

    it('should return LIVE_PANEL when sceneSet has LIVE_PANEL', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.LIVE_PANEL);
    });

    it('should return HEADS_UP when sceneSet has HEADS_UP', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.HEADS_UP);
    });

    it('should return DESKTOP when no conditions are met', () => {
      sceneSetMock.has.mockReturnValue(false);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DESKTOP);
    });

    it('should create an instance of LiveMetaBallBaseVm', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm).not.assertEqualNull();
    });

    it('should set and get animStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 50;
      vm.animStatusBarHeight = height;
      expect(vm.animStatusBarHeight).assertEqual(height);
    });

    it('should set and get STATUS_BAR_HEIGHT correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm.STATUS_BAR_HEIGHT).assertEqualDefined();
    });

    it('should updateStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 75;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    it('should fusionBall correctly', 0, async () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const status = [true, false];
      const colors: ResourceColor[] = [{ color: '#ff0000' }, { color: '#00ff00' }];
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          curve: Curve.Linear,
          duration: 950,
          finishCallbackType: FinishCallbackType.LOGICALLY
        },
        scene: MetaballAnimationScene.NORMAL
      };
      await vm.fusionBall(status, colors, animateParam);
      // 验证controller的startFusionBallAnimation被调用
      // 例如：
      expect(vm.controller.startFusionBallAnimation).toHaveBeenCalledWith(status, animateParam, colors);
    });

    it('should getAnimateParam correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const animateParam = vm.getAnimateParam();
      expect(animateParam.curve).assertEqual(Curve.Linear);
      expect(animateParam.duration).assertEqual(950);
      expect(animateParam.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should setScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const scene = LiveMetaBallScene.REMIND;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).assertEqual(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).assertEqual(false);
    });

    it('should getScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 测试不同的场景
      const scenes = [
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.IMMERSIVE
      ];
      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        const currentScene = vm.getScene();
        expect(currentScene).assertEqual(scene);
        vm.sceneSet.clear();
      }
      // 测试默认场景
      expect(vm.getScene()).assertEqual(LiveMetaBallScene.DESKTOP);
    });

    it('should updateProperty correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const newVm: ILiveMetaBallVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).assertEqual(true);
    });

    it('should getTaskNum correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 模拟不同的liveList情况
      const testCases = [
        {
          liveList: [],
          expectedCount: 0
        },
        {
          liveList: [
            { typeCode: SysTypeCode.SCREEN_RECORDING, type: LiveType.INSTANT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.PERSISTENT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: false }
          ],
          expectedCount: 1
        },
        {
          liveList: [
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true }
          ],
          expectedCount: 3
        }
      ];

      testCases.forEach(testCase => {
        const capsuleListVm = {
          liveList: testCase.liveList
        };
        vm.vmInjector.getCapsuleListVm = jest.fn().mockReturnValue(capsuleListVm);
        testCase.liveList.forEach(live => {
          const capsuleVm = {
            isShow: live.isShow
          };
          vm.vmInjector.getCapsuleVm = jest.fn().mockReturnValue(capsuleVm);
        });
        const count = vm.getTaskNum();
        expect(count).assertEqual(testCase.expectedCount);
      });
    });

    // 测试当scene为DESKTOP时
    it('should toggleState to Desktop', async () => {
      await yourClass.toggleState();
      expect(mockGetScene).toHaveBeenCalled();
      expect(mockToggleToDeskTop).toHaveBeenCalled();
    });

    // 测试当scene为HEADS_UP时
    it('should toggleState to HeadUp', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.HEADS_UP);
      await yourClass.toggleState();
      expect(mockToggleToHeadUp).toHaveBeenCalled();
    });

    // 测试当scene为LIVE_PANEL时
    it('should toggleState to LivePanel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.LIVE_PANEL);
      await yourClass.toggleState();
      expect(mockToggleToLiveList).toHaveBeenCalled();
    });

    // 测试当scene为DROPDOWN或SCREEN_LOCK时
    it('should toggleState to Panel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.DROPDOWN);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();

      mockGetScene.mockReturnValue(LiveMetaBallScene.SCREEN_LOCK);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为STATUSBAR_HIDE时
    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });

    // 每个it方法内部定义所需的对象
    it('should create an instance of LiveMetaBallBaseVm', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm).not.assertEqualNull();
    });

    it('should set and get animStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 50;
      vm.animStatusBarHeight = height;
      expect(vm.animStatusBarHeight).assertEqual(height);
    });

    it('should set and get STATUS_BAR_HEIGHT correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm.STATUS_BAR_HEIGHT).assertEqualDefined();
    });

    it('should updateStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 75;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    it('should fusionBall correctly', 0, async () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const status = [true, false];
      const colors: ResourceColor[] = [{ color: '#ff0000' }, { color: '#00ff00' }];
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          curve: Curve.Linear,
          duration: 950,
          finishCallbackType: FinishCallbackType.LOGICALLY
        },
        scene: MetaballAnimationScene.NORMAL
      };
      await vm.fusionBall(status, colors, animateParam);
      // 验证controller的startFusionBallAnimation被调用
      // 例如：
      expect(vm.controller.startFusionBallAnimation).toHaveBeenCalledWith(status, animateParam, colors);
    });

    it('should getAnimateParam correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const animateParam = vm.getAnimateParam();
      expect(animateParam.curve).assertEqual(Curve.Linear);
      expect(animateParam.duration).assertEqual(950);
      expect(animateParam.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should setScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const scene = LiveMetaBallScene.REMIND;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).assertEqual(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).assertEqual(false);
    });

    it('should getScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 测试不同的场景
      const scenes = [
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.IMMERSIVE
      ];
      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        const currentScene = vm.getScene();
        expect(currentScene).assertEqual(scene);
        vm.sceneSet.clear();
      }
      // 测试默认场景
      expect(vm.getScene()).assertEqual(LiveMetaBallScene.DESKTOP);
    });

    it('should updateProperty correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const newVm: ILiveMetaBallVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).assertEqual(true);
    });

    it('should getTaskNum correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 模拟不同的liveList情况
      const testCases = [
        {
          liveList: [],
          expectedCount: 0
        },
        {
          liveList: [
            { typeCode: SysTypeCode.SCREEN_RECORDING, type: LiveType.INSTANT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.PERSISTENT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: false }
          ],
          expectedCount: 1
        },
        {
          liveList: [
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true }
          ],
          expectedCount: 3
        }
      ];

      testCases.forEach(testCase => {
        const capsuleListVm = {
          liveList: testCase.liveList
        };
        vm.vmInjector.getCapsuleListVm = jest.fn().mockReturnValue(capsuleListVm);
        testCase.liveList.forEach(live => {
          const capsuleVm = {
            isShow: live.isShow
          };
          vm.vmInjector.getCapsuleVm = jest.fn().mockReturnValue(capsuleVm);
        });
        const count = vm.getTaskNum();
        expect(count).assertEqual(testCase.expectedCount);
      });
    });

    // 测试当scene为DESKTOP时
    it('should toggleState to Desktop', async () => {
      await yourClass.toggleState();
      expect(mockGetScene).toHaveBeenCalled();
      expect(mockToggleToDeskTop).toHaveBeenCalled();
    });

    // 测试当scene为HEADS_UP时
    it('should toggleState to HeadUp', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.HEADS_UP);
      await yourClass.toggleState();
      expect(mockToggleToHeadUp).toHaveBeenCalled();
    });

    // 测试当scene为LIVE_PANEL时
    it('should toggleState to LivePanel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.LIVE_PANEL);
      await yourClass.toggleState();
      expect(mockToggleToLiveList).toHaveBeenCalled();
    });

    // 测试当scene为DROPDOWN或SCREEN_LOCK时
    it('should toggleState to Panel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.DROPDOWN);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();

      mockGetScene.mockReturnValue(LiveMetaBallScene.SCREEN_LOCK);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为STATUSBAR_HIDE时
    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });

    it('should return REMIND when sceneSet has REMIND', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.REMIND);
    });

    it('should return SCREEN_LOCK when sceneSet has SCREEN_LOCK', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.SCREEN_LOCK);
    });

    it('should return STATUSBAR_HIDE when sceneSet has STATUSBAR_HIDE and cutoutVm isMiddleCutout', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.STATUSBAR_HIDE);
    });

    it('should return DROPDOWN when sceneSet has DROPDOWN', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DROPDOWN);
    });

    it('should return LIVE_PANEL when sceneSet has LIVE_PANEL', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.LIVE_PANEL);
    });

    it('should return HEADS_UP when sceneSet has HEADS_UP', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.HEADS_UP);
    });

    it('should return DESKTOP when no conditions are met', () => {
      sceneSetMock.has.mockReturnValue(false);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DESKTOP);
    });

    it('should create an instance of LiveMetaBallBaseVm', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm).not.assertEqualNull();
    });

    it('should set and get animStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 50;
      vm.animStatusBarHeight = height;
      expect(vm.animStatusBarHeight).assertEqual(height);
    });

    it('should set and get STATUS_BAR_HEIGHT correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm.STATUS_BAR_HEIGHT).assertEqualDefined();
    });

    it('should updateStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 75;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    it('should fusionBall correctly', 0, async () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const status = [true, false];
      const colors: ResourceColor[] = [{ color: '#ff0000' }, { color: '#00ff00' }];
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          curve: Curve.Linear,
          duration: 950,
          finishCallbackType: FinishCallbackType.LOGICALLY
        },
        scene: MetaballAnimationScene.NORMAL
      };
      await vm.fusionBall(status, colors, animateParam);
      // 验证controller的startFusionBallAnimation被调用
      // 例如：
      expect(vm.controller.startFusionBallAnimation).toHaveBeenCalledWith(status, animateParam, colors);
    });

    it('should getAnimateParam correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const animateParam = vm.getAnimateParam();
      expect(animateParam.curve).assertEqual(Curve.Linear);
      expect(animateParam.duration).assertEqual(950);
      expect(animateParam.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should setScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const scene = LiveMetaBallScene.REMIND;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).assertEqual(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).assertEqual(false);
    });

    it('should getScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 测试不同的场景
      const scenes = [
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.IMMERSIVE
      ];
      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        const currentScene = vm.getScene();
        expect(currentScene).assertEqual(scene);
        vm.sceneSet.clear();
      }
      // 测试默认场景
      expect(vm.getScene()).assertEqual(LiveMetaBallScene.DESKTOP);
    });

    it('should updateProperty correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const newVm: ILiveMetaBallVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).assertEqual(true);
    });

    it('should getTaskNum correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 模拟不同的liveList情况
      const testCases = [
        {
          liveList: [],
          expectedCount: 0
        },
        {
          liveList: [
            { typeCode: SysTypeCode.SCREEN_RECORDING, type: LiveType.INSTANT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.PERSISTENT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: false }
          ],
          expectedCount: 1
        },
        {
          liveList: [
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true }
          ],
          expectedCount: 3
        }
      ];

      testCases.forEach(testCase => {
        const capsuleListVm = {
          liveList: testCase.liveList
        };
        vm.vmInjector.getCapsuleListVm = jest.fn().mockReturnValue(capsuleListVm);
        testCase.liveList.forEach(live => {
          const capsuleVm = {
            isShow: live.isShow
          };
          vm.vmInjector.getCapsuleVm = jest.fn().mockReturnValue(capsuleVm);
        });
        const count = vm.getTaskNum();
        expect(count).assertEqual(testCase.expectedCount);
      });
    });

    // 测试当scene为DESKTOP时
    it('should toggleState to Desktop', async () => {
      await yourClass.toggleState();
      expect(mockGetScene).toHaveBeenCalled();
      expect(mockToggleToDeskTop).toHaveBeenCalled();
    });

    // 测试当scene为HEADS_UP时
    it('should toggleState to HeadUp', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.HEADS_UP);
      await yourClass.toggleState();
      expect(mockToggleToHeadUp).toHaveBeenCalled();
    });

    // 测试当scene为LIVE_PANEL时
    it('should toggleState to LivePanel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.LIVE_PANEL);
      await yourClass.toggleState();
      expect(mockToggleToLiveList).toHaveBeenCalled();
    });

    // 测试当scene为DROPDOWN或SCREEN_LOCK时
    it('should toggleState to Panel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.DROPDOWN);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();

      mockGetScene.mockReturnValue(LiveMetaBallScene.SCREEN_LOCK);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为STATUSBAR_HIDE时
    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });

    it('should return REMIND when sceneSet has REMIND', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.REMIND);
    });

    it('should return SCREEN_LOCK when sceneSet has SCREEN_LOCK', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.SCREEN_LOCK);
    });

    it('should return STATUSBAR_HIDE when sceneSet has STATUSBAR_HIDE and cutoutVm isMiddleCutout', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.STATUSBAR_HIDE);
    });

    it('should return DROPDOWN when sceneSet has DROPDOWN', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DROPDOWN);
    });

    it('should return LIVE_PANEL when sceneSet has LIVE_PANEL', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.LIVE_PANEL);
    });

    it('should return HEADS_UP when sceneSet has HEADS_UP', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.HEADS_UP);
    });

    it('should return DESKTOP when no conditions are met', () => {
      sceneSetMock.has.mockReturnValue(false);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DESKTOP);
    });

    it('should create an instance of LiveMetaBallBaseVm', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm).not.assertEqualNull();
    });

    it('should set and get animStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 50;
      vm.animStatusBarHeight = height;
      expect(vm.animStatusBarHeight).assertEqual(height);
    });

    it('should set and get STATUS_BAR_HEIGHT correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm.STATUS_BAR_HEIGHT).assertEqualDefined();
    });

    it('should updateStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 75;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    it('should fusionBall correctly', 0, async () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const status = [true, false];
      const colors: ResourceColor[] = [{ color: '#ff0000' }, { color: '#00ff00' }];
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          curve: Curve.Linear,
          duration: 950,
          finishCallbackType: FinishCallbackType.LOGICALLY
        },
        scene: MetaballAnimationScene.NORMAL
      };
      await vm.fusionBall(status, colors, animateParam);
      // 验证controller的startFusionBallAnimation被调用
      // 例如：
      expect(vm.controller.startFusionBallAnimation).toHaveBeenCalledWith(status, animateParam, colors);
    });

    it('should getAnimateParam correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const animateParam = vm.getAnimateParam();
      expect(animateParam.curve).assertEqual(Curve.Linear);
      expect(animateParam.duration).assertEqual(950);
      expect(animateParam.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should setScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const scene = LiveMetaBallScene.REMIND;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).assertEqual(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).assertEqual(false);
    });

    it('should getScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 测试不同的场景
      const scenes = [
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.IMMERSIVE
      ];
      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        const currentScene = vm.getScene();
        expect(currentScene).assertEqual(scene);
        vm.sceneSet.clear();
      }
      // 测试默认场景
      expect(vm.getScene()).assertEqual(LiveMetaBallScene.DESKTOP);
    });

    it('should updateProperty correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const newVm: ILiveMetaBallVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).assertEqual(true);
    });

    it('should getTaskNum correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 模拟不同的liveList情况
      const testCases = [
        {
          liveList: [],
          expectedCount: 0
        },
        {
          liveList: [
            { typeCode: SysTypeCode.SCREEN_RECORDING, type: LiveType.INSTANT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.PERSISTENT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: false }
          ],
          expectedCount: 1
        },
        {
          liveList: [
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true }
          ],
          expectedCount: 3
        }
      ];

      testCases.forEach(testCase => {
        const capsuleListVm = {
          liveList: testCase.liveList
        };
        vm.vmInjector.getCapsuleListVm = jest.fn().mockReturnValue(capsuleListVm);
        testCase.liveList.forEach(live => {
          const capsuleVm = {
            isShow: live.isShow
          };
          vm.vmInjector.getCapsuleVm = jest.fn().mockReturnValue(capsuleVm);
        });
        const count = vm.getTaskNum();
        expect(count).assertEqual(testCase.expectedCount);
      });
    });

    // 测试当scene为DESKTOP时
    it('should toggleState to Desktop', async () => {
      await yourClass.toggleState();
      expect(mockGetScene).toHaveBeenCalled();
      expect(mockToggleToDeskTop).toHaveBeenCalled();
    });

    // 测试当scene为HEADS_UP时
    it('should toggleState to HeadUp', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.HEADS_UP);
      await yourClass.toggleState();
      expect(mockToggleToHeadUp).toHaveBeenCalled();
    });

    // 测试当scene为LIVE_PANEL时
    it('should toggleState to LivePanel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.LIVE_PANEL);
      await yourClass.toggleState();
      expect(mockToggleToLiveList).toHaveBeenCalled();
    });

    // 测试当scene为DROPDOWN或SCREEN_LOCK时
    it('should toggleState to Panel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.DROPDOWN);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();

      mockGetScene.mockReturnValue(LiveMetaBallScene.SCREEN_LOCK);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为STATUSBAR_HIDE时
    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });

    it('should create an instance of LiveMetaBallBaseVm', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm).not.assertEqualNull();
    });

    it('should set and get animStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 50;
      vm.animStatusBarHeight = height;
      expect(vm.animStatusBarHeight).assertEqual(height);
    });

    it('should set and get STATUS_BAR_HEIGHT correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm.STATUS_BAR_HEIGHT).assertEqualDefined();
    });

    it('should updateStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 75;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    it('should fusionBall correctly', 0, async () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const status = [true, false];
      const colors: ResourceColor[] = [{ color: '#ff0000' }, { color: '#00ff00' }];
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          curve: Curve.Linear,
          duration: 950,
          finishCallbackType: FinishCallbackType.LOGICALLY
        },
        scene: MetaballAnimationScene.NORMAL
      };
      await vm.fusionBall(status, colors, animateParam);
      // 验证controller的startFusionBallAnimation被调用
      // 例如：
      expect(vm.controller.startFusionBallAnimation).toHaveBeenCalledWith(status, animateParam, colors);
    });

    it('should getAnimateParam correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const animateParam = vm.getAnimateParam();
      expect(animateParam.curve).assertEqual(Curve.Linear);
      expect(animateParam.duration).assertEqual(950);
      expect(animateParam.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should setScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const scene = LiveMetaBallScene.REMIND;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).assertEqual(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).assertEqual(false);
    });

    it('should getScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 测试不同的场景
      const scenes = [
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.IMMERSIVE
      ];
      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        const currentScene = vm.getScene();
        expect(currentScene).assertEqual(scene);
        vm.sceneSet.clear();
      }
      // 测试默认场景
      expect(vm.getScene()).assertEqual(LiveMetaBallScene.DESKTOP);
    });

    it('should updateProperty correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const newVm: ILiveMetaBallVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).assertEqual(true);
    });

    it('should getTaskNum correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 模拟不同的liveList情况
      const testCases = [
        {
          liveList: [],
          expectedCount: 0
        },
        {
          liveList: [
            { typeCode: SysTypeCode.SCREEN_RECORDING, type: LiveType.INSTANT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.PERSISTENT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: false }
          ],
          expectedCount: 1
        },
        {
          liveList: [
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true }
          ],
          expectedCount: 3
        }
      ];

      testCases.forEach(testCase => {
        const capsuleListVm = {
          liveList: testCase.liveList
        };
        vm.vmInjector.getCapsuleListVm = jest.fn().mockReturnValue(capsuleListVm);
        testCase.liveList.forEach(live => {
          const capsuleVm = {
            isShow: live.isShow
          };
          vm.vmInjector.getCapsuleVm = jest.fn().mockReturnValue(capsuleVm);
        });
        const count = vm.getTaskNum();
        expect(count).assertEqual(testCase.expectedCount);
      });
    });

    // 测试当scene为DESKTOP时
    it('should toggleState to Desktop', async () => {
      await yourClass.toggleState();
      expect(mockGetScene).toHaveBeenCalled();
      expect(mockToggleToDeskTop).toHaveBeenCalled();
    });

    // 测试当scene为HEADS_UP时
    it('should toggleState to HeadUp', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.HEADS_UP);
      await yourClass.toggleState();
      expect(mockToggleToHeadUp).toHaveBeenCalled();
    });

    // 测试当scene为LIVE_PANEL时
    it('should toggleState to LivePanel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.LIVE_PANEL);
      await yourClass.toggleState();
      expect(mockToggleToLiveList).toHaveBeenCalled();
    });

    // 测试当scene为DROPDOWN或SCREEN_LOCK时
    it('should toggleState to Panel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.DROPDOWN);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();

      mockGetScene.mockReturnValue(LiveMetaBallScene.SCREEN_LOCK);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为STATUSBAR_HIDE时
    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });

    it('should return REMIND when sceneSet has REMIND', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.REMIND);
    });

    it('should return SCREEN_LOCK when sceneSet has SCREEN_LOCK', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.SCREEN_LOCK);
    });

    it('should return STATUSBAR_HIDE when sceneSet has STATUSBAR_HIDE and cutoutVm isMiddleCutout', () => {
      sceneSetMock.has.mockReturnValue(true);
      cutoutVmMock.isMiddleCutout.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.STATUSBAR_HIDE);
    });

    it('should return DROPDOWN when sceneSet has DROPDOWN', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DROPDOWN);
    });

    it('should return LIVE_PANEL when sceneSet has LIVE_PANEL', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.LIVE_PANEL);
    });

    it('should return HEADS_UP when sceneSet has HEADS_UP', () => {
      sceneSetMock.has.mockReturnValue(true);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.HEADS_UP);
    });

    it('should return DESKTOP when no conditions are met', () => {
      sceneSetMock.has.mockReturnValue(false);
      cutoutVmMock.isMiddleCutout.mockReturnValue(false);
      expect(new LiveMetaBallScene().getScene()).toBe(LiveMetaBallScene.DESKTOP);
    });

    it('should create an instance of LiveMetaBallBaseVm', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm).not.assertEqualNull();
    });

    it('should set and get animStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 50;
      vm.animStatusBarHeight = height;
      expect(vm.animStatusBarHeight).assertEqual(height);
    });

    it('should set and get STATUS_BAR_HEIGHT correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      expect(vm.STATUS_BAR_HEIGHT).assertEqualDefined();
    });

    it('should updateStatusBarHeight correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const height = 75;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    it('should fusionBall correctly', 0, async () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const status = [true, false];
      const colors: ResourceColor[] = [{ color: '#ff0000' }, { color: '#00ff00' }];
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          curve: Curve.Linear,
          duration: 950,
          finishCallbackType: FinishCallbackType.LOGICALLY
        },
        scene: MetaballAnimationScene.NORMAL
      };
      await vm.fusionBall(status, colors, animateParam);
      // 验证controller的startFusionBallAnimation被调用
      // 例如：
      expect(vm.controller.startFusionBallAnimation).toHaveBeenCalledWith(status, animateParam, colors);
    });

    it('should getAnimateParam correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const animateParam = vm.getAnimateParam();
      expect(animateParam.curve).assertEqual(Curve.Linear);
      expect(animateParam.duration).assertEqual(950);
      expect(animateParam.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should setScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const scene = LiveMetaBallScene.REMIND;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).assertEqual(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).assertEqual(false);
    });

    it('should getScene correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 测试不同的场景
      const scenes = [
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.IMMERSIVE
      ];
      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        const currentScene = vm.getScene();
        expect(currentScene).assertEqual(scene);
        vm.sceneSet.clear();
      }
      // 测试默认场景
      expect(vm.getScene()).assertEqual(LiveMetaBallScene.DESKTOP);
    });

    it('should updateProperty correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      const newVm: ILiveMetaBallVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).assertEqual(true);
    });

    it('should getTaskNum correctly', 0, () => {
      const cutoutVm = CutoutVm.instance;
      const statusBarHeightVm = new StatusBarHeightVm();
      const vm = new TestLiveMetaBallVm();
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
      // 模拟不同的liveList情况
      const testCases = [
        {
          liveList: [],
          expectedCount: 0
        },
        {
          liveList: [
            { typeCode: SysTypeCode.SCREEN_RECORDING, type: LiveType.INSTANT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.PERSISTENT, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: false }
          ],
          expectedCount: 1
        },
        {
          liveList: [
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true },
            { typeCode: SysTypeCode.GENERAL, type: LiveType.GENERAL, isShow: true }
          ],
          expectedCount: 3
        }
      ];

      testCases.forEach(testCase => {
        const capsuleListVm = {
          liveList: testCase.liveList
        };
        vm.vmInjector.getCapsuleListVm = jest.fn().mockReturnValue(capsuleListVm);
        testCase.liveList.forEach(live => {
          const capsuleVm = {
            isShow: live.isShow
          };
          vm.vmInjector.getCapsuleVm = jest.fn().mockReturnValue(capsuleVm);
        });
        const count = vm.getTaskNum();
        expect(count).assertEqual(testCase.expectedCount);
      });
    });

    // 测试当scene为DESKTOP时
    it('should toggleState to Desktop', async () => {
      await yourClass.toggleState();
      expect(mockGetScene).toHaveBeenCalled();
      expect(mockToggleToDeskTop).toHaveBeenCalled();
    });

    // 测试当scene为HEADS_UP时
    it('should toggleState to HeadUp', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.HEADS_UP);
      await yourClass.toggleState();
      expect(mockToggleToHeadUp).toHaveBeenCalled();
    });

    // 测试当scene为LIVE_PANEL时
    it('should toggleState to LivePanel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.LIVE_PANEL);
      await yourClass.toggleState();
      expect(mockToggleToLiveList).toHaveBeenCalled();
    });

    // 测试当scene为DROPDOWN或SCREEN_LOCK时
    it('should toggleState to Panel', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.DROPDOWN);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();

      mockGetScene.mockReturnValue(LiveMetaBallScene.SCREEN_LOCK);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为STATUSBAR_HIDE时
    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });
  });

  describe('controller_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_MetaballController_when_controller_is_called', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      expect(livemetaballbasevm.controller).assertInstanceOf(MetaballController);
    });
  });

  describe('fusionBall_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_when_fusionBall_success', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();

      let mockGetMetaBallVisibleVm: Function = mocker.mockFunc(livemetaballbasevm.vmInjector, livemetaballbasevm.vmInjector.getMetaBallVisibleVm);
      let mockILiveMetaBallVisibleVm: ILiveMetaBallVm = {};
      when(mockGetMetaBallVisibleVm)([]).afterReturn(mockILiveMetaBallVisibleVm);

      let mockStartFusionBallAnimation: Function = mocker.mockFunc(livemetaballbasevm.controller, livemetaballbasevm.controller.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let mockPreSetShowHeight: Function = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().preSetShowHeight);
      when(mockPreSetShowHeight)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturnNothing();

      let mockClearShowHeight: Function = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().clearShowHeight);
      when(mockClearShowHeight)([ArgumentMatchers.anyString]).afterReturnNothing();

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogInfo)([ArgumentMatchers.any]).afterReturnNothing();

      let mockLogError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockLogError)([ArgumentMatchers.any]).afterReturnNothing();
    });

    it('should_resolve_when_fusionBall_success', 0, async () => {
      const mocker = new MockKit();

      // Mock getMetaBallVisibleVm
      const mockGetMetaBallVisibleVm = mocker.mockFunc(livemetaballbasevm.vmInjector, livemetaballbasevm.vmInjector.getMetaBallVisibleVm);
      const mockILiveMetaBallVisibleVm: ILiveMetaBallVisibleVm = {};
      when(mockGetMetaBallVisibleVm)([]).afterReturn(mockILiveMetaBallVisibleVm);

      // Mock startFusionBallAnimation
      const mockStartFusionBallAnimation = mocker.mockFunc(livemetaballbasevm.controller, livemetaballbasevm.controller.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      // Mock preSetShowHeight
      const mockPreSetShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().preSetShowHeight);
      when(mockPreSetShowHeight)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturnNothing();

      // Mock clearShowHeight
      const mockClearShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().clearShowHeight);
      when(mockClearShowHeight)([ArgumentMatchers.anyString]).afterReturnNothing();

      // Mock log.info
      const mockLogInfo = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogInfo)([ArgumentMatchers.any]).afterReturnNothing();

      // 调用fusionBall
      const status = [true];
      const colors = []; // 假设colors为空数组
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          duration: 1000,
          onFinish: () => {}
        },
        scene: LiveMetaBallScene.NORMAL
      };

      const result = await livemetaballbasevm.fusionBall(status, colors, animateParam);

      // 断言Promise resolve
      expect(result).assertUndefined();
    });

    it('should_catch_error_when_startFusionBallAnimation_throws', 0, async () => {
      const mocker = new MockKit();

      const mockGetMetaBallVisibleVm = mocker.mockFunc(livemetaballbasevm.vmInjector, livemetaballbasevm.vmInjector.getMetaBallVisibleVm);
      const mockILiveMetaBallVisibleVm: ILiveMetaBallVisibleVm = {};
      when(mockGetMetaBallVisibleVm)([]).afterReturn(mockILiveMetaBallVisibleVm);

      // Mock startFusionBallAnimation抛出错误
      const mockStartFusionBallAnimation = mocker.mockFunc(livemetaballbasevm.controller, livemetaballbasevm.controller.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterThrow('Test Error');

      const mockPreSetShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().preSetShowHeight);
      when(mockPreSetShowHeight)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturnNothing();

      const mockClearShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().clearShowHeight);
      when(mockClearShowHeight)([ArgumentMatchers.anyString]).afterReturnNothing();

      const mockLogError = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockLogError)([ArgumentMatchers.any]).afterReturnNothing();

      // 调用fusionBall
      const status = [true];
      const colors = []; // 假设colors为空数组
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          duration: 1000,
          onFinish: () => {}
        },
        scene: LiveMetaBallScene.NORMAL
      };

      const result = await livemetaballbasevm.fusionBall(status, colors, animateParam);

      // 断言Promise resolve
      expect(result).assertUndefined();
    });
  });

  describe('getAnimateParam_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_default_duration_when_duration_is_not_provided', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam();
      expect(result.duration).assertEqual(777);
    });

    it('should_return_custom_duration_when_duration_is_provided', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam(500);
      expect(result.duration).assertEqual(500);
    });

    it('should_return_logically_finish_callback_type', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam();
      expect(result.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should_return_curve_as_taskCurve', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam();
      expect(result.curve).assertEqual(curves.taskCurve);
    });

    it('should_return_default_duration_when_duration_is_not_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam();
      expect(result.duration).assertEqual(777);
    });

    it('should_return_custom_duration_when_duration_is_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(500);
      expect(result.duration).assertEqual(500);
    });

    it('should_return_logically_finish_callback_type', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam();
      expect(result.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should_return_curve_as_taskCurve', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam();
      expect(result.curve).assertEqual(curves.taskCurve);
    });

    it('should_return_duration_zero_when_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(0);
      expect(result.duration).assertEqual(0);
    });

    it('should_return_negative_duration_when_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(-100);
      expect(result.duration).assertEqual(-100);
    });

    it('should_return_large_duration_when_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(1000000);
      expect(result.duration).assertEqual(1000000);
    });

    it('should_return_default_duration_when_duration_is_null', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(null);
      expect(result.duration).assertEqual(777);
    });
  });

  describe('toggleState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_toggleToDeskTop_when_scene_is_DESKTOP', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToDeskTop: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToDeskTop);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.DESKTOP);
      when(mockToggleToDeskTop)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        isUpwards: true,
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToDeskTop);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToHeadUp_when_scene_is_HEADS_UP', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToHeadUp: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToHeadUp);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.HEADS_UP);
      when(mockToggleToHeadUp)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToHeadUp);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToLiveList_when_scene_is_LIVE_PANEL', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToLiveList: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToLiveList);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.LIVE_PANEL);
      when(mockToggleToLiveList)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToLiveList);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToPanel_when_scene_is_DROPDOWN', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.DROPDOWN);
      when(mockToggleToPanel)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToPanel_when_scene_is_SCREEN_LOCK', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.SCREEN_LOCK);
      when(mockToggleToPanel)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_call_toggleToPanel_when_scene_is_STATUSBAR_HIDE', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.STATUSBAR_HIDE);
      when(mockToggleToPanel)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
    });

    it('should_call_toggleToRemind_when_scene_is_REMIND', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToRemind: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToRemind);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.REMIND);
      when(mockToggleToRemind)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToRemind);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToImmersive_when_scene_is_IMMERSIVE', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToImmersive: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToImmersive);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.IMMERSIVE);
      when(mockToggleToImmersive)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToImmersive);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_add_scene_when_isAdd_is_true', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      livemetaballbasevm.setScene(scene, true);
      expect(livemetaballbasevm.sceneSet.has(scene)).assertTrue();
    });

    it('should_remove_scene_when_isAdd_is_false', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      livemetaballbasevm.setScene(scene, false);
      expect(livemetaballbasevm.sceneSet.has(scene)).assertFalse();
    });

    it('should_log_info_when_set_scene', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      livemetaballbasevm.setScene(scene, true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_status_bar_height_when_scene_is_status_bar_height_change', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.STATUS_BAR_HEIGHT_CHANGE;
      let mocker: MockKit = new MockKit();
      let statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.instance;
      let mockfunc: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.updateStatusBarHeight);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(null);
      livemetaballbasevm.setScene(scene, true);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.updateStatusBarHeight);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_cutout_vm_when_scene_is_camera_switch', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.CAMERA_SWITCH;
      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockfunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.updateCutout);
      when(mockfunc)().afterReturn(null);
      livemetaballbasevm.setScene(scene, true);
      mocker.ignoreMock(cutoutVm, cutoutVm.updateCutout);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_scale_when_scene_is_camera_switch', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.CAMERA_SWITCH;
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.updateScale);
      when(mockfunc)(ArgumentMatchers.anyNumber, ArgumentMatchers.anyNumber).afterReturn(null);
      livemetaballbasevm.setScene(scene, true);
      mocker.ignoreMock(metaballController, metaballController.updateScale);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_animation_params_when_scene_is_camera_switch', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.CAMERA_SWITCH;
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.updateAnimationParams);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);
      livemetaballbasevm.setScene(scene, true);
      mocker.ignoreMock(metaballController, metaballController.updateAnimationParams);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_status_bar_capsule_position_when_scene_is_status_bar_capsule_position_change', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.STATUS_BAR_CAPSULE_POSITION_CHANGE;
      let mocker: MockKit = new MockKit();
      let statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.instance;
      let mockfunc: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.updateStatusBarCapsulePosition);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);
      livemetaballbasevm.setScene(scene, true);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.updateStatusBarCapsulePosition);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_status_bar_capsule_position_when_scene_is_status_bar_capsule_position_change_2', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.STATUS_BAR_CAPSULE_POSITION_CHANGE;
      let mocker: MockKit = new MockKit();
      let statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.instance;
      let mockfunc: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.updateStatusBarCapsulePosition);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);
      livemetaballbasevm.setScene(scene, false);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.updateStatusBarCapsulePosition);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_status_bar_capsule_position_when_scene_is_status_bar_capsule_position_change_3', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.STATUS_BAR_CAPSULE_POSITION_CHANGE;
      let mocker: MockKit = new MockKit();
      let statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.instance;
      let mockfunc: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.updateStatusBarCapsulePosition);
      when(mockfunc)(ArgumentMatchers.anyObj).afterReturn(null);
      livemetaballbasevm.setScene(scene, true);
      mocker.ignoreMock(statusBarHeightVm, statusBarHeightVm.updateStatusBarCapsulePosition);  //还原mock函数，否则会影响其他用例
    });

    it('should_update_status_bar_capsule_position_when_scene_is_status_bar_capsule_position_change_4', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let scene: LiveMetaBallScene = LiveMetaBallScene.STATUS_BAR_CAPSULE_POSITION_CHANGE;
      let mocker: MockKit = new MockKit();
      let statusBarHeightVm: StatusBarHeightVm = StatusBarHeightVm.instance;
      let mockfunc: Function = mocker.mockFunc(statusBarHeightVm, statusBarHeightVm.updateStatusBarCapsulePosition);
    });
  });

  describe('getScene_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_LiveMetaBallScene_REMIND_when_REMIND_in_sceneSet', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(LiveMetaBallScene.REMIND);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.REMIND);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.REMIND);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_return_LiveMetaBallScene_SCREEN_LOCK_when_SCREEN_LOCK_in_sceneSet', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(LiveMetaBallScene.SCREEN_LOCK);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.SCREEN_LOCK);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.SCREEN_LOCK);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_return_LiveMetaBallScene_STATUSBAR_HIDE_when_STATUSBAR_HIDE_in_sceneSet_and_cutoutVm_is_middle_cutout', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(LiveMetaBallScene.STATUSBAR_HIDE);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.STATUSBAR_HIDE);
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockCutoutFunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockCutoutFunc)([]).afterReturn(true);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.STATUSBAR_HIDE);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveMetaBallScene_DROPDOWN_when_DROPDOWN_in_sceneSet', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(LiveMetaBallScene.DROPDOWN);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.DROPDOWN);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.DROPDOWN);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_return_LiveMetaBallScene_LIVE_PANEL_when_LIVE_PANEL_in_sceneSet', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(LiveMetaBallScene.LIVE_PANEL);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.LIVE_PANEL);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.LIVE_PANEL);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_return_LiveMetaBallScene_HEADS_UP_when_HEADS_UP_in_sceneSet', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(LiveMetaBallScene.HEADS_UP);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.HEADS_UP);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.HEADS_UP);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_return_LiveMetaBallScene_DESKTOP_when_no_matching_scene', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(LiveMetaBallScene.DESKTOP);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.DESKTOP);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
    });

    it('should_return_LiveMetaBallScene_REMIND_when_multiple_scenes_present', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.REMIND);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.SCREEN_LOCK);
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.REMIND);
    });

    it('should_return_LiveMetaBallScene_DROPDOWN_when_STATUSBAR_HIDE_present_but_cutout_not_middle', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.STATUSBAR_HIDE);
      livemetaballbasevm.sceneSet.add(LiveMetaBallScene.DROPDOWN);

      let mocker: MockKit = new MockKit();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let mockCutoutFunc: Function = mocker.mockFunc(cutoutVm, cutoutVm.isMiddleCutout);
      when(mockCutoutFunc)([]).afterReturn(false);

      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.DROPDOWN);

      mocker.ignoreMock(cutoutVm, cutoutVm.isMiddleCutout);
    });

    it('should_return_LiveMetaBallScene_DESKTOP_when_no_scenes_present', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getScene();
      expect(result).assertEqual(LiveMetaBallScene.DESKTOP);
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

  describe('toggleToDeskTop_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_resolve_when_toggleToDeskTop_is_called_with_no_params', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      await livemetaballbasevm.toggleToDeskTop();
    });

    it('should_resolve_when_toggleToDeskTop_is_called_with_isUpwards_param', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      await livemetaballbasevm.toggleToDeskTop(true);
    });

    it('should_resolve_when_toggleToDeskTop_is_called_with_duration_param', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      await livemetaballbasevm.toggleToDeskTop(false, 1000);
    });

    it('should_resolve_when_toggleToDeskTop_is_called_with_isUpwards_and_duration_params', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      await livemetaballbasevm.toggleToDeskTop(true, 1000);
    });
  });

  describe('toggleToHeadUp_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_when_duration_is_undefined', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      await livemetaballbasevm.toggleToHeadUp();
      mocker.ignoreMock(metaballController, metaballController.play);
    });

    it('should_resolve_when_duration_is_defined', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      await livemetaballbasevm.toggleToHeadUp(1000);
      mocker.ignoreMock(metaballController, metaballController.play);
    });

    it('should_reject_when_metaball_controller_play_fails', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any).afterThrow("Error");
      try {
        await livemetaballbasevm.toggleToHeadUp(1000);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }
      mocker.ignoreMock(metaballController, metaballController.play);
    });
  });

  describe('toggleToLiveList_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_resolve_when_duration_is_undefined', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      await livemetaballbasevm.toggleToLiveList();
      mocker.ignoreMock(metaballController, metaballController.play);
    });
    it('should_resolve_when_duration_is_set', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      await livemetaballbasevm.toggleToLiveList(1000);
      mocker.ignoreMock(metaballController, metaballController.play);
    });
    it('should_reject_when_metaball_controller_play_throws_error', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");
      try {
        await livemetaballbasevm.toggleToLiveList(1000);
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }
      mocker.ignoreMock(metaballController, metaballController.play);
    });
  });

  describe('toggleToPanel_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_when_duration_is_undefined', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      await livemetaballbasevm.toggleToPanel();
      mocker.ignoreMock(metaballController, metaballController.play);
    });

    it('should_resolve_when_duration_is_defined', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      await livemetaballbasevm.toggleToPanel(1000);
      mocker.ignoreMock(metaballController, metaballController.play);
    });

    it('should_reject_when_metaball_controller_play_throws_error', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterThrow("Error");
      try {
        await livemetaballbasevm.toggleToPanel();
        assertFail("Expected an error to be thrown");
      } catch (e) {
        expect(e.message).assertEqual("Error");
      }
      mocker.ignoreMock(metaballController, metaballController.play);
    });

    it('should_call_metaball_controller_play_with_correct_params', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      let expectedParams: MetaballAnimationParams = {
        duration: WindowConstants.DEFAULT_DURATION,
        curve: curves.springMotion,
        delay: 0,
        callback: undefined,
        sysType: SysTypeCode.LIVE_TYPE,
        metaballController: metaballController,
        fillMode: RotationConstants.ROTATE_NONE,
        replaceMode: RotationConstants.ROTATE_NONE,
        removeMode: RotationConstants.ROTATE_NONE,
        stash: false
      };
      await livemetaballbasevm.toggleToPanel();
      expect(mockfunc).assertCalledWith(expectedParams);
      mocker.ignoreMock(metaballController, metaballController.play);
    });

    it('should_set_metaball_controller_params_when_duration_is_defined', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve) => {
        resolve();
      }));
      let expectedParams: MetaballAnimationParams = {
        duration: 1000,
        curve: curves.springMotion,
        delay: 0,
        callback: undefined,
        sysType: SysTypeCode.LIVE_TYPE,
        metaballController: metaballController,
        fillMode: RotationConstants.ROTATE_NONE,
        replaceMode: RotationConstants.ROTATE_NONE,
        removeMode: RotationConstants.ROTATE_NONE,
        stash: false
      };
      await livemetaballbasevm.toggleToPanel(1000);
      expect(mockfunc).assertCalledWith(expectedParams);
      mocker.ignoreMock(metaballController, metaballController.play);
    });

    it('should reject when metaball_controller_play_returns_rejected_promise', 0, async () => {
      let mocker: MockKit = new MockKit();
      let metaballController: MetaballController = MetaballController.instance;
      let mockfunc: Function = mocker.mockFunc(metaballController, metaballController.play);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(new CustomPromise<void>((resolve, reject) => {
        reject("Rejected");
      }));
      await assertRejects(async () => {
        await livemetaballbasevm.toggleToPanel();
      }, "Rejected");
      mocker.ignoreMock(metaballController, metaballController.play);
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

    it('should_add_scene_when_isAdd_is_true', 0, () => {
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
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = false;
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.has(scene)).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_add_duplicate_scene_when_isAdd_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = true;
      livemetaballbasevm.setScene(scene, isAdd);
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.size).assertEqual(1);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_remove_nonexistent_scene_gracefully_when_isAdd_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = false;
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.has(scene)).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should toggleState to Panel for STATUSBAR_HIDE', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.STATUSBAR_HIDE);
      await yourClass.toggleState();
      expect(mockToggleToPanel).toHaveBeenCalled();
    });

    // 测试当scene为REMIND时
    it('should toggleState to Remind', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.REMIND);
      await yourClass.toggleState();
      expect(mockToggleToRemind).toHaveBeenCalled();
    });

    // 测试当scene为IMMERSIVE时
    it('should toggleState to Immersive', async () => {
      mockGetScene.mockReturnValue(LiveMetaBallScene.IMMERSIVE);
      await yourClass.toggleState();
      expect(mockToggleToImmersive).toHaveBeenCalled();
    });
  });

  describe('controller_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_MetaballController_when_controller_is_called', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      expect(livemetaballbasevm.controller).assertInstanceOf(MetaballController);
    });
  });

  describe('fusionBall_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_resolve_when_fusionBall_success', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();

      let mockGetMetaBallVisibleVm: Function = mocker.mockFunc(livemetaballbasevm.vmInjector, livemetaballbasevm.vmInjector.getMetaBallVisibleVm);
      let mockILiveMetaBallVisibleVm: ILiveMetaBallVm = {};
      when(mockGetMetaBallVisibleVm)([]).afterReturn(mockILiveMetaBallVisibleVm);

      let mockStartFusionBallAnimation: Function = mocker.mockFunc(livemetaballbasevm.controller, livemetaballbasevm.controller.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      let mockPreSetShowHeight: Function = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().preSetShowHeight);
      when(mockPreSetShowHeight)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturnNothing();

      let mockClearShowHeight: Function = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().clearShowHeight);
      when(mockClearShowHeight)([ArgumentMatchers.anyString]).afterReturnNothing();

      let mockLogInfo: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogInfo)([ArgumentMatchers.any]).afterReturnNothing();

      let mockLogError: Function = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockLogError)([ArgumentMatchers.any]).afterReturnNothing();
    });

    it('should_resolve_when_fusionBall_success', 0, async () => {
      const mocker = new MockKit();

      // Mock getMetaBallVisibleVm
      const mockGetMetaBallVisibleVm = mocker.mockFunc(livemetaballbasevm.vmInjector, livemetaballbasevm.vmInjector.getMetaBallVisibleVm);
      const mockILiveMetaBallVisibleVm: ILiveMetaBallVisibleVm = {};
      when(mockGetMetaBallVisibleVm)([]).afterReturn(mockILiveMetaBallVisibleVm);

      // Mock startFusionBallAnimation
      const mockStartFusionBallAnimation = mocker.mockFunc(livemetaballbasevm.controller, livemetaballbasevm.controller.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterReturnNothing();

      // Mock preSetShowHeight
      const mockPreSetShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().preSetShowHeight);
      when(mockPreSetShowHeight)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturnNothing();

      // Mock clearShowHeight
      const mockClearShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().clearShowHeight);
      when(mockClearShowHeight)([ArgumentMatchers.anyString]).afterReturnNothing();

      // Mock log.info
      const mockLogInfo = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockLogInfo)([ArgumentMatchers.any]).afterReturnNothing();

      // 调用fusionBall
      const status = [true];
      const colors = []; // 假设colors为空数组
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          duration: 1000,
          onFinish: () => {}
        },
        scene: LiveMetaBallScene.NORMAL
      };

      const result = await livemetaballbasevm.fusionBall(status, colors, animateParam);

      // 断言Promise resolve
      expect(result).assertUndefined();
    });

    it('should_catch_error_when_startFusionBallAnimation_throws', 0, async () => {
      const mocker = new MockKit();

      const mockGetMetaBallVisibleVm = mocker.mockFunc(livemetaballbasevm.vmInjector, livemetaballbasevm.vmInjector.getMetaBallVisibleVm);
      const mockILiveMetaBallVisibleVm: ILiveMetaBallVisibleVm = {};
      when(mockGetMetaBallVisibleVm)([]).afterReturn(mockILiveMetaBallVisibleVm);

      // Mock startFusionBallAnimation抛出错误
      const mockStartFusionBallAnimation = mocker.mockFunc(livemetaballbasevm.controller, livemetaballbasevm.controller.startFusionBallAnimation);
      when(mockStartFusionBallAnimation)([ArgumentMatchers.any, ArgumentMatchers.any, ArgumentMatchers.any]).afterThrow('Test Error');

      const mockPreSetShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().preSetShowHeight);
      when(mockPreSetShowHeight)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturnNothing();

      const mockClearShowHeight = mocker.mockFunc(StatusBarHeightVm.getInstance(), StatusBarHeightVm.getInstance().clearShowHeight);
      when(mockClearShowHeight)([ArgumentMatchers.anyString]).afterReturnNothing();

      const mockLogError = mocker.mockFunc(LogHelper, LogHelper.showError);
      when(mockLogError)([ArgumentMatchers.any]).afterReturnNothing();

      // 调用fusionBall
      const status = [true];
      const colors = []; // 假设colors为空数组
      const animateParam: MetaballAnimationParams = {
        animateParam: {
          duration: 1000,
          onFinish: () => {}
        },
        scene: LiveMetaBallScene.NORMAL
      };

      const result = await livemetaballbasevm.fusionBall(status, colors, animateParam);

      // 断言Promise resolve
      expect(result).assertUndefined();
    });
  });

  describe('getAnimateParam_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_default_duration_when_duration_is_not_provided', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam();
      expect(result.duration).assertEqual(777);
    });

    it('should_return_custom_duration_when_duration_is_provided', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam(500);
      expect(result.duration).assertEqual(500);
    });

    it('should_return_logically_finish_callback_type', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam();
      expect(result.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should_return_curve_as_taskCurve', 0, () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let result: AnimateParam = livemetaballbasevm.getAnimateParam();
      expect(result.curve).assertEqual(curves.taskCurve);
    });

    it('should_return_default_duration_when_duration_is_not_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam();
      expect(result.duration).assertEqual(777);
    });

    it('should_return_custom_duration_when_duration_is_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(500);
      expect(result.duration).assertEqual(500);
    });

    it('should_return_logically_finish_callback_type', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam();
      expect(result.finishCallbackType).assertEqual(FinishCallbackType.LOGICALLY);
    });

    it('should_return_curve_as_taskCurve', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam();
      expect(result.curve).assertEqual(curves.taskCurve);
    });

    it('should_return_duration_zero_when_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(0);
      expect(result.duration).assertEqual(0);
    });

    it('should_return_negative_duration_when_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(-100);
      expect(result.duration).assertEqual(-100);
    });

    it('should_return_large_duration_when_provided', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(1000000);
      expect(result.duration).assertEqual(1000000);
    });

    it('should_return_default_duration_when_duration_is_null', 0, () => {
      const livemetaballbasevm = new LiveMetaBallBaseVm();
      const result = livemetaballbasevm.getAnimateParam(null);
      expect(result.duration).assertEqual(777);
    });
  });

  describe('toggleState_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_call_toggleToDeskTop_when_scene_is_DESKTOP', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToDeskTop: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToDeskTop);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.DESKTOP);
      when(mockToggleToDeskTop)([ArgumentMatchers.anyBoolean, ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        isUpwards: true,
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToDeskTop);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToHeadUp_when_scene_is_HEADS_UP', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToHeadUp: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToHeadUp);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.HEADS_UP);
      when(mockToggleToHeadUp)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToHeadUp);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToLiveList_when_scene_is_LIVE_PANEL', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToLiveList: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToLiveList);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.LIVE_PANEL);
      when(mockToggleToLiveList)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToLiveList);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToPanel_when_scene_is_DROPDOWN', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.DROPDOWN);
      when(mockToggleToPanel)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToPanel_when_scene_is_SCREEN_LOCK', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.SCREEN_LOCK);
      when(mockToggleToPanel)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_call_toggleToPanel_when_scene_is_STATUSBAR_HIDE', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToPanel: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.STATUSBAR_HIDE);
      when(mockToggleToPanel)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToPanel);
    });

    it('should_call_toggleToRemind_when_scene_is_REMIND', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToRemind: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToRemind);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.REMIND);
      when(mockToggleToRemind)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToRemind);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_call_toggleToImmersive_when_scene_is_IMMERSIVE', 0, async () => {
      let livemetaballbasevm: LiveMetaBallBaseVm = new LiveMetaBallBaseVm();
      let mocker: MockKit = new MockKit();
      let mockGetScene: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.getScene);
      let mockToggleToImmersive: Function = mocker.mockFunc(livemetaballbasevm, livemetaballbasevm.toggleToImmersive);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);

      when(mockGetScene)([]).afterReturn(LiveMetaBallScene.IMMERSIVE);
      when(mockToggleToImmersive)([ArgumentMatchers.anyNumber]).afterReturn(new Promise<void>(() => {}));
      when(mockShowInfo)([ArgumentMatchers.anyString]).afterReturn(undefined);

      let capsuleTransferParam: CapsuleTransferParam = {
        metaBallToggleDuration: 1000
      };
      await livemetaballbasevm.toggleState(capsuleTransferParam);

      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.getScene);
      mocker.ignoreMock(livemetaballbasevm, livemetaballbasevm.toggleToImmersive);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
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

    it('should_add_scene_when_isAdd_is_true', 0, () => {
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
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = false;
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.has(scene)).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_add_duplicate_scene_when_isAdd_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = true;
      livemetaballbasevm.setScene(scene, isAdd);
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.size).assertEqual(1);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_remove_nonexistent_scene_gracefully_when_isAdd_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      let scene: LiveMetaBallScene = LiveMetaBallScene.DEFAULT;
      let isAdd: boolean = false;
      livemetaballbasevm.setScene(scene, isAdd);

      expect(livemetaballbasevm.sceneSet.has(scene)).assertFalse();
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
}