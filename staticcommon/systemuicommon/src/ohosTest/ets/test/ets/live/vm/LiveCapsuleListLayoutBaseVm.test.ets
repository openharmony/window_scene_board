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
import { describe, it, beforeEach, afterEach, expect } from 'mocha';
import { LiveBaseVm } from './LiveBaseVm';
import { LiveCapsuleModel } from '../model/LiveCapsuleModel';
import { SystemUICommonUtil } from '../../TsIndex';
import { mock } from 'mockit';
import { CutoutVm, DeviceInfoVm, LiveVmInjector } from '../../../../../../../newIndex';
import { ILiveCapsuleVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleVm';
import { LiveCapsuleMarqueeVm } from '../../../../../../main/ets/live/vm/LiveCapsuleMarqueeVm';
import { LiveCapsuleVm } from '../../../../../../main/ets/live/vm/LiveCapsuleVm';
import { LiveCapsuleListLayoutBaseVm } from '../../../../../../main/ets/live/vm/LiveCapsuleListLayoutBaseVm';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BaseVmInjector } from '../../../../../../main/ets/vm/BaseVmInjector';
import { CapsuleShowType } from '../../../../../../main/ets/liveview/common/LiveConstants';

const TAG = 'LiveCapsuleListLayoutBaseVmTest';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export default function LiveCapsuleListLayoutBaseVmTest() {
  describe('LiveCapsuleListLayoutBaseVmTest', () => {
    // 不在 describe 中定义变量，所有变量在 it 方法内部定义

    // 测试获取最小宽度
    it('should get minimum width correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.TOP
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    // 测试 HANGING_HOLE 类型，无扩展文本
    it('should return CAPSULE_WIDTH for HANGING_HOLE without extend text', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.HANGING_HOLE
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      // 模拟 isExistExtendText 返回 false
      vm.isExistTextContent = () => false;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    // 测试 HANGING_HOLE 类型，有扩展文本且 minWidthWithExtendTextWidth 大于 CAPSULE_WIDTH
    it('should return CAPSULE_WIDTH for HANGING_HOLE with extend text and larger width', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.HANGING_HOLE
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      // 模拟 isExistExtendText 返回 true
      vm.isExistTextContent = () => true;

      // 模拟 getHangingHoleCapsuleRealWidth 返回一个大于 CAPSULE_WIDTH 的值
      vm.getHangingHoleCapsuleRealWidth = () => LiveStyle.CAPSULE_WIDTH + 1;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.CAPSULE_WIDTH);
    });

    // 测试 HANGING_HOLE 类型，有扩展文本且 minWidthWithExtendTextWidth 小于 CAPSULE_WIDTH
    it('should return minWidthWithExtendTextWidth for HANGING_HOLE with extend text and smaller width', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.HANGING_HOLE
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      // 模拟 isExistExtendText 返回 true
      vm.isExistTextContent = () => true;

      // 模拟 getHangingHoleCapsuleRealWidth 返回一个小于 CAPSULE_WIDTH 的值
      vm.getHangingHoleCapsuleRealWidth = () => LiveStyle.CAPSULE_WIDTH - 1;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.CAPSULE_WIDTH - 1);
    });

    // 测试 RIGHT_HOLE 类型
    it('should return CAPSULE_CIRCLE_WIDTH for RIGHT_HOLE', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.RIGHT_HOLE
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
    });

    // 测试 ROUND_CAKE 类型
    it('should return CAPSULE_CIRCLE_WIDTH for ROUND_CAKE', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.ROUND_CAKE
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
    });

    // 测试 RETRACTABLE_ROUND_CAKE 类型
    it('should return CAPSULE_CIRCLE_WIDTH for RETRACTABLE_ROUND_CAKE', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.RETRACTABLE_ROUND_CAKE
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.CAPSULE_CIRCLE_WIDTH);
    });

    // 测试 SHADOW 类型
    it('should return SHADOW_CAPSULE_SHOW_WIDTH for SHADOW', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.SHADOW
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
    });

    // 测试默认情况
    it('should return 0 for unknown fixedShowType', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: 999 // 假设 999 是一个未定义的值
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const minWidth = vm.getMinWidth(liveNotification);
      expect(minWidth).assertEqual(0);
    });

    // 测试调整固定宽度
    it('should adjust fixed width correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.TOP,
        fixedWidth: 100
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const increasedUseSpace = vm.adjustFixedWidth(10, liveNotification, true);
      expect(increasedUseSpace).assertEqua(0);
    });

    // 测试获取文本
    it('should get text correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      const text = vm.getText(liveNotification, true);
      expect(text).assertEqua('Extend');
    });

    // 测试是否显示扩展文本
    it('should determine extend show correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      // 测试 capsule 不存在的情况
      it('should return empty string when capsule is null', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: null
        });

        const text = vm.getText(liveNotification);
        expect(text).toBe('');
      });

      // 测试 capsule 是文本类型，isExtend 为 false
      it('should return title for text capsule with isExtend false', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isText: () => true,
            title: 'Test Title'
          })
        });

        const text = vm.getText(liveNotification);
        expect(text).toBe('Test Title');
      });

      // 测试 capsule 是文本类型，isExtend 为 true 且 isContentDisplayed 为 true
      it('should return content for text capsule with isExtend true and isContentDisplayed true', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isText: () => true,
            isContentDisplayed: true,
            content: 'Test Content'
          })
        });

        const text = vm.getText(liveNotification, true);
        expect(text).toBe('Test Content');
      });

      // 测试 capsule 是文本类型，isExtend 为 true 且 isContentDisplayed 为 false
      it('should return empty string for text capsule with isExtend true and isContentDisplayed false', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isText: () => true,
            isContentDisplayed: false
          })
        });

        const text = vm.getText(liveNotification, true);
        expect(text).toBe('');
      });

      // 测试 capsule 是进度类型，isExtend 为 false 且 live.isCharge() 为 false
      it('should return progress text for progress capsule with isExtend false and isCharge false', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isProgress: () => true,
            progress: 50
          }),
          isCharge: () => false
        });

        const text = vm.getText(liveNotification);
        expect(text).toBe(LiveCapsuleMarqueeVm.getProgressText(50));
      });

      // 测试 capsule 是进度类型，isExtend 为 true
      it('should return empty string for progress capsule with isExtend true', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isProgress: () => true
          })
        });

        const text = vm.getText(liveNotification, true);
        expect(text).toBe('');
      });

      // 测试 capsule 是进度类型，isExtend 为 false 且 live.isCharge() 为 true
      it('should return title for progress capsule with isExtend false and isCharge true', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isProgress: () => true,
            title: 'Charge Progress'
          }),
          isCharge: () => true
        });

        const text = vm.getText(liveNotification);
        expect(text).toBe('Charge Progress');
      });

      // 测试 capsule 是计时器类型，isExtend 为 false
      it('should return timer text for timer capsule with isExtend false', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isTimer: () => true,
            timer: 1000
          })
        });

        const text = vm.getText(liveNotification);
        expect(text).toBe('1000ms');
      });

      // 测试 capsule 是计时器类型，isExtend 为 true 且 isContentDisplayed 为 true
      it('should return content for timer capsule with isExtend true and isContentDisplayed true', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isTimer: () => true,
            isContentDisplayed: true,
            content: 'Timer Content'
          })
        });

        const text = vm.getText(liveNotification, true);
        expect(text).toBe('Timer Content');
      });

      // 测试 capsule 是计时器类型，isExtend 为 true 且 isContentDisplayed 为 false
      it('should return empty string for timer capsule with isExtend true and isContentDisplayed false', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isTimer: () => true,
            isContentDisplayed: false
          })
        });

        const text = vm.getText(liveNotification, true);
        expect(text).toBe('');
      });

      // 测试 capsule 是其他类型
      it('should return empty string for unknown capsule type', 0, () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        const liveNotification = mock(LiveNotification, {
          capsule: mock({
            isText: () => false,
            isProgress: () => false,
            isTimer: () => false
          })
        });

        const text = vm.getText(liveNotification);
        expect(text).toBe('');
      });

      const isExtendShow = vm.isExtendShow(liveNotification);
      expect(isExtendShow).assertEqua(true);
    });

    // 测试获取期望宽度
    it('should get expected width correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.TOP
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const expectWidth = vm.getExpectWidth(liveNotification, true);
      expect(expectWidth).assertEqua(LiveStyle.CAPSULE_EXTEND_WIDTH);
    });

    // 测试 fixedShowType 为 SHADOW 的情况
    it('should return SHADOW_CAPSULE_SHOW_WIDTH when fixedShowType is SHADOW', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification);

      const width = vm.getExpectWidth(liveNotification);
      expect(width).toBe(LiveStyle.SHADOW_CAPSULE_SHOW_WIDTH);
    });

    // 测试 fixedShowType 为 RETRACTABLE_ROUND_CAKE 的情况
    it('should return CAPSULE_WIDTH when fixedShowType is RETRACTABLE_ROUND_CAKE', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      vm.capsuleVm.fixedShowType = CapsuleShowType.RETRACTABLE_ROUND_CAKE;

      const liveNotification = mock(LiveNotification);

      const width = vm.getExpectWidth(liveNotification);
      expect(width).toBe(LiveStyle.CAPSULE_WIDTH);
    });

    // 测试 fixedShowType 为 HANGING_HOLE，isShowForExtend 为 false 的情况
    it('should return CAPSULE_WIDTH when fixedShowType is HANGING_HOLE and isShowForExtend is false', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      vm.capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE;

      const liveNotification = mock(LiveNotification);

      const width = vm.getExpectWidth(liveNotification);
      expect(width).toBe(LiveStyle.CAPSULE_WIDTH);
    });

    // 测试 fixedShowType 为 HANGING_HOLE，isShowForExtend 为 false 且 realCapsuleWidth 为 200 的情况
    it('should return 200 when fixedShowType is HANGING_HOLE, isShowForExtend is false and realCapsuleWidth is 200', 0,
      () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        vm.capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE;

        const liveNotification = mock(LiveNotification);

        const width = vm.getExpectWidth(liveNotification, false, 200);
        expect(width).toBe(200);
      });

    // 测试 fixedShowType 为 HANGING_HOLE，isShowForExtend 为 true 的情况
    it('should return getHangingHoleCapsuleRealWidth when fixedShowType is HANGING_HOLE and isShowForExtend is true', 0,
      () => {
        let cutoutVm: CutoutVm = CutoutVm.instance;
        let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
        let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
        let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
        const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
        vm.capsuleVm.fixedShowType = CapsuleShowType.HANGING_HOLE;

        const liveNotification = mock(LiveNotification);

        const width = vm.getExpectWidth(liveNotification, true);
        expect(width).toBe(300);
      });

    // 测试 fixedShowType 为其他类型的情况
    it('should return CAPSULE_WIDTH when fixedShowType is other', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      vm.capsuleVm.fixedShowType = CapsuleShowType.OTHER;

      const liveNotification = mock(LiveNotification);

      const width = vm.getExpectWidth(liveNotification);
      expect(width).toBe(LiveStyle.CAPSULE_WIDTH);
    });

    // 测试 fixedShowType 为其他类型，isShowForExtend 为 true 的情况
    it('should return CAPSULE_EXTEND_WIDTH when fixedShowType is other and isShowForExtend is true', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      vm.capsuleVm.fixedShowType = CapsuleShowType.OTHER;

      const liveNotification = mock(LiveNotification);

      const width = vm.getExpectWidth(liveNotification, true);
      expect(width).toBe(LiveStyle.CAPSULE_EXTEND_WIDTH);
    });

    // 测试 realCapsuleWidth 小于 capsuleMinWidth 的情况
    it('should return capsuleMinWidth when realCapsuleWidth is less than capsuleMinWidth', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(100, 150, 200);
      expect(result).toBe(150);
    });

    // 测试 realCapsuleWidth 大于 capsuleMaxWidth 的情况
    it('should return capsuleMaxWidth when realCapsuleWidth is greater than capsuleMaxWidth', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(250, 150, 200);
      expect(result).toBe(200);
    });

    // 测试 realCapsuleWidth 在 capsuleMinWidth 和 capsuleMaxWidth 之间的情况
    it('should return realCapsuleWidth when it is between capsuleMinWidth and capsuleMaxWidth', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(180, 150, 200);
      expect(result).toBe(180);
    });

    // 测试 realCapsuleWidth 等于 capsuleMinWidth 的情况
    it('should return capsuleMinWidth when realCapsuleWidth equals capsuleMinWidth', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(150, 150, 200);
      expect(result).toBe(150);
    });

    // 测试 realCapsuleWidth 等于 capsuleMaxWidth 的情况
    it('should return capsuleMaxWidth when realCapsuleWidth equals capsuleMaxWidth', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(200, 150, 200);
      expect(result).toBe(200);
    });

    // 测试 capsuleMinWidth 等于 capsuleMaxWidth 的情况
    it('should return realCapsuleWidth when capsuleMinWidth equals capsuleMaxWidth', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(150, 150, 150);
      expect(result).toBe(150);
    });

    // 测试 capsuleMinWidth 大于 capsuleMaxWidth 的情况
    it('should return realCapsuleWidth when capsuleMinWidth is greater than capsuleMaxWidth', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(180, 200, 150);
      expect(result).toBe(180);
    });

    // 测试所有参数都为0的情况
    it('should return 0 when all parameters are 0', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(0, 0, 0);
      expect(result).toBe(0);
    });

    // 测试负数情况
    it('should handle negative values correctly', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(-100, -200, -50);
      expect(result).toBe(-100);
    });

    // 测试极端值情况
    it('should handle extreme values correctly', () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const result = vm.getExpectWidthByLimit(Number.MAX_SAFE_INTEGER, 1, Number.MAX_SAFE_INTEGER);
      expect(result).toBe(Number.MAX_SAFE_INTEGER);
    });

    // 测试计算增加的使用空间
    it('should calculate increased use space correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.TOP,
        fixedWidth: 100
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const increasedUseSpace = vm.calculateIncreasedUseSpace(150, 100, 10, liveNotification, true);
      expect(increasedUseSpace).assertEqua(50);
    });

    // 测试计算文本宽度和大小
    it('should calculate text width and size correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.TOP,
        fixedWidth: 200
      });

      const capsuleMarqueeVm = mock(LiveCapsuleMarqueeVm, {
        fixedTextWidth: 0,
        fixedExtendTextWidth: 0,
        fixedTextSize: LiveStyle.CAPSULE_FONT_SIZE
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;
      vm.vmInjector.getCapsuleMarqueeVm = () => capsuleMarqueeVm;

      vm.calculateTextWidthAndSize(liveNotification, 'Test', 'Extend', 100, 50);
      expect(capsuleMarqueeVm.fixedTextWidth).assertEqual(100);
      expect(capsuleMarqueeVm.fixedExtendTextWidth).assertEqua(50);
      expect(capsuleMarqueeVm.fixedTextSize).assertEqua(LiveStyle.CAPSULE_FONT_SIZE);
    });

    // 测试获取胶囊除去文本显示外其他元素宽度之和
    it('should get capsule marquee without text width correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const liveNotification = mock(LiveNotification, {
        isInstant: () => false,
        isPersistent: () => false,
        capsule: {
          isText: () => true,
          title: 'Test',
          content: 'Extend'
        }
      });

      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedShowType: CapsuleShowType.TOP
      });

      vm.vmInjector.getCapsuleVm = () => capsuleVm;

      const width = vm.getCapsuleMarqueeWithoutTextWidth(liveNotification);
      expect(width).assertEqual(vm.capsuleNonTextWidthWithoutExtend);
    });

    // 测试是否仅显示圆形
    it('should determine only show circle correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const capsuleVm = mock(ILiveCapsuleVm, {
        fixedWidth: LiveStyle.CAPSULE_CIRCLE_WIDTH,
        button: true
      });

      vm.isOnlyShowCirCle(capsuleVm);
      expect(capsuleVm.showCircle).assertEqual(true);
    });

    // 测试计算文本大小
    it('should compute text size correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const textSize = vm.computeTextSize(100, 'Test');
      expect(textSize).toBeLessThanOrEqual(LiveStyle.CAPSULE_FONT_SIZE);
      expect(textSize).toBeGreaterThanOrEqual(LiveStyle.CAPSULE_FONT_MIN_SIZE);
    });

    // 测试获取文本宽度
    it('should get text width correctly', 0, () => {
      let cutoutVm: CutoutVm = CutoutVm.instance;
      let deviceInfoVm: DeviceInfoVm = DeviceInfoVm.instance;
      let capsuleVm: LiveCapsuleVm = mock(LiveCapsuleVm);
      let capsuleMarqueeVm: LiveCapsuleMarqueeVm = mock(LiveCapsuleMarqueeVm);
      const vm = new LiveCapsuleListLayoutBaseVm(new LiveVmInjector());
      const textWidth = vm.getTextWidthBySize(LiveStyle.CAPSULE_FONT_SIZE, 'Test');
      expect(textWidth).toBeGreaterThan(0);
    });
  });
}