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
import { ILiveCardSystemVm } from '../../../../main/ets/live/interface/ILiveCardSystemVm';
import { LiveItemBaseVm } from '../../../../main/ets/live/vm/LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveCardSystemModel } from '../../../../main/ets/live/model/LiveCardSystemModel';
import { PhoneSimStatus, SysTypeCode } from '../../../../main/ets/liveview/common/LiveConstants';
import { LiveStyle } from '../../../../main/ets/live/constants/LiveStyle';
import { AccessibilityVm } from '../../../../main/ets/vm/AccessibilityVm';
import { ResourceVm } from '../../../../main/ets/vm/ResourceVm';
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
  ArgumentMatchers,
  DEFAULT
} from '@ohos/hypium';
import { LiveCardSystemVm } from '../../../../main/ets/live/vm/LiveCardSystemVm';

export default function LiveCardSystemVmTest() {
  describe('simIcon_testSuite', () => {
    let vm: LiveCardSystemVm;
    let mockLogHelper: any;
    let mockVmInjector: any;
    let mockTimerVm: any;
    let mockAccessibilityVm: any;
    let mockResourceVm: any;
    beforeEach(() => {
      // 模拟依赖项
      mockLogHelper = {
        showInfo: jasmine.createSpy('showInfo'),
        showWarn: jasmine.createSpy('showWarn'),
      };

      mockVmInjector = {
        getTimerVm: () => mockTimerVm,
        getColorVm: () => ({
          liveFontFgBrightness: { brightness: 0.8 },
        }),
        getAccessibilityVm: () => mockAccessibilityVm,
        getResourceVm: () => mockResourceVm,
      };

      mockTimerVm = {
        getTimerText: jasmine.createSpy('getTimerText').and.returnValue('10:00'),
        getTimerAccessibilityText: jasmine.createSpy('getTimerAccessibilityText').and.returnValue('10 minutes remaining'),
      };

      mockAccessibilityVm = {
        isEnabled: true,
      };

      mockResourceVm = {
        instance: {
          getFontSize: (key: string) => 16,
          getFontScaleHeightDiff: (base: number) => 8,
          DEFAULT_MAX_SCALE: 1.5,
        },
      };

      // 初始化 VM
      vm = new LiveCardSystemVm();
      vm.log = mockLogHelper;
      vm.vmInjector = mockVmInjector;
      vm.live = {
        card: mockLiveCardModel,
        typeCode: SysTypeCode.BIG_TEXT_TIMER,
        hashCode: 'TEST_HASH',
      } as any;
    });
    afterEach(() => {

    });


    it('should_return_undefined_when_sim1_and_sim2_are_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let simIcon: Resource | undefined = livecardsystemvm.simIcon;
      expect(simIcon).assertUndefined();
    });

    it('should_return_sim1_when_simIconStatus_is_STATUS_SIM_1', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.simIconStatus = PhoneSimStatus.STATUS_SIM_1;
      livecardsystemvm.card = liveCardSystemModel;
      let simIcon: Resource | undefined = livecardsystemvm.simIcon;
      expect(simIcon).assertEqual(LiveStyle.SIM1_SYMBOL_RESOURCE);
    });

    it('should_return_sim2_when_simIconStatus_is_STATUS_SIM_2', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
      livecardsystemvm.card = liveCardSystemModel;
      let simIcon: Resource | undefined = livecardsystemvm.simIcon;
      expect(simIcon).assertEqual(LiveStyle.SIM2_SYMBOL_RESOURCE);
    });

    it('should_return_undefined_when_simIconStatus_is_neither_STATUS_SIM_1_nor_STATUS_SIM_2', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let liveCardSystemModel: LiveCardSystemModel = new LiveCardSystemModel();
      liveCardSystemModel.simIconStatus = 3; // some other status
      livecardsystemvm.card = liveCardSystemModel;
      let simIcon: Resource | undefined = livecardsystemvm.simIcon;
      expect(simIcon).assertUndefined();
    });
  });

  it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
    let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    const result = livecardsystemvm.getTitleAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
  });

  it('should_return_timer_accessibility_text_when_timer_is_enabled_and_in_title', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
    let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.timer = {
      minutes: 10, seconds: 5
    };
    card.isTimerInTitle = true;
    livecardsystemvm.card = card;
    let vmInjector: LiveItemBaseVm = new LiveItemBaseVm();
    let mockfunc2: Function = mocker.mockFunc(vmInjector, vmInjector.getTimerVm);
    when(mockfunc2)(ArgumentMatchers.any).afterReturn({
      getTimerAccessibilityText: (timer) => {
        return "Timer Text";
      }
    });
    livecardsystemvm.vmInjector = vmInjector;
    const result = livecardsystemvm.getTitleAccessibilityText();
    expect(result).assertEqual("Timer Text");
    mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
    mocker.ignoreMock(vmInjector, vmInjector.getTimerVm);
  });

  it('should_return_title_when_timer_is_not_enabled_or_not_in_title', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
    let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.timer = undefined;
    card.isTimerInTitle = false;
    card.title = "Test Title";
    livecardsystemvm.card = card;
    const result = livecardsystemvm.getTitleAccessibilityText();
    expect(result).assertEqual("Test Title");
    mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
  });

  it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
    let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
  });

  it('should_return_content_when_timer_is_in_title', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = true;
    card.content = 'Test Content';
    let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('Test Content');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
  });

  it('should_return_timer_accessibility_text_when_timer_is_not_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = 'Test Timer';
    card.content = 'Test Content';
    let liveVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
    let mockfuncCard: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    let mockfuncLiveVmInjector: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getTimerVm);
    when(mockfuncCard)(ArgumentMatchers.any).afterReturn(card);
    when(mockfuncLiveVmInjector)(ArgumentMatchers.any).afterReturn(liveVmInjector);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('Mock Timer Accessibility Text');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    mocker.ignoreMock(liveVmInjector, liveVmInjector.getTimerVm);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = null;
    card.content = 'Test Content';
    let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('Test Content');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0,() => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.card).toBe(mockLiveCardModel);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.title).toBe('10:00');
    expect(mockTimerVm.getTimerText).toHaveBeenCalledWith(mockLiveCardModel.timer);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.title).toBe(mockLiveCardModel.title);
  });
  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.title).toBe('10:00');
    expect(mockTimerVm.getTimerText).toHaveBeenCalledWith(mockLiveCardModel.timer);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.title).toBe(mockLiveCardModel.title);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.title).toBe('10:00');
    expect(mockTimerVm.getTimerText).toHaveBeenCalledWith(mockLiveCardModel.timer);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.title).toBe(mockLiveCardModel.title);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.title).toBe('10:00');
    expect(mockTimerVm.getTimerText).toHaveBeenCalledWith(mockLiveCardModel.timer);
  });

  it('should_return_content_when_timer_is_null', 0,() => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.title).toBe(mockLiveCardModel.title);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.title).toBe('10:00');
    expect(mockTimerVm.getTimerText).toHaveBeenCalledWith(mockLiveCardModel.timer);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.title).toBe(mockLiveCardModel.title);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.title).toBe('10:00');
    expect(mockTimerVm.getTimerText).toHaveBeenCalledWith(mockLiveCardModel.timer);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.title).toBe(mockLiveCardModel.title);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.title).toBe('10:00');
    expect(mockTimerVm.getTimerText).toHaveBeenCalledWith(mockLiveCardModel.timer);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.title).toBe(mockLiveCardModel.title);
  });

  it('should_return_content_when_timer_is_null', 0,() => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0,() => {
    expect(vm.isBigTitle).toBeTrue();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.live.typeCode = SysTypeCode.DEFAULT;
    expect(vm.isBigTitle).toBeFalse();
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });
  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', 0, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });
  it('should_return_content_when_timer_is_null', 0, () => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });
  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });

  it('should_return_content_when_timer_is_null', DEFAULT,() => {
    expect(vm.titleFontSize).toBe($r('sys.float.ohos_id_text_size_headline6'));
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    vm.isBigTitle = false;
    expect(vm.titleLineHeight).toBe(16);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.text).toBe(mockLiveCardModel.content);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.text).toBe('10:00');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.simIcon).toBe(LiveStyle.SIM1_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
    expect(vm.simIcon).toBe(LiveStyle.SIM2_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
    expect(vm.simIcon).toBeUndefined();
  });
  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.text).toBe(mockLiveCardModel.content);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.text).toBe('10:00');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.simIcon).toBe(LiveStyle.SIM1_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
    expect(vm.simIcon).toBe(LiveStyle.SIM2_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
    expect(vm.simIcon).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.text).toBe(mockLiveCardModel.content);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.text).toBe('10:00');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.simIcon).toBe(LiveStyle.SIM1_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
    expect(vm.simIcon).toBe(LiveStyle.SIM2_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
    expect(vm.simIcon).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.text).toBe(mockLiveCardModel.content);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.text).toBe('10:00');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.simIcon).toBe(LiveStyle.SIM1_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
    expect(vm.simIcon).toBe(LiveStyle.SIM2_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
    expect(vm.simIcon).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.text).toBe(mockLiveCardModel.content);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.text).toBe('10:00');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.simIcon).toBe(LiveStyle.SIM1_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
    expect(vm.simIcon).toBe(LiveStyle.SIM2_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
    expect(vm.simIcon).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.text).toBe(mockLiveCardModel.content);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.text).toBe('10:00');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.simIcon).toBe(LiveStyle.SIM1_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
    expect(vm.simIcon).toBe(LiveStyle.SIM2_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
    expect(vm.simIcon).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.text).toBe(mockLiveCardModel.content);
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.text).toBe('10:00');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.simIcon).toBe(LiveStyle.SIM1_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_SIM_2;
    expect(vm.simIcon).toBe(LiveStyle.SIM2_SYMBOL_RESOURCE);
    mockLiveCardModel.simIconStatus = PhoneSimStatus.STATUS_UNKNOWN;
    expect(vm.simIcon).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getTitleAccessibilityText()).toBe('10 minutes remaining');
    mockAccessibilityVm.isEnabled = false;
    expect(vm.getTitleAccessibilityText()).toBe('');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getContentAccessibilityText()).toBe(mockLiveCardModel.content);
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.getContentAccessibilityText()).toBe('10 minutes remaining');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getTitleAccessibilityText()).toBe('10 minutes remaining');
    mockAccessibilityVm.isEnabled = false;
    expect(vm.getTitleAccessibilityText()).toBe('');
  });

  it('should_return_content_when_timer_is_null', DEFAULT,() => {
    expect(vm.getContentAccessibilityText()).toBe(mockLiveCardModel.content);
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.getContentAccessibilityText()).toBe('10 minutes remaining');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getTitleAccessibilityText()).toBe('10 minutes remaining');
    mockAccessibilityVm.isEnabled = false;
    expect(vm.getTitleAccessibilityText()).toBe('');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getContentAccessibilityText()).toBe(mockLiveCardModel.content);
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.getContentAccessibilityText()).toBe('10 minutes remaining');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getTitleAccessibilityText()).toBe('10 minutes remaining');
    mockAccessibilityVm.isEnabled = false;
    expect(vm.getTitleAccessibilityText()).toBe('');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getContentAccessibilityText()).toBe(mockLiveCardModel.content);
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.getContentAccessibilityText()).toBe('10 minutes remaining');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getTitleAccessibilityText()).toBe('10 minutes remaining');
    mockAccessibilityVm.isEnabled = false;
    expect(vm.getTitleAccessibilityText()).toBe('');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getContentAccessibilityText()).toBe(mockLiveCardModel.content);
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.getContentAccessibilityText()).toBe('10 minutes remaining');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getTitleAccessibilityText()).toBe('10 minutes remaining');
    mockAccessibilityVm.isEnabled = false;
    expect(vm.getTitleAccessibilityText()).toBe('');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    expect(vm.getContentAccessibilityText()).toBe(mockLiveCardModel.content);
    mockLiveCardModel.isTimerInTitle = false;
    expect(vm.getContentAccessibilityText()).toBe('10 minutes remaining');
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    vm.live.card = undefined as any;
    expect(vm.card).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    LiveStyle.SIM1_SYMBOL_RESOURCE = undefined;
    expect(vm.simIcon).toBeUndefined();
  });

  it('should_return_content_when_timer_is_null', DEFAULT, () => {
    vm.vmInjector.getResourceVm = () => undefined;
    expect(vm.getCardHeight()).toBe(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);
  });

  describe('getTitleAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(false);
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
    });

    it('should_return_timer_accessibility_text_when_timer_is_enabled_and_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = '123456';
      card.isTimerInTitle = true;
      let mockfunc2: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.vmInjector);
      let timervm: LiveItemBaseVm = new LiveItemBaseVm();
      when(mockfunc2().getTimerVm)().afterReturn(timervm);
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('Timer Accessibility Text');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.vmInjector);
    });

    it('should_return_title_when_timer_is_not_enabled_or_not_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.title = 'Test Title';
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('Test Title');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
    });

    it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(false);
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
    });

    it('should_return_timer_accessibility_text_when_timer_is_enabled_and_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = '123456';
      card.isTimerInTitle = true;
      let mockfunc2: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.vmInjector);
      let timervm: LiveItemBaseVm = new LiveItemBaseVm();
      when(mockfunc2().getTimerVm)().afterReturn(timervm);
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('Timer Accessibility Text');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.vmInjector);
    });

    it('should_return_title_when_timer_is_not_enabled_or_not_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.title = 'Test Title';
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('Test Title');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
    });

    it('should_return_empty_string_when_card_is_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      // 模拟card为null的情况
      let mockfunc2: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
      when(mockfunc2)().afterReturn(null);
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    });

    it('should_return_title_when_timer_exists_but_not_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = '123456';
      card.isTimerInTitle = false;
      card.title = 'Test Title';
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('Test Title');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
    });

    it('should_return_title_when_timer_is_null_but_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = null;
      card.isTimerInTitle = true;
      card.title = 'Test Title';
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('Test Title');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
    });

    it('should_return_empty_string_when_getTimerVm_returns_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      when(mockfunc)().afterReturn(true);
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.timer = '123456';
      card.isTimerInTitle = true;
      let mockfunc2: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.vmInjector);
      when(mockfunc2().getTimerVm)().afterReturn(null);
      const result = livecardsystemvm.getTitleAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(AccessibilityVm.instance, AccessibilityVm.instance.isEnabled);
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.vmInjector);
    });
  });

  describe('getContentAccessibilityText_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
      let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
    });

    it('should_return_content_when_timer_is_in_title', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = true;
      card.content = "Test Content";
      let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual("Test Content");
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    });

    it('should_return_timer_accessibility_text_when_timer_is_not_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = false;
      card.timer = { id: 1, startTime: 1000, endTime: 2000 };
      let liveVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfuncCard: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
      let mockfuncInjector: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getTimerVm);
      when(mockfuncCard)(ArgumentMatchers.any).afterReturn(card);
      when(mockfuncInjector)(ArgumentMatchers.any).afterReturn({ getTimerAccessibilityText: (timer) => "Timer Accessible Text" });
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual("Timer Accessible Text");
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
      mocker.ignoreMock(liveVmInjector, liveVmInjector.getTimerVm);
    });

    it('should_return_content_when_timer_is_null_and_content_is_not_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = false;
      card.timer = null;
      card.content = "Test Content";
      let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual("Test Content");
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    });

    it('should_return_empty_string_when_timer_is_null_and_content_is_null', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let card: LiveCardSystemModel = new LiveCardSystemModel();
      card.isTimerInTitle = false;
      card.timer = null;
      card.content = null;
      let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
      const result = livecardsystemvm.getContentAccessibilityText();
      expect(result).assertEqual('');
      mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    });
  });

  it('should_return_empty_string_when_accessibility_is_disabled', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let accessibilityVm: AccessibilityVm = AccessibilityVm.instance;
    let mockfunc: Function = mocker.mockFunc(accessibilityVm, accessibilityVm.isEnabled);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(false);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(accessibilityVm, accessibilityVm.isEnabled);
  });

  it('should_return_content_when_timer_is_in_title', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = true;
    card.content = "Test Content";
    let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual("Test Content");
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
  });

  it('should_return_timer_accessibility_text_when_timer_is_not_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = { id: 1, startTime: 1000, endTime: 2000 };
    let liveVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
    let mockfuncCard: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    let mockfuncInjector: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getTimerVm);
    when(mockfuncCard)(ArgumentMatchers.any).afterReturn(card);
    when(mockfuncInjector)(ArgumentMatchers.any).afterReturn({ getTimerAccessibilityText: (timer) => "Timer Accessible Text" });
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual("Timer Accessible Text");
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    mocker.ignoreMock(liveVmInjector, liveVmInjector.getTimerVm);
  });

  it('should_return_content_when_timer_is_null_and_content_is_not_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = null;
    card.content = "Test Content";
    let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual("Test Content");
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
  });

  it('should_return_empty_string_when_timer_is_null_and_content_is_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = null;
    card.content = null;
    let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
  });

  it('should_return_empty_string_when_card_is_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
  });

  it('should_return_empty_string_when_content_is_undefined', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = null;
    card.content = undefined;
    let mockfunc: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    when(mockfunc)(ArgumentMatchers.any).afterReturn(card);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
  });

  it('should_return_empty_string_when_getTimerVm_returns_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = { id: 1, startTime: 1000, endTime: 2000 };
    let liveVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
    let mockfuncCard: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    let mockfuncInjector: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getTimerVm);
    when(mockfuncCard)(ArgumentMatchers.any).afterReturn(card);
    when(mockfuncInjector)(ArgumentMatchers.any).afterReturn(null);
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    mocker.ignoreMock(liveVmInjector, liveVmInjector.getTimerVm);
  });

  it('should_return_empty_string_when_getTimerAccessibilityText_returns_null', 0, () => {
    let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
    let mocker: MockKit = new MockKit();
    let card: LiveCardSystemModel = new LiveCardSystemModel();
    card.isTimerInTitle = false;
    card.timer = { id: 1, startTime: 1000, endTime: 2000 };
    let liveVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
    let mockfuncCard: Function = mocker.mockFunc(livecardsystemvm, livecardsystemvm.card);
    let mockfuncInjector: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getTimerVm);
    when(mockfuncCard)(ArgumentMatchers.any).afterReturn(card);
    when(mockfuncInjector)(ArgumentMatchers.any).afterReturn({ getTimerAccessibilityText: (timer) => null });
    const result = livecardsystemvm.getContentAccessibilityText();
    expect(result).assertEqual('');
    mocker.ignoreMock(livecardsystemvm, livecardsystemvm.card);
    mocker.ignoreMock(liveVmInjector, liveVmInjector.getTimerVm);
  });

  describe('getCardHeight_testSuite', () => {
    it('should_return_correct_height_when_getFontScaleHeightDiff_returns_positive_value', 0, () => {
      const livecardsystemvm = new LiveCardSystemVm();
      const mocker = new MockKit();
      const resourceVm = ResourceVm.instance;
      const mockfunc = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(10);

      const result = livecardsystemvm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + 10);

      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });

    it('should_return_correct_height_when_getFontScaleHeightDiff_returns_zero', 0, () => {
      const livecardsystemvm = new LiveCardSystemVm();
      const mocker = new MockKit();
      const resourceVm = ResourceVm.instance;
      const mockfunc = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(0);

      const result = livecardsystemvm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT);

      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });

    it('should_return_correct_height_when_getFontScaleHeightDiff_returns_negative_value', 0, () => {
      const livecardsystemvm = new LiveCardSystemVm();
      const mocker = new MockKit();
      const resourceVm = ResourceVm.instance;
      const mockfunc = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(-5);

      const result = livecardsystemvm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT - 5);

      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });

    it('should_return_correct_height_when_getFontScaleHeightDiff_returns_max_scale', 0, () => {
      const livecardsystemvm = new LiveCardSystemVm();
      const mocker = new MockKit();
      const resourceVm = ResourceVm.instance;
      const mockfunc = mocker.mockFunc(resourceVm, resourceVm.getFontScaleHeightDiff);
      when(mockfunc)(ArgumentMatchers.anyNumber).afterReturn(ResourceVm.DEFAULT_MAX_SCALE);

      const result = livecardsystemvm.getCardHeight();
      expect(result).assertEqual(LiveStyle.LIVE_SYSTEM_CARD_HEIGHT + ResourceVm.DEFAULT_MAX_SCALE);

      mocker.ignoreMock(resourceVm, resourceVm.getFontScaleHeightDiff);
    });
  });

  describe('getTextForegroundBrightness_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_undefined_when_liveFontFgBrightness_is_undefined', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let baseVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfunc: Function = mocker.mockFunc(baseVmInjector, baseVmInjector.getColorVm);
      when(mockfunc)([]).afterReturn(undefined);
      livecardsystemvm.vmInjector = baseVmInjector;
      const result = livecardsystemvm.getTextForegroundBrightness();
      expect(result).assertUndefined();
      mocker.ignoreMock(baseVmInjector, baseVmInjector.getColorVm);
    });

    it('should_return_BrightnessOptions_when_liveFontFgBrightness_is_defined', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let baseVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfunc: Function = mocker.mockFunc(baseVmInjector, baseVmInjector.getColorVm);
      when(mockfunc)([]).afterReturn({ liveFontFgBrightness: LiveStyle.LIVE_CARD_TEXT_FONT_COLOR });
      livecardsystemvm.vmInjector = baseVmInjector;
      const result = livecardsystemvm.getTextForegroundBrightness();
      expect(result).assertInstanceOf(BrightnessOptions);
      mocker.ignoreMock(baseVmInjector, baseVmInjector.getColorVm);
    });

    it('should_return_undefined_when_liveFontFgBrightness_is_undefined', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let baseVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfunc: Function = mocker.mockFunc(baseVmInjector, baseVmInjector.getColorVm);
      when(mockfunc)([]).afterReturn(undefined);
      livecardsystemvm.vmInjector = baseVmInjector;
      const result = livecardsystemvm.getTextForegroundBrightness();
      expect(result).assertUndefined();
      mocker.ignoreMock(baseVmInjector, baseVmInjector.getColorVm);
    });

    it('should_return_BrightnessOptions_when_liveFontFgBrightness_is_defined', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let baseVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfunc: Function = mocker.mockFunc(baseVmInjector, baseVmInjector.getColorVm);
      when(mockfunc)([]).afterReturn({ liveFontFgBrightness: LiveStyle.LIVE_CARD_TEXT_FONT_COLOR });
      livecardsystemvm.vmInjector = baseVmInjector;
      const result = livecardsystemvm.getTextForegroundBrightness();
      expect(result).assertInstanceOf(BrightnessOptions);
      mocker.ignoreMock(baseVmInjector, baseVmInjector.getColorVm);
    });

    it('should_return_undefined_when_liveFontFgBrightness_is_not_present', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let baseVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfunc: Function = mocker.mockFunc(baseVmInjector, baseVmInjector.getColorVm);
      when(mockfunc)([]).afterReturn({});
      livecardsystemvm.vmInjector = baseVmInjector;
      const result = livecardsystemvm.getTextForegroundBrightness();
      expect(result).assertUndefined();
      mocker.ignoreMock(baseVmInjector, baseVmInjector.getColorVm);
    });

    it('should_throw_error_when_getColorVm_throws_error', 0, () => {
      let livecardsystemvm: ILiveCardSystemVm = new LiveCardSystemVm();
      let mocker: MockKit = new MockKit();
      let baseVmInjector: LiveItemBaseVm = new LiveItemBaseVm();
      let mockfunc: Function = mocker.mockFunc(baseVmInjector, baseVmInjector.getColorVm);
      when(mockfunc)([]).afterThrow('Error occurred');
      livecardsystemvm.vmInjector = baseVmInjector;
      expect(() => livecardsystemvm.getTextForegroundBrightness()).assertThrowError('Error occurred');
      mocker.ignoreMock(baseVmInjector, baseVmInjector.getColorVm);
    });

  });

}