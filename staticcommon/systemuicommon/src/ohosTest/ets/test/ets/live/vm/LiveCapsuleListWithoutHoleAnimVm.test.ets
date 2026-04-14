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
import { beforeEach, DEFAULT, describe, it } from '@ohos/hypium';
import { CapsuleTransferParam } from '../../../../../../main/ets/live/interface/ILiveCapsuleListVm';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveCapsuleListWithoutHoleAnimVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListWithoutHoleAnimVm';

// 模拟依赖对象
jest.mock('@/path/to/your-vm-injector', () => ({
  vmInjector: {
    getCapsuleListVm: jest.fn(),
    getCapsuleVm: jest.fn(),
    getCapsuleLightWaveVm: jest.fn(),
  },
}));

jest.mock('@/path/to/system-ui-ccm-config', () => ({
  SystemUICcmConfig: {
    instance: {
      liveConfig: {
        isShowLightWhenExpandCapsule: jest.fn(),
      },
    },
  },
}));

jest.mock('@/path/to/resource-vm', () => ({
  ResourceVm: {
    instance: {
      isRTL: true, // 默认值，测试时可覆盖
    },
  },
}));

describe('LiveCapsuleListWithoutHoleAnimVm', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleAnimVm;
  let vmInjector: any;
  let SystemUICcmConfig: any;
  let ResourceVm: any;
  let AnimationBaseMock: any;

  beforeEach(() => {
    const mockLiveVmInjector = new MockLiveVmInjector();
    liveCapsuleListVm = new LiveCapsuleListWithoutHoleAnimVm(mockLiveVmInjector);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly',DEFAULT, () => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly', DEFAULT,async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly', DEFAULT,() => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleTransferState方法
  it('should set capsule transfer state correctly', DEFAULT,() => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    liveCapsuleListVm.setCapsuleTransferState(capsuleTransferParam);
  });

  // 测试setLightWaveAnim方法
  it('should set light wave animation correctly',DEFAULT, () => {
    const lightWaveVm = liveCapsuleListVm.getLightWaveVm();
    lightWaveVm.setAnimStartState(0);
    lightWaveVm.doWaveAnim(100, 20);
  });

  it('Test setCapsuleListFinalState with default parameters', 0, async () => {
    // 创建测试所需的依赖对象
    const liveNotification = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    // 创建测试对象
    const vm = new LiveCapsuleListWithoutHoleAnimVm();

    // 执行方法
    await vm.setCapsuleListFinalState(capsuleTransferParam);
  });

  it('Test collapseCapsuleList with onlyChangeOpacity true', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    await vm.collapseCapsuleList(capsuleTransferParam);
  });

  it('Test expandCapsuleList with delay', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 500,
      onlyChangeOpacity: false,
      isUpdateImmediately: false
    };

    await vm.expandCapsuleList(capsuleTransferParam);
  });

  it('Test setCapsuleTransferState with immediate update', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    vm.setCapsuleTransferState(capsuleTransferParam);
  });

  it('Test updateCapsuleWidthAndOffset', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const liveList = [new LiveNotification()];

    await vm.updateCapsuleWidthAndOffset(liveList);
  });

  it('Test collapseOtherCapsule with index 0', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    const result = vm.collapseOtherCapsule(live, 0, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandOtherCapsule with opacity change only', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    const result = vm.expandOtherCapsule(live, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandRemindCapsule with delay', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const result = vm.expandRemindCapsule(live, 500);
    expect(result.length).toBe(2);
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    SystemUICcmConfig = require('@/path/to/system-ui-ccm-config').SystemUICcmConfig;
    ResourceVm = require('@/path/to/resource-vm').ResourceVm;
    AnimationBaseMock = jest.fn().mockImplementation(() => ({
      executeAnimation: jest.fn().mockResolvedValue(undefined),
    }));
    (AnimationBase as any).mockImplementation = AnimationBaseMock;
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', async () => {
    const capsuleTransferParam = {
      delay: 200,
      onlyChangeOpacity: false,
    };

    // 模拟数据准备
    const mockLive = { id: 'test' };
    const mockCapsuleListVm = {
      liveList: [mockLive],
    };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedWidth: 150,
      isRemindShow: true,
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockLightWaveVm = {
      lightShow: true,
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn().mockReturnValue([{ type: 'wave' }]),
      doProgressWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);

    // 设置条件
    SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
    ResourceVm.instance.isRTL = true;

    // 执行方法
    await expandCapsuleList(capsuleTransferParam);

    // 验证执行路径
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);
    expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalledWith(200, -60);
    expect(mockLightWaveVm.doProgressWaveAnim).not.toHaveBeenCalled();
    expect(mockCapsuleVm.isRemindShow).toBeTruthy();
    expect(AnimationBaseMock).toHaveBeenCalledWith('CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE');
    expect(AnimationBaseMock().executeAnimation).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时跳过循环
  test('当isShow为false时跳过循环', async () => {
    const mockLive = { id: 'test' };
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    await expandCapsuleList();

    expect(vmInjector.getCapsuleLightWaveVm).not.toHaveBeenCalled();
    expect(AnimationBaseMock().executeAnimation).not.toHaveBeenCalled();
  });

  // 测试用例3：onlyChangeOpacity为true时不更新宽度
  test('当onlyChangeOpacity为true时跳过宽度更新', async () => {
    const param = { onlyChangeOpacity: true };
    const mockUpdateWidth = jest.fn().mockReturnValue([]);
    this.updateCapsuleListWidth = mockUpdateWidth; // 需要正确mock该方法

    await expandCapsuleList(param);

    expect(mockUpdateWidth).not.toHaveBeenCalled();
  });

  // 测试用例4：light条件组合覆盖
  test('light条件组合覆盖', async () => {
    const cases = [
      { lightShow: true, isRemindShow: false, expectWave: true },
      { lightShow: false, isRemindShow: true, expectWave: true },
      { lightShow: true, isRemindShow: true, expectWave: true },
      { lightShow: false, isRemindShow: false, expectWave: false },
    ];

    cases.forEach(({ lightShow, isRemindShow, expectWave }) => {
      const mockLightWaveVm = {
        lightShow,
        setAnimStartState: jest.fn(),
        doWaveAnim: jest.fn(),
        doProgressWaveAnim: jest.fn(),
      };
      vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
      const mockCapsuleVm = { isRemindShow };
      vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

      SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
      ResourceVm.instance.isRTL = true;

      expandCapsuleList().then(() => {
        if (expectWave) {
          expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalled();
        } else {
          expect(mockLightWaveVm.doWaveAnim).not.toHaveBeenCalled();
        }
      });
    });
  });

  // 测试用例5：RTL方向切换
  test('RTL方向切换测试', async () => {
    const mockLightWaveVm = {
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
    const mockCapsuleVm = { fixedWidth: 200, isRemindShow: true };

    // 测试RTL为true
    ResourceVm.instance.isRTL = true;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);

    // 测试RTL为false
    ResourceVm.instance.isRTL = false;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(0);
  });

  // 测试用例6：cmds为空时直接返回
  test('当cmds为空时直接返回', async () => {
    vmInjector.getCapsuleListVm.mockReturnValue({ liveList: [] });
    const mockAnimation = new AnimationBase('');
    const executeSpy = jest.spyOn(mockAnimation, 'executeAnimation');

    await expandCapsuleList();

    expect(executeSpy).not.toHaveBeenCalled();
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    capsuleTransferParam = {};
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', () => {
    const mockLive = {
      isInstant: jest.fn().mockReturnValue(true),
      isPersistent: jest.fn().mockReturnValue(false)
    };
    const mockCapsuleListVm = { liveList: [mockLive] };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedShowType: 'fixed',
      fixedWidth: 100,
      fixedOffsetX: 20,
      isShowed: false,
      setCakeShowVal: jest.fn(),
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockMarqueeVm = { updateUIProperty: jest.fn() };
    vmInjector.getCapsuleMarqueeVm.mockReturnValue(mockMarqueeVm);

    const mockLayoutVm = { capsuleListFixedWidth: 300 };
    vmInjector.getCapsuleListLayoutVm.mockReturnValue(mockLayoutVm);

    // 设置参数
    capsuleTransferParam = {
      delay: 500,
      isUpdateImmediately: false,
    };

    // 执行方法
    const cmds = setCapsuleTransferStateToFixedPos(capsuleTransferParam);

    // 验证参数
    expect(cmds.length).toBe(2); // 主动画 + 跑马灯更新
    const mainCmd = cmds[0];
    expect(mainCmd.delay).toBe(500);
    expect(mainCmd.event).toBeInstanceOf(Function);
    mainCmd.event(); // 执行事件函数

    // 验证属性设置
    expect(mockCapsuleVm.showType).toBe('fixed');
    expect(mockCapsuleVm.width).toBe(100);
    expect(mockCapsuleVm.isRemindShow).toBe(!mockCapsuleVm.isShowed);
    expect(mockCapsuleVm.setCakeShowVal).toHaveBeenCalled();

    // 验证onFinish
    mainCmd.onFinish();
    expect(mockLayoutVm.capsuleListWidth).toBe(300);

    // 验证跑马灯更新
    const marqueeCmd = cmds[1];
    expect(marqueeCmd.delay).toBe(550);
    marqueeCmd.event();
    expect(mockMarqueeVm.updateUIProperty).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时的属性设置
  test('当isShow为false时的属性设置', () => {
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    setCapsuleTransferStateToFixedPos();

    const cmd = vmInjector.getCapsuleVm().event();
    expect(mockCapsuleVm.width).toBe(0);
    expect(mockCapsuleVm.isRemindShow).toBe(false);
  });

  // 测试用例3：live类型组合覆盖
  test('live类型组合覆盖', () => {
    const cases = [
      { isInstant: true, isPersistent: true, expected: true },
      { isInstant: false, isPersistent: true, expected: true },
      { isInstant: true, isPersistent: false, expected: true },
      { isInstant: false, isPersistent: false, expected: false },
    ];

    cases.forEach(({ isInstant, isPersistent, expected }) => {
      const mockLive = {
        isInstant: jest.fn().mockReturnValue(isInstant),
        isPersistent: jest.fn().mockReturnValue(isPersistent),
      };
      const mockCapsuleVm = { isShowed: false };
      vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

      setCapsuleTransferStateToFixedPos();
      const cmd = vmInjector.getCapsuleVm().event();
      cmd();

      expect(mockCapsuleVm.isRemindShow).toBe(expected);
    });
  });

  // 测试用例4：isUpdateImmediately为true时不添加额外命令
  test('当isUpdateImmediately为true时', () => {
    capsuleTransferParam = { isUpdateImmediately: true };
    const cmds = setCapsuleTransferStateToFixedPos(capsuleTransferParam);

    expect(cmds.length).toBe(1);
    expect(cmds[0].event).toBeInstanceOf(Function);
  });

  // 测试用例5：参数缺失时使用默认值
  test('参数缺失时使用默认值', () => {
    const defaultDelay = 200; // 假设this.expandListDelayTime为200
    const cmds = setCapsuleTransferStateToFixedPos();

    expect(cmds[0].delay).toBe(defaultDelay);
  });

  // 测试用例6：多胶囊场景
  test('多胶囊场景', () => {
    const mockLives = [
      { id: '1' },
      { id: '2' },
    ];
    vmInjector.getCapsuleListVm.mockReturnValue({ liveList: mockLives });

    const cmds = setCapsuleTransferStateToFixedPos();
    expect(cmds.length).toBe(mockLives.length * 2); // 假设isUpdateImmediately为false
  });

});

describe('LiveCapsuleListWithoutHoleAnimVm2', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleAnimVm;
  let vmInjector: any;
  let SystemUICcmConfig: any;
  let ResourceVm: any;
  let AnimationBaseMock: any;

  beforeEach(() => {
    const mockLiveVmInjector = new MockLiveVmInjector();
    liveCapsuleListVm = new LiveCapsuleListWithoutHoleAnimVm(mockLiveVmInjector);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly',DEFAULT, () => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly', DEFAULT,async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly', DEFAULT,() => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleTransferState方法
  it('should set capsule transfer state correctly', DEFAULT,() => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    liveCapsuleListVm.setCapsuleTransferState(capsuleTransferParam);
  });

  // 测试setLightWaveAnim方法
  it('should set light wave animation correctly',DEFAULT, () => {
    const lightWaveVm = liveCapsuleListVm.getLightWaveVm();
    lightWaveVm.setAnimStartState(0);
    lightWaveVm.doWaveAnim(100, 20);
  });

  it('Test setCapsuleListFinalState with default parameters', 0, async () => {
    // 创建测试所需的依赖对象
    const liveNotification = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    // 创建测试对象
    const vm = new LiveCapsuleListWithoutHoleAnimVm();

    // 执行方法
    await vm.setCapsuleListFinalState(capsuleTransferParam);
  });

  it('Test collapseCapsuleList with onlyChangeOpacity true', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    await vm.collapseCapsuleList(capsuleTransferParam);
  });

  it('Test expandCapsuleList with delay', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 500,
      onlyChangeOpacity: false,
      isUpdateImmediately: false
    };

    await vm.expandCapsuleList(capsuleTransferParam);
  });

  it('Test setCapsuleTransferState with immediate update', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    vm.setCapsuleTransferState(capsuleTransferParam);
  });

  it('Test updateCapsuleWidthAndOffset', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const liveList = [new LiveNotification()];

    await vm.updateCapsuleWidthAndOffset(liveList);
  });

  it('Test collapseOtherCapsule with index 0', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    const result = vm.collapseOtherCapsule(live, 0, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandOtherCapsule with opacity change only', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    const result = vm.expandOtherCapsule(live, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandRemindCapsule with delay', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const result = vm.expandRemindCapsule(live, 500);
    expect(result.length).toBe(2);
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    SystemUICcmConfig = require('@/path/to/system-ui-ccm-config').SystemUICcmConfig;
    ResourceVm = require('@/path/to/resource-vm').ResourceVm;
    AnimationBaseMock = jest.fn().mockImplementation(() => ({
      executeAnimation: jest.fn().mockResolvedValue(undefined),
    }));
    (AnimationBase as any).mockImplementation = AnimationBaseMock;
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', async () => {
    const capsuleTransferParam = {
      delay: 200,
      onlyChangeOpacity: false,
    };

    // 模拟数据准备
    const mockLive = { id: 'test' };
    const mockCapsuleListVm = {
      liveList: [mockLive],
    };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedWidth: 150,
      isRemindShow: true,
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockLightWaveVm = {
      lightShow: true,
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn().mockReturnValue([{ type: 'wave' }]),
      doProgressWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);

    // 设置条件
    SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
    ResourceVm.instance.isRTL = true;

    // 执行方法
    await expandCapsuleList(capsuleTransferParam);

    // 验证执行路径
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);
    expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalledWith(200, -60);
    expect(mockLightWaveVm.doProgressWaveAnim).not.toHaveBeenCalled();
    expect(mockCapsuleVm.isRemindShow).toBeTruthy();
    expect(AnimationBaseMock).toHaveBeenCalledWith('CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE');
    expect(AnimationBaseMock().executeAnimation).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时跳过循环
  test('当isShow为false时跳过循环', async () => {
    const mockLive = { id: 'test' };
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    await expandCapsuleList();

    expect(vmInjector.getCapsuleLightWaveVm).not.toHaveBeenCalled();
    expect(AnimationBaseMock().executeAnimation).not.toHaveBeenCalled();
  });

  // 测试用例3：onlyChangeOpacity为true时不更新宽度
  test('当onlyChangeOpacity为true时跳过宽度更新', async () => {
    const param = { onlyChangeOpacity: true };
    const mockUpdateWidth = jest.fn().mockReturnValue([]);
    this.updateCapsuleListWidth = mockUpdateWidth; // 需要正确mock该方法

    await expandCapsuleList(param);

    expect(mockUpdateWidth).not.toHaveBeenCalled();
  });

  // 测试用例4：light条件组合覆盖
  test('light条件组合覆盖', async () => {
    const cases = [
      { lightShow: true, isRemindShow: false, expectWave: true },
      { lightShow: false, isRemindShow: true, expectWave: true },
      { lightShow: true, isRemindShow: true, expectWave: true },
      { lightShow: false, isRemindShow: false, expectWave: false },
    ];

    cases.forEach(({ lightShow, isRemindShow, expectWave }) => {
      const mockLightWaveVm = {
        lightShow,
        setAnimStartState: jest.fn(),
        doWaveAnim: jest.fn(),
        doProgressWaveAnim: jest.fn(),
      };
      vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
      const mockCapsuleVm = { isRemindShow };
      vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

      SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
      ResourceVm.instance.isRTL = true;

      expandCapsuleList().then(() => {
        if (expectWave) {
          expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalled();
        } else {
          expect(mockLightWaveVm.doWaveAnim).not.toHaveBeenCalled();
        }
      });
    });
  });

  // 测试用例5：RTL方向切换
  test('RTL方向切换测试', async () => {
    const mockLightWaveVm = {
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
    const mockCapsuleVm = { fixedWidth: 200, isRemindShow: true };

    // 测试RTL为true
    ResourceVm.instance.isRTL = true;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);

    // 测试RTL为false
    ResourceVm.instance.isRTL = false;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(0);
  });

  // 测试用例6：cmds为空时直接返回
  test('当cmds为空时直接返回', async () => {
    vmInjector.getCapsuleListVm.mockReturnValue({ liveList: [] });
    const mockAnimation = new AnimationBase('');
    const executeSpy = jest.spyOn(mockAnimation, 'executeAnimation');

    await expandCapsuleList();

    expect(executeSpy).not.toHaveBeenCalled();
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    capsuleTransferParam = {};
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', () => {
    const mockLive = {
      isInstant: jest.fn().mockReturnValue(true),
      isPersistent: jest.fn().mockReturnValue(false)
    };
    const mockCapsuleListVm = { liveList: [mockLive] };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedShowType: 'fixed',
      fixedWidth: 100,
      fixedOffsetX: 20,
      isShowed: false,
      setCakeShowVal: jest.fn(),
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockMarqueeVm = { updateUIProperty: jest.fn() };
    vmInjector.getCapsuleMarqueeVm.mockReturnValue(mockMarqueeVm);

    const mockLayoutVm = { capsuleListFixedWidth: 300 };
    vmInjector.getCapsuleListLayoutVm.mockReturnValue(mockLayoutVm);

    // 设置参数
    capsuleTransferParam = {
      delay: 500,
      isUpdateImmediately: false,
    };

    // 执行方法
    const cmds = setCapsuleTransferStateToFixedPos(capsuleTransferParam);

    // 验证参数
    expect(cmds.length).toBe(2); // 主动画 + 跑马灯更新
    const mainCmd = cmds[0];
    expect(mainCmd.delay).toBe(500);
    expect(mainCmd.event).toBeInstanceOf(Function);
    mainCmd.event(); // 执行事件函数

    // 验证属性设置
    expect(mockCapsuleVm.showType).toBe('fixed');
    expect(mockCapsuleVm.width).toBe(100);
    expect(mockCapsuleVm.isRemindShow).toBe(!mockCapsuleVm.isShowed);
    expect(mockCapsuleVm.setCakeShowVal).toHaveBeenCalled();

    // 验证onFinish
    mainCmd.onFinish();
    expect(mockLayoutVm.capsuleListWidth).toBe(300);

    // 验证跑马灯更新
    const marqueeCmd = cmds[1];
    expect(marqueeCmd.delay).toBe(550);
    marqueeCmd.event();
    expect(mockMarqueeVm.updateUIProperty).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时的属性设置
  test('当isShow为false时的属性设置', () => {
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    setCapsuleTransferStateToFixedPos();

    const cmd = vmInjector.getCapsuleVm().event();
    expect(mockCapsuleVm.width).toBe(0);
    expect(mockCapsuleVm.isRemindShow).toBe(false);
  });
});

describe('LiveCapsuleListWithoutHoleAnimVm3', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleAnimVm;
  let vmInjector: any;
  let SystemUICcmConfig: any;
  let ResourceVm: any;
  let AnimationBaseMock: any;

  beforeEach(() => {
    const mockLiveVmInjector = new MockLiveVmInjector();
    liveCapsuleListVm = new LiveCapsuleListWithoutHoleAnimVm(mockLiveVmInjector);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly',DEFAULT, () => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly', DEFAULT,async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly', DEFAULT,() => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleTransferState方法
  it('should set capsule transfer state correctly', DEFAULT,() => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    liveCapsuleListVm.setCapsuleTransferState(capsuleTransferParam);
  });

  // 测试setLightWaveAnim方法
  it('should set light wave animation correctly',DEFAULT, () => {
    const lightWaveVm = liveCapsuleListVm.getLightWaveVm();
    lightWaveVm.setAnimStartState(0);
    lightWaveVm.doWaveAnim(100, 20);
  });

  it('Test setCapsuleListFinalState with default parameters', 0, async () => {
    // 创建测试所需的依赖对象
    const liveNotification = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    // 创建测试对象
    const vm = new LiveCapsuleListWithoutHoleAnimVm();

    // 执行方法
    await vm.setCapsuleListFinalState(capsuleTransferParam);
  });

  it('Test collapseCapsuleList with onlyChangeOpacity true', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    await vm.collapseCapsuleList(capsuleTransferParam);
  });

  it('Test expandCapsuleList with delay', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 500,
      onlyChangeOpacity: false,
      isUpdateImmediately: false
    };

    await vm.expandCapsuleList(capsuleTransferParam);
  });

  it('Test setCapsuleTransferState with immediate update', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    vm.setCapsuleTransferState(capsuleTransferParam);
  });

  it('Test updateCapsuleWidthAndOffset', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const liveList = [new LiveNotification()];

    await vm.updateCapsuleWidthAndOffset(liveList);
  });

  it('Test collapseOtherCapsule with index 0', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    const result = vm.collapseOtherCapsule(live, 0, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandOtherCapsule with opacity change only', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    const result = vm.expandOtherCapsule(live, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandRemindCapsule with delay', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const result = vm.expandRemindCapsule(live, 500);
    expect(result.length).toBe(2);
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    SystemUICcmConfig = require('@/path/to/system-ui-ccm-config').SystemUICcmConfig;
    ResourceVm = require('@/path/to/resource-vm').ResourceVm;
    AnimationBaseMock = jest.fn().mockImplementation(() => ({
      executeAnimation: jest.fn().mockResolvedValue(undefined),
    }));
    (AnimationBase as any).mockImplementation = AnimationBaseMock;
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', async () => {
    const capsuleTransferParam = {
      delay: 200,
      onlyChangeOpacity: false,
    };

    // 模拟数据准备
    const mockLive = { id: 'test' };
    const mockCapsuleListVm = {
      liveList: [mockLive],
    };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedWidth: 150,
      isRemindShow: true,
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockLightWaveVm = {
      lightShow: true,
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn().mockReturnValue([{ type: 'wave' }]),
      doProgressWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);

    // 设置条件
    SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
    ResourceVm.instance.isRTL = true;

    // 执行方法
    await expandCapsuleList(capsuleTransferParam);

    // 验证执行路径
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);
    expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalledWith(200, -60);
    expect(mockLightWaveVm.doProgressWaveAnim).not.toHaveBeenCalled();
    expect(mockCapsuleVm.isRemindShow).toBeTruthy();
    expect(AnimationBaseMock).toHaveBeenCalledWith('CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE');
    expect(AnimationBaseMock().executeAnimation).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时跳过循环
  test('当isShow为false时跳过循环', async () => {
    const mockLive = { id: 'test' };
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    await expandCapsuleList();

    expect(vmInjector.getCapsuleLightWaveVm).not.toHaveBeenCalled();
    expect(AnimationBaseMock().executeAnimation).not.toHaveBeenCalled();
  });

  // 测试用例3：onlyChangeOpacity为true时不更新宽度
  test('当onlyChangeOpacity为true时跳过宽度更新', async () => {
    const param = { onlyChangeOpacity: true };
    const mockUpdateWidth = jest.fn().mockReturnValue([]);
    this.updateCapsuleListWidth = mockUpdateWidth; // 需要正确mock该方法

    await expandCapsuleList(param);

    expect(mockUpdateWidth).not.toHaveBeenCalled();
  });

  // 测试用例4：light条件组合覆盖
  test('light条件组合覆盖', async () => {
    const cases = [
      { lightShow: true, isRemindShow: false, expectWave: true },
      { lightShow: false, isRemindShow: true, expectWave: true },
      { lightShow: true, isRemindShow: true, expectWave: true },
      { lightShow: false, isRemindShow: false, expectWave: false },
    ];

    cases.forEach(({ lightShow, isRemindShow, expectWave }) => {
      const mockLightWaveVm = {
        lightShow,
        setAnimStartState: jest.fn(),
        doWaveAnim: jest.fn(),
        doProgressWaveAnim: jest.fn(),
      };
      vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
      const mockCapsuleVm = { isRemindShow };
      vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

      SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
      ResourceVm.instance.isRTL = true;

      expandCapsuleList().then(() => {
        if (expectWave) {
          expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalled();
        } else {
          expect(mockLightWaveVm.doWaveAnim).not.toHaveBeenCalled();
        }
      });
    });
  });

  // 测试用例5：RTL方向切换
  test('RTL方向切换测试', async () => {
    const mockLightWaveVm = {
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
    const mockCapsuleVm = { fixedWidth: 200, isRemindShow: true };

    // 测试RTL为true
    ResourceVm.instance.isRTL = true;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);

    // 测试RTL为false
    ResourceVm.instance.isRTL = false;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(0);
  });

  // 测试用例6：cmds为空时直接返回
  test('当cmds为空时直接返回', async () => {
    vmInjector.getCapsuleListVm.mockReturnValue({ liveList: [] });
    const mockAnimation = new AnimationBase('');
    const executeSpy = jest.spyOn(mockAnimation, 'executeAnimation');

    await expandCapsuleList();

    expect(executeSpy).not.toHaveBeenCalled();
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    capsuleTransferParam = {};
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', () => {
    const mockLive = {
      isInstant: jest.fn().mockReturnValue(true),
      isPersistent: jest.fn().mockReturnValue(false)
    };
    const mockCapsuleListVm = { liveList: [mockLive] };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedShowType: 'fixed',
      fixedWidth: 100,
      fixedOffsetX: 20,
      isShowed: false,
      setCakeShowVal: jest.fn(),
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockMarqueeVm = { updateUIProperty: jest.fn() };
    vmInjector.getCapsuleMarqueeVm.mockReturnValue(mockMarqueeVm);

    const mockLayoutVm = { capsuleListFixedWidth: 300 };
    vmInjector.getCapsuleListLayoutVm.mockReturnValue(mockLayoutVm);

    // 设置参数
    capsuleTransferParam = {
      delay: 500,
      isUpdateImmediately: false,
    };

    // 执行方法
    const cmds = setCapsuleTransferStateToFixedPos(capsuleTransferParam);

    // 验证参数
    expect(cmds.length).toBe(2); // 主动画 + 跑马灯更新
    const mainCmd = cmds[0];
    expect(mainCmd.delay).toBe(500);
    expect(mainCmd.event).toBeInstanceOf(Function);
    mainCmd.event(); // 执行事件函数

    // 验证属性设置
    expect(mockCapsuleVm.showType).toBe('fixed');
    expect(mockCapsuleVm.width).toBe(100);
    expect(mockCapsuleVm.isRemindShow).toBe(!mockCapsuleVm.isShowed);
    expect(mockCapsuleVm.setCakeShowVal).toHaveBeenCalled();

    // 验证onFinish
    mainCmd.onFinish();
    expect(mockLayoutVm.capsuleListWidth).toBe(300);

    // 验证跑马灯更新
    const marqueeCmd = cmds[1];
    expect(marqueeCmd.delay).toBe(550);
    marqueeCmd.event();
    expect(mockMarqueeVm.updateUIProperty).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时的属性设置
  test('当isShow为false时的属性设置', () => {
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    setCapsuleTransferStateToFixedPos();

    const cmd = vmInjector.getCapsuleVm().event();
    expect(mockCapsuleVm.width).toBe(0);
    expect(mockCapsuleVm.isRemindShow).toBe(false);
  });
});

describe('LiveCapsuleListWithoutHoleAnimVm4', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleAnimVm;
  let vmInjector: any;
  let SystemUICcmConfig: any;
  let ResourceVm: any;
  let AnimationBaseMock: any;

  beforeEach(() => {
    const mockLiveVmInjector = new MockLiveVmInjector();
    liveCapsuleListVm = new LiveCapsuleListWithoutHoleAnimVm(mockLiveVmInjector);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly',DEFAULT, () => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly', DEFAULT,async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly', DEFAULT,() => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleTransferState方法
  it('should set capsule transfer state correctly', DEFAULT,() => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    liveCapsuleListVm.setCapsuleTransferState(capsuleTransferParam);
  });

  // 测试setLightWaveAnim方法
  it('should set light wave animation correctly',DEFAULT, () => {
    const lightWaveVm = liveCapsuleListVm.getLightWaveVm();
    lightWaveVm.setAnimStartState(0);
    lightWaveVm.doWaveAnim(100, 20);
  });

  it('Test setCapsuleListFinalState with default parameters', 0, async () => {
    // 创建测试所需的依赖对象
    const liveNotification = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    // 创建测试对象
    const vm = new LiveCapsuleListWithoutHoleAnimVm();

    // 执行方法
    await vm.setCapsuleListFinalState(capsuleTransferParam);
  });

  it('Test collapseCapsuleList with onlyChangeOpacity true', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    await vm.collapseCapsuleList(capsuleTransferParam);
  });

  it('Test expandCapsuleList with delay', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 500,
      onlyChangeOpacity: false,
      isUpdateImmediately: false
    };

    await vm.expandCapsuleList(capsuleTransferParam);
  });

  it('Test setCapsuleTransferState with immediate update', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    vm.setCapsuleTransferState(capsuleTransferParam);
  });

  it('Test updateCapsuleWidthAndOffset', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const liveList = [new LiveNotification()];

    await vm.updateCapsuleWidthAndOffset(liveList);
  });

  it('Test collapseOtherCapsule with index 0', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    const result = vm.collapseOtherCapsule(live, 0, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandOtherCapsule with opacity change only', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    const result = vm.expandOtherCapsule(live, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandRemindCapsule with delay', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const result = vm.expandRemindCapsule(live, 500);
    expect(result.length).toBe(2);
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    SystemUICcmConfig = require('@/path/to/system-ui-ccm-config').SystemUICcmConfig;
    ResourceVm = require('@/path/to/resource-vm').ResourceVm;
    AnimationBaseMock = jest.fn().mockImplementation(() => ({
      executeAnimation: jest.fn().mockResolvedValue(undefined),
    }));
    (AnimationBase as any).mockImplementation = AnimationBaseMock;
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', async () => {
    const capsuleTransferParam = {
      delay: 200,
      onlyChangeOpacity: false,
    };

    // 模拟数据准备
    const mockLive = { id: 'test' };
    const mockCapsuleListVm = {
      liveList: [mockLive],
    };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedWidth: 150,
      isRemindShow: true,
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockLightWaveVm = {
      lightShow: true,
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn().mockReturnValue([{ type: 'wave' }]),
      doProgressWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);

    // 设置条件
    SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
    ResourceVm.instance.isRTL = true;

    // 执行方法
    await expandCapsuleList(capsuleTransferParam);

    // 验证执行路径
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);
    expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalledWith(200, -60);
    expect(mockLightWaveVm.doProgressWaveAnim).not.toHaveBeenCalled();
    expect(mockCapsuleVm.isRemindShow).toBeTruthy();
    expect(AnimationBaseMock).toHaveBeenCalledWith('CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE');
    expect(AnimationBaseMock().executeAnimation).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时跳过循环
  test('当isShow为false时跳过循环', async () => {
    const mockLive = { id: 'test' };
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    await expandCapsuleList();

    expect(vmInjector.getCapsuleLightWaveVm).not.toHaveBeenCalled();
    expect(AnimationBaseMock().executeAnimation).not.toHaveBeenCalled();
  });

  // 测试用例3：onlyChangeOpacity为true时不更新宽度
  test('当onlyChangeOpacity为true时跳过宽度更新', async () => {
    const param = { onlyChangeOpacity: true };
    const mockUpdateWidth = jest.fn().mockReturnValue([]);
    this.updateCapsuleListWidth = mockUpdateWidth; // 需要正确mock该方法

    await expandCapsuleList(param);

    expect(mockUpdateWidth).not.toHaveBeenCalled();
  });

  // 测试用例4：light条件组合覆盖
  test('light条件组合覆盖', async () => {
    const cases = [
      { lightShow: true, isRemindShow: false, expectWave: true },
      { lightShow: false, isRemindShow: true, expectWave: true },
      { lightShow: true, isRemindShow: true, expectWave: true },
      { lightShow: false, isRemindShow: false, expectWave: false },
    ];

    cases.forEach(({ lightShow, isRemindShow, expectWave }) => {
      const mockLightWaveVm = {
        lightShow,
        setAnimStartState: jest.fn(),
        doWaveAnim: jest.fn(),
        doProgressWaveAnim: jest.fn(),
      };
      vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
      const mockCapsuleVm = { isRemindShow };
      vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

      SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
      ResourceVm.instance.isRTL = true;

      expandCapsuleList().then(() => {
        if (expectWave) {
          expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalled();
        } else {
          expect(mockLightWaveVm.doWaveAnim).not.toHaveBeenCalled();
        }
      });
    });
  });

  // 测试用例5：RTL方向切换
  test('RTL方向切换测试', async () => {
    const mockLightWaveVm = {
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
    const mockCapsuleVm = { fixedWidth: 200, isRemindShow: true };

    // 测试RTL为true
    ResourceVm.instance.isRTL = true;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);

    // 测试RTL为false
    ResourceVm.instance.isRTL = false;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(0);
  });

  // 测试用例6：cmds为空时直接返回
  test('当cmds为空时直接返回', async () => {
    vmInjector.getCapsuleListVm.mockReturnValue({ liveList: [] });
    const mockAnimation = new AnimationBase('');
    const executeSpy = jest.spyOn(mockAnimation, 'executeAnimation');

    await expandCapsuleList();

    expect(executeSpy).not.toHaveBeenCalled();
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    capsuleTransferParam = {};
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', () => {
    const mockLive = {
      isInstant: jest.fn().mockReturnValue(true),
      isPersistent: jest.fn().mockReturnValue(false)
    };
    const mockCapsuleListVm = { liveList: [mockLive] };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedShowType: 'fixed',
      fixedWidth: 100,
      fixedOffsetX: 20,
      isShowed: false,
      setCakeShowVal: jest.fn(),
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockMarqueeVm = { updateUIProperty: jest.fn() };
    vmInjector.getCapsuleMarqueeVm.mockReturnValue(mockMarqueeVm);

    const mockLayoutVm = { capsuleListFixedWidth: 300 };
    vmInjector.getCapsuleListLayoutVm.mockReturnValue(mockLayoutVm);

    // 设置参数
    capsuleTransferParam = {
      delay: 500,
      isUpdateImmediately: false,
    };

    // 执行方法
    const cmds = setCapsuleTransferStateToFixedPos(capsuleTransferParam);

    // 验证参数
    expect(cmds.length).toBe(2); // 主动画 + 跑马灯更新
    const mainCmd = cmds[0];
    expect(mainCmd.delay).toBe(500);
    expect(mainCmd.event).toBeInstanceOf(Function);
    mainCmd.event(); // 执行事件函数

    // 验证属性设置
    expect(mockCapsuleVm.showType).toBe('fixed');
    expect(mockCapsuleVm.width).toBe(100);
    expect(mockCapsuleVm.isRemindShow).toBe(!mockCapsuleVm.isShowed);
    expect(mockCapsuleVm.setCakeShowVal).toHaveBeenCalled();

    // 验证onFinish
    mainCmd.onFinish();
    expect(mockLayoutVm.capsuleListWidth).toBe(300);

    // 验证跑马灯更新
    const marqueeCmd = cmds[1];
    expect(marqueeCmd.delay).toBe(550);
    marqueeCmd.event();
    expect(mockMarqueeVm.updateUIProperty).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时的属性设置
  test('当isShow为false时的属性设置', () => {
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    setCapsuleTransferStateToFixedPos();

    const cmd = vmInjector.getCapsuleVm().event();
    expect(mockCapsuleVm.width).toBe(0);
    expect(mockCapsuleVm.isRemindShow).toBe(false);
  });
});

describe('LiveCapsuleListWithoutHoleAnimVm4', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleAnimVm;
  let vmInjector: any;
  let SystemUICcmConfig: any;
  let ResourceVm: any;
  let AnimationBaseMock: any;

  beforeEach(() => {
    const mockLiveVmInjector = new MockLiveVmInjector();
    liveCapsuleListVm = new LiveCapsuleListWithoutHoleAnimVm(mockLiveVmInjector);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly',DEFAULT, () => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly', DEFAULT,async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly', DEFAULT,() => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleTransferState方法
  it('should set capsule transfer state correctly', DEFAULT,() => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    liveCapsuleListVm.setCapsuleTransferState(capsuleTransferParam);
  });

  // 测试setLightWaveAnim方法
  it('should set light wave animation correctly',DEFAULT, () => {
    const lightWaveVm = liveCapsuleListVm.getLightWaveVm();
    lightWaveVm.setAnimStartState(0);
    lightWaveVm.doWaveAnim(100, 20);
  });

  it('Test setCapsuleListFinalState with default parameters', 0, async () => {
    // 创建测试所需的依赖对象
    const liveNotification = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    // 创建测试对象
    const vm = new LiveCapsuleListWithoutHoleAnimVm();

    // 执行方法
    await vm.setCapsuleListFinalState(capsuleTransferParam);
  });

  it('Test collapseCapsuleList with onlyChangeOpacity true', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    await vm.collapseCapsuleList(capsuleTransferParam);
  });

  it('Test expandCapsuleList with delay', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 500,
      onlyChangeOpacity: false,
      isUpdateImmediately: false
    };

    await vm.expandCapsuleList(capsuleTransferParam);
  });

  it('Test setCapsuleTransferState with immediate update', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    vm.setCapsuleTransferState(capsuleTransferParam);
  });

  it('Test updateCapsuleWidthAndOffset', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const liveList = [new LiveNotification()];

    await vm.updateCapsuleWidthAndOffset(liveList);
  });

  it('Test collapseOtherCapsule with index 0', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    const result = vm.collapseOtherCapsule(live, 0, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandOtherCapsule with opacity change only', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    const result = vm.expandOtherCapsule(live, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandRemindCapsule with delay', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const result = vm.expandRemindCapsule(live, 500);
    expect(result.length).toBe(2);
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    SystemUICcmConfig = require('@/path/to/system-ui-ccm-config').SystemUICcmConfig;
    ResourceVm = require('@/path/to/resource-vm').ResourceVm;
    AnimationBaseMock = jest.fn().mockImplementation(() => ({
      executeAnimation: jest.fn().mockResolvedValue(undefined),
    }));
    (AnimationBase as any).mockImplementation = AnimationBaseMock;
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', async () => {
    const capsuleTransferParam = {
      delay: 200,
      onlyChangeOpacity: false,
    };

    // 模拟数据准备
    const mockLive = { id: 'test' };
    const mockCapsuleListVm = {
      liveList: [mockLive],
    };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedWidth: 150,
      isRemindShow: true,
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockLightWaveVm = {
      lightShow: true,
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn().mockReturnValue([{ type: 'wave' }]),
      doProgressWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);

    // 设置条件
    SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
    ResourceVm.instance.isRTL = true;

    // 执行方法
    await expandCapsuleList(capsuleTransferParam);

    // 验证执行路径
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);
    expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalledWith(200, -60);
    expect(mockLightWaveVm.doProgressWaveAnim).not.toHaveBeenCalled();
    expect(mockCapsuleVm.isRemindShow).toBeTruthy();
    expect(AnimationBaseMock).toHaveBeenCalledWith('CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE');
    expect(AnimationBaseMock().executeAnimation).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时跳过循环
  test('当isShow为false时跳过循环', async () => {
    const mockLive = { id: 'test' };
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    await expandCapsuleList();

    expect(vmInjector.getCapsuleLightWaveVm).not.toHaveBeenCalled();
    expect(AnimationBaseMock().executeAnimation).not.toHaveBeenCalled();
  });

  // 测试用例3：onlyChangeOpacity为true时不更新宽度
  test('当onlyChangeOpacity为true时跳过宽度更新', async () => {
    const param = { onlyChangeOpacity: true };
    const mockUpdateWidth = jest.fn().mockReturnValue([]);
    this.updateCapsuleListWidth = mockUpdateWidth; // 需要正确mock该方法

    await expandCapsuleList(param);

    expect(mockUpdateWidth).not.toHaveBeenCalled();
  });

  // 测试用例4：light条件组合覆盖
  test('light条件组合覆盖', async () => {
    const cases = [
      { lightShow: true, isRemindShow: false, expectWave: true },
      { lightShow: false, isRemindShow: true, expectWave: true },
      { lightShow: true, isRemindShow: true, expectWave: true },
      { lightShow: false, isRemindShow: false, expectWave: false },
    ];

    cases.forEach(({ lightShow, isRemindShow, expectWave }) => {
      const mockLightWaveVm = {
        lightShow,
        setAnimStartState: jest.fn(),
        doWaveAnim: jest.fn(),
        doProgressWaveAnim: jest.fn(),
      };
      vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
      const mockCapsuleVm = { isRemindShow };
      vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

      SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
      ResourceVm.instance.isRTL = true;

      expandCapsuleList().then(() => {
        if (expectWave) {
          expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalled();
        } else {
          expect(mockLightWaveVm.doWaveAnim).not.toHaveBeenCalled();
        }
      });
    });
  });

  // 测试用例5：RTL方向切换
  test('RTL方向切换测试', async () => {
    const mockLightWaveVm = {
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
    const mockCapsuleVm = { fixedWidth: 200, isRemindShow: true };

    // 测试RTL为true
    ResourceVm.instance.isRTL = true;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);

    // 测试RTL为false
    ResourceVm.instance.isRTL = false;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(0);
  });

  // 测试用例6：cmds为空时直接返回
  test('当cmds为空时直接返回', async () => {
    vmInjector.getCapsuleListVm.mockReturnValue({ liveList: [] });
    const mockAnimation = new AnimationBase('');
    const executeSpy = jest.spyOn(mockAnimation, 'executeAnimation');

    await expandCapsuleList();

    expect(executeSpy).not.toHaveBeenCalled();
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    capsuleTransferParam = {};
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', () => {
    const mockLive = {
      isInstant: jest.fn().mockReturnValue(true),
      isPersistent: jest.fn().mockReturnValue(false)
    };
    const mockCapsuleListVm = { liveList: [mockLive] };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedShowType: 'fixed',
      fixedWidth: 100,
      fixedOffsetX: 20,
      isShowed: false,
      setCakeShowVal: jest.fn(),
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockMarqueeVm = { updateUIProperty: jest.fn() };
    vmInjector.getCapsuleMarqueeVm.mockReturnValue(mockMarqueeVm);

    const mockLayoutVm = { capsuleListFixedWidth: 300 };
    vmInjector.getCapsuleListLayoutVm.mockReturnValue(mockLayoutVm);

    // 设置参数
    capsuleTransferParam = {
      delay: 500,
      isUpdateImmediately: false,
    };

    // 执行方法
    const cmds = setCapsuleTransferStateToFixedPos(capsuleTransferParam);

    // 验证参数
    expect(cmds.length).toBe(2); // 主动画 + 跑马灯更新
    const mainCmd = cmds[0];
    expect(mainCmd.delay).toBe(500);
    expect(mainCmd.event).toBeInstanceOf(Function);
    mainCmd.event(); // 执行事件函数

    // 验证属性设置
    expect(mockCapsuleVm.showType).toBe('fixed');
    expect(mockCapsuleVm.width).toBe(100);
    expect(mockCapsuleVm.isRemindShow).toBe(!mockCapsuleVm.isShowed);
    expect(mockCapsuleVm.setCakeShowVal).toHaveBeenCalled();

    // 验证onFinish
    mainCmd.onFinish();
    expect(mockLayoutVm.capsuleListWidth).toBe(300);

    // 验证跑马灯更新
    const marqueeCmd = cmds[1];
    expect(marqueeCmd.delay).toBe(550);
    marqueeCmd.event();
    expect(mockMarqueeVm.updateUIProperty).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时的属性设置
  test('当isShow为false时的属性设置', () => {
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    setCapsuleTransferStateToFixedPos();

    const cmd = vmInjector.getCapsuleVm().event();
    expect(mockCapsuleVm.width).toBe(0);
    expect(mockCapsuleVm.isRemindShow).toBe(false);
  });
});

describe('LiveCapsuleListWithoutHoleAnimVm5', () => {
  let liveCapsuleListVm: LiveCapsuleListWithoutHoleAnimVm;
  let vmInjector: any;
  let SystemUICcmConfig: any;
  let ResourceVm: any;
  let AnimationBaseMock: any;

  beforeEach(() => {
    const mockLiveVmInjector = new MockLiveVmInjector();
    liveCapsuleListVm = new LiveCapsuleListWithoutHoleAnimVm(mockLiveVmInjector);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly',DEFAULT, () => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleListFinalState方法
  it('should set capsule list to final state correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.setCapsuleListFinalState(capsuleTransferParam);
  });

  // 测试collapseCapsuleList方法
  it('should collapse capsule list correctly', DEFAULT,async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: true,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.collapseCapsuleList(capsuleTransferParam);
  });

  // 测试expandCapsuleList方法
  it('should expand capsule list correctly',DEFAULT, async () => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    await liveCapsuleListVm.expandCapsuleList(capsuleTransferParam);
    expect(liveCapsuleListVm.baseGap).assertEqual(4);
  });

  // 测试updateFixedWidth方法
  it('should update fixed width correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedWidth();
  });

  // 测试updateFixedOffset方法
  it('should update fixed offset correctly',DEFAULT, () => {
    liveCapsuleListVm.updateFixedOffset();
  });

  // 测试setRemindCapsuleWidth方法
  it('should set remind capsule width correctly',DEFAULT, () => {
    const live: LiveNotification = { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false };
    liveCapsuleListVm.setRemindCapsuleWidth(live, true);
  });

  // 测试filterShowCapsuleList方法
  it('should filter show capsule list correctly', DEFAULT,() => {
    const liveList: LiveNotification[] = [
      { isInstant: false, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: true, isPersistent: false, isFlip: false, isScreenRecorder: false },
      { isInstant: false, isPersistent: true, isFlip: false, isScreenRecorder: false },
    ];
    liveCapsuleListVm.filterShowCapsuleList(liveList);
  });

  // 测试setCapsuleTransferState方法
  it('should set capsule transfer state correctly', DEFAULT,() => {
    const capsuleTransferParam: CapsuleTransferParam = {
      onlyChangeOpacity: false,
      delay: 100,
      isUpdateImmediately: true,
    };
    liveCapsuleListVm.setCapsuleTransferState(capsuleTransferParam);
  });

  // 测试setLightWaveAnim方法
  it('should set light wave animation correctly',DEFAULT, () => {
    const lightWaveVm = liveCapsuleListVm.getLightWaveVm();
    lightWaveVm.setAnimStartState(0);
    lightWaveVm.doWaveAnim(100, 20);
  });

  it('Test setCapsuleListFinalState with default parameters', 0, async () => {
    // 创建测试所需的依赖对象
    const liveNotification = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    // 创建测试对象
    const vm = new LiveCapsuleListWithoutHoleAnimVm();

    // 执行方法
    await vm.setCapsuleListFinalState(capsuleTransferParam);
  });

  it('Test collapseCapsuleList with onlyChangeOpacity true', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    await vm.collapseCapsuleList(capsuleTransferParam);
  });

  it('Test expandCapsuleList with delay', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 500,
      onlyChangeOpacity: false,
      isUpdateImmediately: false
    };

    await vm.expandCapsuleList(capsuleTransferParam);
  });

  it('Test setCapsuleTransferState with immediate update', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    vm.setCapsuleTransferState(capsuleTransferParam);
  });

  it('Test updateCapsuleWidthAndOffset', 0, async () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const liveList = [new LiveNotification()];

    await vm.updateCapsuleWidthAndOffset(liveList);
  });

  it('Test collapseOtherCapsule with index 0', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: false,
      isUpdateImmediately: true
    };

    const result = vm.collapseOtherCapsule(live, 0, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandOtherCapsule with opacity change only', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const capsuleTransferParam: CapsuleTransferParam = {
      delay: 0,
      onlyChangeOpacity: true,
      isUpdateImmediately: true
    };

    const result = vm.expandOtherCapsule(live, capsuleTransferParam);
    expect(result.length).toBe(1);
  });

  it('Test expandRemindCapsule with delay', 0, () => {
    const vm = new LiveCapsuleListWithoutHoleAnimVm();
    const live = new LiveNotification();
    const result = vm.expandRemindCapsule(live, 500);
    expect(result.length).toBe(2);
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    SystemUICcmConfig = require('@/path/to/system-ui-ccm-config').SystemUICcmConfig;
    ResourceVm = require('@/path/to/resource-vm').ResourceVm;
    AnimationBaseMock = jest.fn().mockImplementation(() => ({
      executeAnimation: jest.fn().mockResolvedValue(undefined),
    }));
    (AnimationBase as any).mockImplementation = AnimationBaseMock;
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', async () => {
    const capsuleTransferParam = {
      delay: 200,
      onlyChangeOpacity: false,
    };

    // 模拟数据准备
    const mockLive = { id: 'test' };
    const mockCapsuleListVm = {
      liveList: [mockLive],
    };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedWidth: 150,
      isRemindShow: true,
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockLightWaveVm = {
      lightShow: true,
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn().mockReturnValue([{ type: 'wave' }]),
      doProgressWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);

    // 设置条件
    SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
    ResourceVm.instance.isRTL = true;

    // 执行方法
    await expandCapsuleList(capsuleTransferParam);

    // 验证执行路径
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);
    expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalledWith(200, -60);
    expect(mockLightWaveVm.doProgressWaveAnim).not.toHaveBeenCalled();
    expect(mockCapsuleVm.isRemindShow).toBeTruthy();
    expect(AnimationBaseMock).toHaveBeenCalledWith('CAPSULE_LIST_EXPAND_ANIMATION_WITHOUT_HOLE');
    expect(AnimationBaseMock().executeAnimation).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时跳过循环
  test('当isShow为false时跳过循环', async () => {
    const mockLive = { id: 'test' };
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    await expandCapsuleList();

    expect(vmInjector.getCapsuleLightWaveVm).not.toHaveBeenCalled();
    expect(AnimationBaseMock().executeAnimation).not.toHaveBeenCalled();
  });

  // 测试用例3：onlyChangeOpacity为true时不更新宽度
  test('当onlyChangeOpacity为true时跳过宽度更新', async () => {
    const param = { onlyChangeOpacity: true };
    const mockUpdateWidth = jest.fn().mockReturnValue([]);
    this.updateCapsuleListWidth = mockUpdateWidth; // 需要正确mock该方法

    await expandCapsuleList(param);

    expect(mockUpdateWidth).not.toHaveBeenCalled();
  });

  // 测试用例4：light条件组合覆盖
  test('light条件组合覆盖', async () => {
    const cases = [
      { lightShow: true, isRemindShow: false, expectWave: true },
      { lightShow: false, isRemindShow: true, expectWave: true },
      { lightShow: true, isRemindShow: true, expectWave: true },
      { lightShow: false, isRemindShow: false, expectWave: false },
    ];

    cases.forEach(({ lightShow, isRemindShow, expectWave }) => {
      const mockLightWaveVm = {
        lightShow,
        setAnimStartState: jest.fn(),
        doWaveAnim: jest.fn(),
        doProgressWaveAnim: jest.fn(),
      };
      vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
      const mockCapsuleVm = { isRemindShow };
      vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

      SystemUICcmConfig.instance.liveConfig.isShowLightWhenExpandCapsule.mockReturnValue(true);
      ResourceVm.instance.isRTL = true;

      expandCapsuleList().then(() => {
        if (expectWave) {
          expect(mockLightWaveVm.doWaveAnim).toHaveBeenCalled();
        } else {
          expect(mockLightWaveVm.doWaveAnim).not.toHaveBeenCalled();
        }
      });
    });
  });

  // 测试用例5：RTL方向切换
  test('RTL方向切换测试', async () => {
    const mockLightWaveVm = {
      setAnimStartState: jest.fn(),
      doWaveAnim: jest.fn(),
    };
    vmInjector.getCapsuleLightWaveVm.mockReturnValue(mockLightWaveVm);
    const mockCapsuleVm = { fixedWidth: 200, isRemindShow: true };

    // 测试RTL为true
    ResourceVm.instance.isRTL = true;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(mockCapsuleVm.fixedWidth);

    // 测试RTL为false
    ResourceVm.instance.isRTL = false;
    await expandCapsuleList();
    expect(mockLightWaveVm.setAnimStartState).toHaveBeenCalledWith(0);
  });

  // 测试用例6：cmds为空时直接返回
  test('当cmds为空时直接返回', async () => {
    vmInjector.getCapsuleListVm.mockReturnValue({ liveList: [] });
    const mockAnimation = new AnimationBase('');
    const executeSpy = jest.spyOn(mockAnimation, 'executeAnimation');

    await expandCapsuleList();

    expect(executeSpy).not.toHaveBeenCalled();
  });

  beforeEach(() => {
    vmInjector = require('@/path/to/your-vm-injector').vmInjector;
    capsuleTransferParam = {};
  });

  // 测试用例1：完整条件组合覆盖
  test('条件组合覆盖测试', () => {
    const mockLive = {
      isInstant: jest.fn().mockReturnValue(true),
      isPersistent: jest.fn().mockReturnValue(false)
    };
    const mockCapsuleListVm = { liveList: [mockLive] };
    vmInjector.getCapsuleListVm.mockReturnValue(mockCapsuleListVm);

    const mockCapsuleVm = {
      isShow: true,
      fixedShowType: 'fixed',
      fixedWidth: 100,
      fixedOffsetX: 20,
      isShowed: false,
      setCakeShowVal: jest.fn(),
    };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    const mockMarqueeVm = { updateUIProperty: jest.fn() };
    vmInjector.getCapsuleMarqueeVm.mockReturnValue(mockMarqueeVm);

    const mockLayoutVm = { capsuleListFixedWidth: 300 };
    vmInjector.getCapsuleListLayoutVm.mockReturnValue(mockLayoutVm);

    // 设置参数
    capsuleTransferParam = {
      delay: 500,
      isUpdateImmediately: false,
    };

    // 执行方法
    const cmds = setCapsuleTransferStateToFixedPos(capsuleTransferParam);

    // 验证参数
    expect(cmds.length).toBe(2); // 主动画 + 跑马灯更新
    const mainCmd = cmds[0];
    expect(mainCmd.delay).toBe(500);
    expect(mainCmd.event).toBeInstanceOf(Function);
    mainCmd.event(); // 执行事件函数

    // 验证属性设置
    expect(mockCapsuleVm.showType).toBe('fixed');
    expect(mockCapsuleVm.width).toBe(100);
    expect(mockCapsuleVm.isRemindShow).toBe(!mockCapsuleVm.isShowed);
    expect(mockCapsuleVm.setCakeShowVal).toHaveBeenCalled();

    // 验证onFinish
    mainCmd.onFinish();
    expect(mockLayoutVm.capsuleListWidth).toBe(300);

    // 验证跑马灯更新
    const marqueeCmd = cmds[1];
    expect(marqueeCmd.delay).toBe(550);
    marqueeCmd.event();
    expect(mockMarqueeVm.updateUIProperty).toHaveBeenCalled();
  });

  // 测试用例2：isShow为false时的属性设置
  test('当isShow为false时的属性设置', () => {
    const mockCapsuleVm = { isShow: false };
    vmInjector.getCapsuleVm.mockReturnValue(mockCapsuleVm);

    setCapsuleTransferStateToFixedPos();

    const cmd = vmInjector.getCapsuleVm().event();
    expect(mockCapsuleVm.width).toBe(0);
    expect(mockCapsuleVm.isRemindShow).toBe(false);
  });
});