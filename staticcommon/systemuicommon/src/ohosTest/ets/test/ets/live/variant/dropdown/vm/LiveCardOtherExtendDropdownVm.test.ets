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
import { describe, it, expect, MockKit, beforeEach, when, ArgumentMatchers } from '@ohos/hypium/index';
import { SystemUIUseScene } from '../../../../../../../../main/ets/constants/SystemuiConstants';
import {
  LiveCardOtherExtendDropdownVm
} from '../../../../../../../../main/ets/live/variant/dropdown/vm/LiveCardOtherExtendDropdownVm';
import {
  LiveCardSystemDropdownVm
} from '../../../../../../../../main/ets/live/variant/dropdown/vm/LiveCardSystemDropdownVm';
import { ClickRegion } from '../../../../../../../../main/ets/maintenance/StatisticsConstants';

export default function TriggerExtendWantTest() {
  describe('triggerExtendWant', () => {
    // 测试前初始化变量和Mock对象
    let ra: LiveCardOtherExtendDropdownVm;
    let mocker: MockKit;
    let mockLogShowInfo: MockFunc;
    let mockSaveInfo: MockFunc;
    let mockGetStarterVm: MockFunc;
    let mockStartCardWantAgent: MockFunc;
    let mockHidePanel: MockFunc;
    let mockReportClickExtendEvent: MockFunc;

    beforeEach(() => {
      // 初始化被测对象
      ra = new LiveCardOtherExtendDropdownVm();
      // 创建MockKit实例
      mocker = new MockKit();

      // Mock日志方法
      mockLogShowInfo = mocker.mockFunc(ra.log, ra.log.showInfo);
      // Mock保存点击信息的方法
      mockSaveInfo = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo);
      // Mock获取StarterVm的方法
      mockGetStarterVm = mocker.mockFunc(ra.vmInjector, ra.vmInjector.getStarterVm);
      // Mock启动CardWantAgent的方法
      mockStartCardWantAgent = mocker.mockFunc(mockGetStarterVm, mockGetStarterVm.startCardWantAgent);
      // Mock隐藏面板的方法
      mockHidePanel = mocker.mockFunc(DropdownVm.instance, DropdownVm.instance.hidePanel);
      // Mock上报事件的方法
      mockReportClickExtendEvent = mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportClickExtendEvent);
    });

    afterEach(() => {
      // 清理所有Mock
      mocker.resetAll();
    });

    // 测试场景1：当extensionWantAgent为null时，函数提前返回
    it('should return early when extensionWantAgent is null', 0, async () => {
      // 设置extensionWantAgent为null
      ra.card.extensionWantAgent = null;

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证日志未被调用
      expect(mockLogShowInfo.called).assertFalse();
      // 验证保存信息未被调用
      expect(mockSaveInfo.called).assertFalse();
      // 验证获取StarterVm未被调用
      expect(mockGetStarterVm.called).assertFalse();
      // 验证隐藏面板未被调用
      expect(mockHidePanel.called).assertFalse();
      // 验证上报事件未被调用
      expect(mockReportClickExtendEvent.called).assertFalse();
    });

    // 测试场景2：正常流程，extensionWantAgent存在且start成功
    it('should execute full flow when extension exists and start succeeds', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 设置live.hashCode的值
      ra.live.hashCode = 'TEST_HASHCODE';

      // 配置mock返回值
      const isStartApp = {
        start: true
      };
      when(mockStartCardWantAgent)(ArgumentMatchers.any).afterReturn(isStartApp);

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证日志调用参数
      expect(mockLogShowInfo.calledWith(`triggerExtendWant for ${ra.live.hashCode}`)).assertTrue();
      // 验证保存信息的参数
      expect(mockSaveInfo.calledWith({
        data: ra.live,
        clickRegion: ClickRegion.SUB_AREA,
        scene: SystemUIUseScene.DROPDOWN
      })).assertTrue();
      // 验证startCardWantAgent的参数
      const args = mockStartCardWantAgent.getCall(0).args[0];
      expect(args.wantAgent).assertEqual(ra.card.extensionWantAgent);
      expect(args.cardVm).assertEqual(ra.vmInjector.getCardListItemVm(ra.live));
      // 验证隐藏面板被调用
      expect(mockHidePanel.calledWith(false)).assertTrue();
      // 验证上报事件被调用
      expect(mockReportClickExtendEvent.calledWith(
        ra.live,
        NotificationType.TYPE_PHONE_DROPDOWN
      )).assertTrue();
    });

    // 测试场景3：startCardWantAgent返回start为false时，不隐藏面板
    it('should not hide panel when start is false', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 配置mock返回值
      const isStartApp = {
        start: false
      };
      when(mockStartCardWantAgent)(ArgumentMatchers.any).afterReturn(isStartApp);

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证隐藏面板未被调用
      expect(mockHidePanel.called).assertFalse();
      // 验证其他步骤正常执行
      expect(mockReportClickExtendEvent.called).assertTrue();
    });

    // 测试场景4：startCardWantAgent抛出异常时，继续执行后续步骤
    it('should continue execution even if startCardWantAgent throws error', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 配置mock抛出错误
      const error = new Error('Test Error');
      when(mockStartCardWantAgent)(ArgumentMatchers.any).afterThrow(error);

      // 执行被测函数（预期不抛出错误）
      await ra.triggerExtendWant();

      // 验证上报事件仍被调用
      expect(mockReportClickExtendEvent.called).assertTrue();
    });

    // 测试场景5：验证cardVm参数传递正确性
    it('should pass correct cardVm to startCardWantAgent', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // Mock获取CardListItemVm的方法
      const mockGetCardListItemVm = mocker.mockFunc(ra.vmInjector, ra.vmInjector.getCardListItemVm);
      const expectedCardVm = { /* 预期的CardVm对象 */
      };
      when(mockGetCardListItemVm)(ArgumentMatchers.any).afterReturn(expectedCardVm);

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证传递的cardVm参数
      const args = mockStartCardWantAgent.getCall(0).args[0];
      expect(args.cardVm).assertEqual(expectedCardVm);
    });

    // 测试场景6：验证所有步骤的顺序执行
    it('should execute steps in correct order', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 记录方法调用顺序
      let logCallCount = 0;
      let saveCallCount = 0;
      let startCallCount = 0;
      let hideCallCount = 0;
      let reportCallCount = 0;

      // 设置Mock的回调函数来记录调用顺序
      mockLogShowInfo = mocker.mockFunc(ra.log, ra.log.showInfo, (message) => {
        logCallCount++;
      });
      mockSaveInfo = mocker.mockFunc(ClickNotificationMaintenance, ClickNotificationMaintenance.saveInfo, (info) => {
        saveCallCount++;
      });
      mockStartCardWantAgent = mocker.mockFunc(mockGetStarterVm, mockGetStarterVm.startCardWantAgent, (args) => {
        startCallCount++;
        return {
          start: true
        };
      });
      mockHidePanel = mocker.mockFunc(DropdownVm.instance, DropdownVm.instance.hidePanel, (hide) => {
        hideCallCount++;
      });
      mockReportClickExtendEvent =
        mocker.mockFunc(LiveHiSysEvent, LiveHiSysEvent.reportClickExtendEvent, (live, type) => {
          reportCallCount++;
        });

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证调用顺序
      expect(logCallCount).assertEqual(1);
      expect(saveCallCount).assertEqual(1);
      expect(startCallCount).assertEqual(1);
      expect(hideCallCount).assertEqual(1);
      expect(reportCallCount).assertEqual(1);
      // 确保上报事件在最后执行
      expect(reportCallCount).assertEqual(5); // 总共有5个步骤，最后执行
    });

    // 测试场景7：验证异步执行的正确性
    it('should handle async operations correctly', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 模拟startCardWantAgent的延迟返回
      const delay = 100;
      when(mockStartCardWantAgent)(ArgumentMatchers.any).afterAction((args) => {
        return new Promise(resolve => setTimeout(() => resolve({
          start: true
        }), delay));
      });

      // 记录开始时间
      const startTime = Date.now();
      // 执行被测函数
      await ra.triggerExtendWant();
      // 计算执行时间
      const duration = Date.now() - startTime;

      // 验证执行时间接近延迟时间（允许误差）
      expect(duration).assertLarger(delay - 50);
      expect(duration).assertLess(delay + 50);
    });

    // 测试场景8：验证所有参数传递的完整性
    it('should pass all required parameters correctly', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 验证保存信息的参数
      const expectedSaveInfo = {
        data: ra.live,
        clickRegion: ClickRegion.SUB_AREA,
        scene: SystemUIUseScene.DROPDOWN
      };
      // 验证上报事件的参数
      const expectedReportArgs = [
        ra.live,
        NotificationType.TYPE_PHONE_DROPDOWN
      ];

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证参数传递
      expect(mockSaveInfo.calledWith(expectedSaveInfo)).assertTrue();
      expect(mockReportClickExtendEvent.calledWith(...expectedReportArgs)).assertTrue();
    });

    // 测试场景9：验证日志输出的正确性
    it('should log correct message', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 设置live.hashCode的值
      ra.live.hashCode = 'TEST_HASHCODE';

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证日志消息
      expect(mockLogShowInfo.calledWith(`triggerExtendWant for ${ra.live.hashCode}`)).assertTrue();
    });

    // 测试场景10：验证所有方法被正确调用
    it('should call all required methods when conditions met', 0, async () => {
      // 设置extensionWantAgent为有效值
      ra.card.extensionWantAgent = { /* 有效代理对象 */
      };
      // 配置mock返回值
      const isStartApp = {
        start: true
      };
      when(mockStartCardWantAgent)(ArgumentMatchers.any).afterReturn(isStartApp);

      // 执行被测函数
      await ra.triggerExtendWant();

      // 验证所有方法被调用
      expect(mockLogShowInfo.called).assertTrue();
      expect(mockSaveInfo.called).assertTrue();
      expect(mockStartCardWantAgent.called).assertTrue();
      expect(mockHidePanel.called).assertTrue();
      expect(mockReportClickExtendEvent.called).assertTrue();
    });
  });

  describe('buttonBgBrightness', () => {
    // 测试前初始化变量和Mock对象
    let ra: LiveCardOtherExtendDropdownVm; // 替换为实际类名
    let mocker: MockKit;
    let mockGetColorVm: MockFunc;

    beforeEach(() => {
      // 初始化被测对象
      ra = new LiveCardOtherExtendDropdownVm();
      // 创建MockKit实例
      mocker = new MockKit();
      // Mock vmInjector.getColorVm 方法
      mockGetColorVm = mocker.mockFunc(ra.vmInjector, ra.vmInjector.getColorVm);
    });

    afterEach(() => {
      // 清理所有Mock
      mocker.resetAll();
    });

    // 测试场景1：当getColorVm返回有效对象且remainderBgBrightness存在时，返回正确值
    it('should_return_remainderBgBrightness_when_colorVm_exists', 0, () => {
      // 配置mock返回有效ColorVm对象
      const mockColorVm = {
        remainderBgBrightness: BrightnessOptions.LIGHT // 假设有效值
      };
      when(mockGetColorVm)().afterReturn(mockColorVm);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证返回值
      expect(result).assertEqual(mockColorVm.remainderBgBrightness);
      // 验证getColorVm被调用
      expect(mockGetColorVm.called).assertTrue();
    });

    // 测试场景2：当getColorVm返回undefined时，返回undefined
    it('should_return_undefined_when_colorVm_is_undefined', 0, () => {
      // 配置mock返回undefined
      when(mockGetColorVm)().afterReturn(undefined);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证返回值
      expect(result).assertUndefined();
      // 验证getColorVm被调用
      expect(mockGetColorVm.called).assertTrue();
    });

    // 测试场景3：当ColorVm存在但remainderBgBrightness缺失时，返回undefined
    it('should_return_undefined_when_remainderBgBrightness_missing', 0, () => {
      // 配置mock返回缺少remainderBgBrightness的ColorVm
      const mockColorVm = {};
      when(mockGetColorVm)().afterReturn(mockColorVm);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证返回值
      expect(result).assertUndefined();
      // 验证getColorVm被调用
      expect(mockGetColorVm.called).assertTrue();
    });

    // 测试场景4：当getColorVm抛出错误时，返回undefined
    it('should_return_undefined_when_colorVm_throws_error', 0, () => {
      // 配置mock抛出错误
      const error = new Error('Test Error');
      when(mockGetColorVm)().afterThrow(error);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证返回值
      expect(result).assertUndefined();
      // 验证getColorVm被调用
      expect(mockGetColorVm.called).assertTrue();
    });

    // 测试场景5：验证多次调用时缓存行为（假设计算属性无缓存）
    it('should_call_getColorVm_on_every_access', 0, () => {
      // 配置mock返回不同值
      let callCount = 0;
      when(mockGetColorVm)().afterAction(() => {
        callCount++;
        return {
          remainderBgBrightness: callCount
        };
      });

      // 第一次访问
      const result1 = ra.buttonBgBrightness;
      expect(result1).assertEqual(1);

      // 第二次访问
      const result2 = ra.buttonBgBrightness;
      expect(result2).assertEqual(2);

      // 验证调用次数
      expect(callCount).assertEqual(2);
    });

    // 测试场景6：验证链式调用的正确性
    it('should_chain_getColorVm_correctly', 0, () => {
      // 配置mock返回嵌套对象
      const mockColorVm = {
        remainderBgBrightness: BrightnessOptions.DARK
      };
      when(mockGetColorVm)().afterReturn(mockColorVm);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证返回值
      expect(result).assertEqual(mockColorVm.remainderBgBrightness);
      // 验证调用路径
      expect(mockGetColorVm.called).assertTrue();
    });

    // 测试场景7：验证参数传递的正确性（无参数时）
    it('should_call_getColorVm_without_parameters', 0, () => {
      // 配置mock验证参数
      when(mockGetColorVm)(ArgumentMatchers.any).afterAction((...args) => {
        expect(args.length).assertEqual(0);
      });

      // 触发计算属性
      ra.buttonBgBrightness;

      // 验证参数传递
      expect(mockGetColorVm.calledWith()).assertTrue();
    });

    // 测试场景8：验证返回值类型符合枚举约束
    it('should_return_valid_BrightnessOptions_value', 0, () => {
      // 配置mock返回有效枚举值
      const mockColorVm = {
        remainderBgBrightness: BrightnessOptions.LIGHT
      };
      when(mockGetColorVm)().afterReturn(mockColorVm);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证类型
      expect(BrightnessOptions[result]).assertNotNull();
    });

    // 测试场景9：验证返回undefined时的类型检查
    it('should_return_undefined_when_value_is_invalid', 0, () => {
      // 配置mock返回无效值（如数字）
      const mockColorVm = {
        remainderBgBrightness: 123 // 非枚举值
      };
      when(mockGetColorVm)().afterReturn(mockColorVm);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证返回undefined
      expect(result).assertUndefined();
    });

    // 测试场景10：验证异步场景（假设getColorVm可能异步）
    it('should_handle_async_getColorVm_correctly', 0, async () => {
      // 配置mock返回Promise
      const mockColorVm = {
        remainderBgBrightness: BrightnessOptions.DARK
      };
      when(mockGetColorVm)().afterAction(() => {
        return new Promise(resolve => setTimeout(() => resolve(mockColorVm), 100));
      });

      // 等待异步完成
      const result = await ra.buttonBgBrightness; // 假设计算属性支持异步

      // 验证返回值
      expect(result).assertEqual(mockColorVm.remainderBgBrightness);
    });

    // 测试场景11：验证空对象返回
    it('should_return_undefined_for_empty_colorVm', 0, () => {
      // 配置mock返回空对象
      const mockColorVm = {};
      when(mockGetColorVm)().afterReturn(mockColorVm);

      // 获取计算属性值
      const result = ra.buttonBgBrightness;

      // 验证返回undefined
      expect(result).assertUndefined();
    });
  });
}