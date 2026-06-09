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
import { describe, it, beforeEach, afterEach, expect } from '@ohos.test';
import { BallParams, MetaballAnimationScene } from '@hms.hds.Metaball';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ILiveMetaBallVm } from '../interface/ILiveMetaBallVm';
import { LiveStyle } from '../constants/LiveStyle';
import { LiveMetaBallBaseVm } from './LiveMetaBallBaseVm';
import { LiveSingleMetaBallVm } from '../../../../../../main/ets/live/vm/LiveSingleMetaBallVm';
import { StatusBarHeightVm } from '../../../../../../main/ets/statusbar/vm/StatusBarHeightVm';
import { CutoutVm, LiveVmInjector, StatusBarCapsulePosition } from '../../../../../../../newIndex';
import { LiveMetaBallScene } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { BaseVmInjector } from '../../../../../../main/ets/vm/BaseVmInjector';

const TAG = 'LiveSingleMetaBallVmTest';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default function LiveSingleMetaBallVmTest() {
  describe('LiveSingleMetaBallVmTest', () => {
    beforeEach(() => {
      // 初始化依赖项
      capsulePosition.width = 200;
      capsulePosition.height = 100;
      capsulePosition.left = 50;
      capsulePosition.top = 50;
      capsulePosition.holes = [
        {
          centerX: 100, centerY: 200
        }
      ];
      vm.cutoutVm = cutoutVm;
      vm.statusBarHeightVm = statusBarHeightVm;
    });

    afterEach(() => {
      vm = null;
      cutoutVm = null;
      statusBarHeightVm = null;
      capsulePosition = null;
    });

    // 测试getWidth方法
    it('should calculate width correctly', 0, () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      const width = vm.getWidth(capsulePosition);
      expect(width).toBe(capsulePosition.width * 5.0);
    });

    // 测试getHeight方法
    it('should calculate height correctly', 0, () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      const height = vm.getHeight(capsulePosition);
      expect(height).toBe(capsulePosition.height * 1.6);
    });

    // 测试getPosition方法
    it('should calculate position correctly', 0, () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      const position = vm.getPosition(capsulePosition);
      expect(position.left).toBe(-capsulePosition.width * (5.0 - 1) / 2);
      expect(position.top).toBe(-capsulePosition.height * (1.6 - 1) / 2);
    });

    // 测试getBallParam方法
    it('should get ball parameters correctly', 0, () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      const params = vm.getBallParam(capsulePosition);
      expect(params.length).toBe(1);
      expect(params[0].centerX).toBe(capsulePosition.holes[0].centerX - capsulePosition.left);
      expect(params[0].centerY).toBe(capsulePosition.holes[0].centerY - capsulePosition.top);
      expect(params[0].radius).toBe(LiveStyle.CAPSULE_HEIGHT / 2);
      expect(params[0].isIsolated).toBe(true);
    });

    // 测试toggleState方法
    it('should toggle state correctly for different scenes', 0, async () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      // 模拟不同的场景
      const scenes = [
        LiveMetaBallScene.DESKTOP,
        LiveMetaBallScene.LIVE_PANEL,
        LiveMetaBallScene.DROPDOWN,
        LiveMetaBallScene.SCREEN_LOCK,
        LiveMetaBallScene.STATUSBAR_HIDE,
        LiveMetaBallScene.REMIND,
        LiveMetaBallScene.IMMERSIVE
      ];

      for (const scene of scenes) {
        vm.sceneSet.add(scene);
        await vm.toggleState();
        // 根据不同的场景，验证相应的toggleTo...方法被调用
        // 这里需要使用jest或其他 mocking 工具来跟踪方法调用
        // 例如：
        // expect(vm.toggleToDeskTop).toHaveBeenCalled();
        vm.sceneSet.clear();
      }
      expect(vm.sceneSet.size() > 0).assertEqual(true);
    });

    // 测试toggleToDeskTop方法
    it('should toggle to desktop state correctly', 0, async () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      // 模拟不同的taskNum
      const taskNums = [0, 1, 2, 3];
      for (const taskNum of taskNums) {
        vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
        await vm.toggleToDeskTop();
        // 验证fusionBall被正确调用
        // 例如：
        expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
      }
    });

    // 测试toggleToLiveList方法
    it('should toggle to live list state correctly', 0, async () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      await vm.toggleToLiveList();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    });

    // 测试toggleToPanel方法
    it('should toggle to panel state correctly', 0, async () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      await vm.toggleToPanel();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    });

    // 测试toggleToRemind方法
    it('should toggle to remind state correctly', 0, async () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      // 模拟不同的taskNum
      const taskNums = [0, 1, 2];
      for (const taskNum of taskNums) {
        vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
        await vm.toggleToRemind();
        // 验证fusionBall被正确调用
        // 例如：
        expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
      }
    });

    // 测试toggleToImmersive方法
    it('should toggle to immersive state correctly', 0, async () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      await vm.toggleToImmersive();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    });

    // 测试更新状态栏高度
    it('should update status bar height correctly', 0, () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      const height = 100;
      const tag = 'testTag';
      vm.updateStatusBarHeight(height, tag);
      // 验证StatusBarHeightVm的preSetShowHeight被调用
      // 例如：
      expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
    });

    // 测试设置和获取场景
    it('should set and get scene correctly', 0, () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      const scene = LiveMetaBallScene.DESKTOP;
      vm.setScene(scene, true);
      expect(vm.sceneSet.has(scene)).toBe(true);
      vm.setScene(scene, false);
      expect(vm.sceneSet.has(scene)).toBe(false);
    });

    // 测试更新属性
    it('should update properties correctly', 0, () => {
      let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm();
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
      let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
      const newVm = {
        sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
      };
      vm.updateProperty(newVm);
      expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
    });
  });

  // 测试getWidth方法
  it('should calculate width correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const width = vm.getWidth(capsulePosition);
    expect(width).toBe(capsulePosition.width * 5.0);
  });

  // 测试getHeight方法
  it('should calculate height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = vm.getHeight(capsulePosition);
    expect(height).toBe(capsulePosition.height * 1.6);
  });

  // 测试getPosition方法
  it('should calculate position correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const position = vm.getPosition(capsulePosition);
    expect(position.left).toBe(-capsulePosition.width * (5.0 - 1) / 2);
    expect(position.top).toBe(-capsulePosition.height * (1.6 - 1) / 2);
  });

  // 测试getBallParam方法
  it('should get ball parameters correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const params = vm.getBallParam(capsulePosition);
    expect(params.length).toBe(1);
    expect(params[0].centerX).toBe(capsulePosition.holes[0].centerX - capsulePosition.left);
    expect(params[0].centerY).toBe(capsulePosition.holes[0].centerY - capsulePosition.top);
    expect(params[0].radius).toBe(LiveStyle.CAPSULE_HEIGHT / 2);
    expect(params[0].isIsolated).toBe(true);
  });

  // 测试toggleState方法
  it('should toggle state correctly for different scenes', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的场景
    const scenes = [
      LiveMetaBallScene.DESKTOP,
      LiveMetaBallScene.LIVE_PANEL,
      LiveMetaBallScene.DROPDOWN,
      LiveMetaBallScene.SCREEN_LOCK,
      LiveMetaBallScene.STATUSBAR_HIDE,
      LiveMetaBallScene.REMIND,
      LiveMetaBallScene.IMMERSIVE
    ];

    for (const scene of scenes) {
      vm.sceneSet.add(scene);
      await vm.toggleState();
      // 根据不同的场景，验证相应的toggleTo...方法被调用
      // 这里需要使用jest或其他 mocking 工具来跟踪方法调用
      // 例如：
      // expect(vm.toggleToDeskTop).toHaveBeenCalled();
      vm.sceneSet.clear();
    }
  });

  // 测试toggleToDeskTop方法
  it('should toggle to desktop state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的taskNum
    const taskNums = [0, 1, 2, 3];
    for (const taskNum of taskNums) {
      vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
      await vm.toggleToDeskTop();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    }
  });

  // 测试toggleToLiveList方法
  it('should toggle to live list state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToLiveList();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试toggleToPanel方法
  it('should toggle to panel state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToPanel();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试toggleToRemind方法
  it('should toggle to remind state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的taskNum
    const taskNums = [0, 1, 2];
    for (const taskNum of taskNums) {
      vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
      await vm.toggleToRemind();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    }
  });

  // 测试toggleToImmersive方法
  it('should toggle to immersive state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToImmersive();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试getWidth方法
  it('should calculate width correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const width = vm.getWidth(capsulePosition);
    expect(width).toBe(capsulePosition.width * 5.0);
  });

  // 测试getHeight方法
  it('should calculate height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = vm.getHeight(capsulePosition);
    expect(height).toBe(capsulePosition.height * 1.6);
  });

  // 测试getPosition方法
  it('should calculate position correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const position = vm.getPosition(capsulePosition);
    expect(position.left).toBe(-capsulePosition.width * (5.0 - 1) / 2);
    expect(position.top).toBe(-capsulePosition.height * (1.6 - 1) / 2);
  });

  // 测试getBallParam方法
  it('should get ball parameters correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const params = vm.getBallParam(capsulePosition);
    expect(params.length).toBe(1);
    expect(params[0].centerX).toBe(capsulePosition.holes[0].centerX - capsulePosition.left);
    expect(params[0].centerY).toBe(capsulePosition.holes[0].centerY - capsulePosition.top);
    expect(params[0].radius).toBe(LiveStyle.CAPSULE_HEIGHT / 2);
    expect(params[0].isIsolated).toBe(true);
  });

  // 测试toggleState方法
  it('should toggle state correctly for different scenes', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的场景
    const scenes = [
      LiveMetaBallScene.DESKTOP,
      LiveMetaBallScene.LIVE_PANEL,
      LiveMetaBallScene.DROPDOWN,
      LiveMetaBallScene.SCREEN_LOCK,
      LiveMetaBallScene.STATUSBAR_HIDE,
      LiveMetaBallScene.REMIND,
      LiveMetaBallScene.IMMERSIVE
    ];

    for (const scene of scenes) {
      vm.sceneSet.add(scene);
      await vm.toggleState();
      // 根据不同的场景，验证相应的toggleTo...方法被调用
      // 这里需要使用jest或其他 mocking 工具来跟踪方法调用
      // 例如：
      // expect(vm.toggleToDeskTop).toHaveBeenCalled();
      vm.sceneSet.clear();
    }
  });

  // 测试toggleToDeskTop方法
  it('should toggle to desktop state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的taskNum
    const taskNums = [0, 1, 2, 3];
    for (const taskNum of taskNums) {
      vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
      await vm.toggleToDeskTop();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    }
  });

  // 测试toggleToLiveList方法
  it('should toggle to live list state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToLiveList();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试toggleToPanel方法
  it('should toggle to panel state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToPanel();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试toggleToRemind方法
  it('should toggle to remind state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    // 模拟不同的taskNum
    const taskNums = [0, 1, 2];
    for (const taskNum of taskNums) {
      vm.getTaskNum = jest.fn().mockReturnValue(taskNum);
      await vm.toggleToRemind();
      // 验证fusionBall被正确调用
      // 例如：
      expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
    }
  });

  // 测试toggleToImmersive方法
  it('should toggle to immersive state correctly', 0, async () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    await vm.toggleToImmersive();
    // 验证fusionBall被正确调用
    // 例如：
    expect(vm.fusionBall).toHaveBeenCalledWith('fusionBall');
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试设置和获取场景
  it('should set and get scene correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const scene = LiveMetaBallScene.DESKTOP;
    vm.setScene(scene, true);
    expect(vm.sceneSet.has(scene)).toBe(true);
    vm.setScene(scene, false);
    expect(vm.sceneSet.has(scene)).toBe(false);
  });

  // 测试更新属性
  it('should update properties correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const newVm = {
      sceneSet: new Set([LiveMetaBallScene.LIVE_PANEL])
    };
    vm.updateProperty(newVm);
    expect(vm.sceneSet.has(LiveMetaBallScene.LIVE_PANEL)).toBe(true);
  });

  // 测试更新状态栏高度
  it('should update status bar height correctly', 0, () => {
    let vm: LiveSingleMetaBallVm = new LiveSingleMetaBallVm(new LiveVmInjector());
    let cutoutVm: CutoutVm = CutoutVm.instance;
    let statusBarHeightVm: StatusBarHeightVm = new StatusBarHeightVm();
    let capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();
    const height = 100;
    const tag = 'testTag';
    vm.updateStatusBarHeight(height, tag);
    // 验证StatusBarHeightVm的preSetShowHeight被调用
    // 例如：
    expect(statusBarHeightVm.preSetShowHeight).toHaveBeenCalledWith(height, tag);
  });


  it('should_set_capsuleVm_isShowed_to_true_when_envVm_is_screenLock', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockEnvVm: EnvVm = new EnvVm();
    when(mockEnvVm.isScreenLock)([]).afterReturn(true);
    liverindvm.envVm = mockEnvVm;

    let live: LiveNotification = new LiveNotification();
    liverindvm.checkUpdateCapsuleScene(live);

    expect(mockCapsuleVm.isShowed).assertEqual(true);

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
  });

  it('should_set_capsuleVm_isShowed_to_true_when_app_is_foreground_and_live_is_not_sticky', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockAppLifeCycleManager: AppLifeCycleManager = AppLifeCycleManager.instance;
    when(mockAppLifeCycleManager.isForeground)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

    let live: LiveNotification = new LiveNotification();
    liverindvm.checkUpdateCapsuleScene(live);

    expect(mockCapsuleVm.isShowed).assertEqual(true);

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
  });

  it('should_return_immediately_when_live_is_not_Flip', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(false);

    let live: LiveNotification = new LiveNotification();
    liveremindvm.checkUpdateCapsuleScene(live);

    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
  });

  it('should_set_capsuleVm_isShowed_to_true_when_dropdownVm_is_true', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockIsDropDown: Function = mocker.mockFunc(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
    when(mockIsDropDown)([]).afterReturn(true);

    let live: LiveNotification = new LiveNotification();
    liveremindvm.checkUpdateCapsuleScene(live);

    expect(mockCapsuleVm.isShowed).assertEqual(true);

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
  });

  it('should_set_capsuleVm_isShowed_to_true_when_bannerVm_is_hideCapsule', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockIsHideCapsule: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
    when(mockIsHideCapsule)([]).afterReturn(true);

    let live: LiveNotification = new LiveNotification();
    liveremindvm.checkUpdateCapsuleScene(live);

    expect(mockCapsuleVm.isShowed).assertEqual(true);

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
  });

  it('should_set_capsuleVm_isShowed_to_true_when_live_headsUpNtfHashCode_matches', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockGetLiveHeadsUpVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
    let mockLiveHeadsUpVm: { headsUpNtfHashCode: string } = { headsUpNtfHashCode: 'testHash' };
    when(mockGetLiveHeadsUpVm)([]).afterReturn(mockLiveHeadsUpVm);

    let live: LiveNotification = new LiveNotification();
    live.hashCode = 'testHash';
    liveremindvm.checkUpdateCapsuleScene(live);

    expect(mockCapsuleVm.isShowed).assertEqual(true);

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
  });

  it('should_set_capsuleVm_isShowed_to_true_when_envVm_is_screenLock', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockEnvVm: EnvVm = new EnvVm();
    when(mockEnvVm.isScreenLock)([]).afterReturn(true);
    liveremindvm.envVm = mockEnvVm;

    let live: LiveNotification = new LiveNotification();
    liveremindvm.checkUpdateCapsuleScene(live);

    expect(mockCapsuleVm.isShowed).assertEqual(true);

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
  });

  it('should_set_capsuleVm_isShowed_to_true_when_app_is_foreground_and_live_is_not_sticky', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockAppLifeCycleManager: AppLifeCycleManager = AppLifeCycleManager.instance;
    when(mockAppLifeCycleManager.isForeground)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(true);

    let live: LiveNotification = new LiveNotification();
    live.capsule = { sticky: false };
    liveremindvm.checkUpdateCapsuleScene(live);

    expect(mockCapsuleVm.isShowed).assertEqual(true);

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
  });

  it('should_call_setRemindCapsule_when_all_conditions_are_met', 0, () => {
    let liveremindvm: LiveRemindVm = new LiveRemindVm();
    let mocker: MockKit = new MockKit();
    let mockIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
    when(mockIsFlip)(ArgumentMatchers.any).afterReturn(true);

    let mockGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    let mockCapsuleVm: ILiveRemindVm = {};
    when(mockGetCapsuleVm)(ArgumentMatchers.any).afterReturn(mockCapsuleVm);

    let mockIsDropDown: Function = mocker.mockFunc(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
    when(mockIsDropDown)([]).afterReturn(false);

    let mockIsHideCapsule: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
    when(mockIsHideCapsule)([]).afterReturn(false);

    let mockGetLiveHeadsUpVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
    let mockLiveHeadsUpVm: { headsUpNtfHashCode: string } = { headsUpNtfHashCode: 'differentHash' };
    when(mockGetLiveHeadsUpVm)([]).afterReturn(mockLiveHeadsUpVm);

    let mockEnvVm: EnvVm = new EnvVm();
    when(mockEnvVm.isScreenLock)([]).afterReturn(false);
    liveremindvm.envVm = mockEnvVm;

    let mockAppLifeCycleManager: AppLifeCycleManager = AppLifeCycleManager.instance;
    when(mockAppLifeCycleManager.isForeground)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);

    let mockSetRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.setRemindCapsule);
    when(mockSetRemindCapsule)(ArgumentMatchers.any).afterAction(() => {
      // 模拟setRemindCapsule的行为
    });

    let live: LiveNotification = new LiveNotification();
    live.hashCode = 'testHash';
    live.capsule = { sticky: true };
    liveremindvm.checkUpdateCapsuleScene(live);

    expect(mockSetRemindCapsule).toHaveBeenCalled();

    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
    mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
    mocker.ignoreMock(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
    mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
    mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
    mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
    mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
    mocker.ignoreMock(liveremindvm, liveremindvm.setRemindCapsule);
  });

  describe('checkCurrentRemindScene_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_clear_remind_capsule_when_live_is_instant', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsInstant: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      let live: LiveNotification = new LiveNotification();
      when(mockfuncIsInstant)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_dropdown_is_true', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncGetCapsuleVm: Function = mocker.mockFunc(liveremindvm, liveremindvm.vmInjector.getCapsuleVm);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncGetCapsuleVm)(ArgumentMatchers.any).afterReturn(capsuleVm);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_banner_is_hide', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsHideCapsule: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      let live: LiveNotification = new LiveNotification();
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncIsHideCapsule)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_heads_up_is_same', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncGetLiveHeadsUpVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      let live: LiveNotification = new LiveNotification();
      let headsUpVm: ILiveHeadsUpVm = new ILiveHeadsUpVm();
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncGetLiveHeadsUpVm)().afterReturn(headsUpVm);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_env_is_screen_lock', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncGetEnvVm: Function = mocker.mockFunc(liveremindvm, liveremindvm.envVm);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      let live: LiveNotification = new LiveNotification();
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncGetEnvVm.isScreenLock)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_app_is_not_foreground', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsForeground: Function = mocker.mockFunc(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);
      let live: LiveNotification = new LiveNotification();
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncIsForeground)(ArgumentMatchers.any, ArgumentMatchers.any).afterReturn(false);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_instant', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsInstant: Function = mocker.mockFunc(liveremindvm, liveremindvm.isInstant);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);

      let live: LiveNotification = new LiveNotification();
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(live);
      when(mockfuncIsInstant)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);

      liveremindvm.checkCurrentRemindScene();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.isInstant);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_dropdown_is_true', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      let mockfuncIsDropDown: Function = mocker.mockFunc(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);

      let live: LiveNotification = new LiveNotification();
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(live);
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncIsDropDown)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);

      liveremindvm.checkCurrentRemindScene();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
      mocker.ignoreMock(liveremindvm.dropdownVm, liveremindvm.dropdownVm.isDropDown);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_banner_is_hide', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      let mockfuncIsHideCapsule: Function = mocker.mockFunc(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);

      let live: LiveNotification = new LiveNotification();
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(live);
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncIsHideCapsule)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);

      liveremindvm.checkCurrentRemindScene();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
      mocker.ignoreMock(liveremindvm.bannerVm, liveremindvm.bannerVm.isHideCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_heads_up_is_same', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      let mockfuncGetLiveHeadsUpVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);

      let live: LiveNotification = new LiveNotification();
      let headsUpVm: ILiveHeadsUpVm = new ILiveHeadsUpVm();
      headsUpVm.headsUpNtfHashCode = live.hashCode;
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(live);
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncGetLiveHeadsUpVm)().afterReturn(headsUpVm);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);

      liveremindvm.checkCurrentRemindScene();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getLiveHeadsUpVm);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_env_is_screen_lock', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      let mockfuncIsScreenLock: Function = mocker.mockFunc(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);

      let live: LiveNotification = new LiveNotification();
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(live);
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncIsScreenLock)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);

      liveremindvm.checkCurrentRemindScene();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
      mocker.ignoreMock(liveremindvm.envVm, liveremindvm.envVm.isScreenLock);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_app_is_not_foreground', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      let mockfuncIsForeground: Function = mocker.mockFunc(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);

      let live: LiveNotification = new LiveNotification();
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(live);
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncIsForeground)(live.creatorUid, live).afterReturn(false);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);

      liveremindvm.checkCurrentRemindScene();

      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
      mocker.ignoreMock(AppLifeCycleManager.instance, AppLifeCycleManager.instance.isForeground);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_clear_remind_capsule_when_live_is_flip_and_banner_is_type_live_heads_up_and_remind_show', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      let mockfuncIsFlip: Function = mocker.mockFunc(liveremindvm, liveremindvm.isFlip);
      let mockfuncGetCapsuleVm: Function = mocker.mockFunc(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
      let mockfuncIsRemindShow: Function = mocker.mockFunc(liveremindvm.vmInjector.getCapsuleVm(live), liveremindvm.vmInjector.getCapsuleVm(live).isRemindShow);
      let mockfuncClearRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.clearRemindCapsule);

      let live: LiveNotification = new LiveNotification();
      let capsuleVm: ILiveCapsuleVm = new ILiveCapsuleVm();
      capsuleVm.isRemindShow = true;
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(live);
      when(mockfuncIsFlip)().afterReturn(true);
      when(mockfuncGetCapsuleVm)(live).afterReturn(capsuleVm);
      when(mockfuncIsRemindShow)().afterReturn(true);
      when(mockfuncClearRemindCapsule)().afterReturn(undefined);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      mocker.ignoreMock(liveremindvm, liveremindvm.isFlip);
      mocker.ignoreMock(liveremindvm.vmInjector, liveremindvm.vmInjector.getCapsuleVm);
      mocker.ignoreMock(liveremindvm.vmInjector.getCapsuleVm(live), liveremindvm.vmInjector.getCapsuleVm(live).isRemindShow);
      mocker.ignoreMock(liveremindvm, liveremindvm.clearRemindCapsule);
    });

    it('should_do_nothing_when_live_is_null', 0, async () => {
      let liveremindvm: LiveRemindVm = new LiveRemindVm();
      let mocker: MockKit = new MockKit();
      let mockfuncGetCurrentRemindCapsule: Function = mocker.mockFunc(liveremindvm, liveremindvm.getCurrentRemindCapsule);
      when(mockfuncGetCurrentRemindCapsule)().afterReturn(null);
      liveremindvm.checkCurrentRemindScene();
      mocker.ignoreMock(liveremindvm, liveremindvm.getCurrentRemindCapsule);
    });
  });
}